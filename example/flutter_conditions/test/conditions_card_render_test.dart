// SPDX-License-Identifier: Apache-2.0
//
// Render-capture test: pump the conditions card in three fed states and write
// a real PNG of each via RepaintBoundary.toImage, so a reviewer can go and SEE
// the actual rendered output (not merely "the test passed").

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_conditions/conditions_card.dart';
import 'package:flutter_conditions/driving_conditions.dart';

const String _captureDir = '_capture';

// The eight-byte PNG signature.
const List<int> _pngMagic = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

// Best-effort: load real fonts so the captured PNGs show readable text and
// icons instead of the test harness's `.notdef` boxes. Portable — discovers
// the Flutter material-fonts dir from FLUTTER_ROOT or the test executable, and
// silently no-ops if not found (the test still passes; text just renders as
// boxes, and content is asserted separately via find.text).
String? _materialFontsDir() {
  final sep = Platform.pathSeparator;
  String? root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) {
    final exe = Platform.resolvedExecutable;
    final marker = '${sep}bin${sep}cache$sep';
    final idx = exe.indexOf(marker);
    if (idx != -1) root = exe.substring(0, idx);
  }
  if (root == null) return null;
  final dir = Directory('$root/bin/cache/artifacts/material_fonts');
  return dir.existsSync() ? dir.path : null;
}

Future<void> _tryLoadFont(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(
      ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.lengthInBytes),
    ));
  await loader.load();
}

Future<void> _loadRealFonts() async {
  final dir = _materialFontsDir();
  if (dir == null) return;
  await _tryLoadFont('Roboto', '$dir/Roboto-Regular.ttf');
  await _tryLoadFont('MaterialIcons', '$dir/MaterialIcons-Regular.otf');
}

Future<({int width, int height, String path, int bytes})> _capture(
  WidgetTester tester,
  String name,
  DrivingConditions conditions,
  ConditionsConnection connection,
) async {
  tester.view.physicalSize = const Size(900, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final boundaryKey = GlobalKey();
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: boundaryKey,
            child: SizedBox(
              width: 400,
              child: DrivingConditionsCard(
                conditions: conditions,
                connection: connection,
                onReconnect: () {},
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  late Uint8List pngBytes;
  late int width;
  late int height;

  // toImage / toByteData are async and must run outside the fake-async zone.
  await tester.runAsync(() async {
    final boundary =
        boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    width = image.width;
    height = image.height;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData!.buffer.asUint8List();
    image.dispose();
  });

  final file = File('$_captureDir/$name.png');
  file.writeAsBytesSync(pngBytes);
  final absPath = file.absolute.path;

  // ignore: avoid_print
  print('RENDER_PNG $name ${width}x$height bytes=${pngBytes.length} $absPath');

  return (width: width, height: height, path: absPath, bytes: pngBytes.length);
}

void main() {
  setUpAll(() async {
    Directory(_captureDir).createSync(recursive: true);
    await _loadRealFonts();
  });

  testWidgets('UNKNOWN (no data) renders and captures a real PNG',
      (tester) async {
    final r = await _capture(
      tester,
      'conditions_unknown',
      const DrivingConditions(), // no signals → UNKNOWN, never fabricated
      ConditionsConnection.connecting,
    );

    expect(find.text('UNKNOWN'), findsOneWidget);
    expect(find.text('No vehicle signals received yet.'), findsOneWidget);

    final bytes = File(r.path).readAsBytesSync();
    expect(bytes.length, greaterThan(1000));
    expect(bytes.sublist(0, 8), _pngMagic); // it is genuinely a PNG
    expect(r.width, greaterThan(0));
    expect(r.height, greaterThan(0));
  });

  testWidgets('ICE / severe renders and captures a real PNG', (tester) async {
    final r = await _capture(
      tester,
      'conditions_ice',
      const DrivingConditions(
        roadFriction: 0.18,
        tcsEngaged: true,
        absEngaged: true,
        airTempC: -6.0,
        wiperIntensity: 5,
        speedKmh: 42,
      ),
      ConditionsConnection.live,
    );

    expect(find.text('ICE'), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);

    final bytes = File(r.path).readAsBytesSync();
    expect(bytes.sublist(0, 8), _pngMagic);
    expect(bytes.length, greaterThan(1000));
  });

  testWidgets('DRY / clear renders and captures a real PNG', (tester) async {
    final r = await _capture(
      tester,
      'conditions_dry',
      const DrivingConditions(
        roadFriction: 0.92,
        tcsEngaged: false,
        absEngaged: false,
        airTempC: 12.0,
        wiperIntensity: 0,
        rainIntensity: 0,
        speedKmh: 60,
      ),
      ConditionsConnection.live,
    );

    expect(find.text('DRY'), findsOneWidget);

    final bytes = File(r.path).readAsBytesSync();
    expect(bytes.sublist(0, 8), _pngMagic);
    expect(bytes.length, greaterThan(1000));
  });

  testWidgets('error state renders the Reconnect affordance + captures a PNG',
      (tester) async {
    final r = await _capture(
      tester,
      'conditions_signal_lost',
      const DrivingConditions(), // degraded to UNKNOWN on error
      ConditionsConnection.error,
    );

    expect(find.text('UNKNOWN'), findsOneWidget);
    expect(find.text('Signal lost'), findsOneWidget);
    expect(find.text('Reconnect'), findsOneWidget);

    final bytes = File(r.path).readAsBytesSync();
    expect(bytes.sublist(0, 8), _pngMagic);
  });
}
