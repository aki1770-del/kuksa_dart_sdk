/// KUKSA Dart SDK — Dart/Flutter client for the Eclipse KUKSA Vehicle
/// Abstraction Layer (kuksa-databroker v2).
///
/// Provides typed access to Vehicle Signal Specification (VSS) signals for
/// driver-assisting navigation on embedded Linux IVI systems.
///
/// ## Quick start
///
/// ```dart
/// import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
///
/// final client = KuksaClient(host: 'localhost', port: 55555);
/// await client.connect();
///
/// // One-shot read
/// final dp = await client.getValue(kRoadFrictionMostProbable);
/// print('Road friction: ${dp.floatValue}');
///
/// // Continuous subscription — all snow-safety signals
/// await for (final update in client.subscribe(kSnowSafetySignals)) {
///   final friction = update[kRoadFrictionMostProbable]?.floatValue;
///   final tcsActive = update[kTcsIsEngaged]?.boolValue ?? false;
///   if ((friction ?? 1.0) < 0.3 || tcsActive) {
///     // Activate snow routing mode in navigation BLoC
///   }
/// }
///
/// await client.dispose();
/// ```
library kuksa_dart_sdk;

export 'src/client/kuksa_client.dart';
export 'src/client/datapoint.dart';
export 'src/client/signal_path.dart';
