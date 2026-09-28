# Dispatching coders

## Roster

Which coders exist, how to start them, how they scored and what habits they have is knowledge of the
installation, not of the method. It lives in the site file (`~/.config/hortator/site.md`, section "Coders
available here"). If there is no site file, ask the boss what is available and offer to create one from
`site.example/site.md`.

What generalises, from one casting of seven coders on six small Python tasks plus three real tasks:

- Scores on small tasks separate weak coders from adequate ones and say little beyond that. Habits matter
  more: leaving scratch files, skipping the final test run, editing protected tests, adding unrequested
  files. Record them per coder and check for them after every run.
- A strong cloud model delivered three modules with all tests green; acceptance on the real target still
  found defects in two of the three. Green tests on a fake are where acceptance starts.
- A local mid-size model needed two passes and a manual finish on its first real task.
- For a kind of task no coder has been measured on, choose on general strength, say in the report that the
  choice has no matching data point, and add what you observe to the site file.

## Cloud subagent (Agent tool)

- One spec file in the repository, committed before dispatch, so the coder's diff is separable.
- The prompt starts cold. It must contain: the repository path, the files to read in order, the hard rules,
  the definition of done as runnable commands, the traps, and the report format. Template:
  `templates/subagent-prompt.md`.
- Tell it not to commit. You commit after acceptance.
- It runs in the background and you are notified. Do not read its transcript file.
- Do not start work in the files it is editing until it reports.

## Local coder (opencode + llama-server)

```
scripts/dispatch_local.sh <repo> <preset> "<task sentence>" [timeout_s]
```

Paths, commands and the model endpoint come from `~/.config/hortator/site.env` (template in
`site.example/site.env`). The script refuses to run without it.

What the script takes care of, each learned the hard way:
- stdin from `/dev/null`: without it a background `opencode run` hangs after `init` with zero events.
- `--auto`: there is nobody to approve tool calls.
- enough context: a 32K window overflowed on a five-file task and the run ended with rc=1; use 64K or more.
- a `timeout`, the project virtualenv on `PATH`, and a `.gitignore` for the run logs.

Local models make the GPU loud and compete for VRAM with anything else on the card. Never run two model
servers at once on a machine without swap. Stop the server when the coder is done.

## Headless Claude Code as a coder

`env -u CLAUDECODE -u CLAUDE_CODE_ENTRYPOINT claude -p "<task>" --model sonnet --append-system-prompt "$(cat coder.md)" --dangerously-skip-permissions --max-turns 80 --max-budget-usd 5 --output-format stream-json --verbose`

Runs on the user's subscription. Use only in a directory that contains nothing but the task.

## Parallel work

Parallelise only independent modules. Give each coder its own git worktree and its own spec. Shared files
(README, the fake, the test helper) are merged by you, not by the coders.
