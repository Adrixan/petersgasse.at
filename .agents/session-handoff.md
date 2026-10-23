# Session Handoff

## Trajectory & Context
* Committed `Pfandsammeln.mp4` and `images/pfandsammeln-poster.webp` inside the `static/` subrepository and pushed commit `6a4d3d1` to `git@github.com:Adrixan/petersgasse-static.git`.
* Published the Pfandsammel-Aktion release via `publish.sh`: 322 files (136.15 MB) uploaded and byte-size verified, production folder rotated and activated.
* Verified live production HTTP 200 responses for `/blog/pfandsammeln/` and `/Pfandsammeln.mp4`.
* Discovered that `static/` is a separate git submodule/subrepository pointing at `git@github.com:Adrixan/petersgasse-static.git`, explaining why `git add -f` silently skipped the new video assets; the outer repo intentionally ignores `/static/`.
* Reverted the temporary `.gitignore` negation rules back to the original plain `/static/` ignore entry.
* Adjusted the blog post date from 12 October to 9 October 2026 to reflect the original email announcement date.
* Compressed the provided 21 MB original video to `static/Pfandsammeln.mp4` (3.3 MB, H.264/AAC, 640x364, CRF 27, faststart) with audio preserved, and generated a 5.4 KB poster frame at `static/images/pfandsammeln-poster.webp`.
* Created blog post `content/de/Blog/pfandsammeln.md` ("Pfandsammel-Aktion an unserer Schule", dated 2026-10-12) with the approved editorially adapted email text from 9 October, embedding the video with the homepage's autoplay reliability pattern (muted, playsinline, user-interaction fallback).
* Verified a clean Hugo build and confirmed the rendered blog page contains the autoplay video element.
* Added the school psychologist's 2026 consultation dates to the homepage under "Unterstützungsangebote innerhalb der Schule". The notice states that the psychologist is available from 9:00 in the meeting room, with 14 December ending at 12:00.
* Verified the homepage with a successful quiet Hugo build.
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

* 2026-10-22: Built the Erasmus+ section from `WG__Erasmus+_Einzelmobilitäten_von_Schüler_innen_(Homepage).zip` (4 student reports from Florenz 2025/26 plus 9 photos).
  - Menu: "Erasmus+" dropdown (weight 650) with Überblick (`/erasmus/`), Viareggio 2025 (existing blog post) and Florenz 2025/26.
  - Content: `content/de/Erasmus/_index.md` (overview, OeAD link) and `florenz-2025-26.md` (four reports, light copy edits only: typos, German quotes, paragraph breaks in Mia's text).
  - Logos per erasmusplus.schule/mediathek (Formulare & Logos): EU emblem "Kofinanziert von der Europäischen Union" plus Erasmus+ logo "Enriching lives, opening minds." without flag; originals from the PAD Dokumentencenter, trimmed and pngquant-optimised in `static/images/erasmus/`. Disclaimer text reused from the Viareggio post.
  - Templates: `layouts/erasmus/{list,single}.html` append `partials/erasmus-logos.html` automatically to every page in the section; logos sit in a `<section class="post__content">` so the theme's medium-zoom (`div.post__content img`) skips them. Shortcodes `galerie` + `foto` (alt required, dimensions via imageConfig, justified rows via `--ar`).
  - Photos: auto-oriented, metadata stripped, max 1600 px WebP q80 in `static/images/erasmus/florenz-2025-26/`.
  - User approved after review; disclaimer wording kept as is (user decision). Merged `feature/erasmus-section` with `--no-ff` into `main` in the outer repo (8a034e9) and the static subrepo (377b92e), both pushed; feature branches deleted after verification.
  - Static subrepo: committed the updated `Hausordnung.pdf` (130,185 bytes, 2 pages, dated 2026-10-22).
  - Outer repo: deleted the source ZIP; committed `original-2B6CAE5E-C12D-4587-9570-2C307CD3CD0C.mp4` (21 MB original Pfandsammeln video) at the repo root on user request.
  - Published via `publish.sh`: 126 pages, 336 files uploaded and verified, production rotated. Live HTTP 200 for `/`, `/erasmus/`, `/erasmus/florenz-2025-26/`, both logos, photos and `/Hausordnung.pdf` (130,185 bytes).

* 2026-10-23: Extended the Erasmus+ section from `erasmus/` (einleitungstext, `Gruppenmobilität_Bratislava.zip`, `Weitere_Einträge_für_die_Homepage.zip`).
  - Overview intro replaced with the accreditation text ("Petersgasse goes Europe", own accreditation since 01.02.2025); "Gruppenmobilität" renamed to "Gruppenmobilitäten".
  - New `content/de/Erasmus/bratislava-2026.md` (7B at Gymnázium Bilíkova, 27.–30.04.2026, student feedback; light comma/typo fixes only) with one group photo.
  - The second ZIP held a teacher training (CLIL course, Europass Teachers Academy Dublin, 12.–19.07.2026), not a group mobility; user chose a separate "Fortbildungen" section. New `dublin-2026.md` with 4 photos, teacher names linked to their staff pages.
  - Menu: Überblick, Viareggio 2025, Bratislava 2026, Florenz 2025/26, Dublin 2026. CSS: lone gallery photo capped at 900 px.
  - Merged `--no-ff` into `main` in both repos (outer 09be36f, static 7c7b377) and pushed; branches deleted. NOT published yet: awaiting user go. Dev server running on 127.0.0.1:1313.
  - Source folder `erasmus/` in the repo root was never committed; deleted on user request 2026-10-23.

* 2026-10-23 (later): Restructured Erasmus+ into nested sections on user request.
  - `content/de/Erasmus/{gruppenmobilitaeten,einzelmobilitaeten,fortbildungen}/` each with `_index.md` (intro, `weight`, `description`, `teaser`, `kategorie` key); reports moved inside. Menu: Überblick, Gruppenmobilitäten, Einzelmobilitäten, Fortbildungen.
  - `layouts/erasmus/list.html` renders subsections (top level) and reports (category level) as cards via `partials/erasmus-cards.html`; category pages also pull in pages from other sections with `erasmus_kategorie = '<kategorie>'` (Viareggio blog post). Reports show an "Alle <Kategorie>" back link. Cards sit in `<section class="post__content">` to avoid medium-zoom.
  - Teasers 600x450 WebP in `static/images/erasmus/teaser/`. Florenz has alias `/erasmus/florenz-2025-26/` (was live). Bratislava/Dublin were never published, no aliases.
  - Merged `--no-ff` in both repos (outer 2f4d75a, static f504afa), pushed, branches deleted.
  - Published 2026-10-23 via `publish.sh`: 354 files uploaded and verified, production rotated. Live HTTP 200 for `/erasmus/`, all three category pages, the Bratislava, Florenz and Dublin reports, `/blog/viareggio-2025/` and the new images; `/erasmus/florenz-2025-26/` redirects to the new Florenz URL; menu shows the four Erasmus+ entries.

## Current State
* Date: 2026-10-23
* Active Branch: `main` in the outer repo and the static subrepo, both pushed and in sync with origin.
* Local Hugo development server stopped (port 1313 free).
* Production site `https://www.petersgasse.at` live with the restructured Erasmus+ section (Überblick, Gruppenmobilitäten with Bratislava and Viareggio, Einzelmobilitäten with Florenz, Fortbildungen with Dublin).

## Next Steps
* SECURITY: `publish.sh` is tracked in the PUBLIC repo `Adrixan/petersgasse.at` and contains the FTP password as a hardcoded default (`FTP_PASS`). Rotate the FTP password at the hoster, remove the default from `publish.sh` (require `.env`, which is gitignored), and decide whether to purge it from git history. Reported to the user 2026-10-22; still awaiting decision.
* Bratislava report: Philipp's feedback mentions Slovakia's "Nähe zu Russland und der korrupten Politik"; published verbatim, flagged to the user for review with the supervising teacher. The text also says the return visit is planned for "Ende Oktober 2026"; update once it has happened.
* Erasmus+ category intro texts on the three overview pages were written by Claude (no source text); user was asked to proofread.
* The `static/` subrepo still holds uncommitted, already published changes (Infoblatt_Schulpsychologie, deleted Sprechstunden PDFs, Journaldienst, Schulvideo files, fonts, Schulvideo posters) awaiting separate review.
* Adding Erasmus+ reports: new Markdown file in the matching `content/de/Erasmus/<kategorie>/` folder with `description` and `teaser` (600x450 WebP in `static/images/erasmus/teaser/`); blog posts join a category via `erasmus_kategorie = '<kategorie>'`.
