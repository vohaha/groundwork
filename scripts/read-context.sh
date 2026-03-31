#!/usr/bin/env bash
# read-context.sh — outputs current project state at session start
# Called by: Claude Code SessionStart hook

# Clear persisted mode — modes don't carry across sessions
rm -f "$HOME/.claude/groundwork-mode"

PROJECT_ROOT=$(git -C "${PWD}" rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
AGREEMENT="$PROJECT_ROOT/WORKING_AGREEMENT.md"

branch=$(git -C "$PROJECT_ROOT" branch --show-current 2>/dev/null || echo "unknown")
last_subject=$(git -C "$PROJECT_ROOT" log -1 --format="%s" 2>/dev/null || echo "no commits")
last_date=$(git -C "$PROJECT_ROOT" log -1 --format="%ad" --date=short 2>/dev/null || echo "")
last_body=$(git -C "$PROJECT_ROOT" log -1 --format="%b" 2>/dev/null || echo "")

state_next=$(echo "$last_body" | grep "^Next:" | head -1 | sed 's/^Next: //')
active=$(echo "$last_body" | grep "^Active:" | head -1 | sed 's/^Active: //')
open_q=$(echo "$last_body" | awk '/^Open:/{found=1; next} found && /^(Why|State|Discovered|Active|Next):/{exit} found && /^$/{if(printed) exit; next} found{print; printed=1}' | head -2)

# Trajectory: Next: values from last 3 commits (skip first — already shown above)
trajectory=$(git -C "$PROJECT_ROOT" log --skip=1 -2 --format="%b" 2>/dev/null | grep "^Next:" | sed 's/^Next: //')

case "$branch" in
  feat/*)    intent="shipping" ;;
  fix/*)     intent="debugging" ;;
  explore/*) intent="exploring (non-committing)" ;;
  *) intent="" ;;
esac

uncommitted=$(git -C "$PROJECT_ROOT" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

open_items=0
if [ -f "$AGREEMENT" ]; then
  open_items=$(grep -cE "^- \[ \]" "$AGREEMENT" 2>/dev/null) || open_items=0
fi

echo ""
echo "┌─ Groundwork: Session Start ────────────────────────────────────────────┐"
printf "│  Branch: %-20s  %s\n" "$branch" "$last_date"
if [ -n "$intent" ]; then
  printf "│  Mode: %s\n" "$intent"
fi
printf "│  %s\n" "$last_subject"
if [ -n "$state_next" ]; then
  printf "│\n│  → Next: %s\n" "$state_next"
fi
if [ -n "$active" ]; then
  printf "│    Active: %s\n" "$active"
fi
if [ -n "$trajectory" ]; then
  while IFS= read -r line; do
    printf "│    prev: %s\n" "$line"
  done <<< "$trajectory"
fi
if [ -n "$open_q" ]; then
  printf "│\n│  Open: %s\n" "$open_q"
fi
# Check priorities
priority=""
if [ -f "$AGREEMENT" ]; then
  priority=$(awk '/^## Current Priorities/{f=1;next} f&&/^## /{exit} f&&/^[0-9]+\./{s=$0;sub(/^[0-9]+\. */,"",s); if(s!="-"&&s!="—"&&s!=""){print s;exit}}' "$AGREEMENT")
fi

if [ -n "$priority" ]; then
  printf "│  Priority: %s\n" "$priority"
else
  printf "│  ⚠ No priorities set\n"
fi
printf "│\n│  Uncommitted: %-5s   Agreement open items: %s\n" "$uncommitted" "$open_items"
echo "│"
echo "│  Claude is the primary stakeholder. Human adapts."
echo "└────────────────────────────────────────────────────────────────────────┘"
echo ""
