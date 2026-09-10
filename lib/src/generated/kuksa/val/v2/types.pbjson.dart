// This is a generated file - do not edit.
//
// Generated from kuksa/val/v2/types.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use filterErrorDescriptor instead')
const FilterError$json = {
  '1': 'FilterError',
  '2': [
    {'1': 'FILTER_ERROR_CODE_UNSPECIFIED', '2': 0},
    {'1': 'FILTER_ERROR_CODE_UNKNOWN_SINGAL_ID', '2': 1},
  ],
};

/// Descriptor for `FilterError`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List filterErrorDescriptor = $convert.base64Decode(
    'CgtGaWx0ZXJFcnJvchIhCh1GSUxURVJfRVJST1JfQ09ERV9VTlNQRUNJRklFRBAAEicKI0ZJTF'
    'RFUl9FUlJPUl9DT0RFX1VOS05PV05fU0lOR0FMX0lEEAE=');

@$core.Deprecated('Use providerErrorDescriptor instead')
const ProviderError$json = {
  '1': 'ProviderError',
  '2': [
    {'1': 'CODE_UNSPECIFIED', '2': 0},
    {'1': 'CODE_NETWORK_ERROR', '2': 1},
    {'1': 'CODE_OVERLOAD', '2': 2},
  ],
};

/// Descriptor for `ProviderError`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List providerErrorDescriptor = $convert.base64Decode(
    'Cg1Qcm92aWRlckVycm9yEhQKEENPREVfVU5TUEVDSUZJRUQQABIWChJDT0RFX05FVFdPUktfRV'
    'JST1IQARIRCg1DT0RFX09WRVJMT0FEEAI=');

@$core.Deprecated('Use errorCodeDescriptor instead')
const ErrorCode$json = {
  '1': 'ErrorCode',
  '2': [
    {'1': 'ERROR_CODE_UNSPECIFIED', '2': 0},
    {'1': 'ERROR_CODE_OK', '2': 1},
    {'1': 'ERROR_CODE_INVALID_ARGUMENT', '2': 2},
    {'1': 'ERROR_CODE_NOT_FOUND', '2': 3},
    {'1': 'ERROR_CODE_PERMISSION_DENIED', '2': 4},
  ],
};

/// Descriptor for `ErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List errorCodeDescriptor = $convert.base64Decode(
    'CglFcnJvckNvZGUSGgoWRVJST1JfQ09ERV9VTlNQRUNJRklFRBAAEhEKDUVSUk9SX0NPREVfT0'
    'sQARIfChtFUlJPUl9DT0RFX0lOVkFMSURfQVJHVU1FTlQQAhIYChRFUlJPUl9DT0RFX05PVF9G'
    'T1VORBADEiAKHEVSUk9SX0NPREVfUEVSTUlTU0lPTl9ERU5JRUQQBA==');

@$core.Deprecated('Use dataTypeDescriptor instead')
const DataType$json = {
  '1': 'DataType',
  '2': [
    {'1': 'DATA_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'DATA_TYPE_STRING', '2': 1},
    {'1': 'DATA_TYPE_BOOLEAN', '2': 2},
    {'1': 'DATA_TYPE_INT8', '2': 3},
    {'1': 'DATA_TYPE_INT16', '2': 4},
    {'1': 'DATA_TYPE_INT32', '2': 5},
    {'1': 'DATA_TYPE_INT64', '2': 6},
    {'1': 'DATA_TYPE_UINT8', '2': 7},
    {'1': 'DATA_TYPE_UINT16', '2': 8},
    {'1': 'DATA_TYPE_UINT32', '2': 9},
    {'1': 'DATA_TYPE_UINT64', '2': 10},
    {'1': 'DATA_TYPE_FLOAT', '2': 11},
    {'1': 'DATA_TYPE_DOUBLE', '2': 12},
    {'1': 'DATA_TYPE_TIMESTAMP', '2': 13},
    {'1': 'DATA_TYPE_STRING_ARRAY', '2': 20},
    {'1': 'DATA_TYPE_BOOLEAN_ARRAY', '2': 21},
    {'1': 'DATA_TYPE_INT8_ARRAY', '2': 22},
    {'1': 'DATA_TYPE_INT16_ARRAY', '2': 23},
    {'1': 'DATA_TYPE_INT32_ARRAY', '2': 24},
    {'1': 'DATA_TYPE_INT64_ARRAY', '2': 25},
    {'1': 'DATA_TYPE_UINT8_ARRAY', '2': 26},
    {'1': 'DATA_TYPE_UINT16_ARRAY', '2': 27},
    {'1': 'DATA_TYPE_UINT32_ARRAY', '2': 28},
    {'1': 'DATA_TYPE_UINT64_ARRAY', '2': 29},
    {'1': 'DATA_TYPE_FLOAT_ARRAY', '2': 30},
    {'1': 'DATA_TYPE_DOUBLE_ARRAY', '2': 31},
    {'1': 'DATA_TYPE_TIMESTAMP_ARRAY', '2': 32},
  ],
};

/// Descriptor for `DataType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dataTypeDescriptor = $convert.base64Decode(
    'CghEYXRhVHlwZRIZChVEQVRBX1RZUEVfVU5TUEVDSUZJRUQQABIUChBEQVRBX1RZUEVfU1RSSU'
    '5HEAESFQoRREFUQV9UWVBFX0JPT0xFQU4QAhISCg5EQVRBX1RZUEVfSU5UOBADEhMKD0RBVEFf'
    'VFlQRV9JTlQxNhAEEhMKD0RBVEFfVFlQRV9JTlQzMhAFEhMKD0RBVEFfVFlQRV9JTlQ2NBAGEh'
    'MKD0RBVEFfVFlQRV9VSU5UOBAHEhQKEERBVEFfVFlQRV9VSU5UMTYQCBIUChBEQVRBX1RZUEVf'
    'VUlOVDMyEAkSFAoQREFUQV9UWVBFX1VJTlQ2NBAKEhMKD0RBVEFfVFlQRV9GTE9BVBALEhQKEE'
    'RBVEFfVFlQRV9ET1VCTEUQDBIXChNEQVRBX1RZUEVfVElNRVNUQU1QEA0SGgoWREFUQV9UWVBF'
    'X1NUUklOR19BUlJBWRAUEhsKF0RBVEFfVFlQRV9CT09MRUFOX0FSUkFZEBUSGAoUREFUQV9UWV'
    'BFX0lOVDhfQVJSQVkQFhIZChVEQVRBX1RZUEVfSU5UMTZfQVJSQVkQFxIZChVEQVRBX1RZUEVf'
    'SU5UMzJfQVJSQVkQGBIZChVEQVRBX1RZUEVfSU5UNjRfQVJSQVkQGRIZChVEQVRBX1RZUEVfVU'
    'lOVDhfQVJSQVkQGhIaChZEQVRBX1RZUEVfVUlOVDE2X0FSUkFZEBsSGgoWREFUQV9UWVBFX1VJ'
    'TlQzMl9BUlJBWRAcEhoKFkRBVEFfVFlQRV9VSU5UNjRfQVJSQVkQHRIZChVEQVRBX1RZUEVfRk'
    'xPQVRfQVJSQVkQHhIaChZEQVRBX1RZUEVfRE9VQkxFX0FSUkFZEB8SHQoZREFUQV9UWVBFX1RJ'
    'TUVTVEFNUF9BUlJBWRAg');

@$core.Deprecated('Use entryTypeDescriptor instead')
const EntryType$json = {
  '1': 'EntryType',
  '2': [
    {'1': 'ENTRY_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ENTRY_TYPE_ATTRIBUTE', '2': 1},
    {'1': 'ENTRY_TYPE_SENSOR', '2': 2},
    {'1': 'ENTRY_TYPE_ACTUATOR', '2': 3},
  ],
};

/// Descriptor for `EntryType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entryTypeDescriptor = $convert.base64Decode(
    'CglFbnRyeVR5cGUSGgoWRU5UUllfVFlQRV9VTlNQRUNJRklFRBAAEhgKFEVOVFJZX1RZUEVfQV'
    'RUUklCVVRFEAESFQoRRU5UUllfVFlQRV9TRU5TT1IQAhIXChNFTlRSWV9UWVBFX0FDVFVBVE9S'
    'EAM=');

@$core.Deprecated('Use datapointDescriptor instead')
const Datapoint$json = {
  '1': 'Datapoint',
  '2': [
    {
      '1': 'timestamp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Value',
      '10': 'value'
    },
  ],
};

/// Descriptor for `Datapoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List datapointDescriptor = $convert.base64Decode(
    'CglEYXRhcG9pbnQSOAoJdGltZXN0YW1wGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJdGltZXN0YW1wEikKBXZhbHVlGAIgASgLMhMua3Vrc2EudmFsLnYyLlZhbHVlUgV2YWx1'
    'ZQ==');

@$core.Deprecated('Use valueDescriptor instead')
const Value$json = {
  '1': 'Value',
  '2': [
    {'1': 'string', '3': 11, '4': 1, '5': 9, '9': 0, '10': 'string'},
    {'1': 'bool', '3': 12, '4': 1, '5': 8, '9': 0, '10': 'bool'},
    {'1': 'int32', '3': 13, '4': 1, '5': 17, '9': 0, '10': 'int32'},
    {'1': 'int64', '3': 14, '4': 1, '5': 18, '9': 0, '10': 'int64'},
    {'1': 'uint32', '3': 15, '4': 1, '5': 13, '9': 0, '10': 'uint32'},
    {'1': 'uint64', '3': 16, '4': 1, '5': 4, '9': 0, '10': 'uint64'},
    {'1': 'float', '3': 17, '4': 1, '5': 2, '9': 0, '10': 'float'},
    {'1': 'double', '3': 18, '4': 1, '5': 1, '9': 0, '10': 'double'},
    {
      '1': 'string_array',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.StringArray',
      '9': 0,
      '10': 'stringArray'
    },
    {
      '1': 'bool_array',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.BoolArray',
      '9': 0,
      '10': 'boolArray'
    },
    {
      '1': 'int32_array',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Int32Array',
      '9': 0,
      '10': 'int32Array'
    },
    {
      '1': 'int64_array',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Int64Array',
      '9': 0,
      '10': 'int64Array'
    },
    {
      '1': 'uint32_array',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Uint32Array',
      '9': 0,
      '10': 'uint32Array'
    },
    {
      '1': 'uint64_array',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Uint64Array',
      '9': 0,
      '10': 'uint64Array'
    },
    {
      '1': 'float_array',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.FloatArray',
      '9': 0,
      '10': 'floatArray'
    },
    {
      '1': 'double_array',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.DoubleArray',
      '9': 0,
      '10': 'doubleArray'
    },
  ],
  '8': [
    {'1': 'typed_value'},
  ],
};

/// Descriptor for `Value`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List valueDescriptor = $convert.base64Decode(
    'CgVWYWx1ZRIYCgZzdHJpbmcYCyABKAlIAFIGc3RyaW5nEhQKBGJvb2wYDCABKAhIAFIEYm9vbB'
    'IWCgVpbnQzMhgNIAEoEUgAUgVpbnQzMhIWCgVpbnQ2NBgOIAEoEkgAUgVpbnQ2NBIYCgZ1aW50'
    'MzIYDyABKA1IAFIGdWludDMyEhgKBnVpbnQ2NBgQIAEoBEgAUgZ1aW50NjQSFgoFZmxvYXQYES'
    'ABKAJIAFIFZmxvYXQSGAoGZG91YmxlGBIgASgBSABSBmRvdWJsZRI+CgxzdHJpbmdfYXJyYXkY'
    'FSABKAsyGS5rdWtzYS52YWwudjIuU3RyaW5nQXJyYXlIAFILc3RyaW5nQXJyYXkSOAoKYm9vbF'
    '9hcnJheRgWIAEoCzIXLmt1a3NhLnZhbC52Mi5Cb29sQXJyYXlIAFIJYm9vbEFycmF5EjsKC2lu'
    'dDMyX2FycmF5GBcgASgLMhgua3Vrc2EudmFsLnYyLkludDMyQXJyYXlIAFIKaW50MzJBcnJheR'
    'I7CgtpbnQ2NF9hcnJheRgYIAEoCzIYLmt1a3NhLnZhbC52Mi5JbnQ2NEFycmF5SABSCmludDY0'
    'QXJyYXkSPgoMdWludDMyX2FycmF5GBkgASgLMhkua3Vrc2EudmFsLnYyLlVpbnQzMkFycmF5SA'
    'BSC3VpbnQzMkFycmF5Ej4KDHVpbnQ2NF9hcnJheRgaIAEoCzIZLmt1a3NhLnZhbC52Mi5VaW50'
    'NjRBcnJheUgAUgt1aW50NjRBcnJheRI7CgtmbG9hdF9hcnJheRgbIAEoCzIYLmt1a3NhLnZhbC'
    '52Mi5GbG9hdEFycmF5SABSCmZsb2F0QXJyYXkSPgoMZG91YmxlX2FycmF5GBwgASgLMhkua3Vr'
    'c2EudmFsLnYyLkRvdWJsZUFycmF5SABSC2RvdWJsZUFycmF5Qg0KC3R5cGVkX3ZhbHVl');

@$core.Deprecated('Use sampleIntervalDescriptor instead')
const SampleInterval$json = {
  '1': 'SampleInterval',
  '2': [
    {'1': 'interval_ms', '3': 1, '4': 1, '5': 13, '10': 'intervalMs'},
  ],
};

/// Descriptor for `SampleInterval`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleIntervalDescriptor = $convert.base64Decode(
    'Cg5TYW1wbGVJbnRlcnZhbBIfCgtpbnRlcnZhbF9tcxgBIAEoDVIKaW50ZXJ2YWxNcw==');

@$core.Deprecated('Use filterDescriptor instead')
const Filter$json = {
  '1': 'Filter',
  '2': [
    {'1': 'duration_ms', '3': 1, '4': 1, '5': 13, '10': 'durationMs'},
    {
      '1': 'min_sample_interval',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.SampleInterval',
      '10': 'minSampleInterval'
    },
  ],
};

/// Descriptor for `Filter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List filterDescriptor = $convert.base64Decode(
    'CgZGaWx0ZXISHwoLZHVyYXRpb25fbXMYASABKA1SCmR1cmF0aW9uTXMSTAoTbWluX3NhbXBsZV'
    '9pbnRlcnZhbBgCIAEoCzIcLmt1a3NhLnZhbC52Mi5TYW1wbGVJbnRlcnZhbFIRbWluU2FtcGxl'
    'SW50ZXJ2YWw=');

@$core.Deprecated('Use signalIDDescriptor instead')
const SignalID$json = {
  '1': 'SignalID',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '9': 0, '10': 'id'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'path'},
  ],
  '8': [
    {'1': 'signal'},
  ],
};

/// Descriptor for `SignalID`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalIDDescriptor = $convert.base64Decode(
    'CghTaWduYWxJRBIQCgJpZBgBIAEoBUgAUgJpZBIUCgRwYXRoGAIgASgJSABSBHBhdGhCCAoGc2'
    'lnbmFs');

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = {
  '1': 'Error',
  '2': [
    {
      '1': 'code',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.kuksa.val.v2.ErrorCode',
      '10': 'code'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode(
    'CgVFcnJvchIrCgRjb2RlGAEgASgOMhcua3Vrc2EudmFsLnYyLkVycm9yQ29kZVIEY29kZRIYCg'
    'dtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = {
  '1': 'Metadata',
  '2': [
    {'1': 'path', '3': 9, '4': 1, '5': 9, '10': 'path'},
    {'1': 'id', '3': 10, '4': 1, '5': 5, '10': 'id'},
    {
      '1': 'data_type',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.kuksa.val.v2.DataType',
      '10': 'dataType'
    },
    {
      '1': 'entry_type',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.kuksa.val.v2.EntryType',
      '10': 'entryType'
    },
    {'1': 'description', '3': 13, '4': 1, '5': 9, '10': 'description'},
    {'1': 'comment', '3': 14, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'deprecation', '3': 15, '4': 1, '5': 9, '10': 'deprecation'},
    {'1': 'unit', '3': 16, '4': 1, '5': 9, '10': 'unit'},
    {
      '1': 'allowed_values',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Value',
      '10': 'allowedValues'
    },
    {
      '1': 'min',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Value',
      '10': 'min'
    },
    {
      '1': 'max',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Value',
      '10': 'max'
    },
    {
      '1': 'min_sample_interval',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.SampleInterval',
      '10': 'minSampleInterval'
    },
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode(
    'CghNZXRhZGF0YRISCgRwYXRoGAkgASgJUgRwYXRoEg4KAmlkGAogASgFUgJpZBIzCglkYXRhX3'
    'R5cGUYCyABKA4yFi5rdWtzYS52YWwudjIuRGF0YVR5cGVSCGRhdGFUeXBlEjYKCmVudHJ5X3R5'
    'cGUYDCABKA4yFy5rdWtzYS52YWwudjIuRW50cnlUeXBlUgllbnRyeVR5cGUSIAoLZGVzY3JpcH'
    'Rpb24YDSABKAlSC2Rlc2NyaXB0aW9uEhgKB2NvbW1lbnQYDiABKAlSB2NvbW1lbnQSIAoLZGVw'
    'cmVjYXRpb24YDyABKAlSC2RlcHJlY2F0aW9uEhIKBHVuaXQYECABKAlSBHVuaXQSOgoOYWxsb3'
    'dlZF92YWx1ZXMYESABKAsyEy5rdWtzYS52YWwudjIuVmFsdWVSDWFsbG93ZWRWYWx1ZXMSJQoD'
    'bWluGBIgASgLMhMua3Vrc2EudmFsLnYyLlZhbHVlUgNtaW4SJQoDbWF4GBMgASgLMhMua3Vrc2'
    'EudmFsLnYyLlZhbHVlUgNtYXgSTAoTbWluX3NhbXBsZV9pbnRlcnZhbBgUIAEoCzIcLmt1a3Nh'
    'LnZhbC52Mi5TYW1wbGVJbnRlcnZhbFIRbWluU2FtcGxlSW50ZXJ2YWw=');

@$core.Deprecated('Use stringArrayDescriptor instead')
const StringArray$json = {
  '1': 'StringArray',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 9, '10': 'values'},
  ],
};

/// Descriptor for `StringArray`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringArrayDescriptor = $convert
    .base64Decode('CgtTdHJpbmdBcnJheRIWCgZ2YWx1ZXMYASADKAlSBnZhbHVlcw==');

@$core.Deprecated('Use boolArrayDescriptor instead')
const BoolArray$json = {
  '1': 'BoolArray',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 8, '10': 'values'},
  ],
};

/// Descriptor for `BoolArray`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boolArrayDescriptor =
    $convert.base64Decode('CglCb29sQXJyYXkSFgoGdmFsdWVzGAEgAygIUgZ2YWx1ZXM=');

@$core.Deprecated('Use int32ArrayDescriptor instead')
const Int32Array$json = {
  '1': 'Int32Array',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 17, '10': 'values'},
  ],
};

/// Descriptor for `Int32Array`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List int32ArrayDescriptor =
    $convert.base64Decode('CgpJbnQzMkFycmF5EhYKBnZhbHVlcxgBIAMoEVIGdmFsdWVz');

@$core.Deprecated('Use int64ArrayDescriptor instead')
const Int64Array$json = {
  '1': 'Int64Array',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 18, '10': 'values'},
  ],
};

/// Descriptor for `Int64Array`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List int64ArrayDescriptor =
    $convert.base64Decode('CgpJbnQ2NEFycmF5EhYKBnZhbHVlcxgBIAMoElIGdmFsdWVz');

@$core.Deprecated('Use uint32ArrayDescriptor instead')
const Uint32Array$json = {
  '1': 'Uint32Array',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 13, '10': 'values'},
  ],
};

/// Descriptor for `Uint32Array`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uint32ArrayDescriptor = $convert
    .base64Decode('CgtVaW50MzJBcnJheRIWCgZ2YWx1ZXMYASADKA1SBnZhbHVlcw==');

@$core.Deprecated('Use uint64ArrayDescriptor instead')
const Uint64Array$json = {
  '1': 'Uint64Array',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 4, '10': 'values'},
  ],
};

/// Descriptor for `Uint64Array`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uint64ArrayDescriptor = $convert
    .base64Decode('CgtVaW50NjRBcnJheRIWCgZ2YWx1ZXMYASADKARSBnZhbHVlcw==');

@$core.Deprecated('Use floatArrayDescriptor instead')
const FloatArray$json = {
  '1': 'FloatArray',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 2, '10': 'values'},
  ],
};

/// Descriptor for `FloatArray`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List floatArrayDescriptor =
    $convert.base64Decode('CgpGbG9hdEFycmF5EhYKBnZhbHVlcxgBIAMoAlIGdmFsdWVz');

@$core.Deprecated('Use doubleArrayDescriptor instead')
const DoubleArray$json = {
  '1': 'DoubleArray',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 1, '10': 'values'},
  ],
};

/// Descriptor for `DoubleArray`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleArrayDescriptor = $convert
    .base64Decode('CgtEb3VibGVBcnJheRIWCgZ2YWx1ZXMYASADKAFSBnZhbHVlcw==');
