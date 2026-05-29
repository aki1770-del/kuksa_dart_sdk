# kuksa_dart_sdk examples

## Quickstart

Start a [kuksa-databroker](https://github.com/eclipse-kuksa/kuksa-databroker)
locally (insecure, no auth — typical for development):

```sh
docker run --rm -it -p 55555:55555 \
  ghcr.io/eclipse-kuksa/kuksa-databroker:latest --insecure
```

Then run the vendor-neutral sample:

```sh
dart run example/kuksa_val_v2.dart
```

[`kuksa_val_v2.dart`](kuksa_val_v2.dart) mirrors the upstream Rust
`kuksa_val_v2.rs` example — it connects, then exercises each core API
(server info, read, write, subscribe, metadata):

```dart
import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

void main() async {
  final client = KuksaClient(host: 'localhost', port: 55555);
  await client.connect();

  // Server info
  final info = await client.getServerInfo();
  print('${info.name} ${info.version}');

  // Subscribe to a signal
  final sub = client.subscribe(['Vehicle.Speed']).listen((update) {
    print('Vehicle.Speed = ${update['Vehicle.Speed']?.value}');
  });

  // Read a signal
  final dp = await client.getValue('Vehicle.Speed');
  print('Vehicle.Speed = ${dp.value}');

  // Write (publish) a signal
  await client.publishValue('Vehicle.Speed', 100.34);

  await sub.cancel();
  await client.dispose();
}
```

## Snow safety monitor

[`snow_safety_monitor.dart`](snow_safety_monitor.dart) is a domain showcase:
it connects to a databroker on an IVI headunit and reacts to road-condition
signals in real time — a one-shot read of road friction, then a continuous
subscription that surfaces snow-safety conditions for driver-assisting
navigation.

```sh
dart run example/snow_safety_monitor.dart
```
