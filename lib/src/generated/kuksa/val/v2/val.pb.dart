// This is a generated file - do not edit.
//
// Generated from kuksa/val/v2/val.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'types.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetValueRequest extends $pb.GeneratedMessage {
  factory GetValueRequest({
    $1.SignalID? signalId,
  }) {
    final result = create();
    if (signalId != null) result.signalId = signalId;
    return result;
  }

  GetValueRequest._();

  factory GetValueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetValueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetValueRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aOM<$1.SignalID>(1, _omitFieldNames ? '' : 'signalId',
        subBuilder: $1.SignalID.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetValueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetValueRequest copyWith(void Function(GetValueRequest) updates) =>
      super.copyWith((message) => updates(message as GetValueRequest))
          as GetValueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetValueRequest create() => GetValueRequest._();
  @$core.override
  GetValueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetValueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetValueRequest>(create);
  static GetValueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.SignalID get signalId => $_getN(0);
  @$pb.TagNumber(1)
  set signalId($1.SignalID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSignalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignalId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.SignalID ensureSignalId() => $_ensure(0);
}

class GetValueResponse extends $pb.GeneratedMessage {
  factory GetValueResponse({
    $1.Datapoint? dataPoint,
  }) {
    final result = create();
    if (dataPoint != null) result.dataPoint = dataPoint;
    return result;
  }

  GetValueResponse._();

  factory GetValueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetValueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetValueResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aOM<$1.Datapoint>(1, _omitFieldNames ? '' : 'dataPoint',
        subBuilder: $1.Datapoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetValueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetValueResponse copyWith(void Function(GetValueResponse) updates) =>
      super.copyWith((message) => updates(message as GetValueResponse))
          as GetValueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetValueResponse create() => GetValueResponse._();
  @$core.override
  GetValueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetValueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetValueResponse>(create);
  static GetValueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Datapoint get dataPoint => $_getN(0);
  @$pb.TagNumber(1)
  set dataPoint($1.Datapoint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDataPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearDataPoint() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Datapoint ensureDataPoint() => $_ensure(0);
}

class GetValuesRequest extends $pb.GeneratedMessage {
  factory GetValuesRequest({
    $core.Iterable<$1.SignalID>? signalIds,
  }) {
    final result = create();
    if (signalIds != null) result.signalIds.addAll(signalIds);
    return result;
  }

  GetValuesRequest._();

  factory GetValuesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetValuesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetValuesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..pPM<$1.SignalID>(1, _omitFieldNames ? '' : 'signalIds',
        subBuilder: $1.SignalID.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetValuesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetValuesRequest copyWith(void Function(GetValuesRequest) updates) =>
      super.copyWith((message) => updates(message as GetValuesRequest))
          as GetValuesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetValuesRequest create() => GetValuesRequest._();
  @$core.override
  GetValuesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetValuesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetValuesRequest>(create);
  static GetValuesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.SignalID> get signalIds => $_getList(0);
}

class GetValuesResponse extends $pb.GeneratedMessage {
  factory GetValuesResponse({
    $core.Iterable<$1.Datapoint>? dataPoints,
  }) {
    final result = create();
    if (dataPoints != null) result.dataPoints.addAll(dataPoints);
    return result;
  }

  GetValuesResponse._();

  factory GetValuesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetValuesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetValuesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..pPM<$1.Datapoint>(1, _omitFieldNames ? '' : 'dataPoints',
        subBuilder: $1.Datapoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetValuesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetValuesResponse copyWith(void Function(GetValuesResponse) updates) =>
      super.copyWith((message) => updates(message as GetValuesResponse))
          as GetValuesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetValuesResponse create() => GetValuesResponse._();
  @$core.override
  GetValuesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetValuesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetValuesResponse>(create);
  static GetValuesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Datapoint> get dataPoints => $_getList(0);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $core.Iterable<$core.String>? signalPaths,
    $core.int? bufferSize,
    $1.Filter? filter,
  }) {
    final result = create();
    if (signalPaths != null) result.signalPaths.addAll(signalPaths);
    if (bufferSize != null) result.bufferSize = bufferSize;
    if (filter != null) result.filter = filter;
    return result;
  }

  SubscribeRequest._();

  factory SubscribeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscribeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'signalPaths')
    ..aI(2, _omitFieldNames ? '' : 'bufferSize', fieldType: $pb.PbFieldType.OU3)
    ..aOM<$1.Filter>(3, _omitFieldNames ? '' : 'filter',
        subBuilder: $1.Filter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeRequest))
          as SubscribeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeRequest create() => SubscribeRequest._();
  @$core.override
  SubscribeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(create);
  static SubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get signalPaths => $_getList(0);

  /// Specifies the number of messages that can be buffered for
  /// slow subscribers before the oldest messages are dropped.
  /// Default (0) results in that only latest message is kept.
  /// Maximum value supported is implementation dependent.
  @$pb.TagNumber(2)
  $core.int get bufferSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set bufferSize($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBufferSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearBufferSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Filter get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter($1.Filter value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Filter ensureFilter() => $_ensure(2);
}

class SubscribeResponse extends $pb.GeneratedMessage {
  factory SubscribeResponse({
    $core.Iterable<$core.MapEntry<$core.String, $1.Datapoint>>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addEntries(entries);
    return result;
  }

  SubscribeResponse._();

  factory SubscribeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscribeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..m<$core.String, $1.Datapoint>(1, _omitFieldNames ? '' : 'entries',
        entryClassName: 'SubscribeResponse.EntriesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $1.Datapoint.create,
        valueDefaultOrMaker: $1.Datapoint.getDefault,
        packageName: const $pb.PackageName('kuksa.val.v2'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeResponse copyWith(void Function(SubscribeResponse) updates) =>
      super.copyWith((message) => updates(message as SubscribeResponse))
          as SubscribeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeResponse create() => SubscribeResponse._();
  @$core.override
  SubscribeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscribeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeResponse>(create);
  static SubscribeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $1.Datapoint> get entries => $_getMap(0);
}

class SubscribeByIdRequest extends $pb.GeneratedMessage {
  factory SubscribeByIdRequest({
    $core.Iterable<$core.int>? signalIds,
    $core.int? bufferSize,
    $1.Filter? filter,
  }) {
    final result = create();
    if (signalIds != null) result.signalIds.addAll(signalIds);
    if (bufferSize != null) result.bufferSize = bufferSize;
    if (filter != null) result.filter = filter;
    return result;
  }

  SubscribeByIdRequest._();

  factory SubscribeByIdRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscribeByIdRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeByIdRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'signalIds', $pb.PbFieldType.K3)
    ..aI(2, _omitFieldNames ? '' : 'bufferSize', fieldType: $pb.PbFieldType.OU3)
    ..aOM<$1.Filter>(3, _omitFieldNames ? '' : 'filter',
        subBuilder: $1.Filter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeByIdRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeByIdRequest copyWith(void Function(SubscribeByIdRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeByIdRequest))
          as SubscribeByIdRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeByIdRequest create() => SubscribeByIdRequest._();
  @$core.override
  SubscribeByIdRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscribeByIdRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeByIdRequest>(create);
  static SubscribeByIdRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get signalIds => $_getList(0);

  /// Specifies the number of messages that can be buffered for
  /// slow subscribers before the oldest messages are dropped.
  /// Default (0) results in that only latest message is kept.
  /// Maximum value supported is implementation dependent.
  @$pb.TagNumber(2)
  $core.int get bufferSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set bufferSize($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBufferSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearBufferSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Filter get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter($1.Filter value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Filter ensureFilter() => $_ensure(2);
}

class SubscribeByIdResponse extends $pb.GeneratedMessage {
  factory SubscribeByIdResponse({
    $core.Iterable<$core.MapEntry<$core.int, $1.Datapoint>>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addEntries(entries);
    return result;
  }

  SubscribeByIdResponse._();

  factory SubscribeByIdResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscribeByIdResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeByIdResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..m<$core.int, $1.Datapoint>(1, _omitFieldNames ? '' : 'entries',
        entryClassName: 'SubscribeByIdResponse.EntriesEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $1.Datapoint.create,
        valueDefaultOrMaker: $1.Datapoint.getDefault,
        packageName: const $pb.PackageName('kuksa.val.v2'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeByIdResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeByIdResponse copyWith(
          void Function(SubscribeByIdResponse) updates) =>
      super.copyWith((message) => updates(message as SubscribeByIdResponse))
          as SubscribeByIdResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeByIdResponse create() => SubscribeByIdResponse._();
  @$core.override
  SubscribeByIdResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscribeByIdResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeByIdResponse>(create);
  static SubscribeByIdResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, $1.Datapoint> get entries => $_getMap(0);
}

class ActuateRequest extends $pb.GeneratedMessage {
  factory ActuateRequest({
    $1.SignalID? signalId,
    $1.Value? value,
  }) {
    final result = create();
    if (signalId != null) result.signalId = signalId;
    if (value != null) result.value = value;
    return result;
  }

  ActuateRequest._();

  factory ActuateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActuateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActuateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aOM<$1.SignalID>(1, _omitFieldNames ? '' : 'signalId',
        subBuilder: $1.SignalID.create)
    ..aOM<$1.Value>(2, _omitFieldNames ? '' : 'value',
        subBuilder: $1.Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActuateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActuateRequest copyWith(void Function(ActuateRequest) updates) =>
      super.copyWith((message) => updates(message as ActuateRequest))
          as ActuateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActuateRequest create() => ActuateRequest._();
  @$core.override
  ActuateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ActuateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActuateRequest>(create);
  static ActuateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.SignalID get signalId => $_getN(0);
  @$pb.TagNumber(1)
  set signalId($1.SignalID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSignalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignalId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.SignalID ensureSignalId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Value get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($1.Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Value ensureValue() => $_ensure(1);
}

class ActuateResponse extends $pb.GeneratedMessage {
  factory ActuateResponse() => create();

  ActuateResponse._();

  factory ActuateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActuateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActuateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActuateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActuateResponse copyWith(void Function(ActuateResponse) updates) =>
      super.copyWith((message) => updates(message as ActuateResponse))
          as ActuateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActuateResponse create() => ActuateResponse._();
  @$core.override
  ActuateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ActuateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActuateResponse>(create);
  static ActuateResponse? _defaultInstance;
}

class BatchActuateRequest extends $pb.GeneratedMessage {
  factory BatchActuateRequest({
    $core.Iterable<ActuateRequest>? actuateRequests,
  }) {
    final result = create();
    if (actuateRequests != null) result.actuateRequests.addAll(actuateRequests);
    return result;
  }

  BatchActuateRequest._();

  factory BatchActuateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchActuateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchActuateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..pPM<ActuateRequest>(1, _omitFieldNames ? '' : 'actuateRequests',
        subBuilder: ActuateRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchActuateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchActuateRequest copyWith(void Function(BatchActuateRequest) updates) =>
      super.copyWith((message) => updates(message as BatchActuateRequest))
          as BatchActuateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchActuateRequest create() => BatchActuateRequest._();
  @$core.override
  BatchActuateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchActuateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchActuateRequest>(create);
  static BatchActuateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ActuateRequest> get actuateRequests => $_getList(0);
}

class BatchActuateResponse extends $pb.GeneratedMessage {
  factory BatchActuateResponse() => create();

  BatchActuateResponse._();

  factory BatchActuateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchActuateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchActuateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchActuateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchActuateResponse copyWith(void Function(BatchActuateResponse) updates) =>
      super.copyWith((message) => updates(message as BatchActuateResponse))
          as BatchActuateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchActuateResponse create() => BatchActuateResponse._();
  @$core.override
  BatchActuateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchActuateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchActuateResponse>(create);
  static BatchActuateResponse? _defaultInstance;
}

class ListMetadataRequest extends $pb.GeneratedMessage {
  factory ListMetadataRequest({
    $core.String? root,
    $core.String? filter,
  }) {
    final result = create();
    if (root != null) result.root = root;
    if (filter != null) result.filter = filter;
    return result;
  }

  ListMetadataRequest._();

  factory ListMetadataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMetadataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMetadataRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'root')
    ..aOS(2, _omitFieldNames ? '' : 'filter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMetadataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMetadataRequest copyWith(void Function(ListMetadataRequest) updates) =>
      super.copyWith((message) => updates(message as ListMetadataRequest))
          as ListMetadataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMetadataRequest create() => ListMetadataRequest._();
  @$core.override
  ListMetadataRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMetadataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMetadataRequest>(create);
  static ListMetadataRequest? _defaultInstance;

  /// Root path to be used when listing metadata
  /// Shall correspond to a VSS branch, e.g. "Vehicle", "Vehicle.Cabin"
  /// Metadata for all signals under that branch will be returned unless filtered by filter.
  /// NOTE: Currently Databroker supports also signals and wildcards in root but that may
  ///   be removed in a future release!
  @$pb.TagNumber(1)
  $core.String get root => $_getSZ(0);
  @$pb.TagNumber(1)
  set root($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoot() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoot() => $_clearField(1);

  /// NOTE : Currently not considered by Databroker, all signals matching root are returned
  @$pb.TagNumber(2)
  $core.String get filter => $_getSZ(1);
  @$pb.TagNumber(2)
  set filter($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilter() => $_clearField(2);
}

class ListMetadataResponse extends $pb.GeneratedMessage {
  factory ListMetadataResponse({
    $core.Iterable<$1.Metadata>? metadata,
  }) {
    final result = create();
    if (metadata != null) result.metadata.addAll(metadata);
    return result;
  }

  ListMetadataResponse._();

  factory ListMetadataResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMetadataResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMetadataResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..pPM<$1.Metadata>(1, _omitFieldNames ? '' : 'metadata',
        subBuilder: $1.Metadata.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMetadataResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMetadataResponse copyWith(void Function(ListMetadataResponse) updates) =>
      super.copyWith((message) => updates(message as ListMetadataResponse))
          as ListMetadataResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMetadataResponse create() => ListMetadataResponse._();
  @$core.override
  ListMetadataResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMetadataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMetadataResponse>(create);
  static ListMetadataResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Metadata> get metadata => $_getList(0);
}

class PublishValueRequest extends $pb.GeneratedMessage {
  factory PublishValueRequest({
    $1.SignalID? signalId,
    $1.Datapoint? dataPoint,
  }) {
    final result = create();
    if (signalId != null) result.signalId = signalId;
    if (dataPoint != null) result.dataPoint = dataPoint;
    return result;
  }

  PublishValueRequest._();

  factory PublishValueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishValueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishValueRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aOM<$1.SignalID>(1, _omitFieldNames ? '' : 'signalId',
        subBuilder: $1.SignalID.create)
    ..aOM<$1.Datapoint>(2, _omitFieldNames ? '' : 'dataPoint',
        subBuilder: $1.Datapoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishValueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishValueRequest copyWith(void Function(PublishValueRequest) updates) =>
      super.copyWith((message) => updates(message as PublishValueRequest))
          as PublishValueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishValueRequest create() => PublishValueRequest._();
  @$core.override
  PublishValueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishValueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishValueRequest>(create);
  static PublishValueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.SignalID get signalId => $_getN(0);
  @$pb.TagNumber(1)
  set signalId($1.SignalID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSignalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignalId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.SignalID ensureSignalId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Datapoint get dataPoint => $_getN(1);
  @$pb.TagNumber(2)
  set dataPoint($1.Datapoint value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDataPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearDataPoint() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Datapoint ensureDataPoint() => $_ensure(1);
}

class PublishValueResponse extends $pb.GeneratedMessage {
  factory PublishValueResponse() => create();

  PublishValueResponse._();

  factory PublishValueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishValueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishValueResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishValueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishValueResponse copyWith(void Function(PublishValueResponse) updates) =>
      super.copyWith((message) => updates(message as PublishValueResponse))
          as PublishValueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishValueResponse create() => PublishValueResponse._();
  @$core.override
  PublishValueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishValueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishValueResponse>(create);
  static PublishValueResponse? _defaultInstance;
}

class PublishValuesRequest extends $pb.GeneratedMessage {
  factory PublishValuesRequest({
    $core.int? requestId,
    $core.Iterable<$core.MapEntry<$core.int, $1.Datapoint>>? dataPoints,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (dataPoints != null) result.dataPoints.addEntries(dataPoints);
    return result;
  }

  PublishValuesRequest._();

  factory PublishValuesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishValuesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishValuesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'requestId', fieldType: $pb.PbFieldType.OU3)
    ..m<$core.int, $1.Datapoint>(2, _omitFieldNames ? '' : 'dataPoints',
        entryClassName: 'PublishValuesRequest.DataPointsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $1.Datapoint.create,
        valueDefaultOrMaker: $1.Datapoint.getDefault,
        packageName: const $pb.PackageName('kuksa.val.v2'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishValuesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishValuesRequest copyWith(void Function(PublishValuesRequest) updates) =>
      super.copyWith((message) => updates(message as PublishValuesRequest))
          as PublishValuesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishValuesRequest create() => PublishValuesRequest._();
  @$core.override
  PublishValuesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishValuesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishValuesRequest>(create);
  static PublishValuesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestId => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.int, $1.Datapoint> get dataPoints => $_getMap(1);
}

class PublishValuesResponse extends $pb.GeneratedMessage {
  factory PublishValuesResponse({
    $core.int? requestId,
    $core.Iterable<$core.MapEntry<$core.int, $1.Error>>? status,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (status != null) result.status.addEntries(status);
    return result;
  }

  PublishValuesResponse._();

  factory PublishValuesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishValuesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishValuesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'requestId', fieldType: $pb.PbFieldType.OU3)
    ..m<$core.int, $1.Error>(2, _omitFieldNames ? '' : 'status',
        entryClassName: 'PublishValuesResponse.StatusEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $1.Error.create,
        valueDefaultOrMaker: $1.Error.getDefault,
        packageName: const $pb.PackageName('kuksa.val.v2'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishValuesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishValuesResponse copyWith(
          void Function(PublishValuesResponse) updates) =>
      super.copyWith((message) => updates(message as PublishValuesResponse))
          as PublishValuesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishValuesResponse create() => PublishValuesResponse._();
  @$core.override
  PublishValuesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishValuesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishValuesResponse>(create);
  static PublishValuesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestId => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.int, $1.Error> get status => $_getMap(1);
}

class ProvideActuationRequest extends $pb.GeneratedMessage {
  factory ProvideActuationRequest({
    $core.Iterable<$1.SignalID>? actuatorIdentifiers,
  }) {
    final result = create();
    if (actuatorIdentifiers != null)
      result.actuatorIdentifiers.addAll(actuatorIdentifiers);
    return result;
  }

  ProvideActuationRequest._();

  factory ProvideActuationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProvideActuationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProvideActuationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..pPM<$1.SignalID>(1, _omitFieldNames ? '' : 'actuatorIdentifiers',
        subBuilder: $1.SignalID.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProvideActuationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProvideActuationRequest copyWith(
          void Function(ProvideActuationRequest) updates) =>
      super.copyWith((message) => updates(message as ProvideActuationRequest))
          as ProvideActuationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProvideActuationRequest create() => ProvideActuationRequest._();
  @$core.override
  ProvideActuationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProvideActuationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProvideActuationRequest>(create);
  static ProvideActuationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.SignalID> get actuatorIdentifiers => $_getList(0);
}

class ProvideActuationResponse extends $pb.GeneratedMessage {
  factory ProvideActuationResponse() => create();

  ProvideActuationResponse._();

  factory ProvideActuationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProvideActuationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProvideActuationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProvideActuationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProvideActuationResponse copyWith(
          void Function(ProvideActuationResponse) updates) =>
      super.copyWith((message) => updates(message as ProvideActuationResponse))
          as ProvideActuationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProvideActuationResponse create() => ProvideActuationResponse._();
  @$core.override
  ProvideActuationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProvideActuationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProvideActuationResponse>(create);
  static ProvideActuationResponse? _defaultInstance;
}

class ProvideSignalRequest extends $pb.GeneratedMessage {
  factory ProvideSignalRequest({
    $core.Iterable<$core.MapEntry<$core.int, $1.SampleInterval>>?
        signalsSampleIntervals,
  }) {
    final result = create();
    if (signalsSampleIntervals != null)
      result.signalsSampleIntervals.addEntries(signalsSampleIntervals);
    return result;
  }

  ProvideSignalRequest._();

  factory ProvideSignalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProvideSignalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProvideSignalRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..m<$core.int, $1.SampleInterval>(
        1, _omitFieldNames ? '' : 'signalsSampleIntervals',
        entryClassName: 'ProvideSignalRequest.SignalsSampleIntervalsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $1.SampleInterval.create,
        valueDefaultOrMaker: $1.SampleInterval.getDefault,
        packageName: const $pb.PackageName('kuksa.val.v2'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProvideSignalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProvideSignalRequest copyWith(void Function(ProvideSignalRequest) updates) =>
      super.copyWith((message) => updates(message as ProvideSignalRequest))
          as ProvideSignalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProvideSignalRequest create() => ProvideSignalRequest._();
  @$core.override
  ProvideSignalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProvideSignalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProvideSignalRequest>(create);
  static ProvideSignalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, $1.SampleInterval> get signalsSampleIntervals =>
      $_getMap(0);
}

class ProvideSignalResponse extends $pb.GeneratedMessage {
  factory ProvideSignalResponse() => create();

  ProvideSignalResponse._();

  factory ProvideSignalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProvideSignalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProvideSignalResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProvideSignalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProvideSignalResponse copyWith(
          void Function(ProvideSignalResponse) updates) =>
      super.copyWith((message) => updates(message as ProvideSignalResponse))
          as ProvideSignalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProvideSignalResponse create() => ProvideSignalResponse._();
  @$core.override
  ProvideSignalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProvideSignalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProvideSignalResponse>(create);
  static ProvideSignalResponse? _defaultInstance;
}

class BatchActuateStreamRequest extends $pb.GeneratedMessage {
  factory BatchActuateStreamRequest({
    $core.Iterable<ActuateRequest>? actuateRequests,
  }) {
    final result = create();
    if (actuateRequests != null) result.actuateRequests.addAll(actuateRequests);
    return result;
  }

  BatchActuateStreamRequest._();

  factory BatchActuateStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchActuateStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchActuateStreamRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..pPM<ActuateRequest>(1, _omitFieldNames ? '' : 'actuateRequests',
        subBuilder: ActuateRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchActuateStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchActuateStreamRequest copyWith(
          void Function(BatchActuateStreamRequest) updates) =>
      super.copyWith((message) => updates(message as BatchActuateStreamRequest))
          as BatchActuateStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchActuateStreamRequest create() => BatchActuateStreamRequest._();
  @$core.override
  BatchActuateStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchActuateStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchActuateStreamRequest>(create);
  static BatchActuateStreamRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ActuateRequest> get actuateRequests => $_getList(0);
}

/// Message that shall be used by provider to indicate if an actuation request was accepted.
class BatchActuateStreamResponse extends $pb.GeneratedMessage {
  factory BatchActuateStreamResponse({
    $1.SignalID? signalId,
    $1.Error? error,
  }) {
    final result = create();
    if (signalId != null) result.signalId = signalId;
    if (error != null) result.error = error;
    return result;
  }

  BatchActuateStreamResponse._();

  factory BatchActuateStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchActuateStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchActuateStreamResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aOM<$1.SignalID>(1, _omitFieldNames ? '' : 'signalId',
        subBuilder: $1.SignalID.create)
    ..aOM<$1.Error>(2, _omitFieldNames ? '' : 'error',
        subBuilder: $1.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchActuateStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchActuateStreamResponse copyWith(
          void Function(BatchActuateStreamResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BatchActuateStreamResponse))
          as BatchActuateStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchActuateStreamResponse create() => BatchActuateStreamResponse._();
  @$core.override
  BatchActuateStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchActuateStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchActuateStreamResponse>(create);
  static BatchActuateStreamResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.SignalID get signalId => $_getN(0);
  @$pb.TagNumber(1)
  set signalId($1.SignalID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSignalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignalId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.SignalID ensureSignalId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Error get error => $_getN(1);
  @$pb.TagNumber(2)
  set error($1.Error value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Error ensureError() => $_ensure(1);
}

class UpdateFilterRequest extends $pb.GeneratedMessage {
  factory UpdateFilterRequest({
    $core.int? requestId,
    $core.Iterable<$core.MapEntry<$core.int, $1.Filter>>? filtersUpdate,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (filtersUpdate != null) result.filtersUpdate.addEntries(filtersUpdate);
    return result;
  }

  UpdateFilterRequest._();

  factory UpdateFilterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateFilterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateFilterRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'requestId', fieldType: $pb.PbFieldType.OU3)
    ..m<$core.int, $1.Filter>(2, _omitFieldNames ? '' : 'filtersUpdate',
        entryClassName: 'UpdateFilterRequest.FiltersUpdateEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $1.Filter.create,
        valueDefaultOrMaker: $1.Filter.getDefault,
        packageName: const $pb.PackageName('kuksa.val.v2'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFilterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFilterRequest copyWith(void Function(UpdateFilterRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateFilterRequest))
          as UpdateFilterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateFilterRequest create() => UpdateFilterRequest._();
  @$core.override
  UpdateFilterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateFilterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateFilterRequest>(create);
  static UpdateFilterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestId => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  /// Databroker sends filters to provider.
  /// In case provider restarts, databroker will send local filters stored
  /// to continue the provider sending same signals with same filter.
  @$pb.TagNumber(2)
  $pb.PbMap<$core.int, $1.Filter> get filtersUpdate => $_getMap(1);
}

/// Only returned if there is a filter error on provider side
class UpdateFilterResponse extends $pb.GeneratedMessage {
  factory UpdateFilterResponse({
    $core.int? requestId,
    $1.FilterError? filterError,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (filterError != null) result.filterError = filterError;
    return result;
  }

  UpdateFilterResponse._();

  factory UpdateFilterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateFilterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateFilterResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'requestId', fieldType: $pb.PbFieldType.OU3)
    ..aE<$1.FilterError>(2, _omitFieldNames ? '' : 'filterError',
        enumValues: $1.FilterError.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFilterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFilterResponse copyWith(void Function(UpdateFilterResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateFilterResponse))
          as UpdateFilterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateFilterResponse create() => UpdateFilterResponse._();
  @$core.override
  UpdateFilterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateFilterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateFilterResponse>(create);
  static UpdateFilterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestId => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.FilterError get filterError => $_getN(1);
  @$pb.TagNumber(2)
  set filterError($1.FilterError value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFilterError() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilterError() => $_clearField(2);
}

/// Send to indicate an error on provider side
class ProviderErrorIndication extends $pb.GeneratedMessage {
  factory ProviderErrorIndication({
    $1.ProviderError? providerError,
  }) {
    final result = create();
    if (providerError != null) result.providerError = providerError;
    return result;
  }

  ProviderErrorIndication._();

  factory ProviderErrorIndication.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProviderErrorIndication.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProviderErrorIndication',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aE<$1.ProviderError>(1, _omitFieldNames ? '' : 'providerError',
        enumValues: $1.ProviderError.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderErrorIndication clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderErrorIndication copyWith(
          void Function(ProviderErrorIndication) updates) =>
      super.copyWith((message) => updates(message as ProviderErrorIndication))
          as ProviderErrorIndication;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderErrorIndication create() => ProviderErrorIndication._();
  @$core.override
  ProviderErrorIndication createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProviderErrorIndication getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProviderErrorIndication>(create);
  static ProviderErrorIndication? _defaultInstance;

  @$pb.TagNumber(1)
  $1.ProviderError get providerError => $_getN(0);
  @$pb.TagNumber(1)
  set providerError($1.ProviderError value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProviderError() => $_has(0);
  @$pb.TagNumber(1)
  void clearProviderError() => $_clearField(1);
}

class GetProviderValueRequest extends $pb.GeneratedMessage {
  factory GetProviderValueRequest({
    $core.int? requestId,
    GetValueRequest? request,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (request != null) result.request = request;
    return result;
  }

  GetProviderValueRequest._();

  factory GetProviderValueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProviderValueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProviderValueRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'requestId', fieldType: $pb.PbFieldType.OU3)
    ..aOM<GetValueRequest>(2, _omitFieldNames ? '' : 'request',
        subBuilder: GetValueRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProviderValueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProviderValueRequest copyWith(
          void Function(GetProviderValueRequest) updates) =>
      super.copyWith((message) => updates(message as GetProviderValueRequest))
          as GetProviderValueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProviderValueRequest create() => GetProviderValueRequest._();
  @$core.override
  GetProviderValueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProviderValueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProviderValueRequest>(create);
  static GetProviderValueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestId => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  GetValueRequest get request => $_getN(1);
  @$pb.TagNumber(2)
  set request(GetValueRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequest() => $_clearField(2);
  @$pb.TagNumber(2)
  GetValueRequest ensureRequest() => $_ensure(1);
}

class GetProviderValueResponse extends $pb.GeneratedMessage {
  factory GetProviderValueResponse({
    $core.int? requestId,
    GetValueResponse? response,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (response != null) result.response = response;
    return result;
  }

  GetProviderValueResponse._();

  factory GetProviderValueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProviderValueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProviderValueResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'requestId', fieldType: $pb.PbFieldType.OU3)
    ..aOM<GetValueResponse>(2, _omitFieldNames ? '' : 'response',
        subBuilder: GetValueResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProviderValueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProviderValueResponse copyWith(
          void Function(GetProviderValueResponse) updates) =>
      super.copyWith((message) => updates(message as GetProviderValueResponse))
          as GetProviderValueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProviderValueResponse create() => GetProviderValueResponse._();
  @$core.override
  GetProviderValueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProviderValueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProviderValueResponse>(create);
  static GetProviderValueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestId => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  GetValueResponse get response => $_getN(1);
  @$pb.TagNumber(2)
  set response(GetValueResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearResponse() => $_clearField(2);
  @$pb.TagNumber(2)
  GetValueResponse ensureResponse() => $_ensure(1);
}

enum OpenProviderStreamRequest_Action {
  provideActuationRequest,
  publishValuesRequest,
  batchActuateStreamResponse,
  provideSignalRequest,
  updateFilterResponse,
  getProviderValueResponse,
  providerErrorIndication,
  notSet
}

class OpenProviderStreamRequest extends $pb.GeneratedMessage {
  factory OpenProviderStreamRequest({
    ProvideActuationRequest? provideActuationRequest,
    PublishValuesRequest? publishValuesRequest,
    BatchActuateStreamResponse? batchActuateStreamResponse,
    ProvideSignalRequest? provideSignalRequest,
    UpdateFilterResponse? updateFilterResponse,
    GetProviderValueResponse? getProviderValueResponse,
    ProviderErrorIndication? providerErrorIndication,
  }) {
    final result = create();
    if (provideActuationRequest != null)
      result.provideActuationRequest = provideActuationRequest;
    if (publishValuesRequest != null)
      result.publishValuesRequest = publishValuesRequest;
    if (batchActuateStreamResponse != null)
      result.batchActuateStreamResponse = batchActuateStreamResponse;
    if (provideSignalRequest != null)
      result.provideSignalRequest = provideSignalRequest;
    if (updateFilterResponse != null)
      result.updateFilterResponse = updateFilterResponse;
    if (getProviderValueResponse != null)
      result.getProviderValueResponse = getProviderValueResponse;
    if (providerErrorIndication != null)
      result.providerErrorIndication = providerErrorIndication;
    return result;
  }

  OpenProviderStreamRequest._();

  factory OpenProviderStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenProviderStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, OpenProviderStreamRequest_Action>
      _OpenProviderStreamRequest_ActionByTag = {
    1: OpenProviderStreamRequest_Action.provideActuationRequest,
    2: OpenProviderStreamRequest_Action.publishValuesRequest,
    3: OpenProviderStreamRequest_Action.batchActuateStreamResponse,
    4: OpenProviderStreamRequest_Action.provideSignalRequest,
    5: OpenProviderStreamRequest_Action.updateFilterResponse,
    6: OpenProviderStreamRequest_Action.getProviderValueResponse,
    7: OpenProviderStreamRequest_Action.providerErrorIndication,
    0: OpenProviderStreamRequest_Action.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenProviderStreamRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
    ..aOM<ProvideActuationRequest>(
        1, _omitFieldNames ? '' : 'provideActuationRequest',
        subBuilder: ProvideActuationRequest.create)
    ..aOM<PublishValuesRequest>(
        2, _omitFieldNames ? '' : 'publishValuesRequest',
        subBuilder: PublishValuesRequest.create)
    ..aOM<BatchActuateStreamResponse>(
        3, _omitFieldNames ? '' : 'batchActuateStreamResponse',
        subBuilder: BatchActuateStreamResponse.create)
    ..aOM<ProvideSignalRequest>(
        4, _omitFieldNames ? '' : 'provideSignalRequest',
        subBuilder: ProvideSignalRequest.create)
    ..aOM<UpdateFilterResponse>(
        5, _omitFieldNames ? '' : 'updateFilterResponse',
        subBuilder: UpdateFilterResponse.create)
    ..aOM<GetProviderValueResponse>(
        6, _omitFieldNames ? '' : 'getProviderValueResponse',
        subBuilder: GetProviderValueResponse.create)
    ..aOM<ProviderErrorIndication>(
        7, _omitFieldNames ? '' : 'providerErrorIndication',
        subBuilder: ProviderErrorIndication.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenProviderStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenProviderStreamRequest copyWith(
          void Function(OpenProviderStreamRequest) updates) =>
      super.copyWith((message) => updates(message as OpenProviderStreamRequest))
          as OpenProviderStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenProviderStreamRequest create() => OpenProviderStreamRequest._();
  @$core.override
  OpenProviderStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenProviderStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenProviderStreamRequest>(create);
  static OpenProviderStreamRequest? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  OpenProviderStreamRequest_Action whichAction() =>
      _OpenProviderStreamRequest_ActionByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearAction() => $_clearField($_whichOneof(0));

  /// Inform server of an actuator this provider provides.
  @$pb.TagNumber(1)
  ProvideActuationRequest get provideActuationRequest => $_getN(0);
  @$pb.TagNumber(1)
  set provideActuationRequest(ProvideActuationRequest value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProvideActuationRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvideActuationRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  ProvideActuationRequest ensureProvideActuationRequest() => $_ensure(0);

  /// Publish a value.
  @$pb.TagNumber(2)
  PublishValuesRequest get publishValuesRequest => $_getN(1);
  @$pb.TagNumber(2)
  set publishValuesRequest(PublishValuesRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishValuesRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishValuesRequest() => $_clearField(2);
  @$pb.TagNumber(2)
  PublishValuesRequest ensurePublishValuesRequest() => $_ensure(1);

  /// Sent to acknowledge the acceptance of a batch actuate
  /// request.
  @$pb.TagNumber(3)
  BatchActuateStreamResponse get batchActuateStreamResponse => $_getN(2);
  @$pb.TagNumber(3)
  set batchActuateStreamResponse(BatchActuateStreamResponse value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBatchActuateStreamResponse() => $_has(2);
  @$pb.TagNumber(3)
  void clearBatchActuateStreamResponse() => $_clearField(3);
  @$pb.TagNumber(3)
  BatchActuateStreamResponse ensureBatchActuateStreamResponse() => $_ensure(2);

  /// Inform server of a signal this provider provides.
  @$pb.TagNumber(4)
  ProvideSignalRequest get provideSignalRequest => $_getN(3);
  @$pb.TagNumber(4)
  set provideSignalRequest(ProvideSignalRequest value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProvideSignalRequest() => $_has(3);
  @$pb.TagNumber(4)
  void clearProvideSignalRequest() => $_clearField(4);
  @$pb.TagNumber(4)
  ProvideSignalRequest ensureProvideSignalRequest() => $_ensure(3);

  /// Update filter response
  @$pb.TagNumber(5)
  UpdateFilterResponse get updateFilterResponse => $_getN(4);
  @$pb.TagNumber(5)
  set updateFilterResponse(UpdateFilterResponse value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdateFilterResponse() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdateFilterResponse() => $_clearField(5);
  @$pb.TagNumber(5)
  UpdateFilterResponse ensureUpdateFilterResponse() => $_ensure(4);

  /// GetValue response
  @$pb.TagNumber(6)
  GetProviderValueResponse get getProviderValueResponse => $_getN(5);
  @$pb.TagNumber(6)
  set getProviderValueResponse(GetProviderValueResponse value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGetProviderValueResponse() => $_has(5);
  @$pb.TagNumber(6)
  void clearGetProviderValueResponse() => $_clearField(6);
  @$pb.TagNumber(6)
  GetProviderValueResponse ensureGetProviderValueResponse() => $_ensure(5);

  /// Indication of error on provider side
  @$pb.TagNumber(7)
  ProviderErrorIndication get providerErrorIndication => $_getN(6);
  @$pb.TagNumber(7)
  set providerErrorIndication(ProviderErrorIndication value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasProviderErrorIndication() => $_has(6);
  @$pb.TagNumber(7)
  void clearProviderErrorIndication() => $_clearField(7);
  @$pb.TagNumber(7)
  ProviderErrorIndication ensureProviderErrorIndication() => $_ensure(6);
}

enum OpenProviderStreamResponse_Action {
  provideActuationResponse,
  publishValuesResponse,
  batchActuateStreamRequest,
  provideSignalResponse,
  updateFilterRequest,
  getProviderValueRequest,
  notSet
}

class OpenProviderStreamResponse extends $pb.GeneratedMessage {
  factory OpenProviderStreamResponse({
    ProvideActuationResponse? provideActuationResponse,
    PublishValuesResponse? publishValuesResponse,
    BatchActuateStreamRequest? batchActuateStreamRequest,
    ProvideSignalResponse? provideSignalResponse,
    UpdateFilterRequest? updateFilterRequest,
    GetProviderValueRequest? getProviderValueRequest,
  }) {
    final result = create();
    if (provideActuationResponse != null)
      result.provideActuationResponse = provideActuationResponse;
    if (publishValuesResponse != null)
      result.publishValuesResponse = publishValuesResponse;
    if (batchActuateStreamRequest != null)
      result.batchActuateStreamRequest = batchActuateStreamRequest;
    if (provideSignalResponse != null)
      result.provideSignalResponse = provideSignalResponse;
    if (updateFilterRequest != null)
      result.updateFilterRequest = updateFilterRequest;
    if (getProviderValueRequest != null)
      result.getProviderValueRequest = getProviderValueRequest;
    return result;
  }

  OpenProviderStreamResponse._();

  factory OpenProviderStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenProviderStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, OpenProviderStreamResponse_Action>
      _OpenProviderStreamResponse_ActionByTag = {
    1: OpenProviderStreamResponse_Action.provideActuationResponse,
    2: OpenProviderStreamResponse_Action.publishValuesResponse,
    3: OpenProviderStreamResponse_Action.batchActuateStreamRequest,
    4: OpenProviderStreamResponse_Action.provideSignalResponse,
    5: OpenProviderStreamResponse_Action.updateFilterRequest,
    6: OpenProviderStreamResponse_Action.getProviderValueRequest,
    0: OpenProviderStreamResponse_Action.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenProviderStreamResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..aOM<ProvideActuationResponse>(
        1, _omitFieldNames ? '' : 'provideActuationResponse',
        subBuilder: ProvideActuationResponse.create)
    ..aOM<PublishValuesResponse>(
        2, _omitFieldNames ? '' : 'publishValuesResponse',
        subBuilder: PublishValuesResponse.create)
    ..aOM<BatchActuateStreamRequest>(
        3, _omitFieldNames ? '' : 'batchActuateStreamRequest',
        subBuilder: BatchActuateStreamRequest.create)
    ..aOM<ProvideSignalResponse>(
        4, _omitFieldNames ? '' : 'provideSignalResponse',
        subBuilder: ProvideSignalResponse.create)
    ..aOM<UpdateFilterRequest>(5, _omitFieldNames ? '' : 'updateFilterRequest',
        subBuilder: UpdateFilterRequest.create)
    ..aOM<GetProviderValueRequest>(
        6, _omitFieldNames ? '' : 'getProviderValueRequest',
        subBuilder: GetProviderValueRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenProviderStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenProviderStreamResponse copyWith(
          void Function(OpenProviderStreamResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OpenProviderStreamResponse))
          as OpenProviderStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenProviderStreamResponse create() => OpenProviderStreamResponse._();
  @$core.override
  OpenProviderStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenProviderStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenProviderStreamResponse>(create);
  static OpenProviderStreamResponse? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  OpenProviderStreamResponse_Action whichAction() =>
      _OpenProviderStreamResponse_ActionByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  void clearAction() => $_clearField($_whichOneof(0));

  /// Response to a provide actuator request.
  @$pb.TagNumber(1)
  ProvideActuationResponse get provideActuationResponse => $_getN(0);
  @$pb.TagNumber(1)
  set provideActuationResponse(ProvideActuationResponse value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProvideActuationResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvideActuationResponse() => $_clearField(1);
  @$pb.TagNumber(1)
  ProvideActuationResponse ensureProvideActuationResponse() => $_ensure(0);

  /// Acknowledgement that a published value was received.
  @$pb.TagNumber(2)
  PublishValuesResponse get publishValuesResponse => $_getN(1);
  @$pb.TagNumber(2)
  set publishValuesResponse(PublishValuesResponse value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishValuesResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishValuesResponse() => $_clearField(2);
  @$pb.TagNumber(2)
  PublishValuesResponse ensurePublishValuesResponse() => $_ensure(1);

  /// Send a batch actuate request to a provider.
  @$pb.TagNumber(3)
  BatchActuateStreamRequest get batchActuateStreamRequest => $_getN(2);
  @$pb.TagNumber(3)
  set batchActuateStreamRequest(BatchActuateStreamRequest value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBatchActuateStreamRequest() => $_has(2);
  @$pb.TagNumber(3)
  void clearBatchActuateStreamRequest() => $_clearField(3);
  @$pb.TagNumber(3)
  BatchActuateStreamRequest ensureBatchActuateStreamRequest() => $_ensure(2);

  /// Response to a provide sensor request.
  @$pb.TagNumber(4)
  ProvideSignalResponse get provideSignalResponse => $_getN(3);
  @$pb.TagNumber(4)
  set provideSignalResponse(ProvideSignalResponse value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProvideSignalResponse() => $_has(3);
  @$pb.TagNumber(4)
  void clearProvideSignalResponse() => $_clearField(4);
  @$pb.TagNumber(4)
  ProvideSignalResponse ensureProvideSignalResponse() => $_ensure(3);

  /// Filter request
  @$pb.TagNumber(5)
  UpdateFilterRequest get updateFilterRequest => $_getN(4);
  @$pb.TagNumber(5)
  set updateFilterRequest(UpdateFilterRequest value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdateFilterRequest() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdateFilterRequest() => $_clearField(5);
  @$pb.TagNumber(5)
  UpdateFilterRequest ensureUpdateFilterRequest() => $_ensure(4);

  /// GetValue request from client forwarded to provider
  @$pb.TagNumber(6)
  GetProviderValueRequest get getProviderValueRequest => $_getN(5);
  @$pb.TagNumber(6)
  set getProviderValueRequest(GetProviderValueRequest value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGetProviderValueRequest() => $_has(5);
  @$pb.TagNumber(6)
  void clearGetProviderValueRequest() => $_clearField(6);
  @$pb.TagNumber(6)
  GetProviderValueRequest ensureGetProviderValueRequest() => $_ensure(5);
}

class GetServerInfoRequest extends $pb.GeneratedMessage {
  factory GetServerInfoRequest() => create();

  GetServerInfoRequest._();

  factory GetServerInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServerInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServerInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoRequest copyWith(void Function(GetServerInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetServerInfoRequest))
          as GetServerInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServerInfoRequest create() => GetServerInfoRequest._();
  @$core.override
  GetServerInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServerInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServerInfoRequest>(create);
  static GetServerInfoRequest? _defaultInstance;
}

class GetServerInfoResponse extends $pb.GeneratedMessage {
  factory GetServerInfoResponse({
    $core.String? name,
    $core.String? version,
    $core.String? commitHash,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (version != null) result.version = version;
    if (commitHash != null) result.commitHash = commitHash;
    return result;
  }

  GetServerInfoResponse._();

  factory GetServerInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServerInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServerInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'kuksa.val.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'commitHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoResponse copyWith(
          void Function(GetServerInfoResponse) updates) =>
      super.copyWith((message) => updates(message as GetServerInfoResponse))
          as GetServerInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServerInfoResponse create() => GetServerInfoResponse._();
  @$core.override
  GetServerInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServerInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServerInfoResponse>(create);
  static GetServerInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commitHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set commitHash($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommitHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommitHash() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
