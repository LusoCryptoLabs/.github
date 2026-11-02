# Runs scripts/pr-check.js against pull request events with a known answer.
# Each case: the exit it must give, the pull_request fields, a name.
D=$(cd "$(dirname "$0")" && pwd)
EV="$D/ev.json"
command -v cygpath >/dev/null 2>&1 && EVP=$(cygpath -m "$EV") || EVP="$EV"
pass=0
fail=0
t() {
  printf '{"pull_request":%s}' "$2" > "$EV"
  GITHUB_EVENT_PATH="$EVP" node "$D/../scripts/pr-check.js" > "$D/out.txt"
  got=$?
  if [ "$got" -eq "$1" ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "WRONG ($3): want $1, got $got"; cat "$D/out.txt"; fi
}
OWNER='"author_association":"OWNER","user":{"type":"User"}'
OUT='"author_association":"FIRST_TIME_CONTRIBUTOR","user":{"type":"User"}'
BOT='"author_association":"NONE","user":{"type":"Bot"}'
GOOD='"body":"## What changes\nA thing.\n\n## Why\nFixes #3\n\n## How it was checked\nnpm test, 12 passed."'
TEMPLATE='"body":"<!-- hint -->\n## What changes\n\n<!-- one line -->\n\n## Why\n\n## How it was checked\n\n<!-- commands -->\n"'
LONG=$(printf 'x%.0s' $(seq 1 70))

t 0 "{\"title\":\"fix(core): avoid caching cells without data\",$OWNER,\"body\":\"\"}" "owner, good title, empty body"
t 0 "{\"title\":\"ci: cache pnpm store\",$OWNER,\"body\":null}" "owner, no scope"
t 1 "{\"title\":\"Fix the thing\",$OWNER,\"body\":\"\"}" "owner, bad title"
t 1 "{\"title\":\"update: the thing\",$OWNER,\"body\":\"\"}" "owner, unknown type"
t 1 "{\"title\":\"fix(core): $LONG\",$OWNER,\"body\":\"\"}" "owner, title too long"
t 0 "{\"title\":\"fix(ui): keep the menu open on tap\",$OUT,$GOOD}" "outsider, filled in"
t 1 "{\"title\":\"fix(ui): keep the menu open on tap\",$OUT,$TEMPLATE}" "outsider, template untouched"
t 1 "{\"title\":\"fix(ui): keep the menu open on tap\",$OUT,\"body\":\"## What changes\nA thing.\"}" "outsider, no check section"
t 1 "{\"title\":\"feat(ui): add dark mode\",$OUT,\"body\":\"## What changes\nDark.\n\n## How it was checked\nLooked.\"}" "outsider feature, no issue"
t 0 "{\"title\":\"feat(ui): add dark mode\",$OUT,\"body\":\"## What changes\nDark.\n\n## Why\nFixes #9\n\n## How it was checked\nLooked.\"}" "outsider feature, issue linked"
t 0 "{\"title\":\"Bump actions/checkout from 4 to 5\",$BOT,\"body\":\"Bumps things.\"}" "bot, its own title"

rm -f "$EV" "$D/out.txt"
echo "pass $pass, fail $fail"
[ "$fail" -eq 0 ]
