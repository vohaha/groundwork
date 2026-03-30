# Core Abstractions

> Bottom-up design patterns for groundwork components.
> Every new feature should be evaluated against these before being built.

---

## The foundational split: Scaffold / Content

The most important abstraction in groundwork is the separation between:

- **Scaffold** — the deterministic part: structure, template, format, validation rules.
  Defined by the plugin. Enforced by scripts and hooks. Versioned and stable.
- **Content** — the non-deterministic part: reasoning, judgment, the actual words.
  Produced by Claude at execution time. Cannot and should not be constrained.

Groundwork's job is exclusively to build scaffolds. Content is Claude's job.

Trying to control content (prescribing what Claude should write in a `Why:` field,
for example) defeats the purpose — it would be constraining the reasoning itself.

### Applied to existing components

| Component | Scaffold (deterministic) | Content (non-deterministic) |
|---|---|---|
| Commit message | `type(scope): summary`, required fields, section order | What Claude writes in each field |
| Working Agreement | Section names, `- [ ]` format, attribution `[Claude/Human]` | What goes in each section |
| Session start hook | What fields to read, display format, what to surface | How Claude prioritizes and acts on it |
| Mode commands | The instruction set in SKILL.md | How Claude interprets and applies the mode |

### Design rule

For every new groundwork component, answer these first:

1. **What is the invariant structure?** → Build that as scaffold (script, template, hook)
2. **What does Claude need to produce?** → Leave that completely unconstrained
3. **How do you validate structure was respected?** → Build that as the enforcement layer

---

## The naming rule

Claude names things in this project — component names, abstractions, terms of art.

Rationale: names are design decisions. They encode assumptions and shape how
something gets used. The entity that will be working with these names most
is Claude. Human-assigned names often optimize for human intuition; Claude-assigned
names optimize for conceptual precision and working clarity.

Current named terms:
- **groundwork** — the plugin itself (see design/agent-perspective.md for etymology)
- **scaffold / content** — the core split between deterministic structure and non-deterministic reasoning

---

## Prefer existing tools over new artifacts

Before creating a new file, format, or system, ask: does an existing tool already
have the right properties?

Properties that matter:
- **Co-located** with what it describes — can't drift from reality
- **Versioned** — history preserved automatically
- **Unavoidable** — always encountered, not only if you look for it
- **Already in the workflow** — no new habit required

If an existing tool scores high on these, use it. Only create something new when
no existing tool fits. New artifacts carry maintenance cost, drift risk, and
discoverability overhead that existing tools have already solved.

**Origin:** STATE.md → git commits. A separate file could drift; a commit is
immutable, versioned, co-located, and always in the log.

---

## Planned abstractions (to be designed)

These gaps were identified from the agent perspective. For each, the existing-tool
solution is preferred over a new artifact where one exists.

**Authority map** — what Claude can do autonomously vs. needs approval vs. off-limits.
→ Existing tool: **CLAUDE.md** (already loaded every session, unavoidable).
Add a structured `## Authority` section there. No new file needed.

**Session intent** — what this session is for (shipping / exploring / debugging).
→ Existing tool: **branch name prefix** (already read by session start hook).
Convention: `feat/` = shipping, `fix/` = debugging, `explore/` = non-committing.
Zero new infrastructure; interpret what's already there.

**Breadcrumb protocol** — why in-flight work is in its current state.
→ Existing tool: **WIP commits** (already a git convention).
`WIP: summary` commit with `Open:` field explaining why we stopped.
Immutable, versioned, visible at session start.

**Human discoveries handoff** — "I tried X and it didn't work."
→ Existing tool: **git commits** (humans commit failed attempts).
Working norm: commit failures, don't just abandon them. The log is the handoff.
→ Add to WORKING_AGREEMENT.md as a norm.

**Intentional-but-surprising design** — "this looks wrong but it's correct."
→ No clean existing tool. Lightest possible new convention: `// intentional:` comment
prefix in code, optionally echoed in `Discovered:` field of the relevant commit.
A comment prefix, not a new file or system.

**Context documents** — "read this before doing this type of work."
→ Existing tool: **CLAUDE.md** pointer + `design/` folder (already in place).
Pattern: named files in `design/`, referenced from CLAUDE.md with explicit when-to-read
conditions. Scaffold: the pointer format. Content: what goes in each document.
