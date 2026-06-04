#!/usr/bin/env bash

set -euo pipefail

TARGET_ROOT="${1:-$HOME/.codex/skills}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${TARGET_ROOT%/}/design-check"

mkdir -p "${TARGET_DIR}"
rsync -a --exclude '.git' "${SCRIPT_DIR}/" "${TARGET_DIR}/"

echo "Installed skill to: ${TARGET_DIR}"
