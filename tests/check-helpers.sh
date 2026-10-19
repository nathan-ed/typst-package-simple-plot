#!/usr/bin/env bash
# Tests for the pedagogical curve helpers: the numerical asserts in their test
# files, the error messages for invalid input, and a pixel check that a curve
# leaving the window is cut at the edge instead of bridged by a chord.
set -euo pipefail
cd "$(dirname "$0")/.."
root=$(pwd)

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
status=0

for f in tests/hermite-spline.typ; do
  if typst compile "$f" "$tmp/out.pdf" --root . 2>"$tmp/err"; then
    echo "ok    $f"
  else
    echo "FAIL  $f"; cat "$tmp/err"; status=1
  fi
done

# Each invalid call must fail to compile with a message containing the
# expected text.
expect_error() {
  local call=$1 expected=$2
  printf '#import "%s/lib.typ": *\n#plot(%s)\n' "$root" "$call" > "$tmp/bad.typ"
  if typst compile "$tmp/bad.typ" "$tmp/bad.pdf" --root / 2>"$tmp/err"; then
    echo "FAIL  accepted: $call"; status=1
  elif grep -qF "$expected" "$tmp/err"; then
    echo "ok    rejected: $call"
  else
    echo "FAIL  wrong error for: $call"; cat "$tmp/err"; status=1
  fi
}

expect_error 'hermite-spline(((0, 0, 1),))' "need an array of at least 2 points"
expect_error 'hermite-spline(((0, 0), (1, 1)))' "each point must be (x, y, dy/dx), got (0, 0)"
expect_error 'hermite-spline(((0, 0, 1), (0, 1, 0)))' "x values must be strictly increasing, got 0 then 0"
expect_error 'hermite-spline(((1, 0, 1), (0, 1, 0)))' "x values must be strictly increasing, got 1 then 0"
expect_error 'hermite-spline(((0, 0, 1), (1, 1, 0)), samples: 0)' "samples must be a positive integer"

# Pixel check: the spline rises above ymax between x = 1.3 and x = 2.4.
# Cut at the edge, it leaves only steep strokes in the top band of the plot;
# filtered and re-joined, a horizontal chord would cross that band.
if python3 -c "import PIL" 2>/dev/null; then
  {
    printf '#import "%s/lib.typ": *\n' "$root"
    printf '#set page(width: auto, height: auto, margin: 0pt)\n'
    printf '#plot(xmin: -3, xmax: 4, ymin: -2, ymax: 1.5, width: 7, height: 3.5, show-grid: false,\n'
    printf '  hermite-spline(((-2, 1, 0), (0, -1, 0), (1, 0, 6), (3, 1, 0)), stroke: black + 1pt))\n'
  } > "$tmp/clip.typ"
  typst compile "$tmp/clip.typ" "$tmp/clip.png" --root / --ppi 100
  python3 - "$tmp/clip.png" <<'PY' || status=1
import sys
from PIL import Image
im = Image.open(sys.argv[1]).convert("L")
w, h = im.size
px = im.load()
longest = 0
for y in range(int(h * 0.12)):
    run = 0
    for x in range(w):
        run = run + 1 if px[x, y] < 128 else 0
        longest = max(longest, run)
ok = longest < w * 0.04
print(("ok    " if ok else "FAIL  ")
      + "clipped at the edge   longest run in the top band: %d px of %d" % (longest, w))
sys.exit(0 if ok else 1)
PY
else
  echo "skip  pixel check (python3 Pillow absent)"
fi

exit $status
