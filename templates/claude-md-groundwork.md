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

Save non-obvious insights to memory autonomously — don't ask permission for
recoverable actions. Memory can be corrected or removed later.

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
- Priorities shift → Current Priorities (3 max, ordered — shapes all tradeoff decisions)

### Authority

Role-based (applies always):

- Commits, bug fixes, refactoring, doc updates: autonomous
- New scripts/skills, behavior changes: autonomous — note in commit message
- Removing features, format changes: autonomous — note in commit message what was removed/changed and why

To restrict, use path-scoped rules in `.claude/rules/` files with `paths:` frontmatter,
or `settings.json` `permissions.deny` to physically block file modifications.

<!-- groundwork:end -->
