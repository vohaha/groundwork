#!/usr/bin/env bash
# statusline.sh — outputs groundwork environment health for Claude Code status line
# Output: compact single-line status. Empty output = not in a groundwork-enabled project.

PROJECT_ROOT=$(git -C "${PWD}" rev-parse --show-toplevel 2>/dev/null) || exit 0

hard_issues=0
open_items=0

project=$(basename "$PROJECT_ROOT")
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

# Check priorities
priorities_set=0
if [ -f "$AGREEMENT" ]; then
  has_p=$(awk '/^## Current Priorities/{f=1;next} f&&/^## /{exit} f&&/^[0-9]+\./{s=$0;sub(/^[0-9]+\. */,"",s); if(s!="-"&&s!="—"&&s!=""){print 1;exit}}' "$AGREEMENT")
  [ -n "$has_p" ] && priorities_set=1
fi

# Current mode (written by UserPromptSubmit hook when mode skills are invoked)
mode_file="$HOME/.claude/groundwork-mode"
mode=""
[ -f "$mode_file" ] && mode=$(cat "$mode_file" 2>/dev/null)
[ -n "$mode" ] && mode_str=" mode=$mode" || mode_str=""

# Warnings suffix
warnings=""
[ "$open_items" -gt 0 ] && warnings="${warnings} ${open_items}open"
[ "$priorities_set" -eq 0 ] && warnings="${warnings} !P"

if [ "$hard_issues" -gt 0 ]; then
  printf "⬡ %s ✗ [%s]%s%s" "$project" "$branch" "$mode_str" "$warnings"
elif [ -n "$warnings" ]; then
  printf "⬡ %s ✓ [%s]%s%s" "$project" "$branch" "$mode_str" "$warnings"
else
  printf "⬡ %s ✓ [%s]%s" "$project" "$branch" "$mode_str"
fi
exit 0
