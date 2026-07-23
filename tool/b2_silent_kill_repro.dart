// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

// ignore_for_file: dangling_library_doc_comments
/// B2 proof — the all-or-nothing subscribe trap, against a REAL databroker.
///
///   FAIL : subscribe([present, absent])                      -> whole stream dies
///   PASS : subscribe([present, absent], skipUnknownPaths:true)-> present streams,
///                                                               absent reported
///
/// Run with a databroker on localhost:55555.
import 'dart:async';

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

const present = 'Vehicle.Speed';
const known = 'Vehicle.Exterior.Humidity'; // in VSS 6.0, never written
const absent = 'Vehicle.Exterior.NoSuchLeafForB2';

Future<String> attempt(
  KuksaClient c,
  List<String> paths, {
  bool skipUnknownPaths = false,
  void Function(List<String>)? onUnknownPaths,
}) async {
  final done = Completer<String>();
  late StreamSubscription sub;
  sub = c
      .subscribe(paths,
          skipUnknownPaths: skipUnknownPaths, onUnknownPaths: onUnknownPaths)
      .listen(
        (u) =>
            done.isCompleted ? null : done.complete('DATA ${u.keys.toList()}'),
        onError: (e) => done.isCompleted
            ? null
            : done.complete('ERROR ${e.runtimeType}: $e'),
        onDone: () => done.isCompleted
            ? null
            : done.complete('CLOSED SILENTLY (no data)'),
      );
  final r = await done.future.timeout(const Duration(seconds: 6),
      onTimeout: () => 'ALIVE (no emission in 6s, stream not errored)');
  await sub.cancel();
  return r;
}

Future<void> main() async {
  final c = KuksaClient(host: 'localhost', port: 55555);
  await c.connect();
  var failures = 0;
  void check(String name, String got, bool ok) {
    if (!ok) failures++;
    print('${ok ? "OK  " : "BAD "} $name -> $got');
  }

  print('=== FAIL CASE (today\'s behaviour, unchanged) ===');
  final baseline = await attempt(c, [present]);
  check('[present] alone streams', baseline, baseline.startsWith('DATA'));
  final trap = await attempt(c, [present, absent]);
  check('[present, absent] kills the whole stream', trap,
      trap.contains('NOT_FOUND'));

  print('=== PASS CASE (skipUnknownPaths) ===');
  var reported = <String>[];
  final hardened = await attempt(c, [present, known, absent],
      skipUnknownPaths: true, onUnknownPaths: (u) => reported = u);
  check('[present, known, absent] still streams', hardened,
      hardened.startsWith('DATA'));
  check('absent path is REPORTED, not dropped silently', '$reported',
      reported.length == 1 && reported.single == absent);

  print('=== NO-SILENT-EMPTY CASE ===');
  final allAbsent = await attempt(c, [absent], skipUnknownPaths: true);
  check('all-absent errors loudly, never closes empty', allAbsent,
      allAbsent.contains('UnknownSignalPathsException'));

  print('=== TRANSIENT-FAILURE CASE (must NOT be read as "absent") ===');
  final dead = KuksaClient(host: 'localhost', port: 55599);
  await dead.connect();
  var res = 'no throw';
  try {
    await dead.resolveKnownPaths([present]);
  } catch (e) {
    res = '${e.runtimeType}';
  }
  check('unreachable broker rethrows, does not drop the path', res,
      res != 'no throw');
  await dead.dispose();

  await c.dispose();
  print(failures == 0 ? '\nALL CHECKS PASSED' : '\n$failures CHECK(S) FAILED');
}
