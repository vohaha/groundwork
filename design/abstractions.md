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

## Planned abstractions (to be designed)

These gaps were identified from the agent perspective. Each needs a scaffold designed
before it can be implemented.

**Authority map** — explicit declaration of what Claude can do autonomously vs. needs
approval vs. is off-limits. Scaffold: categories + format for declaring items.
Content: Claude's application of those rules to unlisted edge cases.

**Session intent** — structured declaration at session start of what this session is
for (shipping / exploring / debugging / thinking). Scaffold: the format and valid modes.
Content: Claude's behavior changes given the declared intent.

**Breadcrumb protocol** — convention for leaving "why this is in this state" notes for
in-flight work that isn't yet committed. Scaffold: the format and placement convention.
Content: what Claude writes in them.

**Human discoveries handoff** — structured way to pass "what I already tried" at
task handoff. Counterpart to `Discovered:` in commits. Scaffold: the input format.
Content: what the human provides.

**Context documents** — a general mechanism for declaring "read this before doing
this type of work." The current `design/` folder + CLAUDE.md pointer is the first
instance. The pattern: files that scope and gate specific modes of work, referenced
from CLAUDE.md with explicit "when to read" conditions. Scaffold: naming convention
and the CLAUDE.md pointer format. Content: what goes in each context document.
