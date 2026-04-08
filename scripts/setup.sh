#!/usr/bin/env bash
# setup.sh — deterministic setup of groundwork git integration
# Called by: groundwork:setup skill
# Handles: hook files, commit template, chmod — all content-exact operations
# Does NOT handle: WORKING_AGREEMENT.md, CLAUDE.md (those need judgment → skill prompt)

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$PROJECT_ROOT" ]; then
  echo "Error: not in a git repository" >&2
  exit 1
fi

echo ""
echo "── Groundwork: Setup ──────────────────────────────────────────────────"

# 1. Install git hooks
echo ""
echo "Git hooks"

HOOKS_DIR="$PROJECT_ROOT/.git/hooks"

cat > "$HOOKS_DIR/commit-msg" << HOOK
#!/usr/bin/env bash
bash "${PLUGIN_ROOT}/scripts/validate-commit-msg.sh" "\$1"
HOOK
chmod +x "$HOOKS_DIR/commit-msg"
echo "  ✓ commit-msg hook installed"

cat > "$HOOKS_DIR/post-commit" << HOOK
#!/usr/bin/env bash
bash "${PLUGIN_ROOT}/scripts/check-agreements.sh" "\$PWD"
HOOK
chmod +x "$HOOKS_DIR/post-commit"
echo "  ✓ post-commit hook installed"

cat > "$HOOKS_DIR/pre-push" << HOOK
#!/usr/bin/env bash
bash "${PLUGIN_ROOT}/scripts/pre-push-version.sh"
HOOK
chmod +x "$HOOKS_DIR/pre-push"
echo "  ✓ pre-push hook installed"

# 2. Install global commit template
echo ""
echo "Commit template"
existing_template=$(git config --global commit.template 2>/dev/null)
if [ -n "$existing_template" ]; then
  echo "  — skipped (already set: $existing_template)"
else
  cp "$PLUGIN_ROOT/templates/commit-message.txt" "$HOME/.gitmessage"
  git config --global commit.template "$HOME/.gitmessage"
  echo "  ✓ installed ~/.gitmessage"
fi

echo ""
echo "────────────────────────────────────────────────────────────────────────"
echo "  Hooks and template done. WORKING_AGREEMENT.md and CLAUDE.md handled by skill."
echo ""
