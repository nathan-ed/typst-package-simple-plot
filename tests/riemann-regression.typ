// Regression tests for riemann-sum rendering bugs (2026-07).
//
// Bugs covered:
//  1. Rectangle wider/taller than the plot window drew a stroked edge at the
//     clip boundary — a false flat top at ymax / false right edge at xmax
//     (visible with a decimal xmax like 2.5 and a wider domain like (0, 3)).
//  2. x_i labels collided with numeric tick labels (only exact-position
//     ticks were hidden, so a tick at 1 printed on top of x_i = 0.9).
//  3. show-dx + show-xi silently skipped the two x_i labels around the
//     bracket instead of moving the bracket below the label row.
//  4. show-points sprayed a method label with arrows to every dot by default.
//  5. Tick labels and axis labels painted a white background box on top of
//     area fills (the fills render first), punching white holes into them.
//  6. CeTZ labels always inherited the surrounding document font size, with
//     no way to make them follow the plot's own scale and label styles
//     (now `label-sizing: "plot"`).
//
// The assert blocks fail compilation if the geometry regresses; the plots
// below them are the exact user-reported configurations for visual checks.
#import "../lib.typ": plot, riemann-sum, riemann-heights, riemann-clip-rect

#set page(margin: 1cm, width: 21cm, height: auto)

#let approx(a, b, eps: 1e-9) = calc.abs(a - b) < eps

// ── riemann-heights: exact widths and heights ───────────────────────────────
#{
  let f = x => calc.pow(x, 2)

  // domain (0, 3), n = 10: every subinterval is exactly 0.3 wide and the
  // left-endpoint height is f(x_i) — including the ones past a window edge.
  let rects = riemann-heights(f, 0.0, 3.0, 10, "left", 20)
  assert(rects.len() == 10)
  for (i, r) in rects.enumerate() {
    assert(approx(r.xr - r.xl, 0.3), message: "width of rect " + str(i))
    assert(approx(r.xl, i * 0.3), message: "left edge of rect " + str(i))
    assert(approx(r.y, calc.pow(i * 0.3, 2)), message: "height of rect " + str(i))
  }

  // n = 11 (the reported failing count): widths 3/11, heights f(left edge).
  let rects11 = riemann-heights(f, 0.0, 3.0, 11, "left", 20)
  assert(rects11.len() == 11)
  for (i, r) in rects11.enumerate() {
    assert(approx(r.xr - r.xl, 3.0 / 11), message: "width of rect " + str(i) + " (n=11)")
    assert(approx(r.y, calc.pow(i * 3.0 / 11, 2)), message: "height of rect " + str(i) + " (n=11)")
  }

  // right / mid evaluation points
  let rr = riemann-heights(f, 0.0, 3.0, 6, "right", 20)
  assert(approx(rr.at(0).y, calc.pow(0.5, 2)))
  let rm = riemann-heights(f, 0.0, 3.0, 6, "mid", 20)
  assert(approx(rm.at(0).y, calc.pow(0.25, 2)))
}

// ── riemann-clip-rect: window clipping and surviving edges ──────────────────
#{
  // Fully inside: untouched, all four edges stroked.
  let c = riemann-clip-rect(0.9, 1.2, 0.0, 0.81, 0.0, 2.5, 0.0, 5.0)
  assert(approx(c.xl, 0.9) and approx(c.xr, 1.2))
  assert(approx(c.y-lo, 0.0) and approx(c.y-hi, 0.81))
  assert(c.left and c.right and c.top and c.bottom)

  // The reported bug: rect (2.4, 2.7) h = 5.76 in window x <= 2.5, y <= 5.
  // Width clips to 2.5, height to 5, and neither the right edge nor the
  // top may be stroked (they lie outside the window).
  let c = riemann-clip-rect(2.4, 2.7, 0.0, 5.76, 0.0, 2.5, 0.0, 5.0)
  assert(approx(c.xl, 2.4) and approx(c.xr, 2.5))
  assert(approx(c.y-hi, 5.0))
  assert(c.left and c.bottom)
  assert(not c.right, message: "clipped right edge must not be stroked")
  assert(not c.top, message: "clipped top edge must not be stroked")

  // Height overflow only (xmax = 3): top open, sides kept.
  let c = riemann-clip-rect(2.5, 3.0, 0.0, 6.25, 0.0, 3.0, 0.0, 5.0)
  assert(approx(c.xr, 3.0) and c.right)
  assert(approx(c.y-hi, 5.0) and not c.top)

  // Fully outside the window: nothing drawn.
  assert(riemann-clip-rect(2.7, 3.0, 0.0, 7.29, 0.0, 2.5, 0.0, 5.0) == none)
  assert(riemann-clip-rect(0.0, 1.0, 6.0, 8.0, 0.0, 2.5, 0.0, 5.0) == none)

  // Negative function (bar below baseline) clipped at ymin: bottom open.
  let c = riemann-clip-rect(1.0, 1.5, -4.0, 0.0, 0.0, 3.0, -2.0, 5.0)
  assert(approx(c.y-lo, -2.0) and not c.bottom and c.top)
}

// ── Visual: user-reported configurations ────────────────────────────────────
#let f(x) = calc.pow(x, 2)

// Decimal xmax with wider domain (n = 10 and n = 11). The last visible bar
// must be open at the top and right (no stroke at the window boundary), the
// x_i labels evenly spaced with no numeric tick printing over them.
#for n in (10, 11) {
  plot(
    xmin: 0, xmax: 2.5, ymin: 0, ymax: 5,
    riemann-sum(f, domain: (0.0, 3.0), n: n, method: "left",
      color: blue.lighten(75%), show-xi: true),
    (fn: f, stroke: blue + 1.5pt),
  )
  h(1cm)
}

// show-dx together with show-xi: the bracket drops below the label row and
// x_3, x_4 are NOT skipped. show-points draws dots only (no label spray).
#plot(
  xmin: 0, xmax: 3, ymin: 0, ymax: 5,
  riemann-sum(f, domain: (0.0, 3.0), n: 6, method: "left",
    color: blue.lighten(75%), show-points: true, show-dx: true, show-xi: true),
  (fn: f, stroke: blue + 1.5pt),
)
#h(1cm)
// show-dx alone: bracket hugs the axis, tick labels under it hidden.
#plot(
  xmin: 0, xmax: 3, ymin: 0, ymax: 5,
  riemann-sum(f, domain: (0.0, 3.0), n: 6, method: "left",
    color: blue.lighten(75%), show-dx: true),
  (fn: f, stroke: blue + 1.5pt),
)

// Negative function: annotations flip above the axis, bars clip at ymin
// with an open bottom. The tick labels ("1", "2") land inside the bars and
// must NOT paint a white box over the red fill.
#plot(
  xmin: 0, xmax: 3, ymin: -2, ymax: 1,
  riemann-sum(x => -calc.pow(x - 1, 2), domain: (0.0, 3.0), n: 6, method: "left",
    color: red.lighten(75%), show-xi: true, show-dx: true),
  (fn: x => -calc.pow(x - 1, 2), stroke: red + 1.5pt),
)
#h(1cm)
// Bars reach the axis end where the "x" axis label sits: the label must not
// punch a white hole into the last bar (its white background is suppressed
// over area fills).
#plot(
  xmin: 0, xmax: 2.5, ymin: 0, ymax: 5,
  riemann-sum(f, domain: (0.0, 3.0), n: 10, method: "left",
    color: blue.lighten(75%)),
  (fn: f, stroke: blue + 1.5pt),
)

// Large surrounding type. With label-sizing: "plot", every label inside the
// scaled plot (including custom x_i and Delta x) must keep the plot's own
// proportional font size instead of inheriting 18pt from this block.
#text(size: 18pt)[
  #plot(
    xmin: -0.12, xmax: 1.12, ymin: -0.28, ymax: 1.15,
    width: 6.0, height: 3.6, scale: 0.8,
    label-sizing: "plot",
    xtick: none, ytick-labels: none, show-origin: false,
    riemann-sum(
      f,
      domain: (0.0, 1.0),
      n: 6,
      method: "left",
      show-dx: true,
      show-xi: true,
      xi-labels: ($x_0$, $x_1$, $x_2$, $dots$, $x_(n-2)$, $x_(n-1)$, $x_n$),
    ),
    (fn: f, label: $f(x)=x^2$),
  )
]

// Same plot with the default label-sizing: "inherit" — labels follow the 18pt
// body text. Side by side with the block above, this is what the option does.
#text(size: 18pt)[
  #plot(
    xmin: -0.12, xmax: 1.12, ymin: -0.28, ymax: 1.15,
    width: 6.0, height: 3.6, scale: 0.8,
    xtick: none, ytick-labels: none, show-origin: false,
    riemann-sum(f, domain: (0.0, 1.0), n: 6, method: "left", show-dx: true),
    (fn: f, label: $f(x)=x^2$),
  )
]
