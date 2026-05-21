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
      final value = pb.Value()..string = 'ICE';
      final raw = pb.Datapoint()..value = value;
      final dp = Datapoint(raw: raw, path: kRoadSurfaceCondition);
      expect(dp.stringValue, equals('ICE'));
      expect(dp.type, DatapointType.string);
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
  });
}
