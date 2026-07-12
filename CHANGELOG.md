## 0.2.4

**Corrects a documentation defect that could cause an application to treat an
icy road as a clear one. Please read the "What you must change" section below.**

### The defect

Versions 0.1.0 through 0.2.3 documented
`Vehicle.ADAS.ESC.RoadFriction.MostProbable` as a float in the range **0.0–1.0**,
with the rule "**below 0.3 = icy**". That is not the signal's contract.

The COVESA Vehicle Signal Specification declares it as:

    datatype: float
    unit: percent
    min: 0
    max: 100
    description: ... 0 = no friction, 100 = maximum friction.

The unit is **percent (0–100)**, not a 0.0–1.0 fraction.

### The impact

An ESC reporting black ice emits a value of roughly `18.0` — that is 18 percent
friction. Application code written against our documented rule evaluates
`18.0 < 0.3`, which is **false**, and therefore concludes the road is *not* icy.
The reading that means "black ice" was documented as a clear road.

The published quickstart made this worse in a second way:

```dart
if ((friction ?? 1.0) < 0.3 || tcsActive) { ... }   // 0.2.3 and earlier
```

The `?? 1.0` substitutes **full grip** when the friction signal is absent
(no ESC module, or no provider publishing the signal). A missing sensor was
turned into a positive assertion that the road is fine.

The wrong range was documented in five places: `lib/src/client/signal_path.dart`,
the library doc comment in `lib/kuksa_dart_sdk.dart`, the README quickstart, the
README signal table, and `example/snow_safety_monitor.dart`.

### The fix

- All documentation now states the specification's contract: float, percent,
  0–100. The COVESA specification is vendored in `spec/` and the README's signal
  table is generated from it by `tool/gen_signal_table.dart`, so the
  documentation can no longer drift away from the standard without CI failing.
- New API: `RoadFriction.classify(double? percent)` returns a
  `RoadFrictionReading` with a tri-state `grip` — `RoadGrip.icy` /
  `RoadGrip.reduced` / `RoadGrip.grip` / `RoadGrip.unknown`. Use it instead of
  comparing the raw double.
  - An **absent** reading is `RoadGrip.unknown`. It answers `false` to *both*
    `isIcy` and `isNotIcy`: absence of a measurement is not a claim about the
    road in either direction. There is no default value to fall back to —
    `percent` is `null` and `requirePercent()` throws.
  - A value **outside** the specification's 0–100 range (or NaN/infinite) is
    also `RoadGrip.unknown`, with `isContractViolation` set. It is deliberately
    **not clamped**: clamping an out-of-range reading up to the maximum would
    assert perfect grip, which is the same class of failure. The producer is
    violating the specification, and the honest answer is that the value is
    unusable.
- `example/snow_safety_monitor.dart` and the Flutter example now use the new
  API and display UNKNOWN when no reading is available.
- Also corrected against the specification: `Vehicle.Exterior.RoadSurfaceCondition`
  is a **uint8 enum** (0 UNKNOWN … 7 LOOSE_GRAVEL), not a string;
  `Windshield.Front.Wiping.Intensity` is a uint8 **actuator** with no maximum
  declared by VSS (it is the requested wiper sensitivity, not a rain sensor, and
  has no significance in OFF/SLOW/MEDIUM/FAST modes) — prefer
  `Vehicle.Body.Raindetection.Intensity` (a sensor, percent 0–100) for
  precipitation.
- This package previously had no CI. It now runs `dart analyze`, the full test
  suite including a VSS conformance suite, a README-is-generated-from-spec check,
  and a weekly job that re-fetches the COVESA specification and fails the build
  if a documented signal's datatype, unit or range has changed upstream.

### What you must change

If your code compares the raw friction value against a fraction-scale threshold
(for example `friction < 0.3`), **it is currently misreading the signal** and
will not detect ice. Either move your threshold onto the percent scale
(`< 30`), or switch to the classifier:

```dart
final road = RoadFriction.classifyDatapoint(update[kRoadFrictionMostProbable]);
switch (road.grip) {
  case RoadGrip.icy:      // measured ice
  case RoadGrip.reduced:  // measured reduced grip
  case RoadGrip.grip:     // measured normal grip
  case RoadGrip.unknown:  // no usable reading — do not assume the road is clear
}
```

If your code uses a `?? 1.0`-style default for a missing friction reading,
remove it. Handle the absent case explicitly.

No existing API was removed or changed; this release is additive at the source
level. The behavioural change is in what the documentation tells you the number
means.

## 0.2.3

- Add `publishValue(path, value)` and `publishDatapoint(path, datapoint)` to
  `KuksaClient` — thin, additive wrappers over the generated `kuksa.val.v2`
  `publishValue` stub. `publishValue` maps Dart runtime types (`bool`/`int`/
  `double`/`String`) to the VSS `Value` oneof; `publishDatapoint` is the escape
  hatch for unsigned/64-bit/array/timestamped values. No breaking changes.
- Add `example/kuksa_val_v2.dart` — a vendor-neutral sample mirroring the
  upstream Rust/Python `kuksa.val.v2` examples (connect → getServerInfo →
  getValue → publishValue → listMetadata → subscribe on `Vehicle.Speed`).
  BDE-verified green against `kuksa-databroker:main` (0.7.0-dev.0, VSS 6.0).
- `example/README.md`: upstream-style quickstart (databroker `docker run` +
  connect→subscribe→read→write); `snow_safety_monitor.dart` retained as the
  domain showcase.

## 0.2.2

- Add `SPDX-License-Identifier: Apache-2.0` headers to all hand-authored Dart
  sources (5 files) for Eclipse machine-readable license-compliance (per
  eclipse-kuksa/kuksa-actions SPDX check). Generated protoc output under
  `lib/src/generated/` is left to the codegen step and not hand-edited.
  `LICENSE` (canonical verbatim Apache-2.0) is unchanged — license detection
  reads that file, not source headers.

## 0.2.1

- Fix `license:unknown` by replacing `LICENSE` with the canonical, verbatim
  Apache-2.0 text. The 0.2.0 change *added* an `SPDX-License-Identifier`
  header line above the license body — that prepended line (plus an
  abbreviated body) is precisely what dropped the file below the license
  detector's similarity threshold, so 0.2.0 still scored `license:unknown`.
  `pana` now reports `10/10 points: Use an OSI-approved license — Detected
  license: Apache-2.0`. Apache-2.0 retained to match Eclipse KUKSA upstream.

## 0.2.0

- Add `SPDX-License-Identifier: Apache-2.0` header to `LICENSE` so pana
  recognizes the package as Apache-2.0 rather than `license:unknown`
  (recovers ~30 pub-points on the licensing axis).
- Update `homepage`, `repository`, and `issue_tracker` URLs in `pubspec.yaml`
  from `aki1770/kuksa_dart_sdk` to the canonical `aki1770-del/kuksa_dart_sdk`
  (the `aki1770/` URL had returned HTTP 404).
- Fix `example/snow_safety_monitor.dart`: `info.commit` → `info.commitHash`
  (the generated protobuf getter is `commitHash`, mapping the `commit_hash`
  field). One-character fix surfaced by `dart analyze` during 0.2.0
  preparation; pre-existing in 0.1.0.
- Otherwise mechanical metadata fix only; no SDK source changes.

## 0.1.0

- Initial release.
- `KuksaClient`: gRPC client for the `kuksa.val.v2` VAL API.
- `Datapoint`: typed wrapper over protobuf `Datapoint` with per-type accessors.
- Snow-safety signal constants (`kRoadFrictionMostProbable`, `kTcsIsEngaged`, `kAbsIsEngaged`, `kSnowSafetySignals`, and more).
- Support for insecure and TLS-secured connections, optional JWT authentication.
- Generated stubs from `eclipse-kuksa/kuksa-proto` v2 (`kuksa.val.v2`).
