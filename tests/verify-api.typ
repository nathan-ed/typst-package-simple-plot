#import "../lib.typ": plot, plot-fn, fill-area, area-between, riemann-sum, func-plot, zoom, volume-of-revolution, scatter, data

#set page(margin: 1cm, width: 21cm, height: auto)
#let f(x) = calc.sin(x)

= 1. Thick hatch stroke (no holes at tile corners)
#plot(
  xmin: -4, xmax: 4, ymin: -2, ymax: 2,
  (fn: f, stroke: blue + 1.5pt),
  fill-area(
    fn: f,
    domain: (0.0, calc.pi),
    hatch: "ne",
    hatch-spacing: 10pt,
    hatch-stroke: red + 1.5pt,
  ),
)

All hatch styles at 2pt stroke, 12pt spacing:
#for style in ("ne", "nw", "h", "v", "cross", "grid") {
  box(plot(
    xmin: 0, xmax: 3, ymin: 0, ymax: 2, width: 3, height: 2,
    fill-area(x => 1.8, domain: (0.2, 2.8), hatch: style,
      hatch-spacing: 12pt, hatch-stroke: purple + 2pt),
  ))
}

= 2. width/height as lengths
#box(stroke: green, plot(width: 60mm, height: 4cm, (fn: f,)))
should equal
#box(stroke: green, plot(width: 6, height: 4, (fn: f,)))

= 3. fn positional vs named (same output)
#plot(xmin: 0, xmax: 4, ymin: -2, ymax: 2, width: 5, height: 3,
  fill-area(f, domain: (0.0, calc.pi), color: blue.lighten(70%)),
  area-between(x => -1.5, x => -1.0, domain: (2, 3), color: red.lighten(70%)),
  riemann-sum(x => 0.5 * x, domain: (0.0, 2.0), n: 4),
  func-plot(f, stroke: blue + 1.2pt),
)
#plot(xmin: 0, xmax: 4, ymin: -2, ymax: 2, width: 5, height: 3,
  fill-area(fn: f, domain: (0.0, calc.pi), color: blue.lighten(70%)),
  area-between(fn1: x => -1.5, fn2: x => -1.0, domain: (2, 3), color: red.lighten(70%)),
  riemann-sum(fn: x => 0.5 * x, domain: (0.0, 2.0), n: 4),
  func-plot(fn: f, stroke: blue + 1.2pt),
)

= 4. zoom: length sizes + transparent inset
#plot(xmin: -5, xmax: 5, ymin: -2, ymax: 2,
  (fn: f, stroke: blue + 1.2pt),
  zoom(center: (0, 0), size: 8mm, magnification: 3, at: (3, 1.2), box-fill: none),
)

= 4b. zoom re-renders fills, Riemann, vline (rect + circle lens)
#let busy = (
  fill-area(f, domain: (0.0, calc.pi), hatch: "ne", hatch-spacing: 5pt, hatch-stroke: red + 0.8pt),
  riemann-sum(f, domain: (0.0, 2.0), n: 4, color: blue.lighten(80%), stroke: blue + 0.6pt),
  (vline: 1.0, stroke: (paint: gray, thickness: 0.6pt, dash: "dashed")),
  (fn: f, stroke: blue + 1.2pt),
)
#plot(xmin: -1, xmax: 5, ymin: -1.5, ymax: 1.5, width: 7, height: 3.5,
  ..busy,
  zoom(center: (1.5, 0.9), size: 1.0, magnification: 2.5, at: (3.8, -0.8)),
)
#plot(xmin: -1, xmax: 5, ymin: -1.5, ymax: 1.5, width: 7, height: 3.5,
  ..busy,
  zoom(center: (1.5, 0.9), size: 1.0, magnification: 2.5, at: (3.8, -0.8), lens-shape: "circle"),
)

= 5. plot-fn forwards samples + volume with lengths
#plot-fn(x => calc.sin(8 * x), domain: (0, 3), samples: 400, width: 6, height: 3)
#volume-of-revolution(x => calc.sqrt(x + 1), domain: (0, 3), n-disks: 4, width: 50mm, height: 35mm)

= 6. hatch dict form (same output as flat form)
#plot(xmin: 0, xmax: 4, ymin: 0, ymax: 2, width: 5, height: 2.5,
  fill-area(f, domain: (0.0, calc.pi), hatch: "ne", hatch-spacing: 8pt, hatch-stroke: red + 1pt),
  (fn: f, stroke: blue + 1.2pt),
)
#plot(xmin: 0, xmax: 4, ymin: 0, ymax: 2, width: 5, height: 2.5,
  fill-area(f, domain: (0.0, calc.pi), hatch: (style: "ne", spacing: 8pt, stroke: red + 1pt)),
  (fn: f, stroke: blue + 1.2pt),
)
#plot(xmin: 0, xmax: 4, ymin: 0, ymax: 2, width: 5, height: 2.5,
  riemann-sum(f, domain: (0.0, 3.0), n: 6, hatch: (style: "cross", spacing: 6pt, stroke: green)),
)

= 7. volume: canonical + legacy names (same output)
#volume-of-revolution(x => calc.sqrt(x), domain: (0.5, 4), n-disks: 3,
  show-back: false, show-radius-marker: true, radius-marker-x: 2.0, show-y-axis: true)
#volume-of-revolution(x => calc.sqrt(x), domain: (0.5, 4), n-disks: 3,
  show-back: false, show-radius-marker: true, yaxis-x: 2.0, show-yaxis: true)

= 8. data is scatter
#plot(xmin: 0, xmax: 4, ymin: 0, ymax: 4, width: 4, height: 3,
  scatter(((1, 1), (2, 2)), mark: "o", mark-stroke: blue),
  data(((1, 3), (3, 1)), mark: "square*", mark-fill: red, connect: true, stroke: red + 0.6pt),
)

= 9. small data range: axis overshoot stays 0.3cm (Gaussian regression)
// Regression: with the old data-unit extends, y in [0, 0.5] produced a
// 6cm-long arrow overshoot above the grid.
#let gauss(x) = 1 / calc.sqrt(2 * calc.pi) * calc.exp(-0.5 * calc.pow(x - 2.4, 2))
#plot(
  xmin: -3, xmax: 5, ymin: 0, ymax: 0.5,
  ytick-step: 0.2,
  show-grid: true,
  xlabel: $V$, ylabel: $p$,
  fill-area(gauss, domain: (-3, 0), color: red.lighten(30%)),
  (fn: gauss, stroke: blue + 1.2pt, label: [Gaussian for 2.4V]),
)
Explicit legacy (data units) and length forms still work:
#plot(xmin: -2, xmax: 2, ymin: -2, ymax: 2, width: 3.5, height: 3,
  axis-x-extend: (0.5, 1), axis-y-extend: (0.5, 1),
  (fn: x => x,),
)
#plot(xmin: -2, xmax: 2, ymin: -2, ymax: 2, width: 3.5, height: 3,
  axis-x-extend: (0pt, 8mm), axis-y-extend: (0pt, 8mm),
  (fn: x => x,),
)
