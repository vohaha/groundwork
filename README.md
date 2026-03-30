# groundwork

Stable context and two-way working agreements for AI-assisted development.

Gives Claude ground to stand on: orientation at session start, semantic git history, enforced working agreements, and explicit mode commands.

## What it does

**Session start** — `SessionStart` hook runs `read-context.sh`: shows current branch, last commit state, next action, and open items. Claude is oriented before the first message.

**Session end** — `Stop` hook runs `check-agreements.sh`: surfaces open `- [ ]` items from `WORKING_AGREEMENT.md`. Reminds you to check in.

**Semantic git** — Every commit captures `Why:` (decision rationale), `State: Next:` (what comes after), and optionally `Discovered:` and `Open:`. Git log becomes a decision ledger Claude can read.

**Working agreement** — `WORKING_AGREEMENT.md` is a two-way contract: open friction points, active commitments, working norms, what's working.

**Mode commands** — explicit invocation prevents inference overhead:
- `/groundwork:do` — execute, no discussion
- `/groundwork:think` — explore options, touch nothing
- `/groundwork:plan` — design approach, wait for sign-off
- `/groundwork:check-in` — session end ritual + checkpoint commit
- `/groundwork:commit` — create a structured commit
- `/groundwork:setup` — one-time per-project git hook installation

## Setup

### Per project (run once)

```
/groundwork:setup
```

Installs `.git/hooks/commit-msg` (warns on missing `Why:`) and `.git/hooks/post-commit` (surfaces open agreement items). Also installs `~/.gitmessage` global commit template.

### Add to your project

Create `WORKING_AGREEMENT.md` at the project root. See template in `templates/working-agreement.md`.

Add to `CLAUDE.md`:

```markdown
## Session Start
At session start: run `git log -3 --format="%B"` and `git status` to orient.
Read `State: / Next:` from the most recent commit.
Check WORKING_AGREEMENT.md for open items — surface them before starting work.

## Commits
Commit autonomously at logical checkpoints. Use `groundwork:commit` for structured messages.
Use `groundwork:check-in` at session end.
```

## Commit format

```
type(scope): summary

Why:
The decision, reasoning, or constraint.

State:
Next: what should happen next
Active: current story/epic (optional)

Discovered:
Non-obvious things found (optional)

Open:
Unresolved questions (optional)
```

Types: `feat` | `fix` | `refactor` | `docs` | `test` | `chore` | `session` | `decide`

## Development

```bash
claude --plugin-dir ~/groundwork
```

## License

MIT
