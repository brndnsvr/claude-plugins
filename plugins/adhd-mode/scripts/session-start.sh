#!/usr/bin/env bash
#
# session-start.sh - SessionStart hook: load ADHD mode by default
#
# Adds the mode text (skills/adhd-mode/mode.md, one item at a time) to every
# interactive session as context, so nobody has to paste it by hand.
# /adhd-mode off (the skill) or "exit ADHD mode" turns it off mid-session.
# Sub-agents never see it.
#
# On by default. Turn it off with CLAUDE_MODE_ADHD=off (or 0) in the "env"
# block of ~/.claude/settings.json (everywhere), a repo's .claude/settings.json
# or settings.local.json (one repo), or `CLAUDE_MODE_ADHD=off claude` (one
# session).
#
# Reads the file at session start and again after compaction, resume and
# /clear. Headless SDK runs get nothing: stop-and-wait pacing would stall
# unattended work. Never blocks; exits quietly when the file is missing.

set -u
case "${CLAUDE_CODE_ENTRYPOINT:-}" in sdk*) exit 0 ;; esac

case "$(printf '%s' "${CLAUDE_MODE_ADHD:-on}" | tr '[:upper:]' '[:lower:]')" in
  off|0|false|no) echo '{"systemMessage": "ADHD mode: off"}'; exit 0 ;;
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
