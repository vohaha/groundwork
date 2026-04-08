#!/usr/bin/env bash
# pre-push-version.sh — normalizes plugin version before push
# Called by: .git/hooks/pre-push (installed by groundwork:setup)
# Reads push refs from stdin (standard pre-push hook protocol)
#
# Only applies to projects that contain .claude-plugin/plugin.json.
# Safe no-op in client projects that aren't plugins.

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
PLUGIN_JSON="$PROJECT_ROOT/.claude-plugin/plugin.json"
MARKETPLACE_JSON="$PROJECT_ROOT/.claude-plugin/marketplace.json"

# Only applies to plugin projects
[ -f "$PLUGIN_JSON" ] || exit 0

while read local_ref local_sha remote_ref remote_sha; do
  # Skip branch deletes
  [ "$local_sha" = "0000000000000000000000000000000000000000" ] && continue
  # Skip new branches — no base version to compare against
  [ "$remote_sha" = "0000000000000000000000000000000000000000" ] && continue

  # Get base version from last pushed commit
  base=$(git show "${remote_sha}:.claude-plugin/plugin.json" 2>/dev/null \
    | grep '"version"' | sed 's/.*"version": *"\([^"]*\)".*/\1/')
  current=$(grep '"version"' "$PLUGIN_JSON" | sed 's/.*"version": *"\([^"]*\)".*/\1/')

  # If versions already differ, someone bumped manually — trust it
  if [ -n "$base" ] && [ "$current" != "$base" ]; then
    echo "groundwork: version already at $current (was $base), skipping auto-bump" >&2
    continue
  fi

  # Analyze surface area changes in commits being pushed
  skill_adds=$(git diff --name-status "$remote_sha" "$local_sha" -- 'skills/' 2>/dev/null \
    | grep 'SKILL\.md' | grep -c '^A')
  skill_dels=$(git diff --name-status "$remote_sha" "$local_sha" -- 'skills/' 2>/dev/null \
    | grep 'SKILL\.md' | grep -c '^D')
  script_changes=$(git diff --name-only "$remote_sha" "$local_sha" -- 'scripts/' 2>/dev/null \
    | grep -c '\.sh$')

  if [ "$skill_adds" -gt 0 ] || [ "$skill_dels" -gt 0 ]; then
    bump="minor"
  elif [ "$script_changes" -gt 0 ]; then
    bump="patch"
  else
    continue  # no surface area change, no bump needed
  fi

  # Parse and increment version
  major=$(echo "$current" | cut -d. -f1)
  minor_v=$(echo "$current" | cut -d. -f2)
  patch_v=$(echo "$current" | cut -d. -f3)

  if [ "$bump" = "minor" ]; then
    minor_v=$((minor_v + 1))
    patch_v=0
  else
    patch_v=$((patch_v + 1))
  fi
  new_version="${major}.${minor_v}.${patch_v}"

  # Update both JSON files (portable — no sed -i)
  tmp=$(mktemp)
  sed "s/\"version\": \"${current}\"/\"version\": \"${new_version}\"/" "$PLUGIN_JSON" > "$tmp" \
    && mv "$tmp" "$PLUGIN_JSON"
  tmp=$(mktemp)
  sed "s/\"version\": \"${current}\"/\"version\": \"${new_version}\"/" "$MARKETPLACE_JSON" > "$tmp" \
    && mv "$tmp" "$MARKETPLACE_JSON"

  git -C "$PROJECT_ROOT" add "$PLUGIN_JSON" "$MARKETPLACE_JSON"
  git -C "$PROJECT_ROOT" commit -m "chore(version): bump to ${new_version}

Why:
Surface area changed in pushed commits — version normalized by pre-push hook.

State:
Next: —

Commit-Tool: groundwork"

  echo "groundwork: version ${current} → ${new_version} (${bump} bump)" >&2
done
