# `proto/` — the vendored gRPC contract

**These are copies. `eclipse-kuksa/kuksa-proto` is the source.**

| field | value |
|---|---|
| upstream | `https://github.com/eclipse-kuksa/kuksa-proto` |
| pinned ref | see `UPSTREAM_REF` (40-char sha) |
| drift detector | `tool/proto_sync.sh` — CI job `proto-contract-drift` |
| generator | `tool/generate_protos.sh` → `lib/src/generated/` |

## Why a vendored copy exists at all

`lib/src/generated/` is checked-in `protoc` output. Every file says only
*"Generated from kuksa/val/v2/val.proto"* — **no ref, no sha, no date.** So the
question *"do our stubs still match the contract the databroker serves?"* had no
answer in this repository. It has one now: the contract is vendored, pinned, and
diffed on every CI run.

**This became acute on 2026-08-24**, when `kuksa-databroker` moved its protos out
of the server repo and into this standalone, independently versioned one. **The
contract can now move without the server moving.**

## The bound, stated so a green run is not over-read

`proto_sync.sh` proves the **vendored `.proto` files match upstream**. It does
**not** prove `lib/src/generated/` was regenerated from them. *Contract drift* and
*stub staleness* are two different failures; this guard catches the first. Run
`tool/generate_protos.sh` for the second.

**An unreachable upstream exits 2 and reports UNVERIFIED — it is never reported as
clean.** A guard that turns "could not check" into "no drift" is the failure mode
the guard exists to prevent.
