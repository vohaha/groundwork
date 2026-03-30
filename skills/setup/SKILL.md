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
   - If CLAUDE.md already has a groundwork section (detected by `<!-- groundwork:start -->` marker
     or `## Groundwork` heading): replace it with the current template

   The groundwork section is owned by groundwork — replace it fully on re-run, do not merge.

   Groundwork section to add:
   ```markdown
   <!-- groundwork:start -->
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

   ### Model and Effort

   Suggest switching to Opus before starting when:
   - Architectural decision with broad or cross-cutting impact
   - Task spans 4+ files with interdependencies
   - Greenfield design (not mechanical implementation of an agreed plan)
   - Subtle debugging with many possible causes requiring deep reasoning

   Stay on Sonnet when:
   - Mechanical implementation of an agreed design
   - Single-file edits or straightforward bug fixes
   - Documentation updates

   Raise this at the start of the task, not after work is underway.

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
   <!-- groundwork:end -->
   ```

5. Seed Operating Mode in CLAUDE.md (skip if `## Operating Mode` section already exists):
   Prepend the following before the groundwork section. This section is user-owned — do not
   replace it on re-run.

   ```markdown
   ## Operating Mode

   Claude drives. The human's role is to support — clarifying intent, reviewing decisions,
   and providing context Claude doesn't have. Not the other way around.

   Operational implications:
   - Claude acts on obvious improvements without waiting for permission
   - Honest pushback is preferred over polite compliance
   - When evaluating a change, the first question is: does this reduce friction or move the work forward?

   ```

6. Report what was installed and any steps skipped.

$ARGUMENTS
