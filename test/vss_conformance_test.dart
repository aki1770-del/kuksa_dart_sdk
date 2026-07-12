// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// Conformance test: this package's documented and executable semantics for
/// VSS signals MUST match the COVESA Vehicle Signal Specification.
///
/// The specification is VENDORED AS DATA under `spec/ADAS.vspec` (fetched by
/// `tool/vss_sync.sh`) and PARSED here. Nothing in this file restates the
/// specification from memory: every expectation is read out of the spec file.
///
/// Why this exists: `Vehicle.ADAS.ESC.RoadFriction.MostProbable` is a float in
/// PERCENT, 0..100 ("0 = no friction, 100 = maximum friction"). A real ESC on
/// black ice emits a value like 18.0. Any code or documentation that treats the
/// signal as a 0.0-1.0 fraction with an "icy below 0.3" rule classifies black
/// ice as a clear road.
library;

import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// One signal's contract as declared by the vendored specification.
class SpecSignal {
  SpecSignal({
    required this.path,
    required this.datatype,
    required this.unit,
    required this.min,
    required this.max,
  });

  final String path;
  final String datatype;
  final String? unit;
  final num? min;
  final num? max;

  @override
  String toString() =>
      '$path (datatype=$datatype, unit=$unit, min=$min, max=$max)';
}

/// Parses the vendored `.vspec` (YAML) and returns fully-qualified signals.
///
/// `.vspec` keys are relative to the file's branch root (`Vehicle.ADAS` for
/// `spec/ADAS/ADAS.vspec`), so we re-qualify them here.
Map<String, SpecSignal> parseVspec(String yamlText, {required String prefix}) {
  final doc = loadYaml(yamlText) as YamlMap;
  final out = <String, SpecSignal>{};
  for (final entry in doc.entries) {
    final node = entry.value;
    if (node is! YamlMap) continue;
    if (node['type'] == 'branch') continue;
    final datatype = node['datatype'];
    if (datatype == null) continue;
    final path = '$prefix.${entry.key}';
    out[path] = SpecSignal(
      path: path,
      datatype: datatype.toString(),
      unit: node['unit']?.toString(),
      min: node['min'] as num?,
      max: node['max'] as num?,
    );
  }
  return out;
}

/// The published locations that document the friction signal's range.
/// Every one of these was wrong in kuksa_dart_sdk <= 0.2.3.
const _documentedRangeLocations = <String>[
  'lib/src/client/signal_path.dart',
  'lib/kuksa_dart_sdk.dart',
  'README.md',
  'example/snow_safety_monitor.dart',
  'example/flutter_conditions/lib/driving_conditions.dart',
];

/// Text patterns that assert the WRONG (0.0-1.0 fraction) contract.
final _fractionScaleClaims = <RegExp>[
  RegExp(r'0\.0\s*[–\-]\s*1\.0'),
  RegExp(r'0\.0\s*[–\-]\s*1\.0'),
  RegExp(r'<\s*0\.3'),
  RegExp(r'below\s+0\.3'),
  RegExp(r'0\.3\s*=\s*icy', caseSensitive: false),
  RegExp(r'kLowFriction\s*=\s*0\.3'),
];

/// The fabricated-clear pattern: an ABSENT sensor reading silently replaced by
/// a value that means "full grip". Absence is not evidence of safety.
final _fabricatedClear = RegExp(r'friction\s*\?\?\s*1\.0|\?\?\s*1\.0\)\s*<');

/// A line that *warns against* the fraction-scale contract is the opposite of a
/// line that asserts it. Only an assertion is a defect.
///
/// This carve-out applies ONLY to the scale/threshold scanner. The
/// fabricated-clear scanner (`?? 1.0`) and the 18.0-classifies-as-ICY property
/// test have no carve-out at all: no phrasing excuses those.
final _negationMarker = RegExp(
  r'\bnot\b|\bnever\b|\bwrong\b|\bincorrect\b|\blegacy\b|\bmisread\b'
  r'|rather than|instead of|will classify|classified as a clear road'
  r'|as a clear road',
  caseSensitive: false,
);

String _read(String rel) => File(rel).readAsStringSync();

/// Lines of [text] that ASSERT the wrong (0.0-1.0 fraction) contract, rendered
/// as `file:line: content` so the failure quotes the real line verbatim.
List<String> violatingLines(String rel, String text) {
  final lines = text.split('\n');
  final out = <String>[];
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (!_fractionScaleClaims.any((re) => re.hasMatch(line))) continue;
    if (_negationMarker.hasMatch(line)) continue; // a warning, not a claim
    out.add('$rel:${i + 1}: ${line.trim()}');
  }
  return out;
}

/// Lines of [text] matching [re], rendered as `file:line: content`.
List<String> _hits(String rel, String text, RegExp re) {
  final lines = text.split('\n');
  final out = <String>[];
  for (var i = 0; i < lines.length; i++) {
    if (re.hasMatch(lines[i])) out.add('$rel:${i + 1}: ${lines[i].trim()}');
  }
  return out;
}

/// The exact text kuksa_dart_sdk 0.2.3 published. The scanner MUST still flag
/// every one of these — otherwise the gate has been blunted and would let the
/// original defect back in.
const _published023Defects = <String>[
  "print('Road friction: \${dp.floatValue}');   // 0.0–1.0; < 0.3 = icy road",
  'if ((friction ?? 1.0) < 0.3 || tcsActive) {',
  '/// Type: float (0.0–1.0). A value below 0.3 indicates icy/snowy road.',
  '| `kRoadFrictionMostProbable` | `Vehicle.ADAS.ESC.RoadFriction.MostProbable`'
      ' | float | 0.0–1.0; < 0.3 = icy |',
  'final bool lowFriction = friction != null && friction < 0.3;',
  '/// Road friction estimate, 0.0–1.0 (`< 0.3` ≈ icy). VSS:',
  '  static const double kLowFriction = 0.3;',
];

void main() {
  late Map<String, SpecSignal> spec;
  late SpecSignal friction;

  setUpAll(() {
    final f = File('spec/ADAS.vspec');
    if (!f.existsSync()) {
      fail('spec/ADAS.vspec is not vendored. Run tool/vss_sync.sh');
    }
    spec = parseVspec(f.readAsStringSync(), prefix: 'Vehicle.ADAS');
    final f2 = spec['Vehicle.ADAS.ESC.RoadFriction.MostProbable'];
    if (f2 == null) {
      fail('Vehicle.ADAS.ESC.RoadFriction.MostProbable absent from vendored '
          'spec — the spec moved; regenerate before trusting this package.');
    }
    friction = f2;
  });

  group('vendored spec is the source of truth', () {
    test('RoadFriction.MostProbable is float, percent, 0..100', () {
      expect(friction.datatype, 'float', reason: 'spec datatype: $friction');
      expect(friction.unit, 'percent', reason: 'spec unit: $friction');
      expect(friction.min, 0, reason: 'spec min: $friction');
      expect(friction.max, 100, reason: 'spec max: $friction');
    });

    test('the friction confidence bounds carry the same contract', () {
      for (final p in const [
        'Vehicle.ADAS.ESC.RoadFriction.LowerBound',
        'Vehicle.ADAS.ESC.RoadFriction.UpperBound',
      ]) {
        final s = spec[p];
        expect(s, isNotNull, reason: '$p absent from vendored spec');
        expect(s!.unit, 'percent', reason: '$s');
        expect(s.min, 0, reason: '$s');
        expect(s.max, 100, reason: '$s');
      }
    });
  });

  group('the scanner itself still fails on the 0.2.3 text (gate self-test)',
      () {
    test('every line kuksa_dart_sdk 0.2.3 published is flagged', () {
      for (final line in _published023Defects) {
        final flagged = violatingLines('published-0.2.3', line);
        expect(flagged, isNotEmpty,
            reason: 'The scale/threshold scanner no longer catches the exact '
                'text 0.2.3 shipped. The gate has been blunted:\n  $line');
      }
    });

    test('the fabricated-clear scanner still flags the 0.2.3 quickstart', () {
      expect(
          _hits('published-0.2.3', 'if ((friction ?? 1.0) < 0.3 || x) {',
              _fabricatedClear),
          isNotEmpty);
    });

    test('a mere warning about the wrong scale is NOT a violation', () {
      expect(
        violatingLines(
            'doc', 'This is NOT a 0.0–1.0 fraction; VSS is percent.'),
        isEmpty,
      );
    });
  });

  group('published documentation must match the vendored spec', () {
    test('no published location claims a 0.0-1.0 scale or a 0.3 ice threshold',
        () {
      final violations = <String>[];
      for (final rel in _documentedRangeLocations) {
        violations.addAll(violatingLines(rel, _read(rel)));
      }
      expect(
        violations,
        isEmpty,
        reason: 'The vendored spec declares ${friction.unit} '
            '${friction.min}..${friction.max}. These lines document a '
            'different contract, under which a real ESC reading of 18.0 '
            '(black ice) is classified as a clear road:\n'
            '${violations.map((v) => '  $v').join('\n')}',
      );
    });

    test('every location that mentions the friction signal states "percent"',
        () {
      final missing = <String>[];
      for (final rel in _documentedRangeLocations) {
        final text = _read(rel);
        if (!text.contains('RoadFriction') && !text.contains('roadFriction')) {
          continue;
        }
        if (!text.toLowerCase().contains('percent')) missing.add(rel);
      }
      expect(missing, isEmpty,
          reason: 'These files document the friction signal without stating '
              'its spec unit (percent, 0..100): $missing');
    });
  });

  group('absence must never be fabricated into safety (D4)', () {
    test('no `?? 1.0` default substitutes full grip for a missing sensor', () {
      final violations = <String>[];
      for (final rel in [..._documentedRangeLocations, 'example/README.md']) {
        if (!File(rel).existsSync()) continue;
        violations.addAll(_hits(rel, _read(rel), _fabricatedClear));
      }
      expect(
        violations,
        isEmpty,
        reason: 'An absent friction reading is being replaced by a value that '
            'means FULL GRIP. Absence is not evidence of a safe road:\n'
            '${violations.map((v) => '  $v').join('\n')}',
      );
    });
  });

  group('the documented classification rule, applied to spec-legal values', () {
    // Extract the ice threshold the package DOCUMENTS, then apply it to values
    // the spec itself declares legal. This does not restate the rule — it reads
    // the rule the package publishes and tests it against the standard.
    double documentedIceThreshold() {
      final src = _read('lib/src/client/signal_path.dart');
      final m = RegExp(r'below\s+([0-9]+(?:\.[0-9]+)?)').firstMatch(src);
      if (m == null) {
        fail('lib/src/client/signal_path.dart no longer documents an ice '
            'threshold in the form "below <N>" — update this test.');
      }
      return double.parse(m.group(1)!);
    }

    test('a spec-legal black-ice reading (18.0 percent) is classified ICY', () {
      final t = documentedIceThreshold();
      expect(18.0, greaterThanOrEqualTo(friction.min!),
          reason: '18.0 is inside the spec range');
      expect(18.0, lessThanOrEqualTo(friction.max!.toDouble()),
          reason: '18.0 is inside the spec range');
      expect(
        18.0 < t,
        isTrue,
        reason: 'The package documents "icy below $t". A real ESC on black ice '
            'emits 18.0 ${friction.unit} (spec range ${friction.min}..'
            '${friction.max}). 18.0 < $t is FALSE, so the documented rule '
            'reports black ice as NOT icy.',
      );
    });

    test('a spec-legal good-grip reading (87.0 percent) is NOT classified ICY',
        () {
      final t = documentedIceThreshold();
      expect(87.0 < t, isFalse,
          reason: 'The package documents "icy below $t"; 87.0 percent is a '
              'good-grip road and must not be reported icy.');
    });
  });
}
