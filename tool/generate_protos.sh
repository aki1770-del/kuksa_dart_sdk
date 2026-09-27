#!/usr/bin/env bash
# Regenerate Dart protobuf stubs from the KUKSA proto definitions.
#
# Proto source: eclipse-kuksa/kuksa-proto (standalone canonical proto repo)
#   git clone https://github.com/eclipse-kuksa/kuksa-proto ../kuksa-proto
#
# Prerequisites:
#   dart pub global activate protoc_plugin
#   brew install protobuf  # or equivalent (apt: protobuf-compiler)
#
# Run from the kuksa_dart_sdk root directory.

set -euo pipefail

# kuksa-proto is the canonical standalone proto repo (eclipse-kuksa/kuksa-proto)
# NOT embedded in kuksa-databroker (that repo also has a proto/ dir but
# kuksa-proto is the authoritative source for Dart codegen)
PROTO_SRC="${1:-../kuksa-proto}"
OUT_DIR="lib/src/generated"

# Pinned upstream commit. This is what the generated stubs in $OUT_DIR were
# last verified against (kuksa/val/v2/{types,val}.proto byte-diffed against
# this exact SHA, 2026-09-27 — see CHANGELOG.md). Without this pin, "regenerate
# the protos" silently means "regenerate against whatever main happens to be
# today", and drift becomes invisible until something breaks at runtime.
# Update this SHA — deliberately, in its own commit — when you intend to move
# to a newer upstream proto revision, not as a side effect of running this
# script against a stale local clone.
PROTO_REF="28bf76ae57085dad425eedd95bc7bd442e1314a7"

if [ ! -d "$PROTO_SRC/kuksa/val/v2" ]; then
  echo "ERROR: Proto source not found at $PROTO_SRC/kuksa/val/v2"
  echo "Clone the canonical proto repo first:"
  echo "  git clone https://github.com/eclipse-kuksa/kuksa-proto ../kuksa-proto"
  echo "  git -C ../kuksa-proto checkout $PROTO_REF"
  echo "Usage: $0 [path/to/kuksa-proto]"
  exit 1
fi

if [ -d "$PROTO_SRC/.git" ]; then
  ACTUAL_REF="$(git -C "$PROTO_SRC" rev-parse HEAD)"
  if [ "$ACTUAL_REF" != "$PROTO_REF" ]; then
    echo "ERROR: $PROTO_SRC is at $ACTUAL_REF, not the pinned $PROTO_REF."
    echo "Either:"
    echo "  git -C $PROTO_SRC checkout $PROTO_REF"
    echo "or, if you deliberately mean to move the pin, update PROTO_REF in"
    echo "this script (own commit) after confirming the generated stubs still"
    echo "match kuksa.val.v2's actual wire contract at the new SHA."
    echo "Override once, at your own risk: KUKSA_PROTO_SKIP_REF_CHECK=1 $0 $*"
    if [ "${KUKSA_PROTO_SKIP_REF_CHECK:-0}" != "1" ]; then
      exit 1
    fi
    echo "KUKSA_PROTO_SKIP_REF_CHECK=1 set — proceeding against $ACTUAL_REF anyway."
  fi
else
  echo "WARNING: $PROTO_SRC is not a git checkout — cannot verify it is at the" \
       "pinned ref $PROTO_REF. Proceeding anyway."
fi

mkdir -p "$OUT_DIR"

# Generate Dart stubs — types.proto must come before val.proto
protoc \
  --proto_path="$PROTO_SRC" \
  --proto_path="$(dart pub cache list 2>/dev/null | grep protoc_plugin | head -1 | awk '{print $2}')/proto" \
  --dart_out="grpc:$OUT_DIR" \
  kuksa/val/v2/types.proto \
  kuksa/val/v2/val.proto

echo "Protos generated in $OUT_DIR from $PROTO_SRC at $PROTO_REF"

