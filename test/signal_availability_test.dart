// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// Decide before you subscribe — and when you did not, be told which path.
///
/// `kuksa.val.v2` Subscribe/GetValues are all-or-nothing by design
/// (eclipse-kuksa/kuksa-databroker#230), and the broker's `NOT_FOUND` says only
/// "Path not found". These cases prove, against a REAL databroker, that
/// `hasSignal(s)`/`missingSignals` let an app decide first, that `expand`
/// turns a pattern into the leaves this broker has, and that a subscribe with
/// one unknown path fails with that path NAMED and no data delivered.
///
/// A mock cannot prove any of it: the contract under test is the broker's.
/// Skipped when no databroker is reachable on localhost:55555, unless
/// KUKSA_TEST_REQUIRE_BROKER=1 (CI), in which case a skip is a failure.
@TestOn('vm')
library;

import 'dart:async';
import 'dart:io';

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
import 'package:test/test.dart';

const present = kVehicleSpeed;
const knownButUnwritten = 'Vehicle.Exterior.Humidity';
const absent1 = 'Vehicle.Exterior.NoSuchLeafForAvailabilityTest';
const absent2 = 'Vehicle.ADAS.NoSuchBranchForAvailabilityTest.Leaf';
const noBroker = 'no databroker reachable on localhost:55555';

final bool brokerRequired =
    Platform.environment['KUKSA_TEST_REQUIRE_BROKER'] == '1';

void unavailable(String why) {
  if (brokerRequired) {
    fail('KUKSA_TEST_REQUIRE_BROKER=1 but $why. These cases are the controls '
        'for the availability helpers; they must run, not be skipped.');
  }
  markTestSkipped(why);
}

/// The first event on [stream]: `data:<paths>`, `error:<toString>`, `closed`
/// or `alive`.
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

/// The first error object on [stream]; fails if data or done arrives first.
Future<Object> firstError(Stream<Map<String, Datapoint>> stream) {
  final done = Completer<Object>();
  late StreamSubscription sub;
  sub = stream.listen(
    (u) => done.isCompleted
        ? null
        : done.completeError(StateError('data arrived first: ${u.keys}')),
    onError: (Object e) => done.isCompleted ? null : done.complete(e),
    onDone: () => done.isCompleted
        ? null
        : done.completeError(StateError('closed without an error')),
  );
  return done.future
      .timeout(const Duration(seconds: 8))
      .whenComplete(sub.cancel);
}

int segments(String path) => path.split('.').length;

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

  group('hasSignal / hasSignals / missingSignals: decide before subscribing',
      () {
    test('a known signal is present whether or not it was ever written',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await client.hasSignal(present), isTrue);
      expect(await client.hasSignal(knownButUnwritten), isTrue,
          reason: 'known-but-unwritten is not absent');
    });

    test('an absent leaf is missing', () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await client.hasSignal(absent1), isFalse);
    });

    test('hasSignals is false on ONE absent path among known ones', () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await client.hasSignals([present, knownButUnwritten]), isTrue);
      expect(await client.hasSignals([present, knownButUnwritten, absent1]),
          isFalse,
          reason: 'the negative control: one absent path is enough');
    });

    test('missingSignals names exactly the absent ones, in request order',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      final missing = await client
          .missingSignals([present, absent1, knownButUnwritten, absent2]);
      expect(missing.toList(), [absent1, absent2]);
      expect(
          await client.missingSignals([present, knownButUnwritten]), isEmpty);
    });

    test('a duplicated known path is still all-present', () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await client.hasSignals([present, present]), isTrue);
    });

    test('a wildcard or a branch is not a signal', () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await client.hasSignal('Vehicle.ADAS.*'), isFalse);
      expect(await client.missingSignals(['Vehicle.ADAS']), {'Vehicle.ADAS'},
          reason: 'a branch has metadata below it but is not subscribable');
    });

    test('an unreachable broker is not read as "signal absent"', () async {
      final dead = KuksaClient(host: 'localhost', port: 55599);
      await dead.connect();
      await expectLater(dead.hasSignal(present), throwsA(anything),
          reason: 'false here would tell an app to run degraded when the bus '
              'is down');
      await dead.dispose();
    });
  });

  group('expand: a pattern becomes the leaf paths this databroker has', () {
    test('"**" walks a branch, sorted', () async {
      if (!brokerUp) return unavailable(noBroker);
      final esc = await client.expand('Vehicle.ADAS.ESC.**');
      expect(esc, contains(kRoadFrictionMostProbable));
      expect(esc.every((p) => p.startsWith('Vehicle.ADAS.ESC.')), isTrue);
      expect(esc, orderedEquals([...esc]..sort()));
    });

    test('a literal branch expands to every leaf under it', () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await client.expand('Vehicle.ADAS.ESC'),
          await client.expand('Vehicle.ADAS.ESC.**'));
    });

    test('a literal leaf expands to itself', () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await client.expand(present), [present]);
    });

    test('"*" is exactly one segment', () async {
      if (!brokerUp) return unavailable(noBroker);
      final direct = await client.expand('Vehicle.ADAS.*');
      final all = await client.expand('Vehicle.ADAS.**');
      expect(direct, isNotEmpty);
      expect(direct.every((p) => segments(p) == 3), isTrue);
      expect(all.toSet().containsAll(direct), isTrue);
      expect(all.length, greaterThan(direct.length));
    });

    test('a leading "**" searches the whole tree', () async {
      if (!brokerUp) return unavailable(noBroker);
      final tyres = await client.expand('**.Tire.Pressure');
      expect(tyres, contains(kTirePressureFrontLeft));
      expect(tyres.every((p) => p.endsWith('.Tire.Pressure')), isTrue);
      expect(tyres, await client.expand('Vehicle.**.Tire.Pressure'));
    });

    test('entryType filters, and the three types partition the branch',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      final all = await client.expand('Vehicle.ADAS.**');
      final sensors = await client.expand('Vehicle.ADAS.**',
          entryType: VssEntryType.sensor);
      final actuators = await client.expand('Vehicle.ADAS.**',
          entryType: VssEntryType.actuator);
      final attributes = await client.expand('Vehicle.ADAS.**',
          entryType: VssEntryType.attribute);
      expect(sensors, isNotEmpty);
      expect(actuators, isNotEmpty);
      expect({...sensors, ...actuators, ...attributes}, all.toSet());
      expect(sensors.toSet().intersection(actuators.toSet()), isEmpty);
      expect(sensors.toSet().intersection(attributes.toSet()), isEmpty);
      expect(actuators.toSet().intersection(attributes.toSet()), isEmpty);
    });

    test('a pattern matching nothing under an existing branch is empty',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(
          await client.expand('Vehicle.ADAS.**.NoSuchLeafForAvailabilityTest'),
          isEmpty,
          reason: 'the negative control');
    });

    test('a branch this databroker does not have is empty, not an error',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await client.expand('Vehicle.NoSuchBranchForAvailabilityTest.**'),
          isEmpty);
      expect(await client.expand('Vehicle.NoSuchBranchForAvailabilityTest'),
          isEmpty);
    });

    test('the expansion subscribes', () async {
      if (!brokerUp) return unavailable(noBroker);
      final leaves = await client.expand('Vehicle.ADAS.ESC');
      expect(await firstEvent(client.subscribe(leaves)), startsWith('data:'));
    });

    test('an unsupported pattern is refused at the call', () async {
      await expectLater(client.expand('Vehicle.**.*.*'), throwsArgumentError);
      await expectLater(client.expand('Vehicle.ADAS.Is*'), throwsArgumentError);
    });
  });

  group('an unknown path in subscribe / getValues is NAMED, not swallowed', () {
    test('subscribe: the error names the one absent path among known ones',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      final requested = [present, absent1, knownButUnwritten];
      final e = await firstError(client.subscribe(requested));
      expect(e, isA<UnknownSignalPathsException>());
      e as UnknownSignalPathsException;
      expect(e.paths, [absent1]);
      expect(e.requested, requested);
      expect(e.allUnknown, isFalse);
      expect(e.brokerMessage, 'Path not found',
          reason: 'what the broker itself says: no path in it');
      expect(
          '$e',
          allOf(contains(absent1), contains('1 of the 3'),
              contains('NOT_FOUND'), isNot(contains(knownButUnwritten))));
    });

    test('subscribe: two absent paths are both named', () async {
      if (!brokerUp) return unavailable(noBroker);
      final e = await firstError(client.subscribe([absent1, present, absent2]))
          as UnknownSignalPathsException;
      expect(e.paths, [absent1, absent2]);
    });

    test('subscribe: no data is delivered before the error', () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await firstEvent(client.subscribe([present, absent1])),
          startsWith('error:'));
    });

    test(
        'subscribe: await for rethrows it, so the default consumption cannot '
        'miss it', () async {
      if (!brokerUp) return unavailable(noBroker);
      Future<void> consume() async {
        await for (final _ in client.subscribe([present, absent1])) {
          fail('data must not arrive');
        }
      }

      await expectLater(consume(), throwsA(isA<UnknownSignalPathsException>()));
      await expectLater(client.subscribe([present, absent1]).first,
          throwsA(isA<UnknownSignalPathsException>()));
    });

    test('subscribe: the known signals still stream on their own', () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(await firstEvent(client.subscribe([present, knownButUnwritten])),
          startsWith('data:'),
          reason: 'the positive control');
    });

    test('subscribe: a wildcard is refused by name, with the expand() hint',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      final e = await firstError(client.subscribe(['Vehicle.ADAS.*']))
          as UnknownSignalPathsException;
      expect(e.paths, ['Vehicle.ADAS.*']);
      expect('$e', contains('expand()'));
    });

    test('getValues: one absent path fails the whole call, naming it',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      await expectLater(
        client.getValues([present, absent1]),
        throwsA(isA<UnknownSignalPathsException>()
            .having((e) => e.paths, 'paths', [absent1]).having(
                (e) => e.requested, 'requested', [present, absent1])),
      );
    });

    test('getValues: a known-but-unwritten signal is a datapoint, not an error',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      final values = await client.getValues([present, knownButUnwritten]);
      expect(values.keys, [present, knownButUnwritten]);
      expect(values[knownButUnwritten]!.hasValue, isFalse);
    });

    test('getValue: an absent path is named', () async {
      if (!brokerUp) return unavailable(noBroker);
      await expectLater(
        client.getValue(absent1),
        throwsA(isA<UnknownSignalPathsException>()
            .having((e) => e.paths, 'paths', [absent1])),
      );
    });
  });

  group('UnknownSignalPathsException wording (no broker needed)', () {
    test('a partial miss counts, names, and says nothing was delivered', () {
      final e = UnknownSignalPathsException([absent1],
          requested: [present, absent1], brokerMessage: 'Path not found');
      expect(e.allUnknown, isFalse);
      expect(
          '$e',
          allOf(
              contains('1 of the 2'),
              contains(absent1),
              contains('NOT_FOUND'),
              contains('all-or-nothing'),
              contains('missingSignals()'),
              isNot(contains('expand()'))));
    });

    test('a wildcard earns the expand() hint', () {
      final e = UnknownSignalPathsException(['Vehicle.ADAS.*'],
          requested: ['Vehicle.ADAS.*']);
      expect(e.allUnknown, isTrue);
      expect('$e', allOf(contains('knows none'), contains('expand()')));
    });

    test('the 0.2.4 shape still reads as it did', () {
      expect(const UnknownSignalPathsException(['A.B']).allUnknown, isTrue);
      expect('${const UnknownSignalPathsException(['A.B'])}',
          allOf(contains('knows none'), contains('A.B')));
    });

    test('an undetermined culprit is said to be undetermined, never "none"',
        () {
      final e = UnknownSignalPathsException(const [],
          requested: [present, absent1], brokerMessage: 'Path not found');
      expect(
          '$e', allOf(contains('could not be determined'), contains(absent1)));
      expect('$e', isNot(contains('knows none')));
    });
  });
}
