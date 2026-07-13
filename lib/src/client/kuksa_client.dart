// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// KUKSA Vehicle Abstraction Layer — Dart client.
///
/// Connects to a running [kuksa-databroker](https://github.com/eclipse-kuksa/kuksa-databroker)
/// instance and provides typed access to VSS (Vehicle Signal Specification)
/// signals via the `kuksa.val.v2` gRPC API.
///
/// Typical usage on an embedded IVI headunit (insecure local connection):
///
/// ```dart
/// final client = KuksaClient(host: 'localhost', port: 55555);
/// await client.connect();
///
/// await for (final update in client.subscribe(kSnowSafetySignals)) {
///   // Classify — never compare the raw value yourself. RoadFriction is on the
///   // VSS percent scale (0-100), and absence must stay absent.
///   final road = RoadFriction.classifyDatapoint(update[kRoadFrictionMostProbable]);
///   if (road.isIcy) activateSnowRoutingMode();
/// }
/// ```
library;

import 'package:grpc/grpc.dart';

import '../generated/kuksa/val/v2/val.pbgrpc.dart' as pb_grpc;
import '../generated/kuksa/val/v2/val.pb.dart' as pb;
import '../generated/kuksa/val/v2/types.pb.dart' as pb_types;
import 'datapoint.dart';

/// Client for the KUKSA databroker v2 (`kuksa.val.v2.VAL` service).
///
/// Each [KuksaClient] instance manages a single gRPC channel. Call [connect]
/// before issuing requests, [dispose] when done.
class KuksaClient {
  final String host;
  final int port;

  /// Optional Bearer token for authenticated databroker instances.
  /// Leave null for local insecure connections (typical on embedded IVI).
  final String? jwtToken;

  /// Optional PEM-encoded root certificate for TLS connections.
  /// Leave null for insecure connections.
  final List<int>? rootCertificates;

  ClientChannel? _channel;
  pb_grpc.VALClient? _stub;

  KuksaClient({
    required this.host,
    this.port = 55555,
    this.jwtToken,
    this.rootCertificates,
  });

  /// Opens the gRPC channel and initialises the stub.
  ///
  /// Safe to call multiple times — subsequent calls are no-ops if already
  /// connected.
  Future<void> connect() async {
    if (_stub != null) return;

    final credentials = rootCertificates != null
        ? ChannelCredentials.secure(
            certificates: rootCertificates,
          )
        : const ChannelCredentials.insecure();

    _channel = ClientChannel(
      host,
      port: port,
      options: ChannelOptions(credentials: credentials),
    );
    _stub = pb_grpc.VALClient(_channel!);
  }

  /// Returns the call options with auth metadata if a JWT token is set.
  CallOptions get _callOptions {
    if (jwtToken == null) return CallOptions();
    return CallOptions(
      metadata: {'authorization': 'Bearer $jwtToken'},
    );
  }

  pb_grpc.VALClient get _client {
    if (_stub == null) {
      throw StateError(
        'KuksaClient not connected. Call connect() before issuing requests.',
      );
    }
    return _stub!;
  }

  /// Reads the current values of the given [paths] in a single batch call.
  ///
  /// Returns a map of path → [Datapoint]. Absent or unknown signals are
  /// represented as [Datapoint] with [Datapoint.hasValue] == false.
  Future<Map<String, Datapoint>> getValues(List<String> paths) async {
    final request = pb.GetValuesRequest(
      signalIds: paths.map(
        (p) => pb_types.SignalID(path: p),
      ),
    );
    final response = await _client.getValues(request, options: _callOptions);
    return {
      for (var i = 0; i < paths.length && i < response.dataPoints.length; i++)
        paths[i]: Datapoint(raw: response.dataPoints[i], path: paths[i]),
    };
  }

  /// Reads a single signal's current value.
  Future<Datapoint> getValue(String path) async {
    final request = pb.GetValueRequest(
      signalId: pb_types.SignalID(path: path),
    );
    final response = await _client.getValue(request, options: _callOptions);
    return Datapoint(raw: response.dataPoint, path: path);
  }

  /// Subscribes to continuous updates for [paths].
  ///
  /// Returns a broadcast [Stream] of update maps. Each map contains only
  /// the signals that changed in that update cycle — not all subscribed
  /// signals. The first emission contains the current values of all paths.
  ///
  /// The stream is closed when the gRPC server stream ends or the channel
  /// is disconnected. Reconnect and re-subscribe as needed.
  ///
  /// Example — snow safety monitoring:
  /// ```dart
  /// await for (final update in client.subscribe(kSnowSafetySignals)) {
  ///   final road = RoadFriction.classifyDatapoint(update[kRoadFrictionMostProbable]);
  ///   final tcs = update[kTcsIsEngaged]?.boolValue;
  ///
  ///   if (road.isIcy || (tcs ?? false)) {
  ///     navigationBloc.add(SnowConditionsDetected());
  ///   } else if (road.grip == RoadGrip.unknown) {
  ///     // The road was NOT measured. Absence is not "no ice" — show the driver
  ///     // that the surface is unknown; do not paint an all-clear.
  ///     navigationBloc.add(RoadSurfaceUnknown());
  ///   }
  /// }
  /// ```
  ///
  /// Do **not** unwrap the friction value yourself. `Vehicle.ADAS.ESC.RoadFriction`
  /// is a **percent** (0-100) on the VSS scale: a threshold written for a
  /// 0.0-1.0 fraction will classify a genuine 18 % black-ice measurement
  /// as a clear road. And defaulting an absent reading to full grip fabricates a
  /// measurement out of a broken sensor — absence is [RoadGrip.unknown], which is
  /// neither safe nor unsafe; surface it to the driver.
  /// [RoadFriction.classifyDatapoint] exists to make both mistakes unavailable.
  Stream<Map<String, Datapoint>> subscribe(
    List<String> paths, {
    /// Server-side buffer size per signal (0 = keep only latest value).
    /// Increase for high-frequency signals (e.g., wheel speed at 50 Hz).
    int bufferSize = 0,
  }) {
    final request = pb.SubscribeRequest(
      signalPaths: paths,
      bufferSize: bufferSize,
    );

    return _client.subscribe(request, options: _callOptions).map((response) => {
          for (final entry in response.entries.entries)
            entry.key: Datapoint(raw: entry.value, path: entry.key),
        });
  }

  /// Publishes a single value for [path] to the databroker.
  ///
  /// This is the provider-side write path (`kuksa.val.v2.VAL/PublishValue`):
  /// a provider claiming a signal pushes its current value so consumers can
  /// read or subscribe to it.
  ///
  /// [value] is mapped to the matching VSS primitive by its Dart runtime type:
  ///
  /// | Dart type      | VSS value field |
  /// |----------------|-----------------|
  /// | `bool`         | `bool`          |
  /// | `int`          | `int32`         |
  /// | `double`       | `float`         |
  /// | `String`       | `string`        |
  ///
  /// For wider or unsigned integer types, array types, or explicit `double`
  /// (vs `float`) precision, construct the [pb_types.Value] yourself and use
  /// [publishDatapoint].
  ///
  /// Example:
  /// ```dart
  /// await client.publishValue('Vehicle.Speed', 100.34);
  /// ```
  Future<void> publishValue(String path, Object value) {
    final pb_types.Value v;
    if (value is bool) {
      v = pb_types.Value(bool_12: value);
    } else if (value is int) {
      v = pb_types.Value(int32: value);
    } else if (value is double) {
      v = pb_types.Value(float: value);
    } else if (value is String) {
      v = pb_types.Value(string: value);
    } else {
      throw ArgumentError.value(
        value,
        'value',
        'Unsupported Dart type for publishValue. Pass bool, int, double, or '
            'String, or use publishDatapoint() with an explicit Value.',
      );
    }
    return publishDatapoint(path, pb_types.Datapoint(value: v));
  }

  /// Publishes a fully-formed [datapoint] for [path] to the databroker.
  ///
  /// Use this when you need control over the value type (e.g. unsigned or
  /// 64-bit integers, arrays, or a timestamp) beyond what [publishValue]'s
  /// Dart-type mapping covers.
  Future<void> publishDatapoint(
      String path, pb_types.Datapoint datapoint) async {
    final request = pb.PublishValueRequest(
      signalId: pb_types.SignalID(path: path),
      dataPoint: datapoint,
    );
    await _client.publishValue(request, options: _callOptions);
  }

  /// Queries the server metadata for a list of signal paths or a pattern.
  ///
  /// [filter] is an optional VSS path prefix/glob (e.g., `"Vehicle.ADAS.*"`).
  Future<pb.ListMetadataResponse> listMetadata({String filter = ''}) {
    final request = pb.ListMetadataRequest(root: filter);
    return _client.listMetadata(request, options: _callOptions);
  }

  /// Returns the databroker server info (name, version, commit).
  Future<pb.GetServerInfoResponse> getServerInfo() {
    return _client.getServerInfo(
      pb.GetServerInfoRequest(),
      options: _callOptions,
    );
  }

  /// Closes the gRPC channel and releases all resources.
  Future<void> dispose() async {
    await _channel?.shutdown();
    _channel = null;
    _stub = null;
  }
}
