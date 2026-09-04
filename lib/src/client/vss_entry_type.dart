// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// The VSS entry type of a signal, as the databroker declares it in metadata.
library;

import '../generated/kuksa/val/v2/types.pbenum.dart' as pbenum;

/// Whether a VSS node is an attribute, a sensor or an actuator.
///
/// Named for the VSS specification rather than for the protobuf enum that
/// carries it, so a caller can filter [KuksaClient.expand] without importing
/// generated code.
enum VssEntryType {
  /// A static property of the vehicle (`Vehicle.VehicleIdentification.VIN`).
  attribute,

  /// A value the vehicle measures (`Vehicle.Exterior.AirTemperature`).
  sensor,

  /// A value that can be set (`Vehicle.Body.Windshield.Front.Wiping.Intensity`).
  actuator,
}

/// Maps the wire enum to [VssEntryType]; `null` for `ENTRY_TYPE_UNSPECIFIED`.
VssEntryType? vssEntryTypeFrom(pbenum.EntryType type) {
  switch (type) {
    case pbenum.EntryType.ENTRY_TYPE_ATTRIBUTE:
      return VssEntryType.attribute;
    case pbenum.EntryType.ENTRY_TYPE_SENSOR:
      return VssEntryType.sensor;
    case pbenum.EntryType.ENTRY_TYPE_ACTUATOR:
      return VssEntryType.actuator;
    case pbenum.EntryType.ENTRY_TYPE_UNSPECIFIED:
      return null;
  }
  return null;
}
