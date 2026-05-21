# kuksa_dart_sdk examples

## Snow safety monitor

[`snow_safety_monitor.dart`](snow_safety_monitor.dart) connects to a KUKSA
databroker on an IVI headunit and reacts to road-condition signals in real
time — a one-shot read of road friction, then a continuous subscription that
surfaces snow-safety conditions for driver-assisting navigation.

Run it against a local databroker:

```sh
dart run example/snow_safety_monitor.dart
```

```dart
import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

void main() async {
  final client = KuksaClient(host: 'localhost', port: 55555);
  await client.connect();

  final friction = await client.getValue(kRoadFrictionMostProbable);
  if (friction.hasValue) {
    print('Current road friction: ${friction.floatValue?.toStringAsFixed(2)}');
  }
}
```
