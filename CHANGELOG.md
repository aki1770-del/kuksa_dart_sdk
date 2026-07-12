## 0.1.1

**Corrects a documentation defect that could cause an application to treat an
icy road as a clear one. Please read the "What you must change" section below.**

This is a patch on the 0.1.x line, for consumers whose constraint is `^0.1.0`
and who therefore cannot receive 0.2.x. The same correction is released as
0.2.4 on the 0.2.x line.

### The defect

0.1.0 documented `Vehicle.ADAS.ESC.RoadFriction.MostProbable` as a float in the
range **0.0-1.0**, with the rule "**below 0.3 = icy**". That is not the signal's
contract.

The COVESA Vehicle Signal Specification declares it as:

    datatype: float
    unit: percent
    min: 0
    max: 100
    description: ... 0 = no friction, 100 = maximum friction.

The unit is **percent (0-100)**, not a 0.0-1.0 fraction.

### The impact

An ESC reporting black ice emits a value of roughly `18.0` - that is 18 percent
friction. Application code written against our documented rule evaluates
`18.0 < 0.3`, which is **false**, and therefore concludes the road is *not* icy.
The reading that means "black ice" was documented as a clear road.

The published quickstart made this worse in a second way:

```dart
if ((friction ?? 1.0) < 0.3 || tcsActive) { ... }   // 0.1.0
```

The `?? 1.0` substitutes **full grip** when the friction signal is absent (no
ESC module, or no provider publishing the signal). A missing sensor was turned
into a positive assertion that the road is fine.

### The fix

- All documentation now states the specification's contract: float, percent,
  0-100. The COVESA specification is vendored in `spec/` and the README's signal
  table is generated from it by `tool/gen_signal_table.dart`, so the
  documentation can no longer drift from the standard without CI failing.
- New API: `RoadFriction.classify(double? percent)` returns a
  `RoadFrictionReading` with a tri-state `grip` - `RoadGrip.icy` /
  `RoadGrip.reduced` / `RoadGrip.grip` / `RoadGrip.unknown`.
  - An **absent** reading is `RoadGrip.unknown`, and answers `false` to *both*
    `isIcy` and `isNotIcy`: absence of a measurement is not a claim about the
    road in either direction. `percent` is `null` and `requirePercent()` throws.
  - A value **outside** the 0-100 range (or NaN/infinite) is also
    `RoadGrip.unknown`, with `isContractViolation` set. It is deliberately
    **not clamped**: clamping an out-of-range reading up to the maximum would
    assert perfect grip, which is the same class of failure.
- `example/snow_safety_monitor.dart` uses the new API and reports UNKNOWN when
  no reading is available. It also fixes `info.commit` -> `info.commitHash`,
  which did not compile against the generated protobuf getter.
- Adds CI (analyze, tests, a VSS conformance suite, and a weekly job that
  re-fetches the COVESA specification and fails the build if an upstream change
  would make this package's documentation untrue).

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
  case RoadGrip.unknown:  // no usable reading - do not assume the road is clear
}
```

If your code uses a `?? 1.0`-style default for a missing friction reading,
remove it. Handle the absent case explicitly.

No existing API was removed or changed. The behavioural change is in what the
documentation tells you the number means.

## 0.1.0

- Initial release.
- `KuksaClient`: gRPC client for the `kuksa.val.v2` VAL API.
- `Datapoint`: typed wrapper over protobuf `Datapoint` with per-type accessors.
- Snow-safety signal constants (`kRoadFrictionMostProbable`, `kTcsIsEngaged`, `kAbsIsEngaged`, `kSnowSafetySignals`, and more).
- Support for insecure and TLS-secured connections, optional JWT authentication.
- Generated stubs from `eclipse-kuksa/kuksa-proto` v2 (`kuksa.val.v2`).
