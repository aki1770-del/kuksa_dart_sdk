// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// VSS signal path constants relevant to snow and road safety navigation.
///
/// These are the signals that flow from vehicle ECUs through KUKSA databroker
/// into SNGNav's navigation_safety BLoC. All paths are VSS dot-notation
/// strings from the COVESA Vehicle Signal Specification.
library;

/// Road friction estimate from the Electronic Stability Control system.
///
/// Type: float, unit **percent**, range 0–100 (VSS: `min: 0`, `max: 100`;
/// "0 = no friction, 100 = maximum friction"). A reading below 30 percent
/// indicates an icy/snowy road — a real ESC on black ice reports around 18.
///
/// This is NOT a 0.0–1.0 fraction. Use [RoadFriction.classify] rather than
/// comparing the raw double yourself; it enforces the spec range and returns
/// [RoadGrip.unknown] for an absent or out-of-spec reading instead of
/// defaulting to a safe-looking value.
///
/// VSS: Vehicle.ADAS.ESC.RoadFriction.MostProbable
const String kRoadFrictionMostProbable =
    'Vehicle.ADAS.ESC.RoadFriction.MostProbable';

/// Lower bound of the friction confidence interval.
///
/// Type: float, unit percent, range 0–100 (5% chance friction is under this).
/// VSS: Vehicle.ADAS.ESC.RoadFriction.LowerBound
const String kRoadFrictionLowerBound =
    'Vehicle.ADAS.ESC.RoadFriction.LowerBound';

/// Upper bound of the friction confidence interval.
///
/// Type: float, unit percent, range 0–100 (95% chance friction is under this).
/// VSS: Vehicle.ADAS.ESC.RoadFriction.UpperBound
const String kRoadFrictionUpperBound =
    'Vehicle.ADAS.ESC.RoadFriction.UpperBound';

/// Whether Traction Control System is currently engaged.
///
/// Type: bool. True = active traction loss event on this road segment.
/// VSS: Vehicle.ADAS.TCS.IsEngaged
const String kTcsIsEngaged = 'Vehicle.ADAS.TCS.IsEngaged';

/// Whether Anti-lock Braking System is currently engaged.
///
/// Type: bool. True = driver is braking on low-friction surface.
/// VSS: Vehicle.ADAS.ABS.IsEngaged
const String kAbsIsEngaged = 'Vehicle.ADAS.ABS.IsEngaged';

/// Front windshield wiper intensity.
///
/// Type: uint8 **actuator**, no maximum declared by VSS ("maximum value
/// supported is vehicle specific"). Per VSS this is the *requested* relative
/// intensity/sensitivity for INTERVAL and RAIN_SENSOR wiper modes, and it
/// "has no significance" when the wiper mode is OFF/SLOW/MEDIUM/FAST — so it
/// is a weak precipitation proxy at best. Prefer [kRaindetectionIntensity]
/// (a real sensor, percent 0–100) where the vehicle publishes it.
/// VSS: Vehicle.Body.Windshield.Front.Wiping.Intensity
const String kWiperFrontIntensity =
    'Vehicle.Body.Windshield.Front.Wiping.Intensity';

/// Rain/precipitation sensor intensity.
///
/// Type: uint8, unit percent, max 100 (VSS declares no explicit min).
/// 0 = dry, no rain; 100 = covered.
/// VSS: Vehicle.Body.Raindetection.Intensity
const String kRaindetectionIntensity = 'Vehicle.Body.Raindetection.Intensity';

/// Ambient outside air temperature.
///
/// Type: float, unit Celsius, no range declared by VSS.
/// At or under 2°C with precipitation → likely snow/ice conditions.
/// VSS: Vehicle.Exterior.AirTemperature
const String kAirTemperature = 'Vehicle.Exterior.AirTemperature';

/// Front-left tire pressure.
///
/// Type: uint16, unit kPa, no range declared by VSS.
/// A TPMS drop may indicate ice damage or valve failure.
/// VSS: Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.Pressure
const String kTirePressureFrontLeft =
    'Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.Pressure';

/// Front-right tire pressure. Type: uint16, unit kPa.
/// VSS: Vehicle.Chassis.Axle.Row1.Wheel.Right.Tire.Pressure
const String kTirePressureFrontRight =
    'Vehicle.Chassis.Axle.Row1.Wheel.Right.Tire.Pressure';

/// Current vehicle speed. Type: float, unit km/h.
/// VSS: Vehicle.Speed
const String kVehicleSpeed = 'Vehicle.Speed';

/// Fused road surface condition.
///
/// Type: **uint8 enum** (NOT a string) — 0 UNKNOWN, 1 DRY, 2 WET, 3 SNOW,
/// 4 ICE, 5 SLUSH, 6 WET_ICE, 7 LOOSE_GRAVEL. Per VSS, UNKNOWN (0) "shall be
/// used when the system cannot assess the road surface condition" — treat it
/// as absence of knowledge, never as a clear road.
/// Availability still depends on the databroker exposing a provider for it.
/// VSS: Vehicle.Exterior.RoadSurfaceCondition
const String kRoadSurfaceCondition = 'Vehicle.Exterior.RoadSurfaceCondition';

/// All snow-safety relevant signals as a single list — use for a
/// single-call subscription covering all road condition indicators.
const List<String> kSnowSafetySignals = [
  kRoadFrictionMostProbable,
  kRoadFrictionLowerBound,
  kTcsIsEngaged,
  kAbsIsEngaged,
  kWiperFrontIntensity,
  kRaindetectionIntensity,
  kAirTemperature,
  kTirePressureFrontLeft,
  kTirePressureFrontRight,
  kVehicleSpeed,
];
