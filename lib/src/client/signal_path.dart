/// VSS signal path constants relevant to snow and road safety navigation.
///
/// These are the signals that flow from vehicle ECUs through KUKSA databroker
/// into SNGNav's navigation_safety BLoC. All paths are VSS dot-notation
/// strings from the COVESA Vehicle Signal Specification.
library;

/// Road friction estimate from the Electronic Stability Control system.
///
/// Type: float (0.0–1.0). A value below 0.3 indicates icy/snowy road.
/// VSS: Vehicle.ADAS.ESC.RoadFriction.MostProbable
const String kRoadFrictionMostProbable =
    'Vehicle.ADAS.ESC.RoadFriction.MostProbable';

/// Lower bound of the friction confidence interval.
/// VSS: Vehicle.ADAS.ESC.RoadFriction.LowerBound
const String kRoadFrictionLowerBound =
    'Vehicle.ADAS.ESC.RoadFriction.LowerBound';

/// Upper bound of the friction confidence interval.
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

/// Front windshield wiper intensity level (0–5).
///
/// A proxy signal for precipitation intensity. Level 3+ indicates
/// moderate to heavy rain or snow. Used when no dedicated rain sensor
/// signal is available.
/// VSS: Vehicle.Body.Windshield.Front.Wiping.Intensity
const String kWiperFrontIntensity =
    'Vehicle.Body.Windshield.Front.Wiping.Intensity';

/// Rain/precipitation sensor intensity (0–100%).
///
/// Type: uint8. 0 = dry, 100 = maximum detected precipitation.
/// VSS: Vehicle.Body.Raindetection.Intensity
const String kRaindetectionIntensity = 'Vehicle.Body.Raindetection.Intensity';

/// Ambient outside air temperature in degrees Celsius.
///
/// Type: float. Below 2°C with precipitation → likely snow/ice conditions.
/// VSS: Vehicle.Exterior.AirTemperature
const String kAirTemperature = 'Vehicle.Exterior.AirTemperature';

/// Front-left tire pressure in kilopascals.
///
/// TPMS drop may indicate ice damage or valve failure.
/// VSS: Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.Pressure
const String kTirePressureFrontLeft =
    'Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.Pressure';

/// Front-right tire pressure in kilopascals.
/// VSS: Vehicle.Chassis.Axle.Row1.Wheel.Right.Tire.Pressure
const String kTirePressureFrontRight =
    'Vehicle.Chassis.Axle.Row1.Wheel.Right.Tire.Pressure';

/// Current vehicle speed in km/h.
/// VSS: Vehicle.Speed
const String kVehicleSpeed = 'Vehicle.Speed';

/// Fused road surface condition (once VSS #877 is merged and databroker
/// exposes this signal via a kuksa-someip-provider implementation).
/// Type: string enum — UNKNOWN | DRY | WET | SNOW | ICE | SLUSH | WET_ICE | LOOSE_GRAVEL
/// VSS: Vehicle.Exterior.RoadSurfaceCondition  (proposed in VSS #877)
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
