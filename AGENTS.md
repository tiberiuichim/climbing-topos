# AGENTS.md — working rules for this repository

Guidance for AI assistants (and future me) editing climbing topos here. Read this before
changing anything; the rules below exist because a topo sheet is both a **document** and a
**print artefact**, and because wrong climbing information is a safety problem, not a typo.

## What this repo is

A library of self-prepared climbing topos, mostly multipitch. Each topo is one HTML sheet
(interactive SVG + pitch-by-pitch beta + A4 print CSS) plus a printed PDF. `index.md` is the
table of contents, `topos/<area>/meta.md` holds the structured facts.

What it is **not**: a guidebook, a place to store prompts or generation pipelines, a place for
scraped third-party content.

## Hard rules

1. **Never invent climbing facts.** Grades, bolt/spit counts, bolt positions, belay locations,
   rapel stations, pitch lengths, approach times, first-ascent data. If a source does not state
   it, leave it out or write `TODO`. An invented bolt on a vectorial topo looks authoritative.
2. **Keep provenance visible.** Every sheet keeps its footer naming the original
   sketch/data source. Every area keeps `meta.md` with a `Verification status` row
   (`from sketches only` / `field-checked on <date>`). Do not silently upgrade status.
3. **Never hand-edit a PDF.** The PDF is generated. Edit the HTML, then re-export.
4. **Keep the three views in sync:** SVG picture, pitch text blocks, and `meta.md` /
   `index.md`. If a pitch is renumbered or a grade changes, update all of them in one commit.
5. **Do not add third-party content** (guidebook scans, other people's photos/topos) beyond
   short factual beta and attribution. This repo is public and CC-NC-SA licensed.

## Language

- Repo docs (`README.md`, `AGENTS.md`, `meta.md`, `index.md`, commit messages): **English**.
- Topo sheet content (titles, pitch descriptions, warnings, legend): **Romanian**, with proper
  diacritics (`ă â î ș ț`). Route names stay in Romanian everywhere, including English prose.
- Climbing jargon in Romanian sheets keeps the local terms (`regrupare`, `tăvănel`, `bavareză`,
  `LC`, `spit`, `anou`). Do not translate them into English mid-sentence.

## Layout & naming

```
topos/<area-slug>/<route-slug>.html
topos/<area-slug>/<route-slug>.pdf
topos/<area-slug>/meta.md
topos/<area-slug>/assets/          # photos, sketch scans (source material)
```

- Slugs: lowercase, ASCII, kebab-case, no diacritics (`vadu-crisului`, not `Vadu Crisului`).
- Shared sheet for two routes on one wall: join with `--`
  (`turnu-babilonului--canguru-schiop.html`).
- HTML and PDF basenames must match exactly.
- One folder per area; one sheet per wall (not per route) when routes share rock and belays.

## Anatomy of a topo sheet (HTML)

Keep the existing sheet's structure so all topos behave the same:

- Single self-contained file, `lang="ro"`, one `.a4-sheet` container per printed page
  (`210mm × 297mm`), `@media print { @page { size: A4 portrait; margin: 5mm } }`, and
  `-webkit-print-color-adjust: exact` so route colours survive printing.
- The topo itself is an **inline `<svg>`** with a stable `viewBox` — vectorial, no raster
  wall image. Route lines are `<path>`s, belays are clickable nodes (`R0`, `R1`, …), pitch
  numbers and grade labels are `<text>`.
- One colour per route, declared as CSS custom properties at the top
  (`--babilon-blue`, `--canguru-red`), reused in the legend.
- Interactive controls get `.no-print` so they never appear on paper.
- Sheet sections, in order: header (area, wall, routes, grades) → SVG topo with legend →
  per-route pitch blocks (length, grade, description, tactics/hazards) → orientation traps and
  hazards callout → descent/retreat → sources footer.
- Prefer **inline CSS** for everything print-critical. The existing sheet pulls Tailwind from a
  CDN and fonts from Google Fonts, which means an offline print loses layout — do not copy that
  habit into new sheets; inline the styles and use a system font stack (and fix it if asked).

## Editing an existing sheet

- Change the SVG and the text blocks together; a mismatch between the drawn pitch and the
  written pitch is the worst failure mode here.
- Keep IDs/classes stable (`#climbing-topo-svg`, `.a4-sheet`, `.no-print`, `.topo-element`) —
  the export script and the print CSS depend on them.
- After editing: re-export the PDF, check it is still A4 and the expected page count
  (`pdfinfo <file>.pdf`), and confirm colours printed (`pdftotext` for text sanity).

## Exporting PDF / PNG

Primary method is manual: open the HTML in Chrome/Chromium → Print → A4 portrait, margins
Default/None, **Background graphics on**.

Scripted (headless Chromium, writes next to the HTML):

```bash
./scripts/export.sh topos/vadu-crisului/turnu-babilonului--canguru-schiop.html
./scripts/export.sh <file>.html --png      # HD preview image instead
```

Equivalent raw command if the script is missing:

```bash
chromium --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf=out.pdf --print-to-pdf-no-header file:///abs/path/sheet.html
```

## Git

- Branch `main`; small commits, imperative subject, prefix with the area slug when obvious:
  `vadu-crisului: fix R1/2 junction label`.
- Commit HTML and PDF together so the printed artefact always matches the source.
- Binary assets in `assets/` are fine; keep individual files under ~5 MB, use Git LFS beyond
  that (large photo scans make cloning on a phone painful).
- Never commit: private landowner/access agreements, gate codes, or precise access coordinates
  for areas that are closed, restricted or seasonal (nesting).

## Checklist for a new topo

1. `topos/<area-slug>/` folder + `assets/` with the source sketches/photos you are allowed to keep.
2. Sheet HTML: SVG wall, one colour per route, belay nodes, legend, pitch blocks, traps,
   descent, sources footer.
3. `meta.md`: area facts, route table (grade, pitches, length, first ascent), key beta,
   sources, verification status, last-updated date.
4. Export the PDF; verify A4, page count, colours.
5. Add the row + area section to `index.md`.
6. Commit HTML + PDF + docs in one commit.
