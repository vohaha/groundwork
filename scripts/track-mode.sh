#!/usr/bin/env bash
# track-mode.sh — UserPromptSubmit hook: detects mode skill invocations and writes ~/.claude/groundwork-mode
# Input: JSON via stdin with "prompt" field
# Output: nothing (passthrough hook)

prompt=$(cat | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('prompt',''))" 2>/dev/null)
mode_file="$HOME/.claude/groundwork-mode"

case "$prompt" in
  /do\ *|/do)       echo "do"    > "$mode_file" ;;
  /think\ *|/think)  echo "think" > "$mode_file" ;;
  /plan\ *|/plan)    echo "plan"  > "$mode_file" ;;
esac

exit 0
