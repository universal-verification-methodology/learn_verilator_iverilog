#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COURSE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL="${SKILL_ROOT:-$HOME/.cursor/skills/module-to-slides-video}"
exec "$SKILL/scripts/run_python.sh" \
  "$SKILL/scripts/generate_outline_from_module.py" \
  "$COURSE_ROOT" "$@"
