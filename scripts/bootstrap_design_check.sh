#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: bash scripts/bootstrap_design_check.sh /abs/path/to/project [docs/design-check/feature-slug]" >&2
  exit 1
fi

PROJECT_ROOT="$1"
RELATIVE_TARGET="${2:-docs/design-check/sample-feature}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/../assets/templates/design-check-kit"
TARGET_DIR="${PROJECT_ROOT%/}/${RELATIVE_TARGET}"

mkdir -p "${TARGET_DIR}"
cp -R "${TEMPLATE_DIR}/." "${TARGET_DIR}/"

echo "Created design-check kit at: ${TARGET_DIR}"
