// This is a generated file - do not edit.
//
// Generated from kuksa/val/v2/val.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'val.pb.dart' as $0;

export 'val.pb.dart';

@$pb.GrpcServiceName('kuksa.val.v2.VAL')
class VALClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  VALClient(super.channel, {super.options, super.interceptors});

  /// Get the latest value of a signal
  /// If the signal exist but does not have a valid value
  /// a DataPoint where value is None shall be returned.
  ///
  /// Returns (GRPC error code):
  ///   NOT_FOUND if the requested signal doesn't exist
  ///   UNAUTHENTICATED if no credentials provided or credentials has expired
  ///   PERMISSION_DENIED if access is denied
  ///   INVALID_ARGUMENT if the request is empty or provided path is too long
  ///     - MAX_REQUEST_PATH_LENGTH: usize = 1000;
  $grpc.ResponseFuture<$0.GetValueResponse> getValue(
    $0.GetValueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getValue, request, options: options);
  }

  /// Get the latest values of a set of signals.
  /// The returned list of data points has the same order as the list of the request.
  /// If a requested signal has no value a DataPoint where value is None will be returned.
  ///
  /// Returns (GRPC error code):
  ///   NOT_FOUND if any of the requested signals doesn't exist.
  ///   UNAUTHENTICATED if no credentials provided or credentials has expired
  ///   PERMISSION_DENIED if access is denied for any of the requested signals.
  ///   INVALID_ARGUMENT if the request is empty or provided path is too long
  ///     - MAX_REQUEST_PATH_LENGTH: usize = 1000;
  $grpc.ResponseFuture<$0.GetValuesResponse> getValues(
    $0.GetValuesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getValues, request, options: options);
  }

  /// Subscribe to a set of signals using string path parameters
  /// Returns (GRPC error code):
  ///   NOT_FOUND if any of the signals are non-existant.
  ///   UNAUTHENTICATED if no credentials provided or credentials has expired
  ///   PERMISSION_DENIED if access is denied for any of the signals.
  ///   INVALID_ARGUMENT
  ///     - if the request is empty or provided path is too long
  ///       MAX_REQUEST_PATH_LENGTH: usize = 1000;
  ///     - if buffer_size exceeds the maximum permitted
  ///       MAX_BUFFER_SIZE: usize = 1000;
  ///
  /// When subscribing, Databroker shall immediately return the value for all
  /// subscribed entries.
  /// If a value isn't available when subscribing to a it, it should return None
  ///
  /// If a subscriber is slow to consume signals, messages will be buffered up
  /// to the specified buffer_size before the oldest messages are dropped.
  $grpc.ResponseStream<$0.SubscribeResponse> subscribe(
    $0.SubscribeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribe, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Subscribe to a set of signals using i32 id parameters
  /// Returns (GRPC error code):
  ///   NOT_FOUND if any of the signals are non-existant.
  ///   UNAUTHENTICATED if no credentials provided or credentials has expired
  ///   PERMISSION_DENIED if access is denied for any of the signals.
  ///   INVALID_ARGUMENT
  ///     - if the request is empty or provided path is too long
  ///       MAX_REQUEST_PATH_LENGTH: usize = 1000;
  ///     - if buffer_size exceeds the maximum permitted
  ///       MAX_BUFFER_SIZE: usize = 1000;
  ///
  /// When subscribing, Databroker shall immediately return the value for all
  /// subscribed entries.
  /// If a value isn't available when subscribing to a it, it should return None
  ///
  /// If a subscriber is slow to consume signals, messages will be buffered up
  /// to the specified buffer_size before the oldest messages are dropped.
  $grpc.ResponseStream<$0.SubscribeByIdResponse> subscribeById(
    $0.SubscribeByIdRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribeById, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Actuate a single actuator
  ///
  /// Returns (GRPC error code):
  ///   NOT_FOUND if the actuator does not exist.
  ///   PERMISSION_DENIED if access is denied for the actuator.
  ///   UNAUTHENTICATED if no credentials provided or credentials has expired
  ///   UNAVAILABLE if there is no provider currently providing the actuator
  ///   DATA_LOSS is there is a internal TransmissionFailure
  ///   INVALID_ARGUMENT
  ///     - if the provided path is not an actuator.
  ///     - if the data type used in the request does not match
  ///       the data type of the addressed signal
  ///     - if the requested value is not accepted,
  ///       e.g. if sending an unsupported enum value
  ///     - if the provided value is out of the min/max range specified
  $grpc.ResponseFuture<$0.ActuateResponse> actuate(
    $0.ActuateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$actuate, request, options: options);
  }

  /// Actuate a single actuator in a gRPC stream -> Use for low latency and high throughput
  ///
  /// Returns (GRPC error code):
  ///   NOT_FOUND if the actuator does not exist.
  ///   PERMISSION_DENIED if access is denied for the actuator.
  ///   UNAUTHENTICATED if no credentials provided or credentials has expired
  ///   UNAVAILABLE if there is no provider currently providing the actuator
  ///   DATA_LOSS is there is a internal TransmissionFailure
  ///   INVALID_ARGUMENT
  ///     - if the provided path is not an actuator.
  ///     - if the data type used in the request does not match
  ///       the data type of the addressed signal
  ///     - if the requested value is not accepted,
  ///       e.g. if sending an unsupported enum value
  ///     - if the provided value is out of the min/max range specified
  $grpc.ResponseFuture<$0.ActuateResponse> actuateStream(
    $async.Stream<$0.ActuateRequest> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$actuateStream, request, options: options)
        .single;
  }

  /// Actuate simultaneously multiple actuators.
  /// If any error occurs, the entire operation will be aborted
  /// and no single actuator value will be forwarded to the provider.
  ///
  /// Returns (GRPC error code):
  ///   NOT_FOUND if any of the actuators are non-existant.
  ///   PERMISSION_DENIED if access is denied for any of the actuators.
  ///   UNAUTHENTICATED if no credentials provided or credentials has expired
  ///   UNAVAILABLE if there is no provider currently providing an actuator
  ///   DATA_LOSS is there is a internal TransmissionFailure
  ///   INVALID_ARGUMENT
  ///     - if any of the provided path is not an actuator.
  ///     - if the data type used in the request does not match
  ///       the data type of the addressed signal
  ///     - if the requested value is not accepted,
  ///       e.g. if sending an unsupported enum value
  ///     - if any of the provided actuators values are out of the min/max range specified
  $grpc.ResponseFuture<$0.BatchActuateResponse> batchActuate(
    $0.BatchActuateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$batchActuate, request, options: options);
  }

  /// List metadata of signals matching the request.
  ///
  /// Returns (GRPC error code):
  ///   NOT_FOUND if the specified root branch does not exist.
  ///   UNAUTHENTICATED if no credentials provided or credentials has expired
  ///   INVALID_ARGUMENT if the provided path or wildcard is wrong.
  $grpc.ResponseFuture<$0.ListMetadataResponse> listMetadata(
    $0.ListMetadataRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMetadata, request, options: options);
  }

  /// Publish a signal value. Used for low frequency signals (e.g. attributes).
  ///
  /// Returns (GRPC error code):
  ///   NOT_FOUND if any of the signals are non-existant.
  ///   PERMISSION_DENIED
  ///     - if access is denied for any of the signals.
  ///   UNAUTHENTICATED if no credentials provided or credentials has expired
  ///   INVALID_ARGUMENT
  ///     - if the data type used in the request does not match
  ///       the data type of the addressed signal
  ///     - if the published value is not accepted,
  ///       e.g. if sending an unsupported enum value
  ///     - if the published value is out of the min/max range specified
  $grpc.ResponseFuture<$0.PublishValueResponse> publishValue(
    $0.PublishValueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$publishValue, request, options: options);
  }

  /// Open a stream used to provide actuation and/or publishing values using
  /// a streaming interface. Used to provide actuators and to enable high frequency
  /// updates of values.
  ///
  /// The open stream is used for request / response type communication between the
  /// provider and server (where the initiator of a request can vary).
  ///
  /// Errors:
  ///  - Provider sends ProvideActuationRequest -> Databroker returns ProvideActuationResponse.
  ///    Possible gRPC error codes:
  ///    - NOT_FOUND if any of the signals do not exist.
  ///    - PERMISSION_DENIED if access is denied for any of the signals.
  ///    - UNAUTHENTICATED if no credentials are provided or if they have expired.
  ///    - ALREADY_EXISTS if a provider already claimed ownership of an actuator.
  ///
  ///  - Provider sends PublishValuesRequest -> Databroker returns PublishValuesResponse
  ///    upon error, and nothing upon success. Errors are returned as messages in the
  ///    stream response with signal id `map<int32, Error> status = 2;` (permissive case).
  ///    Possible error codes:
  ///    - NOT_FOUND if a signal does not exist.
  ///    - PERMISSION_DENIED if access is denied for a signal.
  ///    - INVALID_ARGUMENT if:
  ///      - The data type used in the request does not match the signal's data type.
  ///      - The published value is unsupported (e.g., sending an invalid enum value).
  ///      - The published value is out of the specified min/max range.
  ///
  ///  - Databroker sends BatchActuateStreamRequest -> Provider must return
  ///    BatchActuateStreamResponse for each requested signal to indicate acceptance or rejection.
  ///    It is up to the provider to decide if the stream shall be closed. The databroker
  ///    will not react to the received error message.
  ///
  ///  - Provider sends ProvideSignalRequest -> Databroker returns ProvideSignalResponse.
  ///    Possible gRPC error codes:
  ///    - NOT_FOUND if any signals do not exist.
  ///    - PERMISSION_DENIED if access is denied for any of the signals.
  ///    - UNAUTHENTICATED if no credentials are provided or if they have expired.
  ///    - ALREADY_EXISTS if a provider has already claimed ownership of any signal.
  $grpc.ResponseStream<$0.OpenProviderStreamResponse> openProviderStream(
    $async.Stream<$0.OpenProviderStreamRequest> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$openProviderStream, request,
        options: options);
  }

  /// Get server information
  $grpc.ResponseFuture<$0.GetServerInfoResponse> getServerInfo(
    $0.GetServerInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getServerInfo, request, options: options);
  }

  // method descriptors

  static final _$getValue =
      $grpc.ClientMethod<$0.GetValueRequest, $0.GetValueResponse>(
          '/kuksa.val.v2.VAL/GetValue',
          ($0.GetValueRequest value) => value.writeToBuffer(),
          $0.GetValueResponse.fromBuffer);
  static final _$getValues =
      $grpc.ClientMethod<$0.GetValuesRequest, $0.GetValuesResponse>(
          '/kuksa.val.v2.VAL/GetValues',
          ($0.GetValuesRequest value) => value.writeToBuffer(),
          $0.GetValuesResponse.fromBuffer);
  static final _$subscribe =
      $grpc.ClientMethod<$0.SubscribeRequest, $0.SubscribeResponse>(
          '/kuksa.val.v2.VAL/Subscribe',
          ($0.SubscribeRequest value) => value.writeToBuffer(),
          $0.SubscribeResponse.fromBuffer);
  static final _$subscribeById =
      $grpc.ClientMethod<$0.SubscribeByIdRequest, $0.SubscribeByIdResponse>(
          '/kuksa.val.v2.VAL/SubscribeById',
          ($0.SubscribeByIdRequest value) => value.writeToBuffer(),
          $0.SubscribeByIdResponse.fromBuffer);
  static final _$actuate =
      $grpc.ClientMethod<$0.ActuateRequest, $0.ActuateResponse>(
          '/kuksa.val.v2.VAL/Actuate',
          ($0.ActuateRequest value) => value.writeToBuffer(),
          $0.ActuateResponse.fromBuffer);
  static final _$actuateStream =
      $grpc.ClientMethod<$0.ActuateRequest, $0.ActuateResponse>(
          '/kuksa.val.v2.VAL/ActuateStream',
          ($0.ActuateRequest value) => value.writeToBuffer(),
          $0.ActuateResponse.fromBuffer);
  static final _$batchActuate =
      $grpc.ClientMethod<$0.BatchActuateRequest, $0.BatchActuateResponse>(
          '/kuksa.val.v2.VAL/BatchActuate',
          ($0.BatchActuateRequest value) => value.writeToBuffer(),
          $0.BatchActuateResponse.fromBuffer);
  static final _$listMetadata =
      $grpc.ClientMethod<$0.ListMetadataRequest, $0.ListMetadataResponse>(
          '/kuksa.val.v2.VAL/ListMetadata',
          ($0.ListMetadataRequest value) => value.writeToBuffer(),
          $0.ListMetadataResponse.fromBuffer);
  static final _$publishValue =
      $grpc.ClientMethod<$0.PublishValueRequest, $0.PublishValueResponse>(
          '/kuksa.val.v2.VAL/PublishValue',
          ($0.PublishValueRequest value) => value.writeToBuffer(),
          $0.PublishValueResponse.fromBuffer);
  static final _$openProviderStream = $grpc.ClientMethod<
          $0.OpenProviderStreamRequest, $0.OpenProviderStreamResponse>(
      '/kuksa.val.v2.VAL/OpenProviderStream',
      ($0.OpenProviderStreamRequest value) => value.writeToBuffer(),
      $0.OpenProviderStreamResponse.fromBuffer);
  static final _$getServerInfo =
      $grpc.ClientMethod<$0.GetServerInfoRequest, $0.GetServerInfoResponse>(
          '/kuksa.val.v2.VAL/GetServerInfo',
          ($0.GetServerInfoRequest value) => value.writeToBuffer(),
          $0.GetServerInfoResponse.fromBuffer);
}

@$pb.GrpcServiceName('kuksa.val.v2.VAL')
abstract class VALServiceBase extends $grpc.Service {
  $core.String get $name => 'kuksa.val.v2.VAL';

  VALServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetValueRequest, $0.GetValueResponse>(
        'GetValue',
        getValue_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetValueRequest.fromBuffer(value),
        ($0.GetValueResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetValuesRequest, $0.GetValuesResponse>(
        'GetValues',
        getValues_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetValuesRequest.fromBuffer(value),
        ($0.GetValuesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.SubscribeResponse>(
        'Subscribe',
        subscribe_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.SubscribeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SubscribeByIdRequest, $0.SubscribeByIdResponse>(
            'SubscribeById',
            subscribeById_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.SubscribeByIdRequest.fromBuffer(value),
            ($0.SubscribeByIdResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ActuateRequest, $0.ActuateResponse>(
        'Actuate',
        actuate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ActuateRequest.fromBuffer(value),
        ($0.ActuateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ActuateRequest, $0.ActuateResponse>(
        'ActuateStream',
        actuateStream,
        true,
        false,
        ($core.List<$core.int> value) => $0.ActuateRequest.fromBuffer(value),
        ($0.ActuateResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.BatchActuateRequest, $0.BatchActuateResponse>(
            'BatchActuate',
            batchActuate_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.BatchActuateRequest.fromBuffer(value),
            ($0.BatchActuateResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListMetadataRequest, $0.ListMetadataResponse>(
            'ListMetadata',
            listMetadata_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListMetadataRequest.fromBuffer(value),
            ($0.ListMetadataResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PublishValueRequest, $0.PublishValueResponse>(
            'PublishValue',
            publishValue_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PublishValueRequest.fromBuffer(value),
            ($0.PublishValueResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OpenProviderStreamRequest,
            $0.OpenProviderStreamResponse>(
        'OpenProviderStream',
        openProviderStream,
        true,
        true,
        ($core.List<$core.int> value) =>
            $0.OpenProviderStreamRequest.fromBuffer(value),
        ($0.OpenProviderStreamResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetServerInfoRequest, $0.GetServerInfoResponse>(
            'GetServerInfo',
            getServerInfo_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetServerInfoRequest.fromBuffer(value),
            ($0.GetServerInfoResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetValueResponse> getValue_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetValueRequest> $request) async {
    return getValue($call, await $request);
  }

  $async.Future<$0.GetValueResponse> getValue(
      $grpc.ServiceCall call, $0.GetValueRequest request);

  $async.Future<$0.GetValuesResponse> getValues_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetValuesRequest> $request) async {
    return getValues($call, await $request);
  }

  $async.Future<$0.GetValuesResponse> getValues(
      $grpc.ServiceCall call, $0.GetValuesRequest request);

  $async.Stream<$0.SubscribeResponse> subscribe_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeRequest> $request) async* {
    yield* subscribe($call, await $request);
  }

  $async.Stream<$0.SubscribeResponse> subscribe(
      $grpc.ServiceCall call, $0.SubscribeRequest request);

  $async.Stream<$0.SubscribeByIdResponse> subscribeById_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SubscribeByIdRequest> $request) async* {
    yield* subscribeById($call, await $request);
  }

  $async.Stream<$0.SubscribeByIdResponse> subscribeById(
      $grpc.ServiceCall call, $0.SubscribeByIdRequest request);

  $async.Future<$0.ActuateResponse> actuate_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ActuateRequest> $request) async {
    return actuate($call, await $request);
  }

  $async.Future<$0.ActuateResponse> actuate(
      $grpc.ServiceCall call, $0.ActuateRequest request);

  $async.Future<$0.ActuateResponse> actuateStream(
      $grpc.ServiceCall call, $async.Stream<$0.ActuateRequest> request);

  $async.Future<$0.BatchActuateResponse> batchActuate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BatchActuateRequest> $request) async {
    return batchActuate($call, await $request);
  }

  $async.Future<$0.BatchActuateResponse> batchActuate(
      $grpc.ServiceCall call, $0.BatchActuateRequest request);

  $async.Future<$0.ListMetadataResponse> listMetadata_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListMetadataRequest> $request) async {
    return listMetadata($call, await $request);
  }

  $async.Future<$0.ListMetadataResponse> listMetadata(
      $grpc.ServiceCall call, $0.ListMetadataRequest request);

  $async.Future<$0.PublishValueResponse> publishValue_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PublishValueRequest> $request) async {
    return publishValue($call, await $request);
  }

  $async.Future<$0.PublishValueResponse> publishValue(
      $grpc.ServiceCall call, $0.PublishValueRequest request);

  $async.Stream<$0.OpenProviderStreamResponse> openProviderStream(
      $grpc.ServiceCall call,
      $async.Stream<$0.OpenProviderStreamRequest> request);

  $async.Future<$0.GetServerInfoResponse> getServerInfo_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetServerInfoRequest> $request) async {
    return getServerInfo($call, await $request);
  }

  $async.Future<$0.GetServerInfoResponse> getServerInfo(
      $grpc.ServiceCall call, $0.GetServerInfoRequest request);
}
