# How a guide is written

Every run of the daily job reads this first. A person reviews each guide before it's published, and Google treats pages written only to rank as spam, so each guide has to be worth reading on its own.

## Who it's for, and what it's for

These guides are marketing for Veggies First. Each one answers a real question, and its answer leads to what the app does: it joins your to-do list to your screen time. The apps you scroll stay locked until you've done something on your list, each thing you finish earns time, and once the list is clear your apps are open for the rest of the day. A reader should finish a guide knowing that, and how it helps with the thing they searched for.

## The first month: short, and about the app (through December 31, 2026)

Ben's rule, 2026-11-26, after the first draft ran long and read like an iPhone manual.

- **400 to 900 words: a two to five minute read.** If it's longer, cut.
- **Lead with the answer and the app.** The first two or three sentences answer the question. By the second paragraph the reader knows what Veggies First is and how it solves this.
- **Most of the guide is how the app works** for this problem: what you set up, what happens when you open a locked app, what you get for finishing. Concrete, from the app's own Help text.
- **The iPhone's own settings get a sentence each, not steps.** Say the setting exists and what it's good for, and link the words to Apple's page for it ("[set a time allowance in Screen Time](https://support.apple.com/...)"). No numbered Settings paths, no button names. At most three such mentions in a guide.
- **Every built-in setting is followed by the alternative:** what Veggies First does about the same thing, in a sentence or two. The honest difference is usually this: a built-in limit takes time away and is two taps to skip; Veggies First opens the apps when you've done something.
- **No research section.** One sourced sentence at most, and only if it helps.
- **It ends by sending the reader to the app.** The last section is a short "Try it" (or a heading that fits the guide): one or two sentences that say what to do first in the app for this problem, and that Veggies First is free to try for 14 days. The page puts the download button right under it. These guides are feeders into the app, so a reader should never reach the end without being asked to try it.
- **Show what makes the app different,** a guide at a time: the features, the options and flexibility it gives (passes, days off, big days, an evening window, rewards you set), how it keeps you honest anyway (changes wait for midnight, a removed app stays locked, a pass takes a hold, a friend can check your proof), and what it does when someone tries to get around their own rules.
- Step-by-step iPhone guides (Screen Time, notifications, grayscale and so on) wait until after this date. Topics that are only that are skipped until then. When they exist, the links above point to our own pages instead of Apple's.

## Shape

- Plain words. Short paragraphs. `##` headings that say what the section answers, three to five of them.
- One guide per question. If two searches want the same answer, they're one guide with two `targets`.
- A heading "How Veggies First does it" for the main section about the app (for a `how-it-works` guide the whole guide is that, so no separate section). Include one picture from `public/img/` that fits, written as `![what the picture shows](/img/<file>)`.
- After the first month a guide may run to 1,200 words when the question needs it. The app still comes in early and every built-in setting still gets its alternative.
- Don't write a download block: the page adds it.
- Link 2 to 4 related guides in the text where they fit, as `/guides/<slug>/`, and list their slugs in `related`. Only link guides that exist. With fewer than three guides on the site, link what there is.

## Facts

- What a guide says about an iPhone setting is real: checked against Apple's own support page for the current iOS during this run, with that page linked in the text and listed in `sources`. Where a guide has step-by-step iPhone instructions (after the first month), the Settings path and button names are checked the same way and the iOS version goes in `checkedOn`. If it can't be checked, leave it out.
- In the app a minute of dessert is bought with DDC. In a guide say "coins" the first time with "(the app calls them DDC)", then "coins".
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
