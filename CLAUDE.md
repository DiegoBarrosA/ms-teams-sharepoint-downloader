# CLAUDE.md

Guidance for Claude when working in this repo.

## Project layout

- `src/` — extension source. `content.js`, `intercept.js`, `mux-worker.js`, `modal.css`, `manifest.json`, `icons/`.
- `src/key.pem` — local signing key. **Must not** ship in any release zip.
- `scripts/` — repo utilities.
- `demo-website/` — separate marketing site (Cloudflare Workers). Unrelated to the extension build.
- `releases/` — Chrome Web Store upload artifacts, one zip per release. Gitignored.

## Building a release zip

Always use `scripts/package-extension.ps1` — do not zip `src/` manually. The script reads `version` from `src/manifest.json`, refuses to overwrite an existing zip (bump the version first), excludes `key.pem` + `.DS_Store` + `Thumbs.db`. Supports both Chrome and Firefox targets.

```pwsh
# 1. Bump src/manifest.json "version"
# 2. Build Chrome package:
pwsh scripts/package-extension.ps1
# 3. Build Firefox package:
pwsh scripts/package-extension.ps1 -Target Firefox
# Use -Force only if you intentionally want to overwrite an existing zip.
```

Verify the result with `unzip -l releases/ms-teams-downloader[-firefox]-v<version>.zip` — expect 6 entries (`icons/icon128.png`, `content.js`, `intercept.js`, `manifest.json`, `modal.css`, `mux-worker.js`) and no `key.pem`.

## Building with Nix

```sh
nix build                                # unpacked extension in result/
nix build .#chrome-zip                   # Chrome release zip
nix build .#firefox-zip                  # Firefox release zip
nix develop                              # dev shell with pwsh + web-ext
```

## Don'ts

- Never add `chrome.cookies` permission or a background service worker to extract SharePoint session cookies, even to "improve" CLI tool support. Tested: segment URLs require `FedAuth` + `rtFa` (HttpOnly) and baking those into a copy-paste script exposes the user's full session. The in-browser path is the only one we support.
- Don't bring back the ffmpeg / yt-dlp tabs in the video modal. Microsoft now DASH-SEA AES-128-CBC encrypts Stream segments; yt-dlp refuses all `<ContentProtection>` streams as DRM, and ffmpeg's DASH demuxer doesn't implement DASH-SEA. The modal note states this — don't soften it.

## Agent skills

### Issue tracker

GitHub Issues at `brendangooden/ms-teams-sharepoint-downloader` via `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Canonical defaults (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context — one `CONTEXT.md` + `docs/adr/` at repo root. See `docs/agents/domain.md`.
