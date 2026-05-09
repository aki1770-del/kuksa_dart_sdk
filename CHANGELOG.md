## 0.2.0

- Add `SPDX-License-Identifier: Apache-2.0` header to `LICENSE` so pana
  recognizes the package as Apache-2.0 rather than `license:unknown`
  (recovers ~30 pub-points on the licensing axis).
- Update `homepage`, `repository`, and `issue_tracker` URLs in `pubspec.yaml`
  from `aki1770/kuksa_dart_sdk` to the canonical `aki1770-del/kuksa_dart_sdk`
  (the `aki1770/` URL had returned HTTP 404).
- Fix `example/snow_safety_monitor.dart`: `info.commit` → `info.commitHash`
  (the generated protobuf getter is `commitHash`, mapping the `commit_hash`
  field). One-character fix surfaced by `dart analyze` during 0.2.0
  preparation; pre-existing in 0.1.0.
- Otherwise mechanical metadata fix only; no SDK source changes.

## 0.1.0

- Initial release.
- `KuksaClient`: gRPC client for the `kuksa.val.v2` VAL API.
- `Datapoint`: typed wrapper over protobuf `Datapoint` with per-type accessors.
- Snow-safety signal constants (`kRoadFrictionMostProbable`, `kTcsIsEngaged`, `kAbsIsEngaged`, `kSnowSafetySignals`, and more).
- Support for insecure and TLS-secured connections, optional JWT authentication.
- Generated stubs from `eclipse-kuksa/kuksa-proto` v2 (`kuksa.val.v2`).
