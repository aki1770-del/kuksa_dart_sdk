// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// One absent signal must not end the whole subscription.
///
/// A vehicle that lacks one VSS leaf must not blind a consumer to the five it
/// has. These cases run against a REAL databroker (the trap lives in the
/// broker's all-or-nothing `Subscribe`, so a mock cannot prove the fix); they
/// are skipped when none is reachable on localhost:55555.
@TestOn('vm')
library;

import 'dart:async';

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
import 'package:test/test.dart';

const present = 'Vehicle.Speed';
const knownButUnwritten = 'Vehicle.Exterior.Humidity';
const absent = 'Vehicle.Exterior.NoSuchLeafForResilienceTest';
const noBroker = 'no databroker reachable on localhost:55555';

Future<String> firstEvent(Stream<Map<String, Datapoint>> stream) {
  final done = Completer<String>();
  late StreamSubscription sub;
  sub = stream.listen(
    (u) => done.isCompleted ? null : done.complete('data:${u.keys.join(",")}'),
    onError: (e) => done.isCompleted ? null : done.complete('error:$e'),
    onDone: () => done.isCompleted ? null : done.complete('closed'),
  );
  return done.future
      .timeout(const Duration(seconds: 8), onTimeout: () => 'alive')
      .whenComplete(sub.cancel);
}

void main() {
  late KuksaClient client;
  var brokerUp = false;

  setUpAll(() async {
    client = KuksaClient(host: 'localhost', port: 55555);
    try {
      await client.connect();
      await client.getServerInfo().timeout(const Duration(seconds: 3));
      brokerUp = true;
    } catch (_) {
      brokerUp = false;
    }
  });

  tearDownAll(() async => client.dispose());

  group('a missing signal never blinds the rest', () {
    test('one absent path fails the entire subscription, and is NAMED',
        () async {
      if (!brokerUp) return markTestSkipped(noBroker);
      expect(
          await firstEvent(client.subscribe([present])), startsWith('data:'));
      expect(
          await firstEvent(client.subscribe([present, absent])),
          allOf(contains('UnknownSignalPathsException'), contains(absent),
              contains('NOT_FOUND')),
          reason: 'the broker says only "Path not found"; this package '
              'resolves and names the path');
    }, skip: null);

    test('skipUnknownPaths: the known signals still stream', () async {
      if (!brokerUp) return markTestSkipped(noBroker);
      var reported = <String>[];
      final got = await firstEvent(client.subscribe(
        [present, knownButUnwritten, absent],
        skipUnknownPaths: true,
        onUnknownPaths: (u) => reported = u,
      ));
      expect(got, startsWith('data:'));
      expect(reported, [absent],
          reason: 'the absent path is reported, never silently dropped');
    });

    test('a known-but-never-written signal is NOT treated as absent', () async {
      if (!brokerUp) return markTestSkipped(noBroker);
      expect(await client.resolveKnownPaths([knownButUnwritten]),
          [knownButUnwritten]);
    });

    test('all-absent errors loudly rather than closing empty', () async {
      if (!brokerUp) return markTestSkipped(noBroker);
      expect(
        await firstEvent(client.subscribe([absent], skipUnknownPaths: true)),
        contains('UnknownSignalPathsException'),
      );
    });

    test('an unreachable broker is not read as "signal absent"', () async {
      final dead = KuksaClient(host: 'localhost', port: 55599);
      await dead.connect();
      await expectLater(dead.resolveKnownPaths([present]), throwsA(anything));
      await dead.dispose();
    });
  });

  test('UnknownSignalPathsException names the signals', () {
    expect(
      const UnknownSignalPathsException(['A.B']).toString(),
      allOf(contains('knows none'), contains('A.B')),
    );
  });
}
