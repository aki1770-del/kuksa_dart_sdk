// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// Dart-idiomatic wrapper around the generated [kuksa.val.v2.Datapoint] message.
///
/// Provides a typed [value] getter and helpers for each VSS primitive type
/// without exposing protobuf internals to callers.
library;

import '../generated/kuksa/val/v2/types.pb.dart' as pb;

/// The set of value types a VSS signal can carry.
enum DatapointType {
  string,
  boolean,
  int32,
  int64,
  uint32,
  uint64,
  float,
  double_,
  stringArray,
  boolArray,
  int32Array,
  int64Array,
  uint32Array,
  uint64Array,
  floatArray,
  doubleArray,
  none,
}

/// Typed wrapper around a KUKSA databroker [Datapoint].
///
/// The raw protobuf [Datapoint] uses a `oneof` for value types.
/// This class surfaces the value as a plain Dart [Object?] and provides
/// per-type accessors for ergonomic use in navigation logic.
class Datapoint {
  /// The underlying protobuf message (available for advanced use).
  final pb.Datapoint raw;

  /// The VSS signal path this datapoint was received for.
  final String path;

  const Datapoint({required this.raw, required this.path});

  /// Whether this datapoint carries a value (vs. explicit None / absent).
  bool get hasValue => raw.hasValue();

  /// The active value type, or [DatapointType.none] if absent.
  DatapointType get type {
    if (!raw.hasValue()) return DatapointType.none;
    final v = raw.value;
    if (v.hasString()) return DatapointType.string;
    if (v.hasBool_12()) return DatapointType.boolean;
    if (v.hasInt32()) return DatapointType.int32;
    if (v.hasInt64()) return DatapointType.int64;
    if (v.hasUint32()) return DatapointType.uint32;
    if (v.hasUint64()) return DatapointType.uint64;
    if (v.hasFloat()) return DatapointType.float;
    if (v.hasDouble_18()) return DatapointType.double_;
    if (v.hasStringArray()) return DatapointType.stringArray;
    if (v.hasBoolArray()) return DatapointType.boolArray;
    if (v.hasInt32Array()) return DatapointType.int32Array;
    if (v.hasInt64Array()) return DatapointType.int64Array;
    if (v.hasUint32Array()) return DatapointType.uint32Array;
    if (v.hasUint64Array()) return DatapointType.uint64Array;
    if (v.hasFloatArray()) return DatapointType.floatArray;
    if (v.hasDoubleArray()) return DatapointType.doubleArray;
    return DatapointType.none;
  }

  /// The value as an untyped [Object?].
  ///
  /// Returns null if [hasValue] is false.
  Object? get value {
    if (!raw.hasValue()) return null;
    final v = raw.value;
    if (v.hasString()) return v.string;
    if (v.hasBool_12()) return v.bool_12;
    if (v.hasInt32()) return v.int32;
    if (v.hasInt64()) return v.int64.toInt();
    if (v.hasUint32()) return v.uint32;
    if (v.hasUint64()) return v.uint64.toInt();
    if (v.hasFloat()) return v.float;
    if (v.hasDouble_18()) return v.double_18;
    if (v.hasStringArray()) return v.stringArray.values;
    if (v.hasBoolArray()) return v.boolArray.values;
    if (v.hasInt32Array()) return v.int32Array.values;
    if (v.hasInt64Array()) {
      return v.int64Array.values.map((i) => i.toInt()).toList();
    }
    if (v.hasUint32Array()) return v.uint32Array.values;
    if (v.hasUint64Array()) {
      return v.uint64Array.values.map((i) => i.toInt()).toList();
    }
    if (v.hasFloatArray()) return v.floatArray.values;
    if (v.hasDoubleArray()) return v.doubleArray.values;
    return null;
  }

  /// Convenience accessors — return null if the signal has a different type.

  String? get stringValue =>
      type == DatapointType.string ? raw.value.string : null;
  bool? get boolValue =>
      type == DatapointType.boolean ? raw.value.bool_12 : null;
  int? get int32Value => type == DatapointType.int32 ? raw.value.int32 : null;
  int? get int64Value =>
      type == DatapointType.int64 ? raw.value.int64.toInt() : null;
  int? get uint32Value =>
      type == DatapointType.uint32 ? raw.value.uint32 : null;
  int? get uint64Value =>
      type == DatapointType.uint64 ? raw.value.uint64.toInt() : null;
  double? get floatValue =>
      type == DatapointType.float ? raw.value.float.toDouble() : null;
  double? get doubleValue =>
      type == DatapointType.double_ ? raw.value.double_18 : null;

  @override
  String toString() => 'Datapoint($path: ${value ?? "none"})';
}
