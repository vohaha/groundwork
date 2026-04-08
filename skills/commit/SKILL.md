---
name: commit
description: Create a semantically structured git commit with Why, State, and optional context sections for AI continuity
disable-model-invocation: false
---

Create a structured git commit.

1. Run `git diff --staged` and `git status` to understand what's changing
2. If nothing is staged, determine what to stage based on context; ask if unclear
3. Determine the type and scope from the changes
4. Check if the staged changeset touches plugin surface area (`skills/*/SKILL.md`,
   `scripts/*.sh`). If yes, bump the version in both `.claude-plugin/plugin.json`
   and `.claude-plugin/marketplace.json` before committing, then stage those files:
   - New or removed `skills/*/SKILL.md` → minor bump (x.Y.0)
   - Any other surface area change → patch bump (x.y.Z)
   - Edit both files. The version field appears once in each.
5. Create the commit using ${CLAUDE_PLUGIN_ROOT}/scripts/create-commit.sh:
   - --type <type>          # feat | fix | refactor | docs | test | chore | session | decide
   - --summary "<summary>"  # concise, present tense
   - --why "<rationale>"    # the decision or constraint that drove this change
   - --next "<next action>" # what should happen after this
   - --scope "<scope>"      # optional: component or area
   - --active "<story>"     # optional: current story/epic
   - --before "<prior>"     # optional: what was happening before (the symptom, not the fix)
   - --rejected "<alts>"    # optional: approaches tried/considered and why they failed
   - --assumes "<deps>"     # optional: invariants this relies on; if broken, this breaks
   - --fragile "<gotchas>"  # optional: non-obvious things that look wrong but are intentional
   - --discovered "<text>"  # optional: non-obvious things found
   - --open "<questions>"   # optional: unresolved decisions

6. After committing, check WORKING_AGREEMENT.md for any Open Friction Points or
   Active Commitments that this work completes. If any are done, mark them `[x]`
   with a brief resolution note after `→` and save the file.

## When to use the context fields

- **Before** — use for fix and refactor commits. What was the user-visible behavior
  or code state before? The diff shows what changed; Before shows what was wrong.
- **Rejected** — use when you tried an approach and it didn't work, or deliberately
  chose against an obvious alternative. Future sessions will try the same thing
  without this. Include the reason it was rejected.
- **Assumes** — use when the change relies on something that isn't enforced by the
  code itself (e.g., "refresh tokens outlive access tokens", "this endpoint is
  idempotent", "config is loaded before this runs"). If the assumption breaks,
  the change breaks.
- **Fragile** — use when something looks like a bug but is intentional, or when
  there's a non-obvious coupling. Future Claude sessions will "helpfully" refactor
  this and break it without this field.

$ARGUMENTS
