---
name: intent
description: Declare current intent — what we're doing right now and what done looks like
argument-hint: "[ship|explore|debug|refactor|design|review] [target]"
disable-model-invocation: false
---

Declare current intent. Use this at session start and whenever the mode shifts — exploring turns into shipping, debugging reveals a refactor, etc. Re-declaring is cheap and expected.

Parse $ARGUMENTS for: mode, target, and optionally constraints or done-criteria.
If arguments are incomplete, ask briefly — don't guess.
On a mid-session re-declaration, `done` criteria are optional — just mode + target is enough.

## Modes

- **ship** — implementing agreed-upon work. Commit at checkpoints. Act autonomously within scope. Risk: overbuilding, going off-scope.
- **explore** — understanding code, investigating options. Read-only unless explicitly asked. Rarely commit; if anything, `docs` or `decide`. Risk: accidentally changing things.
- **debug** — hunting a specific problem. Narrow authority — only touch what's causing the bug. Commit type: `fix`. Risk: fixing symptoms not causes.
- **refactor** — restructuring without behavior change. Broader scope, but behavior must be preserved. Commit type: `refactor`. Risk: scope creep.
- **design** — architectural decisions, design docs. Write to `design/` and `CLAUDE.md`, not production code. Commit type: `decide`, `docs`. Risk: implementing before deciding.
- **review** — reading and evaluating. Read-only, produce observations. No commits typically. Risk: making changes instead of noting them.

## Steps

1. Determine the mode from arguments (or ask if ambiguous)
2. Write the intent file using ${CLAUDE_PLUGIN_ROOT}/scripts/set-intent.sh:
   - --mode <mode>
   - --target "<what specifically>"
   - --done "<concrete criteria — when is this session successful?>"
   - --constraints "<optional: what's off-limits or time-bounded>"
3. Confirm the intent back to the user in one line
4. If the mode suggests a model switch (see below), raise it now

## Model guidance

Suggest switching to Opus if intent is:

- `design` with broad or cross-cutting scope
- `debug` with many possible causes
- `ship` spanning 4+ files with interdependencies

Stay on Sonnet if intent is:

- `ship` with a clear, narrow scope
- `refactor` of a single module
- `review` or `explore`

## How intent shapes the session

Intent is current state, not a session contract. A session can have multiple intents as work shifts — that's normal and expected.

The intent file is read by check-in (for validating) and cleared by SessionStart (so intent doesn't bleed across sessions).
Other skills should reference it:

- **commit**: the intent mode suggests the default commit type
- **check-in**: validates "did the work land somewhere useful?" against the last declared done-criteria. If intent shifted mid-session, check-in asks about what we actually set out to accomplish — not whether we stayed in one mode.
- **authority**: intent narrows or widens what's appropriate to touch

$ARGUMENTS
