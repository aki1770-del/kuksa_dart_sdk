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
import 'dart:io';

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

  // The cases below are the only proof this package's resilience works, and
  // every one of them skips when no broker is reachable — at which point
  // `dart test` prints "All tests passed!" for a file that verified nothing.
  // An absent verdict reads exactly like a pass, so it must not be allowed to.
  //
  // Set KUKSA_TEST_BROKER=required (CI, release prep) to make the absence
  // fail instead of skip:
  //   docker run -d -p 55555:55555 \
  //     ghcr.io/eclipse-kuksa/kuksa-databroker:0.7.1 --insecure
  test('the broker-backed cases actually ran', () {
    if (brokerUp) return;
    final required =
        Platform.environment['KUKSA_TEST_BROKER'] == 'required';
    if (required) {
      fail('KUKSA_TEST_BROKER=required but $noBroker. Every resilience case '
          'in this file was skipped; this run proves nothing about whether '
          'one absent signal still blinds a consumer.');
    }
    markTestSkipped('$noBroker — the resilience cases in this file were NOT '
        'verified by this run. Set KUKSA_TEST_BROKER=required to make that '
        'a failure.');
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

  group('subscribeAvailable hands back the verdict with the stream', () {
    test('a partial vehicle streams what it has AND names what it lacks',
        () async {
      if (!brokerUp) return markTestSkipped(noBroker);
      final sub = await client.subscribeAvailable([present, absent]);
      expect(sub.available, [present]);
      expect(sub.notOnThisVehicle, [absent]);
      expect(sub.isDegraded, isTrue);
      expect(sub.isComplete, isFalse);
      expect(sub.toString(), contains(absent),
          reason: 'the absent leaf is named wherever this is logged');
      expect(await firstEvent(sub.updates), startsWith('data:'));
    });

    test('a complete vehicle reports complete', () async {
      if (!brokerUp) return markTestSkipped(noBroker);
      final sub = await client.subscribeAvailable([present, knownButUnwritten]);
      expect(sub.isComplete, isTrue);
      expect(sub.notOnThisVehicle, isEmpty);
      expect(sub.available, [present, knownButUnwritten],
          reason: 'known-but-never-written is present, not absent');
    });

    test('a vehicle that has none of them throws, naming every one', () async {
      if (!brokerUp) return markTestSkipped(noBroker);
      await expectLater(
        client.subscribeAvailable([absent]),
        throwsA(isA<UnknownSignalPathsException>()
            .having((e) => e.toString(), 'message', contains(absent))),
        reason: 'a car that cannot measure the road at all is a fact the '
            'driver is owed, not an empty stream',
      );
    });

    test('asking for nothing is a caller mistake, not a vehicle fact',
        () async {
      if (!brokerUp) return markTestSkipped(noBroker);
      // README's filter recipe can produce an empty list. Reaching the broker
      // with it answers INVALID_ARGUMENT ("No valid id or path specified"),
      // which reads as "you passed something wrong" and says nothing about
      // the vehicle. Kept apart from UnknownSignalPathsException on purpose.
      await expectLater(
          client.subscribeAvailable(const []), throwsA(isA<ArgumentError>()));
    });

    test('an unreachable broker is not read as "every signal absent"',
        () async {
      final dead = KuksaClient(host: 'localhost', port: 55599);
      await dead.connect();
      await expectLater(
        dead.subscribeAvailable([present]),
        throwsA(isNot(isA<UnknownSignalPathsException>())),
        reason: 'a bus that is down has not told us the signal is missing',
      );
      await dead.dispose();
    });
  });

  // The published list is a promise: subscribe(kSnowSafetySignals) works.
  // kuksa.val.v2 is all-or-nothing, so ONE leaf that a stock databroker does
  // not carry breaks that promise for every consumer of the list — silently,
  // at the only moment it matters.
  //
  // This is not hypothetical. `kRoadSurfaceCondition` is declared by this
  // package and is NOT in VSS release 6.0 (measured 2026-09-11 against
  // databroker 0.7.1, which ships vss_release_6.0.json): we vendor our spec
  // from COVESA `master` (tool/vss_sync.sh), our consumers run releases.
  // Adding it to the list would fail this test — which is the point.
  test('every published snow-safety signal exists on a stock databroker',
      () async {
    if (!brokerUp) return markTestSkipped(noBroker);
    expect(await client.missingSignals(kSnowSafetySignals), isEmpty,
        reason: 'kSnowSafetySignals is subscribed all-or-nothing; a leaf a '
            'stock broker lacks takes the other nine down with it');
  });

  test('UnknownSignalPathsException names the signals', () {
    expect(
      const UnknownSignalPathsException(['A.B']).toString(),
      allOf(contains('knows none'), contains('A.B')),
    );
  });
}
