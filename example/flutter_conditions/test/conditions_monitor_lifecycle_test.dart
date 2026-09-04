// SPDX-License-Identifier: Apache-2.0
//
// Lifecycle tests for ConditionsMonitor against a fake source — no databroker.
//
// These pin down the behaviour an always-on vehicle UI needs and that naive
// Flutter examples tend to get wrong ("subscription stops working after a
// while"): subscribe on init, degrade to an HONEST UNKNOWN on error/done,
// reconnect on a fresh stream, and ALWAYS cancel on dispose.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

import 'package:flutter_conditions/conditions_monitor.dart';
import 'package:flutter_conditions/conditions_source.dart';
import 'package:flutter_conditions/driving_conditions.dart';

/// A source whose stream we drive by hand, recording each opened controller so
/// we can assert subscribe / cancel behaviour.
class FakeConditionsSource implements ConditionsSource {
  final List<StreamController<DrivingConditions>> controllers = [];
  bool disposed = false;

  StreamController<DrivingConditions> get latest => controllers.last;

  @override
  Stream<DrivingConditions> conditions() {
    final controller = StreamController<DrivingConditions>();
    controllers.add(controller);
    return controller.stream;
  }

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}

Widget _host(ConditionsSource source) =>
    MaterialApp(home: Scaffold(body: ConditionsMonitor(source: source)));

const _ice = DrivingConditions(
  roadFriction: 18.0, // percent — VSS 0-100; a real ESC on black ice
  tcsEngaged: true,
  airTempC: -6.0,
  wiperIntensity: 5,
);

void main() {
  testWidgets('subscribes on init and shows UNKNOWN until first data',
      (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));

    expect(source.controllers.length, 1);
    expect(source.latest.hasListener, isTrue);
    expect(find.text('UNKNOWN'), findsOneWidget);
    expect(find.text('Connecting…'), findsOneWidget);
  });

  testWidgets('a received assessment drives the card (live)', (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));

    source.latest.add(_ice);
    await tester.pump();

    expect(find.text('ICE'), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
  });

  testWidgets(
      'stream error degrades to UNKNOWN and never keeps a stale reading',
      (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));

    source.latest.add(_ice);
    await tester.pump();
    expect(find.text('ICE'), findsOneWidget);

    source.latest.addError(StateError('gRPC stream broke after a while'));
    await tester.pump(); // deliver the error event
    await tester.pump(); // rebuild after onError's setState

    expect(find.text('ICE'), findsNothing); // no stale reading
    expect(find.text('UNKNOWN'), findsOneWidget); // honest degrade
    expect(find.text('Signal lost'), findsOneWidget);
    expect(find.text('Reconnect'), findsOneWidget);
  });

  testWidgets('a vehicle that lacks every needed signal is told so, BY NAME',
      (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));

    // What KuksaConditionsSource throws when missingSignals() leaves nothing
    // to subscribe to: the typed SDK error, carrying the paths.
    source.latest.addError(const UnknownSignalPathsException([
      'Vehicle.ADAS.ESC.RoadFriction.MostProbable',
      'Vehicle.ADAS.TCS.IsEngaged',
    ]));
    await tester.pump();
    await tester.pump();

    expect(find.text('Signal lost'), findsOneWidget);
    expect(find.textContaining('reports none of the signals'), findsOneWidget);
    expect(find.textContaining('Vehicle.ADAS.TCS.IsEngaged'), findsOneWidget);
    expect(find.text('UNKNOWN'), findsOneWidget);
  });

  testWidgets('a generic stream error carries no invented detail',
      (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));

    source.latest.addError(StateError('gRPC stream broke after a while'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Signal lost'), findsOneWidget);
    expect(find.textContaining('reports none of the signals'), findsNothing);
  });

  testWidgets(
      'signals the vehicle lacks are listed as such, never as a reading',
      (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));

    source.latest.add(const DrivingConditions(
      roadFriction: 87.0, // percent — a positive good-grip measurement
      notOnThisVehicle: ['Vehicle.Exterior.AirTemperature'],
    ));
    await tester.pump();

    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Not on this vehicle'), findsOneWidget);
    expect(
        find.textContaining('Vehicle.Exterior.AirTemperature'), findsOneWidget);
    expect(find.textContaining('Air temp'), findsNothing,
        reason: 'no reading is shown for a signal the vehicle does not have');
  });

  testWidgets('with every signal present, nothing is listed as missing',
      (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));

    source.latest.add(_ice);
    await tester.pump();

    expect(find.text('Not on this vehicle'), findsNothing);
  });

  testWidgets('stream done (server ended) degrades and offers reconnect',
      (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));

    await source.latest.close(); // onDone
    await tester.pump();

    expect(find.text('UNKNOWN'), findsOneWidget);
    expect(find.text('Stream ended'), findsOneWidget);
    expect(find.text('Reconnect'), findsOneWidget);
  });

  testWidgets('reconnect cancels the old subscription and subscribes fresh',
      (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));

    source.latest.addError(StateError('boom'));
    await tester.pump();

    final firstController = source.controllers.first;
    expect(firstController.hasListener, isTrue);

    await tester.tap(find.text('Reconnect'));
    await tester.pump();

    expect(source.controllers.length, 2); // a fresh stream was opened
    expect(source.latest.hasListener, isTrue);
    expect(firstController.hasListener, isFalse); // old one cancelled
    expect(find.text('Connecting…'), findsOneWidget);

    // The fresh stream works.
    source.latest.add(_ice);
    await tester.pump();
    expect(find.text('ICE'), findsOneWidget);
  });

  testWidgets('dispose cancels the subscription and disposes the source',
      (tester) async {
    final source = FakeConditionsSource();
    await tester.pumpWidget(_host(source));
    expect(source.latest.hasListener, isTrue);

    // Unmount the monitor.
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));

    expect(source.controllers.first.hasListener, isFalse); // cancelled
    expect(source.disposed, isTrue); // transport released
  });
}
