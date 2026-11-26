import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";

// One Markdown file per guide in src/content/guides/. The file name is the address:
// stop-doomscrolling.md is published at /guides/stop-doomscrolling/.
const guides = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/guides" }),
  schema: z.object({
    title: z.string(),
    // The search snippet: under about 155 characters.
    description: z.string().max(170),
    topic: z.enum(["how-it-works", "doomscrolling", "screen-time", "focus", "habits", "kids"]),
    // The searches it's written for.
    targets: z.array(z.string()).default([]),
    published: z.coerce.date(),
    updated: z.coerce.date().optional(),
    // Slugs of related guides.
    related: z.array(z.string()).default([]),
    sources: z.array(z.object({ title: z.string(), url: z.string().url() })).default([]),
    // Which iOS the steps were checked on, when the guide has iPhone steps.
    checkedOn: z.string().optional(),
    // A draft builds locally (DRAFTS=1 npm run build) and is never published.
    draft: z.boolean().default(false),
  }),
});

export const collections = { guides };
