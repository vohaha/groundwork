#!/usr/bin/env bash
# create-commit.sh — creates a semantically structured git commit
# Called by: groundwork:check-in, groundwork:commit skills
# Usage: create-commit.sh --type <type> --summary <summary> --why <why> --next <next>
#        [--scope <scope>] [--active <active>] [--discovered <discovered>] [--open <open>]
#
# Scaffold: this script is the programmatic scaffold for Claude's commits.
# The parallel human-facing scaffold is templates/commit-message.txt (~/.gitmessage).
# Both produce the same structure. If the format changes, update both.

type="" scope="" summary="" why="" next="" active="" discovered="" open_q=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --type)       type="$2";       shift 2 ;;
    --scope)      scope="$2";      shift 2 ;;
    --summary)    summary="$2";    shift 2 ;;
    --why)        why="$2";        shift 2 ;;
    --next)       next="$2";       shift 2 ;;
    --active)     active="$2";     shift 2 ;;
    --discovered) discovered="$2"; shift 2 ;;
    --open)       open_q="$2";     shift 2 ;;
    *) echo "Error: unknown argument: $1" >&2; exit 1 ;;
  esac
done

missing=""
[ -z "$type" ]    && missing="${missing} --type"
[ -z "$summary" ] && missing="${missing} --summary"
[ -z "$why" ]     && missing="${missing} --why"
[ -z "$next" ]    && missing="${missing} --next"

if [ -n "$missing" ]; then
  echo "Error: missing required fields:${missing}" >&2
  echo "Required: --type --summary --why --next" >&2
  exit 1
fi

if [ -n "$scope" ]; then
  header="${type}(${scope}): ${summary}"
else
  header="${type}: ${summary}"
fi

body="Why:
${why}

State:
Next: ${next}"

[ -n "$active" ]     && body="${body}
Active: ${active}"

[ -n "$discovered" ] && body="${body}

Discovered:
${discovered}"

[ -n "$open_q" ]     && body="${body}

Open:
${open_q}"

git commit -m "${header}

${body}

Commit-Tool: groundwork"
