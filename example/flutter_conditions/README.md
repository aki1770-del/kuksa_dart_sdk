# flutter_conditions

A minimal **Flutter** example for `kuksa_dart_sdk`: a widget that subscribes to
snow/winter driving-safety VSS signals from an Eclipse KUKSA databroker and
renders a deterministic **driving conditions** card.

It focuses on the part a long-running vehicle UI must get right — a **correct
stream lifecycle** — so the subscription does not silently stop working after
the app has been running for a while:

- the subscription is opened in `initState` and **always cancelled in
  `dispose`** (which tears down the underlying gRPC stream);
- when the stream **errors or ends**, the UI degrades to an honest
  `UNKNOWN` — it never keeps showing a stale reading and never fabricates one;
- a **Reconnect** button opens a fresh subscription.

## Layout

| File | Role |
|------|------|
| `lib/driving_conditions.dart` | The deterministic signal → surface cascade (`unknown`/`dry`/`wet`/`snow`/`ice`). Lifted verbatim from the console sample; absent signals stay `null`, never defaulted. |
| `lib/conditions_source.dart` | The seam over the SDK. `KuksaConditionsSource` connects, subscribes to `kSnowSafetySignals`, and merges each (partial) update into a rolling snapshot before mapping. |
| `lib/conditions_card.dart` | Pure presentation — renders a `DrivingConditions` + connection status. No state, so it is trivial to render-capture. |
| `lib/conditions_monitor.dart` | The stateful widget that owns the subscription lifecycle. |
| `lib/main.dart` | Runnable app entry point. |

## Honesty

The card always carries an explicit caveat: this is a demonstration, not a
safety-critical control. Conditions are derived from vehicle bus signals only;
visibility is never estimated; a warning never produces a number; `null` /
`UNKNOWN` means the driver's own judgment.

## Run it

Start a `kuksa-databroker` on `localhost:55555` (see the parent
[`example/README.md`](../README.md)), then:

```sh
flutter pub get
flutter run
```

With no databroker the app shows the honest `Connecting…` / `UNKNOWN` state and
a Reconnect button.

## Tests

```sh
flutter test
```

- `test/conditions_monitor_lifecycle_test.dart` — subscribe / error-degrade /
  done-degrade / reconnect / cancel-on-dispose, against a fake source (no
  databroker needed).
- `test/conditions_card_render_test.dart` — pumps the card in fed states and
  writes a real PNG of each to `_capture/` via `RepaintBoundary.toImage`, so the
  rendered output can be inspected directly.
