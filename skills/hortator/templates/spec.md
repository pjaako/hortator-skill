# SPEC: <feature, in the user's words>

Decision behind this work: <one or two sentences; who decided and why this design>.

**The real <target> is NOT available to you.** <what the coder must use instead: fake, sandbox, flag>.
Read <files, in order> first. Do not commit.

## Facts measured on the real target (<what, version, date>)

- <fact with number and unit>
- <fact that contradicts the documentation, marked as such>
- <guess, marked GUESS, with what would confirm it>

## 1. <module or file>

<signature, behaviour, error cases. Exact strings where the target is picky. One source of truth for any
list that appears in more than one place.>

## 2. Fake / sandbox

<what the fake must do so that every requirement above is testable, including how it misbehaves>

## 3. Tests

<numbered list; each item is one behaviour with the expected value. Include the error paths.>
<"All existing tests keep passing unmodified.">

## 4. Documentation

<which section of which file, maximum length, what must not be touched>

## Done means

- `<command>` passes.
- `<command>` prints `<expected>`.
- `git status --short` shows only: <files>.

Report: files changed, the final test line verbatim, the output of the commands above, every place where
this spec was wrong or ambiguous or where you deviated and why, what is untested, and anything that looks
like a bug in existing code that you did not touch.
