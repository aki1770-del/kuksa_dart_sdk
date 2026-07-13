// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// Road-friction classification, conformant with the COVESA Vehicle Signal
/// Specification.
///
/// `Vehicle.ADAS.ESC.RoadFriction.MostProbable` is declared by VSS as:
/// `datatype: float`, `unit: percent`, `min: 0`, `max: 100`
/// ("0 = no friction, 100 = maximum friction"). The specification is vendored
/// in this repository at `spec/ADAS.vspec` and asserted by
/// `test/vss_conformance_test.dart`, so this documentation cannot drift from
/// the standard without the build failing.
///
/// Two rules are enforced here, and both exist because breaking either one
/// produces a confident, wrong "the road is fine":
///
/// 1. **The scale is percent, not a 0.0-1.0 fraction.** An ESC on black ice
///    reports something like `18.0`, which a 0.0-1.0 fraction reader will classify
///    as a clear road (its "icy below 0.3" test never fires).
/// 2. **Absence is absence.** A missing reading is [RoadGrip.unknown]. It is
///    never defaulted to full grip, and it never answers "not icy".
library;

import 'datapoint.dart';

/// The grip verdict for a friction reading.
enum RoadGrip {
  /// No usable reading: the signal was absent, or the producer emitted a value
  /// outside the specification's declared range.
  ///
  /// This is **not** a safe state and **not** an unsafe state — it is the
  /// absence of knowledge. Surface it to the driver; never substitute a value.
  unknown,

  /// Very low grip — ice / black ice / packed snow.
  icy,

  /// Reduced grip — wet, slush, loose surface.
  reduced,

  /// Normal grip.
  grip,
}

/// A classified friction reading. Immutable.
class RoadFrictionReading {
  const RoadFrictionReading._({
    required this.grip,
    required this.percent,
    required this.isContractViolation,
    required this.rawValue,
  });

  /// The verdict.
  final RoadGrip grip;

  /// The reading in percent (0..100), or `null` when [grip] is
  /// [RoadGrip.unknown].
  ///
  /// It is deliberately `null` — not clamped, not defaulted — so that a caller
  /// cannot accidentally use an unknown reading as if it were a measurement.
  final double? percent;

  /// True when the producer emitted a value the specification forbids
  /// (outside `min`..`max`, or NaN/infinite).
  ///
  /// The value is **not** clamped into range: clamping an out-of-range reading
  /// to `max` would assert perfect grip, which is exactly the failure this
  /// class exists to prevent. The producer is broken; say so.
  final bool isContractViolation;

  /// The value as received, retained for diagnostics/logging even when it
  /// violates the contract. Never use it as a measurement.
  final double? rawValue;

  /// True when there is a usable measurement.
  bool get isKnown => grip != RoadGrip.unknown;

  /// True only when the road is *positively measured* as icy.
  bool get isIcy => grip == RoadGrip.icy;

  /// True only when the road is *positively measured* as not icy.
  ///
  /// An unknown reading returns `false` here **and** `false` from [isIcy].
  /// Both being false is the point: absence of a reading is not a claim about
  /// the road in either direction.
  bool get isNotIcy => isKnown && grip != RoadGrip.icy;

  /// The reading, or a [StateError] if there is none.
  ///
  /// Use this where a numeric friction value is genuinely required, so that a
  /// missing reading fails loudly instead of becoming a fabricated default.
  double requirePercent() {
    final p = percent;
    if (p == null) {
      throw StateError(
        'No road-friction measurement is available '
        '(${isContractViolation ? 'producer emitted out-of-spec value '
            '$rawValue; VSS declares percent '
            '${RoadFriction.minPercent}..${RoadFriction.maxPercent}' : 'signal '
            'absent — no ESC module, or no provider publishing it'}). '
        'Handle RoadGrip.unknown explicitly; do not substitute a default.',
      );
    }
    return p;
  }

  @override
  String toString() => isKnown
      ? 'RoadFrictionReading(${percent!.toStringAsFixed(1)}% → ${grip.name})'
      : 'RoadFrictionReading(unknown'
          '${isContractViolation ? ', out-of-spec raw=$rawValue' : ''})';
}

/// Spec-conformant classification of `Vehicle.ADAS.ESC.RoadFriction.*`.
abstract final class RoadFriction {
  /// Minimum legal value, from VSS (`min: 0`). Percent.
  static const double minPercent = 0;

  /// Maximum legal value, from VSS (`max: 100`). Percent.
  static const double maxPercent = 100;

  /// Below this percent the surface is treated as icy / very-low-grip.
  ///
  /// This threshold is **this package's advisory choice**, not part of VSS —
  /// the specification defines the scale, not the driving semantics. It is on
  /// the percent scale (0..100), which is the whole point: a fraction-scale
  /// threshold such as `0.3` can never be reached by a real ESC reading.
  static const double icyBelowPercent = 30;

  /// Below this percent (and at/above [icyBelowPercent]) the surface is treated
  /// as reduced-grip. Advisory, not part of VSS.
  static const double reducedBelowPercent = 60;

  /// Classifies a friction reading given in **percent** (VSS scale).
  ///
  /// - `null` → [RoadGrip.unknown] (the signal was not reported).
  /// - Outside `0..100`, NaN or infinite → [RoadGrip.unknown] with
  ///   [RoadFrictionReading.isContractViolation] set. Never clamped.
  /// - Otherwise → [RoadGrip.icy] / [RoadGrip.reduced] / [RoadGrip.grip].
  static RoadFrictionReading classify(double? percent) {
    if (percent == null) {
      return const RoadFrictionReading._(
        grip: RoadGrip.unknown,
        percent: null,
        isContractViolation: false,
        rawValue: null,
      );
    }
    if (percent.isNaN ||
        !percent.isFinite ||
        percent < minPercent ||
        percent > maxPercent) {
      return RoadFrictionReading._(
        grip: RoadGrip.unknown,
        percent: null,
        isContractViolation: true,
        rawValue: percent,
      );
    }
    final RoadGrip g;
    if (percent < icyBelowPercent) {
      g = RoadGrip.icy;
    } else if (percent < reducedBelowPercent) {
      g = RoadGrip.reduced;
    } else {
      g = RoadGrip.grip;
    }
    return RoadFrictionReading._(
      grip: g,
      percent: percent,
      isContractViolation: false,
      rawValue: percent,
    );
  }

  /// Classifies the friction [Datapoint] straight off a subscription snapshot.
  ///
  /// A `null` datapoint, or one carrying no value, is [RoadGrip.unknown].
  static RoadFrictionReading classifyDatapoint(Datapoint? dp) {
    final v = dp?.value;
    return classify(v is num ? v.toDouble() : null);
  }
}
