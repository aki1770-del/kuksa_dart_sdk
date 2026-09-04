// SPDX-License-Identifier: Apache-2.0
//
// The stateful widget that owns the subscription lifecycle.
//
// This is the part that matters: a long-running navigation UI subscribed to a
// vehicle signal stream must (a) cancel the subscription when it is disposed,
// (b) survive the stream erroring or ending — by degrading to an HONEST UNKNOWN
// rather than freezing on a stale reading or fabricating one — and (c) offer a
// clean reconnect. A subscription that is listened-to but never cancelled, and
// never handles onError/onDone, is exactly how a UI "stops updating after a
// while" without anyone noticing.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kuksa_dart_sdk/kuksa_dart_sdk.dart';

import 'conditions_card.dart';
import 'conditions_source.dart';
import 'driving_conditions.dart';

class ConditionsMonitor extends StatefulWidget {
  const ConditionsMonitor({super.key, required this.source});

  final ConditionsSource source;

  @override
  State<ConditionsMonitor> createState() => _ConditionsMonitorState();
}

class _ConditionsMonitorState extends State<ConditionsMonitor> {
  StreamSubscription<DrivingConditions>? _sub;

  // Start UNKNOWN: with no signal yet we must not imply a condition.
  DrivingConditions _conditions = const DrivingConditions();
  ConditionsConnection _connection = ConditionsConnection.connecting;
  String? _errorDetail;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() {
    // Cancel any prior subscription before opening a fresh one — this is the
    // teardown that tears down the underlying gRPC stream on reconnect.
    _sub?.cancel();
    setState(() {
      _connection = ConditionsConnection.connecting;
      _conditions = const DrivingConditions(); // honest reset to UNKNOWN
      _errorDetail = null;
    });

    _sub = widget.source.conditions().listen(
      (c) {
        if (!mounted) return;
        setState(() {
          _conditions = c;
          _connection = ConditionsConnection.live;
        });
      },
      onError: (Object error, StackTrace stack) {
        if (!mounted) return;
        // The stream broke. Do NOT keep showing the last reading and do NOT
        // fabricate one — degrade to UNKNOWN and let the driver reconnect.
        setState(() {
          _conditions = const DrivingConditions();
          _connection = ConditionsConnection.error;
          // Name the cause when the SDK named it. A vehicle that reports none
          // of the signals this card needs is a different fact from a broken
          // link — and Reconnect will not fix it — so it must not hide behind
          // the same "Signal lost".
          _errorDetail = error is UnknownSignalPathsException
              ? 'This vehicle reports none of the signals this card needs: '
                  '${error.paths.join(', ')}'
              : null;
        });
      },
      onDone: () {
        if (!mounted) return;
        setState(() {
          _conditions = const DrivingConditions();
          _connection = ConditionsConnection.ended;
        });
      },
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    // The lifecycle fix: always cancel, and release the source's transport.
    _sub?.cancel();
    _sub = null;
    widget.source.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DrivingConditionsCard(
      conditions: _conditions,
      connection: _connection,
      onReconnect: _connect,
      errorDetail: _errorDetail,
    );
  }
}
