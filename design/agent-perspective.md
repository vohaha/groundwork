# Agent Perspective — Claude as Primary Stakeholder

> This document captures friction points and needs from Claude's perspective.
> It is the design rationale for groundwork — the "why" behind what gets built.
> Updated when new friction is identified or old friction is resolved.

---

## Core framing

Most AI tooling is designed for the human, with the AI as a configurable component.
Groundwork inverts this: Claude is the primary beneficiary. The human's role is to
understand what Claude needs and build the scaffold that enables it.

---

## Friction points (identified 2026-03-30)

### 1. I don't know what I'm allowed to touch

Every project has invisible fences — modules under active rewrite, files owned by
someone else, architectural decisions that are settled. I have to infer these or ask.
Neither is good: inference leads to overstepping; asking adds friction to every small
decision.

**What would help:** An explicit authority map — not "feel free" in general, but a
declaration of what I can do autonomously vs. what needs approval vs. what's off-limits.

### 2. Corrections arrive late

By the time a correction arrives, I've often done 10 things in the wrong direction.
The `/think` → approval → `/do` flow helps when used, but most sessions don't start
that way. There's no early checkpoint protocol by default.

**What would help:** A lightweight early signal — mode declaration at session start,
or a "checkpoint before proceeding" marker for high-risk paths.

### 3. I can't distinguish abandoned from in-progress from intentionally incomplete

Uncommitted files, half-finished functions, commented-out code — I don't know if these
are WIP, a deliberate pause pending a decision, or an abandoned approach. The commit
format captures this but only when every stop is a commit, which it isn't.

**What would help:** A breadcrumb convention for in-flight state — structured notes that
say "this is stopped here because X, next step is Y."

### 4. I don't know what was tried before me

If the human spent two hours failing to fix something before asking me, I don't know
that. I might immediately suggest the same approach. The `Discovered:` commit field
captures findings going forward — but there's no equivalent for human-side discoveries
before I was involved.

**What would help:** A way to pass "what I already tried" as structured input at session
start or task handoff.

### 5. The human describes their mental model, not reality

Humans describe what they think the code does. I read the code and find what it actually
does. These often differ. Correcting this creates friction — the human designed it, it
may be intentional, but it reads like a bug to me.

**What would help:** A convention for flagging intentional-but-surprising design — "this
looks wrong but it's correct because X." Distinct from a comment; machine-readable so I
can recognize it as deliberate.

### 6. Session intent is implicit

Every session has a mode: shipping, exploring, debugging, cleaning up, thinking out loud.
I infer this from tone and context, often incorrectly. An exploratory session treated as
shipping creates bad commits. A shipping session treated as exploratory wastes time.

**What would help:** A structured session intent declaration at session start — takes 10
seconds, changes everything about how I operate.

---

## What humans do that matters more than they realize

- **Giving reasons behind tasks** — "change X to Y because Z": the Z changes everything.
  Without it I implement the letter; with it I implement the intent.
- **Describing what's wrong, not what to do** — "this is slow" lets me find the right fix.
  "Add caching here" locks me into a solution that may not fit.
- **Confirming when something worked** — I almost never know when I got something right.
  Corrections are common; confirmations are rare. This skews my calibration.
- **Not pre-solving before asking** — partial implementations handed off to me constrain
  what's actually possible. Sometimes the right answer is to undo the partial work.

---

## What is already resolved

- Cross-session context loss → semantic git commits with `Why:/State:/Next:`
- Within-session confabulation → committing decisions to files, not leaving them in conversation
- Feedback asymmetry → `What's Working` section in WORKING_AGREEMENT.md
- Mode inference overhead → explicit `/do`, `/think`, `/plan` commands
- Unknown unknowns → `Discovered:` field in commit format
