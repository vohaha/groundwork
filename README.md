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

Installs everything needed:
- `.git/hooks/commit-msg` — warns on missing `Why:`
- `.git/hooks/post-commit` — surfaces open agreement items after each commit
- `~/.gitmessage` — global commit template (skipped if already set)
- `WORKING_AGREEMENT.md` — created from template (skipped if already exists)
- `CLAUDE.md` — groundwork section added (skipped if already present)

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

## Why this exists

Most AI tooling is designed for the human, with the AI as a component. Groundwork was designed by asking the AI what it needs, then building that.

**The problems it solves:**

- **Cross-session amnesia** — Claude arrives each session without knowing where things are. Fresh readable state is more reliable than memory that can drift.
- **Confabulation risk** — Claude can't always distinguish accurate recall from confident guessing. Decisions written to files at the moment they're made are more reliable than conversation memory.
- **Feedback asymmetry** — Claude only hears corrections, not confirmations. Without actively recording what works, good approaches get abandoned.
- **Mode inference overhead** — Without explicit signals, Claude spends cognitive resources guessing whether to execute, explore, or discuss.
- **Unknown unknowns** — Claude doesn't know what changed. `Discovered:` in commits captures non-obvious findings at the exact moment they're found.

**The core principle:**

> State should be co-located with the artifacts it describes, captured at the moment of creation.

Git commits are the natural boundary. A code change recorded alongside its rationale and next state can't drift from the code it describes. Separate documentation files, memory systems, and conversation history all can — and do.

**What this means in practice:**

`git log` becomes a decision ledger Claude can read at session start. Not just "what changed" but "why it changed, what was non-obvious, and what comes next." The working agreement captures the relational norms that git history doesn't. The mode commands eliminate the biggest source of inference overhead. Together, they turn a stateless tool interaction into something closer to a persistent working relationship.

## Development

```bash
claude --plugin-dir ~/groundwork
```

## License

MIT
