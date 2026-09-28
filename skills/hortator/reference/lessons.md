# Lessons

Each entry: what happened, the evidence, the rule. Add new ones at the top, with a date.

| Date | What happened | Rule |
|---|---|---|
| 2026-09-28 | A cold agent given only this skill could not tell whether it was allowed to touch the device with nobody on site: the project said "for the human/manager", the skill said nothing. | Say explicitly who may touch the real target, remotely and unattended, and where that stops. |
| 2026-09-28 | A hand-written hardware check raised halfway and left the user's instrument reset. The agent recovered it remotely from a setup block it had saved earlier; nobody was on site. | Hardware checks run in `try/finally` with restore; save the state before the first change. |
| 2026-09-28 | `200 us/div` became `0.00019999999999999998`; the instrument set 198 us/div. 92 tests on the fake were green. | Send numbers in decimal with limited digits. Only the real target shows what it does with your input. |
| 2026-09-27 | The instrument switched a setting off 0.9 s after a setup block was loaded; an earlier "restored" reading was true for a moment only. | Verify a restore after a delay, not immediately. |
| 2026-09-27 | An unknown command was never answered; the code timed out and left an error queued that was later blamed on an innocent step. | Drain error queues before an operation, and make the fake reject what reality rejects. |
| 2026-09-27 | I drove the instrument with my own code while benchmarking five other tools; they all showed the same latency and the same failure. The user objected: the common cause could be my code. | Use an independent control (bare socket, separate process), remove confounders one by one, name the ones that remain. |
| 2026-09-27 | I declared the vendor's formula wrong. The evidence was clipped data: samples saturated at both rails, mean near mid-scale. The user said the probe had been on a 3 Vpp square wave all along. | Check for saturation. Ask what is connected. Validate against a known signal before overriding documentation. |
| 2026-09-27 | I predicted Ethernet would cut latency to a few ms. It stayed at 22 ms on every transport. | Label expectations as expectations; measure before recommending. |
| 2026-09-27 | Three statements in my first spec, taken from documentation, were wrong (identifier format, point count, number format). | Recon the real target before writing the spec. |
| 2026-09-27 | Files the coder was told to write but not to run (benchmark, example) were the buggy ones. | Every deliverable must be runnable by the coder: give scripts a fake or dry-run mode and require it to be run. |
| 2026-09-27 | A local coder run hung for 12 minutes with zero events. | `opencode run ... < /dev/null`; check for events after a few seconds. |
| 2026-09-27 | A 32K context overflowed on a five-file task. | Give coding agents 64K context or more. |
| 2026-09-27 | A wait loop `until ! pgrep -f 'hf download'` never ended: it matched its own command line. | Anchor process patterns (`^/path/to/binary`). |
| 2026-09-27 | The user's readable-config request went through three designs (SCPI dict, typed Python, YAML with units). Each was prototyped and tested against deliberate mistakes before he chose. | When the boss questions a design, show working alternatives with evidence; the choice is his. |
| 2026-09-28 | A public push was requested; the history held a device serial number, a binary settings dump, local paths and session links. | Before publishing, scan the whole history, not just the working tree. |
