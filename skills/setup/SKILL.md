---
name: setup
description: One-time per-project setup — installs git hooks and global commit template
disable-model-invocation: true
---

Install groundwork git integration for this project.

The plugin root is: ${CLAUDE_PLUGIN_ROOT}

Steps:

1. Install git hooks for the current project:

   Write .git/hooks/commit-msg with content:
   ```
   #!/usr/bin/env bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/validate-commit-msg.sh" "$1"
   ```

   Write .git/hooks/post-commit with content:
   ```
   #!/usr/bin/env bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/check-agreements.sh" "$PWD"
   ```

   Make both executable: chmod +x .git/hooks/commit-msg .git/hooks/post-commit

2. Install global commit message template (skip if already set):
   - Copy ${CLAUDE_PLUGIN_ROOT}/templates/commit-message.txt to ~/.gitmessage
   - Run: git config --global commit.template ~/.gitmessage

3. Report what was installed and any steps skipped.

$ARGUMENTS
