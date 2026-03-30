---
name: help
description: Brief usage guide for the groundwork plugin — what it is, how to use it, available commands
disable-model-invocation: true
---

Print the following groundwork usage guide:

---

## Groundwork

Groundwork gives Claude stable context and a two-way working agreement.
It was designed by asking Claude what it needs — Claude is the primary beneficiary.
Your role is to run the right commands and keep the working agreement current.

### Setup (once per project)

```
/groundwork:setup
```

Installs git hooks, creates WORKING_AGREEMENT.md and CLAUDE.md.

### During a session

Signal your intent before giving Claude a task:

| Command | When to use |
|---|---|
| `/groundwork:do <task>` | You want it done, no discussion |
| `/groundwork:think <topic>` | You want options explored, nothing changed |
| `/groundwork:plan <task>` | You want a design to approve before execution |

### At session end

```
/groundwork:check-in
```

Updates WORKING_AGREEMENT.md and creates a checkpoint commit. Run this before closing.

### Other commands

| Command | What it does |
|---|---|
| `/groundwork:commit` | Create a structured commit manually |
| `/groundwork:validate` | Check that groundwork is set up correctly |
| `/groundwork:help` | Show this guide |

### Working Agreement

`WORKING_AGREEMENT.md` is a two-way contract. Add to it when:
- Something makes work harder → **Open Friction Points**
- Something works well → **What's Working**
- You agree on a behavior → **Active Commitments** (then **Working Norms** once established)

Claude reads it every session. Keep it current.

### Authority

For path-scoped rules ("only style changes in auth/"): use `.claude/rules/` files with `paths:` frontmatter — these load only when relevant.

For hard blocks: use `settings.json` `permissions.deny`.

---

$ARGUMENTS
