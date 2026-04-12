# kuksa_dart_sdk

[![pub package](https://img.shields.io/pub/v/kuksa_dart_sdk.svg)](https://pub.dev/packages/kuksa_dart_sdk)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

Dart/Flutter client SDK for the [Eclipse KUKSA](https://eclipse.dev/kuksa/) Vehicle Abstraction Layer.

Connects to a running `kuksa-databroker` instance and provides typed access to
[Vehicle Signal Specification (VSS)](https://covesa.github.io/vehicle_signal_specification/)
signals — road friction, traction control, tire pressure, wiper intensity, and more.

Built for driver-assisting navigation applications on embedded Linux IVI systems.

---

## Features

- **gRPC-based** — uses the `kuksa.val.v2` VAL API (databroker v0.5+)
- **Typed signal access** — `floatValue`, `boolValue`, `int32Value`, etc. without protobuf boilerplate
- **Snow-safety signal set** — pre-defined `kSnowSafetySignals` covering ESC friction, TCS, ABS, wiper intensity, temperature, TPMS
- **Streaming subscriptions** — continuous updates as a Dart `Stream<Map<String, Datapoint>>`
- **Batch reads** — read multiple signals in one gRPC call
- **Secure + insecure** — optional JWT token and TLS certificate support

---

## Quick Start

```yaml
# pubspec.yaml
dependencies:
  kuksa_dart_sdk: ^0.1.0
```

```dart
import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

final client = KuksaClient(host: 'localhost', port: 55555);
await client.connect();

// One-shot read
final dp = await client.getValue(kRoadFrictionMostProbable);
print('Road friction: ${dp.floatValue}');   // 0.0–1.0; < 0.3 = icy road

// Subscribe to all snow-safety signals
await for (final update in client.subscribe(kSnowSafetySignals)) {
  final friction = update[kRoadFrictionMostProbable]?.floatValue;
  final tcsActive = update[kTcsIsEngaged]?.boolValue ?? false;

  if ((friction ?? 1.0) < 0.3 || tcsActive) {
    // Activate snow routing mode in your navigation BLoC
  }
}

await client.dispose();
```

---

## Signal Constants

`signal_path.dart` exports named constants for the most common driver-safety signals:

| Constant | VSS Path | Type | Notes |
|---|---|---|---|
| `kRoadFrictionMostProbable` | `Vehicle.ADAS.ESC.RoadFriction.MostProbable` | float | 0.0–1.0; < 0.3 = icy |
| `kTcsIsEngaged` | `Vehicle.ADAS.TCS.IsEngaged` | bool | Active traction loss |
| `kAbsIsEngaged` | `Vehicle.ADAS.ABS.IsEngaged` | bool | ABS braking event |
| `kWiperFrontIntensity` | `Vehicle.Body.Windshield.Front.Wiping.Intensity` | uint8 | Precipitation proxy |
| `kAirTemperature` | `Vehicle.Exterior.AirTemperature` | float | °C; < 2°C + precip = snow |
| `kRoadSurfaceCondition` | `Vehicle.Exterior.RoadSurfaceCondition` | string | Requires VSS PR #892 |
| `kSnowSafetySignals` | — | `List<String>` | All snow signals as a list |

---

## Prerequisites

- A running [kuksa-databroker](https://github.com/eclipse-kuksa/kuksa-databroker) v0.5+
- Dart SDK ≥ 3.0.0

For development on embedded Linux IVI (e.g., Raspberry Pi 4, Renesas R-Car):

```bash
# Start databroker in mock mode (no real vehicle required)
docker run --rm -p 55555:55555 ghcr.io/eclipse-kuksa/kuksa-databroker:latest --mock-datapoints
```

---

## Architecture

```
Flutter / Dart app
       │
       ▼
 KuksaClient (this package)
       │  gRPC (kuksa.val.v2 / VAL service)
       ▼
 kuksa-databroker  ──────────────────── Vehicle ECUs
       │                                  (CAN, SOME/IP, LIN)
       ▼
  VSS signals: friction, TCS, ABS, wiper, temperature, TPMS
```

This package is part of the [SNGNav](https://github.com/aki1770) winter navigation stack.
The `navigation_safety` package consumes KUKSA signals via `kuksa_dart_sdk` to adapt
routing decisions in real-time based on road surface conditions.

---

## Contributing

Issues and PRs welcome. Please file an issue before a large change.

*AI-assisted — authored with Claude, reviewed by Komada.*
