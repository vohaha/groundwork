#!/usr/bin/env bash
# track-mode.sh — UserPromptSubmit hook: tracks operating mode and injects instructions each prompt
# Input: JSON via stdin with "prompt" field
# Output: mode instructions injected as system reminder (no default — Claude decides per task)

prompt=$(cat | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('prompt',''))" 2>/dev/null)
mode_file="$HOME/.claude/groundwork-mode"

case "$prompt" in
  /do\ *|/do)          echo "do"    > "$mode_file" ;;
  /think\ *|/think)    echo "think" > "$mode_file" ;;
  /plan\ *|/plan)      echo "plan"  > "$mode_file" ;;
  /clear-mode\ *|/clear-mode) rm -f "$mode_file" ;;
esac

mode=$(cat "$mode_file" 2>/dev/null)

case "$mode" in
  do)    echo "Active mode: do — execute directly, no options, brief report only." ;;
  think) echo "Active mode: think — surface options and tradeoffs only, no changes, wait for direction." ;;
  plan)  echo "Active mode: plan — read context, produce plan with key decisions, no implementation, wait for go-ahead." ;;
esac

exit 0
