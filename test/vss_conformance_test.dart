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

/// Every publishable location that could document the friction signal —
/// **DISCOVERED, never hand-listed.**
///
/// This was a hand-authored list of five paths until 0.2.5, and
/// `lib/src/client/kuksa_client.dart` was not on it. The scanner below is
/// strict, self-tested against the exact text 0.2.3 shipped, and grants the
/// `?? 1.0` pattern no carve-out whatsoever — and it still let
/// `if ((friction ?? 1.0) < 0.3 ...)` ship inside that file's API-reference
/// example, in 0.2.4, on pub.dev, for an edge developer to copy.
///
/// A guard whose scope is written by the same hand as the code cannot falsify
/// that code: the author omits the file for the same reason he wrote the bug.
/// So the scope is now *derived from the filesystem* — every `.dart` we ship
/// under `lib/` and `example/`, and every Markdown doc a reader lands on.
/// Adding a new file cannot silently escape the gate; deleting the list cannot
/// silently shrink it.
List<String> _discoverDocumentedLocations() {
  final out = <String>[];
  for (final dir in ['lib', 'example']) {
    final d = Directory(dir);
    if (!d.existsSync()) continue;
    out.addAll(d
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.path)
        // Skip generated protobuf and build artifacts: not ours to document.
        .where((p) =>
            (p.endsWith('.dart') || p.endsWith('.md')) &&
            !p.contains('/generated/') &&
            !p.contains('/.dart_tool/') &&
            !p.contains('/build/')));
  }
  // README is a TEACHING surface and is scanned.
  //
  // CHANGELOG is deliberately NOT scanned: its job is to quote the old defect
  // verbatim ("0.2.3 and earlier did `(friction ?? 1.0) < 0.3`") so a consumer
  // can recognise it in his own code. The fabricated-clear scanner grants no
  // phrasing carve-out — correctly — so scanning the changelog would flag our
  // own recall note. A confession is not a lesson; teaching surfaces are.
  if (File('README.md').existsSync()) out.add('README.md');
  out.sort();
  return out;
}

final _documentedRangeLocations = _discoverDocumentedLocations();

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
  late Map<String, SpecSignal> exterior;
  late SpecSignal friction;

  setUpAll(() {
    final f = File('spec/ADAS.vspec');
    if (!f.existsSync()) {
      fail('spec/ADAS.vspec is not vendored. Run tool/vss_sync.sh');
    }
    final fe = File('spec/Exterior.vspec');
    if (!fe.existsSync()) {
      fail('spec/Exterior.vspec is not vendored. Run tool/vss_sync.sh');
    }
    exterior = parseVspec(fe.readAsStringSync(), prefix: 'Vehicle.Exterior');
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

  group('a signal\'s DATATYPE, not only its range, must match the spec', () {
    // The range guards above were built after 0.2.3 documented a percent
    // signal as a fraction. The same class of defect then happened on the
    // DATATYPE axis and nothing was watching it: Vehicle.Exterior.
    // RoadSurfaceCondition is a uint8 enum, the package's own test suite
    // asserted a string value for it, and publishValue could not write it at
    // all. These cases read the datatype out of the vendored spec.

    test('RoadSurfaceCondition is a uint8 enum in the vendored spec', () {
      final s = exterior['Vehicle.Exterior.RoadSurfaceCondition'];
      expect(s, isNotNull,
          reason: 'the signal left the spec; do not document it from memory');
      expect(s!.datatype, 'uint8',
          reason: 'spec says: $s. If COVESA changed this datatype, the wire '
              'mapping in lib/src/client/vss_datatype.dart and the docs in '
              'signal_path.dart must be revisited before publishing.');
    });

    test('signal_path.dart documents RoadSurfaceCondition as the spec does',
        () {
      final s = exterior['Vehicle.Exterior.RoadSurfaceCondition']!;
      final doc = _read('lib/src/client/signal_path.dart');
      final block = doc.substring(
          doc.indexOf('/// Fused road surface condition.'),
          doc.indexOf('const String kRoadSurfaceCondition'));
      expect(block, contains(s.datatype),
          reason: 'the vendored spec declares ${s.datatype}; the constant is '
              'documented as something else');
      expect(block.toLowerCase(), isNot(contains('type: string')),
          reason: 'RoadSurfaceCondition is a ${s.datatype} enum. Documenting '
              'it as a string is the contract the 0.2.6 test suite encoded, '
              'and it is why a wrong wire type could not fail a test.');
    });

    test('no source builds a RoadSurfaceCondition datapoint from a string', () {
      // The founding defect, encoded exactly: a Datapoint constructed at
      // path kRoadSurfaceCondition whose value was set with `..string = `.
      // That lived in test/kuksa_dart_sdk_test.dart, so the scan MUST cover
      // test/ — the range scanners above cover lib/ and example/ only, which
      // is why nothing caught it.
      final offenders = <String>[];
      for (final dir in ['lib', 'example', 'test']) {
        final d = Directory(dir);
        if (!d.existsSync()) continue;
        for (final f in d.listSync(recursive: true).whereType<File>().where(
            (f) =>
                f.path.endsWith('.dart') && !f.path.contains('/generated/'))) {
          final lines = f.readAsStringSync().split('\n');
          for (var i = 0; i < lines.length; i++) {
            if (!lines[i].contains('kRoadSurfaceCondition')) continue;
            // Look back a few lines: the value is built just above the
            // Datapoint that carries the path.
            final from = i - 4 < 0 ? 0 : i - 4;
            for (var j = from; j <= i; j++) {
              // A comment cannot construct a Datapoint. This is a structural
              // exclusion, not a phrasing carve-out: the line is skipped
              // because it is not code, never because of how it is worded.
              if (lines[j].trimLeft().startsWith('//')) continue;
              if (RegExp(r"\.\.string\s*=|Value\(string:").hasMatch(lines[j])) {
                offenders.add('${f.path}:${j + 1}: ${lines[j].trim()}');
              }
            }
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason: 'Vehicle.Exterior.RoadSurfaceCondition is a uint8 enum. These '
            'lines build it from a string, which is the contract the 0.2.6 '
            'suite encoded and the reason a wrong wire type could not fail a '
            'test:\n${offenders.map((o) => '  $o').join('\n')}',
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
