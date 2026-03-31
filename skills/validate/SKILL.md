---
name: validate
description: Run structural validation checks on groundwork features — scripts, skills, templates, hooks, and format consistency
disable-model-invocation: false
---

Run groundwork structural validation.

Execute: bash "${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh"

Report results. If any checks fail:
- Fix failures that are within autonomous authority (missing comments, executability, hook correctness)
- Flag failures that need approval (missing skills, architectural issues)

$ARGUMENTS
