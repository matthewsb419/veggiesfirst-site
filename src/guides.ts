import { getCollection } from "astro:content";

export const TOPICS = {
  "doomscrolling": { name: "Doomscrolling", blurb: "Getting out of the feed and back to your day." },
  "screen-time": { name: "Screen Time on iPhone", blurb: "Apple's own limits: what they do, and where they give way." },
  "focus": { name: "Focus and procrastination", blurb: "Starting the hard thing, and staying on it." },
  "habits": { name: "Habits and to-do lists", blurb: "Lists you finish and routines that stick." },
  "kids": { name: "Kids and chores", blurb: "Chores and homework first, then screen time." },
} as const;
export type Topic = keyof typeof TOPICS;

/** Every published guide, newest first. Drafts only show with DRAFTS=1. */
export async function guides() {
  const drafts = import.meta.env.DRAFTS === "1" || process.env.DRAFTS === "1";
  const all = await getCollection("guides", ({ data }) => drafts || !data.draft);
  return all.sort((a, b) => +(b.data.updated ?? b.data.published) - +(a.data.updated ?? a.data.published));
}
