// Regression tests for volume-of-revolution.
//
// 1-2: the closing cap at x = b must show a visible rim. Before the fix the
//      right cap was only filled and its dashed back arc was painted over by
//      the body, so the solid ended in a grey blob with no outline.
// 3-6: hollow solids (inner-fn) — annular caps and washer cross-sections.
#import "../lib.typ": volume-of-revolution

#set page(width: 20cm, height: auto, margin: 1cm)
#set text(size: 10pt)

*1. solid, n-disks: 5 — closing cap at b is stroked*
#volume-of-revolution(
  x => 1.0 + 0.55 * calc.sqrt(calc.max(x, 0.0)),
  domain: (0.0, 4.0), n-disks: 5, width: 7.0, height: 3.4, show-y-axis: true,
)

*2. cone — radius 0 at a, so no left cap, but b still closes*
#volume-of-revolution(
  x => 0.5 * x,
  domain: (0.0, 4.0), n-disks: 5, width: 6.2, height: 3.0, show-y-axis: true,
  label-a: $0$, label-b: $4$,
)

*3. hollow — annular caps and washer cross-sections*
#volume-of-revolution(
  x => 1.6 + 0.25 * x, inner-fn: x => 0.5 + 0.18 * x,
  domain: (0.0, 4.0), n-disks: 4, width: 7.0, height: 3.4, show-y-axis: true,
  label-f: $g$, label-inner: $f$,
)

*4. hollow, n-disks: 0 — only the two annular caps*
#volume-of-revolution(
  x => 2.0 - 0.15 * x, inner-fn: x => 0.9,
  domain: (0.0, 4.0), n-disks: 0, width: 7.0, height: 3.4,
)

*5. hollow, show-back: false — half view*
#volume-of-revolution(
  x => 1.6 + 0.25 * x, inner-fn: x => 0.5 + 0.18 * x,
  domain: (0.0, 4.0), n-disks: 3, width: 7.0, height: 3.4, show-back: false,
)

*6. degenerate hole — inner-fn touching and exceeding fn must not overflow*
#volume-of-revolution(
  x => 1.0 + 0.2 * x, inner-fn: x => 3.0,
  domain: (0.0, 4.0), n-disks: 3, width: 7.0, height: 3.0,
)

*7. hollow with a custom inner stroke and hole colour*
#volume-of-revolution(
  x => 1.8, inner-fn: x => 0.8,
  domain: (0.0, 4.0), n-disks: 3, width: 7.0, height: 3.0,
  inner-stroke: red + 0.8pt, hole-color: luma(245),
)
