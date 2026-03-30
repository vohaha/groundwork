#!/usr/bin/env bash
# validate.sh — checks structural integrity of groundwork features
# Called by: groundwork:validate skill
# Scaffold: this script; Content: n/a (pure structural verification)

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pass=0
fail=0

ok()   { echo "  ✓ $1"; pass=$((pass + 1)); }
fail() { echo "  ✗ $1"; fail=$((fail + 1)); }

echo ""
echo "── Groundwork: Structural Validation ──────────────────────────────────"

echo ""
echo "Scripts"
for script in validate-commit-msg.sh check-agreements.sh read-context.sh create-commit.sh statusline.sh validate.sh; do
  path="$PLUGIN_ROOT/scripts/$script"
  if [ ! -f "$path" ]; then
    fail "$script — missing"
  elif [ ! -x "$path" ]; then
    fail "$script — not executable"
  else
    ok "$script"
  fi
done

echo ""
echo "Skills"
for skill in do think plan commit check-in setup validate help; do
  path="$PLUGIN_ROOT/skills/$skill/SKILL.md"
  if [ ! -f "$path" ]; then
    fail "$skill/SKILL.md — missing"
  else
    ok "$skill/SKILL.md"
  fi
done

echo ""
echo "Templates"
for tpl in commit-message.txt working-agreement.md; do
  path="$PLUGIN_ROOT/templates/$tpl"
  [ -f "$path" ] && ok "$tpl" || fail "$tpl — missing"
done

echo ""
echo "Scaffold comments"
for script in create-commit.sh commit-message.txt; do
  if grep -q "Scaffold:" "$PLUGIN_ROOT/scripts/$script" 2>/dev/null || \
     grep -q "Scaffold:" "$PLUGIN_ROOT/templates/$script" 2>/dev/null; then
    ok "$script has scaffold comment"
  else
    fail "$script missing scaffold comment"
  fi
done

echo ""
echo "Commit format consistency (template vs script)"
template_sections=$(grep -oE '\b(Why|State|Next|Active|Discovered|Open):' "$PLUGIN_ROOT/templates/commit-message.txt" | sort -u)
script_sections=$(grep -oE '\b(Why|State|Next|Active|Discovered|Open):' "$PLUGIN_ROOT/scripts/create-commit.sh" | sort -u)
if [ "$template_sections" = "$script_sections" ]; then
  ok "template and script sections match"
else
  fail "template and script sections diverged — update both"
  echo "    template: $(echo "$template_sections" | tr '\n' ' ')"
  echo "    script:   $(echo "$script_sections" | tr '\n' ' ')"
fi

echo ""
echo "Hook correctness (per-project hooks checked if present)"
PROJECT_ROOT=$(git -C "${PWD}" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$PROJECT_ROOT" ] && [ -f "$PROJECT_ROOT/.git/hooks/commit-msg" ]; then
  if grep -q '"\$1"' "$PROJECT_ROOT/.git/hooks/commit-msg"; then
    ok "commit-msg hook passes \$1 correctly"
  else
    fail "commit-msg hook does not pass \$1 — run /groundwork:setup to fix"
  fi
  if [ -x "$PROJECT_ROOT/.git/hooks/commit-msg" ]; then
    ok "commit-msg hook is executable"
  else
    fail "commit-msg hook is not executable"
  fi
  if [ -x "$PROJECT_ROOT/.git/hooks/post-commit" ]; then
    ok "post-commit hook is executable"
  else
    fail "post-commit hook is not executable"
  fi
else
  echo "  — no project hooks found (run /groundwork:setup in a project)"
fi

echo ""
echo "Self-test: read-context.sh"
if bash "$PLUGIN_ROOT/scripts/read-context.sh" > /dev/null 2>&1; then
  ok "read-context.sh runs cleanly"
else
  fail "read-context.sh exited with error"
fi

echo ""
echo "────────────────────────────────────────────────────────────────────────"
echo "  Passed: $pass   Failed: $fail"
echo ""

[ "$fail" -eq 0 ]
