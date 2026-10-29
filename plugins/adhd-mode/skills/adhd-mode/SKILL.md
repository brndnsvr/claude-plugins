---
name: adhd-mode
description: Turn ADHD mode (one item at a time, low-load replies) on or off for this session. The plugin turns it on at session start; `/adhd-mode off` turns it off, `/adhd-mode on` turns it back on. Run only when the user types /adhd-mode.
argument-hint: "[on|off|request]"
disable-model-invocation: true
---

# adhd-mode: on/off switch

The mode text lives in `mode.md` beside this file. The plugin's SessionStart
hook loads the same text at the start of every interactive session, so this
skill is only the switch.

Argument given: `$ARGUMENTS`

- **off**: say "adhd-mode off." and stop following the mode for the rest of
  the session, including after compaction, resume or /clear, until the user
  runs `/adhd-mode on`. Go back to your normal style.
- **on**, or nothing: say "adhd-mode on." and follow the mode below from now
  on. If no work is in flight, stop there.
- **anything else**: treat it as the user's request (for example
  `/adhd-mode where does this session stand?`). Turn the mode on and answer it
  right away under the mode.

Unless the argument is off, also:

- Where a decision fits naturally as this/that or yes/no, use the
  AskUserQuestion picker with the recommended option first. Don't force it
  where it doesn't fit; give one recommendation and ask "ok?".
- Flag risk or uncertainty in one short line starting with ⚠️, so the user can
  check it instead of trusting it.

## The mode

!`cat "${CLAUDE_SKILL_DIR}/mode.md" 2>/dev/null || echo "mode.md is missing beside SKILL.md. Say so in one line, then pace one item at a time anyway."`
