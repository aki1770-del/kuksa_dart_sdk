// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// The wildcard semantics `expand()` applies client-side. No databroker: the
/// contract under test is this package's own matcher, pinned to the
/// databroker's wildcard_matching.md and the Python client's patterns.py.
library;

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
import 'package:test/test.dart';

const speed = 'Vehicle.Speed';
const friction = 'Vehicle.ADAS.ESC.RoadFriction.MostProbable';
const tcs = 'Vehicle.ADAS.TCS.IsEngaged';
const tyre = 'Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.Pressure';

void main() {
  group('"*" matches exactly one segment', () {
    test('one segment', () {
      final p = SignalPattern('Vehicle.*');
      expect(p.matches(speed), isTrue);
      expect(p.matches(tcs), isFalse, reason: 'three segments below Vehicle');
      expect(p.matches('Vehicle'), isFalse, reason: 'zero segments');
    });

    test('in the middle', () {
      final p = SignalPattern('Vehicle.ADAS.*.IsEngaged');
      expect(p.matches(tcs), isTrue);
      expect(p.matches('Vehicle.ADAS.ESC.Extra.IsEngaged'), isFalse);
    });

    test('never matches an empty segment', () {
      expect(SignalPattern('Vehicle.*.Speed').matches(speed), isFalse);
    });
  });

  group('"**" matches zero or more segments', () {
    test('zero', () {
      expect(SignalPattern('Vehicle.**.Speed').matches(speed), isTrue);
    });

    test('many', () {
      expect(SignalPattern('Vehicle.**.Pressure').matches(tyre), isTrue);
      expect(SignalPattern('**.Pressure').matches(tyre), isTrue);
      expect(SignalPattern('Vehicle.**').matches(friction), isTrue);
    });

    test('but only where the rest still lines up', () {
      expect(SignalPattern('Vehicle.**.Pressure').matches(speed), isFalse);
      expect(SignalPattern('Vehicle.ADAS.**').matches(speed), isFalse);
      expect(SignalPattern('Vehicle.Chassis.**.Left.**').matches(tyre), isTrue);
      expect(
          SignalPattern('Vehicle.Chassis.**.Right.**').matches(tyre), isFalse);
    });
  });

  group('a literal pattern is a branch', () {
    test('matches itself and everything below it', () {
      final p = SignalPattern('Vehicle.ADAS.ESC');
      expect(p.matches('Vehicle.ADAS.ESC'), isTrue);
      expect(p.matches(friction), isTrue);
      expect(p.matches(tcs), isFalse);
      expect(p.matches('Vehicle.ADAS.ESCape.X'), isFalse,
          reason: 'a prefix must end on a segment boundary');
    });

    test('a leaf matches only itself', () {
      expect(SignalPattern(speed).matches(speed), isTrue);
      expect(SignalPattern(speed).matches('$speed.Extra'), isTrue,
          reason: 'a literal pattern is a branch; the broker decides what '
              'lives below it');
    });

    test('the empty pattern matches everything', () {
      expect(SignalPattern('').matchesAll, isTrue);
      expect(SignalPattern('').matches(speed), isTrue);
      expect(SignalPattern('').literalPrefix, '');
    });
  });

  group('literalPrefix bounds the metadata listing', () {
    test('stops at the first wildcard', () {
      expect(SignalPattern('Vehicle.ADAS.**').literalPrefix, 'Vehicle.ADAS');
      expect(SignalPattern('Vehicle.*.IsEngaged').literalPrefix, 'Vehicle');
      expect(SignalPattern('**.Pressure').literalPrefix, '');
      expect(SignalPattern(friction).literalPrefix, friction);
    });
  });

  group('unsupported patterns are refused at the call, not matched to nothing',
      () {
    test('"**" with consecutive "*" segments', () {
      expect(() => SignalPattern('Vehicle.**.*.*'), throwsArgumentError);
      expect(() => SignalPattern('*.*.**'), throwsArgumentError);
    });

    test('consecutive "*" without "**" is allowed', () {
      expect(SignalPattern('Vehicle.*.*').matches('Vehicle.ADAS.X'), isTrue);
    });

    test('a partial-segment glob', () {
      // The Python matcher compares "Is*" literally and expands to nothing.
      expect(() => SignalPattern('Vehicle.ADAS.TCS.Is*'), throwsArgumentError);
    });

    test('an empty segment', () {
      expect(() => SignalPattern('Vehicle..Speed'), throwsArgumentError);
    });
  });

  test('VssEntryType maps every wire value, and UNSPECIFIED to null', () {
    expect(VssEntryType.values, hasLength(3));
  });
}
