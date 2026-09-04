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
import 'vss_datatype.dart';

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

  /// Datatype per signal path, as this databroker declared it.
  ///
  /// A signal's datatype does not change while a databroker is running, so the
  /// metadata lookup behind [resolveDataType] is made once per path and reused
  /// — a provider publishing at 50 Hz pays for it on its first write only.
  final Map<String, VssDataType> _dataTypeCache = {};

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
  /// ## One absent signal ends the whole subscription
  ///
  /// `kuksa.val.v2` subscribes to [paths] as a single all-or-nothing request.
  /// If the databroker does not know **one** of them it answers `NOT_FOUND`
  /// and **no** signal is ever delivered — measured against databroker 0.7.0:
  /// `[Vehicle.Speed]` streams, `[Vehicle.Speed, <absent>]` dies.
  ///
  /// Vehicles differ in which VSS leaves they expose, so a consumer that asks
  /// for six safety signals loses all six on the one the vehicle lacks. Set
  /// [skipUnknownPaths] to subscribe to the signals this databroker actually
  /// has and be *told* which ones it lacks, instead of going blind.
  Stream<Map<String, Datapoint>> subscribe(
    List<String> paths, {
    /// Server-side buffer size per signal (0 = keep only latest value).
    /// Increase for high-frequency signals (e.g., wheel speed at 50 Hz).
    int bufferSize = 0,

    /// Subscribe to the paths this databroker knows instead of failing the
    /// whole stream on the ones it does not (see [resolveKnownPaths]).
    ///
    /// Absent paths are never silently dropped: they are reported to
    /// [onUnknownPaths], and if *none* of [paths] is known the stream errors
    /// with [UnknownSignalPathsException] rather than completing empty.
    bool skipUnknownPaths = false,

    /// Called once, before the stream opens, with the subset of [paths] this
    /// databroker does not know. Only invoked when it is non-empty.
    ///
    /// Treat those signals as unmeasured — not as safe. A missing road-friction
    /// leaf is [RoadGrip.unknown], never a clear road.
    void Function(List<String> unknownPaths)? onUnknownPaths,
  }) {
    if (!skipUnknownPaths) {
      return _subscribeExact(paths, bufferSize);
    }
    return _subscribeKnown(paths, bufferSize, onUnknownPaths);
  }

  Stream<Map<String, Datapoint>> _subscribeExact(
    List<String> paths,
    int bufferSize,
  ) {
    final request = pb.SubscribeRequest(
      signalPaths: paths,
      bufferSize: bufferSize,
    );

    return _client.subscribe(request, options: _callOptions).map((response) => {
          for (final entry in response.entries.entries)
            entry.key: Datapoint(raw: entry.value, path: entry.key),
        });
  }

  Stream<Map<String, Datapoint>> _subscribeKnown(
    List<String> paths,
    int bufferSize,
    void Function(List<String>)? onUnknownPaths,
  ) async* {
    final known = await resolveKnownPaths(paths);
    final unknown = paths.where((p) => !known.contains(p)).toList();

    if (unknown.isNotEmpty) onUnknownPaths?.call(unknown);
    if (known.isEmpty) throw UnknownSignalPathsException(unknown);

    yield* _subscribeExact(known, bufferSize);
  }

  /// Returns the subset of [paths] this databroker knows, in the given order.
  ///
  /// A path is *known* when the databroker holds metadata for it — whether or
  /// not a provider has ever written a value. Both are distinguished from an
  /// absent path, which is the only kind [subscribe] may drop.
  ///
  /// Only `NOT_FOUND` marks a path unknown. Any other gRPC failure
  /// (`UNAVAILABLE`, `UNAUTHENTICATED`, …) is rethrown: a databroker that is
  /// unreachable or refusing us has not told us the signal is absent, and
  /// treating it as absent would drop signals the vehicle really has.
  Future<List<String>> resolveKnownPaths(List<String> paths) async {
    final known = <String>[];
    for (final path in paths) {
      try {
        final metadata = await listMetadata(filter: path);
        for (final m in metadata.metadata.where((m) => m.path == path)) {
          known.add(path);
          // This response already carries the datatype; remember it so a later
          // publish on the same path costs no second round-trip.
          final type = vssDataTypeFrom(m.dataType);
          if (type != null) _dataTypeCache[path] = type;
        }
      } on GrpcError catch (e) {
        if (e.code != StatusCode.notFound) rethrow;
      }
    }
    return known;
  }

  /// The VSS datatype this databroker declares for [path].
  ///
  /// Read once per path from the broker's own signal metadata and cached; pass
  /// `refresh: true` to re-read it.
  ///
  /// The broker is the authority here, not a vendored copy of the
  /// specification. A vehicle serves the VSS leaves it actually has, plus any
  /// overlay its integrator added, and only the broker knows that set. Throws
  /// [UnknownSignalPathsException] if this databroker does not know [path].
  Future<VssDataType> resolveDataType(String path,
      {bool refresh = false}) async {
    if (!refresh) {
      final cached = _dataTypeCache[path];
      if (cached != null) return cached;
    }
    final pb.ListMetadataResponse response;
    try {
      response = await listMetadata(filter: path);
    } on GrpcError catch (e) {
      // Only NOT_FOUND means the databroker does not have this signal. Any
      // other failure (UNAVAILABLE, UNAUTHENTICATED, ...) has told us nothing
      // about the signal, and reporting it as absent would hide the real
      // fault behind a plausible one.
      if (e.code == StatusCode.notFound) {
        throw UnknownSignalPathsException([path]);
      }
      rethrow;
    }
    for (final m in response.metadata) {
      if (m.path != path) continue;
      final type = vssDataTypeFrom(m.dataType);
      if (type == null) {
        throw UndeclaredSignalDataTypeException(path);
      }
      _dataTypeCache[path] = type;
      return type;
    }
    throw UnknownSignalPathsException([path]);
  }

  /// Publishes a single value for [path] to the databroker.
  ///
  /// This is the provider-side write path (`kuksa.val.v2.VAL/PublishValue`):
  /// a provider claiming a signal pushes its current value so consumers can
  /// read or subscribe to it.
  ///
  /// ## The wire type follows the SIGNAL, not the Dart value
  ///
  /// [value] is encoded into the `kuksa.val.v2.Value` field that this
  /// databroker accepts for [path], looked up from the signal's declared VSS
  /// datatype via [resolveDataType]. A Dart `int` is not enough to choose that
  /// field: `uint8`, `uint16` and `uint32` signals all travel in the `uint32`
  /// field, `int8`/`int16`/`int32` all travel in `int32`, and VSS 6.1rc2
  /// declares only 9 of its 1382 leaves as `int32`.
  ///
  /// Until 0.2.6 this method mapped every Dart `int` to `int32`, so publishing
  /// `Vehicle.Exterior.RoadSurfaceCondition` — a `uint8` — failed with
  /// `INVALID_ARGUMENT: Wrong type provided` and there was no supported way to
  /// write it.
  ///
  /// Accepted Dart types per VSS datatype:
  ///
  /// | VSS datatype                          | Dart value            |
  /// |---------------------------------------|-----------------------|
  /// | `boolean`                             | `bool`                |
  /// | `string`                              | `String`              |
  /// | `int8` `int16` `int32` `int64`        | `int`                 |
  /// | `uint8` `uint16` `uint32` `uint64`    | `int`                 |
  /// | `float` `double`                      | `double` (or `int`)   |
  /// | any `…[]` datatype                    | `List` of the above   |
  ///
  /// An `int` offered to a `float` or `double` signal is widened. A `double`
  /// offered to an integer signal is **refused** rather than truncated: a
  /// silently rounded value on a safety signal cannot be told apart from a
  /// measured one. Out-of-range integers are refused with the VSS datatype and
  /// the bound named — see [VssTypeMismatch].
  ///
  /// Costs one metadata lookup the first time a given [path] is published to,
  /// and none afterwards. Use [publishTyped] to skip it entirely.
  ///
  /// Example:
  /// ```dart
  /// await client.publishValue('Vehicle.Speed', 100.34);            // float
  /// await client.publishValue(kRoadSurfaceCondition, 4);           // uint8
  /// await client.publishValue('Vehicle.Diagnostics.DTCList', ['P0001']);
  /// ```
  Future<void> publishValue(String path, Object value) {
    if (value is! bool &&
        value is! int &&
        value is! double &&
        value is! String &&
        value is! List) {
      throw ArgumentError.value(
        value,
        'value',
        'Unsupported Dart type for publishValue. Pass bool, int, double, '
            'String, or a List of those. To state the VSS datatype yourself, '
            'use publishTyped().',
      );
    }
    return _publishResolved(path, value);
  }

  Future<void> _publishResolved(String path, Object value) async {
    final type = await resolveDataType(path);
    return publishTyped(path, type, value);
  }

  /// Publishes [value] for [path] as an explicitly stated VSS [type].
  ///
  /// Use when the datatype is already known and the metadata lookup that
  /// [publishValue] performs is not wanted — a provider writing one signal in a
  /// tight loop, or a test that must not depend on broker metadata.
  ///
  /// This is the supported way to control the wire encoding. It needs no
  /// protobuf import: state the VSS datatype and this package chooses the
  /// `Value` field the databroker accepts for it.
  ///
  /// ```dart
  /// await client.publishTyped(kRoadSurfaceCondition, VssDataType.uint8, 4);
  /// ```
  ///
  /// Throws [VssTypeMismatch] if [value] cannot be written as [type].
  Future<void> publishTyped(String path, VssDataType type, Object value) {
    return publishDatapoint(
      path,
      pb_types.Datapoint(
        value: encodeVssValue(path: path, type: type, value: value),
      ),
    );
  }

  /// Publishes a fully-formed protobuf [datapoint] for [path].
  ///
  /// **Prefer [publishValue] or [publishTyped].** Both cover every VSS datatype
  /// the wire format can carry, and neither requires the caller to import
  /// generated protobuf code.
  ///
  /// This method's parameter is the generated `kuksa.val.v2.Datapoint`, which
  /// collides by name with this package's own [Datapoint] wrapper, so reaching
  /// it means a prefixed import of `src/generated/…` — a private path that
  /// carries no API-stability promise. It stays public because consumers of
  /// 0.2.6 and earlier call it; it is not the recommended surface.
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
    _dataTypeCache.clear();
  }
}

/// Thrown when the databroker knows a path but declares no datatype for it.
class UndeclaredSignalDataTypeException implements Exception {
  /// The path whose metadata carried `DATA_TYPE_UNSPECIFIED`.
  final String path;

  const UndeclaredSignalDataTypeException(this.path);

  @override
  String toString() =>
      'UndeclaredSignalDataTypeException: the databroker knows '
      '$path but declares no datatype for it, so this client cannot tell '
      'which wire type to publish. Absence of a datatype is not a default: '
      'fix the databroker metadata rather than guessing.';
}

/// Thrown by [KuksaClient.subscribe] with `skipUnknownPaths: true` when the
/// databroker knows **none** of the requested paths.
///
/// The subscription fails loudly rather than handing back an empty stream: a
/// consumer that receives nothing and no error cannot tell "this vehicle is
/// safe" from "this vehicle told us nothing".
class UnknownSignalPathsException implements Exception {
  /// The requested paths, none of which the databroker knows.
  final List<String> paths;

  const UnknownSignalPathsException(this.paths);

  @override
  String toString() =>
      'UnknownSignalPathsException: the databroker knows none of the '
      'requested signals: ${paths.join(', ')}';
}
