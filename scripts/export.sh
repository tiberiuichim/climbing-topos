#!/usr/bin/env bash
# Export a topo sheet (HTML) to print-ready PDF, or to an HD PNG preview.
#
#   ./scripts/export.sh topos/vadu-crisului/turnu-babilonului--canguru-schiop.html
#   ./scripts/export.sh topos/vadu-crisului/turnu-babilonului--canguru-schiop.html --png
#
# The output file is written next to the HTML with the same basename.
# Requires Google Chrome or Chromium (headless).

set -euo pipefail

usage() {
  echo "usage: $0 <sheet.html> [--png]" >&2
  exit 1
}

[[ $# -lt 1 ]] && usage

src=""
mode="pdf"
for arg in "$@"; do
  case "$arg" in
    --png) mode="png" ;;
    --pdf) mode="pdf" ;;
    -h|--help) usage ;;
    *) src="$arg" ;;
  esac
done

[[ -f "$src" ]] || { echo "error: no such file: $src" >&2; exit 1; }

# locate a headless browser
browser=""
for candidate in "${CHROME_BIN:-}" chromium chromium-browser google-chrome google-chrome-stable; do
  [[ -n "$candidate" ]] && command -v "$candidate" >/dev/null 2>&1 && { browser="$candidate"; break; }
done
[[ -n "$browser" ]] || { echo "error: no chromium/chrome found (set CHROME_BIN)" >&2; exit 1; }

abs_src="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
base="${abs_src%.html}"

# give web fonts / CDN css time to load before printing
common=(--headless --disable-gpu --hide-scrollbars --virtual-time-budget=15000)

if [[ "$mode" == "png" ]]; then
  out="$base.png"
  # A4 at ~150 dpi, portrait
  "$browser" "${common[@]}" --window-size=1240,1754 --screenshot="$out" "file://$abs_src"
else
  out="$base.pdf"
  "$browser" "${common[@]}" --no-pdf-header-footer --print-to-pdf="$out" "file://$abs_src" \
    || "$browser" "${common[@]}" --print-to-pdf="$out" --print-to-pdf-no-header "file://$abs_src"
fi

# headless chromium exits 0 even when the page failed to load, so verify the artefact
if [[ ! -s "$out" ]]; then
  echo "error: $browser produced no output for $abs_src" >&2
  echo "hint: snap-packaged chromium cannot read paths like /tmp — point CHROME_BIN at" >&2
  echo "      a non-snap chrome, or run this from your home directory." >&2
  exit 1
fi

echo "wrote: $out"
