#!/usr/bin/env bash
# backlog.sh — show open items, priorities, and last session from WORKING_AGREEMENT.md
# Usage: backlog.sh [project-root]

PROJECT_ROOT="${1:-$(git -C "${PWD}" rev-parse --show-toplevel 2>/dev/null || echo "$PWD")}"
WA="$PROJECT_ROOT/WORKING_AGREEMENT.md"

if [ ! -f "$WA" ]; then
    echo "no WORKING_AGREEMENT.md found in $PROJECT_ROOT"
    exit 1
fi

# Colors
DIM='\033[2m'
BOLD='\033[1m'
YELLOW='\033[33m'
CYAN='\033[36m'
GREEN='\033[32m'
RST='\033[0m'

echo -e "${BOLD}=== priorities ===${RST}"
sed -n '/^## Current Priorities/,/^## /{/^[0-9]/p}' "$WA" | while read -r line; do
    echo -e "  ${CYAN}${line}${RST}"
done

echo ""
echo -e "${BOLD}=== open friction ===${RST}"
sed -n '/^## Open Friction/,/^## /{/^\- \[ \]/p}' "$WA" | sed 's/- \[ \] //' | while read -r line; do
    owner=$(echo "$line" | grep -oP '^\[.*?\]' || echo "")
    rest=$(echo "$line" | sed 's/^\[.*\] //')
    echo -e "  ${YELLOW}${owner}${RST} ${rest}"
done

echo ""
echo -e "${BOLD}=== active commitments ===${RST}"
sed -n '/^## Active Commitments/,/^## /{/^\- \[ \]/p}' "$WA" | sed 's/- \[ \] //' | while read -r line; do
    owner=$(echo "$line" | grep -oP '^\[.*?\]' || echo "")
    rest=$(echo "$line" | sed 's/^\[.*\] //')
    echo -e "  ${YELLOW}${owner}${RST} ${rest}"
done

echo ""
echo -e "${BOLD}=== last session ===${RST}"
SESSION_HASH=$(git -C "$PROJECT_ROOT" log --all --format='%H' --grep='^session:' -1 2>/dev/null || echo "")
if [[ -n "$SESSION_HASH" ]]; then
    SUBJECT=$(git -C "$PROJECT_ROOT" log --format='%s' -1 "$SESSION_HASH")
    BODY=$(git -C "$PROJECT_ROOT" log --format='%b' -1 "$SESSION_HASH")
    echo -e "  ${DIM}${SUBJECT}${RST}"

    NEXT=$(echo "$BODY" | sed -n '/^Next:/s/^Next: //p')
    OPEN=$(echo "$BODY" | sed -n '/^Open:/s/^Open: //p')

    if [[ -n "$NEXT" ]]; then
        echo -e "  ${GREEN}next:${RST} ${NEXT}"
    fi
    if [[ -n "$OPEN" ]]; then
        echo -e "  ${YELLOW}open:${RST} ${OPEN}"
    fi
else
    echo -e "  ${DIM}(no session commits found)${RST}"
fi
