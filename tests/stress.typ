// Stress tests for riemann-sum, fill-area, area-between, volume-of-revolution
#import "../lib.typ": plot, fill-area, area-between, riemann-sum, volume-of-revolution, fill-closed, note, vline

#set page(margin: 1cm, width: 21cm, height: auto)
#set text(size: 9pt)
#show heading.where(level: 2): it => { pagebreak(weak: true); it }

= Stress tests

== 1. Riemann rectangles poking above ymax (overflow?)
#plot(
  xmin: 0, xmax: 3.5, ymin: 0, ymax: 4,
  width: 8, height: 4,
  axis-x-pos: "bottom", axis-y-pos: "left",
  riemann-sum(x => x * x, domain: (0.0, 3.0), n: 6, method: "right",
              color: blue.lighten(80%), stroke: blue + 0.6pt),
  (fn: x => x * x, stroke: blue + 1.2pt),
)

== 2. fill-area exceeding ymax (overflow?)
#plot(
  xmin: 0, xmax: 4, ymin: 0, ymax: 3,
  width: 8, height: 4,
  axis-x-pos: "bottom", axis-y-pos: "left",
  fill-area(x => x * x, domain: (0.0, 3.0), color: red.lighten(75%)),
  (fn: x => x * x, stroke: red + 1.2pt),
)

== 3. Riemann domain wider than x-range (overflow?)
#plot(
  xmin: 0, xmax: 3, ymin: 0, ymax: 2,
  width: 8, height: 4,
  axis-x-pos: "bottom", axis-y-pos: "left",
  riemann-sum(x => calc.sqrt(x), domain: (0.0, 5.0), n: 8, method: "left",
              color: green.lighten(80%), stroke: green + 0.6pt),
  (fn: x => calc.sqrt(calc.max(x, 0.0)), stroke: green.darken(20%) + 1.2pt),
)

== 4. area-between with domain beyond axes (overflow?)
#plot(
  xmin: -1, xmax: 2, ymin: -1, ymax: 3,
  width: 8, height: 4,
  axis-x-pos: "center", axis-y-pos: "center",
  area-between(x => x + 2, x => x * x, domain: (-2.0, 3.0), color: purple.lighten(75%)),
  (fn: x => x + 2, stroke: blue + 1.2pt),
  (fn: x => x * x, stroke: red + 1.2pt),
)

== 5. Negative function riemann (below baseline)
#plot(
  xmin: 0, xmax: 3.5, ymin: -2.5, ymax: 1,
  width: 8, height: 4,
  axis-x-pos: "center", axis-y-pos: "left",
  riemann-sum(x => -calc.sqrt(x) - 0.5, domain: (0.0, 3.0), n: 6, method: "mid",
              color: orange.lighten(75%), stroke: orange.darken(20%) + 0.6pt,
              show-dx: true, show-xi: true),
  (fn: x => -calc.sqrt(calc.max(x, 0.0)) - 0.5, stroke: orange.darken(20%) + 1.2pt),
)

== 6. show-xi vs xtick labels overlap check
#plot(
  xmin: -0.2, xmax: 3.5, ymin: -0.1, ymax: 5.5,
  width: 8, height: 4.5,
  axis-x-pos: "bottom", axis-y-pos: "left",
  xtick: (0, 1, 2, 3), ytick: (1, 2, 3, 4, 5),
  show-origin: false,
  riemann-sum(x => x * x, domain: (0.0, 3.0), n: 6, method: "right",
              color: blue.lighten(80%), stroke: blue + 0.6pt,
              show-points: true, show-dx: true, show-xi: true),
  (fn: x => x * x, domain: (0.0, 3.2), stroke: blue + 1.4pt),
)

== 7. fill with NaN region (sqrt of negative)
#plot(
  xmin: -2, xmax: 4, ymin: -0.5, ymax: 2.5,
  width: 8, height: 4,
  axis-x-pos: "bottom", axis-y-pos: "center",
  fill-area(x => if x >= 0 { calc.sqrt(x) } else { none }, domain: (-1.0, 3.0), color: teal.lighten(75%)),
  (fn: x => if x >= 0 { calc.sqrt(x) } else { none }, stroke: teal.darken(20%) + 1.2pt),
)

== 8. Revolution: degenerate flat-zero function
#volume-of-revolution(x => 0.0, domain: (0.0, 3.0), n-disks: 3, width: 6, height: 3)

== 9. Revolution: function crossing the axis (sin)
#volume-of-revolution(x => calc.sin(x), domain: (0.0, 6.28), n-disks: 5, width: 8, height: 3.5)

== 10. Revolution: oblique axis, curve crossing it
#volume-of-revolution(x => x * x, domain: (0.01, 2.0), axis-slope: 1.0, n-disks: 4,
                      width: 7, height: 4)

== 11. fill-closed self-intersecting
#plot(
  xmin: -2, xmax: 2, ymin: -2, ymax: 2,
  width: 6, height: 6,
  fill-closed(t => calc.sin(2 * t), t => calc.sin(3 * t), domain: (0.0, 6.30),
              color: blue.lighten(70%)),
)

== 12. Riemann n = 1, lower method on non-monotone fn
#plot(
  xmin: -2.5, xmax: 2.5, ymin: -0.5, ymax: 5,
  width: 8, height: 4,
  axis-x-pos: "bottom", axis-y-pos: "center",
  riemann-sum(x => x * x, domain: (-2.0, 2.0), n: 1, method: "lower",
              color: gray.lighten(60%)),
  riemann-sum(x => x * x, domain: (-2.0, 2.0), n: 1, method: "upper",
              color: none, hatch: "ne", stroke: red + 0.6pt),
  (fn: x => x * x, stroke: blue + 1.2pt),
)
