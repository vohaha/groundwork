#!/usr/bin/env bash
# check-agreements.sh — surfaces open items from WORKING_AGREEMENT.md
# Called by: Claude Code Stop hook, git post-commit hook
# Usage: check-agreements.sh [project-root]

PROJECT_ROOT="${1:-$(git -C "${PWD}" rev-parse --show-toplevel 2>/dev/null || echo "$PWD")}"

files=(
  "$PROJECT_ROOT/WORKING_AGREEMENT.md"
  "$HOME/.claude/WORKING_AGREEMENT.md"
)

all_items=()
all_labels=()

for file in "${files[@]}"; do
  [ -f "$file" ] || continue

  if [[ "$file" == "$HOME/.claude/"* ]]; then
    label="global"
  else
    label="$(basename "$PROJECT_ROOT")"
  fi

  while IFS= read -r line; do
    all_items+=("$line")
    all_labels+=("$label")
  done < <(grep -E "^- \[ \]" "$file")
done

[ ${#all_items[@]} -eq 0 ] && exit 0

# Debounce: skip if reminded within the last 30 minutes (post-commit can fire often)
debounce_file="/tmp/groundwork-agreement-reminded-$(echo "$PROJECT_ROOT" | md5 -q 2>/dev/null || echo "$PROJECT_ROOT" | md5sum 2>/dev/null | cut -d' ' -f1)"
if [ -f "$debounce_file" ]; then
  last_reminded=$(stat -f %m "$debounce_file" 2>/dev/null || stat -c %Y "$debounce_file" 2>/dev/null || echo 0)
  now=$(date +%s)
  elapsed=$(( now - last_reminded ))
  [ "$elapsed" -lt 1800 ] && exit 0
fi
touch "$debounce_file"

echo ""
echo "┌─ Working Agreement: ${#all_items[@]} open item(s) ────────────────────────────┐"
prev_label=""
for i in "${!all_items[@]}"; do
  label="${all_labels[$i]}"
  if [ "$label" != "$prev_label" ]; then
    printf "│  [%s]\n" "$label"
    prev_label="$label"
  fi
  printf "│  %s\n" "${all_items[$i]}"
done
echo "│"
echo "│  → Review WORKING_AGREEMENT.md and check off resolved items"
echo "└────────────────────────────────────────────────────────────────────────┘"
echo ""
