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

  // One-shot read — current road friction
  final friction = await client.getValue(kRoadFrictionMostProbable);
  if (friction.hasValue) {
    print('Current road friction: ${friction.floatValue?.toStringAsFixed(2)}');
  } else {
    print(
        'Road friction signal not available (no ESC module or not running on vehicle)');
  }

  // Continuous snow-safety subscription
  print('\nMonitoring snow safety signals... (Ctrl+C to stop)\n');

  await for (final update in client.subscribe(kSnowSafetySignals)) {
    _handleUpdate(update);
  }

  await client.dispose();
}

void _handleUpdate(Map<String, Datapoint> update) {
  final friction = update[kRoadFrictionMostProbable]?.floatValue;
  final tcs = update[kTcsIsEngaged]?.boolValue;
  final abs_ = update[kAbsIsEngaged]?.boolValue;
  final temp = update[kAirTemperature]?.floatValue;
  final wiper = update[kWiperFrontIntensity]?.uint32Value;
  final rain = update[kRaindetectionIntensity]?.uint32Value;

  // Snow condition assessment
  final bool lowFriction = friction != null && friction < 0.3;
  final bool activeTraction = tcs == true;
  final bool activeAbs = abs_ == true;
  final bool belowFreezing = temp != null && temp < 2.0;
  final bool heavyPrecipitation = (wiper ?? 0) >= 3 || (rain ?? 0) >= 60;

  final int alarmLevel = [
    lowFriction,
    activeTraction,
    activeAbs,
    belowFreezing && heavyPrecipitation
  ].where((b) => b).length;

  if (alarmLevel == 0 && update.isEmpty) return; // no meaningful update

  final timestamp = DateTime.now().toIso8601String().substring(11, 19);
  final label = switch (alarmLevel) {
    0 => 'NORMAL  ',
    1 => 'CAUTION ',
    2 => 'WARNING ',
    _ => 'SNOW ❄  ',
  };

  final parts = <String>[];
  if (friction != null) parts.add('friction=${friction.toStringAsFixed(2)}');
  if (tcs != null) parts.add('TCS=${tcs ? "ON" : "off"}');
  if (abs_ != null) parts.add('ABS=${abs_ ? "ON" : "off"}');
  if (temp != null) parts.add('${temp.toStringAsFixed(1)}°C');
  if (wiper != null) parts.add('wiper=$wiper');
  if (rain != null) parts.add('rain=$rain%');

  print('[$timestamp] $label ${parts.join(' | ')}');
}
