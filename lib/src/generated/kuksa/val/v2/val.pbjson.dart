// This is a generated file - do not edit.
//
// Generated from kuksa/val/v2/val.proto.

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

@$core.Deprecated('Use getValueRequestDescriptor instead')
const GetValueRequest$json = {
  '1': 'GetValueRequest',
  '2': [
    {
      '1': 'signal_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.SignalID',
      '10': 'signalId'
    },
  ],
};

/// Descriptor for `GetValueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getValueRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRWYWx1ZVJlcXVlc3QSMwoJc2lnbmFsX2lkGAEgASgLMhYua3Vrc2EudmFsLnYyLlNpZ2'
    '5hbElEUghzaWduYWxJZA==');

@$core.Deprecated('Use getValueResponseDescriptor instead')
const GetValueResponse$json = {
  '1': 'GetValueResponse',
  '2': [
    {
      '1': 'data_point',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Datapoint',
      '10': 'dataPoint'
    },
  ],
};

/// Descriptor for `GetValueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getValueResponseDescriptor = $convert.base64Decode(
    'ChBHZXRWYWx1ZVJlc3BvbnNlEjYKCmRhdGFfcG9pbnQYASABKAsyFy5rdWtzYS52YWwudjIuRG'
    'F0YXBvaW50UglkYXRhUG9pbnQ=');

@$core.Deprecated('Use getValuesRequestDescriptor instead')
const GetValuesRequest$json = {
  '1': 'GetValuesRequest',
  '2': [
    {
      '1': 'signal_ids',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.SignalID',
      '10': 'signalIds'
    },
  ],
};

/// Descriptor for `GetValuesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getValuesRequestDescriptor = $convert.base64Decode(
    'ChBHZXRWYWx1ZXNSZXF1ZXN0EjUKCnNpZ25hbF9pZHMYASADKAsyFi5rdWtzYS52YWwudjIuU2'
    'lnbmFsSURSCXNpZ25hbElkcw==');

@$core.Deprecated('Use getValuesResponseDescriptor instead')
const GetValuesResponse$json = {
  '1': 'GetValuesResponse',
  '2': [
    {
      '1': 'data_points',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.Datapoint',
      '10': 'dataPoints'
    },
  ],
};

/// Descriptor for `GetValuesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getValuesResponseDescriptor = $convert.base64Decode(
    'ChFHZXRWYWx1ZXNSZXNwb25zZRI4CgtkYXRhX3BvaW50cxgBIAMoCzIXLmt1a3NhLnZhbC52Mi'
    '5EYXRhcG9pbnRSCmRhdGFQb2ludHM=');

@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = {
  '1': 'SubscribeRequest',
  '2': [
    {'1': 'signal_paths', '3': 1, '4': 3, '5': 9, '10': 'signalPaths'},
    {'1': 'buffer_size', '3': 2, '4': 1, '5': 13, '10': 'bufferSize'},
    {
      '1': 'filter',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Filter',
      '10': 'filter'
    },
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpYmVSZXF1ZXN0EiEKDHNpZ25hbF9wYXRocxgBIAMoCVILc2lnbmFsUGF0aHMSHw'
    'oLYnVmZmVyX3NpemUYAiABKA1SCmJ1ZmZlclNpemUSLAoGZmlsdGVyGAMgASgLMhQua3Vrc2Eu'
    'dmFsLnYyLkZpbHRlclIGZmlsdGVy');

@$core.Deprecated('Use subscribeResponseDescriptor instead')
const SubscribeResponse$json = {
  '1': 'SubscribeResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.SubscribeResponse.EntriesEntry',
      '10': 'entries'
    },
  ],
  '3': [SubscribeResponse_EntriesEntry$json],
};

@$core.Deprecated('Use subscribeResponseDescriptor instead')
const SubscribeResponse_EntriesEntry$json = {
  '1': 'EntriesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Datapoint',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `SubscribeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeResponseDescriptor = $convert.base64Decode(
    'ChFTdWJzY3JpYmVSZXNwb25zZRJGCgdlbnRyaWVzGAEgAygLMiwua3Vrc2EudmFsLnYyLlN1Yn'
    'NjcmliZVJlc3BvbnNlLkVudHJpZXNFbnRyeVIHZW50cmllcxpTCgxFbnRyaWVzRW50cnkSEAoD'
    'a2V5GAEgASgJUgNrZXkSLQoFdmFsdWUYAiABKAsyFy5rdWtzYS52YWwudjIuRGF0YXBvaW50Ug'
    'V2YWx1ZToCOAE=');

@$core.Deprecated('Use subscribeByIdRequestDescriptor instead')
const SubscribeByIdRequest$json = {
  '1': 'SubscribeByIdRequest',
  '2': [
    {'1': 'signal_ids', '3': 1, '4': 3, '5': 5, '10': 'signalIds'},
    {'1': 'buffer_size', '3': 2, '4': 1, '5': 13, '10': 'bufferSize'},
    {
      '1': 'filter',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Filter',
      '10': 'filter'
    },
  ],
};

/// Descriptor for `SubscribeByIdRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeByIdRequestDescriptor = $convert.base64Decode(
    'ChRTdWJzY3JpYmVCeUlkUmVxdWVzdBIdCgpzaWduYWxfaWRzGAEgAygFUglzaWduYWxJZHMSHw'
    'oLYnVmZmVyX3NpemUYAiABKA1SCmJ1ZmZlclNpemUSLAoGZmlsdGVyGAMgASgLMhQua3Vrc2Eu'
    'dmFsLnYyLkZpbHRlclIGZmlsdGVy');

@$core.Deprecated('Use subscribeByIdResponseDescriptor instead')
const SubscribeByIdResponse$json = {
  '1': 'SubscribeByIdResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.SubscribeByIdResponse.EntriesEntry',
      '10': 'entries'
    },
  ],
  '3': [SubscribeByIdResponse_EntriesEntry$json],
};

@$core.Deprecated('Use subscribeByIdResponseDescriptor instead')
const SubscribeByIdResponse_EntriesEntry$json = {
  '1': 'EntriesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Datapoint',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `SubscribeByIdResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeByIdResponseDescriptor = $convert.base64Decode(
    'ChVTdWJzY3JpYmVCeUlkUmVzcG9uc2USSgoHZW50cmllcxgBIAMoCzIwLmt1a3NhLnZhbC52Mi'
    '5TdWJzY3JpYmVCeUlkUmVzcG9uc2UuRW50cmllc0VudHJ5UgdlbnRyaWVzGlMKDEVudHJpZXNF'
    'bnRyeRIQCgNrZXkYASABKAVSA2tleRItCgV2YWx1ZRgCIAEoCzIXLmt1a3NhLnZhbC52Mi5EYX'
    'RhcG9pbnRSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use actuateRequestDescriptor instead')
const ActuateRequest$json = {
  '1': 'ActuateRequest',
  '2': [
    {
      '1': 'signal_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.SignalID',
      '10': 'signalId'
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

/// Descriptor for `ActuateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actuateRequestDescriptor = $convert.base64Decode(
    'Cg5BY3R1YXRlUmVxdWVzdBIzCglzaWduYWxfaWQYASABKAsyFi5rdWtzYS52YWwudjIuU2lnbm'
    'FsSURSCHNpZ25hbElkEikKBXZhbHVlGAIgASgLMhMua3Vrc2EudmFsLnYyLlZhbHVlUgV2YWx1'
    'ZQ==');

@$core.Deprecated('Use actuateResponseDescriptor instead')
const ActuateResponse$json = {
  '1': 'ActuateResponse',
};

/// Descriptor for `ActuateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actuateResponseDescriptor =
    $convert.base64Decode('Cg9BY3R1YXRlUmVzcG9uc2U=');

@$core.Deprecated('Use batchActuateRequestDescriptor instead')
const BatchActuateRequest$json = {
  '1': 'BatchActuateRequest',
  '2': [
    {
      '1': 'actuate_requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.ActuateRequest',
      '10': 'actuateRequests'
    },
  ],
};

/// Descriptor for `BatchActuateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchActuateRequestDescriptor = $convert.base64Decode(
    'ChNCYXRjaEFjdHVhdGVSZXF1ZXN0EkcKEGFjdHVhdGVfcmVxdWVzdHMYASADKAsyHC5rdWtzYS'
    '52YWwudjIuQWN0dWF0ZVJlcXVlc3RSD2FjdHVhdGVSZXF1ZXN0cw==');

@$core.Deprecated('Use batchActuateResponseDescriptor instead')
const BatchActuateResponse$json = {
  '1': 'BatchActuateResponse',
};

/// Descriptor for `BatchActuateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchActuateResponseDescriptor =
    $convert.base64Decode('ChRCYXRjaEFjdHVhdGVSZXNwb25zZQ==');

@$core.Deprecated('Use listMetadataRequestDescriptor instead')
const ListMetadataRequest$json = {
  '1': 'ListMetadataRequest',
  '2': [
    {'1': 'root', '3': 1, '4': 1, '5': 9, '10': 'root'},
    {'1': 'filter', '3': 2, '4': 1, '5': 9, '10': 'filter'},
  ],
};

/// Descriptor for `ListMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMetadataRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0TWV0YWRhdGFSZXF1ZXN0EhIKBHJvb3QYASABKAlSBHJvb3QSFgoGZmlsdGVyGAIgAS'
    'gJUgZmaWx0ZXI=');

@$core.Deprecated('Use listMetadataResponseDescriptor instead')
const ListMetadataResponse$json = {
  '1': 'ListMetadataResponse',
  '2': [
    {
      '1': 'metadata',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.Metadata',
      '10': 'metadata'
    },
  ],
};

/// Descriptor for `ListMetadataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMetadataResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0TWV0YWRhdGFSZXNwb25zZRIyCghtZXRhZGF0YRgBIAMoCzIWLmt1a3NhLnZhbC52Mi'
    '5NZXRhZGF0YVIIbWV0YWRhdGE=');

@$core.Deprecated('Use publishValueRequestDescriptor instead')
const PublishValueRequest$json = {
  '1': 'PublishValueRequest',
  '2': [
    {
      '1': 'signal_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.SignalID',
      '10': 'signalId'
    },
    {
      '1': 'data_point',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Datapoint',
      '10': 'dataPoint'
    },
  ],
};

/// Descriptor for `PublishValueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishValueRequestDescriptor = $convert.base64Decode(
    'ChNQdWJsaXNoVmFsdWVSZXF1ZXN0EjMKCXNpZ25hbF9pZBgBIAEoCzIWLmt1a3NhLnZhbC52Mi'
    '5TaWduYWxJRFIIc2lnbmFsSWQSNgoKZGF0YV9wb2ludBgCIAEoCzIXLmt1a3NhLnZhbC52Mi5E'
    'YXRhcG9pbnRSCWRhdGFQb2ludA==');

@$core.Deprecated('Use publishValueResponseDescriptor instead')
const PublishValueResponse$json = {
  '1': 'PublishValueResponse',
};

/// Descriptor for `PublishValueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishValueResponseDescriptor =
    $convert.base64Decode('ChRQdWJsaXNoVmFsdWVSZXNwb25zZQ==');

@$core.Deprecated('Use publishValuesRequestDescriptor instead')
const PublishValuesRequest$json = {
  '1': 'PublishValuesRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 13, '10': 'requestId'},
    {
      '1': 'data_points',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.PublishValuesRequest.DataPointsEntry',
      '10': 'dataPoints'
    },
  ],
  '3': [PublishValuesRequest_DataPointsEntry$json],
};

@$core.Deprecated('Use publishValuesRequestDescriptor instead')
const PublishValuesRequest_DataPointsEntry$json = {
  '1': 'DataPointsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Datapoint',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `PublishValuesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishValuesRequestDescriptor = $convert.base64Decode(
    'ChRQdWJsaXNoVmFsdWVzUmVxdWVzdBIdCgpyZXF1ZXN0X2lkGAEgASgNUglyZXF1ZXN0SWQSUw'
    'oLZGF0YV9wb2ludHMYAiADKAsyMi5rdWtzYS52YWwudjIuUHVibGlzaFZhbHVlc1JlcXVlc3Qu'
    'RGF0YVBvaW50c0VudHJ5UgpkYXRhUG9pbnRzGlYKD0RhdGFQb2ludHNFbnRyeRIQCgNrZXkYAS'
    'ABKAVSA2tleRItCgV2YWx1ZRgCIAEoCzIXLmt1a3NhLnZhbC52Mi5EYXRhcG9pbnRSBXZhbHVl'
    'OgI4AQ==');

@$core.Deprecated('Use publishValuesResponseDescriptor instead')
const PublishValuesResponse$json = {
  '1': 'PublishValuesResponse',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 13, '10': 'requestId'},
    {
      '1': 'status',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.PublishValuesResponse.StatusEntry',
      '10': 'status'
    },
  ],
  '3': [PublishValuesResponse_StatusEntry$json],
};

@$core.Deprecated('Use publishValuesResponseDescriptor instead')
const PublishValuesResponse_StatusEntry$json = {
  '1': 'StatusEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Error',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `PublishValuesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishValuesResponseDescriptor = $convert.base64Decode(
    'ChVQdWJsaXNoVmFsdWVzUmVzcG9uc2USHQoKcmVxdWVzdF9pZBgBIAEoDVIJcmVxdWVzdElkEk'
    'cKBnN0YXR1cxgCIAMoCzIvLmt1a3NhLnZhbC52Mi5QdWJsaXNoVmFsdWVzUmVzcG9uc2UuU3Rh'
    'dHVzRW50cnlSBnN0YXR1cxpOCgtTdGF0dXNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIpCgV2YW'
    'x1ZRgCIAEoCzITLmt1a3NhLnZhbC52Mi5FcnJvclIFdmFsdWU6AjgB');

@$core.Deprecated('Use provideActuationRequestDescriptor instead')
const ProvideActuationRequest$json = {
  '1': 'ProvideActuationRequest',
  '2': [
    {
      '1': 'actuator_identifiers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.SignalID',
      '10': 'actuatorIdentifiers'
    },
  ],
};

/// Descriptor for `ProvideActuationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List provideActuationRequestDescriptor =
    $convert.base64Decode(
        'ChdQcm92aWRlQWN0dWF0aW9uUmVxdWVzdBJJChRhY3R1YXRvcl9pZGVudGlmaWVycxgBIAMoCz'
        'IWLmt1a3NhLnZhbC52Mi5TaWduYWxJRFITYWN0dWF0b3JJZGVudGlmaWVycw==');

@$core.Deprecated('Use provideActuationResponseDescriptor instead')
const ProvideActuationResponse$json = {
  '1': 'ProvideActuationResponse',
};

/// Descriptor for `ProvideActuationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List provideActuationResponseDescriptor =
    $convert.base64Decode('ChhQcm92aWRlQWN0dWF0aW9uUmVzcG9uc2U=');

@$core.Deprecated('Use provideSignalRequestDescriptor instead')
const ProvideSignalRequest$json = {
  '1': 'ProvideSignalRequest',
  '2': [
    {
      '1': 'signals_sample_intervals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.ProvideSignalRequest.SignalsSampleIntervalsEntry',
      '10': 'signalsSampleIntervals'
    },
  ],
  '3': [ProvideSignalRequest_SignalsSampleIntervalsEntry$json],
};

@$core.Deprecated('Use provideSignalRequestDescriptor instead')
const ProvideSignalRequest_SignalsSampleIntervalsEntry$json = {
  '1': 'SignalsSampleIntervalsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.SampleInterval',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `ProvideSignalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List provideSignalRequestDescriptor = $convert.base64Decode(
    'ChRQcm92aWRlU2lnbmFsUmVxdWVzdBJ4ChhzaWduYWxzX3NhbXBsZV9pbnRlcnZhbHMYASADKA'
    'syPi5rdWtzYS52YWwudjIuUHJvdmlkZVNpZ25hbFJlcXVlc3QuU2lnbmFsc1NhbXBsZUludGVy'
    'dmFsc0VudHJ5UhZzaWduYWxzU2FtcGxlSW50ZXJ2YWxzGmcKG1NpZ25hbHNTYW1wbGVJbnRlcn'
    'ZhbHNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIyCgV2YWx1ZRgCIAEoCzIcLmt1a3NhLnZhbC52'
    'Mi5TYW1wbGVJbnRlcnZhbFIFdmFsdWU6AjgB');

@$core.Deprecated('Use provideSignalResponseDescriptor instead')
const ProvideSignalResponse$json = {
  '1': 'ProvideSignalResponse',
};

/// Descriptor for `ProvideSignalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List provideSignalResponseDescriptor =
    $convert.base64Decode('ChVQcm92aWRlU2lnbmFsUmVzcG9uc2U=');

@$core.Deprecated('Use batchActuateStreamRequestDescriptor instead')
const BatchActuateStreamRequest$json = {
  '1': 'BatchActuateStreamRequest',
  '2': [
    {
      '1': 'actuate_requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.ActuateRequest',
      '10': 'actuateRequests'
    },
  ],
};

/// Descriptor for `BatchActuateStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchActuateStreamRequestDescriptor =
    $convert.base64Decode(
        'ChlCYXRjaEFjdHVhdGVTdHJlYW1SZXF1ZXN0EkcKEGFjdHVhdGVfcmVxdWVzdHMYASADKAsyHC'
        '5rdWtzYS52YWwudjIuQWN0dWF0ZVJlcXVlc3RSD2FjdHVhdGVSZXF1ZXN0cw==');

@$core.Deprecated('Use batchActuateStreamResponseDescriptor instead')
const BatchActuateStreamResponse$json = {
  '1': 'BatchActuateStreamResponse',
  '2': [
    {
      '1': 'signal_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.SignalID',
      '10': 'signalId'
    },
    {
      '1': 'error',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Error',
      '10': 'error'
    },
  ],
};

/// Descriptor for `BatchActuateStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchActuateStreamResponseDescriptor =
    $convert.base64Decode(
        'ChpCYXRjaEFjdHVhdGVTdHJlYW1SZXNwb25zZRIzCglzaWduYWxfaWQYASABKAsyFi5rdWtzYS'
        '52YWwudjIuU2lnbmFsSURSCHNpZ25hbElkEikKBWVycm9yGAIgASgLMhMua3Vrc2EudmFsLnYy'
        'LkVycm9yUgVlcnJvcg==');

@$core.Deprecated('Use updateFilterRequestDescriptor instead')
const UpdateFilterRequest$json = {
  '1': 'UpdateFilterRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 13, '10': 'requestId'},
    {
      '1': 'filters_update',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.kuksa.val.v2.UpdateFilterRequest.FiltersUpdateEntry',
      '10': 'filtersUpdate'
    },
  ],
  '3': [UpdateFilterRequest_FiltersUpdateEntry$json],
};

@$core.Deprecated('Use updateFilterRequestDescriptor instead')
const UpdateFilterRequest_FiltersUpdateEntry$json = {
  '1': 'FiltersUpdateEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.Filter',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `UpdateFilterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateFilterRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVGaWx0ZXJSZXF1ZXN0Eh0KCnJlcXVlc3RfaWQYASABKA1SCXJlcXVlc3RJZBJbCg'
    '5maWx0ZXJzX3VwZGF0ZRgCIAMoCzI0Lmt1a3NhLnZhbC52Mi5VcGRhdGVGaWx0ZXJSZXF1ZXN0'
    'LkZpbHRlcnNVcGRhdGVFbnRyeVINZmlsdGVyc1VwZGF0ZRpWChJGaWx0ZXJzVXBkYXRlRW50cn'
    'kSEAoDa2V5GAEgASgFUgNrZXkSKgoFdmFsdWUYAiABKAsyFC5rdWtzYS52YWwudjIuRmlsdGVy'
    'UgV2YWx1ZToCOAE=');

@$core.Deprecated('Use updateFilterResponseDescriptor instead')
const UpdateFilterResponse$json = {
  '1': 'UpdateFilterResponse',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 13, '10': 'requestId'},
    {
      '1': 'filter_error',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.kuksa.val.v2.FilterError',
      '10': 'filterError'
    },
  ],
};

/// Descriptor for `UpdateFilterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateFilterResponseDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVGaWx0ZXJSZXNwb25zZRIdCgpyZXF1ZXN0X2lkGAEgASgNUglyZXF1ZXN0SWQSPA'
    'oMZmlsdGVyX2Vycm9yGAIgASgOMhkua3Vrc2EudmFsLnYyLkZpbHRlckVycm9yUgtmaWx0ZXJF'
    'cnJvcg==');

@$core.Deprecated('Use providerErrorIndicationDescriptor instead')
const ProviderErrorIndication$json = {
  '1': 'ProviderErrorIndication',
  '2': [
    {
      '1': 'provider_error',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.kuksa.val.v2.ProviderError',
      '10': 'providerError'
    },
  ],
};

/// Descriptor for `ProviderErrorIndication`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerErrorIndicationDescriptor =
    $convert.base64Decode(
        'ChdQcm92aWRlckVycm9ySW5kaWNhdGlvbhJCCg5wcm92aWRlcl9lcnJvchgBIAEoDjIbLmt1a3'
        'NhLnZhbC52Mi5Qcm92aWRlckVycm9yUg1wcm92aWRlckVycm9y');

@$core.Deprecated('Use getProviderValueRequestDescriptor instead')
const GetProviderValueRequest$json = {
  '1': 'GetProviderValueRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 13, '10': 'requestId'},
    {
      '1': 'request',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.GetValueRequest',
      '10': 'request'
    },
  ],
};

/// Descriptor for `GetProviderValueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProviderValueRequestDescriptor = $convert.base64Decode(
    'ChdHZXRQcm92aWRlclZhbHVlUmVxdWVzdBIdCgpyZXF1ZXN0X2lkGAEgASgNUglyZXF1ZXN0SW'
    'QSNwoHcmVxdWVzdBgCIAEoCzIdLmt1a3NhLnZhbC52Mi5HZXRWYWx1ZVJlcXVlc3RSB3JlcXVl'
    'c3Q=');

@$core.Deprecated('Use getProviderValueResponseDescriptor instead')
const GetProviderValueResponse$json = {
  '1': 'GetProviderValueResponse',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 13, '10': 'requestId'},
    {
      '1': 'response',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.GetValueResponse',
      '10': 'response'
    },
  ],
};

/// Descriptor for `GetProviderValueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProviderValueResponseDescriptor = $convert.base64Decode(
    'ChhHZXRQcm92aWRlclZhbHVlUmVzcG9uc2USHQoKcmVxdWVzdF9pZBgBIAEoDVIJcmVxdWVzdE'
    'lkEjoKCHJlc3BvbnNlGAIgASgLMh4ua3Vrc2EudmFsLnYyLkdldFZhbHVlUmVzcG9uc2VSCHJl'
    'c3BvbnNl');

@$core.Deprecated('Use openProviderStreamRequestDescriptor instead')
const OpenProviderStreamRequest$json = {
  '1': 'OpenProviderStreamRequest',
  '2': [
    {
      '1': 'provide_actuation_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.ProvideActuationRequest',
      '9': 0,
      '10': 'provideActuationRequest'
    },
    {
      '1': 'publish_values_request',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.PublishValuesRequest',
      '9': 0,
      '10': 'publishValuesRequest'
    },
    {
      '1': 'batch_actuate_stream_response',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.BatchActuateStreamResponse',
      '9': 0,
      '10': 'batchActuateStreamResponse'
    },
    {
      '1': 'provide_signal_request',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.ProvideSignalRequest',
      '9': 0,
      '10': 'provideSignalRequest'
    },
    {
      '1': 'update_filter_response',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.UpdateFilterResponse',
      '9': 0,
      '10': 'updateFilterResponse'
    },
    {
      '1': 'get_provider_value_response',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.GetProviderValueResponse',
      '9': 0,
      '10': 'getProviderValueResponse'
    },
    {
      '1': 'provider_error_indication',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.ProviderErrorIndication',
      '9': 0,
      '10': 'providerErrorIndication'
    },
  ],
  '8': [
    {'1': 'action'},
  ],
};

/// Descriptor for `OpenProviderStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openProviderStreamRequestDescriptor = $convert.base64Decode(
    'ChlPcGVuUHJvdmlkZXJTdHJlYW1SZXF1ZXN0EmMKGXByb3ZpZGVfYWN0dWF0aW9uX3JlcXVlc3'
    'QYASABKAsyJS5rdWtzYS52YWwudjIuUHJvdmlkZUFjdHVhdGlvblJlcXVlc3RIAFIXcHJvdmlk'
    'ZUFjdHVhdGlvblJlcXVlc3QSWgoWcHVibGlzaF92YWx1ZXNfcmVxdWVzdBgCIAEoCzIiLmt1a3'
    'NhLnZhbC52Mi5QdWJsaXNoVmFsdWVzUmVxdWVzdEgAUhRwdWJsaXNoVmFsdWVzUmVxdWVzdBJt'
    'Ch1iYXRjaF9hY3R1YXRlX3N0cmVhbV9yZXNwb25zZRgDIAEoCzIoLmt1a3NhLnZhbC52Mi5CYX'
    'RjaEFjdHVhdGVTdHJlYW1SZXNwb25zZUgAUhpiYXRjaEFjdHVhdGVTdHJlYW1SZXNwb25zZRJa'
    'ChZwcm92aWRlX3NpZ25hbF9yZXF1ZXN0GAQgASgLMiIua3Vrc2EudmFsLnYyLlByb3ZpZGVTaW'
    'duYWxSZXF1ZXN0SABSFHByb3ZpZGVTaWduYWxSZXF1ZXN0EloKFnVwZGF0ZV9maWx0ZXJfcmVz'
    'cG9uc2UYBSABKAsyIi5rdWtzYS52YWwudjIuVXBkYXRlRmlsdGVyUmVzcG9uc2VIAFIUdXBkYX'
    'RlRmlsdGVyUmVzcG9uc2USZwobZ2V0X3Byb3ZpZGVyX3ZhbHVlX3Jlc3BvbnNlGAYgASgLMiYu'
    'a3Vrc2EudmFsLnYyLkdldFByb3ZpZGVyVmFsdWVSZXNwb25zZUgAUhhnZXRQcm92aWRlclZhbH'
    'VlUmVzcG9uc2USYwoZcHJvdmlkZXJfZXJyb3JfaW5kaWNhdGlvbhgHIAEoCzIlLmt1a3NhLnZh'
    'bC52Mi5Qcm92aWRlckVycm9ySW5kaWNhdGlvbkgAUhdwcm92aWRlckVycm9ySW5kaWNhdGlvbk'
    'IICgZhY3Rpb24=');

@$core.Deprecated('Use openProviderStreamResponseDescriptor instead')
const OpenProviderStreamResponse$json = {
  '1': 'OpenProviderStreamResponse',
  '2': [
    {
      '1': 'provide_actuation_response',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.ProvideActuationResponse',
      '9': 0,
      '10': 'provideActuationResponse'
    },
    {
      '1': 'publish_values_response',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.PublishValuesResponse',
      '9': 0,
      '10': 'publishValuesResponse'
    },
    {
      '1': 'batch_actuate_stream_request',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.BatchActuateStreamRequest',
      '9': 0,
      '10': 'batchActuateStreamRequest'
    },
    {
      '1': 'provide_signal_response',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.ProvideSignalResponse',
      '9': 0,
      '10': 'provideSignalResponse'
    },
    {
      '1': 'update_filter_request',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.UpdateFilterRequest',
      '9': 0,
      '10': 'updateFilterRequest'
    },
    {
      '1': 'get_provider_value_request',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.kuksa.val.v2.GetProviderValueRequest',
      '9': 0,
      '10': 'getProviderValueRequest'
    },
  ],
  '8': [
    {'1': 'action'},
  ],
};

/// Descriptor for `OpenProviderStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openProviderStreamResponseDescriptor = $convert.base64Decode(
    'ChpPcGVuUHJvdmlkZXJTdHJlYW1SZXNwb25zZRJmChpwcm92aWRlX2FjdHVhdGlvbl9yZXNwb2'
    '5zZRgBIAEoCzImLmt1a3NhLnZhbC52Mi5Qcm92aWRlQWN0dWF0aW9uUmVzcG9uc2VIAFIYcHJv'
    'dmlkZUFjdHVhdGlvblJlc3BvbnNlEl0KF3B1Ymxpc2hfdmFsdWVzX3Jlc3BvbnNlGAIgASgLMi'
    'Mua3Vrc2EudmFsLnYyLlB1Ymxpc2hWYWx1ZXNSZXNwb25zZUgAUhVwdWJsaXNoVmFsdWVzUmVz'
    'cG9uc2USagocYmF0Y2hfYWN0dWF0ZV9zdHJlYW1fcmVxdWVzdBgDIAEoCzInLmt1a3NhLnZhbC'
    '52Mi5CYXRjaEFjdHVhdGVTdHJlYW1SZXF1ZXN0SABSGWJhdGNoQWN0dWF0ZVN0cmVhbVJlcXVl'
    'c3QSXQoXcHJvdmlkZV9zaWduYWxfcmVzcG9uc2UYBCABKAsyIy5rdWtzYS52YWwudjIuUHJvdm'
    'lkZVNpZ25hbFJlc3BvbnNlSABSFXByb3ZpZGVTaWduYWxSZXNwb25zZRJXChV1cGRhdGVfZmls'
    'dGVyX3JlcXVlc3QYBSABKAsyIS5rdWtzYS52YWwudjIuVXBkYXRlRmlsdGVyUmVxdWVzdEgAUh'
    'N1cGRhdGVGaWx0ZXJSZXF1ZXN0EmQKGmdldF9wcm92aWRlcl92YWx1ZV9yZXF1ZXN0GAYgASgL'
    'MiUua3Vrc2EudmFsLnYyLkdldFByb3ZpZGVyVmFsdWVSZXF1ZXN0SABSF2dldFByb3ZpZGVyVm'
    'FsdWVSZXF1ZXN0QggKBmFjdGlvbg==');

@$core.Deprecated('Use getServerInfoRequestDescriptor instead')
const GetServerInfoRequest$json = {
  '1': 'GetServerInfoRequest',
};

/// Descriptor for `GetServerInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServerInfoRequestDescriptor =
    $convert.base64Decode('ChRHZXRTZXJ2ZXJJbmZvUmVxdWVzdA==');

@$core.Deprecated('Use getServerInfoResponseDescriptor instead')
const GetServerInfoResponse$json = {
  '1': 'GetServerInfoResponse',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'commit_hash', '3': 3, '4': 1, '5': 9, '10': 'commitHash'},
  ],
};

/// Descriptor for `GetServerInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServerInfoResponseDescriptor = $convert.base64Decode(
    'ChVHZXRTZXJ2ZXJJbmZvUmVzcG9uc2USEgoEbmFtZRgBIAEoCVIEbmFtZRIYCgd2ZXJzaW9uGA'
    'IgASgJUgd2ZXJzaW9uEh8KC2NvbW1pdF9oYXNoGAMgASgJUgpjb21taXRIYXNo');
