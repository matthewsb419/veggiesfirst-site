import { getCollection } from "astro:content";

export const TOPICS = {
  "how-it-works": { name: "How Veggies First works", blurb: "The app, one part at a time: to-dos, locked apps, coins and the rest." },
  "doomscrolling": { name: "Doomscrolling", blurb: "Getting out of the feed and back to your day." },
  "screen-time": { name: "Screen Time on iPhone", blurb: "Apple's own limits: what they do, and where they give way." },
  "focus": { name: "Focus and procrastination", blurb: "Starting the hard thing, and staying on it." },
  "habits": { name: "Habits and to-do lists", blurb: "Lists you finish and routines that stick." },
  "kids": { name: "Kids and chores", blurb: "Chores and homework first, then screen time." },
} as const;
export type Topic = keyof typeof TOPICS;

/** A guide goes out at 8 PM Central on its `published` day: 02:00 UTC the next morning,
 *  which is 26 hours after the UTC midnight the date parses to (9 PM in summer time).
 *  The site is rebuilt every evening just after that (.github/workflows), so a guide
 *  written ahead with a later date appears by itself on its day. */
const RELEASE_HOURS = 26;
// GUIDES_NOW=2026-12-05T02:10:00Z npm run build shows the site as it will be at that moment.
const clock = () => (process.env.GUIDES_NOW ? new Date(process.env.GUIDES_NOW) : new Date());
export const isOut = (published: Date, now = clock()) => +published + RELEASE_HOURS * 3600_000 <= +now;

/** Every published guide, newest first. Drafts, and guides dated ahead, only show with DRAFTS=1. */
export async function guides() {
  const drafts = import.meta.env.DRAFTS === "1" || process.env.DRAFTS === "1";
  const all = await getCollection("guides", ({ data }) => drafts || (!data.draft && isOut(data.published)));
  return all.sort((a, b) => +(b.data.updated ?? b.data.published) - +(a.data.updated ?? a.data.published));
}
