# Cloudflare deployment

The website can be deployed as Cloudflare Workers static assets using `wrangler.jsonc`.

- Repository: `stevyhacker/lokalbot`, production branch: `master`.
- Build command: leave empty; `web/` contains the deployable site.
- Deploy command: `npx wrangler@4.131.2 deploy`.
- Custom domains: `www.lokalbot.com` and `lokalbot.com`.
- The apex redirects to `www` using a Cloudflare zone Redirect Rule.
  `cloudflare/redirect-rules.json` records the exact HTTP 308 rule, which preserves
  the path and query string. Zone rules are managed separately from Wrangler.
- Extensionless article URLs are preserved. Workers `_redirects` files cannot
  match a source hostname, so the canonical redirect belongs in the zone rules.
- `.assetsignore` excludes Markdown instructions from public assets.
- No runtime secret is needed; downloads remain on GitHub Releases.

Before switching DNS, verify the Workers URL, article links, CSS, JavaScript,
video range requests and the download link. Keep the Vercel project available
until the custom domains pass the same checks.

Back up and remove only conflicting website A/CNAME records before attaching the
custom domains declared in Wrangler. Preserve mail and TXT records. Enable the
canonical rule after Cloudflare manages the proxied website DNS.
