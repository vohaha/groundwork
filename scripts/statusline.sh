#!/usr/bin/env bash
# statusline.sh — outputs groundwork environment health for Claude Code status line
# Output: compact single-line status. Empty output = not in a groundwork-enabled project.

PROJECT_ROOT=$(git -C "${PWD}" rev-parse --show-toplevel 2>/dev/null) || exit 0

hard_issues=0
warnings=0
open_items=0

branch=$(git -C "${PWD}" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Hard issues: structural problems that break groundwork
[ -x "$PROJECT_ROOT/.git/hooks/commit-msg" ] || hard_issues=$((hard_issues + 1))
[ -x "$PROJECT_ROOT/.git/hooks/post-commit" ] || hard_issues=$((hard_issues + 1))

AGREEMENT="$PROJECT_ROOT/WORKING_AGREEMENT.md"
if [ -f "$AGREEMENT" ]; then
  open_items=$(grep -cE "^- \[ \]" "$AGREEMENT" 2>/dev/null) || open_items=0
else
  hard_issues=$((hard_issues + 1))
fi

# Warning: branch not in expected format (type/description, e.g. feat/my-feature)
if ! echo "$branch" | grep -qE '^(feat|fix|refactor|docs|test|chore|session|decide)/[a-z0-9]'; then
  warnings=$((warnings + 1))
fi

# Current mode (written by UserPromptSubmit hook when mode skills are invoked)
mode_file="$HOME/.claude/groundwork-mode"
mode=""
[ -f "$mode_file" ] && mode=$(cat "$mode_file" 2>/dev/null)
[ -n "$mode" ] && mode_str=" mode=$mode" || mode_str=""

if [ "$hard_issues" -gt 0 ]; then
  printf "⬡ GW ✗ [%s]%s" "$branch" "$mode_str"
  [ "$open_items" -gt 0 ] && printf " %s open" "$open_items"
elif [ "$warnings" -gt 0 ]; then
  printf "⬡ GW ⚠ [%s]%s" "$branch" "$mode_str"
  [ "$open_items" -gt 0 ] && printf " %s open" "$open_items"
elif [ "$open_items" -gt 0 ]; then
  printf "⬡ GW ✓ [%s]%s %s open" "$branch" "$mode_str" "$open_items"
else
  printf "⬡ GW ✓ [%s]%s" "$branch" "$mode_str"
fi
exit 0
