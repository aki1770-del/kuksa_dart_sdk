// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// Generates the README's signal table FROM the vendored COVESA VSS spec.
///
/// The prose in README.md must not be able to drift away from the standard, so
/// it is not written by hand: the datatype / unit / min / max columns are read
/// out of `spec/*.vspec` and rendered between the marker comments.
///
///   dart run tool/gen_signal_table.dart          # rewrite README.md in place
///   dart run tool/gen_signal_table.dart --check  # exit 1 if README is stale
///
/// `--check` is what CI runs: if COVESA changes a signal's unit or range and
/// `tool/vss_sync.sh` pulls it in, the build fails loudly instead of leaving
/// the documentation quietly untrue.
library;

import 'dart:io';

import 'package:yaml/yaml.dart';

const beginMarker = '<!-- BEGIN GENERATED SIGNAL TABLE -->';
const endMarker = '<!-- END GENERATED SIGNAL TABLE -->';

/// Which vendored file holds which branch of the tree.
const specFiles = <String, String>{
  'spec/ADAS.vspec': 'Vehicle.ADAS',
  'spec/Body.vspec': 'Vehicle.Body',
  'spec/Vehicle.vspec': 'Vehicle',
  'spec/Exterior.vspec': 'Vehicle.Exterior',
  'spec/Wheel.vspec': 'Vehicle.Chassis.Axle.Wheel',
};

/// The constants this package exports, and the spec key each one resolves to.
///
/// Instance-expanded paths (`Axle.Row1`, `Wheel.Left`, `Windshield.Front`) are
/// declared in VSS via `instances:` on the branch, so the leaf's contract lives
/// under the un-instanced key — that is the key we look up.
const signalMap = <({String constant, String path, String specKey})>[
  (
    constant: 'kRoadFrictionMostProbable',
    path: 'Vehicle.ADAS.ESC.RoadFriction.MostProbable',
    specKey: 'Vehicle.ADAS.ESC.RoadFriction.MostProbable',
  ),
  (
    constant: 'kRoadFrictionLowerBound',
    path: 'Vehicle.ADAS.ESC.RoadFriction.LowerBound',
    specKey: 'Vehicle.ADAS.ESC.RoadFriction.LowerBound',
  ),
  (
    constant: 'kRoadFrictionUpperBound',
    path: 'Vehicle.ADAS.ESC.RoadFriction.UpperBound',
    specKey: 'Vehicle.ADAS.ESC.RoadFriction.UpperBound',
  ),
  (
    constant: 'kTcsIsEngaged',
    path: 'Vehicle.ADAS.TCS.IsEngaged',
    specKey: 'Vehicle.ADAS.TCS.IsEngaged',
  ),
  (
    constant: 'kAbsIsEngaged',
    path: 'Vehicle.ADAS.ABS.IsEngaged',
    specKey: 'Vehicle.ADAS.ABS.IsEngaged',
  ),
  (
    constant: 'kWiperFrontIntensity',
    path: 'Vehicle.Body.Windshield.Front.Wiping.Intensity',
    specKey: 'Vehicle.Body.Windshield.Wiping.Intensity',
  ),
  (
    constant: 'kRaindetectionIntensity',
    path: 'Vehicle.Body.Raindetection.Intensity',
    specKey: 'Vehicle.Body.Raindetection.Intensity',
  ),
  (
    constant: 'kAirTemperature',
    path: 'Vehicle.Exterior.AirTemperature',
    specKey: 'Vehicle.Exterior.AirTemperature',
  ),
  (
    constant: 'kRoadSurfaceCondition',
    path: 'Vehicle.Exterior.RoadSurfaceCondition',
    specKey: 'Vehicle.Exterior.RoadSurfaceCondition',
  ),
  (
    constant: 'kTirePressureFrontLeft',
    path: 'Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.Pressure',
    specKey: 'Vehicle.Chassis.Axle.Wheel.Tire.Pressure',
  ),
  (
    constant: 'kTirePressureFrontRight',
    path: 'Vehicle.Chassis.Axle.Row1.Wheel.Right.Tire.Pressure',
    specKey: 'Vehicle.Chassis.Axle.Wheel.Tire.Pressure',
  ),
  (
    constant: 'kVehicleSpeed',
    path: 'Vehicle.Speed',
    specKey: 'Vehicle.Speed',
  ),
];

/// A signal's contract as declared by the vendored specification.
typedef SpecEntry = ({
  String datatype,
  String type,
  String? unit,
  num? min,
  num? max,
  List<String> allowed,
});

/// Loads every vendored spec file into one path -> contract index.
Map<String, SpecEntry> loadSpecIndex({String root = '.'}) {
  final index = <String, SpecEntry>{};
  for (final entry in specFiles.entries) {
    final file = File('$root/${entry.key}');
    if (!file.existsSync()) {
      throw StateError('Vendored spec missing: ${entry.key}. '
          'Run tool/vss_sync.sh');
    }
    final doc = loadYaml(file.readAsStringSync());
    if (doc is! YamlMap) continue;
    for (final e in doc.entries) {
      final node = e.value;
      if (node is! YamlMap) continue;
      final datatype = node['datatype'];
      if (datatype == null) continue; // branch
      final enumNode = node['enum'];
      final allowedNode = node['allowed'];
      index['${entry.value}.${e.key}'] = (
        datatype: datatype.toString(),
        type: node['type']?.toString() ?? 'sensor',
        unit: node['unit']?.toString(),
        min: node['min'] as num?,
        max: node['max'] as num?,
        allowed: [
          if (enumNode is YamlMap) ...enumNode.keys.map((k) => k.toString()),
          if (allowedNode is YamlList) ...allowedNode.map((v) => v.toString()),
        ],
      );
    }
  }
  return index;
}

String _range(SpecEntry s) {
  final unit = s.unit;
  final hasMin = s.min != null;
  final hasMax = s.max != null;
  final parts = <String>[];
  if (unit != null) parts.add(unit);
  if (hasMin && hasMax) {
    parts.add('${s.min}–${s.max}');
  } else if (hasMax) {
    parts.add('max ${s.max}');
  } else if (hasMin) {
    parts.add('min ${s.min}');
  } else if (s.allowed.isNotEmpty) {
    parts.add(s.allowed.join(' \\| '));
  } else {
    parts.add('no range declared');
  }
  return parts.join(', ');
}

/// Renders the markdown table (between, but not including, the markers).
String renderTable({String root = '.'}) {
  final index = loadSpecIndex(root: root);
  final b = StringBuffer()
    ..writeln('<!-- Generated by tool/gen_signal_table.dart from the vendored '
        'COVESA spec in spec/. Do not edit by hand. -->')
    ..writeln()
    ..writeln('| Constant | VSS path | Datatype | Unit / range (per VSS) |')
    ..writeln('|---|---|---|---|');
  for (final s in signalMap) {
    final spec = index[s.specKey];
    if (spec == null) {
      throw StateError('${s.specKey} is not in the vendored spec — the '
          'signal moved or was removed upstream. Do not document it from '
          'memory; re-run tool/vss_sync.sh and fix the mapping.');
    }
    b.writeln('| `${s.constant}` | `${s.path}` | ${spec.datatype} '
        '(${spec.type}) | ${_range(spec)} |');
  }
  b
    ..writeln('| `kSnowSafetySignals` | — | `List<String>` | '
        'all of the above as one subscription list |')
    ..writeln()
    ..writeln('`Vehicle.ADAS.ESC.RoadFriction.MostProbable` is a **percent** '
        'value (0–100), **not** a 0.0–1.0 fraction: an ESC on black ice '
        'reports about `18.0`. Classify it with `RoadFriction.classify` — see '
        '[Road friction](#road-friction).');
  return b.toString().trimRight();
}

String rewriteReadme(String readme, String table) {
  final start = readme.indexOf(beginMarker);
  final end = readme.indexOf(endMarker);
  if (start < 0 || end < 0 || end < start) {
    throw StateError('README.md is missing the generated-table markers '
        '($beginMarker / $endMarker).');
  }
  final head = readme.substring(0, start + beginMarker.length);
  final tail = readme.substring(end);
  return '$head\n$table\n$tail';
}

void main(List<String> args) {
  final check = args.contains('--check');
  final readmeFile = File('README.md');
  final current = readmeFile.readAsStringSync();
  final updated = rewriteReadme(current, renderTable());

  if (check) {
    if (current != updated) {
      stderr.writeln('README.md signal table is STALE with respect to the '
          'vendored VSS spec in spec/.');
      stderr.writeln('Run: dart run tool/gen_signal_table.dart');
      exit(1);
    }
    stdout.writeln('README.md signal table matches the vendored VSS spec.');
    return;
  }

  readmeFile.writeAsStringSync(updated);
  stdout.writeln('README.md signal table regenerated from spec/.');
}
