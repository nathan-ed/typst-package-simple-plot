// Numerical checks for hermite-spline: compiling this file is the test, every
// check is an assert. tests/check-hermite-tangent.sh also renders it.
#import "../lib.typ": plot, hermite-spline, scatter, zoom, _hermite-eval

#set page(margin: 1cm, width: 21cm, height: auto)

#let close(a, b, tol: 1e-9) = calc.abs(a - b) <= tol * calc.max(1, calc.abs(b))

// Interpolation: the spline passes through every support point.
#let pts = ((-2, 1, 0), (0, -1, 0), (1, 0, 2), (3, 2, 0))
#let spec = hermite-spline(pts)
#for (x, y, _) in pts {
  assert(close((spec.fn)(x), y), message: "value at knot x=" + repr(x))
}

// Prescribed slopes: central differences at each interior knot.
#for (x, _, m) in pts.slice(1, -1) {
  let d = 1e-6
  let slope = ((spec.fn)(x + d) - (spec.fn)(x - d)) / (2 * d)
  assert(close(slope, m, tol: 1e-5), message: "slope at knot x=" + repr(x))
}

// Cubic Hermite interpolation reproduces any cubic exactly, whatever the
// (uneven) knot spacing.
#let p(x) = 0.5 * x * x * x - x * x + 2 * x - 3
#let dp(x) = 1.5 * x * x - 2 * x + 2
#let cubic = hermite-spline((-2, -0.5, 1, 1.25, 4).map(x => (x, p(x), dp(x))))
#for i in range(61) {
  let x = -2 + i * 0.1
  assert(close((cubic.fn)(x), p(x), tol: 1e-9), message: "cubic at x=" + repr(x))
}

// The curve exists exactly on [first x, last x], and the spec is a plain
// function series over that domain.
#assert.eq(spec.domain, (-2.0, 3.0))
#assert.eq((spec.fn)(-2.0001), none)
#assert.eq((spec.fn)(3.0001), none)
#assert(close((spec.fn)(3.0 + 1e-12), 2.0), message: "end-point rounding absorbed")
#assert.eq(spec.samples, 24 * 3)
#assert.eq(hermite-spline(pts, samples: 5).samples, 15)

// Two points, integer and float input mixed.
#let two = hermite-spline(((0, 0, 1), (2.5, 1, 0)))
#assert(close((two.fn)(0), 0) and close((two.fn)(2.5), 1))
#assert.eq(_hermite-eval(((0., 0., 0.), (1., 1., 0.)), 0.5), 0.5)

= hermite-spline

Exact derivatives taken from sin/cos: the spline (thin blue) lies on the true
curve (thick red).
#let xs = (0, calc.pi / 2, calc.pi, 3 * calc.pi / 2, 2 * calc.pi)
#plot(xmin: -0.3, xmax: 2 * calc.pi + 0.3, ymin: -1.4, ymax: 1.4, width: 8, height: 3.5,
  (fn: x => calc.sin(x), stroke: red + 2.2pt, label: $sin(x)$),
  hermite-spline(xs.map(x => (x, calc.sin(x), calc.cos(x))), stroke: blue + 0.9pt, label: [Hermite]),
)

A spline overshooting the window is cut at the edge, not bridged by a chord:
#let over = ((-2, 1, 0), (0, -1, 0), (1, 0, 6), (3, 1, 0))
#plot(xmin: -3, xmax: 4, ymin: -2, ymax: 1.5, width: 8, height: 4,
  hermite-spline(over, label: $C_f$, label-pos: 0.3),
  scatter(over.map(p => (p.at(0), p.at(1))), mark: "*"),
)

`zoom()` redraws a spline:
#let flat = ((0, 0), (1, 3), (2, 1), (3, 2), (4, 0.5), (5, 3))
#plot(xmin: -0.3, xmax: 5.3, ymin: -0.3, ymax: 3.5, width: 8, height: 4,
  hermite-spline(flat.map(p => (p.at(0), p.at(1), 0)), stroke: blue + 1.2pt),
  scatter(flat, mark: "o", mark-fill: white, mark-stroke: black + 1pt),
  zoom(center: (3, 2), size: 1.4, magnification: 3, at: (1, 3)),
)
