// npm run check, after npm run build: the built site hangs together.
//   every internal link in dist/ points at a page or file that exists,
//   every page has a title and a description, no two guides share a title,
//   once there are three guides, each one links at least two others.
import { readFileSync, readdirSync, existsSync, statSync } from "node:fs";
import { join } from "node:path";

const DIST = "dist";
const problems = [];
const pages = [];
(function walk(dir) {
  for (const name of readdirSync(dir)) {
    const path = join(dir, name);
    if (statSync(path).isDirectory()) walk(path);
    else if (name.endsWith(".html")) pages.push(path);
  }
})(DIST);

const exists = (url) => {
  const clean = decodeURIComponent(url.split("#")[0].split("?")[0]);
  if (!clean) return true;
  const path = join(DIST, clean);
  return existsSync(path) && (!statSync(path).isDirectory() || existsSync(join(path, "index.html")));
};

const titles = new Map();
const guidePages = pages.filter((p) => /dist\/guides\/[^/]+\/index\.html$/.test(p));
for (const page of pages) {
  const html = readFileSync(page, "utf8");
  const shown = page.slice(DIST.length);
  // Copies of the veggies-review pages and the account area keep their own head.
  const own = !/^\/(privacy|support)\.html$|^\/account\//.test(shown);
  const title = html.match(/<title>([^<]*)<\/title>/)?.[1]?.trim();
  if (!title) problems.push(`${shown}: no title`);
  if (own && !/<meta name="description" content="[^"]+/.test(html)) problems.push(`${shown}: no description`);
  if (guidePages.includes(page)) {
    if (titles.has(title)) problems.push(`${shown}: same title as ${titles.get(title)}`);
    titles.set(title, shown);
  }
  const links = [...html.matchAll(/(?:href|src)="(\/[^"/][^"]*|\/)"/g)].map((m) => m[1]);
  for (const link of links) if (!exists(link)) problems.push(`${shown}: broken link ${link}`);
  if (guidePages.includes(page) && guidePages.length >= 3) {
    const self = shown.replace(/index\.html$/, "");
    const others = new Set(links.filter((l) => /^\/guides\/[^/]+\/$/.test(l) && l !== self));
    if (others.size < 2) problems.push(`${shown}: links ${others.size} other guides, needs 2`);
  }
}

if (problems.length) {
  console.error(problems.join("\n"));
  console.error(`CHECK-FAILED ${problems.length} problems`);
  process.exit(1);
}
console.log(`CHECK-OK ${pages.length} pages, ${guidePages.length} guides`);
