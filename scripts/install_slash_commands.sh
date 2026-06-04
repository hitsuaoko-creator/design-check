#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: bash scripts/install_slash_commands.sh /abs/path/to/project [cursor|claude|both]" >&2
  exit 1
fi

PROJECT_ROOT="$1"
PLATFORM="${2:-both}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SUPPORT_DIR="${PROJECT_ROOT%/}/.design-check"

mkdir -p "${SUPPORT_DIR}"
cp "${REPO_ROOT}/AGENT-SPEC.md" "${SUPPORT_DIR}/AGENT-SPEC.md"
rm -rf "${SUPPORT_DIR}/design-check-kit"
cp -R "${REPO_ROOT}/assets/templates/design-check-kit" "${SUPPORT_DIR}/design-check-kit"

case "${PLATFORM}" in
  cursor)
    mkdir -p "${PROJECT_ROOT%/}/.cursor/commands"
    cp "${REPO_ROOT}/.cursor/commands/design-check.md" "${PROJECT_ROOT%/}/.cursor/commands/design-check.md"
    ;;
  claude)
    mkdir -p "${PROJECT_ROOT%/}/.claude/commands"
    cp "${REPO_ROOT}/.claude/commands/design-check.md" "${PROJECT_ROOT%/}/.claude/commands/design-check.md"
    ;;
  both)
    mkdir -p "${PROJECT_ROOT%/}/.cursor/commands" "${PROJECT_ROOT%/}/.claude/commands"
    cp "${REPO_ROOT}/.cursor/commands/design-check.md" "${PROJECT_ROOT%/}/.cursor/commands/design-check.md"
    cp "${REPO_ROOT}/.claude/commands/design-check.md" "${PROJECT_ROOT%/}/.claude/commands/design-check.md"
    ;;
  *)
    echo "Invalid platform: ${PLATFORM}. Use cursor, claude, or both." >&2
    exit 1
    ;;
esac

echo "Installed design-check slash command support to: ${PROJECT_ROOT}"
