// Numerical checks for tangent-line: compiling this file is the test, every
// check is an assert. tests/check-helpers.sh also renders it.
#import "../lib.typ": plot, tangent-line, hermite-spline, zoom

#set page(margin: 1cm, width: 21cm, height: auto)

#let close(a, b) = calc.abs(a - b) <= 1e-12

// The line y = slope (x - x0) + y0 on [x0 - left, x0 + right].
#let t = tangent-line(1, 1, 2, left: 0.8, right: 0.5)
#assert(close((t.fn)(1), 1))
#assert(close((t.fn)(0.2), -0.6))
#assert(close((t.fn)(1.5), 2))
#assert(close(t.domain.at(0), 0.2) and close(t.domain.at(1), 1.5))
#assert.eq(tangent-line(2, 0, 1, left: 0, right: 1).domain, (2, 3))
#assert.eq(tangent-line(2, 0, 1, left: 1, right: 0).domain, (1, 2))

// Stroke: default, bare colour, bare thickness, dashed, a dash pattern, and
// the fields of a full stroke kept through the dash.
#let st(..args) = tangent-line(0, 0, 1, ..args).stroke
#assert.eq(st(), stroke(paint: luma(100), thickness: 0.6pt))
#assert.eq(st(stroke: red), stroke(paint: red, thickness: 0.6pt))
#assert.eq(st(stroke: 2pt), stroke(paint: luma(100), thickness: 2pt))
#assert.eq(st(dashed: true).dash, stroke(dash: "dashed").dash)
#assert.eq(st(dashed: "dotted").dash, stroke(dash: "dotted").dash)
#assert.eq(st(stroke: (paint: red, dash: "dotted")).dash, stroke(dash: "dotted").dash)
#let full = st(stroke: (paint: blue, thickness: 1pt, cap: "round", join: "bevel"), dashed: true)
#assert.eq((full.paint, full.thickness, full.cap, full.join), (blue, 1pt, "round", "bevel"))
#assert.eq(full.dash, stroke(dash: "dashed").dash)
#assert.eq(st(stroke: none), none)

= tangent-line

Tangent and half-tangent on $y = x^2$, a dashed one long enough to leave the
window at both ends (cut at the edges), a dotted one and a bare colour stroke:
#plot(xmin: -1, xmax: 3, ymin: -1, ymax: 4, width: 8, height: 4,
  (fn: x => x * x, stroke: blue + 1.2pt),
  tangent-line(1, 1, 2, left: 3, right: 3, dashed: true, label: $T_1$, label-pos: 0.6),
  tangent-line(0, 0, 0, left: 0, right: 0.7, stroke: red),
  tangent-line(-0.5, 0.25, -1, left: 0.4, right: 0.4, dashed: "dotted"),
)

Half-tangents at the corner of $|x - 1|$, redrawn by `zoom()`:
#plot(xmin: -1, xmax: 3, ymin: -0.5, ymax: 2, width: 8, height: 4,
  (fn: x => calc.abs(x - 1), stroke: blue + 1.2pt),
  tangent-line(1, 0, -1, left: 0.6, right: 0, stroke: red + 0.8pt),
  tangent-line(1, 0, 1, left: 0, right: 0.6, stroke: red + 0.8pt),
  zoom(center: (1, 0.2), size: 0.6, magnification: 2.5, at: (2.3, 1.6)),
)

Together with `hermite-spline`, the tangents at the support points:
#let pts = ((-2, 1, 0), (0, -1, 0), (1, 0, 2), (3, 2, 0))
#plot(xmin: -3, xmax: 4, ymin: -2, ymax: 3, width: 8, height: 4,
  hermite-spline(pts, label: $C_f$),
  ..pts.map(((x, y, m)) => tangent-line(x, y, m, stroke: red + 0.8pt)),
)

A tangent whose domain lies wholly outside the window draws nothing, and its
label is not placed either (no floating "T" at the right edge):
#plot(xmin: 0, xmax: 3, ymin: -1, ymax: 2, width: 6, height: 2.5,
  tangent-line(5, 1, 0, label: $T$),
  tangent-line(1, 1, 0, stroke: none, label: $S$),
)
