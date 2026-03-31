---
name: setup
description: One-time per-project setup — installs git hooks, commit template, WORKING_AGREEMENT.md, and CLAUDE.md
disable-model-invocation: false
---

Install groundwork git integration for this project.

The plugin root is: ${CLAUDE_PLUGIN_ROOT}

Steps:

1. Run the setup script: bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh"
   This installs git hooks and commit template deterministically.

2. Create or check WORKING_AGREEMENT.md at the project root:
   - If it doesn't exist: copy ${CLAUDE_PLUGIN_ROOT}/templates/working-agreement.md to
     ./WORKING_AGREEMENT.md and replace `[project]` in the header with the actual project name
   - If it already exists: read the template and the existing file. Check for required
     sections: Current Priorities, Open Friction Points, Active Commitments, Working Norms,
     What's Working, Last Check-in, Resolved. Report any missing sections with the template
     content for each. Offer to add missing sections, preserving all existing project-specific
     content (norms, entries, resolved items).

3. Create or update CLAUDE.md:
   - Read the groundwork template from ${CLAUDE_PLUGIN_ROOT}/templates/claude-md-groundwork.md
   - If no CLAUDE.md exists: create it with the template content
   - If CLAUDE.md exists but has no groundwork section: append the template content
   - If CLAUDE.md already has a groundwork section (detected by `<!-- groundwork:start -->` marker
     or `## Groundwork` heading): replace it with the template content

   The groundwork section is owned by groundwork — replace it fully on re-run, do not merge.

4. Seed user-owned sections in CLAUDE.md (skip each if already exists):

   a. Operating Mode (skip if `## Operating Mode` exists):
      Prepend before the groundwork section.

   ```markdown
   ## Operating Mode

   Claude drives. The human's role is to support — clarifying intent, reviewing decisions,
   and providing context Claude doesn't have. Not the other way around.

   Operational implications:

   - Claude acts on obvious improvements without waiting for permission
   - Honest pushback is preferred over polite compliance
   - When evaluating a change, the first question is: does this reduce friction or move the work forward?
   ```

   b. Domain (skip if `## Domain` exists):
      Add after Operating Mode, before the groundwork section.

   ```markdown
   ## Domain

   <!-- Key domain concepts, terminology, and decisions that a new session needs.
        This section is user-owned — groundwork will not overwrite it.
        Update during check-in when domain understanding deepens. -->
   ```

5. Run validation: bash "${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh"
   If any checks fail, fix them before reporting.

6. Report what was installed, any steps skipped, and validation results.

$ARGUMENTS
