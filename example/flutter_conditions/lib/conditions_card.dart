// SPDX-License-Identifier: Apache-2.0
//
// Pure presentation: render a [DrivingConditions] + connection status. No
// stream, no state — which is exactly why it is trivial to pump in a widget
// test and capture as a PNG so a reviewer can go and see the actual output.

import 'package:flutter/material.dart';

import 'driving_conditions.dart';

/// Lifecycle state of the underlying conditions subscription.
enum ConditionsConnection {
  /// Subscription opened, no assessment received yet.
  connecting,

  /// Receiving live assessments from the databroker.
  live,

  /// The stream emitted an error; reading is no longer trusted.
  error,

  /// The server stream ended cleanly; no more updates without reconnect.
  ended,
}

/// A minimal, honest "driving conditions" card.
class DrivingConditionsCard extends StatelessWidget {
  const DrivingConditionsCard({
    super.key,
    required this.conditions,
    required this.connection,
    this.onReconnect,
  });

  final DrivingConditions conditions;
  final ConditionsConnection connection;

  /// Shown only when the subscription is broken/ended.
  final VoidCallback? onReconnect;

  Color get _accent {
    switch (conditions.surface) {
      case SurfaceState.ice:
        return const Color(0xFF7E1F2E); // deep red
      case SurfaceState.snow:
        return const Color(0xFF1B5EA6); // blue
      case SurfaceState.wet:
        return const Color(0xFF8A5A00); // amber-brown
      case SurfaceState.dry:
        return const Color(0xFF1E6E3C); // green
      case SurfaceState.unknown:
        return const Color(0xFF4A4F57); // grey
    }
  }

  IconData get _icon {
    switch (conditions.surface) {
      case SurfaceState.ice:
        return Icons.ac_unit;
      case SurfaceState.snow:
        return Icons.cloudy_snowing;
      case SurfaceState.wet:
        return Icons.water_drop;
      case SurfaceState.dry:
        return Icons.check_circle;
      case SurfaceState.unknown:
        return Icons.help_outline;
    }
  }

  ({String label, Color color, IconData icon}) get _conn {
    switch (connection) {
      case ConditionsConnection.connecting:
        return (label: 'Connecting…', color: Colors.grey, icon: Icons.sync);
      case ConditionsConnection.live:
        return (label: 'Live', color: Colors.green, icon: Icons.sensors);
      case ConditionsConnection.error:
        return (
          label: 'Signal lost',
          color: Colors.red,
          icon: Icons.sensors_off
        );
      case ConditionsConnection.ended:
        return (
          label: 'Stream ended',
          color: Colors.orange,
          icon: Icons.link_off
        );
    }
  }

  List<String> get _received {
    final c = conditions;
    final out = <String>[];
    // RoadFriction is a VSS percent (0..100) — never a 0.0-1.0 fraction — so it
    // is rendered with a % sign. A null reading is simply not listed: absence is
    // shown as absence, never as a friction number.
    if (c.roadFriction != null) {
      out.add('Road friction ${c.roadFriction!.toStringAsFixed(0)}%');
    }
    if (c.tcsEngaged != null) {
      out.add('Traction control ${c.tcsEngaged! ? "ENGAGED" : "off"}');
    }
    if (c.absEngaged != null) {
      out.add('ABS ${c.absEngaged! ? "ENGAGED" : "off"}');
    }
    if (c.wiperIntensity != null) out.add('Wipers level ${c.wiperIntensity}');
    if (c.rainIntensity != null) out.add('Rain sensor ${c.rainIntensity}%');
    if (c.airTempC != null) {
      out.add('Air temp ${c.airTempC!.toStringAsFixed(1)} °C');
    }
    if (c.speedKmh != null) {
      out.add('Speed ${c.speedKmh!.toStringAsFixed(0)} km/h');
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final conn = _conn;
    final received = _received;
    final showReconnect = connection == ConditionsConnection.error ||
        connection == ConditionsConnection.ended;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection status row.
            Row(
              children: [
                Icon(conn.icon, size: 16, color: conn.color),
                const SizedBox(width: 6),
                Text(
                  conn.label,
                  style: TextStyle(
                    color: conn.color,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Headline: the surface state (UNKNOWN when not enough signal).
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Text(
                  conditions.surface.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: _accent,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Advisory.
            Text(
              conditions.advisory,
              style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
            ),
            const SizedBox(height: 14),

            // Signals received (only the ones the vehicle actually reported).
            Text(
              'Signals received',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
                letterSpacing: 0.5,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 6),
            if (received.isEmpty)
              const Text(
                'No vehicle signals received yet.',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                ),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final s in received)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(
                            fontSize: 12, fontFamily: 'Roboto'),
                      ),
                    ),
                ],
              ),

            if (showReconnect) ...[
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onReconnect,
                icon: const Icon(Icons.refresh),
                label: const Text('Reconnect'),
              ),
            ],

            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Honesty caveat.
            Text(
              'Demonstration — not safety-critical. Conditions are derived from '
              "vehicle bus signals only. Visibility is never estimated; a "
              'warning never produces a number; null / UNKNOWN means the '
              "driver's own judgment.",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                height: 1.3,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
