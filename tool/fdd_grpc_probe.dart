// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0
//
// FDD probe, 2026-09-09: how does a live subscription END when the broker
// goes away? onDone (silent) or onError (loud)? Measured, not assumed.
import 'dart:async';
import 'dart:io';
import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

Future<void> main(List<String> args) async {
  final port = int.parse(args.isEmpty ? '55555' : args[0]);
  final client = KuksaClient(host: 'localhost', port: port);
  await client.connect();
  stdout.writeln('PROBE: connected to localhost:$port');
  final info = await client.getServerInfo();
  stdout.writeln('PROBE: broker ${info.name} ${info.version}');

  var events = 0;
  final ended = Completer<String>();
  final sub = client.subscribe(['Vehicle.Speed']).listen(
    (u) { events++; stdout.writeln('PROBE: data #$events ${u.keys.join(",")}'); },
    onError: (e) {
      if (!ended.isCompleted) ended.complete('onError: ${e.runtimeType}: $e');
    },
    onDone: () {
      if (!ended.isCompleted) ended.complete('onDone (SILENT — no error)');
    },
  );

  // Let the first emission land.
  await Future.delayed(const Duration(seconds: 2));
  stdout.writeln('PROBE: killing the broker now (events so far: $events)');
  final how = args.length > 1 ? args[1] : 'stop';
  final r = await Process.run('docker', [how, 'fdd_db']);
  stdout.writeln('PROBE: docker $how exit=${r.exitCode}');

  final outcome = await ended.future
      .timeout(const Duration(seconds: 25), onTimeout: () => 'STILL OPEN after 25s — NOTHING was delivered and NOTHING ended it');
  stdout.writeln('PROBE RESULT [$how]: $outcome');
  await sub.cancel();
  await client.dispose();
  exit(0);
}
