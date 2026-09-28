# Casting: interviewing local models before trusting them with work

Do this once per installation, and again when the hardware, the engine or the kind of task changes. The
result goes into the site file, with the date and the task set. Ask the boss before starting: a casting
occupies the GPU for an hour or more.

No kit is shipped with this skill, on purpose. You build the tasks, the hidden tests and the runner
yourself, for the language and the kind of work this installation does. If you cannot, that is a finding:
stop and report it. Do not hand work to a coder you could not measure.

## 0. Gates: stop at the first one that fails

Each gate is a check you run, not an assumption you make. On a failure, stop the casting, tell the boss
which gate failed and what you observed, and fall back to coders that are already measured, to cloud
coders, or to doing the work yourself.

| Gate | Passes when |
|---|---|
| Hardware is known | you have read GPU memory, system memory and swap from the machine, not from memory or a document |
| Something fits | at least one candidate loads with 64K of context for one coder, weights fully on the GPU |
| The harness works | a trivial task runs end to end through the harness, with real tool calls and a changed file |
| The tasks are sound | every task starts in the intended state: the failing test fails for the intended reason, the others pass |
| The grading is sound | your own reference solution passes every hidden test, and the untouched task fails them |
| The kit is solvable | a coder you already trust passes it; if nobody can pass a task, the task is wrong |
| The runs are clean | each run starts from a fresh copy; a timeout is recorded as a timeout, not as a failure of the coder |

A casting that skipped a gate produces numbers, not knowledge.

## 1. Shortlist what fits the hardware

A coder is useful only if the model **and** its working context fit in GPU memory together.

```
VRAM needed = weights + context memory x number of parallel coders + ~1 GB overhead
```

- **Weights must fit entirely on the GPU.** Moving a small part of a model to the CPU cost 40 % of the
  generation speed in our measurements, far more than a higher quantisation gains. Prefer a smaller
  quantisation that fits over a larger one that needs offload.
- **Context is not free.** Context memory grows linearly with context length and with the number of parallel
  slots. Measure it: load the model with the context you intend to use and read the memory in use. For a
  30B-class model, 32K tokens of context took about 3 GB per slot.
- **Coding needs large contexts.** A coder re-reads files, test output and its own history on every turn. A
  32K window overflowed on a task touching five files. Plan for 64K per coder as the minimum and more for
  repositories with large files. A model that fits only with 8K-16K of context is not a coder, whatever
  its benchmark score.
- **Parallel coders multiply the context, not the weights.** Three coders at 64K need three times the
  context memory. Check that the total still fits before promising parallel work.
- Reasoning ("thinking") models spend context on their reasoning. Give them more room, not less.

Drop from the shortlist anything that does not fit with 64K of context for one coder.

## 2. Measure the engine, not only the model

- Single-stream generation and prompt-processing speed, in tokens per second.
- Whether throughput grows with parallel requests. One engine we measured stayed flat however many slots it
  had; another scaled almost linearly. This decides how many coders can run at once.
- Agent loops are prompt-heavy: every file a coder reads is thousands of tokens to process. Prompt speed and
  prefix caching matter as much as generation speed.

## 3. The interview

Give every candidate the same small tasks through the same harness, each in a fresh repository:

| Task | What it shows |
|---|---|
| Fix a bug that a failing test points at | reads, edits, runs tests |
| Add a feature to an existing module, judged by hidden tests | follows a written spec |
| Refactor with the tests kept green | restraint |
| Write a small program from a spec, including its tests | works from nothing; tests its own tests |
| Find a bug in a file of 1000+ lines | handles volume, context use |
| A deliberately incomplete spec | decides, and says what it decided |

Rules that made the results usable:

- **Hidden tests** decide whether the spec was met. The coder's own tests are scored separately: a coder
  that meets the spec but leaves its own tests failing has a process problem, not a capability problem.
- **Protected files.** Where the spec forbids editing tests, any change there is a failure.
- **Validate the hidden tests against a reference solution** before the casting, or you will be grading the
  candidates on your own mistakes.
- Record for each run: outcome, wall time, number of tool calls, files changed beyond what the task needed.
- Read the diffs. Stray debug files, unrequested config files and skipped final test runs do not show up in
  a score and are exactly what you will have to guard against later.
- Time to a finished result matters more than tokens per second. A slower model that needs fewer steps can
  finish first.

## 4. Reading the result

- One run per task is an anecdote. A difference of one task between two coders is noise; rerun before
  acting on it.
- Small tasks separate inadequate coders from adequate ones. They do not tell you who is best at large work.
- Put the roster in the site file: coder, how to start it, context, score with date and task set, habits.
- Include the cloud models available to the boss in the same casting. They set the reference point for what
  the local ones are worth.

## 5. After the casting

Assign roles, not ranks: a primary coder, a fast one for mechanical work, one that is only trusted with
trivial fixes, and a cloud model to escalate to. Revisit when a coder surprises you in real work, in either
direction, and write down what happened.
