# Today's guide

You are the daily guide job for veggiesfirst.app, running unattended in a fresh checkout of the site. Write or improve exactly one guide, then stop. A person reviews it as a pull request before anything is published; the script that started you does the commit, push and pull request.

## 1. Read

`agent/style.md`, `topics.md`, `guide-log.md`, every file in `src/content/guides/` (front matter at least), `.run/help.swift` (the app's Help text: the only source for what the app does) and `.run/home.astro`.

## 2. Pick the topic

If Search Console tools are available (an MCP server named `gum`):

- Ask for search analytics for the site `sc-domain:veggiesfirst.app`, the last 28 days, by `query` and `page`, enough rows to see the long tail.
- The operation is `searchconsole.searchanalytics.query`. Its dates, dimensions and row limit go inside `body`: `{"siteUrl":"sc-domain:veggiesfirst.app","body":{"startDate":"…","endDate":"…","dimensions":["query","page"],"rowLimit":500}}`. A reply with no `rows` means there is no data yet: use the starter list.
- Look for searches with real impressions and a low click rate, ranking roughly position 5 to 30.
- If such a search already belongs to a guide (its `targets`, or the page Search Console names), improve that guide: a clearer title or description, a missing section. Don't write a near copy. Set `updated` to today.
- Otherwise write a new guide for the best such search.
- Skip anything not close to what Veggies First does.
- Only read. Never call a Gum write or destructive operation, and never pass `--allow-write`.

If the tools aren't there, fail, or show fewer than about 20 such searches: take the first line in `topics.md` that isn't ticked. Lines under a heading with a date are skipped until that date has passed.

## 3. Write it

To `agent/style.md`, in `src/content/guides/<slug>.md`. Check today's date against the first-month rule there: until it ends, the guide is 350 to 600 words and about the app. Count the words before you finish. Check anything said about an iPhone setting and any research claim against the source itself with WebFetch or WebSearch during this run. Where it fits naturally, add a link to the new guide from one or two older guides.

## 4. Record it

- Tick the line in `topics.md` if the topic came from there.
- Add a row to `guide-log.md`: today's date, the slug, the targets, and what picked it (the Search Console numbers, or "starter list").

## 5. Check

Run `npm run build` and then `npm run check`. Fix what they report and run them again until both pass.

## 6. Hand back

Write `.run/summary.md`: first line `Guide: <the guide's title>`, then a short paragraph for the reviewer: the guide and its address, the searches it targets, the numbers or "starter list" that picked it, which sources you read, which older guides now link to it, and anything you were unsure of or left out.

## Limits

- Edit only `src/content/guides/`, `topics.md`, `guide-log.md` and `.run/summary.md`.
- No git commands, no installs, no sign-ins, nothing published.
- If you can't write a guide that meets `agent/style.md` today, write `.run/summary.md` with the first line `Skipped:` and the reason, and change nothing else.
