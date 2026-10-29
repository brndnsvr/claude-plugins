# adhd-mode

A working mode for Claude Code: one item at a time, one decision per reply,
and a status line on every reply so you can step away and pick back up.

It was built for an ADHD brain, but it is just a pacing rule. It changes how
the conversation moves, not the goal, the quality bar, or the safety rules.
It says nothing about sub-agents, models, or effort.

## What it does

The mode is off until you run `/adhd-mode on`. While it is on:

- Claude orders the work internally and tells you how many items there are.
- Each reply starts with `Item N of M · <title> · <done> done · <parked> parked`.
- Each reply carries one decision, in about six lines: what, why, the
  recommendation, the main risk.
- Claude stops and waits for you. It never works ahead on later items.
- After you decide, it does the item, reports what it verified, and brings
  the next one in the same reply.
- "Skip" or "park" sets an item aside without losing it. "Where are we?"
  gets open, done, and parked.
- Each next item follows from your last answer. It is never a fixed
  questionnaire.
- Silence is never approval. Irreversible or outward-facing actions are
  confirmed right before they happen, even after a general "go."

A quick question or lookup is not an item; it just gets answered.

## Switching it off and on

- `/adhd-mode on` turns it on. `/adhd-mode <request>` turns it on and
  answers the request under the mode.
- `/adhd-mode off` or "exit ADHD mode" turns it off for the session.
- `CLAUDE_MODE_ADHD=on` has the session-start hook turn it on in every
  session. Put it in the `env` block of `~/.claude/settings.json` for every
  session, in a repo's `.claude/settings.json` for one repo, or on the command
  line for one run.
- Headless SDK runs never get the mode, so unattended work does not stall.

## Install

```text
/plugin marketplace add https://github.com/brndnsvr/claude-plugins
/plugin install adhd-mode@brndnsvr
```

Start a new session and run `/adhd-mode on`. The next reply will carry a
status line.

## Layout

```text
skills/adhd-mode/SKILL.md   the /adhd-mode switch
skills/adhd-mode/mode.md    the mode text; the single source
hooks/hooks.json            SessionStart hook (opt-in)
scripts/session-start.sh    injects mode.md as session context
```

To change the wording, edit `mode.md`. Nothing else holds a copy.
