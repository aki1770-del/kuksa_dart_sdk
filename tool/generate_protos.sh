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

if [ ! -d "$PROTO_SRC/kuksa/val/v2" ]; then
  echo "ERROR: Proto source not found at $PROTO_SRC/kuksa/val/v2"
  echo "Clone the canonical proto repo first:"
  echo "  git clone https://github.com/eclipse-kuksa/kuksa-proto ../kuksa-proto"
  echo "Usage: $0 [path/to/kuksa-proto]"
  exit 1
fi

mkdir -p "$OUT_DIR"

# Generate Dart stubs — types.proto must come before val.proto
protoc \
  --proto_path="$PROTO_SRC" \
  --proto_path="$(dart pub cache list 2>/dev/null | grep protoc_plugin | head -1 | awk '{print $2}')/proto" \
  --dart_out="grpc:$OUT_DIR" \
  kuksa/val/v2/types.proto \
  kuksa/val/v2/val.proto

echo "Protos generated in $OUT_DIR"
