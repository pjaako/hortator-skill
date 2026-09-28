# hortator

Instructions that let a cold AI agent take over as **project owner**: the user is the boss, the agent
decomposes the work, writes specs, hands implementation to coder agents (local models or cloud subagents),
accepts the result against reality and reports.

Distilled from real sessions (a local LLM inference setup, an instrument driver with hardware in the loop),
including the mistakes. It is a method, not a framework: a skill, three reference files, three templates, one script.

## Layout

| Path | What |
|---|---|
| `skills/hortator/SKILL.md` | the skill: the loop, the rules, who does what |
| `skills/hortator/reference/dispatch.md` | roster of coders, how to start cloud and local ones |
| `skills/hortator/reference/acceptance.md` | how to check a coder's claim, especially on hardware |
| `skills/hortator/reference/lessons.md` | what went wrong and the rule that came out of it |
| `skills/hortator/templates/` | spec, subagent prompt, handoff |
| `skills/hortator/scripts/dispatch_local.sh` | run one local coder through opencode |
| `skills/hortator/site.example/` | templates for the private site configuration |

## Install as a Claude Code skill

```bash
mkdir -p ~/.claude/skills && cp -r skills/hortator ~/.claude/skills/
```

### Site configuration (private)

```bash
mkdir -p ~/.config/hortator
cp skills/hortator/site.example/site.md skills/hortator/site.example/site.env ~/.config/hortator/
```

Fill both in. `site.md` is read by the agent: who the boss is, which coders exist and how they behave,
machines, paths, shared resources. `site.env` is read by `dispatch_local.sh`. Neither belongs in any
repository. The skill works without them, but it will ask more and know less.

Then in a session: `/hortator`, or just ask the agent to act as project owner. For one project only, copy
the folder to `<project>/.claude/skills/` instead.

Without skills support, tell the agent: "Read `skills/hortator/SKILL.md` in `<path to this repo>` and work
that way."

## What belongs where

| Knowledge | Lives in |
|---|---|
| How to run work as project owner | here |
| Decisions and measured facts of a project | that project's `README.md` |
| Constraints and traps of a project | that project's `AGENTS.md` |
| Current state and open items | that project's `HANDOFF.md` |
| Which coders exist here, how they score, how to start them, addresses, paths | `~/.config/hortator/site.md`, private |

## Tested how

2026-09-28: a cold cloud agent was given only the path to the skill and a project's `HANDOFF.md`, plus a
one-line task from "the boss", in planning mode. It chose recon before spec, a cloud coder because the
machine had to stay quiet, a fake for the coder, acceptance on the real target, and refused the public push.
It also reported four gaps, which were fixed. That is one run on one task without execution: the skill has
not yet carried a real task from start to finish in a fresh session.

## Keeping it honest

Add a lesson when something goes wrong, with the evidence. Remove a rule when it stops paying for itself.
The roster is a measurement with a date: rerun the casting before trusting it for a new kind of task.
