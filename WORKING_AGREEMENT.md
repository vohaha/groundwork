# Working Agreement — groundwork

> Two-way contract between Claude and the human.
> `- [ ]` items are tracked by the enforcement script — these are one-time actions to establish.
> Ongoing behaviors live in Working Norms — no checkbox, standing contract terms.
> Either party can add to any section during a session.

---

## Open Friction Points

<!-- What makes work harder — add when you notice it, either party -->
<!-- Format: - [ ] [Claude/Human] Description — YYYY-MM-DD -->

## Active Commitments

<!-- One-time actions needed to establish something new — check off when done -->
<!-- Format: - [ ] [Claude/Human] What — YYYY-MM-DD -->

## Working Norms

<!-- Ongoing behaviors — no checkbox. Move here from Active Commitments once established. Remove if no longer relevant. -->

- [Human] Use `/groundwork:check-in` at session end
- [Human] Signal mode at session start with `/do`, `/think`, or `/plan` — mode persists across prompts until changed or session ends
- [Human] Surface human compliance risks — if a proposed norm requires discipline to maintain, say so; Claude will redesign to automate instead
- [Claude] Diagnose full plugin state before proposing changes
- [Claude] Fixes and gaps first, improvements second
- [Claude] When noting friction, be specific: exact moment + what would have helped, not just "that was confusing"
- [Claude] When presenting options, lead with the preferred variant and state why — don't make the human extract the recommendation
- [Claude] Reject ideas that don't genuinely reduce Claude's friction — honest rejection preferred over polite implementation
- [Human] Commit failed attempts before abandoning them — the git log is the handoff; Claude won't know what was already tried otherwise
- [Human/Claude] WIP commits use `WIP: summary` format with an `Open:` field explaining why work is stopped — breadcrumb for the next session
- [Human/Claude] Mark intentional-but-surprising code with `// intentional: reason` comment — distinguishes deliberate oddity from bugs

## What's Working

<!-- Non-obvious things worth repeating — helps Claude's asymmetric feedback problem -->

- Giving the "why" behind tasks → Claude makes much better decisions
- Mode persistence via `UserPromptSubmit` hook → mode set once, injected as system reminder every prompt; no repetition needed
- Designing tooling by asking Claude what it needs, then building that → bilateral workflow
- Git semantic commits as cognitive prosthetic → session orientation without extra docs
- Claude reading the full codebase before forming opinions — no proposals based on partial reads
- `/groundwork:think` before `/groundwork:do` for anything non-trivial → catches design errors early
- "Use existing tools" check before building anything new → prevented several unnecessary artifacts this session
- Live session test (new session, role question) → confirmed mode transfer actually works
- `/groundwork:think` → `/groundwork:plan` → `/groundwork:do` flow in a single session → clean execution, no backtracking

## Last Check-in

- Date: 2026-03-30
- Notes: Removed branch format warning — convention adds friction for pet projects that work on main with no feature branches. Branch naming stays optional; ⚠ state removed entirely. do/think/plan modes confirmed sufficient for cognitive overhead without needing work-type dimension.

---

## Resolved

<!-- Archive — move closed [x] items here -->

- [x] Fix commit-msg hook passing "" instead of $1 — 2026-03-30
- [x] Create templates/working-agreement.md — 2026-03-30
