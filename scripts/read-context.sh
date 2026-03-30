#!/usr/bin/env bash
# read-context.sh — outputs current project state at session start
# Called by: Claude Code SessionStart hook

PROJECT_ROOT=$(git -C "${PWD}" rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
AGREEMENT="$PROJECT_ROOT/WORKING_AGREEMENT.md"

branch=$(git -C "$PROJECT_ROOT" branch --show-current 2>/dev/null || echo "unknown")
last_subject=$(git -C "$PROJECT_ROOT" log -1 --format="%s" 2>/dev/null || echo "no commits")
last_date=$(git -C "$PROJECT_ROOT" log -1 --format="%ad" --date=short 2>/dev/null || echo "")
last_body=$(git -C "$PROJECT_ROOT" log -1 --format="%b" 2>/dev/null || echo "")

state_next=$(echo "$last_body" | grep "^Next:" | head -1 | sed 's/^Next: //')
active=$(echo "$last_body" | grep "^Active:" | head -1 | sed 's/^Active: //')
open_q=$(echo "$last_body" | awk '/^Open:/{found=1; next} found && /^(Why|State|Discovered|Active|Next):/{exit} found && /^$/{if(printed) exit; next} found{print; printed=1}' | head -2)

uncommitted=$(git -C "$PROJECT_ROOT" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

open_items=0
if [ -f "$AGREEMENT" ]; then
  open_items=$(grep -cE "^- \[ \]" "$AGREEMENT" 2>/dev/null || echo 0)
fi

echo ""
echo "┌─ Groundwork: Session Start ────────────────────────────────────────────┐"
printf "│  Branch: %-20s  %s\n" "$branch" "$last_date"
printf "│  %s\n" "$last_subject"
if [ -n "$state_next" ]; then
  printf "│\n│  → Next: %s\n" "$state_next"
fi
if [ -n "$active" ]; then
  printf "│    Active: %s\n" "$active"
fi
if [ -n "$open_q" ]; then
  printf "│\n│  Open: %s\n" "$open_q"
fi
printf "│\n│  Uncommitted: %-5s   Agreement open items: %s\n" "$uncommitted" "$open_items"
echo "│"
echo "│  Claude is the primary stakeholder. Human adapts."
echo "└────────────────────────────────────────────────────────────────────────┘"
echo ""
