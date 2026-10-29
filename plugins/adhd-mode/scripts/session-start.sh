#!/usr/bin/env bash
#
# session-start.sh - SessionStart hook: optionally load ADHD mode
#
# Off by default: the mode starts only when you run /adhd-mode on. Set
# CLAUDE_MODE_ADHD=on (or 1) to have this hook add the mode text
# (skills/adhd-mode/mode.md, one item at a time) to every interactive session
# instead. Put it in the "env" block of ~/.claude/settings.json (everywhere),
# a repo's .claude/settings.json or settings.local.json (one repo), or run
# `CLAUDE_MODE_ADHD=on claude` (one session). /adhd-mode off or "exit ADHD
# mode" still turns it off mid-session. Sub-agents never see it.
#
# Reads the file at session start and again after compaction, resume and
# /clear. Headless SDK runs get nothing: stop-and-wait pacing would stall
# unattended work. Never blocks; exits quietly when the file is missing.

set -u
case "${CLAUDE_CODE_ENTRYPOINT:-}" in sdk*) exit 0 ;; esac

case "$(printf '%s' "${CLAUDE_MODE_ADHD:-off}" | tr '[:upper:]' '[:lower:]')" in
  on|1|true|yes) ;;
  *) exit 0 ;;
esac

ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
FILE="$ROOT/skills/adhd-mode/mode.md"
[ -r "$FILE" ] || { echo '{"systemMessage": "ADHD mode: mode.md missing"}'; exit 0; }

python3 - "$FILE" <<'PY' || exit 0
import json, sys

text = open(sys.argv[1], encoding="utf-8").read().strip()
print(json.dumps({
    "systemMessage": "ADHD mode: on",
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": "Standing working mode for this session. If I "
        "already ran /adhd-mode off or said \"exit ADHD mode\" earlier in this "
        "conversation (and haven't run /adhd-mode on since), keep it off.\n\n"
        + text,
    },
}))
PY
