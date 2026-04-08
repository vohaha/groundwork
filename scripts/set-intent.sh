#!/usr/bin/env bash
# set-intent.sh — writes session intent file
# Called by: groundwork:intent skill
# Usage: set-intent.sh --mode <mode> --target <target> --done <criteria>
#        [--constraints <constraints>]
#
# Intent persists across conversation but is cleared at session start
# (read-context.sh clears it). It can be read by other scripts.

INTENT_FILE="$HOME/.claude/groundwork-intent"

mode="" target="" done="" constraints=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)        mode="$2";        shift 2 ;;
    --target)      target="$2";      shift 2 ;;
    --done)        done="$2";        shift 2 ;;
    --constraints) constraints="$2"; shift 2 ;;
    *) echo "Error: unknown argument: $1" >&2; exit 1 ;;
  esac
done

missing=""
[ -z "$mode" ]   && missing="${missing} --mode"
[ -z "$target" ] && missing="${missing} --target"
[ -z "$done" ]   && missing="${missing} --done"

if [ -n "$missing" ]; then
  echo "Error: missing required fields:${missing}" >&2
  echo "Required: --mode --target --done" >&2
  exit 1
fi

valid_modes="ship explore debug refactor design review"
if ! echo "$valid_modes" | grep -qw "$mode"; then
  echo "Error: invalid mode '$mode'" >&2
  echo "Valid modes: $valid_modes" >&2
  exit 1
fi

cat > "$INTENT_FILE" <<EOF
mode: ${mode}
target: ${target}
done: ${done}
declared: $(date +%Y-%m-%d)
EOF

[ -n "$constraints" ] && echo "constraints: ${constraints}" >> "$INTENT_FILE"

echo "Intent set: ${mode} — ${target}"
