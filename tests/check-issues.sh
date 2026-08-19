#!/usr/bin/env bash
# Regression tests for the reported issues. Each assertion is measured on the
# rendered page, because every one of these bugs was a rendering bug.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! python3 -c "import PIL" 2>/dev/null; then
  echo "skip  issues (python3 Pillow absent)"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
typst compile tests/issue-fixtures.typ "$tmp/p-{p}.png" --root . --ppi 200

python3 - "$tmp" <<'PY'
import sys
from PIL import Image

d = sys.argv[1]
status = 0

def load(n):
    im = Image.open("%s/p-%d.png" % (d, n)).convert("L")
    return im, im.load(), im.size

def report(ok, name, detail):
    global status
    print(("ok    " if ok else "FAIL  ") + "%-22s %s" % (name, detail))
    if not ok:
        status = 1

# 1 — the horizontal curve y = 1 must be broken into dashes: scanning its row
# has to find several runs of ink separated by gaps.
im, px, (w, h) = load(1)
def runs_in_row(y):
    ink = [x for x in range(w) if px[x, y] < 128]
    if len(ink) < 20:
        return 0
    n = 1
    for a, b in zip(ink, ink[1:]):
        if b - a > 2:
            n += 1
    return n
best = max(runs_in_row(y) for y in range(h))
report(best >= 8, "dash (#11)", "%d segments sur la ligne la plus decoupee" % best)

# 2 — a "0" must be drawn somewhere near the origin.
im, px, (w, h) = load(2)
cx, cy = w // 2, h // 2
near = sum(1 for y in range(cy - 60, cy + 60) for x in range(cx - 60, cx + 60) if px[x, y] < 128)
im1, px1, _ = load(1)
report(near > 40, "zero a l'origine (#9)", "%d pixels d'encre autour de l'origine" % near)

# 3 — the grid must not be interrupted where a label is empty. Count how many
# of the vertical grid lines are continuous over the plot height.
im, px, (w, h) = load(3)
cols = {}
for x in range(w):
    cols[x] = sum(1 for y in range(h) if px[x, y] < 250)
tall = [x for x, c in cols.items() if c > 0.55 * h]
report(len(tall) >= 4, "grille continue", "%d colonnes de grille ininterrompues" % len(tall))

# 4 — with samples: 2000 the sine reaches its full amplitude everywhere: the
# curve's ink spans a tall band rather than the clipped zigzag of 100 samples.
im, px, (w, h) = load(4)
ys = [y for y in range(h) for x in range(0, w, 3) if px[x, y] < 128]
report(len(ys) > 0 and (max(ys) - min(ys)) > 0.15 * h, "samples (#7)",
       "amplitude tracee sur %d px" % (max(ys) - min(ys) if ys else 0))

raise SystemExit(status)
PY
