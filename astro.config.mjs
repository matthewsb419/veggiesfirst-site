import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";

export default defineConfig({
  site: "https://veggiesfirst.app",
  trailingSlash: "always",
  integrations: [sitemap({ filter: (page) => !page.includes("/account/") && !page.includes("/404"), customPages: ["https://veggiesfirst.app/support.html", "https://veggiesfirst.app/privacy.html"] })],
});
