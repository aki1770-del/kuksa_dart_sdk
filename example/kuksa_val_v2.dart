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
    await listMetadata(client);
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
Future<void> publishValue(KuksaClient client) async {
  await client.publishValue(_path, 100.34);
  print('[publishValue] $_path <- 100.34');
}

/// Lists metadata for signals under a path prefix.
Future<void> listMetadata(KuksaClient client) async {
  final response = await client.listMetadata(filter: _path);
  print('[listMetadata] ${response.metadata.length} entry(ies) under $_path');
  for (final m in response.metadata) {
    print('  - ${m.path}');
  }
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
