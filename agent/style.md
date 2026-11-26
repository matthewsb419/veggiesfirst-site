# How a guide is written

Every run of the daily job reads this first. A person reviews each guide before it's published, and Google treats pages written only to rank as spam, so each guide has to be worth reading on its own.

## Shape

- The answer in the first two or three sentences, then the steps. Someone who searched for this wants the answer, not a story.
- 700 to 1,500 words, whatever the question needs. Plain words. Short paragraphs. `##` headings that say what the section answers.
- One guide per question. If two searches want the same answer, they're one guide with two `targets`.
- One honest section on how Veggies First does it, headed "How Veggies First does it" (for a `how-it-works` guide the whole guide is that, so no separate section). Include one picture from `public/img/` that fits, written as `![what the picture shows](/img/<file>)`.
- Don't write a download block: the page adds it.
- Link 2 to 4 related guides in the text where they fit, as `/guides/<slug>/`, and list their slugs in `related`. Only link guides that exist. With fewer than three guides on the site, link what there is.

## Facts

- iPhone steps are real: the Settings path and the button names, checked against Apple's own support pages for the current iOS, with the page in `sources` and the iOS version in `checkedOn`. If a step can't be checked, leave it out.
- What Veggies First does comes only from `.run/help.swift` (the app's own Help text) and `.run/home.astro` (the site's home page). If a feature isn't described there, it isn't in the guide. No prices: they change, and the App Store shows them.
- A claim about research or numbers has a source in `sources`, read during this run. No invented statistics, quotes or studies.
- Habits and tools only. Nothing that reads as medical advice about attention, anxiety, ADHD or addiction.
- Don't run down other apps by name. Saying what Apple's own Screen Time does and doesn't do is fine.

## Front matter

```
---
title: "Under 65 characters, written for a person deciding whether to click"
description: "Under 155 characters: the answer in one line."
topic: how-it-works | doomscrolling | screen-time | focus | habits | kids
targets: ["the search it's for", "another search with the same answer"]
published: YYYY-MM-DD
checkedOn: "iOS 26"        # only when the guide has iPhone steps
related: ["other-guide-slug"]
sources:
  - title: "Apple: Use Screen Time on your iPhone"
    url: "https://support.apple.com/..."
---
```

The file name is the address: `stop-doomscrolling.md` is published at `/guides/stop-doomscrolling/`. Lower case, hyphens, the main search in it, no dates.
