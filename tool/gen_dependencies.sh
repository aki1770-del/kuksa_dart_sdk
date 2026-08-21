#!/usr/bin/env bash
# Regenerate DEPENDENCIES — the runtime third-party manifest for Eclipse IP review.
#
#   tool/gen_dependencies.sh --coordinates   # Dash INPUT: one coordinate per line
#   tool/gen_dependencies.sh                 # annotated manifest (default)
#
# Runtime closure only. `--no-dev` is load-bearing: this is a library, so the
# dev dependencies (test, lints and their transitives) are not distributed and
# must not appear in an IP review.
#
# NOTE for anyone adapting this: do NOT filter `dart pub deps --json` by
# `kind == "transitive"`. A dev dependency's transitives are ALSO "transitive",
# so that filter silently admits packages you do not ship. Either use --no-dev
# as below, or walk the graph from root.directDependencies.
set -euo pipefail
cd "$(dirname "$0")/.."

dart pub get >/dev/null

coordinates() {
  dart pub deps --no-dev --style=list \
    | sed -n 's|^- \([a-zA-Z0-9_]*\) \(.*\)$|pub/pub.dev/-/\1/\2|p' \
    | sort
}

if [[ "${1:-}" == "--coordinates" ]]; then
  coordinates
  exit 0
fi

coordinates | python3 tool/spdx_from_cache.py | python3 tool/render_dependencies.py
