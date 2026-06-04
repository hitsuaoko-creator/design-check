#!/usr/bin/env bash

set -euo pipefail

if [[ $# -gt 2 ]]; then
  echo "Usage: bash scripts/bootstrap_design_check.sh [/abs/path/to/output-root] [design-check/feature-slug]" >&2
  exit 1
fi

OUTPUT_ROOT="${1:-$HOME/Desktop}"
RELATIVE_TARGET="${2:-design-check/sample-feature}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/../assets/templates/design-check-kit"
TARGET_DIR="${OUTPUT_ROOT%/}/${RELATIVE_TARGET}"

mkdir -p "${TARGET_DIR}"
cp -R "${TEMPLATE_DIR}/." "${TARGET_DIR}/"

echo "Created design-check kit at: ${TARGET_DIR}"
