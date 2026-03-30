# CLAUDE.md — groundwork

## Session Start (every session)

Run to orient:

```
git log -3 --format="── %h ── %s ──%n%b"
git status --short
```

Read `State: / Next:` from the most recent commit — that's where we are.
Check WORKING_AGREEMENT.md for open items — surface them briefly before starting work.

## During Work

Commit at logical checkpoints using `/groundwork:commit`. Use structured format:

- `type(scope): summary`
- `Why:` — required, the decision and its reasoning
- `State: / Next:` — required, what comes after
- `Discovered:` — optional, non-obvious things found
- `Open:` — optional, unresolved questions

Types: `feat` | `fix` | `refactor` | `docs` | `test` | `chore` | `session` | `decide`

Commit autonomously during implementation. Use `/groundwork:commit` when the user needs to commit something manually.

## Session End

Run `/groundwork:check-in` — updates WORKING_AGREEMENT.md and creates the session checkpoint commit.

## Working Agreement

Update WORKING_AGREEMENT.md when:

- Something makes work harder → Open Friction Points
- Something works unusually well → What's Working
- We agree on a behavior change → Active Commitments
