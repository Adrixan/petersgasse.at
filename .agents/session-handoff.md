# Session Handoff

## Trajectory & Context
* Investigated blocked video embedding on `https://www.petersgasse.at`. Confirmed that SharePoint Online returns `X-Frame-Options: SAMEORIGIN` and CSP `frame-ancestors` restricting iframe embeds to Microsoft internal domains, accompanied by 403 Forbidden for unauthenticated visitors.
* Tested updated embed parameters (`ust: true`) via curl against `petersgasse-my.sharepoint.com` and confirmed the same framing restrictions and authentication requirement remain active on Microsoft's end.
* Removed the embedded video from `content/de/_index.md` per user request and cleaned up associated CSS rules.
* Resolved mobile horizontal viewport overflow by applying universal `box-sizing: border-box`, overflow clipping, responsive rules for media/tables, and properly pinning `.header` with right margin on `.navbar-burger`.
* Resolved persistent navigation dropdowns by overriding `anatole-header.js` with mutual exclusivity between dropdowns, click-outside detection, Escape key dismissal, and link-click closure.
* Resolved Hugo v0.158+ deprecation warnings: updated `languageCode` to `locale` and `languages.de.languageName` to `label` in `config/_default/hugo.toml`, and resolved template deprecations (`.Language.Direction` and `.Site.Language.Locale`) across layout overrides (`baseof.html`, `head.html`, `schema.html`, `rss.xml`).
* Cleaned 45 orphaned artifacts from `public/` (old school year PDFs, deprecated CSS/JS hash bundles, deleted pages) and configured `cleanDestinationDir = true` in `config/_default/hugo.toml` to automatically purge stale files on all subsequent builds.
* Designed and built automated publishing shell script `publish.sh` deploying the site to `ftp://pet001it@s1.weirer-it.at/petersgasse.at/`.
* Diagnosed ProFTPD hard quota limit (`8192 MB` via `mod_quotatab`) that caused `BrokenPipeError` during large file uploads. Resolved by deleting legacy `.prev` backups prior to upload, which freed ~125 MB and provided sufficient headroom (~209 MB free) for the Hugo build.
* Resolved ProFTPD `550 SIZE not allowed in ASCII mode` by enforcing `TYPE I` binary mode before integrity checks and configuring `latin-1` FTP encoding to support Austrian German umlauts.
* Re-encoded `static/Schulvideo_480p.mp4` to 8.44 MB (down from 34.1 MB) using `libx264` (`crf 26`, `preset slow`, `+faststart`), providing optimal web streaming performance without visual degradation.
* Generated lightweight poster frame images (`static/images/schulvideo-poster.webp` at 7.5 KB and `.jpg` at 24 KB) extracted from the video stream to eliminate black frame delays.
* Centered the video in `content/de/_index.md` with `.video-container` (`display: flex; justify-content: center`) and `.index-video` with `max-width: 852px` (matching native 480p width to prevent upscaling blurriness on 1080p/4K displays) and `aspect-ratio: 71 / 40` to guarantee zero Cumulative Layout Shift (CLS).
* Added automated silent autoplay reliability handler in `assets/js/anatole-header.js` to ensure immediate playback across mobile and desktop environments.
* Successfully executed full cleanup of legacy backup directory `/petersgasse.at/www.petersgasse.at.bak`, deleting 28,197 obsolete files and 4,137 directories, reducing server storage usage from 8,140 MB down to 551 MB (reclaiming over 7.5 GB of free quota headroom).
* Published updated release to production via `publish.sh`: verified all 286 remote files and byte sizes, rotated production backup, and activated release.
* Verified live production HTTP responses: `https://www.petersgasse.at/` (200 OK), `https://www.petersgasse.at/Schulvideo_480p.mp4` (200 OK, 8,438,987 bytes), and `https://www.petersgasse.at/images/schulvideo-poster.webp` (200 OK, 7,598 bytes).
* Resolved mobile Firefox autoplay failure: diagnosed that Gecko's mobile autoplay engine inspects audio track presence in the MP4 container; stripped the silent AAC audio stream entirely with `-an`, resulting in an intrinsically silent 8.37 MB MP4 with faststart.
* Enhanced video element attributes and execution timing: attached direct `src="/Schulvideo_480p.mp4"`, `defaultMuted`, `playsinline`, and `webkit-playsinline`, backed by an immediate synchronous script and a passive user-interaction fallback (`touchstart`, `scroll`, `click`) in case of strict cellular data-saver mode.
* Deployed release to production via `publish.sh`: verified all 286 remote files and byte sizes (including the 8,371,786 byte video).
* Verified live production HTTP responses: `https://www.petersgasse.at/` (200 OK) and `https://www.petersgasse.at/Schulvideo_480p.mp4` (200 OK, 8,371,786 bytes).
* Created separate feature branch `feature/corporate-identity-fonts` to implement the school's official corporate identity typography from `WG__Schulschrift.zip`.
* Extracted and converted all 16 font weights and styles of `Source Sans 3` (200 ExtraLight through 900 Black, normal and italic) to high-efficiency WOFF2 files (reducing font payload from 4.70 MB down to 1.38 MB, an 80% compression ratio) alongside original TTF fallbacks.
* Staged font assets in `assets/fonts/source-sans-3/` and `static/fonts/source-sans-3/`.
* Created `assets/css/fonts.css` with 16 comprehensive `@font-face` rules utilizing `font-display: swap`.
* Removed external Google Fonts request (`Open Sans`) from `config/_default/hugo.toml`, ensuring 100% self-hosted, GDPR-compliant local font serving.
* Established a structured typography hierarchy in `assets/css/styles.css` matching specific Source Sans 3 weights to all element categories: H1/H2 (Bold 700 uppercase), H3/H4/H5 (SemiBold 600), H6 (Medium 500), body/lists (Regular 400), strong/b (SemiBold 600), navigation/buttons (SemiBold 600), sidebar (Bold 700 / Regular 400), metadata (Regular 400), and tables (SemiBold 600 headers, Regular 400 tabular numeric cells). Explicitly preserved monospace code stacks and FontAwesome icon fonts.
* Added font preloads for primary weights (Regular, SemiBold, Bold) in `layouts/partials/head.html` to eliminate layout shift (CLS) and flash of unstyled text (FOUT).
* Launched local Hugo development server with draft rendering and fast render disabled on `http://localhost:1313`.

* Merged `feature/corporate-identity-fonts` back into `main` via fast-forward merge.
* Deployed full release to production via `publish.sh`: verified all 319 remote files and byte sizes across the FTP server.
* Verified live production HTTP responses: `https://www.petersgasse.at/` (200 OK), `https://www.petersgasse.at/fonts/source-sans-3/SourceSans3-Regular.woff2` (200 OK, 102,964 bytes), and `https://www.petersgasse.at/fonts/source-sans-3/SourceSans3-Bold.woff2` (200 OK, 102,776 bytes).
* Terminated local Hugo development server and verified port 1313 is closed.
* Switched back to `main` branch per user request.
* Replaced outdated Sprechstundenliste references on the homepage (`content/de/_index.md`) under "Aktuelle Aussendungen" and on the teacher directory page (`content/de/Schule/lehrpersonal.md`) with the notice: "Sprechstunden: Aktuelle Termine siehe WebUntis (Gesamtliste folgt demnächst)".
* Configured DataTable on `content/de/Schule/lehrpersonal.md` with `columnDefs: [{ target: [0, 3, 4], visible: false, searchable: false }]` to hide obsolete office hours columns from the 2025/26 school year.
* Backed up and purged legacy static files `static/Sprechtstundenliste.pdf` and `static/Sprechstunden_2324.pdf`.
* Added link to `static/Journaldienst_Bundesschulen.pdf` ("Journaldienst Schulpsychologie") under "# Unterstützungsangebote innerhalb der Schule" in `content/de/_index.md`.
* Started local Hugo development server (`http://localhost:1313`) for user review.
* Upon user approval, committed content changes to `main` (commit `9597147`).
* Terminated local Hugo development server and verified port 1313 is closed.
* Executed `./publish.sh`: compiled 121 pages via Hugo, uploaded 318 files (132.87 MB) to FTP remote `public`, verified byte size integrity of all 318 remote files, rotated `www.petersgasse.at` to `www.petersgasse.at.prev`, and promoted `public` to production `www.petersgasse.at`.
* Verified live production HTTP responses:
  - `https://www.petersgasse.at/` (HTTP 200 OK, serving updated Aussendungen and mental health support link)
  - `https://www.petersgasse.at/Journaldienst_Bundesschulen.pdf` (HTTP 200 OK, 357,732 bytes)
  - `https://www.petersgasse.at/Sprechtstundenliste.pdf` (HTTP 404 Not Found, confirmed purged)
  - `https://www.petersgasse.at/schule/lehrpersonal/` (HTTP 200 OK)

* Consolidated "Tag der offenen Tür: 16. Jänner 2027" announcement and link into a single clickable H2 heading in `content/de/_index.md`.
* Updated `assets/css/styles.css` to add high-specificity heading link rules (`h1 a`, `h2 a`, `h3 a`) for light and dark themes to guarantee visibility and proper line height across all color modes.
* Created detailed informational page `content/de/Blog/tag-der-offenen-tuer-2027.md` with full program descriptions, station overviews, Schnuppertage instructions for elementary school pupils, and link to the Bildungsdirektion Steiermark admission process.
* Shut down local Hugo development server and verified port 1313 is closed.
* Executed `./publish.sh`: compiled 122 pages via Hugo, uploaded 319 files (132.90 MB) to FTP remote `public`, verified file count and sizes, rotated `www.petersgasse.at` to `www.petersgasse.at.prev`, and promoted `public` to production `www.petersgasse.at`.
* Verified live production HTTP 200 responses:
  - `https://www.petersgasse.at/` (HTTP 200 OK, serving updated single-line clickable announcement)
  - `https://www.petersgasse.at/blog/tag-der-offenen-tuer-2027/` (HTTP 200 OK, full event details active)

## Current State
* Date: 2026-10-06
* Active Branch: `main`.
* Local Hugo development server stopped (port 1313 free).
* Production site `https://www.petersgasse.at` live with all changes published.

## Next Steps
* Standby for upcoming announcements or further website maintenance.


