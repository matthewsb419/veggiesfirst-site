#!/bin/zsh
# guide-daily.sh — the daily guide job (plan: Docs/seo-guide-site.md in the app repo).
# Every run, in a fresh checkout of origin/main:
#   1. a headless Claude Code session reads agent/brief.md: it looks at Search Console
#      through Gum when Gum is set up (read-only), otherwise takes the next starter topic,
#      and writes or improves ONE guide,
#   2. the site is built and checked here as well,
#   3. the guide goes up as a pull request labelled `guide`. Nothing is published:
#      merging the pull request is what publishes it.
# Runs Monday, Thursday and Saturday. Skips the day while 3 or more guide pull
# requests are waiting, so they don't pile up.
# Installed on launchd at 6:00 AM by tools/install-guide-check.sh; by hand:
#   tools/guide-daily.sh          the real thing
#   tools/guide-daily.sh --dry    everything but the push and the pull request
# Logs: ~/Library/Logs/VeggiesFirst/guides.log. Run folders:
# ~/Library/Application Support/VeggiesFirst/guides/<date>/ (the checkout is in work/).
set -u
REPO=$(cd "$(dirname "$0")/.." && pwd)
APP=~/code/veggies-before-dessert
DRY=""; [ "${1:-}" = "--dry" ] && DRY=1
BASE=${BASE:-origin/main}   # BASE=origin/<branch> tries the job from another branch
DAY=$(date +%F)
LOGS=~/Library/Logs/VeggiesFirst; mkdir -p $LOGS
RUNS=~/Library/Application\ Support/VeggiesFirst/guides; mkdir -p "$RUNS"
RUN="$RUNS/$DAY"; WORK="$RUN/work"; BRANCH=guide-$DAY
LOCK="$RUNS/.running"
PATH=/opt/homebrew/bin:$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH
say() { echo "$(date '+%F %T') $*" | tee -a $LOGS/guides.log; }
note() { osascript -e "display notification \"$1\" with title \"Veggies First guides\"" 2>/dev/null || true; }

if [ -e "$LOCK" ] && kill -0 "$(cat "$LOCK")" 2>/dev/null; then say "a run is still going (pid $(cat "$LOCK"))"; exit 0; fi
echo $$ > "$LOCK"; trap 'rm -f "$LOCK"' EXIT

# Six posts a week, never a Tuesday (Ben, 2026-11-26). The guides written ahead go out by
# themselves on Wednesday, Friday and Sunday evenings; this job writes the ones for the
# days between, Monday, Thursday and Saturday, from what Search Console shows.
# A run by hand with --dry works on any day.
case "$(date +%u)" in 1|4|6) ;; *) [ -z "$DRY" ] && { say "skipped: not one of this job's days (Mon, Thu, Sat)"; exit 0; } ;; esac

cd "$REPO" || exit 1
WAITING=$(gh pr list --label guide --state open --json number --jq length 2>/dev/null || echo 0)
if [ -z "$DRY" ] && [ "$WAITING" -ge 3 ]; then say "skipped: $WAITING guide pull requests are waiting for review"; exit 0; fi
git fetch -q origin || { say "couldn't reach GitHub"; exit 1; }
if [ -z "$DRY" ] && git ls-remote --exit-code --heads origin $BRANCH >/dev/null 2>&1; then say "skipped: $BRANCH is already up"; exit 0; fi

# A fresh checkout of $BASE, so the working copy in ~/code is never touched.
git worktree remove --force "$WORK" 2>/dev/null; rm -rf "$RUN"; git worktree prune; mkdir -p "$RUN"
git branch -D $BRANCH >/dev/null 2>&1
git worktree add -q -b $BRANCH "$WORK" $BASE || { say "couldn't make the checkout"; exit 1; }
cd "$WORK" && mkdir -p .run
[ -r agent/brief.md ] || { say "skipped: $BASE has no agent/brief.md yet (the guide-job pull request isn't merged)"; exit 0; }
npm ci --silent > "$RUN/npm.log" 2>&1 || { say "npm ci failed, see $RUN/npm.log"; exit 1; }
# What the app does, for the guide's facts: the app's own Help text and the home page.
cp "$APP/App/HelpContent.swift" .run/help.swift 2>/dev/null || say "no Help text found at $APP"
cp src/pages/index.astro .run/home.astro

# Search Console through Gum, once Ben has installed it and signed the bot account in.
MCP=(); TOOLS=(Read Glob Grep Edit Write WebFetch WebSearch "Bash(npm run build)" "Bash(npm run check)")
if [ -x /Users/benjaminmatthews/.local/bin/gum ] && /Users/benjaminmatthews/.local/bin/gum doctor >/dev/null 2>&1; then
  MCP=(--mcp-config agent/mcp.json); TOOLS+=(mcp__gum); say "Gum is set up: reading Search Console"
else
  say "Gum isn't set up: starter list"
fi

say "writing ($BRANCH${DRY:+, dry run})"
# macOS has no timeout(1): perl sets an alarm that survives the exec and ends a run past 45 minutes.
perl -e 'alarm shift; exec @ARGV' 2700 claude -p "Today is $DAY. $(cat agent/brief.md)" \
  --permission-mode acceptEdits --allowedTools "${TOOLS[@]}" "${MCP[@]}" --output-format text > "$RUN/run.log" 2>&1
RC=$?
SUMMARY=.run/summary.md
[ -s $SUMMARY ] || { say "the run ended (exit $RC) without a summary, see $RUN/run.log"; note "Today's guide run failed"; exit 1; }
cp $SUMMARY "$RUN/summary.md"
TITLE=$(head -1 $SUMMARY)
case "$TITLE" in Skipped:*) say "$TITLE"; exit 0;; esac

npm run build > "$RUN/build.log" 2>&1 && npm run check >> "$RUN/build.log" 2>&1 || { say "the guide doesn't build, see $RUN/build.log"; note "Today's guide doesn't build"; exit 1; }
# Only the guides and the two lists may change.
STRAY=$(git status --porcelain | cut -c4- | grep -v -E '^(src/content/guides/|topics\.md$|guide-log\.md$)' || true)
[ -z "$STRAY" ] || { say "the run changed other files, nothing pushed: $STRAY"; note "Today's guide changed files it shouldn't"; exit 1; }
[ -n "$(git status --porcelain)" ] || { say "nothing changed"; exit 0; }

if [ -n "$DRY" ]; then say "dry run done: $TITLE (in $WORK)"; exit 0; fi
git add -A src/content/guides topics.md guide-log.md
git commit -q -m "$TITLE

Written by the daily guide job (tools/guide-daily.sh)."
git push -q -u origin $BRANCH || { say "push failed"; exit 1; }
gh label create guide --color 6fcf97 --description "A guide from the daily job" >/dev/null 2>&1
URL=$(gh pr create --base main --head $BRANCH --label guide --title "$TITLE" --body "$(tail -n +2 $SUMMARY)

Merging publishes it. To see it first: check out \`$BRANCH\`, then \`npm install && npm run dev\`.

Written by the daily guide job (\`tools/guide-daily.sh\`).")
say "opened $URL: $TITLE"; note "$TITLE is ready to review"
cd "$REPO" && git worktree remove --force "$WORK" 2>/dev/null
