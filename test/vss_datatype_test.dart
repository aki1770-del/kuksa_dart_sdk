// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// The VSS-datatype -> wire-field table, asserted independently of the code
/// that implements it.
///
/// The expectations below are HARD-CODED from measurement, not read back out of
/// [wireArmFor]. Asserting `armOf(encode(t)) == wireArmFor(t)` would be a
/// tautology that passes for any table, including a wrong one.
///
/// Provenance of the expected column, both derivations agreeing where they
/// overlap:
///
///  * measured against kuksa-databroker 0.7.1 + COVESA VSS 6.1rc2 by offering
///    all sixteen `Value` fields at a real leaf of each datatype and recording
///    the one accepted (13 datatypes have leaves in VSS 6.1rc2);
///  * read from the databroker's own `fn validate_value` in
///    `databroker/src/broker.rs` for the datatypes VSS 6.1rc2 has no leaf of.
@TestOn('vm')
library;

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
import 'package:test/test.dart';

/// datatype -> (a legal Dart value, the field the databroker accepts).
const table = <VssDataType, (Object, ValueArm)>{
  VssDataType.boolean: (true, ValueArm.boolean),
  VssDataType.string: ('ICE', ValueArm.string),
  VssDataType.int8: (-50, ValueArm.int32),
  VssDataType.int16: (-3000, ValueArm.int32),
  VssDataType.int32: (70000, ValueArm.int32),
  VssDataType.int64: (5000000000, ValueArm.int64),
  VssDataType.uint8: (4, ValueArm.uint32),
  VssDataType.uint16: (60000, ValueArm.uint32),
  VssDataType.uint32: (4000000000, ValueArm.uint32),
  VssDataType.uint64: (5000000000, ValueArm.uint64),
  VssDataType.float: (18.0, ValueArm.float),
  VssDataType.double_: (18.0, ValueArm.double_),
  VssDataType.booleanArray: ([true, false], ValueArm.boolArray),
  VssDataType.stringArray: (['P0001'], ValueArm.stringArray),
  VssDataType.int8Array: ([-1, 2], ValueArm.int32Array),
  VssDataType.int16Array: ([-300, 2], ValueArm.int32Array),
  VssDataType.int32Array: ([70000], ValueArm.int32Array),
  VssDataType.int64Array: ([5000000000], ValueArm.int64Array),
  VssDataType.uint8Array: ([1, 255], ValueArm.uint32Array),
  VssDataType.uint16Array: ([60000], ValueArm.uint32Array),
  VssDataType.uint32Array: ([4000000000], ValueArm.uint32Array),
  VssDataType.uint64Array: ([5000000000], ValueArm.uint64Array),
  VssDataType.floatArray: ([1.5], ValueArm.floatArray),
  VssDataType.doubleArray: ([1.5], ValueArm.doubleArray),
};

/// The wire format has no field for these, so no client can publish them.
const unpublishable = <VssDataType>[
  VssDataType.timestamp,
  VssDataType.timestampArray,
];

void main() {
  group('every VSS datatype encodes into the field the databroker accepts', () {
    table.forEach((type, expected) {
      final (value, arm) = expected;
      test('${type.name} -> ${arm.name}', () {
        final encoded =
            encodeVssValue(path: 'Vehicle.Test', type: type, value: value);
        expect(armOf(encoded), arm);
      });
    });

    test('the table covers every VssDataType', () {
      final covered = {...table.keys, ...unpublishable};
      expect(covered, containsAll(VssDataType.values),
          reason: 'A VssDataType exists with no expected wire field. Add it '
              'here with the field a real databroker accepts — do not infer '
              'one from the name.');
    });
  });

  group('the narrow integer datatypes are the ones that were broken', () {
    test('uint8 does NOT go out on int32', () {
      // The whole defect in one line: 411 of the 1382 leaves in VSS 6.1rc2 are
      // narrow integers, and a Dart int alone cannot pick their field.
      final encoded = encodeVssValue(
          path: kRoadSurfaceCondition, type: VssDataType.uint8, value: 4);
      expect(armOf(encoded), ValueArm.uint32);
      expect(armOf(encoded), isNot(ValueArm.int32),
          reason: 'the databroker answers "Wrong type provided" for int32 on '
              'a uint8 signal');
    });

    test('int8 and int16 share the int32 field, uint8 and uint16 the uint32',
        () {
      for (final t in [
        VssDataType.int8,
        VssDataType.int16,
        VssDataType.int32
      ]) {
        expect(wireArmFor(t), ValueArm.int32, reason: t.name);
      }
      for (final t in [
        VssDataType.uint8,
        VssDataType.uint16,
        VssDataType.uint32
      ]) {
        expect(wireArmFor(t), ValueArm.uint32, reason: t.name);
      }
    });
  });

  group('a value that cannot be written is refused, never truncated', () {
    test('uint8 refuses 256', () {
      expect(
        () => encodeVssValue(
            path: 'Vehicle.Test', type: VssDataType.uint8, value: 256),
        throwsA(isA<VssTypeMismatch>()),
      );
    });

    test('uint8 refuses a negative value', () {
      expect(
        () => encodeVssValue(
            path: 'Vehicle.Test', type: VssDataType.uint8, value: -1),
        throwsA(isA<VssTypeMismatch>()),
      );
    });

    test('int8 refuses 128', () {
      expect(
        () => encodeVssValue(
            path: 'Vehicle.Test', type: VssDataType.int8, value: 128),
        throwsA(isA<VssTypeMismatch>()),
      );
    });

    test('an integer signal refuses a fractional double rather than rounding',
        () {
      expect(
        () => encodeVssValue(
            path: kRoadSurfaceCondition, type: VssDataType.uint8, value: 4.7),
        throwsA(isA<VssTypeMismatch>()),
        reason: 'a silently rounded value on a safety signal cannot be told '
            'apart from a measured one',
      );
    });

    test('a uint8 array refuses an out-of-range element', () {
      expect(
        () => encodeVssValue(
            path: 'Vehicle.Test',
            type: VssDataType.uint8Array,
            value: [1, 999]),
        throwsA(isA<VssTypeMismatch>()),
      );
    });

    test('an array datatype refuses a scalar', () {
      expect(
        () => encodeVssValue(
            path: 'Vehicle.Test', type: VssDataType.stringArray, value: 'ICE'),
        throwsA(isA<VssTypeMismatch>()),
      );
    });

    test('a string signal refuses an int', () {
      expect(
        () => encodeVssValue(
            path: 'Vehicle.Test', type: VssDataType.string, value: 4),
        throwsA(isA<VssTypeMismatch>()),
      );
    });

    for (final t in unpublishable) {
      test('${t.name} says the wire format has no field for it', () {
        expect(
          () => encodeVssValue(path: 'Vehicle.Test', type: t, value: 1),
          throwsA(isA<VssTypeMismatch>()),
          reason: 'kuksa.val.v2.Value has no ${t.name} field; that is a limit '
              'of the wire format and must be reported, not guessed at',
        );
      });
    }
  });

  group('widening toward a float signal is allowed', () {
    test('an int written to a float signal is widened', () {
      final encoded = encodeVssValue(
          path: kVehicleSpeed, type: VssDataType.float, value: 100);
      expect(armOf(encoded), ValueArm.float);
    });

    test('an int written to a double signal is widened', () {
      final encoded = encodeVssValue(
          path: 'Vehicle.Test', type: VssDataType.double_, value: 100);
      expect(armOf(encoded), ValueArm.double_);
    });

    test('an int element in a float array is widened', () {
      final encoded = encodeVssValue(
          path: 'Vehicle.Test', type: VssDataType.floatArray, value: [1, 2.5]);
      expect(armOf(encoded), ValueArm.floatArray);
    });
  });

  group('the failure names the signal, the datatype and the bound', () {
    test('VssTypeMismatch carries what the databroker will not tell you', () {
      try {
        encodeVssValue(
            path: kRoadSurfaceCondition, type: VssDataType.uint8, value: 300);
        fail('expected VssTypeMismatch');
      } on VssTypeMismatch catch (e) {
        expect(e.path, kRoadSurfaceCondition);
        expect(e.dataType, VssDataType.uint8);
        expect(e.value, 300);
        // The broker's own rejection is "Value out of type bounds (id: 891)":
        // no path, no datatype, no limit.
        expect(e.toString(), contains(kRoadSurfaceCondition));
        expect(e.toString(), contains('uint8'));
        expect(e.toString(), contains('255'));
      }
    });
  });
}
