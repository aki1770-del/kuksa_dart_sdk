/// Snow safety monitor — SNGNav integration example.
///
/// Demonstrates connecting to a KUKSA databroker on an IVI headunit and
/// reacting to road condition signals in real time.
///
/// Run against a local databroker:
///   dart run example/snow_safety_monitor.dart
library;

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

void main() async {
  final client = KuksaClient(host: 'localhost', port: 55555);
  await client.connect();

  // Print databroker version
  final info = await client.getServerInfo();
  print('Connected to KUKSA databroker ${info.version} (${info.commitHash})');

  // One-shot read — current road friction.
  // VSS declares this signal in PERCENT (0–100), not as a 0.0–1.0 fraction.
  final road = RoadFriction.classifyDatapoint(
    await client.getValue(kRoadFrictionMostProbable),
  );
  if (road.isKnown) {
    print('Current road friction: ${road.percent!.toStringAsFixed(1)}% '
        '(${road.grip.name})');
  } else if (road.isContractViolation) {
    print('Road friction reading is OUT OF SPEC (raw=${road.rawValue}; VSS '
        'declares percent 0–100). Treating as UNKNOWN — not as a clear road.');
  } else {
    print('Road friction signal not available (no ESC module, or nothing '
        'publishing it). Conditions UNKNOWN — no condition is assumed.');
  }

  // Continuous snow-safety subscription
  print('\nMonitoring snow safety signals... (Ctrl+C to stop)\n');

  await for (final update in client.subscribe(kSnowSafetySignals)) {
    _handleUpdate(update);
  }

  await client.dispose();
}

void _handleUpdate(Map<String, Datapoint> update) {
  final road =
      RoadFriction.classifyDatapoint(update[kRoadFrictionMostProbable]);
  final tcs = update[kTcsIsEngaged]?.boolValue;
  final abs_ = update[kAbsIsEngaged]?.boolValue;
  final temp = update[kAirTemperature]?.floatValue;
  final wiper = update[kWiperFrontIntensity]?.uint32Value;
  final rain = update[kRaindetectionIntensity]?.uint32Value;

  // Snow condition assessment.
  //
  // Every term below is `true` only on a POSITIVE measurement. A signal that
  // was not reported contributes nothing — it never argues that the road is
  // fine. That is why the "no evidence" case is printed as UNKNOWN rather than
  // falling through to NORMAL.
  final bool activeTraction = tcs == true;
  final bool activeAbs = abs_ == true;
  final bool belowFreezing = temp != null && temp <= 2.0;
  final bool heavyPrecipitation = (rain != null && rain >= 60) ||
      // Wiper intensity is an actuator request, not a rain sensor — a weak
      // proxy, used only when the rain sensor is silent.
      (rain == null && wiper != null && wiper >= 3);

  final int alarmLevel = [
    road.isIcy,
    activeTraction,
    activeAbs,
    belowFreezing && heavyPrecipitation,
  ].where((b) => b).length;

  final bool noEvidence = !road.isKnown &&
      tcs == null &&
      abs_ == null &&
      temp == null &&
      wiper == null &&
      rain == null;

  if (update.isEmpty) return; // nothing arrived at all

  final timestamp = DateTime.now().toIso8601String().substring(11, 19);
  final label = noEvidence
      ? 'UNKNOWN '
      : switch (alarmLevel) {
          0 => 'NORMAL  ',
          1 => 'CAUTION ',
          2 => 'WARNING ',
          _ => 'SNOW ❄  ',
        };

  final parts = <String>[];
  if (road.isKnown) {
    parts.add('friction=${road.percent!.toStringAsFixed(1)}% '
        '(${road.grip.name})');
  } else if (road.isContractViolation) {
    parts.add('friction=OUT-OF-SPEC(${road.rawValue})');
  } else {
    parts.add('friction=unknown');
  }
  if (tcs != null) parts.add('TCS=${tcs ? "ON" : "off"}');
  if (abs_ != null) parts.add('ABS=${abs_ ? "ON" : "off"}');
  if (temp != null) parts.add('${temp.toStringAsFixed(1)}°C');
  if (wiper != null) parts.add('wiper=$wiper');
  if (rain != null) parts.add('rain=$rain%');

  print('[$timestamp] $label ${parts.join(' | ')}');
}
