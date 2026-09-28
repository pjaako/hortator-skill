# Site: <name of this installation>

Private. Lives in `~/.config/hortator/site.md` (or where `HORTATOR_SITE` points). Never commit it.
Everything here is local knowledge: the skill itself must work without it, only less well.

## The boss

- Language for reports: <language>
- Commits are authored as: <name> <email>; the agent is co-author: <yes/no>
- Quiet hours / conditions when local models must not run: <e.g. 22:00-08:00, or "when I say the machine must stay quiet">
- Prefers cloud or local coders when both would do: <cloud / local / ask>
- Things only the boss does: <system settings, network configuration, public pushes, purchases, ...>

## Machines and paths

| What | Value |
|---|---|
| Workspace root | <path> |
| Scratch directory | <path> |
| Filesystem traps | <e.g. "workspace is NTFS: chmod is ignored, secrets must live elsewhere"> |
| Swap / memory traps | <e.g. "no swap: never run two model servers"> |

## Coders available here

| Coder | How to start | Context | Score (what, when) | Habits to guard against |
|---|---|---|---|---|
| <cloud model> | <Agent tool, model name> | - | <n/m on <task set>, <date>> | <...> |
| <local model, quant> | <command or preset> | <tokens> | <n/m on <task set>, <date>> | <...> |

Scores are measurements with a date on a particular task set. Say which.

## Shared resources

| Resource | How to reach it | State it must be left in |
|---|---|---|
| <device / server> | <address, protocol> | <...> |

## Projects

| Project | Path | Handoff file |
|---|---|---|
| <name> | <path> | `HANDOFF.md` |
