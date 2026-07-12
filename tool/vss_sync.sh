#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
# SPDX-License-Identifier: Apache-2.0
#
# Re-fetches the COVESA Vehicle Signal Specification files this package
# documents, and DIFFS them against the copies vendored in spec/.
#
#   tool/vss_sync.sh          # diff only; exit 1 if upstream has changed
#   tool/vss_sync.sh --update # overwrite spec/ with upstream, then diff
#
# Why: this package's documentation and its RoadFriction classifier are derived
# from the vendored spec (see tool/gen_signal_table.dart and
# test/vss_conformance_test.dart). If COVESA changes a signal's unit or range,
# we want the build to BREAK LOUDLY rather than let our documentation quietly
# become untrue. CI runs this in diff mode.

set -euo pipefail

BASE="https://raw.githubusercontent.com/COVESA/vehicle_signal_specification/${VSS_REF:-master}/spec"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SPEC_DIR="$ROOT/spec"

# vendored filename : upstream path
FILES=(
  "ADAS.vspec:ADAS/ADAS.vspec"
  "Body.vspec:Body/Body.vspec"
  "Vehicle.vspec:Vehicle/Vehicle.vspec"
  "Exterior.vspec:Vehicle/Exterior.vspec"
  "Chassis.vspec:Chassis/Chassis.vspec"
  "Wheel.vspec:Chassis/Wheel.vspec"
)

UPDATE=0
[[ "${1:-}" == "--update" ]] && UPDATE=1

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

drift=0
for pair in "${FILES[@]}"; do
  local_name="${pair%%:*}"
  remote_path="${pair#*:}"
  url="$BASE/$remote_path"

  if ! curl -sfL "$url" -o "$TMP/$local_name"; then
    echo "FETCH FAILED: $url" >&2
    echo "The spec file moved or the network is unavailable. Do NOT proceed" >&2
    echo "by documenting the signal from memory." >&2
    exit 2
  fi

  if [[ ! -f "$SPEC_DIR/$local_name" ]]; then
    echo "NOT VENDORED: spec/$local_name (fetched from $url)"
    drift=1
    [[ $UPDATE -eq 1 ]] && cp "$TMP/$local_name" "$SPEC_DIR/$local_name"
    continue
  fi

  if ! diff -u "$SPEC_DIR/$local_name" "$TMP/$local_name" > "$TMP/$local_name.diff"; then
    echo "UPSTREAM DRIFT: spec/$local_name differs from $url"
    cat "$TMP/$local_name.diff"
    drift=1
    [[ $UPDATE -eq 1 ]] && cp "$TMP/$local_name" "$SPEC_DIR/$local_name"
  fi
done

if [[ $drift -eq 1 && $UPDATE -eq 0 ]]; then
  cat >&2 <<'EOF'

The vendored VSS spec is out of date with COVESA upstream.

  1. tool/vss_sync.sh --update
  2. dart run tool/gen_signal_table.dart     # regenerate the README table
  3. dart test                               # the conformance test will fail
                                             #   if a documented contract moved
  4. Read the diff. If a unit or range changed, the classifier thresholds and
     the CHANGELOG must be revisited BEFORE publishing.
EOF
  exit 1
fi

if [[ $UPDATE -eq 1 ]]; then
  echo "spec/ updated from upstream. Now run:"
  echo "  dart run tool/gen_signal_table.dart && dart test"
else
  echo "spec/ matches COVESA upstream (${VSS_REF:-master})."
fi
