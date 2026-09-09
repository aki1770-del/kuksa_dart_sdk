// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0
//
// FDD A/B, 2026-09-09. One real databroker, frozen mid-subscription. Two
// clients: one as 0.2.8 could be built, one with keepalive. Which one is told?
import 'dart:async';
import 'dart:io';
import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

Future<String> watch(KuksaClient c, String label, {Duration? stallTimeout}) async {
  final done = Completer<String>();
  final t0 = DateTime.now();
  final sub = c
      .subscribe(['Vehicle.Speed'], stallTimeout: stallTimeout)
      .listen(
    (u) => stdout.writeln('  [$label] data ${u.keys.join(",")}'),
    onError: (Object e) => done.isCompleted
        ? null
        : done.complete('TOLD after '
            '${DateTime.now().difference(t0).inMilliseconds} ms — '
            '${e.runtimeType}'),
    onDone: () => done.isCompleted
        ? null
        : done.complete('TOLD — stream closed'),
  );
  unawaited(done.future.whenComplete(sub.cancel));
  return done.future.timeout(const Duration(seconds: 30),
      onTimeout: () => 'NOT TOLD — still "subscribed" after 30 s, no data, '
          'no error, no end');
}

Future<void> main() async {
  final plain = KuksaClient(host: 'localhost', port: 55555);
  final tuned = KuksaClient(
    host: 'localhost',
    port: 55555,
    keepAlive: const ClientKeepAliveOptions(
      pingInterval: Duration(seconds: 3),
      timeout: Duration(seconds: 2),
      permitWithoutCalls: true,
    ),
  );
  final stalled = KuksaClient(host: 'localhost', port: 55555);
  await plain.connect();
  await tuned.connect();
  await stalled.connect();
  stdout.writeln('broker: ${(await plain.getServerInfo()).version}');

  final a = watch(plain, 'A/no-keepalive');
  final b = watch(tuned, 'B/keepalive-3s');
  final c = watch(stalled, 'C/stallTimeout-5s',
      stallTimeout: const Duration(seconds: 5));
  await Future<void>.delayed(const Duration(seconds: 2));

  stdout.writeln('>>> FREEZING the broker (socket stays open, no FIN, no RST)');
  final r = await Process.run('docker', ['pause', 'fdd_db']);
  stdout.writeln('>>> docker pause exit=${r.exitCode}');
  final t = DateTime.now();

  final results = await Future.wait([a, b, c]);
  final secs = DateTime.now().difference(t).inMilliseconds / 1000;
  stdout.writeln('\nAFTER ${secs}s FROZEN:');
  stdout.writeln('  A  no keepalive (all a 0.2.8 caller could do): ${results[0]}');
  stdout.writeln('  B  keepAlive ping 3s / timeout 2s          : ${results[1]}');
  stdout.writeln('  C  stallTimeout 5s (0.2.9)                 : ${results[2]}');
  await Process.run('docker', ['unpause', 'fdd_db']);
  exit(0);
}
