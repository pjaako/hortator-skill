# Acceptance

A coder's report is a claim. Acceptance is you checking the claim.

## Order

1. `git status --short`: only the files the spec allowed. Stray files are a finding.
2. Run the test suite yourself. Read at least the core of the diff.
3. Run static analysis if the project has it, with a checker installed outside the project environment.
4. Read the coder's list of deviations and untested items. Decide each one: accept, fix, or send back.
5. **Run on the real target.** Exercise the happy path, the error paths, and the restore.
6. Every defect found in step 5 gets: a fix, a test, and a change to the fake so the fake now behaves like
   reality in that respect.
7. Update the project docs with measured facts, commit with attribution, report.

## On the real target

- Save the state first, work inside `try: ... finally: restore`, then verify the restore by reading the
  state back a second or two later. Some devices undo a setting asynchronously.
- Check that the data is valid before interpreting it: not saturated, not stale, taken under the conditions
  you think. Ask the boss what is connected instead of assuming.
- Distrust a number that matches your expectation too well as much as one that does not match at all.
- One measurement is an anecdote. Repeat, and report the spread.
- When the boss is away and a browser or a person is needed, build a scripted stand-in (for example a robot
  that answers operator prompts through the same API the UI uses).

## Send back or fix yourself

Fix yourself when the change is small (roughly under 60 lines), you already know the cause, and another
round would cost more than the fix. Send back when the design is wrong or the coder ignored a numbered
requirement. Either way the spec or the fake is updated so the defect cannot return unnoticed.

## What goes in the report to the boss

- What works, verified where: on reality / on a fake / not at all.
- What acceptance found and what was done about it, including your own mistakes.
- State of shared resources after your work.
- Decisions that are his.
