# AGENTS.md

This repository is the method for acting as project owner. Start with `skills/hortator/SKILL.md`.

- Keep `SKILL.md` short (under 120 lines): it is loaded into context every time. Detail goes to `reference/`.
- A rule without evidence does not go in. Every entry in `reference/lessons.md` names what happened.
- Project-specific facts do not belong here. Put them in the project's own `README.md` / `AGENTS.md`.
- The skill folder must stay self-contained: it is installed by copying `skills/hortator/` alone.
- This repository is public. It must contain no local paths, addresses, host or user names, serial numbers,
  model inventories or anything else that describes one installation. Such data goes to
  `~/.config/hortator/` (templates in `skills/hortator/site.example/`). Before committing run
  `grep -rnIE '/home/|192\.168\.|10\.[0-9]+\.[0-9]+\.' .` and expect no hits outside `.git`.
- Licence: MIT for everything. `skills/hortator/LICENSE` is a copy of the root `LICENSE` and must stay inside the skill folder, because the folder is installed on its own.
