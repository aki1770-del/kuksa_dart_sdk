## 0.2.8

### The signal a vehicle lacks is now named. Our issue said it was silent; the silence was ours

We filed [eclipse-kuksa/kuksa-databroker#230](https://github.com/eclipse-kuksa/kuksa-databroker/issues/230):
one unknown VSS path in a multi-path `Subscribe` fails the whole request with
`NOT_FOUND`, so a road-condition subscription of six safety signals dies on the
one leaf a deployment lacks — *"with no error surfaced to the user."* The
maintainer's answer, in short: all-or-nothing is a design choice, because a
caller asking for several signals *"knows what he is doing"*. His own words, quoted as
he wrote them — spelling, spacing and punctuation left exactly as they are:

> the idea is to have databroker as "deterministic" and "non-surprising" as possible, and thus not hide to many magic there. "Useful Magic" should  go to API abstractions.

> I would expect the GRPC API to give you an error when not all subscriptions can be fullfileld. But I have not checked the code  just now

His second sentence ends there, without a full stop, and the typo is his.

He is right. Measured against databroker 0.7.1: the broker answered `NOT_FOUND`,
this package passed it through unchanged as a `GrpcError`, and the silence was
downstream of both — in our own consuming app, whose stream layer turned the
error into an "unavailable" update carrying the message, and whose UI read the
flag, discarded the message, and showed its simulated default. The sentence in
our issue was true about what the driver saw and wrong about who was
responsible for it.

What this package got wrong on its own:

- **The error was untyped and named no path.** The broker's message is the bare
  `Path not found`, even with three paths in the request; a consumer had to
  guess which of six leaves the vehicle lacked.
- **`getValues` documented that an unknown signal** *"is represented as a
  Datapoint with hasValue == false."* It never was: the call failed with
  `NOT_FOUND`, exactly like `Subscribe`.
- **`subscribe` documented a broadcast stream.** It is single-subscription.

### Decide before you subscribe

The shape follows the redesigned Python client's `has_signal(s)` /
`missing_signals` / `expand`, which the maintainer pointed to, so a pattern or a
check means one thing in both SDKs:

- **`missingSignals(paths)`** returns the subset this databroker does not know,
  in request order; **`hasSignals(paths)`** and **`hasSignal(path)`** are the
  boolean forms. Only `NOT_FOUND` counts as missing — an unreachable broker
  throws, because "absent" would tell an app to run degraded when the bus is
  down. An app can now choose to work, to work degraded with the absent readings
  shown as unmeasured, or to refuse, *before* the subscription fails.
- **`expand(pattern, {entryType})`** turns a wildcard pattern or a branch into
  the concrete leaf paths this databroker has, sorted. `kuksa.val.v2` accepts
  exact leaves only — `Vehicle.ADAS.*`, `Vehicle.**` and the branch
  `Vehicle.ADAS` all answer `NOT_FOUND` in `Subscribe`/`GetValues` (measured) —
  so the match runs client-side over one `ListMetadata` call bounded by the
  pattern's literal prefix, and never relies on the broker's wildcard support,
  which its own proto says *"may be removed in a future release."* `*` is one
  segment, `**` any number; a pattern with no wildcard is a branch.
  `SignalPattern` carries the rule; `VssEntryType` filters by sensor, actuator
  or attribute without a protobuf import.

### When you did not check, the error names the leaf

`subscribe`, `getValues` and `getValue` now fail with
`UnknownSignalPathsException` **naming the unknown paths** — resolved from
metadata here, since the broker does not — with `requested` and the broker's own
message attached, and no data delivered first. `await for` rethrows it; `.first`
rethrows it. A wildcard passed as a path earns a pointer to `expand()`. If the
follow-up lookup itself fails, the error says the culprit could not be
determined; it never says "nothing missing".

**This is the one behaviour change in 0.2.8, and it is on the error path.**
0.2.7 let the broker's `GrpcError` with `code == StatusCode.notFound` through
raw from `subscribe` (as a stream error), `getValues` and `getValue`. 0.2.8
throws `UnknownSignalPathsException` there instead. It implements `Exception`,
not `GrpcError`, and has no `.code`. A handler written as
`on GrpcError catch (e) { if (e.code == StatusCode.notFound) … }`, or a stream
`onError` testing `e is GrpcError && e.code == StatusCode.notFound`, **stops
matching** and must test `e is UnknownSignalPathsException` — the unknown
paths are on `e.paths`, the broker's original text on `e.brokerMessage`. Every
other status (`UNAVAILABLE`, `UNAUTHENTICATED`, `PERMISSION_DENIED`,
`INVALID_ARGUMENT`) still arrives as `GrpcError`, unchanged, and
`resolveDataType` already threw `UnknownSignalPathsException` in 0.2.7. The
failure now also costs one metadata round-trip per requested path, on the
error path only, to resolve the names. Shipped inside the `^0.2.x` range: no
consumer we could find filters on that code, and a `NOT_FOUND` nobody could
act on was the defect — if your code does filter on it, this is the paragraph
to read.

**Announced for 0.3.0.** `subscribe(skipUnknownPaths: true)` without
`onUnknownPaths` still drops the unknown paths silently — the one silence this
release leaves in place, because making the callback required is a breaking
change that the `^0.2.x` range would never deliver. **0.3.0 will require
`onUnknownPaths` whenever `skipUnknownPaths` is `true`.** Pass it now and 0.3.0
changes nothing for you.

`listMetadata`'s `filter` parameter is documented for what it is: the request's
`root`. The wire message's own `filter` field is ignored by databroker 0.7.1
(measured: `root: Vehicle, filter: Vehicle.Speed` returns all 1 263 entries).

The `flutter_conditions` example now asks `missingSignals` first, subscribes to
what the vehicle has, lists the rest under *Not on this vehicle*, and names the
signals when there are none to subscribe to instead of showing "Signal lost".
`snow_safety_monitor.dart` does the same in the console.

## 0.2.7

### 31 % of the specification could not be written through this package

`publishValue` mapped **every** Dart `int` to the `int32` field of
`kuksa.val.v2.Value`. Measured against the COVESA VSS 6.1rc2 release
(`vss.json`, 1382 leaves): **9 leaves are `int32`. 411 are `uint8`, `uint16`,
`int16`, `int8` or `uint32`, and 23 more are arrays.** A Dart `int` cannot
choose the field on its own — `uint8`, `uint16` and `uint32` all travel in the
`uint32` field, `int8`/`int16`/`int32` all travel in `int32` — so the runtime
type of the value is the wrong thing to look at.

**`Vehicle.Exterior.RoadSurfaceCondition` could not be published at all.** It is
a `uint8` enum (4 = ICE), and a real databroker answered:

```
gRPC Error (code: 3, INVALID_ARGUMENT, message: Wrong type provided (id: 891))
```

That path is the first signal this project merged into VSS. Our own SDK could
not write it.

The documented escape — "construct the `Value` yourself and use
`publishDatapoint`" — did not work either. `publishDatapoint` takes the
generated `kuksa.val.v2.Datapoint`, `lib/kuksa_dart_sdk.dart` exports no
generated file, and importing one alongside the barrel gives **two classes
named `Datapoint`**: `ambiguous_import`, a hard analyzer error whose text reads
as the caller's mistake rather than ours. The only route that compiled was a
prefixed import of `package:kuksa_dart_sdk/src/generated/…`, a private path
carrying no stability promise, and nothing said so.

**If you publish integer or array signals, they were failing.** Not silently:
the databroker rejected the write with `INVALID_ARGUMENT`. A provider whose
error handling only logs has been writing nothing to those signals.

### The wire type now follows the signal

`publishValue` reads the signal's declared VSS datatype from the databroker's
own metadata — once per path, then cached — and encodes into the field that
databroker accepts. Every VSS datatype the wire format can carry is covered,
including the unsigned families, 64-bit families and arrays.

```dart
await client.publishValue(kRoadSurfaceCondition, 4);     // uint8  -> ICE
await client.publishValue('Vehicle.Diagnostics.DTCList', ['P0001']);
await client.publishValue(kVehicleSpeed, 100);           // int widened to float
```

The **databroker**, not a vendored copy of the specification, is the authority.
A vehicle serves the leaves it actually has plus whatever overlay its integrator
added, and only the broker knows that set. The spec files vendored in `spec/`
declare 177 un-instanced leaves — 12.8 % of the 1382-leaf expanded tree — so
driving the encoding from them would have fixed an eighth of the problem while
looking like a fix for all of it.

- **`publishTyped(path, VssDataType, value)`** states the datatype explicitly
  and skips the metadata lookup. It needs no protobuf import, and is the
  supported way to control the encoding.
- **`resolveDataType(path)`** returns the datatype the databroker declares.
- **`VssDataType`, `ValueArm`, `wireArmFor`, `encodeVssValue`, `armOf`** are
  exported: the datatype-to-field table is a public, tested artifact rather than
  a branch buried in the client.
- An `int` written to a `float` or `double` signal is widened. A `double`
  written to an integer signal is **refused, not rounded**: a silently truncated
  value on a safety signal cannot be told apart from a measured one.
- Out-of-range integers raise **`VssTypeMismatch`**, naming the path, the VSS
  datatype and the bound. The databroker's own rejection says only
  `Value out of type bounds (id: 891)` — no path, no datatype, no limit.
- `kuksa.val.v2.Value` has no timestamp field, so `timestamp` signals cannot be
  published by any client of this API. That is now reported as a limit of the
  wire format instead of failing as a type error.
- An unknown path raises `UnknownSignalPathsException` rather than a raw
  `NOT_FOUND`. Only `NOT_FOUND` is read as absence; every other gRPC failure is
  rethrown, because a broker that is unreachable has told us nothing about the
  signal.

### Why the green test suite never caught it

`test/kuksa_dart_sdk_test.dart` asserted that `kRoadSurfaceCondition` carries a
**string**, while `signal_path.dart` documented it as *"uint8 enum (NOT a
string)"* and the vendored spec agreed. **The suite encoded the wrong contract
for the exact signal whose contract was being got wrong on the wire** — and it
could not have failed on it either way, because it built the protobuf
`Datapoint` by hand and then asserted what it had just built.

- That case now uses a signal VSS really declares `string`, and a new case
  asserts a `uint8` signal reads back through `uint32Value`.
- `test/publish_wire_type_test.dart` publishes to a **real databroker** and
  asserts the field the value came back on. It uses only API that 0.2.6 already
  shipped, so it runs against the released version too: on 0.2.6 it fails with
  `Wrong type provided (id: 891)`, and passes here.
- `test/vss_datatype_test.dart` asserts the datatype-to-field table with
  hard-coded expectations. Reading them back out of `wireArmFor` would be a
  tautology that passes for any table, including a wrong one.
- `test/vss_conformance_test.dart` gains a **datatype** axis. Its scanners
  guarded units and ranges only — the axis on which 0.2.3 went wrong — and
  watched `lib/` and `example/` but never `test/`, which is where this defect
  lived. It now reads the datatype out of the vendored spec and refuses any
  source under `lib/`, `example/` **or `test/`** that builds a
  `RoadSurfaceCondition` datapoint from a string.
- CI gains a job that runs the wire-type control against a real databroker
  carrying VSS 6.1rc2. The stock databroker image ships VSS 6.0, whose metadata
  does not contain `Vehicle.Exterior.RoadSurfaceCondition` at all, so the
  control would have skipped — and a suite of skips reads as a pass.
  `KUKSA_TEST_REQUIRE_BROKER=1` turns any skip in that file into a failure.

### Upgrading

Nothing in your dependency constraint: `0.2.7` is source-compatible with
`0.2.6`. `publishValue`, `publishDatapoint`, `getValue`, `subscribe` and
`listMetadata` keep their signatures.

Two behaviour changes to know about:

- `publishValue` now makes one metadata lookup the first time a given path is
  published to, and none afterwards. Use `publishTyped` to avoid it entirely.
- `publishValue` on a path the databroker does not know now raises
  `UnknownSignalPathsException` instead of a raw gRPC `NOT_FOUND`.

## 0.2.6

### ⚠ If you are upgrading from 0.2.3 or earlier, read this first

**Versions 0.1.0 and 0.2.0 through 0.2.3 documented
`Vehicle.ADAS.ESC.RoadFriction.MostProbable` as a float in the range `0.0–1.0`,
with the rule "below 0.3 = icy". That is not the signal's contract, and code
written to it cannot detect ice.**

The VSS unit is **percent, range 0–100** — *0 = no friction, 100 = maximum
friction*. **A real ESC on black ice reports around `18.0`.** A test written
from our old documentation evaluates `18.0 < 0.3`, which is **false**, and
therefore concludes the road is *not* icy. The same examples also wrote
`friction ?? 1.0`, which substitutes **full grip** when the signal is absent —
turning a missing sensor into a positive assertion that the road is fine.

**If you copied either line, your ice detection does not fire.** The correct
threshold is `< 30` percent, and better still is
`RoadFriction.classifyDatapoint(...)`, which enforces the spec range and returns
`RoadGrip.unknown` for an absent or out-of-spec reading instead of defaulting to
a safe-looking value.

The contract was corrected in `0.2.4` (and backported to `0.1.1` for consumers
pinned to `^0.1.0`); `0.2.5` fixed the last two stale examples on the
API-reference page.

**We cannot retract the affected versions.** pub.dev permits retraction only
within seven days of publication, and every one of those windows closed before
we acted — the earliest 128 days ago. Their pages remain online and still show
the wrong rule. This entry is the only notice we can give you, which is why it
is at the top of this one.

### One signal a vehicle does not have no longer blinds a consumer to every signal it does have

`kuksa.val.v2` subscribes to a path list as a single all-or-nothing request: if
the databroker does not know one of them it answers `NOT_FOUND` and no signal is
ever delivered. Measured against databroker 0.7.0 (VSS 6.0): `[Vehicle.Speed]`
streams; `[Vehicle.Speed, <absent path>]` dies.

Vehicles differ in which VSS leaves they expose, so a consumer asking for six
safety signals loses all six on the one leaf that vehicle lacks — and a caller
whose `onError` only logs goes quietly blind for the rest of the drive.

- `KuksaClient.subscribe` accepts `skipUnknownPaths: true`, which subscribes to
  the signals this databroker actually has. Default is `false`, so existing
  behaviour is unchanged.
- Absent paths are never dropped in silence: they are reported to
  `onUnknownPaths`, and if *none* of the requested paths is known the stream
  errors with the new `UnknownSignalPathsException` rather than completing
  empty. A consumer that receives nothing and no error cannot tell "this road is
  safe" from "this vehicle told us nothing".
- `KuksaClient.resolveKnownPaths` exposes the probe. A signal the databroker
  knows but no provider has ever written is **not** absent and is kept. Only
  `NOT_FOUND` marks a path unknown — `UNAVAILABLE`, `UNAUTHENTICATED` and the
  rest are rethrown, because an unreachable broker has not told us a signal is
  missing, and treating it as missing would drop signals the vehicle has.

Proven fail-then-pass against a real databroker (not a mock — the trap lives in
the broker's all-or-nothing `Subscribe`): `test/subscribe_resilience_test.dart`,
which skips when no broker is reachable on `localhost:55555`. Verified before
this release with a live broker: 44 tests, 0 skipped.

### Also in this release

- `spec/Exterior.vspec` re-synced with COVESA upstream, taking in
  `RoadSurfaceTemperature`. No signal's unit, range or datatype changed, so no
  documented contract moved and no classifier threshold was revisited.
- `SECURITY.md` added. This package is listed on the Eclipse KUKSA organisation
  page as a third-party component, which means the KUKSA team does not monitor
  it for vulnerabilities. We do, and there is now an address to write to.

**One signal a vehicle does not have could blind a consumer to every signal it
does have.** `kuksa.val.v2` subscribes to a path list as a single all-or-nothing
request: if the databroker does not know one of them it answers `NOT_FOUND` and
no signal is ever delivered. Measured against databroker 0.7.0 (VSS 6.0):
`[Vehicle.Speed]` streams; `[Vehicle.Speed, <absent path>]` dies.

Vehicles differ in which VSS leaves they expose, so a consumer asking for six
safety signals loses all six on the one leaf that vehicle lacks — and a caller
whose `onError` only logs goes quietly blind for the rest of the drive.

### What changed

- `KuksaClient.subscribe` accepts `skipUnknownPaths: true`, which subscribes to
  the signals this databroker actually has. Default is `false`, so existing
  behaviour is unchanged.
- Absent paths are never dropped in silence: they are reported to
  `onUnknownPaths`, and if *none* of the requested paths is known the stream
  errors with the new `UnknownSignalPathsException` rather than completing
  empty. A consumer that receives nothing and no error cannot tell "this road is
  safe" from "this vehicle told us nothing".
- `KuksaClient.resolveKnownPaths` exposes the probe. A signal the databroker
  knows but no provider has ever written is **not** absent and is kept. Only
  `NOT_FOUND` marks a path unknown — `UNAVAILABLE`, `UNAUTHENTICATED` and the
  rest are rethrown, because an unreachable broker has not told us a signal is
  missing, and treating it as missing would drop signals the vehicle has.

Proven fail-then-pass against a real databroker (not a mock — the trap lives in
the broker's all-or-nothing `Subscribe`): `test/subscribe_resilience_test.dart`,
which skips when no broker is reachable on `localhost:55555`.

## 0.2.5

**0.2.4 fixed the friction contract but left the defect alive in the two code
examples on this package's own API-reference page — the examples an integrator
copies. If you copied either one, please re-read it.**

### What was still wrong

`0.2.4` corrected the scale (percent, 0..100) and added `RoadFriction` so that an
absent reading stays `RoadGrip.unknown`. But the `KuksaClient` library example and
the `subscribe()` example still unwrapped the raw datapoint by hand, still compared
it against a `0.3` fraction threshold, and — in the `subscribe()` case — still
substituted a full-grip default for a missing sensor. Both are rendered on pub.dev.

Concretely, an ESC on black ice reports about `18.0` (percent). Under the copied
example's threshold that is **not** below `0.3`, so the ice never fires; and when
the sensor is silent, the default asserted a road that nobody had measured.

### What changed

- Both examples now call `RoadFriction.classifyDatapoint(...)` and branch on
  `isIcy` / `RoadGrip.unknown`. They no longer touch the raw value.
- The `subscribe()` example now shows the third state explicitly: when the road was
  **not measured**, tell the driver it is unknown — do not paint an all-clear.
- `example/flutter_conditions` states the unit (percent) where it renders friction.

### The guard that should have caught this, and did not

This package already ships a conformance scanner (`test/vss_conformance_test.dart`)
that flags exactly these two patterns, tests itself against the text `0.2.3`
shipped, and grants no phrasing carve-out. It passed for `0.2.4` — because its list
of files to scan was **hand-written, and did not include `kuksa_client.dart`.**

A guard whose scope is authored by the same hand as the code cannot falsify that
code: the author omits the file for the same reason he wrote the bug. The scanner
now **discovers** its scope from the filesystem — every `.dart` under `lib/` and
`example/`, plus the README. It was re-run against `0.2.4` before this release and
**failed**, naming `lib/src/client/kuksa_client.dart:134`. A new file cannot escape
it by not being remembered.

### What you must change

Nothing in your dependency constraint: `0.2.5` is source-compatible with `0.2.4`
and is a documentation and test change only — no API, no behaviour.

If you copied either example out of `0.2.4` (or earlier), replace your hand-rolled
friction check with `RoadFriction.classifyDatapoint(...)` and handle
`RoadGrip.unknown` as its own state.

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
