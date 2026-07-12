// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// Property tests for the road-friction classifier.
///
/// The spec (`spec/ADAS.vspec`, vendored) declares
/// `Vehicle.ADAS.ESC.RoadFriction.MostProbable` as float, unit percent,
/// min 0, max 100. Values are drawn from that declared range — including the
/// black-ice region a real ESC actually emits.
library;

import 'dart:io';
import 'dart:math';

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// Reads min/max for the friction signal out of the vendored spec — the test
/// draws from the standard's range, not from a range we assumed.
({num min, num max}) specRange() {
  final doc = loadYaml(File('spec/ADAS.vspec').readAsStringSync()) as YamlMap;
  final node = doc['ESC.RoadFriction.MostProbable'] as YamlMap;
  return (min: node['min'] as num, max: node['max'] as num);
}

void main() {
  final range = specRange();

  group('spec bounds', () {
    test('the classifier advertises the spec range', () {
      expect(RoadFriction.minPercent, range.min);
      expect(RoadFriction.maxPercent, range.max);
    });
  });

  group('classification of spec-legal readings', () {
    test('18.0 percent (black ice — a real ESC reading) is ICY', () {
      final r = RoadFriction.classify(18.0);
      expect(r.grip, RoadGrip.icy);
      expect(r.isIcy, isTrue);
      expect(r.isKnown, isTrue);
      expect(r.percent, 18.0);
    });

    test('87.0 percent (good grip) is GRIP and NOT icy', () {
      final r = RoadFriction.classify(87.0);
      expect(r.grip, RoadGrip.grip);
      expect(r.isIcy, isFalse);
      expect(r.isKnown, isTrue);
    });

    test(
        'the whole spec range partitions into icy | reduced | grip, never '
        'unknown', () {
      for (var p = range.min.toDouble(); p <= range.max; p += 0.5) {
        final r = RoadFriction.classify(p);
        expect(r.grip, isNot(RoadGrip.unknown),
            reason: '$p percent is inside the spec range and must classify');
        expect(r.isKnown, isTrue, reason: '$p percent');
      }
    });

    test('randomised sweep of the spec range: icy iff below the threshold', () {
      final rnd = Random(20260712);
      for (var i = 0; i < 2000; i++) {
        final p = range.min + rnd.nextDouble() * (range.max - range.min);
        final r = RoadFriction.classify(p);
        expect(r.isIcy, p < RoadFriction.icyBelowPercent,
            reason: '$p percent classified ${r.grip}');
      }
    });

    test('the ice threshold is on the percent scale, not a 0-1 fraction', () {
      expect(RoadFriction.icyBelowPercent, greaterThan(1.0),
          reason: 'a threshold <= 1.0 would mean the fraction-scale bug is '
              'back: 18.0 (black ice) would never be below it');
    });
  });

  group('absence is absence — never an all-clear (D4)', () {
    test('null (no sensor / no provider) is UNKNOWN, never grip', () {
      final r = RoadFriction.classify(null);
      expect(r.grip, RoadGrip.unknown);
      expect(r.isKnown, isFalse);
      expect(r.percent, isNull);
      // The load-bearing property: an absent reading must NOT answer "not icy".
      expect(r.isIcy, isFalse, reason: 'unknown is not a positive ice claim');
      expect(r.isNotIcy, isFalse,
          reason: 'ABSENCE MUST NOT ASSERT A SAFE ROAD. If this is true, an '
              'unreported sensor has been turned into a clear-road claim.');
    });

    test('unknown is not silently coerced by ??-style defaulting', () {
      // The 0.2.3 README did `(friction ?? 1.0) < 0.3` — full grip fabricated.
      // There is no double to fall back to: the API forces the caller to see it.
      final r = RoadFriction.classify(null);
      expect(r.percent, isNull);
      expect(() => r.requirePercent(), throwsA(isA<StateError>()));
    });
  });

  group('a producer contract violation surfaces as UNKNOWN, never coerced', () {
    // FSE: clamping 18.0-style out-of-range values re-creates a fabricated
    // clear (a clamp of 120 -> 100 asserts PERFECT GRIP). Out of range means
    // the producer is broken; the honest answer is "we do not know".
    test('above the spec max is UNKNOWN + contract violation, not clamped', () {
      final r = RoadFriction.classify(range.max + 20.0);
      expect(r.grip, RoadGrip.unknown);
      expect(r.isContractViolation, isTrue);
      expect(r.isNotIcy, isFalse, reason: 'must not be coerced to full grip');
      expect(r.percent, isNull, reason: 'must not be clamped to a safe number');
    });

    test('below the spec min is UNKNOWN + contract violation, not clamped', () {
      final r = RoadFriction.classify(-5.0);
      expect(r.grip, RoadGrip.unknown);
      expect(r.isContractViolation, isTrue);
      expect(r.percent, isNull);
    });

    test('NaN / infinity are UNKNOWN + contract violation', () {
      for (final v in [double.nan, double.infinity, -double.infinity]) {
        final r = RoadFriction.classify(v);
        expect(r.grip, RoadGrip.unknown, reason: '$v');
        expect(r.isContractViolation, isTrue, reason: '$v');
      }
    });

    test(
        'a 0.0-1.0-scaled producer (the legacy bug) does NOT silently pass as '
        'good grip', () {
      // If some producer emits 0.85 meaning "85% grip", on the percent scale
      // that is 0.85 percent — a near-frictionless road. The classifier must
      // report ICY (the alarming reading), never quietly rescale it to grip.
      final r = RoadFriction.classify(0.85);
      expect(r.grip, RoadGrip.icy,
          reason: 'must not rescale a suspicious value into a safe one');
    });

    test('classifyDatapoint(null datapoint) is UNKNOWN', () {
      final r = RoadFriction.classifyDatapoint(null);
      expect(r.grip, RoadGrip.unknown);
      expect(r.isKnown, isFalse);
    });
  });
}
