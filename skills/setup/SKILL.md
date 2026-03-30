---
name: setup
description: One-time per-project setup — installs git hooks, commit template, WORKING_AGREEMENT.md, and CLAUDE.md
disable-model-invocation: true
---

Install groundwork git integration for this project.

The plugin root is: ${CLAUDE_PLUGIN_ROOT}

Steps:

1. Install git hooks for the current project:

   Write .git/hooks/commit-msg with content:
   ```
   #!/usr/bin/env bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/validate-commit-msg.sh" "$1"
   ```

   Write .git/hooks/post-commit with content:
   ```
   #!/usr/bin/env bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/check-agreements.sh" "$PWD"
   ```

   Make both executable: chmod +x .git/hooks/commit-msg .git/hooks/post-commit

2. Install global commit message template (skip if already set):
   - Copy ${CLAUDE_PLUGIN_ROOT}/templates/commit-message.txt to ~/.gitmessage
   - Run: git config --global commit.template ~/.gitmessage

3. Create WORKING_AGREEMENT.md at the project root (skip if already exists):
   - Copy ${CLAUDE_PLUGIN_ROOT}/templates/working-agreement.md to ./WORKING_AGREEMENT.md
   - Replace `[project]` in the header with the actual project name (use the directory name if unsure)

4. Create or update CLAUDE.md:
   - If no CLAUDE.md exists: create it with the groundwork section below
   - If CLAUDE.md exists but has no groundwork section: append the section below
   - If CLAUDE.md already has a groundwork section: skip

   Groundwork section to add:
   ```markdown
   ## Groundwork

   ### Session Start

   Orientation is handled automatically by the groundwork `SessionStart` hook —
   the session start box contains branch, last commit, trajectory, open questions,
   uncommitted count, and agreement item count.

   Check `WORKING_AGREEMENT.md` if there are open items.

   ### During Work

   Commit at logical checkpoints with `/groundwork:commit`.

   Format: `type(scope): summary` + `Why:` (required) + `State:/Next:` (required)
   Optional: `Discovered:` (non-obvious findings) | `Open:` (unresolved questions)
   Types: `feat` | `fix` | `refactor` | `docs` | `test` | `chore` | `session` | `decide`

   Commit autonomously. The commit message IS the state — don't defer commits.

   ### Session End

   Run `/groundwork:check-in` — updates WORKING_AGREEMENT.md and creates checkpoint commit.

   ### Working Agreement

   Update WORKING_AGREEMENT.md when:
   - Something makes work harder → Open Friction Points
   - Something works unusually well → What's Working
   - We agree on a behavior change → Active Commitments

   ### Authority

   Role-based (applies always):
   - Commits, bug fixes, doc updates: autonomous
   - New scripts/skills, behavior changes: needs approval
   - Removing features, format changes: discuss first

   Path-scoped authority (optional, add as needed):
   Use `.claude/rules/` files with `paths:` frontmatter for area-specific rules.
   These only load when working on matching files — no context overhead otherwise.
   Example: `.claude/rules/auth.md` with `paths: ["src/auth/**"]` → "style only".

   Hard enforcement (optional):
   Use `settings.json` `permissions.deny` to physically block file modifications.
   ```

5. Report what was installed and any steps skipped.

$ARGUMENTS
