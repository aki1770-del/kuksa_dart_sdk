// SPDX-License-Identifier: Apache-2.0
//
// Runnable entry point. Against a live databroker on localhost:55555 this shows
// driving conditions updating in real time; with no databroker it shows the
// honest "Connecting…" / UNKNOWN state and a Reconnect button — never a
// fabricated reading.
//
//   dart run / flutter run   (start a kuksa-databroker first; see README)

import 'package:flutter/material.dart';

import 'conditions_monitor.dart';
import 'conditions_source.dart';

void main() => runApp(const KuksaConditionsApp());

class KuksaConditionsApp extends StatelessWidget {
  const KuksaConditionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KUKSA Driving Conditions',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(title: const Text('Driving conditions (KUKSA)')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ConditionsMonitor(source: KuksaConditionsSource()),
            ),
          ),
        ),
      ),
    );
  }
}
