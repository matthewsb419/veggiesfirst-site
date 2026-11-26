# veggiesfirst.app

The Veggies First website: the landing page, the guides, and the account area. Built with Astro and published by GitHub Pages when `main` changes (`.github/workflows/deploy.yml`).

```
npm install
npm run dev              # local preview
npm run build            # what gets published, in dist/
DRAFTS=1 npm run build   # the same, with draft guides included
```

## Where things are

- `src/pages/index.astro`: the landing page. `src/styles.css`: the look, shared by every page.
- `src/content/guides/*.md`: one file per guide. The file name is the address (`/guides/<name>/`). The front matter is checked by `src/content.config.ts`; a guide with `draft: true` is never published.
- `src/guides.ts`: the topics. Each topic gets a hub page at `/topics/<topic>/` once it has a guide.
- `src/config.ts`: the App Store link. While it's `null`, every download button says "Coming soon to the App Store".
- `public/`: files served as they are: `privacy.html`, `support.html` (copies of the pages in `veggies-review`; keep them the same), the account area (`account/`), pictures.
- `topics.md`: the starter list of guides to write. `guide-log.md`: what was written and why.

## Writing a guide

The answer in the first two or three sentences, then the steps. Real iPhone steps checked on a current iOS, or left out. One honest section on how Veggies First does it, with a real app screen. Sources for any claim about research or numbers; no invented statistics and no medical claims. Link 2 to 4 related guides. 700 to 1,500 words.

## The daily guide job

`tools/guide-daily.sh` writes one guide a day and opens it as a pull request labelled `guide`; merging the pull request publishes it. It runs a headless Claude Code session on `agent/brief.md`, which follows `agent/style.md`. With Gum set up (`/opt/homebrew/bin/gum`, signed in read-only to Search Console) it picks searches where the site shows up but gets few clicks; until then it takes the next line of `topics.md`. It skips the day while three guide pull requests are waiting.

```
tools/guide-daily.sh --dry      # write today's guide, but no push and no pull request
tools/install-guide-check.sh    # run it at 6:00 every morning (launchd)
npm run check                   # after a build: links, titles, descriptions
```

Logs are in `~/Library/Logs/VeggiesFirst/guides.log`; each day's run is in `~/Library/Application Support/VeggiesFirst/guides/<date>/`.
