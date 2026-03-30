#!/usr/bin/env bash
# validate-commit-msg.sh — warns if commit message is missing Why: section
# Called by: .git/hooks/commit-msg
# Usage: validate-commit-msg.sh <commit-msg-file>
# Non-blocking: always exits 0

commit_msg_file="$1"
[ -f "$commit_msg_file" ] || exit 0

# Strip comment lines for analysis
commit_msg=$(grep -v "^#" "$commit_msg_file")
first_line=$(echo "$commit_msg" | head -1)

# Skip merge, revert, wip, and fixup commits
if echo "$first_line" | grep -qiE "^(Merge|Revert|WIP|fixup!|squash!)"; then
  exit 0
fi

if ! echo "$commit_msg" | grep -qE "^Why:"; then
  echo ""
  echo "⚠  Groundwork: missing 'Why:' section"
  echo "   What was the decision? What constraint or goal drove this change?"
  echo ""
fi

exit 0
