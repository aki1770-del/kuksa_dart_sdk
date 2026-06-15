// SPDX-License-Identifier: Apache-2.0
//
// LIFTED VERBATIM from the verified console sample
//   /home/komada/tmp/kuksa_conditions_sample/lib/driving_conditions.dart
// The signal -> surface cascade is reused unchanged (unit-tested there and
// re-tested here). The Flutter example only adds the *widget + stream
// lifecycle* on top of this pure, deterministic mapping.
//
// Deterministic mapping from raw KUKSA/VSS snow-safety signals to a
// human-readable "driving conditions" readout.
//
// Design rule (honesty): when a signal is absent we keep it `null` and never
// substitute a default. If there is not enough evidence to decide, the surface
// is [SurfaceState.unknown] — we never fabricate a condition.

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

/// Best-estimate road surface state derived from the available signals.
enum SurfaceState {
  /// Not enough signal to decide. Never fabricate — show this instead.
  unknown,

  /// Dry, normal-grip surface.
  dry,

  /// Wet or otherwise reduced-grip surface above freezing.
  wet,

  /// Falling/standing snow near or below freezing.
  snow,

  /// Ice / black-ice risk: very low grip near or below freezing.
  ice,
}

/// A deterministic driving-conditions assessment built from VSS signals.
///
/// All fields are nullable: `null` means "the vehicle did not report this
/// signal", which is materially different from a zero value.
class DrivingConditions {
  /// Road friction estimate, 0.0–1.0 (`< 0.3` ≈ icy). VSS:
  /// `Vehicle.ADAS.ESC.RoadFriction.MostProbable`.
  final double? roadFriction;

  /// Traction Control engaged → active loss of traction.
  final bool? tcsEngaged;

  /// ABS engaged → braking on a low-friction surface.
  final bool? absEngaged;

  /// Front wiper level (0–5); a precipitation proxy.
  final int? wiperIntensity;

  /// Rain-sensor intensity (0–100%).
  final int? rainIntensity;

  /// Ambient outside air temperature, °C.
  final double? airTempC;

  /// Vehicle speed, km/h.
  final double? speedKmh;

  const DrivingConditions({
    this.roadFriction,
    this.tcsEngaged,
    this.absEngaged,
    this.wiperIntensity,
    this.rainIntensity,
    this.airTempC,
    this.speedKmh,
  });

  /// Friction threshold below which the road is treated as icy/very-low-grip.
  static const double kLowFriction = 0.3;

  /// At/below this temperature, precipitation is treated as snow/ice.
  static const double kFreezingMarginC = 2.0;

  /// Wiper level at/above which precipitation is considered present.
  static const int kWiperPrecip = 3;

  /// Rain-sensor % at/above which precipitation is considered present.
  static const int kRainPrecip = 50;

  /// True when any signal indicates active loss of grip.
  bool get lowGrip =>
      (roadFriction != null && roadFriction! < kLowFriction) ||
      tcsEngaged == true ||
      absEngaged == true;

  /// True when the air temperature is at/below the freezing margin.
  /// `null` (unknown) is treated as "not known sub-zero".
  bool get nearFreezing => airTempC != null && airTempC! <= kFreezingMarginC;

  /// True when precipitation is detected (wiper or rain sensor).
  bool get precipitation =>
      (wiperIntensity != null && wiperIntensity! >= kWiperPrecip) ||
      (rainIntensity != null && rainIntensity! >= kRainPrecip);

  /// True when no decisive signal is available at all.
  bool get _noEvidence =>
      roadFriction == null &&
      tcsEngaged == null &&
      absEngaged == null &&
      wiperIntensity == null &&
      rainIntensity == null &&
      airTempC == null;

  /// Deterministic surface-state cascade.
  SurfaceState get surface {
    if (_noEvidence) return SurfaceState.unknown;

    // Sub-zero takes priority: it turns reduced grip into ice and
    // precipitation into snow.
    if (nearFreezing) {
      if (lowGrip) return SurfaceState.ice;
      if (precipitation) return SurfaceState.snow;
      // Cold but dry road with no grip loss — still dry (advisory warns of
      // black-ice on bridges/shaded spots).
      if (roadFriction != null && roadFriction! >= 0.6) return SurfaceState.dry;
      return SurfaceState.unknown;
    }

    // Above freezing.
    if (precipitation || lowGrip) return SurfaceState.wet;
    if (roadFriction != null && roadFriction! >= 0.6) return SurfaceState.dry;
    return SurfaceState.unknown;
  }

  /// A short, driver-facing advisory string for [surface].
  String get advisory {
    switch (surface) {
      case SurfaceState.ice:
        return 'ICE RISK — very low grip near/below freezing. Slow down, '
            'leave extra distance, avoid sudden steering or braking.';
      case SurfaceState.snow:
        return 'SNOW — snow near freezing. Reduce speed; expect reduced '
            'traction and longer stopping distances.';
      case SurfaceState.wet:
        return 'WET / REDUCED GRIP — wet or slippery surface. Increase '
            'following distance and braking distance.';
      case SurfaceState.dry:
        return nearFreezing
            ? 'DRY (COLD) — surface dry but at/below freezing; watch for black '
                'ice on bridges and shaded sections.'
            : 'DRY — normal driving conditions.';
      case SurfaceState.unknown:
        return 'CONDITIONS UNKNOWN — not enough signals to assess (no provider '
            'publishing?). No condition is fabricated.';
    }
  }

  /// Adapts a snapshot of kuksa_dart_sdk [Datapoint]s into a typed assessment.
  ///
  /// Uses [Datapoint.value] (the untyped accessor) and coerces numerically, so
  /// it is robust to a databroker modelling, e.g., wiper intensity as `int32`
  /// vs `uint8`. Signals absent from [snapshot] (or carrying no value) stay
  /// `null`.
  factory DrivingConditions.fromSignals(Map<String, Datapoint> snapshot) {
    return DrivingConditions(
      roadFriction: _asDouble(snapshot[kRoadFrictionMostProbable]),
      tcsEngaged: _asBool(snapshot[kTcsIsEngaged]),
      absEngaged: _asBool(snapshot[kAbsIsEngaged]),
      wiperIntensity: _asInt(snapshot[kWiperFrontIntensity]),
      rainIntensity: _asInt(snapshot[kRaindetectionIntensity]),
      airTempC: _asDouble(snapshot[kAirTemperature]),
      speedKmh: _asDouble(snapshot[kVehicleSpeed]),
    );
  }

  static double? _asDouble(Datapoint? dp) {
    final v = dp?.value;
    return v is num ? v.toDouble() : null;
  }

  static int? _asInt(Datapoint? dp) {
    final v = dp?.value;
    return v is num ? v.toInt() : null;
  }

  static bool? _asBool(Datapoint? dp) {
    final v = dp?.value;
    return v is bool ? v : null;
  }
}
