# Working Agreement — groundwork

> Two-way contract between Claude and the human.
> `- [ ]` items are tracked by the enforcement script — these are one-time actions to establish.
> Ongoing behaviors live in Working Norms — no checkbox, standing contract terms.
> Either party can add to any section during a session.

---

## Current Priorities
<!-- 3 items max, ordered. What matters most right now. -->
<!-- Claude reads this at session start — shapes judgment calls about effort, scope, and tradeoffs. -->
<!-- Update when priorities shift. Empty = Claude can't make tradeoff decisions. -->

1. Test autonomy norms (Phase 1-3) over next few sessions — groundwork v0.1.0
2. Client project setup — verify `/groundwork:setup` end-to-end in game1
3. —

## Open Friction Points

<!-- What makes work harder — add when you notice it, either party -->
<!-- Format: - [ ] [Claude/Human] Description — YYYY-MM-DD -->

## Active Commitments

<!-- One-time actions needed to establish something new — check off when done -->
<!-- Format: - [ ] [Claude/Human] What — YYYY-MM-DD -->

- [ ] [Claude/Human] Review autonomy norms — are self-verification, request intake, self-escalation, and priority context working? Decide: keep as norms, adjust, or automate — 2026-04-03

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
- [Claude] Recoverable mistakes are acceptable — commit before changing direction so reasoning is visible
- [Claude] For non-trivial tasks, may ask for outcome/acceptance criteria before starting — human can skip
- [Claude] Self-escalate from do→think when uncertain mid-execution — flag it visibly, don't forge ahead
- [Human] Commit failed attempts before abandoning them — the git log is the handoff; Claude won't know what was already tried otherwise
- [Human/Claude] WIP commits use `WIP: summary` format with an `Open:` field explaining why work is stopped — breadcrumb for the next session
- [Human/Claude] Mark intentional-but-surprising code with `// intentional: reason` comment — distinguishes deliberate oddity from bugs

## What's Working

<!-- Non-obvious things worth repeating — helps Claude's asymmetric feedback problem -->

- "Analyze build-planner, then improve groundwork" — using a real client project as the lens for plugin improvements found bugs no amount of self-inspection would (the "" hook bug, validate checking existence but not content)
- Client agent feedback → groundwork norms: the build-planner agent's session reflection surfaced two patterns (parallel exploration, autonomous memory) that became groundwork defaults. The feedback loop from client→plugin is a real improvement channel.
- Giving the "why" behind tasks → Claude makes much better decisions
- Mode persistence via `UserPromptSubmit` hook → mode set once, injected as system reminder every prompt; no repetition needed
- Designing tooling by asking Claude what it needs, then building that → bilateral workflow
- Git semantic commits as cognitive prosthetic → session orientation without extra docs
- Claude reading the full codebase before forming opinions — no proposals based on partial reads
- `/groundwork:think` before `/groundwork:do` for anything non-trivial → catches design errors early
- "Use existing tools" check before building anything new → prevented several unnecessary artifacts this session
- Live session test (new session, role question) → confirmed mode transfer actually works
- `/groundwork:think` → `/groundwork:plan` → `/groundwork:do` flow in a single session → clean execution, no backtracking
- Brainstorming autonomy improvements by asking Claude what it needs → produced 7 concrete items, most are zero-cost norm changes
- Human pushing "automate the human check" instinct → keeps groundwork honest about automation-first principle

## Last Check-in

- Date: 2026-03-31
- Notes: Hardened setup/validate pipeline (5 fixes). Added autonomous memory saving and parallel exploration as default norms. Both sourced from client agent feedback.

---

## Resolved

<!-- Archive — move closed [x] items here -->

- [x] Fix commit-msg hook passing "" instead of $1 — 2026-03-30
- [x] Create templates/working-agreement.md — 2026-03-30
