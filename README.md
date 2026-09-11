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
- **Survives a vehicle that lacks a signal** — `subscribeAvailable` streams what this car has and names what it does not, in one call; `kuksa.val.v2` subscribes all-or-nothing, so one absent leaf otherwise delivers nothing at all
- **Streaming subscriptions** — continuous updates as a Dart `Stream<Map<String, Datapoint>>`
- **Batch reads** — read multiple signals in one gRPC call
- **Secure + insecure** — optional JWT token and TLS certificate support

---

## Quick Start

```yaml
# pubspec.yaml
dependencies:
  kuksa_dart_sdk: ^0.2.4
```

```dart
import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

final client = KuksaClient(host: 'localhost', port: 55555);
await client.connect();

// One-shot read
final dp = await client.getValue(kRoadFrictionMostProbable);
print(RoadFriction.classifyDatapoint(dp));  // e.g. "RoadFrictionReading(18.0% → icy)"

// Subscribe to the snow-safety signals THIS vehicle has, and be told which
// it lacks. `subscribe()` is all-or-nothing: one absent leaf delivers nothing.
final sub = await client.subscribeAvailable(kSnowSafetySignals);
if (sub.isDegraded) {
  // Unmeasured is not safe. Show the driver which readings are missing.
  print('not on this vehicle: ${sub.notOnThisVehicle.join(', ')}');
}

await for (final update in sub.updates) {
  final road = RoadFriction.classifyDatapoint(update[kRoadFrictionMostProbable]);
  final tcsActive = update[kTcsIsEngaged]?.boolValue ?? false;

  switch (road.grip) {
    case RoadGrip.icy:      // measured ice — activate snow routing mode
    case RoadGrip.reduced:  // measured reduced grip
    case RoadGrip.grip:     // measured normal grip
      if (tcsActive) { /* traction loss despite a good reading */ }
    case RoadGrip.unknown:  // NO reading (absent signal, or out-of-spec value)
      // Show the driver that conditions are UNKNOWN.
      // Do not assume the road is clear.
  }
}

await client.dispose();
```

---

## Decide before you subscribe

`kuksa.val.v2` `Subscribe` (and `GetValues`) is **all-or-nothing, by design**
([eclipse-kuksa/kuksa-databroker#230](https://github.com/eclipse-kuksa/kuksa-databroker/issues/230)):
one path the databroker does not know fails the whole request with
`NOT_FOUND`, nothing is delivered for the paths it does know, and the broker's
message — `Path not found` — does not say which. Vehicles differ in which VSS
leaves they expose, so a six-signal road-condition subscription dies on the one
leaf a deployment lacks.

**One call does this**: `subscribeAvailable` subscribes to what the vehicle
has and hands you the names of what it does not, together — you cannot hold
the stream without holding the verdict.

```dart
final sub = await client.subscribeAvailable(kSnowSafetySignals);

sub.available;         // subscribed — never empty
sub.notOnThisVehicle;  // absent here; UNMEASURED, not safe
sub.isDegraded;        // true when the picture is partial — say so

await for (final update in sub.updates) { /* ... */ }
```

It throws `UnknownSignalPathsException`, naming every path, when the vehicle
has **none** of them — a car that cannot measure the road at all is a fact the
driver is owed, not an empty stream. It costs one metadata round-trip per path
before the stream opens, which is why it is opt-in and not what `subscribe`
does.

Or ask and choose by hand — work, work degraded, or refuse:

```dart
final missing = await client.missingSignals(kSnowSafetySignals); // Set<String>
if (missing.isNotEmpty) {
  // Tell the driver these readings are UNMEASURED. Absence is not a clear road.
}
final have = [for (final p in kSnowSafetySignals) if (!missing.contains(p)) p];
if (have.isEmpty) throw StateError('this vehicle exposes none of them');
await for (final update in client.subscribe(have)) { /* ... */ }

await client.hasSignal('Vehicle.Speed');                        // true
await client.hasSignals(['Vehicle.Speed', 'Vehicle.NoSuch']);   // false
```

Guard `have.isEmpty` yourself on that path: `subscribe([])` reaches the broker
and comes back `INVALID_ARGUMENT` — "No valid id or path specified" — which
reads as a mistake you made, and says nothing about the vehicle that has none
of them. `subscribeAvailable` keeps the two apart for you.

Only `NOT_FOUND` counts as missing. An unreachable broker **throws** — reporting
its signals as absent would tell an app to run degraded when the bus is down.

If you subscribe without checking, the stream errors with
`UnknownSignalPathsException` **naming the unknown paths** — this package
resolves them from the broker's metadata — and delivers no data first.
`await for` rethrows it. An `onError` that only logs is where that name goes
to die; ours did (see the changelog).

### Wildcards: `expand()`

`Subscribe`/`GetValue(s)` take exact leaf paths. `Vehicle.ADAS.*`,
`Vehicle.**` and the branch `Vehicle.ADAS` all answer `NOT_FOUND` (measured,
databroker 0.7.1). Turn a pattern into leaves explicitly, from the broker's own
metadata:

```dart
final tyres = await client.expand('Vehicle.**.Tire.Pressure');
final esc = await client.expand('Vehicle.ADAS.ESC');              // a branch
final sensors = await client.expand('Vehicle.ADAS.**',
    entryType: VssEntryType.sensor);
await for (final update in client.subscribe(tyres)) { /* ... */ }
```

`*` matches one segment, `**` any number; a pattern with no wildcard is a
branch and yields every leaf under it. The rule is the redesigned Python
client's, so a pattern means one thing in both SDKs. An empty result means
nothing matched — including a branch this vehicle does not have.

---

## Road friction

`Vehicle.ADAS.ESC.RoadFriction.MostProbable` is declared by VSS as
`datatype: float`, `unit: percent`, `min: 0`, `max: 100` —
*"0 = no friction, 100 = maximum friction"*.

It is **not** a 0.0–1.0 fraction. An ESC on black ice reports about `18.0`.
Code that compares the raw value against a fraction-scale threshold such as
`< 0.3` will classify black ice as a clear road.

`RoadFriction.classify(double? percent)` returns a `RoadFrictionReading`:

| Reading | `grip` | Meaning |
|---|---|---|
| `18.0` | `RoadGrip.icy` | measured ice / very low grip (below 30 percent) |
| `45.0` | `RoadGrip.reduced` | measured reduced grip (below 60 percent) |
| `87.0` | `RoadGrip.grip` | measured normal grip |
| `null` | `RoadGrip.unknown` | **no reading** — signal absent or no provider |
| `120.0`, `NaN` | `RoadGrip.unknown` (`isContractViolation`) | producer emitted a value outside the VSS range |

Two properties this API guarantees:

- **An absent reading is never a safe value.** `unknown` answers `false` to
  *both* `isIcy` and `isNotIcy`. Absence of a measurement is not a claim about
  the road in either direction. There is no `?? 1.0`-style default to reach for:
  `percent` is `null`, and `requirePercent()` throws.
- **An out-of-range value is never coerced.** It is not clamped (clamping `120`
  to the maximum would assert *perfect grip*) and not rescaled. The producer is
  violating the specification; the honest answer is `unknown`.

The 30 / 60 percent thresholds are this package's advisory choice. VSS defines
the scale, not the driving semantics.

---

## Signal Constants

`signal_path.dart` exports named constants for the most common driver-safety
signals. The table below is **generated from the COVESA specification vendored
in [`spec/`](spec/)** by `tool/gen_signal_table.dart`, and CI fails if it drifts.

<!-- BEGIN GENERATED SIGNAL TABLE -->
<!-- Generated by tool/gen_signal_table.dart from the vendored COVESA spec in spec/. Do not edit by hand. -->

| Constant | VSS path | Datatype | Unit / range (per VSS) | In `kSnowSafetySignals` |
|---|---|---|---|---|
| `kRoadFrictionMostProbable` | `Vehicle.ADAS.ESC.RoadFriction.MostProbable` | float (sensor) | percent, 0–100 | yes |
| `kRoadFrictionLowerBound` | `Vehicle.ADAS.ESC.RoadFriction.LowerBound` | float (sensor) | percent, 0–100 | yes |
| `kRoadFrictionUpperBound` | `Vehicle.ADAS.ESC.RoadFriction.UpperBound` | float (sensor) | percent, 0–100 | no |
| `kTcsIsEngaged` | `Vehicle.ADAS.TCS.IsEngaged` | boolean (sensor) | no range declared | yes |
| `kAbsIsEngaged` | `Vehicle.ADAS.ABS.IsEngaged` | boolean (sensor) | no range declared | yes |
| `kWiperFrontIntensity` | `Vehicle.Body.Windshield.Front.Wiping.Intensity` | uint8 (actuator) | no range declared | yes |
| `kRaindetectionIntensity` | `Vehicle.Body.Raindetection.Intensity` | uint8 (sensor) | percent, max 100 | yes |
| `kAirTemperature` | `Vehicle.Exterior.AirTemperature` | float (sensor) | Celsius, no range declared | yes |
| `kRoadSurfaceCondition` | `Vehicle.Exterior.RoadSurfaceCondition` | uint8 (sensor) | UNKNOWN \| DRY \| WET \| SNOW \| ICE \| SLUSH \| WET_ICE \| LOOSE_GRAVEL | no |
| `kTirePressureFrontLeft` | `Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.Pressure` | uint16 (sensor) | kPa, no range declared | yes |
| `kTirePressureFrontRight` | `Vehicle.Chassis.Axle.Row1.Wheel.Right.Tire.Pressure` | uint16 (sensor) | kPa, no range declared | yes |
| `kVehicleSpeed` | `Vehicle.Speed` | float (sensor) | km/h, no range declared | yes |
| `kSnowSafetySignals` | — | `List<String>` | 10 of the 12 signals above as one subscription list; excludes `kRoadFrictionUpperBound`, `kRoadSurfaceCondition` |

`Vehicle.ADAS.ESC.RoadFriction.MostProbable` is a **percent** value (0–100), **not** a 0.0–1.0 fraction: an ESC on black ice reports about `18.0`. Classify it with `RoadFriction.classify` — see [Road friction](#road-friction).
<!-- END GENERATED SIGNAL TABLE -->

---

## Publishing values

`publishValue` encodes for the **signal**, not for the Dart value:

```dart
await client.publishValue(kVehicleSpeed, 100.34);        // float
await client.publishValue(kRoadSurfaceCondition, 4);     // uint8 enum -> ICE
await client.publishValue('Vehicle.Diagnostics.DTCList', ['P0001']);
```

A Dart `int` cannot tell a client which wire field to use. `kuksa.val.v2.Value`
has one `uint32` field carrying every `uint8`, `uint16` and `uint32` signal, and
one `int32` field carrying every `int8`, `int16` and `int32` signal — and VSS
6.1rc2 declares just **9 of its 1382 leaves** as `int32`, against **411** narrow
integers. So the datatype is read from the databroker's own signal metadata
(once per path, then cached) and the value is encoded into the field that
databroker accepts.

| VSS datatype | Dart value you pass |
|---|---|
| `boolean` | `bool` |
| `string` | `String` |
| `int8` `int16` `int32` `int64` | `int` |
| `uint8` `uint16` `uint32` `uint64` | `int` |
| `float` `double` | `double`, or `int` (widened) |
| any `…[]` datatype | `List` of the above |

An `int` written to a `float` signal is widened. A `double` written to an
integer signal is **refused**, not rounded: a silently truncated value on a
safety signal cannot be told apart from a measured one. Out-of-range integers
are refused with the VSS datatype and the bound named.

To skip the metadata lookup — a provider writing one signal in a loop, or a test
that must not depend on broker metadata — state the datatype yourself:

```dart
await client.publishTyped(kRoadSurfaceCondition, VssDataType.uint8, 4);
```

`publishTyped` needs no protobuf import. `publishDatapoint` still takes a
generated `kuksa.val.v2.Datapoint` and remains for consumers of 0.2.6 and
earlier, but it is not the recommended surface: that type collides by name with
this package's own `Datapoint`, so reaching it means a prefixed import of
`src/generated/…`, a private path carrying no stability promise.

`kuksa.val.v2.Value` has no timestamp field, so a `timestamp` signal cannot be
published by any client of this API. That is reported as such rather than
guessed at.

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

This package is part of the [SNGNav](https://github.com/aki1770-del/SNGNav) winter navigation stack.
The `navigation_safety` package consumes KUKSA signals via `kuksa_dart_sdk` to adapt
routing decisions in real-time based on road surface conditions.

---

## Third-party dependencies and the Eclipse Dash input

`DEPENDENCIES` is **generated, never hand-written**, and this section exists so
anyone — including the Eclipse Dash tooling maintainers — can reproduce it.

**The Dash input (one coordinate per line):**

```sh
tool/gen_dependencies.sh --coordinates
```

**The annotated manifest committed as `DEPENDENCIES`:**

```sh
tool/gen_dependencies.sh > DEPENDENCIES
```

The coordinate line is the whole of it — a `dart pub deps` walk reshaped into
Dash's `pub/pub.dev/-/<name>/<version>` form:

```sh
dart pub deps --no-dev --style=list \
  | sed -n 's|^- \([a-zA-Z0-9_]*\) \(.*\)$|pub/pub.dev/-/\1/\2|p' \
  | sort
```

⚑ **`--no-dev` is load-bearing, not tidiness.** This is a library: its dev
dependencies (test, lints, and their transitives) are never distributed and must
not appear in an IP review.

⚑ **Do not filter `dart pub deps --json` by `kind == "transitive"` instead.** A
*dev* dependency's transitives are also `"transitive"`, so that filter silently
admits packages you do not ship. Use `--no-dev`, or walk the graph from
`root.directDependencies`.

⚑ **Versions resolve live, so a clean checkout may not reproduce the committed
file byte for byte.** `pubspec.lock` is deliberately not committed — a library
must not pin its consumers — so `dart pub deps` reports whatever each range
resolves to on the day you run it. Measured while writing this: a pristine
checkout resolved `clock` and `stack_trace` one patch version ahead of what
`DEPENDENCIES` records. The coordinate list is regenerated on every run and is
what Dash consumes; treat the committed annotated file as a snapshot and
regenerate before relying on it.

`tool/spdx_from_cache.py` and `tool/render_dependencies.py` add the licence
column from the local pub cache; the coordinate command above is sufficient on
its own if you only need Dash input.

## Contributing

Issues and PRs welcome. Please file an issue before a large change.

*AI-assisted — authored with Claude, reviewed by Komada.*
