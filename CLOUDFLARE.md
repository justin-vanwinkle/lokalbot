# Cloudflare deployment

The website can be deployed as Cloudflare Workers static assets using `wrangler.jsonc`.

- Repository: `stevyhacker/lokalbot`, production branch: `master`.
- Build command: leave empty; `web/` contains the deployable site.
- Deploy command: `npx wrangler@4.131.2 deploy`.
- Custom domains: `www.lokalbot.com` and `lokalbot.com`.
- The apex redirects to `www`. Extensionless article URLs are preserved.
- `.assetsignore` excludes Markdown instructions from public assets.
- No runtime secret is needed; downloads remain on GitHub Releases.

Before switching DNS, verify the Workers URL, article links, CSS, JavaScript,
video range requests and the download link. Keep the Vercel project available
until the custom domains pass the same checks.
