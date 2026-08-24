// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0
//
// The OTHER half of the proto guard, and the two are deliberately separate.
//
//   tool/proto_sync.sh  proves proto/ matches eclipse-kuksa/kuksa-proto.
//   THIS TEST           proves lib/src/generated/ matches proto/.
//
// Contract drift and stub staleness are different failures. A repo can pass the
// first and fail the second: someone re-vendors an updated contract, forgets
// `tool/generate_protos.sh`, and the stubs silently describe a protocol the
// server no longer speaks. That is not a compile error — it is a runtime
// deserialization failure, in a vehicle, on a signal a driver's warning depends
// on. `proto/README.md` names this gap; this file closes it.
//
// It reads the vendored .proto as TEXT rather than importing anything, because
// the point is to compare two artifacts that are supposed to agree and that
// nothing else forces to agree.
@TestOn('vm')
library;

import 'dart:io';

import 'package:test/test.dart';

/// Every `rpc Name(` declared in the vendored val.v2 service contract.
Set<String> _contractRpcs() {
  final proto = File('proto/kuksa/val/v2/val.proto').readAsStringSync();
  return RegExp(r'^\s*rpc\s+(\w+)', multiLine: true)
      .allMatches(proto)
      .map((m) => m.group(1)!)
      .toSet();
}

/// Every method path baked into the generated gRPC client.
Set<String> _generatedRpcs() {
  final stub =
      File('lib/src/generated/kuksa/val/v2/val.pbgrpc.dart').readAsStringSync();
  return RegExp(r"'/kuksa\.val\.v2\.VAL/(\w+)'")
      .allMatches(stub)
      .map((m) => m.group(1)!)
      .toSet();
}

void main() {
  group('generated stubs match the vendored contract', () {
    test('precondition: both artifacts are present and non-trivial', () {
      expect(_contractRpcs(), isNotEmpty,
          reason: 'proto/kuksa/val/v2/val.proto declares no rpc — the vendored '
              'contract is missing or unreadable, and every assertion below '
              'would pass vacuously');
      expect(_generatedRpcs(), isNotEmpty,
          reason: 'the generated stub exposes no VAL method path');
    });

    test('no RPC in the contract is missing from the stubs', () {
      final missing = _contractRpcs().difference(_generatedRpcs());
      expect(
        missing,
        isEmpty,
        reason: 'the databroker serves these and this client cannot call them. '
            'The contract moved and lib/src/generated/ did not: run '
            'tool/generate_protos.sh. Missing: $missing',
      );
    });

    test('no RPC in the stubs is absent from the contract', () {
      final extra = _generatedRpcs().difference(_contractRpcs());
      expect(
        extra,
        isEmpty,
        reason: 'this client would call methods the contract no longer '
            'declares — a removed RPC is an UNIMPLEMENTED at runtime, not a '
            'compile error. Extra: $extra',
      );
    });
  });
}
