#!/usr/bin/env bash
# statusline.sh — outputs groundwork environment health for Claude Code status line
# Output: compact single-line status. Empty output = not in a groundwork-enabled project.

PROJECT_ROOT=$(git -C "${PWD}" rev-parse --show-toplevel 2>/dev/null) || exit 0

issues=0
open_items=0
branch=$(git -C "${PWD}" rev-parse --abbrev-ref HEAD 2>/dev/null)
{ [ "$branch" = "main" ] || [ "$branch" = "master" ]; } && issues=$((issues + 1))

# Check git hooks installed
[ -x "$PROJECT_ROOT/.git/hooks/commit-msg" ] || issues=$((issues + 1))
[ -x "$PROJECT_ROOT/.git/hooks/post-commit" ] || issues=$((issues + 1))

# Check WORKING_AGREEMENT.md exists
AGREEMENT="$PROJECT_ROOT/WORKING_AGREEMENT.md"
if [ -f "$AGREEMENT" ]; then
  open_items=$(grep -cE "^- \[ \]" "$AGREEMENT" 2>/dev/null) || open_items=0
else
  issues=$((issues + 1))
fi

if [ "$issues" -gt 0 ]; then
  printf "⬡ GW ✗ [%s]" "$branch"
  [ "$open_items" -gt 0 ] && printf " %s open" "$open_items"
elif [ "$open_items" -gt 0 ]; then
  printf "⬡ GW [%s] %s open" "$branch" "$open_items"
else
  printf "⬡ GW ✓ [%s]" "$branch"
fi
exit 0
