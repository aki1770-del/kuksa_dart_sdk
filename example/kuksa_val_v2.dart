// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// Vendor-neutral `kuksa.val.v2` sample for the KUKSA Dart SDK.
///
/// Mirrors the shape of the upstream Rust `kuksa_val_v2.rs` example: a `main()`
/// that connects to a local databroker and exercises each core API —
/// server info, read, write, subscribe, and metadata listing.
///
/// Start a databroker first (see example/README.md), then run:
///   dart run example/kuksa_val_v2.dart
library;

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

const String _path = 'Vehicle.Speed';

void main() async {
  final client = KuksaClient(host: 'localhost', port: 55555);

  try {
    await client.connect();
    print('Connected to kuksa-databroker at localhost:55555\n');

    await getServerInfo(client);
    await getValue(client);
    await publishValue(client);
    await publishNarrowInteger(client);
    await listMetadata(client);
    await expand(client);
    await subscribe(client);
  } finally {
    await client.dispose();
  }
}

/// Prints the databroker server name, version, and commit.
Future<void> getServerInfo(KuksaClient client) async {
  final info = await client.getServerInfo();
  print('[getServerInfo] ${info.name} ${info.version} (${info.commitHash})');
}

/// Reads the current value of a single signal.
Future<void> getValue(KuksaClient client) async {
  final dp = await client.getValue(_path);
  if (dp.hasValue) {
    print('[getValue] $_path = ${dp.value}');
  } else {
    print('[getValue] $_path has no value yet');
  }
}

/// Publishes (writes) a value for a signal.
///
/// The wire type follows the SIGNAL's declared VSS datatype, not the Dart type
/// of the value: `Vehicle.Speed` is a `float`, so 100.34 goes out on the float
/// field.
Future<void> publishValue(KuksaClient client) async {
  await client.publishValue(_path, 100.34);
  print('[publishValue] $_path <- 100.34');
}

/// Publishes a narrow-integer signal.
///
/// `Vehicle.Exterior.RoadSurfaceCondition` is a `uint8` enum (4 = ICE), and
/// `uint8` travels in the `uint32` field of `kuksa.val.v2.Value` — not `int32`.
/// Passing a Dart `int` is enough; this package reads the datatype from the
/// databroker and picks the field. Before 0.2.7 this call was impossible
/// through the public API: every Dart `int` went out on `int32` and the
/// databroker answered `Wrong type provided`.
///
/// Not every databroker serves this leaf, so an absent signal is reported
/// rather than allowed to look like a failed write.
Future<void> publishNarrowInteger(KuksaClient client) async {
  const path = kRoadSurfaceCondition;
  try {
    await client.publishValue(path, 4);
    print('[publishValue] $path <- 4 (ICE)');
  } on UnknownSignalPathsException {
    print('[publishValue] $path is not in this databroker\'s VSS — skipped');
  }
}

/// Lists metadata for signals under a path prefix.
Future<void> listMetadata(KuksaClient client) async {
  final response = await client.listMetadata(filter: _path);
  print('[listMetadata] ${response.metadata.length} entry(ies) under $_path');
  for (final m in response.metadata) {
    print('  - ${m.path}');
  }
}

/// Expands a wildcard pattern into the leaf paths this databroker has, and
/// asks whether a signal exists before using it.
///
/// `kuksa.val.v2` takes exact leaf paths in Subscribe/GetValue(s): a wildcard
/// or a branch there answers NOT_FOUND. The expansion is explicit, from the
/// broker's own metadata, so the caller sees the list it is about to subscribe.
Future<void> expand(KuksaClient client) async {
  const pattern = 'Vehicle.ADAS.ESC.**';
  final leaves = await client.expand(pattern);
  print('[expand] $pattern -> ${leaves.length} leaf path(s)');
  for (final p in leaves) {
    print('  - $p');
  }
  print('[hasSignal] $_path: ${await client.hasSignal(_path)}');
  print('[hasSignal] Vehicle.NoSuchSignal: '
      '${await client.hasSignal('Vehicle.NoSuchSignal')}');
}

/// Subscribes to a signal and prints the first update.
///
/// The databroker delivers the signal's current value once on subscribe, then
/// only on subsequent change. For a static signal in a short-lived sample we
/// take the first update and stop, so the demo terminates cleanly. A
/// long-running app would keep the subscription open and react to each change.
Future<void> subscribe(KuksaClient client) async {
  print('[subscribe] watching $_path (first update)...');
  await for (final update in client.subscribe([_path])) {
    final dp = update[_path];
    if (dp != null) {
      print('  update: $_path = ${dp.value}');
      break;
    }
  }
  print('[subscribe] done');
}
