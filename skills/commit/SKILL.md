---
name: commit
description: Create a semantically structured git commit with Why, State, and optional Discovered/Open sections
disable-model-invocation: false
---

Create a structured git commit.

1. Run `git diff --staged` and `git status` to understand what's changing
2. If nothing is staged, determine what to stage based on context; ask if unclear
3. Determine the type and scope from the changes
4. Create the commit using ${CLAUDE_PLUGIN_ROOT}/scripts/create-commit.sh:
   - --type <type>          # feat | fix | refactor | docs | test | chore | session | decide
   - --summary "<summary>"  # concise, present tense
   - --why "<rationale>"    # the decision or constraint that drove this change
   - --next "<next action>" # what should happen after this
   - --scope "<scope>"      # optional: component or area
   - --active "<story>"     # optional: current story/epic
   - --discovered "<text>"  # optional: non-obvious things found
   - --open "<questions>"   # optional: unresolved decisions

$ARGUMENTS
