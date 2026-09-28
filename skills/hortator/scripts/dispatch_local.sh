#!/usr/bin/env bash
# Run one local coder on one task in one repository, then report what it left behind.
# Usage: dispatch_local.sh <repo> <preset> "<task sentence>" [timeout_s]
# Configuration: ~/.config/hortator/site.env (or $HORTATOR_SITE_ENV), see site.example/site.env.
set -uo pipefail
[ $# -ge 3 ] || { echo "usage: $0 <repo> <preset> \"<task>\" [timeout_s]" >&2; exit 2; }
SITE_ENV="${HORTATOR_SITE_ENV:-$HOME/.config/hortator/site.env}"
[ -f "$SITE_ENV" ] || { echo "no site configuration at $SITE_ENV; copy site.example/site.env there and fill it in" >&2; exit 2; }
# shellcheck disable=SC1090
. "$SITE_ENV"
for v in HORTATOR_MODEL_START HORTATOR_MODEL_STOP HORTATOR_MODEL_HEALTH HORTATOR_CODER_PROMPT HORTATOR_OPENCODE_MODEL HORTATOR_OPENCODE_BIN; do
  [ -n "${!v:-}" ] || { echo "$v is not set in $SITE_ENV" >&2; exit 2; }
done
REPO="$(cd "$1" && pwd)"; PRESET="$2"; TASK="$3"; TIMEOUT="${4:-1500}"
[ -f "$HORTATOR_CODER_PROMPT" ] || { echo "coder prompt not found: $HORTATOR_CODER_PROMPT" >&2; exit 2; }
git -C "$REPO" diff --quiet && git -C "$REPO" diff --cached --quiet || { echo "commit the spec first: the working tree of $REPO is not clean" >&2; exit 2; }

${HORTATOR_MODEL_START//\{preset\}/$PRESET} | tail -1
for _ in $(seq 1 60); do
  [ "$(curl -s -o /dev/null -w '%{http_code}' "$HORTATOR_MODEL_HEALTH")" = 200 ] && break; sleep 2
done

cd "$REPO"
for f in opencode.json opencode.jsonl opencode.err; do grep -qxF "$f" .gitignore 2>/dev/null || echo "$f" >> .gitignore; done
cat > opencode.json <<JSON
{
  "\$schema": "https://opencode.ai/config.json",
  "permission": { "edit": "allow", "bash": "allow", "webfetch": "deny" },
  "agent": { "coder": { "description": "Local coder", "mode": "primary", "model": "$HORTATOR_OPENCODE_MODEL",
    "temperature": 0.2, "prompt": "{file:$HORTATOR_CODER_PROMPT}",
    "permission": { "edit": "allow", "bash": "allow", "webfetch": "deny" } } }
}
JSON
export PATH="$REPO/.venv/bin:$HORTATOR_OPENCODE_BIN:$PATH"
START=$(date +%s)
# stdin from /dev/null: a background run without it hangs after init and never sends a request
timeout "$TIMEOUT" opencode run --dir "$REPO" --agent coder -m "$HORTATOR_OPENCODE_MODEL" --format json --auto "$TASK" \
  > opencode.jsonl 2> opencode.err < /dev/null
RC=$?
echo "rc=$RC secs=$(( $(date +%s) - START )) events=$(wc -l < opencode.jsonl) tool_calls=$(grep -oE '"type": *"tool(_use)?"' opencode.jsonl | wc -l)"
[ "$RC" = 124 ] && echo "TIMEOUT after ${TIMEOUT}s"
[ "$(wc -l < opencode.jsonl)" = 0 ] && echo "NO EVENTS: the coder never talked to the model; check the server and the opencode log"
git status --short
$HORTATOR_MODEL_STOP | tail -1
