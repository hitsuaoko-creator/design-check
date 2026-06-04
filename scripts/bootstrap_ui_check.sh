#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: bash scripts/bootstrap_ui_check.sh /abs/path/to/project [docs/ui-check/feature-slug]" >&2
  exit 1
fi

PROJECT_ROOT="$1"
RELATIVE_TARGET="${2:-docs/ui-check/sample-feature}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/../assets/templates/ui-check-kit"
TARGET_DIR="${PROJECT_ROOT%/}/${RELATIVE_TARGET}"

mkdir -p "${TARGET_DIR}"
cp -R "${TEMPLATE_DIR}/." "${TARGET_DIR}/"

echo "Created UI-check kit at: ${TARGET_DIR}"
