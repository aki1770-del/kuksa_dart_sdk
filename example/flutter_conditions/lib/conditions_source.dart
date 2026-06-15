// SPDX-License-Identifier: Apache-2.0
//
// The seam between the kuksa_dart_sdk VSS stream and the widget layer.
//
// Keeping the databroker behind an interface lets the widget be unit-tested
// against a fake source (no databroker needed), while the real implementation
// does the one realistic thing the SDK contract demands: each subscribe update
// carries only the signals that CHANGED, so we merge into a rolling snapshot
// before mapping — otherwise a value that stopped changing would be lost.

import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

import 'driving_conditions.dart';

/// A source of [DrivingConditions] updates for [ConditionsMonitor].
///
/// The widget owns the *subscription lifecycle* over this stream; the source
/// owns *connecting and producing* it. Abstracting it this way is what makes
/// the widget's lifecycle (cancel-on-dispose, degrade-on-error, reconnect)
/// testable without a live databroker.
abstract class ConditionsSource {
  /// A stream of assessments, newest last.
  ///
  /// Calling this opens a fresh subscription; the returned stream completes
  /// (`onDone`) when the underlying server stream ends and emits `onError`
  /// when it breaks. Cancelling the listener must tear the source down.
  Stream<DrivingConditions> conditions();

  /// Releases any transport resources (e.g. the gRPC channel).
  Future<void> dispose();
}

/// Real [ConditionsSource] backed by a KUKSA databroker over `kuksa.val.v2`.
class KuksaConditionsSource implements ConditionsSource {
  KuksaConditionsSource({this.host = 'localhost', this.port = 55555});

  final String host;
  final int port;

  KuksaClient? _client;

  /// Rolling view of the latest value seen for each subscribed signal. The
  /// databroker only resends a signal when it changes, so we accumulate.
  final Map<String, Datapoint> _snapshot = {};

  @override
  Stream<DrivingConditions> conditions() async* {
    _snapshot.clear();
    final client = _client = KuksaClient(host: host, port: port);
    await client.connect();

    // `await for` over the SDK stream means: cancelling OUR subscription
    // cancels this loop, which cancels the underlying gRPC stream — the
    // correct teardown the AGL examples were missing. When the server stream
    // ends, the loop completes and our stream emits `onDone`.
    await for (final update in client.subscribe(kSnowSafetySignals)) {
      _snapshot.addAll(update);
      // Hand out a defensive copy so a downstream holder can't mutate ours.
      yield DrivingConditions.fromSignals(Map<String, Datapoint>.of(_snapshot));
    }
  }

  @override
  Future<void> dispose() async {
    await _client?.dispose();
    _client = null;
  }
}
