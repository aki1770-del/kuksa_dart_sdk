// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
import 'package:test/test.dart';

import 'package:kuksa_dart_sdk/src/generated/kuksa/val/v2/types.pb.dart' as pb;

void main() {
  group('Datapoint', () {
    test('hasValue returns false for empty datapoint', () {
      final raw = pb.Datapoint();
      final dp = Datapoint(raw: raw, path: 'Vehicle.Speed');
      expect(dp.hasValue, isFalse);
      expect(dp.value, isNull);
      expect(dp.type, DatapointType.none);
    });

    test('floatValue returns correct value for float datapoint', () {
      final value = pb.Value()..float = 0.25;
      final raw = pb.Datapoint()..value = value;
      final dp = Datapoint(raw: raw, path: kRoadFrictionMostProbable);
      expect(dp.hasValue, isTrue);
      expect(dp.type, DatapointType.float);
      expect(dp.floatValue, closeTo(0.25, 0.001));
    });

    test('boolValue returns correct value for bool datapoint', () {
      final value = pb.Value()..bool_12 = true;
      final raw = pb.Datapoint()..value = value;
      final dp = Datapoint(raw: raw, path: kTcsIsEngaged);
      expect(dp.boolValue, isTrue);
      expect(dp.type, DatapointType.boolean);
    });

    test('stringValue returns correct value for string datapoint', () {
      // A signal VSS really does declare as `string`. This case used to be
      // written against kRoadSurfaceCondition, which VSS declares `uint8` —
      // so the suite taught the wrong contract for the one signal whose
      // contract was being got wrong on the wire. It could never fail on it:
      // the raw Datapoint is built here by hand, so the assertion only ever
      // restated what this file already believed.
      const roadIcingState = 'Vehicle.Safety.RoadIcingState';
      final value = pb.Value()..string = 'BLACK_ICE';
      final raw = pb.Datapoint()..value = value;
      final dp = Datapoint(raw: raw, path: roadIcingState);
      expect(dp.stringValue, equals('BLACK_ICE'));
      expect(dp.type, DatapointType.string);
    });

    test('a uint8 enum signal reads back through uint32Value, not stringValue',
        () {
      // What a databroker actually returns for Vehicle.Exterior.
      // RoadSurfaceCondition: 4 = ICE, in the uint32 field. See
      // test/publish_wire_type_test.dart for the same contract proven against
      // a real broker rather than a hand-built message.
      final value = pb.Value()..uint32 = 4;
      final raw = pb.Datapoint()..value = value;
      final dp = Datapoint(raw: raw, path: kRoadSurfaceCondition);
      expect(dp.type, DatapointType.uint32);
      expect(dp.uint32Value, 4);
      expect(dp.stringValue, isNull,
          reason: 'the signal is a uint8 enum, not a string');
      expect(dp.int32Value, isNull,
          reason: 'a uint8 arrives in the uint32 field, not int32');
    });

    test('floatValue returns null for non-float datapoint', () {
      final value = pb.Value()..bool_12 = false;
      final raw = pb.Datapoint()..value = value;
      final dp = Datapoint(raw: raw, path: kAbsIsEngaged);
      expect(dp.floatValue, isNull);
    });

    test('toString includes path and value', () {
      final value = pb.Value()..float = 0.8;
      final raw = pb.Datapoint()..value = value;
      final dp = Datapoint(raw: raw, path: kRoadFrictionMostProbable);
      expect(dp.toString(), contains(kRoadFrictionMostProbable));
    });
  });

  group('Signal path constants', () {
    test('kSnowSafetySignals contains expected paths', () {
      expect(kSnowSafetySignals, contains(kRoadFrictionMostProbable));
      expect(kSnowSafetySignals, contains(kTcsIsEngaged));
      expect(kSnowSafetySignals, contains(kAbsIsEngaged));
      expect(kSnowSafetySignals, contains(kAirTemperature));
      expect(kSnowSafetySignals.length, greaterThan(5));
    });

    test('all snow safety signal paths are VSS dot-notation', () {
      for (final path in kSnowSafetySignals) {
        expect(path, startsWith('Vehicle.'),
            reason: '$path should start with Vehicle.');
      }
    });

    test('kRoadSurfaceCondition is a valid VSS path', () {
      expect(kRoadSurfaceCondition,
          equals('Vehicle.Exterior.RoadSurfaceCondition'));
    });
  });

  group('KuksaClient constructor', () {
    test('default port is 55555', () {
      final client = KuksaClient(host: 'localhost');
      expect(client.port, equals(55555));
    });

    test('custom port is accepted', () {
      final client = KuksaClient(host: '192.168.1.10', port: 55556);
      expect(client.port, equals(55556));
    });

    test('jwtToken defaults to null', () {
      final client = KuksaClient(host: 'localhost');
      expect(client.jwtToken, isNull);
    });

    test('throws StateError if getValue called before connect', () async {
      final client = KuksaClient(host: 'localhost');
      expect(
        () async => await client.getValue(kVehicleSpeed),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError if publishValue called before connect', () async {
      final client = KuksaClient(host: 'localhost');
      expect(
        () async => await client.publishValue(kVehicleSpeed, 100.34),
        throwsA(isA<StateError>()),
      );
    });

    test('publishValue rejects unsupported Dart value type', () {
      final client = KuksaClient(host: 'localhost');
      // Refused before any network call, so the caller is told what is wrong
      // with the VALUE rather than that the client is not connected.
      expect(
        () => client.publishValue(kVehicleSpeed, DateTime.now()),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('publishTyped needs no connection to reject an unwritable value', () {
      final client = KuksaClient(host: 'localhost');
      expect(
        () =>
            client.publishTyped(kRoadSurfaceCondition, VssDataType.uint8, 300),
        throwsA(isA<VssTypeMismatch>()),
      );
    });
  });
}
