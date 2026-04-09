---
name: check-in
description: Session end ritual — update working agreement and create session checkpoint commit
disable-model-invocation: false
---

Session check-in. We are wrapping up.

0. If `~/.claude/groundwork-intent` exists, read it. Sessions may have shifted through
   multiple modes — evaluate whether the work landed somewhere useful overall, not whether
   we stayed in one mode.
   - If `done:` criteria exist, compare against what was actually accomplished:
     - **Fully met** — proceed normally.
     - **Partially met** — surface unmet criteria as `--open` in the session commit
       and add them to Open Friction Points in WORKING_AGREEMENT.md.
     - **Not started** — note it in the session commit `--open`; don't manufacture
       progress. The intent file is cleared at the next session start regardless.
   - If no `done:` criteria (e.g. intent was re-declared mid-session without them),
     ask one question: "Did the session accomplish what you set out to do?" and proceed.
1. Read WORKING_AGREEMENT.md
2. Update it:
   - Mark completed Open Friction Points and Active Commitments as `[x]` — include a short resolution note after `→`
   - Any friction from this session → Open Friction Points
   - Anything that worked unusually well → What's Working
   - Any new agreements made → Active Commitments
   - Update Last Check-in date and notes
3. Write non-obvious understanding from this session to auto-memory —
   not what you did, but what you now understand that isn't obvious from
   the code or git history
3b. If domain understanding deepened this session (new terms, concepts, or
   decisions a future session would need), update the `## Domain` section
   in CLAUDE.md. Keep it concise — only what changes behavior.
4. Stage all modified tracked files (git add)
5. Create a session commit using ${CLAUDE_PLUGIN_ROOT}/scripts/create-commit.sh:
   - --type session
   - --summary "YYYY-MM-DD — <brief phrase: what this session accomplished>"
   - --why "<one sentence: what this session accomplished>"
   - --next "<the most important next action>"
   - --active "<current story/epic if applicable>"
   - --discovered "<non-obvious things found — omit if none>"
   - --open "<unresolved questions — omit if none>"
6. Summarize briefly: what we did, what is open, what is next
7. Ask: "Anything you noticed that should go in the agreement?"
