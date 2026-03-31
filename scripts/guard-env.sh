#!/usr/bin/env bash
# Block any tool call that references .env files
# Used as a PreToolUse hook — exits 2 to block, 0 to allow

input=$(cat)
if echo "$input" | grep -qiE '\.env(\b|"|$|/)'; then
  echo '{"error": "Blocked: .env files are off-limits"}'
  exit 2
fi
exit 0
