// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// The wire type a publish puts on the bus must follow the SIGNAL's declared
/// VSS datatype, not the Dart runtime type of the value.
///
/// These cases run against a REAL databroker. That is deliberate: the contract
/// under test is the broker's, and until 0.2.6 this package's own unit tests
/// constructed the protobuf `Datapoint` by hand — so they asserted whatever the
/// test author believed and could not fail on a wrong wire type. A mock would
/// reproduce that blindness exactly.
///
/// Skipped when no databroker is reachable on localhost:55555:
///
/// ```
/// curl -sfLO https://github.com/COVESA/vehicle_signal_specification/releases/download/v6.1rc2/vss.json
/// docker run -d --rm -p 55555:55555 -v "$PWD/vss.json:/app/vss.json:ro" \
///   -e KUKSA_DATABROKER_METADATA_FILE=/app/vss.json \
///   ghcr.io/eclipse-kuksa/kuksa-databroker:latest --insecure
/// ```
///
/// This file deliberately uses ONLY the public API that 0.2.6 already shipped,
/// so it compiles against the released version too. That is what makes it a
/// control: it fails on 0.2.6 and passes here, and the difference is the fix
/// rather than a new assertion written to match new code.
@TestOn('vm')
library;

import 'dart:io';

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
import 'package:test/test.dart';

const noBroker = 'no databroker reachable on localhost:55555';

/// When set, a missing broker or a missing signal FAILS instead of skipping.
///
/// CI sets it. Without it a CI run with no broker — or with the stock
/// databroker image, whose VSS 6.0 metadata does not contain
/// `Vehicle.Exterior.RoadSurfaceCondition` at all — reports every case in this
/// file as skipped, and a suite of skips is reported as a pass. The control
/// that proves the fix would then never run, and nothing would say so.
final bool brokerRequired =
    Platform.environment['KUKSA_TEST_REQUIRE_BROKER'] == '1';

/// Skips, or fails when the broker was declared required.
void unavailable(String why) {
  if (brokerRequired) {
    fail('KUKSA_TEST_REQUIRE_BROKER=1 but $why. This case is the control for '
        'the wire-type fix; it must run, not be skipped.');
  }
  markTestSkipped(why);
}

/// A `uint8` leaf — 411 of the 1382 leaves in VSS 6.1rc2 are narrow integers
/// like this one, against 9 that are `int32`.
const uint8Signal = kRoadSurfaceCondition;

/// A `float` leaf.
const floatSignal = kVehicleSpeed;

void main() {
  late KuksaClient client;
  var brokerUp = false;
  var knowsUint8Signal = false;

  setUpAll(() async {
    client = KuksaClient(host: 'localhost', port: 55555);
    try {
      await client.connect();
      await client.getServerInfo().timeout(const Duration(seconds: 3));
      brokerUp = true;
      knowsUint8Signal =
          (await client.resolveKnownPaths([uint8Signal])).isNotEmpty;
    } catch (_) {
      brokerUp = false;
    }
  });

  tearDownAll(() async => client.dispose());

  group('publishValue encodes for the signal, not for the Dart type', () {
    test('a uint8 signal accepts an int and reads back as uint32', () async {
      if (!brokerUp) return unavailable(noBroker);
      if (!knowsUint8Signal) {
        return unavailable('$uint8Signal is absent from this broker\'s VSS '
            '(the stock image ships VSS 6.0; mount VSS 6.1rc2 to exercise it)');
      }

      // ICE. Until 0.2.6 this line threw
      //   GrpcError INVALID_ARGUMENT: Wrong type provided
      // because every Dart int was mapped to the int32 field.
      await client.publishValue(uint8Signal, 4);

      final dp = await client.getValue(uint8Signal);
      expect(dp.hasValue, isTrue,
          reason: 'the write was accepted but nothing was stored');
      expect(dp.type, DatapointType.uint32,
          reason: 'a uint8 VSS signal travels in the uint32 field of '
              'kuksa.val.v2.Value; int32 is rejected by the databroker');
      expect(dp.uint32Value, 4);
      expect(dp.int32Value, isNull,
          reason: 'if this is non-null the value went out on the wrong field');
    });

    test('a float signal still accepts a double', () async {
      if (!brokerUp) return unavailable(noBroker);
      await client.publishValue(floatSignal, 88.5);
      final dp = await client.getValue(floatSignal);
      expect(dp.type, DatapointType.float);
      expect(dp.floatValue, closeTo(88.5, 0.001));
    });

    test('a float signal accepts an int, widened', () async {
      if (!brokerUp) return unavailable(noBroker);
      // Rejected before 0.2.7: the int went out on the int32 field.
      await client.publishValue(floatSignal, 100);
      final dp = await client.getValue(floatSignal);
      expect(dp.type, DatapointType.float);
      expect(dp.floatValue, closeTo(100.0, 0.001));
    });

    test('an unknown path is reported as unknown, not as a type error',
        () async {
      if (!brokerUp) return unavailable(noBroker);
      expect(
        () => client.publishValue('Vehicle.NoSuchLeafForWireTypeTest', 1),
        throwsA(isA<UnknownSignalPathsException>()),
      );
    });
  });
}
