// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// The VSS datatype of a signal, and the rule for putting a Dart value of that
/// datatype onto the `kuksa.val.v2` wire.
///
/// ## Why this file exists
///
/// `kuksa.val.v2.Value` is a `oneof` with sixteen arms, but VSS declares
/// twenty-six datatypes. The mapping between them is **many-to-one and not
/// inferable from a Dart value**: `uint8`, `uint16` and `uint32` all travel in
/// the `uint32` arm; `int8`, `int16` and `int32` all travel in `int32`. A Dart
/// `int` alone therefore cannot tell a client which arm to use — only the
/// signal's declared datatype can.
///
/// Until 0.2.6 this package mapped every Dart `int` to the `int32` arm. Against
/// VSS 6.1rc2 (1382 leaves) that is correct for **9 leaves** and wrong for
/// **411**, so a provider could not write `Vehicle.Exterior.RoadSurfaceCondition`
/// — a `uint8` — at all. The databroker answered `INVALID_ARGUMENT: Wrong type
/// provided` and the consumer had no way to tell that the fault was ours.
///
/// [wireArmFor] is the table that fixes it. It is not written from memory: see
/// the provenance note on that member.
library;

import 'package:fixnum/fixnum.dart';

import '../generated/kuksa/val/v2/types.pb.dart' as pb;
import '../generated/kuksa/val/v2/types.pbenum.dart' as pbenum;

/// A VSS datatype, as the databroker declares it in signal metadata.
///
/// Named for the VSS specification rather than for the protobuf arm that
/// carries it, because the specification is what an edge developer reads.
enum VssDataType {
  boolean,
  string,
  int8,
  int16,
  int32,
  int64,
  uint8,
  uint16,
  uint32,
  uint64,
  float,
  double_,
  timestamp,
  booleanArray,
  stringArray,
  int8Array,
  int16Array,
  int32Array,
  int64Array,
  uint8Array,
  uint16Array,
  uint32Array,
  uint64Array,
  floatArray,
  doubleArray,
  timestampArray,
}

/// The arms of the `kuksa.val.v2.Value` oneof.
///
/// Exposed so a caller can assert which arm a value was encoded into without
/// importing the generated protobuf code.
enum ValueArm {
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
}

/// The `kuksa.val.v2.Value` oneof arm a databroker accepts for [type], or null
/// when the wire format has no arm for it at all.
///
/// ## Provenance — this table was measured, not recalled
///
/// Two independent derivations, agreeing everywhere they overlap:
///
/// 1. **Measured** against `ghcr.io/eclipse-kuksa/kuksa-databroker` 0.7.1
///    carrying COVESA VSS 6.1rc2, by publishing all sixteen `Value` arms at a
///    real leaf of each datatype and recording which one the broker accepted.
///    Exactly one arm was accepted per datatype. VSS 6.1rc2 has leaves for
///    thirteen of these datatypes, so thirteen rows are measured directly.
/// 2. **Derived** from the databroker's own type check —
///    `databroker/src/broker.rs`, `fn validate_value`, the `match
///    self.metadata.data_type` arms — which is the code that returns
///    `UpdateError::WrongType`. This covers the rows VSS 6.1rc2 has no leaf to
///    probe (`int64`, `uint64`, and most array datatypes).
///
/// [VssDataType.timestamp] and [VssDataType.timestampArray] return **null**:
/// `kuksa.val.v2.Value` genuinely has no timestamp arm (its oneof tags are
/// 11-18 and 21-28, all accounted for), so such a signal cannot be published
/// through this API at all. That is a limit of the wire format, not of this
/// package, and it is reported as such rather than guessed at.
ValueArm? wireArmFor(VssDataType type) => switch (type) {
      VssDataType.boolean => ValueArm.boolean,
      VssDataType.string => ValueArm.string,
      // int8 and int16 are NARROWED into the int32 arm. The broker range-checks
      // them (`i8::try_from` / `i16::try_from`) and answers
      // `Value out of type bounds` — measured.
      VssDataType.int8 => ValueArm.int32,
      VssDataType.int16 => ValueArm.int32,
      VssDataType.int32 => ValueArm.int32,
      VssDataType.int64 => ValueArm.int64,
      // Likewise uint8 and uint16 narrow into the uint32 arm.
      VssDataType.uint8 => ValueArm.uint32,
      VssDataType.uint16 => ValueArm.uint32,
      VssDataType.uint32 => ValueArm.uint32,
      VssDataType.uint64 => ValueArm.uint64,
      VssDataType.float => ValueArm.float,
      VssDataType.double_ => ValueArm.double_,
      VssDataType.booleanArray => ValueArm.boolArray,
      VssDataType.stringArray => ValueArm.stringArray,
      VssDataType.int8Array => ValueArm.int32Array,
      VssDataType.int16Array => ValueArm.int32Array,
      VssDataType.int32Array => ValueArm.int32Array,
      VssDataType.int64Array => ValueArm.int64Array,
      VssDataType.uint8Array => ValueArm.uint32Array,
      VssDataType.uint16Array => ValueArm.uint32Array,
      VssDataType.uint32Array => ValueArm.uint32Array,
      VssDataType.uint64Array => ValueArm.uint64Array,
      VssDataType.floatArray => ValueArm.floatArray,
      VssDataType.doubleArray => ValueArm.doubleArray,
      VssDataType.timestamp => null,
      VssDataType.timestampArray => null,
    };

/// The inclusive range a VSS integer datatype admits, or null if [type] is not
/// a narrowed integer datatype.
///
/// Checked client-side so an out-of-range write names the VSS datatype and the
/// bound it broke. The databroker checks the same bounds and would reject the
/// write anyway; it reports `Value out of type bounds (id: N)`, which does not
/// tell the caller which signal, which datatype, or which limit.
({int min, int max})? integerRangeFor(VssDataType type) => switch (type) {
      VssDataType.int8 || VssDataType.int8Array => (min: -128, max: 127),
      VssDataType.int16 || VssDataType.int16Array => (min: -32768, max: 32767),
      VssDataType.int32 || VssDataType.int32Array => (
          min: -2147483648,
          max: 2147483647
        ),
      VssDataType.uint8 || VssDataType.uint8Array => (min: 0, max: 255),
      VssDataType.uint16 || VssDataType.uint16Array => (min: 0, max: 65535),
      VssDataType.uint32 || VssDataType.uint32Array => (
          min: 0,
          max: 4294967295
        ),
      // int64 spans the whole of Dart's int. uint64 has no upper bound
      // expressible as a positive Dart int, but its lower bound is real.
      VssDataType.uint64 || VssDataType.uint64Array => (min: 0, max: -1),
      _ => null,
    };

/// Translates the datatype the databroker reports in signal metadata.
///
/// Returns null for `DATA_TYPE_UNSPECIFIED`, which means the broker declared no
/// datatype for the signal — absence, not a default.
VssDataType? vssDataTypeFrom(pbenum.DataType dataType) => switch (dataType) {
      pbenum.DataType.DATA_TYPE_BOOLEAN => VssDataType.boolean,
      pbenum.DataType.DATA_TYPE_STRING => VssDataType.string,
      pbenum.DataType.DATA_TYPE_INT8 => VssDataType.int8,
      pbenum.DataType.DATA_TYPE_INT16 => VssDataType.int16,
      pbenum.DataType.DATA_TYPE_INT32 => VssDataType.int32,
      pbenum.DataType.DATA_TYPE_INT64 => VssDataType.int64,
      pbenum.DataType.DATA_TYPE_UINT8 => VssDataType.uint8,
      pbenum.DataType.DATA_TYPE_UINT16 => VssDataType.uint16,
      pbenum.DataType.DATA_TYPE_UINT32 => VssDataType.uint32,
      pbenum.DataType.DATA_TYPE_UINT64 => VssDataType.uint64,
      pbenum.DataType.DATA_TYPE_FLOAT => VssDataType.float,
      pbenum.DataType.DATA_TYPE_DOUBLE => VssDataType.double_,
      pbenum.DataType.DATA_TYPE_TIMESTAMP => VssDataType.timestamp,
      pbenum.DataType.DATA_TYPE_BOOLEAN_ARRAY => VssDataType.booleanArray,
      pbenum.DataType.DATA_TYPE_STRING_ARRAY => VssDataType.stringArray,
      pbenum.DataType.DATA_TYPE_INT8_ARRAY => VssDataType.int8Array,
      pbenum.DataType.DATA_TYPE_INT16_ARRAY => VssDataType.int16Array,
      pbenum.DataType.DATA_TYPE_INT32_ARRAY => VssDataType.int32Array,
      pbenum.DataType.DATA_TYPE_INT64_ARRAY => VssDataType.int64Array,
      pbenum.DataType.DATA_TYPE_UINT8_ARRAY => VssDataType.uint8Array,
      pbenum.DataType.DATA_TYPE_UINT16_ARRAY => VssDataType.uint16Array,
      pbenum.DataType.DATA_TYPE_UINT32_ARRAY => VssDataType.uint32Array,
      pbenum.DataType.DATA_TYPE_UINT64_ARRAY => VssDataType.uint64Array,
      pbenum.DataType.DATA_TYPE_FLOAT_ARRAY => VssDataType.floatArray,
      pbenum.DataType.DATA_TYPE_DOUBLE_ARRAY => VssDataType.doubleArray,
      pbenum.DataType.DATA_TYPE_TIMESTAMP_ARRAY => VssDataType.timestampArray,
      _ => null,
    };

/// Thrown when a Dart value cannot be put on the wire as [dataType].
///
/// Carries the signal path, the declared VSS datatype and the offending value,
/// because the databroker's own rejection carries only a numeric signal id.
class VssTypeMismatch implements Exception {
  /// The VSS path the write was addressed to.
  final String path;

  /// The datatype the databroker declares for [path].
  final VssDataType dataType;

  /// The value the caller passed.
  final Object? value;

  /// Why it could not be encoded.
  final String reason;

  const VssTypeMismatch({
    required this.path,
    required this.dataType,
    required this.value,
    required this.reason,
  });

  @override
  String toString() => 'VssTypeMismatch: $path is declared '
      '${dataType.name} in the databroker\'s signal metadata, and '
      '${value is String ? '"$value"' : value} '
      '(${value.runtimeType}) cannot be written to it: $reason';
}

/// Encodes [value] into the `Value` arm that a databroker accepts for a signal
/// declared [type].
///
/// [path] is used only to make a failure legible.
///
/// ## Widening is allowed; narrowing is not
///
/// A Dart `int` is accepted for a `float` or `double` signal and widened,
/// because the intent is unambiguous and the conversion loses nothing that the
/// caller wrote. The reverse is **refused**: a Dart `double` offered to an
/// integer signal would have to drop its fractional part, and a silently
/// truncated value on a safety signal is indistinguishable from a measured one.
pb.Value encodeVssValue({
  required String path,
  required VssDataType type,
  required Object value,
}) {
  Never mismatch(String reason) => throw VssTypeMismatch(
      path: path, dataType: type, value: value, reason: reason);

  final arm = wireArmFor(type);
  if (arm == null) {
    mismatch('the kuksa.val.v2 wire format has no Value field for '
        '${type.name}, so no client can publish this signal');
  }

  void checkIntRange(int v) {
    final r = integerRangeFor(type);
    if (r == null) return;
    if (v < r.min) {
      mismatch('$v is below the minimum ${r.min} that ${type.name} admits');
    }
    // max == -1 marks "no upper bound expressible as a positive Dart int".
    if (r.max >= 0 && v > r.max) {
      mismatch('$v exceeds the maximum ${r.max} that ${type.name} admits');
    }
  }

  List<T> homogeneous<T>(String what, T? Function(Object? e) coerce) {
    if (value is! List) {
      mismatch('${type.name} needs a List<$what>');
    }
    final out = <T>[];
    for (final e in value) {
      final c = coerce(e);
      if (c == null) {
        mismatch('${type.name} needs a List<$what>, but element '
            '"$e" is a ${e.runtimeType}');
      }
      out.add(c);
    }
    return out;
  }

  List<bool> asBoolList() =>
      homogeneous<bool>('bool', (e) => e is bool ? e : null);

  List<String> asStringList() =>
      homogeneous<String>('String', (e) => e is String ? e : null);

  /// An `int` element is widened to double, matching the scalar rule above.
  List<double> asDoubleList() => homogeneous<double>(
      'double', (e) => e is double ? e : (e is int ? e.toDouble() : null));

  List<int> asIntList() {
    final list = homogeneous<int>('int', (e) => e is int ? e : null);
    for (final e in list) {
      checkIntRange(e);
    }
    return list;
  }

  switch (arm) {
    case ValueArm.boolean:
      if (value is! bool) mismatch('${type.name} needs a bool');
      return pb.Value(bool_12: value);

    case ValueArm.string:
      if (value is! String) mismatch('${type.name} needs a String');
      return pb.Value(string: value);

    case ValueArm.int32:
      if (value is! int) {
        mismatch(value is double
            ? '${type.name} is an integer signal; pass an int, not a double '
                '(a fractional part cannot be written and must not be dropped '
                'silently)'
            : '${type.name} needs an int');
      }
      checkIntRange(value);
      return pb.Value(int32: value);

    case ValueArm.uint32:
      if (value is! int) {
        mismatch(value is double
            ? '${type.name} is an integer signal; pass an int, not a double '
                '(a fractional part cannot be written and must not be dropped '
                'silently)'
            : '${type.name} needs an int');
      }
      checkIntRange(value);
      return pb.Value(uint32: value);

    case ValueArm.int64:
      if (value is! int) mismatch('${type.name} needs an int');
      return pb.Value(int64: Int64(value));

    case ValueArm.uint64:
      if (value is! int) mismatch('${type.name} needs an int');
      checkIntRange(value);
      return pb.Value(uint64: Int64(value));

    case ValueArm.float:
      if (value is int) return pb.Value(float: value.toDouble());
      if (value is! double) mismatch('${type.name} needs a double');
      return pb.Value(float: value);

    case ValueArm.double_:
      if (value is int) return pb.Value(double_18: value.toDouble());
      if (value is! double) mismatch('${type.name} needs a double');
      return pb.Value(double_18: value);

    case ValueArm.boolArray:
      return pb.Value(boolArray: pb.BoolArray(values: asBoolList()));

    case ValueArm.stringArray:
      return pb.Value(stringArray: pb.StringArray(values: asStringList()));

    case ValueArm.int32Array:
      return pb.Value(int32Array: pb.Int32Array(values: asIntList()));

    case ValueArm.uint32Array:
      return pb.Value(uint32Array: pb.Uint32Array(values: asIntList()));

    case ValueArm.int64Array:
      return pb.Value(
          int64Array:
              pb.Int64Array(values: asIntList().map(Int64.new).toList()));

    case ValueArm.uint64Array:
      return pb.Value(
          uint64Array:
              pb.Uint64Array(values: asIntList().map(Int64.new).toList()));

    case ValueArm.floatArray:
      return pb.Value(floatArray: pb.FloatArray(values: asDoubleList()));

    case ValueArm.doubleArray:
      return pb.Value(doubleArray: pb.DoubleArray(values: asDoubleList()));
  }
}

/// The arm [value] actually carries, or null if it carries none.
///
/// Lets a test assert the wire encoding without importing generated protobuf.
ValueArm? armOf(pb.Value value) {
  if (value.hasString()) return ValueArm.string;
  if (value.hasBool_12()) return ValueArm.boolean;
  if (value.hasInt32()) return ValueArm.int32;
  if (value.hasInt64()) return ValueArm.int64;
  if (value.hasUint32()) return ValueArm.uint32;
  if (value.hasUint64()) return ValueArm.uint64;
  if (value.hasFloat()) return ValueArm.float;
  if (value.hasDouble_18()) return ValueArm.double_;
  if (value.hasStringArray()) return ValueArm.stringArray;
  if (value.hasBoolArray()) return ValueArm.boolArray;
  if (value.hasInt32Array()) return ValueArm.int32Array;
  if (value.hasInt64Array()) return ValueArm.int64Array;
  if (value.hasUint32Array()) return ValueArm.uint32Array;
  if (value.hasUint64Array()) return ValueArm.uint64Array;
  if (value.hasFloatArray()) return ValueArm.floatArray;
  if (value.hasDoubleArray()) return ValueArm.doubleArray;
  return null;
}
