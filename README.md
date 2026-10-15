# Climbing Topos

Personal library of climbing topos I prepare myself — mostly **multipitch** routes — with an
emphasis on keeping the *final result* organized, versioned, easy to reference on the phone and
easy to print at A4.

I use AI tools and web sources during preparation (sketch reconstruction, redrawing, drafting
the pitch descriptions), but this repository is **not** about that pipeline — it is about the
deliverables: one clean vector sheet per wall, one printable PDF per topo, one index of
everything.

> ⚠️ **Not a guidebook.** These are working topos, reconstructed from published sketches and
> beta, and not verified bolt-by-bolt on the wall. Grades, bolt positions, belay locations and
> retreat options can be wrong or outdated. Climbing multipitch routes is dangerous: check the
> current condition of the gear, carry your own rack and belay/vthread material, and have a
> descent plan before you leave the ground.

## Repository layout

```
climbing-topos/
├─ README.md
├─ AGENTS.md                  # conventions for AI assistants working in this repo
├─ LICENSE                    # CC BY-NC-SA 4.0
├─ index.md                   # master table of all topos
├─ scripts/
│  └─ export.sh               # optional: HTML -> PDF/PNG via headless Chromium
└─ topos/
   └─ <area-slug>/            # one folder per climbing area
      ├─ meta.md              # area + route facts, sources, verification status
      ├─ <route-slug>.html    # master source: interactive SVG topo + beta, A4 print CSS
      ├─ <route-slug>.pdf     # print-ready A4 export
      └─ assets/              # source photos, sketch scans, reference images
```

## Using a topo

1. **On the wall / phone** — open the `.html` in a browser. It is a single self-contained file:
   the topo is an SVG, so it scales without blurring, and you can filter to a single route,
   toggle between full sheet / sketch only, and tap a belay (`R0`, `R1`, …) or pitch to
   highlight its technical details.
2. **On paper** — print the `.pdf` (A4 portrait, 2 pages). Or print the HTML directly:
   `Ctrl/Cmd-P` → destination *Printers* → paper **A4**, portrait, margins **Default/None**,
   and **tick "Background graphics"** — the route lines, colours and shading are background
   layers and disappear otherwise.
3. **Find something** — start at [`index.md`](index.md); every topo has one row there.

## Adding a topo

```
topos/<area-slug>/<route-slug>.html    # the sheet itself
topos/<area-slug>/<route-slug>.pdf     # printed from the HTML
topos/<area-slug>/meta.md              # grades, first ascents, gear, descent, sources, status
index.md                               # add a row
```

Naming: lowercase kebab-case ASCII slugs, `--` (double dash) separating route names on shared
sheets, e.g. `turnu-babilonului--canguru-schiop.html`. Area folders are slugs too
(`vadu-crisului`, not `Vadu Crisului`) so links and scripts stay portable across OSes. Keep the
HTML and PDF with **identical basenames** — the PDF is always regenerable from the HTML.

Regenerate the print files with the helper script (needs Chromium/Chrome):

```bash
./scripts/export.sh topos/vadu-crisului/turnu-babilonului--canguru-schiop.html
```

## Attribution & license

Every topo states its original data source in-sheet and in its `meta.md`. The route lines and
sketches in the Vadu Crișului topo derive from the original sketches of Adrian Păută, Gina
Păută, Ștefan Soloși and Raluca Păută; the vectorial redraw and the text are my reconstruction
(AI-assisted) of those sources.

- **This repository:** [CC BY-NC-SA 4.0](LICENSE) — attribution, non-commercial, share-alike.
- **Underlying material:** guidebook text, published sketches and photos remain the property of
  their authors. If you are a rights holder and want something removed or credited differently,
  open an issue.
