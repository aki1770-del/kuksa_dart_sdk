// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// gRPC canonical client obligations, proved against a VAL server this test
/// controls.
///
/// Three of these are oracles for defects measured on 2026-09-09 against a
/// real databroker 0.7.1, and they run here against an in-process server
/// because the failure needs a broker that ENDS a stream on command or NEVER
/// answers — neither of which a real broker will do to order. No case here is
/// skipped and none needs a container: a suite of skips is not a pass.
///
///  - a subscription the broker ends closes SILENTLY (`onDone`, no error)
///  - a unary call has no deadline and waits forever (grpc.io: *"By default,
///    gRPC does not set a deadline which means it is possible for a client to
///    end up waiting for a response effectively forever."*)
///  - a deadline must NOT be applied to a subscription, or it kills a healthy
///    feed at a fixed age
@TestOn('vm')
library;

import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';
import 'package:kuksa_dart_sdk/src/generated/kuksa/val/v2/val.pb.dart' as pb;
import 'package:kuksa_dart_sdk/src/generated/kuksa/val/v2/val.pbgrpc.dart'
    as pb_grpc;
import 'package:kuksa_dart_sdk/src/generated/kuksa/val/v2/types.pb.dart'
    as pb_types;
import 'package:test/test.dart';

/// How the fake broker behaves, chosen per test.
enum Behaviour {
  /// Send one update, then end the stream the way a graceful shutdown does.
  endAfterOneUpdate,

  /// Keep sending updates. A healthy feed.
  streamForever,

  /// Accept the call and never answer it. A frozen broker.
  neverAnswer,
}

const _speed = 'Vehicle.Speed';

class FakeVal extends pb_grpc.VALServiceBase {
  FakeVal(this.behaviour);
  final Behaviour behaviour;

  static pb.SubscribeResponse _update(double v) => pb.SubscribeResponse(
        entries: [
          MapEntry(
            _speed,
            pb_types.Datapoint(value: pb_types.Value(float: v)),
          ),
        ],
      );

  @override
  Stream<pb.SubscribeResponse> subscribe(
      ServiceCall call, pb.SubscribeRequest request) async* {
    switch (behaviour) {
      case Behaviour.endAfterOneUpdate:
        yield _update(1);
        return; // graceful end — exactly what a broker restart looks like
      case Behaviour.streamForever:
        var v = 0.0;
        while (true) {
          await Future<void>.delayed(const Duration(milliseconds: 200));
          yield _update(v += 1);
        }
      case Behaviour.neverAnswer:
        await Completer<void>().future; // never completes
    }
  }

  @override
  Future<pb.GetValueResponse> getValue(
      ServiceCall call, pb.GetValueRequest request) async {
    if (behaviour == Behaviour.neverAnswer) await Completer<void>().future;
    return pb.GetValueResponse(
        dataPoint: pb_types.Datapoint(value: pb_types.Value(float: 1)));
  }

  // Nothing below is exercised; the base class requires them.
  Never _unused() => throw UnimplementedError('not used by these oracles');
  @override
  Future<pb.GetValuesResponse> getValues(ServiceCall c, pb.GetValuesRequest r) =>
      _unused();
  @override
  Stream<pb.SubscribeByIdResponse> subscribeById(
          ServiceCall c, pb.SubscribeByIdRequest r) =>
      _unused();
  @override
  Future<pb.ActuateResponse> actuate(ServiceCall c, pb.ActuateRequest r) =>
      _unused();
  @override
  Future<pb.ActuateResponse> actuateStream(
          ServiceCall c, Stream<pb.ActuateRequest> r) =>
      _unused();
  @override
  Future<pb.BatchActuateResponse> batchActuate(
          ServiceCall c, pb.BatchActuateRequest r) =>
      _unused();
  @override
  Future<pb.ListMetadataResponse> listMetadata(
          ServiceCall c, pb.ListMetadataRequest r) =>
      _unused();
  @override
  Future<pb.PublishValueResponse> publishValue(
          ServiceCall c, pb.PublishValueRequest r) =>
      _unused();
  @override
  Stream<pb.OpenProviderStreamResponse> openProviderStream(
          ServiceCall c, Stream<pb.OpenProviderStreamRequest> r) =>
      _unused();
  @override
  Future<pb.GetServerInfoResponse> getServerInfo(
          ServiceCall c, pb.GetServerInfoRequest r) =>
      _unused();
}

/// Starts a fake broker on an ephemeral port and returns it.
Future<Server> startBroker(Behaviour behaviour) async {
  final server = Server.create(services: [FakeVal(behaviour)]);
  await server.serve(address: 'localhost', port: 0);
  return server;
}

/// The first thing that happens to [stream]: data, an error, its end, or
/// nothing at all within [patience].
Future<String> firstOutcome(
  Stream<Map<String, Datapoint>> stream, {
  Duration patience = const Duration(seconds: 3),
  int afterUpdates = 1,
}) {
  final done = Completer<String>();
  var seen = 0;
  late StreamSubscription<Map<String, Datapoint>> sub;
  sub = stream.listen(
    (u) {
      if (++seen >= afterUpdates && !done.isCompleted) {
        done.complete('data($seen)');
      }
    },
    onError: (Object e) =>
        done.isCompleted ? null : done.complete('error:${e.runtimeType}'),
    onDone: () => done.isCompleted ? null : done.complete('closed-silently'),
  );
  return done.future
      .timeout(patience, onTimeout: () => 'nothing-happened')
      .whenComplete(sub.cancel);
}

void main() {
  group('a subscription the broker ENDS must not read as a clear road', () {
    late Server broker;
    setUp(() async => broker = await startBroker(Behaviour.endAfterOneUpdate));
    tearDown(() async => broker.shutdown());

    test('DEFECT, characterised: by default it closes silently — no error',
        () async {
      final c = KuksaClient(host: 'localhost', port: broker.port!);
      await c.connect();
      addTearDown(c.dispose);

      // Consume past the single update, the way `await for` does.
      final outcome = await firstOutcome(
        c.subscribe([_speed]).skip(1),
      );
      expect(outcome, 'closed-silently',
          reason: 'this is the whole problem: an ended subscription and a '
              'quiet road are the same event to the consumer');
    });

    test('FIX: errorOnEnd surfaces it where a safety consumer already looks',
        () async {
      final c = KuksaClient(host: 'localhost', port: broker.port!);
      await c.connect();
      addTearDown(c.dispose);

      Object? caught;
      try {
        await for (final _ in c.subscribe([_speed], errorOnEnd: true)) {}
      } catch (e) {
        caught = e;
      }
      expect(caught, isA<SubscriptionEndedException>());
      expect(
        caught.toString(),
        allOf(
          contains(_speed),
          contains('No further values will arrive'),
          contains('not as last known good'),
        ),
        reason: 'the message must tell the consumer what to DO — treat the '
            'signal as unmeasured — not merely that a stream ended',
      );
    });

  });

  group('cancelling is not the broker ending the stream', () {
    late Server broker;
    setUp(() async => broker = await startBroker(Behaviour.streamForever));
    tearDown(() async => broker.shutdown());

    test('a consumer that cancels a LIVE feed is not told it lost the road',
        () async {
      final c = KuksaClient(host: 'localhost', port: broker.port!);
      await c.connect();
      addTearDown(c.dispose);

      Object? caught;
      var updates = 0;
      final sub = c.subscribe([_speed], errorOnEnd: true).listen(
            (_) => updates++,
            onError: (Object e) => caught = e,
          );
      await Future<void>.delayed(const Duration(milliseconds: 700));
      expect(updates, greaterThan(0), reason: 'the feed must be live first');
      await sub.cancel();
      await Future<void>.delayed(const Duration(milliseconds: 500));
      expect(caught, isNull,
          reason: 'a consumer shutting down cleanly has not lost the road; '
              'errorOnEnd is for the BROKER ending the stream, and an async* '
              'generator that is cancelled is never resumed past its loop');
    });
  });

  group('a unary call must be able to give up', () {
    late Server broker;
    setUp(() async => broker = await startBroker(Behaviour.neverAnswer));
    tearDown(() async => broker.shutdown());

    test('DEFECT: with no callTimeout, getValue waits forever', () async {
      final c = KuksaClient(host: 'localhost', port: broker.port!);
      await c.connect();
      // dispose(timeout:) is required here, not decoration: the graceful
      // shutdown blocks on the very call this test leaves outstanding.
      addTearDown(() => c.dispose(timeout: const Duration(seconds: 2)));
      expect(c.callTimeout, isNull, reason: 'the 0.2.8 default is unchanged');

      var settled = false;
      unawaited(c.getValue(_speed).then((_) => settled = true,
          onError: (_) => settled = true));
      await Future<void>.delayed(const Duration(seconds: 3));
      expect(settled, isFalse,
          reason: 'grpc.io: without a deadline a client can wait for a '
              'response effectively forever — measured here, it does');
    });

    test('DEFECT+FIX: dispose() hangs on a frozen broker; dispose(timeout:) '
        'returns', () async {
      final c = KuksaClient(host: 'localhost', port: broker.port!);
      await c.connect();
      unawaited(c.getValue(_speed).then((_) {}, onError: (_) {}));
      await Future<void>.delayed(const Duration(milliseconds: 400));

      // The graceful path cannot finish: shutdown() lets in-progress RPCs
      // complete, and this one never will.
      var gracefulReturned = false;
      final graceful = KuksaClient(host: 'localhost', port: broker.port!);
      await graceful.connect();
      unawaited(graceful.getValue(_speed).then((_) {}, onError: (_) {}));
      await Future<void>.delayed(const Duration(milliseconds: 400));
      unawaited(graceful.dispose().then((_) => gracefulReturned = true));
      await Future<void>.delayed(const Duration(seconds: 2));
      expect(gracefulReturned, isFalse,
          reason: 'channel.dart:28-31 — shutdown() waits for RPCs already in '
              'progress, and this broker answers none of them');

      // The bounded path gives up and terminates.
      await c
          .dispose(timeout: const Duration(milliseconds: 700))
          .timeout(const Duration(seconds: 5));
    });

    test('FIX: callTimeout makes it fail as DEADLINE_EXCEEDED', () async {
      final c = KuksaClient(
        host: 'localhost',
        port: broker.port!,
        callTimeout: const Duration(milliseconds: 800),
      );
      await c.connect();
      addTearDown(c.dispose);

      await expectLater(
        c.getValue(_speed),
        throwsA(isA<GrpcError>().having(
            (e) => e.code, 'code', StatusCode.deadlineExceeded)),
      );
    });
  });

  group('a deadline must never be applied to a subscription', () {
    late Server broker;
    setUp(() async => broker = await startBroker(Behaviour.streamForever));
    tearDown(() async => broker.shutdown());

    test('a healthy feed outlives callTimeout many times over', () async {
      final c = KuksaClient(
        host: 'localhost',
        port: broker.port!,
        callTimeout: const Duration(milliseconds: 500),
      );
      await c.connect();
      addTearDown(c.dispose);

      // 8 updates at 200 ms is ~1.6 s, more than three callTimeouts. If the
      // deadline ever reaches the stream, this arrives as an error instead.
      final outcome = await firstOutcome(
        c.subscribe([_speed]),
        afterUpdates: 8,
        patience: const Duration(seconds: 6),
      );
      expect(outcome, 'data(8)',
          reason: 'grpc-dart arms the deadline as a wall-clock timer at call '
              'creation (call.dart:226); routing callTimeout into the '
              'subscription would kill a working safety feed on a timer');
    });
  });

  group('a stall watchdog and an ended stream are DIFFERENT failures', () {
    test('REFUTES "one mechanism answers both": a stallTimeout does NOT fire '
        'when the broker ENDS the stream', () async {
      final broker = await startBroker(Behaviour.endAfterOneUpdate);
      addTearDown(broker.shutdown);
      final c = KuksaClient(host: 'localhost', port: broker.port!);
      await c.connect();
      addTearDown(c.dispose);

      // A watchdog measures silence between messages. A closed stream is not
      // silence — it is closure, and Stream.timeout completes with it.
      final outcome = await firstOutcome(
        c.subscribe([_speed], stallTimeout: const Duration(milliseconds: 400))
            .skip(1),
        patience: const Duration(seconds: 3),
      );
      expect(outcome, 'closed-silently',
          reason: 'an inactivity watchdog cannot catch a graceful end, so '
              'errorOnEnd is not redundant with stallTimeout — the two cover '
              'different failures and a consumer wanting both sets both');
    });

    test('a stalled feed IS caught, and the two compose', () async {
      final broker = await startBroker(Behaviour.neverAnswer);
      addTearDown(broker.shutdown);
      final c = KuksaClient(host: 'localhost', port: broker.port!);
      await c.connect();
      addTearDown(() => c.dispose(timeout: const Duration(seconds: 2)));

      Object? caught;
      try {
        await for (final _ in c.subscribe([_speed],
            errorOnEnd: true, stallTimeout: const Duration(milliseconds: 600))) {}
      } catch (e) {
        caught = e;
      }
      expect(caught, isA<SubscriptionStalledException>());
      expect(caught.toString(),
          allOf(contains('UNMEASURED'), contains('not as last known good')));
    });

    test('a healthy feed is never called stalled', () async {
      final broker = await startBroker(Behaviour.streamForever);
      addTearDown(broker.shutdown);
      final c = KuksaClient(host: 'localhost', port: broker.port!);
      await c.connect();
      addTearDown(c.dispose);

      // Updates every 200 ms; a 900 ms window must be reset by each one.
      final outcome = await firstOutcome(
        c.subscribe([_speed], stallTimeout: const Duration(milliseconds: 900)),
        afterUpdates: 10,
        patience: const Duration(seconds: 8),
      );
      expect(outcome, 'data(10)',
          reason: 'the window is per-message, not per-subscription');
    });
  });

  group('the 0.2.8 channel is what a caller still gets by default', () {
    test('every new knob defaults to "leave grpc-dart alone"', () {
      final c = KuksaClient(host: 'localhost');
      expect(c.keepAlive, isNull);
      expect(c.connectTimeout, isNull);
      expect(c.idleTimeout, isNull);
      expect(c.callTimeout, isNull);
    });

    test('keepalive is reachable at all, which it was not before', () {
      final c = KuksaClient(
        host: 'localhost',
        keepAlive: const ClientKeepAliveOptions(
          pingInterval: Duration(seconds: 10),
          timeout: Duration(seconds: 5),
          permitWithoutCalls: true,
        ),
        connectTimeout: const Duration(seconds: 2),
        idleTimeout: const Duration(minutes: 30),
      );
      expect(c.keepAlive!.pingInterval, const Duration(seconds: 10));
      expect(c.keepAlive!.shouldSendPings, isTrue,
          reason: 'grpc-dart sends NO pings unless pingInterval is set, and '
              'until 0.2.9 there was no way to set it through this client');
      expect(c.connectTimeout, const Duration(seconds: 2));
      expect(c.idleTimeout, const Duration(minutes: 30));
    });
  });
}
