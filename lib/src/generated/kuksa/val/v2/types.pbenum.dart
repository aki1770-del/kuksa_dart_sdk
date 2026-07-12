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

import 'package:protobuf/protobuf.dart' as $pb;

class FilterError extends $pb.ProtobufEnum {
  static const FilterError FILTER_ERROR_CODE_UNSPECIFIED =
      FilterError._(0, _omitEnumNames ? '' : 'FILTER_ERROR_CODE_UNSPECIFIED');
  static const FilterError FILTER_ERROR_CODE_UNKNOWN_SINGAL_ID = FilterError._(
      1, _omitEnumNames ? '' : 'FILTER_ERROR_CODE_UNKNOWN_SINGAL_ID');

  static const $core.List<FilterError> values = <FilterError>[
    FILTER_ERROR_CODE_UNSPECIFIED,
    FILTER_ERROR_CODE_UNKNOWN_SINGAL_ID,
  ];

  static final $core.List<FilterError?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static FilterError? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FilterError._(super.value, super.name);
}

/// Could be extended in the future with more errors
class ProviderError extends $pb.ProtobufEnum {
  static const ProviderError CODE_UNSPECIFIED =
      ProviderError._(0, _omitEnumNames ? '' : 'CODE_UNSPECIFIED');
  static const ProviderError CODE_NETWORK_ERROR =
      ProviderError._(1, _omitEnumNames ? '' : 'CODE_NETWORK_ERROR');
  static const ProviderError CODE_OVERLOAD =
      ProviderError._(2, _omitEnumNames ? '' : 'CODE_OVERLOAD');

  static const $core.List<ProviderError> values = <ProviderError>[
    CODE_UNSPECIFIED,
    CODE_NETWORK_ERROR,
    CODE_OVERLOAD,
  ];

  static final $core.List<ProviderError?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ProviderError? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProviderError._(super.value, super.name);
}

class ErrorCode extends $pb.ProtobufEnum {
  static const ErrorCode ERROR_CODE_UNSPECIFIED =
      ErrorCode._(0, _omitEnumNames ? '' : 'ERROR_CODE_UNSPECIFIED');
  static const ErrorCode ERROR_CODE_OK =
      ErrorCode._(1, _omitEnumNames ? '' : 'ERROR_CODE_OK');
  static const ErrorCode ERROR_CODE_INVALID_ARGUMENT =
      ErrorCode._(2, _omitEnumNames ? '' : 'ERROR_CODE_INVALID_ARGUMENT');
  static const ErrorCode ERROR_CODE_NOT_FOUND =
      ErrorCode._(3, _omitEnumNames ? '' : 'ERROR_CODE_NOT_FOUND');
  static const ErrorCode ERROR_CODE_PERMISSION_DENIED =
      ErrorCode._(4, _omitEnumNames ? '' : 'ERROR_CODE_PERMISSION_DENIED');

  static const $core.List<ErrorCode> values = <ErrorCode>[
    ERROR_CODE_UNSPECIFIED,
    ERROR_CODE_OK,
    ERROR_CODE_INVALID_ARGUMENT,
    ERROR_CODE_NOT_FOUND,
    ERROR_CODE_PERMISSION_DENIED,
  ];

  static final $core.List<ErrorCode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ErrorCode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ErrorCode._(super.value, super.name);
}

/// VSS Data type of a signal
///
/// Protobuf doesn't support int8, int16, uint8 or uint16.
/// These are mapped to int32 and uint32 respectively.
class DataType extends $pb.ProtobufEnum {
  static const DataType DATA_TYPE_UNSPECIFIED =
      DataType._(0, _omitEnumNames ? '' : 'DATA_TYPE_UNSPECIFIED');
  static const DataType DATA_TYPE_STRING =
      DataType._(1, _omitEnumNames ? '' : 'DATA_TYPE_STRING');
  static const DataType DATA_TYPE_BOOLEAN =
      DataType._(2, _omitEnumNames ? '' : 'DATA_TYPE_BOOLEAN');
  static const DataType DATA_TYPE_INT8 =
      DataType._(3, _omitEnumNames ? '' : 'DATA_TYPE_INT8');
  static const DataType DATA_TYPE_INT16 =
      DataType._(4, _omitEnumNames ? '' : 'DATA_TYPE_INT16');
  static const DataType DATA_TYPE_INT32 =
      DataType._(5, _omitEnumNames ? '' : 'DATA_TYPE_INT32');
  static const DataType DATA_TYPE_INT64 =
      DataType._(6, _omitEnumNames ? '' : 'DATA_TYPE_INT64');
  static const DataType DATA_TYPE_UINT8 =
      DataType._(7, _omitEnumNames ? '' : 'DATA_TYPE_UINT8');
  static const DataType DATA_TYPE_UINT16 =
      DataType._(8, _omitEnumNames ? '' : 'DATA_TYPE_UINT16');
  static const DataType DATA_TYPE_UINT32 =
      DataType._(9, _omitEnumNames ? '' : 'DATA_TYPE_UINT32');
  static const DataType DATA_TYPE_UINT64 =
      DataType._(10, _omitEnumNames ? '' : 'DATA_TYPE_UINT64');
  static const DataType DATA_TYPE_FLOAT =
      DataType._(11, _omitEnumNames ? '' : 'DATA_TYPE_FLOAT');
  static const DataType DATA_TYPE_DOUBLE =
      DataType._(12, _omitEnumNames ? '' : 'DATA_TYPE_DOUBLE');
  static const DataType DATA_TYPE_TIMESTAMP =
      DataType._(13, _omitEnumNames ? '' : 'DATA_TYPE_TIMESTAMP');
  static const DataType DATA_TYPE_STRING_ARRAY =
      DataType._(20, _omitEnumNames ? '' : 'DATA_TYPE_STRING_ARRAY');
  static const DataType DATA_TYPE_BOOLEAN_ARRAY =
      DataType._(21, _omitEnumNames ? '' : 'DATA_TYPE_BOOLEAN_ARRAY');
  static const DataType DATA_TYPE_INT8_ARRAY =
      DataType._(22, _omitEnumNames ? '' : 'DATA_TYPE_INT8_ARRAY');
  static const DataType DATA_TYPE_INT16_ARRAY =
      DataType._(23, _omitEnumNames ? '' : 'DATA_TYPE_INT16_ARRAY');
  static const DataType DATA_TYPE_INT32_ARRAY =
      DataType._(24, _omitEnumNames ? '' : 'DATA_TYPE_INT32_ARRAY');
  static const DataType DATA_TYPE_INT64_ARRAY =
      DataType._(25, _omitEnumNames ? '' : 'DATA_TYPE_INT64_ARRAY');
  static const DataType DATA_TYPE_UINT8_ARRAY =
      DataType._(26, _omitEnumNames ? '' : 'DATA_TYPE_UINT8_ARRAY');
  static const DataType DATA_TYPE_UINT16_ARRAY =
      DataType._(27, _omitEnumNames ? '' : 'DATA_TYPE_UINT16_ARRAY');
  static const DataType DATA_TYPE_UINT32_ARRAY =
      DataType._(28, _omitEnumNames ? '' : 'DATA_TYPE_UINT32_ARRAY');
  static const DataType DATA_TYPE_UINT64_ARRAY =
      DataType._(29, _omitEnumNames ? '' : 'DATA_TYPE_UINT64_ARRAY');
  static const DataType DATA_TYPE_FLOAT_ARRAY =
      DataType._(30, _omitEnumNames ? '' : 'DATA_TYPE_FLOAT_ARRAY');
  static const DataType DATA_TYPE_DOUBLE_ARRAY =
      DataType._(31, _omitEnumNames ? '' : 'DATA_TYPE_DOUBLE_ARRAY');
  static const DataType DATA_TYPE_TIMESTAMP_ARRAY =
      DataType._(32, _omitEnumNames ? '' : 'DATA_TYPE_TIMESTAMP_ARRAY');

  static const $core.List<DataType> values = <DataType>[
    DATA_TYPE_UNSPECIFIED,
    DATA_TYPE_STRING,
    DATA_TYPE_BOOLEAN,
    DATA_TYPE_INT8,
    DATA_TYPE_INT16,
    DATA_TYPE_INT32,
    DATA_TYPE_INT64,
    DATA_TYPE_UINT8,
    DATA_TYPE_UINT16,
    DATA_TYPE_UINT32,
    DATA_TYPE_UINT64,
    DATA_TYPE_FLOAT,
    DATA_TYPE_DOUBLE,
    DATA_TYPE_TIMESTAMP,
    DATA_TYPE_STRING_ARRAY,
    DATA_TYPE_BOOLEAN_ARRAY,
    DATA_TYPE_INT8_ARRAY,
    DATA_TYPE_INT16_ARRAY,
    DATA_TYPE_INT32_ARRAY,
    DATA_TYPE_INT64_ARRAY,
    DATA_TYPE_UINT8_ARRAY,
    DATA_TYPE_UINT16_ARRAY,
    DATA_TYPE_UINT32_ARRAY,
    DATA_TYPE_UINT64_ARRAY,
    DATA_TYPE_FLOAT_ARRAY,
    DATA_TYPE_DOUBLE_ARRAY,
    DATA_TYPE_TIMESTAMP_ARRAY,
  ];

  static final $core.List<DataType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 32);
  static DataType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DataType._(super.value, super.name);
}

/// Entry type
class EntryType extends $pb.ProtobufEnum {
  static const EntryType ENTRY_TYPE_UNSPECIFIED =
      EntryType._(0, _omitEnumNames ? '' : 'ENTRY_TYPE_UNSPECIFIED');
  static const EntryType ENTRY_TYPE_ATTRIBUTE =
      EntryType._(1, _omitEnumNames ? '' : 'ENTRY_TYPE_ATTRIBUTE');
  static const EntryType ENTRY_TYPE_SENSOR =
      EntryType._(2, _omitEnumNames ? '' : 'ENTRY_TYPE_SENSOR');
  static const EntryType ENTRY_TYPE_ACTUATOR =
      EntryType._(3, _omitEnumNames ? '' : 'ENTRY_TYPE_ACTUATOR');

  static const $core.List<EntryType> values = <EntryType>[
    ENTRY_TYPE_UNSPECIFIED,
    ENTRY_TYPE_ATTRIBUTE,
    ENTRY_TYPE_SENSOR,
    ENTRY_TYPE_ACTUATOR,
  ];

  static final $core.List<EntryType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static EntryType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntryType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
