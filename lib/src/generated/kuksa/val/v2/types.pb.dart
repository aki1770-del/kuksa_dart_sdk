// This is a generated file - do not edit.
//
// Generated from kuksa/val/v2/types.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

import 'types.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'types.pbenum.dart';

/// A Datapoint represents a timestamped value.
/// The 'value' field can be explicitly 'None', meaning the Datapoint exists but no value is present.
class Datapoint extends $pb.GeneratedMessage {
  factory Datapoint({
    $0.Timestamp? timestamp,
    Value? value,
  }) {
    final result = create();
    if (timestamp != null) result.timestamp = timestamp;
    if (value != null) result.value = value;
    return result;
  }

  Datapoint._();

  factory Datapoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Datapoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Datapoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $0.Timestamp.create)
    ..aOM<Value>(2, _omitFieldNames ? '' : 'value', subBuilder: Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Datapoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Datapoint copyWith(void Function(Datapoint) updates) =>
      super.copyWith((message) => updates(message as Datapoint)) as Datapoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Datapoint create() => Datapoint._();
  @$core.override
  Datapoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Datapoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Datapoint>(create);
  static Datapoint? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get timestamp => $_getN(0);
  @$pb.TagNumber(1)
  set timestamp($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureTimestamp() => $_ensure(0);

  @$pb.TagNumber(2)
  Value get value => $_getN(1);
  @$pb.TagNumber(2)
  set value(Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
  @$pb.TagNumber(2)
  Value ensureValue() => $_ensure(1);
}

enum Value_TypedValue {
  string,
  bool_12,
  int32,
  int64,
  uint32,
  uint64,
  float,
  double_18,
  stringArray,
  boolArray,
  int32Array,
  int64Array,
  uint32Array,
  uint64Array,
  floatArray,
  doubleArray,
  notSet
}

class Value extends $pb.GeneratedMessage {
  factory Value({
    $core.String? string,
    $core.bool? bool_12,
    $core.int? int32,
    $fixnum.Int64? int64,
    $core.int? uint32,
    $fixnum.Int64? uint64,
    $core.double? float,
    $core.double? double_18,
    StringArray? stringArray,
    BoolArray? boolArray,
    Int32Array? int32Array,
    Int64Array? int64Array,
    Uint32Array? uint32Array,
    Uint64Array? uint64Array,
    FloatArray? floatArray,
    DoubleArray? doubleArray,
  }) {
    final result = create();
    if (string != null) result.string = string;
    if (bool_12 != null) result.bool_12 = bool_12;
    if (int32 != null) result.int32 = int32;
    if (int64 != null) result.int64 = int64;
    if (uint32 != null) result.uint32 = uint32;
    if (uint64 != null) result.uint64 = uint64;
    if (float != null) result.float = float;
    if (double_18 != null) result.double_18 = double_18;
    if (stringArray != null) result.stringArray = stringArray;
    if (boolArray != null) result.boolArray = boolArray;
    if (int32Array != null) result.int32Array = int32Array;
    if (int64Array != null) result.int64Array = int64Array;
    if (uint32Array != null) result.uint32Array = uint32Array;
    if (uint64Array != null) result.uint64Array = uint64Array;
    if (floatArray != null) result.floatArray = floatArray;
    if (doubleArray != null) result.doubleArray = doubleArray;
    return result;
  }

  Value._();

  factory Value.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Value.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Value_TypedValue> _Value_TypedValueByTag = {
    11: Value_TypedValue.string,
    12: Value_TypedValue.bool_12,
    13: Value_TypedValue.int32,
    14: Value_TypedValue.int64,
    15: Value_TypedValue.uint32,
    16: Value_TypedValue.uint64,
    17: Value_TypedValue.float,
    18: Value_TypedValue.double_18,
    21: Value_TypedValue.stringArray,
    22: Value_TypedValue.boolArray,
    23: Value_TypedValue.int32Array,
    24: Value_TypedValue.int64Array,
    25: Value_TypedValue.uint32Array,
    26: Value_TypedValue.uint64Array,
    27: Value_TypedValue.floatArray,
    28: Value_TypedValue.doubleArray,
    0: Value_TypedValue.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Value',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..oo(0, [11, 12, 13, 14, 15, 16, 17, 18, 21, 22, 23, 24, 25, 26, 27, 28])
    ..aOS(11, _omitFieldNames ? '' : 'string')
    ..aOB(12, _omitFieldNames ? '' : 'bool')
    ..aI(13, _omitFieldNames ? '' : 'int32', fieldType: $pb.PbFieldType.OS3)
    ..a<$fixnum.Int64>(14, _omitFieldNames ? '' : 'int64', $pb.PbFieldType.OS6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(15, _omitFieldNames ? '' : 'uint32', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(16, _omitFieldNames ? '' : 'uint64', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(17, _omitFieldNames ? '' : 'float', fieldType: $pb.PbFieldType.OF)
    ..aD(18, _omitFieldNames ? '' : 'double')
    ..aOM<StringArray>(21, _omitFieldNames ? '' : 'stringArray',
        subBuilder: StringArray.create)
    ..aOM<BoolArray>(22, _omitFieldNames ? '' : 'boolArray',
        subBuilder: BoolArray.create)
    ..aOM<Int32Array>(23, _omitFieldNames ? '' : 'int32Array',
        subBuilder: Int32Array.create)
    ..aOM<Int64Array>(24, _omitFieldNames ? '' : 'int64Array',
        subBuilder: Int64Array.create)
    ..aOM<Uint32Array>(25, _omitFieldNames ? '' : 'uint32Array',
        subBuilder: Uint32Array.create)
    ..aOM<Uint64Array>(26, _omitFieldNames ? '' : 'uint64Array',
        subBuilder: Uint64Array.create)
    ..aOM<FloatArray>(27, _omitFieldNames ? '' : 'floatArray',
        subBuilder: FloatArray.create)
    ..aOM<DoubleArray>(28, _omitFieldNames ? '' : 'doubleArray',
        subBuilder: DoubleArray.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Value clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Value copyWith(void Function(Value) updates) =>
      super.copyWith((message) => updates(message as Value)) as Value;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Value create() => Value._();
  @$core.override
  Value createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Value getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Value>(create);
  static Value? _defaultInstance;

  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  Value_TypedValue whichTypedValue() =>
      _Value_TypedValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  void clearTypedValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(11)
  $core.String get string => $_getSZ(0);
  @$pb.TagNumber(11)
  set string($core.String value) => $_setString(0, value);
  @$pb.TagNumber(11)
  $core.bool hasString() => $_has(0);
  @$pb.TagNumber(11)
  void clearString() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get bool_12 => $_getBF(1);
  @$pb.TagNumber(12)
  set bool_12($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(12)
  $core.bool hasBool_12() => $_has(1);
  @$pb.TagNumber(12)
  void clearBool_12() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get int32 => $_getIZ(2);
  @$pb.TagNumber(13)
  set int32($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(13)
  $core.bool hasInt32() => $_has(2);
  @$pb.TagNumber(13)
  void clearInt32() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get int64 => $_getI64(3);
  @$pb.TagNumber(14)
  set int64($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(14)
  $core.bool hasInt64() => $_has(3);
  @$pb.TagNumber(14)
  void clearInt64() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get uint32 => $_getIZ(4);
  @$pb.TagNumber(15)
  set uint32($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(15)
  $core.bool hasUint32() => $_has(4);
  @$pb.TagNumber(15)
  void clearUint32() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get uint64 => $_getI64(5);
  @$pb.TagNumber(16)
  set uint64($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(16)
  $core.bool hasUint64() => $_has(5);
  @$pb.TagNumber(16)
  void clearUint64() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.double get float => $_getN(6);
  @$pb.TagNumber(17)
  set float($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(17)
  $core.bool hasFloat() => $_has(6);
  @$pb.TagNumber(17)
  void clearFloat() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.double get double_18 => $_getN(7);
  @$pb.TagNumber(18)
  set double_18($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(18)
  $core.bool hasDouble_18() => $_has(7);
  @$pb.TagNumber(18)
  void clearDouble_18() => $_clearField(18);

  @$pb.TagNumber(21)
  StringArray get stringArray => $_getN(8);
  @$pb.TagNumber(21)
  set stringArray(StringArray value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasStringArray() => $_has(8);
  @$pb.TagNumber(21)
  void clearStringArray() => $_clearField(21);
  @$pb.TagNumber(21)
  StringArray ensureStringArray() => $_ensure(8);

  @$pb.TagNumber(22)
  BoolArray get boolArray => $_getN(9);
  @$pb.TagNumber(22)
  set boolArray(BoolArray value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasBoolArray() => $_has(9);
  @$pb.TagNumber(22)
  void clearBoolArray() => $_clearField(22);
  @$pb.TagNumber(22)
  BoolArray ensureBoolArray() => $_ensure(9);

  @$pb.TagNumber(23)
  Int32Array get int32Array => $_getN(10);
  @$pb.TagNumber(23)
  set int32Array(Int32Array value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasInt32Array() => $_has(10);
  @$pb.TagNumber(23)
  void clearInt32Array() => $_clearField(23);
  @$pb.TagNumber(23)
  Int32Array ensureInt32Array() => $_ensure(10);

  @$pb.TagNumber(24)
  Int64Array get int64Array => $_getN(11);
  @$pb.TagNumber(24)
  set int64Array(Int64Array value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasInt64Array() => $_has(11);
  @$pb.TagNumber(24)
  void clearInt64Array() => $_clearField(24);
  @$pb.TagNumber(24)
  Int64Array ensureInt64Array() => $_ensure(11);

  @$pb.TagNumber(25)
  Uint32Array get uint32Array => $_getN(12);
  @$pb.TagNumber(25)
  set uint32Array(Uint32Array value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasUint32Array() => $_has(12);
  @$pb.TagNumber(25)
  void clearUint32Array() => $_clearField(25);
  @$pb.TagNumber(25)
  Uint32Array ensureUint32Array() => $_ensure(12);

  @$pb.TagNumber(26)
  Uint64Array get uint64Array => $_getN(13);
  @$pb.TagNumber(26)
  set uint64Array(Uint64Array value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasUint64Array() => $_has(13);
  @$pb.TagNumber(26)
  void clearUint64Array() => $_clearField(26);
  @$pb.TagNumber(26)
  Uint64Array ensureUint64Array() => $_ensure(13);

  @$pb.TagNumber(27)
  FloatArray get floatArray => $_getN(14);
  @$pb.TagNumber(27)
  set floatArray(FloatArray value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasFloatArray() => $_has(14);
  @$pb.TagNumber(27)
  void clearFloatArray() => $_clearField(27);
  @$pb.TagNumber(27)
  FloatArray ensureFloatArray() => $_ensure(14);

  @$pb.TagNumber(28)
  DoubleArray get doubleArray => $_getN(15);
  @$pb.TagNumber(28)
  set doubleArray(DoubleArray value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasDoubleArray() => $_has(15);
  @$pb.TagNumber(28)
  void clearDoubleArray() => $_clearField(28);
  @$pb.TagNumber(28)
  DoubleArray ensureDoubleArray() => $_ensure(15);
}

class SampleInterval extends $pb.GeneratedMessage {
  factory SampleInterval({
    $core.int? intervalMs,
  }) {
    final result = create();
    if (intervalMs != null) result.intervalMs = intervalMs;
    return result;
  }

  SampleInterval._();

  factory SampleInterval.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SampleInterval.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleInterval',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'intervalMs', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleInterval clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleInterval copyWith(void Function(SampleInterval) updates) =>
      super.copyWith((message) => updates(message as SampleInterval))
          as SampleInterval;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SampleInterval create() => SampleInterval._();
  @$core.override
  SampleInterval createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SampleInterval getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleInterval>(create);
  static SampleInterval? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get intervalMs => $_getIZ(0);
  @$pb.TagNumber(1)
  set intervalMs($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIntervalMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearIntervalMs() => $_clearField(1);
}

class Filter extends $pb.GeneratedMessage {
  factory Filter({
    $core.int? durationMs,
    SampleInterval? minSampleInterval,
  }) {
    final result = create();
    if (durationMs != null) result.durationMs = durationMs;
    if (minSampleInterval != null) result.minSampleInterval = minSampleInterval;
    return result;
  }

  Filter._();

  factory Filter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Filter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Filter',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'durationMs', fieldType: $pb.PbFieldType.OU3)
    ..aOM<SampleInterval>(2, _omitFieldNames ? '' : 'minSampleInterval',
        subBuilder: SampleInterval.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Filter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Filter copyWith(void Function(Filter) updates) =>
      super.copyWith((message) => updates(message as Filter)) as Filter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Filter create() => Filter._();
  @$core.override
  Filter createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Filter getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Filter>(create);
  static Filter? _defaultInstance;

  /// Duration of the active call. If it is not set, call will last for ever.
  @$pb.TagNumber(1)
  $core.int get durationMs => $_getIZ(0);
  @$pb.TagNumber(1)
  set durationMs($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDurationMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearDurationMs() => $_clearField(1);

  /// Min desired sample update interval.
  @$pb.TagNumber(2)
  SampleInterval get minSampleInterval => $_getN(1);
  @$pb.TagNumber(2)
  set minSampleInterval(SampleInterval value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMinSampleInterval() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinSampleInterval() => $_clearField(2);
  @$pb.TagNumber(2)
  SampleInterval ensureMinSampleInterval() => $_ensure(1);
}

enum SignalID_Signal { id, path, notSet }

class SignalID extends $pb.GeneratedMessage {
  factory SignalID({
    $core.int? id,
    $core.String? path,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (path != null) result.path = path;
    return result;
  }

  SignalID._();

  factory SignalID.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignalID.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SignalID_Signal> _SignalID_SignalByTag = {
    1: SignalID_Signal.id,
    2: SignalID_Signal.path,
    0: SignalID_Signal.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignalID',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalID clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalID copyWith(void Function(SignalID) updates) =>
      super.copyWith((message) => updates(message as SignalID)) as SignalID;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignalID create() => SignalID._();
  @$core.override
  SignalID createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignalID getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignalID>(create);
  static SignalID? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  SignalID_Signal whichSignal() => _SignalID_SignalByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearSignal() => $_clearField($_whichOneof(0));

  /// Numeric identifier to the signal
  /// As of today Databroker assigns arbitrary unique numbers to each registered signal
  /// at startup, meaning that identifiers may change after restarting Databroker.
  /// A mechanism for static identifiers may be introduced in the future.
  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Full VSS-style path to a specific signal, like "Vehicle.Speed"
  /// Wildcards and paths to branches are not supported.
  /// The given path must be known by the Databroker.
  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);
}

class Error extends $pb.GeneratedMessage {
  factory Error({
    ErrorCode? code,
    $core.String? message,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    return result;
  }

  Error._();

  factory Error.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Error.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Error',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aE<ErrorCode>(1, _omitFieldNames ? '' : 'code',
        enumValues: ErrorCode.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Error clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Error copyWith(void Function(Error) updates) =>
      super.copyWith((message) => updates(message as Error)) as Error;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  @$core.override
  Error createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

  @$pb.TagNumber(1)
  ErrorCode get code => $_getN(0);
  @$pb.TagNumber(1)
  set code(ErrorCode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class Metadata extends $pb.GeneratedMessage {
  factory Metadata({
    $core.String? path,
    $core.int? id,
    DataType? dataType,
    EntryType? entryType,
    $core.String? description,
    $core.String? comment,
    $core.String? deprecation,
    $core.String? unit,
    Value? allowedValues,
    Value? min,
    Value? max,
    SampleInterval? minSampleInterval,
  }) {
    final result = create();
    if (path != null) result.path = path;
    if (id != null) result.id = id;
    if (dataType != null) result.dataType = dataType;
    if (entryType != null) result.entryType = entryType;
    if (description != null) result.description = description;
    if (comment != null) result.comment = comment;
    if (deprecation != null) result.deprecation = deprecation;
    if (unit != null) result.unit = unit;
    if (allowedValues != null) result.allowedValues = allowedValues;
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    if (minSampleInterval != null) result.minSampleInterval = minSampleInterval;
    return result;
  }

  Metadata._();

  factory Metadata.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Metadata.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Metadata',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aOS(9, _omitFieldNames ? '' : 'path')
    ..aI(10, _omitFieldNames ? '' : 'id')
    ..aE<DataType>(11, _omitFieldNames ? '' : 'dataType',
        enumValues: DataType.values)
    ..aE<EntryType>(12, _omitFieldNames ? '' : 'entryType',
        enumValues: EntryType.values)
    ..aOS(13, _omitFieldNames ? '' : 'description')
    ..aOS(14, _omitFieldNames ? '' : 'comment')
    ..aOS(15, _omitFieldNames ? '' : 'deprecation')
    ..aOS(16, _omitFieldNames ? '' : 'unit')
    ..aOM<Value>(17, _omitFieldNames ? '' : 'allowedValues',
        subBuilder: Value.create)
    ..aOM<Value>(18, _omitFieldNames ? '' : 'min', subBuilder: Value.create)
    ..aOM<Value>(19, _omitFieldNames ? '' : 'max', subBuilder: Value.create)
    ..aOM<SampleInterval>(20, _omitFieldNames ? '' : 'minSampleInterval',
        subBuilder: SampleInterval.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metadata copyWith(void Function(Metadata) updates) =>
      super.copyWith((message) => updates(message as Metadata)) as Metadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Metadata create() => Metadata._();
  @$core.override
  Metadata createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Metadata getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Metadata>(create);
  static Metadata? _defaultInstance;

  /// Full dot notated path for the signal
  @$pb.TagNumber(9)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(9)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(9)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(9)
  void clearPath() => $_clearField(9);

  /// ID field
  @$pb.TagNumber(10)
  $core.int get id => $_getIZ(1);
  @$pb.TagNumber(10)
  set id($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(10)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(10)
  void clearId() => $_clearField(10);

  /// Data type
  /// The VSS data type of the entry (i.e. the value, min, max etc).
  ///
  /// NOTE: protobuf doesn't have int8, int16, uint8 or uint16 which means
  /// that these values must be serialized as int32 and uint32 respectively.
  @$pb.TagNumber(11)
  DataType get dataType => $_getN(2);
  @$pb.TagNumber(11)
  set dataType(DataType value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDataType() => $_has(2);
  @$pb.TagNumber(11)
  void clearDataType() => $_clearField(11);

  /// Entry type
  @$pb.TagNumber(12)
  EntryType get entryType => $_getN(3);
  @$pb.TagNumber(12)
  set entryType(EntryType value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasEntryType() => $_has(3);
  @$pb.TagNumber(12)
  void clearEntryType() => $_clearField(12);

  /// Description
  /// Describes the meaning and content of the entry.
  @$pb.TagNumber(13)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(13)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(13)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(13)
  void clearDescription() => $_clearField(13);

  /// Comment
  /// A comment can be used to provide additional informal information
  /// on a entry.
  @$pb.TagNumber(14)
  $core.String get comment => $_getSZ(5);
  @$pb.TagNumber(14)
  set comment($core.String value) => $_setString(5, value);
  @$pb.TagNumber(14)
  $core.bool hasComment() => $_has(5);
  @$pb.TagNumber(14)
  void clearComment() => $_clearField(14);

  /// Deprecation
  /// Whether this entry is deprecated. Can contain recommendations of what
  /// to use instead.
  @$pb.TagNumber(15)
  $core.String get deprecation => $_getSZ(6);
  @$pb.TagNumber(15)
  set deprecation($core.String value) => $_setString(6, value);
  @$pb.TagNumber(15)
  $core.bool hasDeprecation() => $_has(6);
  @$pb.TagNumber(15)
  void clearDeprecation() => $_clearField(15);

  /// Unit
  /// The unit of measurement
  @$pb.TagNumber(16)
  $core.String get unit => $_getSZ(7);
  @$pb.TagNumber(16)
  set unit($core.String value) => $_setString(7, value);
  @$pb.TagNumber(16)
  $core.bool hasUnit() => $_has(7);
  @$pb.TagNumber(16)
  void clearUnit() => $_clearField(16);

  /// Value restrictions checked/enforced by Databroker
  @$pb.TagNumber(17)
  Value get allowedValues => $_getN(8);
  @$pb.TagNumber(17)
  set allowedValues(Value value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasAllowedValues() => $_has(8);
  @$pb.TagNumber(17)
  void clearAllowedValues() => $_clearField(17);
  @$pb.TagNumber(17)
  Value ensureAllowedValues() => $_ensure(8);

  @$pb.TagNumber(18)
  Value get min => $_getN(9);
  @$pb.TagNumber(18)
  set min(Value value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasMin() => $_has(9);
  @$pb.TagNumber(18)
  void clearMin() => $_clearField(18);
  @$pb.TagNumber(18)
  Value ensureMin() => $_ensure(9);

  @$pb.TagNumber(19)
  Value get max => $_getN(10);
  @$pb.TagNumber(19)
  set max(Value value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasMax() => $_has(10);
  @$pb.TagNumber(19)
  void clearMax() => $_clearField(19);
  @$pb.TagNumber(19)
  Value ensureMax() => $_ensure(10);

  /// Minimum sample interval at which its provider can publish the signal value
  @$pb.TagNumber(20)
  SampleInterval get minSampleInterval => $_getN(11);
  @$pb.TagNumber(20)
  set minSampleInterval(SampleInterval value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasMinSampleInterval() => $_has(11);
  @$pb.TagNumber(20)
  void clearMinSampleInterval() => $_clearField(20);
  @$pb.TagNumber(20)
  SampleInterval ensureMinSampleInterval() => $_ensure(11);
}

class StringArray extends $pb.GeneratedMessage {
  factory StringArray({
    $core.Iterable<$core.String>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  StringArray._();

  factory StringArray.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StringArray.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StringArray',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'values')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StringArray clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StringArray copyWith(void Function(StringArray) updates) =>
      super.copyWith((message) => updates(message as StringArray))
          as StringArray;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StringArray create() => StringArray._();
  @$core.override
  StringArray createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StringArray getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StringArray>(create);
  static StringArray? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get values => $_getList(0);
}

class BoolArray extends $pb.GeneratedMessage {
  factory BoolArray({
    $core.Iterable<$core.bool>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  BoolArray._();

  factory BoolArray.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BoolArray.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BoolArray',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..p<$core.bool>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KB)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BoolArray clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BoolArray copyWith(void Function(BoolArray) updates) =>
      super.copyWith((message) => updates(message as BoolArray)) as BoolArray;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BoolArray create() => BoolArray._();
  @$core.override
  BoolArray createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BoolArray getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BoolArray>(create);
  static BoolArray? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.bool> get values => $_getList(0);
}

class Int32Array extends $pb.GeneratedMessage {
  factory Int32Array({
    $core.Iterable<$core.int>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  Int32Array._();

  factory Int32Array.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Int32Array.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Int32Array',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KS3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Int32Array clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Int32Array copyWith(void Function(Int32Array) updates) =>
      super.copyWith((message) => updates(message as Int32Array)) as Int32Array;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Int32Array create() => Int32Array._();
  @$core.override
  Int32Array createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Int32Array getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Int32Array>(create);
  static Int32Array? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get values => $_getList(0);
}

class Int64Array extends $pb.GeneratedMessage {
  factory Int64Array({
    $core.Iterable<$fixnum.Int64>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  Int64Array._();

  factory Int64Array.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Int64Array.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Int64Array',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KS6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Int64Array clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Int64Array copyWith(void Function(Int64Array) updates) =>
      super.copyWith((message) => updates(message as Int64Array)) as Int64Array;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Int64Array create() => Int64Array._();
  @$core.override
  Int64Array createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Int64Array getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Int64Array>(create);
  static Int64Array? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get values => $_getList(0);
}

class Uint32Array extends $pb.GeneratedMessage {
  factory Uint32Array({
    $core.Iterable<$core.int>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  Uint32Array._();

  factory Uint32Array.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Uint32Array.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Uint32Array',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Uint32Array clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Uint32Array copyWith(void Function(Uint32Array) updates) =>
      super.copyWith((message) => updates(message as Uint32Array))
          as Uint32Array;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Uint32Array create() => Uint32Array._();
  @$core.override
  Uint32Array createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Uint32Array getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Uint32Array>(create);
  static Uint32Array? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get values => $_getList(0);
}

class Uint64Array extends $pb.GeneratedMessage {
  factory Uint64Array({
    $core.Iterable<$fixnum.Int64>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  Uint64Array._();

  factory Uint64Array.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Uint64Array.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Uint64Array',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KU6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Uint64Array clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Uint64Array copyWith(void Function(Uint64Array) updates) =>
      super.copyWith((message) => updates(message as Uint64Array))
          as Uint64Array;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Uint64Array create() => Uint64Array._();
  @$core.override
  Uint64Array createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Uint64Array getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Uint64Array>(create);
  static Uint64Array? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get values => $_getList(0);
}

class FloatArray extends $pb.GeneratedMessage {
  factory FloatArray({
    $core.Iterable<$core.double>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  FloatArray._();

  factory FloatArray.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FloatArray.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FloatArray',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloatArray clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloatArray copyWith(void Function(FloatArray) updates) =>
      super.copyWith((message) => updates(message as FloatArray)) as FloatArray;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FloatArray create() => FloatArray._();
  @$core.override
  FloatArray createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FloatArray getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FloatArray>(create);
  static FloatArray? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get values => $_getList(0);
}

class DoubleArray extends $pb.GeneratedMessage {
  factory DoubleArray({
    $core.Iterable<$core.double>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  DoubleArray._();

  factory DoubleArray.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DoubleArray.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DoubleArray',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoubleArray clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoubleArray copyWith(void Function(DoubleArray) updates) =>
      super.copyWith((message) => updates(message as DoubleArray))
          as DoubleArray;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DoubleArray create() => DoubleArray._();
  @$core.override
  DoubleArray createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DoubleArray getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DoubleArray>(create);
  static DoubleArray? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get values => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
