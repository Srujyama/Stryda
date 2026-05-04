import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: process.env.ASTRO_SITE || 'https://stryda.ai',
  output: 'static',
  integrations: [
    sitemap({
      // /pitch and /manifesto are share-by-link only — keep them out of
      // sitemap.xml so they don't get crawled or indexed.
      filter: (page) =>
        !/^https?:\/\/[^/]+\/(pitch|manifesto)(\/|$)/.test(page),
    }),
  ],
  build: {
    assets: 'assets',
  },
  vite: {
    build: {
      sourcemap: false,
    },
  },
});
