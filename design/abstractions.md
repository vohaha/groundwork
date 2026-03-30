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

## Automate everything possible

If a norm requires human discipline to maintain, it will fail. If automation can
enforce it, automation must enforce it.

The test for any groundwork feature: can a human skip or forget this? If yes, is
there a hook, script, or check that makes skipping impossible or immediately visible?

Hooks and scripts are always preferred over documented norms for behaviors that must
be consistent. Norms are for things that genuinely cannot be automated — judgment,
reasoning, communication style.

**Applied:** session start hook (orientation), post-commit hook (agreement surfacing),
commit-msg hook (Why: validation), setup creating WORKING_AGREEMENT.md and CLAUDE.md.

**Not yet applied:** branch naming convention (planned), WIP commit protocol (norm only).

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

## Principle priority ordering

When principles conflict, apply them in this order:

1. **Scaffold/content** — most fundamental (defines what groundwork IS)
2. **Prefer existing tools** — how to implement (don't create new artifacts)
3. **Automate everything possible** — execution quality (enforce over document)

Example conflict: an existing tool doesn't automate something. Build a new automated
tool (violates prefer-existing-tools) or use the existing tool with a documented norm
(violates automate-everything)? Answer: prefer-existing-tools wins — add automation
to the existing tool rather than creating a parallel new one.

---

## Minimal sufficient context

Every addition to the session start hook, CLAUDE.md, or any always-loaded context
must pass this test: **if Claude sees this, does it change what Claude does?**

If the answer is no — if it's informational but doesn't affect behavior — it doesn't
belong in persistent context. It belongs in a document Claude reads on demand.

The risk of violating this: context accumulates until signal is buried in noise.
Each individual addition seems valuable; collectively they degrade orientation quality.

---

## Automation reliability threshold

Automation must be reliable or silent. A fragile automation that fails with noise
is worse than a documented norm.

Rules:
- If a script can fail, it must exit 0 and warn — never block (see validate-commit-msg.sh)
- If a hook fails silently, it adds no value — test it
- Prefer a weaker automation that always works over a stronger one that sometimes breaks
- When in doubt, make it non-blocking first; upgrade to blocking after proven reliable

---

## Feature audit checklist

Run this mentally for any new or changed groundwork feature:

1. Is the scaffold (structure) separate from the content (reasoning)? → scaffold/content
2. Is there an existing tool that already has co-located, versioned, unavoidable, in-workflow properties? → prefer-existing-tools
3. Can a human skip or forget this? If yes, is there automation? → automate-everything
4. Does every addition to persistent context change Claude's behavior? → minimal-context
5. If this automation can fail, does it fail silently/non-blocking? → reliability threshold
6. Does `groundwork:validate` pass after the change?

---

## Planned abstractions (to be designed)

These gaps were identified from the agent perspective. For each, the existing-tool
solution is preferred over a new artifact where one exists.

**Authority map** ✓ — implemented as `## Authority Map` section in CLAUDE.md.

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
