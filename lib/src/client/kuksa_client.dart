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
///   final friction = update[kRoadFrictionMostProbable]?.floatValue;
///   if (friction != null && friction < 0.3) activateSnowRoutingMode();
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
  ///   final friction = update[kRoadFrictionMostProbable]?.floatValue;
  ///   final tcs = update[kTcsIsEngaged]?.boolValue;
  ///   if ((friction ?? 1.0) < 0.3 || (tcs ?? false)) {
  ///     navigationBloc.add(SnowConditionsDetected());
  ///   }
  /// }
  /// ```
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

    return _client
        .subscribe(request, options: _callOptions)
        .map((response) => {
              for (final entry in response.entries.entries)
                entry.key: Datapoint(raw: entry.value, path: entry.key),
            });
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
