# MS Teams / SharePoint / Stream -- Video & Transcript Downloader

> **Fork** of [brendangooden/ms-teams-sharepoint-downloader](https://github.com/brendangooden/ms-teams-sharepoint-downloader) with Firefox support added.

[![Firefox](https://img.shields.io/badge/firefox-available-FF7139?logo=firefoxbrowser&logoColor=white)](https://github.com/DiegoBarrosA/ms-teams-sharepoint-downloader/releases)
[![License](https://img.shields.io/github/license/brendangooden/ms-teams-sharepoint-downloader?color=blue)](LICENSE)

Download videos and transcripts from MS Teams meeting recordings, SharePoint, and Microsoft Stream -- even when the built-in download button is disabled.

## Browser support

- **Chrome / Edge** -- install from the [Chrome Web Store](https://chromewebstore.google.com/detail/ms-teams-transcript-downl/hmljlkhcebhkkhbbafiheolbneecoinp).
- **Firefox 128+** -- download the latest `ms-teams-downloader-firefox-v*.zip` from [GitHub Releases](https://github.com/DiegoBarrosA/ms-teams-sharepoint-downloader/releases), open `about:debugging#/runtime/this-firefox`, and click **Load Temporary Add-on** (lasts for the current session; AMO signing is not yet set up).

## Features

- In-browser video/audio download (MP4, M4A, or video-only) with parallel segment fetching and automatic throttle backoff.
- Transcript download in RAW JSON, WebVTT, or Grouped VTT formats with live preview.
- Floating banner widget as a fallback for dynamic SharePoint UI.
- Nix flake for local builds: `nix build`, `nix build .#chrome-zip`, `nix build .#firefox-zip`, `nix develop`.

## Usage

1. Open a meeting recording or MP4 in Teams, SharePoint, or the Stream-on-SharePoint player.
2. Click **Download Video** or **Download Transcript** in the command bar or floating banner.
3. Pick a format and download.

## Known limitations

- Firefox requires temporary loading (not AMO-signed).
- DRM-protected videos cannot be downloaded.
- Guest/unauthenticated viewers may fail due to missing tokens.

## License

MIT -- see `LICENSE`.
