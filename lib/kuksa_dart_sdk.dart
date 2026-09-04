// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// KUKSA Dart SDK — Dart/Flutter client for the Eclipse KUKSA Vehicle
/// Abstraction Layer (kuksa-databroker v2).
///
/// Provides typed access to Vehicle Signal Specification (VSS) signals for
/// driver-assisting navigation on embedded Linux IVI systems.
///
/// ## Quick start
///
/// `Vehicle.ADAS.ESC.RoadFriction.MostProbable` is a float in **percent**
/// (VSS range 0–100), not a 0.0–1.0 fraction. Classify it with
/// [RoadFriction.classify], which enforces the spec range and reports an absent
/// or out-of-spec reading as [RoadGrip.unknown] instead of a safe-looking
/// default.
///
/// ```dart
/// import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
///
/// final client = KuksaClient(host: 'localhost', port: 55555);
/// await client.connect();
///
/// // One-shot read
/// final dp = await client.getValue(kRoadFrictionMostProbable);
/// print(RoadFriction.classifyDatapoint(dp)); // e.g. "18.0% → icy"
///
/// // Continuous subscription — all snow-safety signals
/// await for (final update in client.subscribe(kSnowSafetySignals)) {
///   final road = RoadFriction.classifyDatapoint(update[kRoadFrictionMostProbable]);
///   final tcsActive = update[kTcsIsEngaged]?.boolValue ?? false;
///
///   switch (road.grip) {
///     case RoadGrip.icy:
///       // Measured ice — activate snow routing mode.
///     case RoadGrip.reduced:
///       // Measured reduced grip.
///     case RoadGrip.grip:
///       if (tcsActive) { /* traction loss despite a good reading */ }
///     case RoadGrip.unknown:
///       // No reading. Tell the driver conditions are UNKNOWN.
///       // Do not assume the road is clear.
///   }
/// }
///
/// await client.dispose();
/// ```
library kuksa_dart_sdk;

export 'src/client/kuksa_client.dart';
export 'src/client/datapoint.dart';
export 'src/client/road_friction.dart';
export 'src/client/signal_path.dart';
export 'src/client/vss_datatype.dart';
