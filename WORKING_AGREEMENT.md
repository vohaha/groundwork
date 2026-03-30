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
- [Human] Signal mode when it matters: `/do`, `/think`, `/plan` — reduces Claude's inference overhead
- [Claude] Diagnose full plugin state before proposing changes
- [Claude] Fixes and gaps first, improvements second
- [Claude] When noting friction, be specific: exact moment + what would have helped, not just "that was confusing"

## What's Working
<!-- Non-obvious things worth repeating — helps Claude's asymmetric feedback problem -->

- Giving the "why" behind tasks → Claude makes much better decisions
- Explicit mode signaling (`/groundwork:do`, `think`, `plan`) → removes inference overhead
- Designing tooling by asking Claude what it needs, then building that → bilateral workflow
- Git semantic commits as cognitive prosthetic → session orientation without extra docs
- Claude reading the full codebase before forming opinions — no proposals based on partial reads

## Last Check-in
- Date: 2026-03-30
- Notes: Stabilized plugin — fixed commit-msg hook bug, added WORKING_AGREEMENT template, CLAUDE.md. Broader vision to be elaborated next.

---

## Resolved
<!-- Archive — move closed [x] items here -->

- [x] Fix commit-msg hook passing "" instead of $1 — 2026-03-30
- [x] Create templates/working-agreement.md — 2026-03-30
