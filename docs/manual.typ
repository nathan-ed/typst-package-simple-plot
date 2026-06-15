#import "@preview/simple-plot:0.9.0": plot, plot-fn, scatter, data, line-plot, func-plot, parametric, fill-closed, fill-area, area-between, riemann-sum, note, vline, hline, volume-of-revolution, solid-of-revolution, set-plot-defaults, reset-plot-defaults

// =============================================================================
// DOCUMENT SETUP
// =============================================================================

#set page(margin: (x: 1.8cm, y: 2cm))
#set text(size: 10.5pt, font: "New Computer Modern")
#set heading(numbering: "1.")
#set par(justify: true)

#show raw.where(lang: "typst"): it => block(
  fill: luma(97%),
  radius: 3pt,
  inset: 8pt,
  stroke: 0.5pt + luma(85%),
)[#it]

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/// Two-column example layout with code and preview
#let example(code, body) = block(breakable: false)[
  #table(
    columns: (1fr, 1fr),
    stroke: none,
    inset: 6pt,
    align: (left + top, center + top),
    [
      #set text(size: 8pt)
      *Code*
      #v(0.3em)
      #code
    ],
    [
      *Preview*
      #v(0.3em)
      #box(
        width: 100%,
        inset: 6pt,
        radius: 3pt,
        stroke: 0.5pt + luma(85%),
        fill: white,
      )[
        #set text(size: 9pt)
        #body
      ]
    ],
  )
  #v(0.5em)
]

/// Full-width example for larger plots
#let example-full(code, body) = block(breakable: false)[
  #set text(size: 8pt)
  *Code*
  #v(0.3em)
  #code
  #v(0.5em)
  *Preview*
  #v(0.3em)
  #align(center)[
    #box(
      inset: 8pt,
      radius: 3pt,
      stroke: 0.5pt + luma(85%),
      fill: white,
    )[
      #body
    ]
  ]
  #v(0.8em)
]

// =============================================================================
// TITLE PAGE
// =============================================================================

#align(center)[
  #v(2cm)
  #text(size: 28pt, weight: "bold")[simple-plot]
  #v(0.5em)
  #text(size: 16pt)[Typst Package]
  #v(1em)
  #text(size: 12pt, style: "italic")[Mathematical Function Plotting]
  #v(2cm)
  #line(length: 60%, stroke: 0.5pt)
  #v(1cm)
  #text(size: 11pt)[
    A lightweight library for creating elegant mathematical plots\
    Version 0.9.0\
    Nathan Scheinmann
  ]
]

#pagebreak()

// =============================================================================
// TABLE OF CONTENTS
// =============================================================================

#outline(indent: 1em, depth: 2)

#pagebreak()

// =============================================================================
// INTRODUCTION
// =============================================================================

= Introduction

`simple-plot` is a Typst package for creating clean, elegant mathematical plots. Built on CeTZ, it provides an intuitive interface for plotting functions, data points, and creating publication-ready graphs.

== Features

- Plot mathematical functions with automatic sampling
- Parametric curves (ellipses, hyperbolas, closed shapes)
- Scatter plots and line plots with customizable markers
- Fill areas under curves or between two curves (solid or hatched)
- Clean integer-based tick system by default
- Major and minor grid with elegant styling
- Gap-based grid line breaks around tick labels (grid-label-break)
- Automatic axis extension beyond grid
- Flexible axis positioning (origin, bottom/left, custom)
- Multiple label display options (unit-label-only, label-step)
- Function labels with flexible positioning
- Text annotations and reference lines (vline, hline)
- Riemann sum rectangles with left, right, midpoint, lower, and upper methods
- Volume of revolution diagrams with end caps, disks, and tilted axes
- Clipping for clean rendering at boundaries
- Global defaults and style overrides

== Installation

Import the package in your Typst document:

```typst
#import "@preview/simple-plot:0.9.0": plot
```

== Quick Start

#example-full(
  [```typst
#plot(
  width: 6, height: 5,
  xmin: -3, xmax: 3, ymin: -2, ymax: 4,
  xlabel: $x$, ylabel: $y$,
  show-grid: true,
  (fn: x => x * x, stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 6, height: 5,
      xmin: -3, xmax: 3, ymin: -2, ymax: 4,
      xlabel: $x$, ylabel: $y$,
      show-grid: true,
      (fn: x => x * x, stroke: blue + 1.5pt),
    )
  ]
)

#pagebreak()

// =============================================================================
// BASIC USAGE
// =============================================================================

= Basic Usage

== Plotting Functions

Plot mathematical functions by passing a dictionary with `fn`:

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: -4, xmax: 4, ymin: -1.5, ymax: 1.5,
  xlabel: $x$, ylabel: $y$,
  show-grid: "major",
  (fn: x => calc.sin(x), stroke: blue + 1.5pt),
  (fn: x => calc.cos(x), stroke: red + 1.5pt),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: -4, xmax: 4, ymin: -1.5, ymax: 1.5,
      xlabel: $x$, ylabel: $y$,
      show-grid: "major",
      (fn: x => calc.sin(x), stroke: blue + 1.5pt),
      (fn: x => calc.cos(x), stroke: red + 1.5pt),
    )
  ]
)

== Mathematical Functions Reference

Functions are defined using Typst's `calc` module. Here are the most common mathematical functions:

#table(
  columns: (1fr, 1fr),
  stroke: 0.5pt + luma(80%),
  inset: 6pt,
  fill: (_, y) => if y == 0 { luma(95%) } else { none },
  [*Function*], [*Typst syntax*],
  [Power $x^n$], [`calc.pow(x, n)`],
  [Square root $sqrt(x)$], [`calc.sqrt(x)`],
  [Absolute value $|x|$], [`calc.abs(x)`],
  [Sine $sin(x)$], [`calc.sin(x)`],
  [Cosine $cos(x)$], [`calc.cos(x)`],
  [Tangent $tan(x)$], [`calc.tan(x)`],
  [Exponential $e^x$], [`calc.exp(x)`],
  [Natural log $ln(x)$], [`calc.ln(x)`],
  [Log base $b$], [`calc.log(x, base: b)`],
  [Maximum], [`calc.max(a, b)`],
  [Minimum], [`calc.min(a, b)`],
)

#v(0.5em)

#block(
  fill: rgb("#fff3cd"),
  stroke: rgb("#ffc107") + 0.5pt,
  radius: 3pt,
  inset: 8pt,
)[
  *Important:* When using constants in calculations, use decimal notation (e.g., `2.0` instead of `2`) to avoid type errors. For example:

  - ✓ `x => x * x / 2.0`
  - ✗ `x => x * x / 2` _(may cause errors)_

  This is because Typst's type system requires consistent float arithmetic.

  To draw a function with a hole or discontinuity, return `none` from the function at that point — the line will break without connecting across the gap:

  ```typst
  // Draws 1/x with a break at x=0
  (fn: x => if calc.abs(x) < 0.01 { none } else { 1.0 / x }, stroke: blue + 1.5pt)
  ```
]

#pagebreak()

== Function Domain

Specify a custom domain for functions:

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: 0, xmax: 5, ymin: 0, ymax: 3,
  xlabel: $x$, ylabel: $y$,
  axis-x-pos: "bottom", axis-y-pos: "left",
  show-grid: "major",
  (fn: x => calc.sqrt(x), domain: (0, 5), stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: 0, xmax: 5, ymin: 0, ymax: 3,
      xlabel: $x$, ylabel: $y$,
      axis-x-pos: "bottom", axis-y-pos: "left",
      show-grid: "major",
      (fn: x => calc.sqrt(x), domain: (0, 5), stroke: blue + 1.5pt),
    )
  ]
)

#pagebreak()

== Function Labels

Add labels to your functions:

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: -3, xmax: 3, ymin: -2, ymax: 4,
  xlabel: $x$, ylabel: $y$,
  show-grid: "major",
  (
    fn: x => x * x,
    stroke: blue + 1.5pt,
    label: $f(x) = x^2$,
    label-side: "above",
    label-pos: 0.75,
  ),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: -3, xmax: 3, ymin: -2, ymax: 4,
      xlabel: $x$, ylabel: $y$,
      show-grid: "major",
      (
        fn: x => x * x,
        stroke: blue + 1.5pt,
        label: $f(x) = x^2$,
        label-side: "above",
        label-pos: 0.75,
      ),
    )
  ]
)

== Data Points and Scatter Plots

Plot discrete data points:

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: 0, xmax: 6, ymin: 0, ymax: 10,
  xlabel: $x$, ylabel: $y$,
  axis-x-pos: "bottom", axis-y-pos: "left",
  show-grid: "major",
  (
    data: ((1, 2), (2, 4), (3, 5), (4, 7), (5, 9)),
    mark: "o",
    mark-size: 0.15,
    stroke: blue + 1pt,
  ),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: 0, xmax: 6, ymin: 0, ymax: 10,
      xlabel: $x$, ylabel: $y$,
      axis-x-pos: "bottom", axis-y-pos: "left",
      show-grid: "major",
      (
        data: ((1, 2), (2, 4), (3, 5), (4, 7), (5, 9)),
        mark: "o",
        mark-size: 0.15,
        stroke: blue + 1pt,
      ),
    )
  ]
)

#pagebreak()

// =============================================================================
// GRID OPTIONS
// =============================================================================

= Grid Options

== Grid Modes

Control grid display with `show-grid`:

#example(
  [```typst
// Major grid only
#plot(
  width: 5, height: 4,
  xmin: -2, xmax: 2, ymin: -2, ymax: 2,
  show-grid: "major",
)

// Minor grid only
#plot(
  width: 5, height: 4,
  xmin: -2, xmax: 2, ymin: -2, ymax: 2,
  show-grid: "minor",
)

// Both grids
#plot(
  width: 5, height: 4,
  xmin: -2, xmax: 2, ymin: -2, ymax: 2,
  show-grid: "both",
)
  ```],
  [
    #plot(width: 3.5, height: 2.5, xmin: -2, xmax: 2, ymin: -2, ymax: 2, show-grid: "major")
    #v(0.2em)
    #plot(width: 3.5, height: 2.5, xmin: -2, xmax: 2, ymin: -2, ymax: 2, show-grid: "minor")
    #v(0.2em)
    #plot(width: 3.5, height: 2.5, xmin: -2, xmax: 2, ymin: -2, ymax: 2, show-grid: "both")
  ]
)

== Minor Grid Subdivisions

Control the number of subdivisions with `minor-grid-step`:

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: 0, xmax: 4, ymin: 0, ymax: 3,
  xlabel: $x$, ylabel: $y$,
  axis-x-pos: "bottom", axis-y-pos: "left",
  show-grid: "both",
  minor-grid-step: 10,  // 10 subdivisions per unit
  (fn: x => calc.sqrt(x), domain: (0, 4), stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: 0, xmax: 4, ymin: 0, ymax: 3,
      xlabel: $x$, ylabel: $y$,
      axis-x-pos: "bottom", axis-y-pos: "left",
      show-grid: "both",
      minor-grid-step: 10,
      (fn: x => calc.sqrt(x), domain: (0, 4), stroke: blue + 1.5pt),
    )
  ]
)

#pagebreak()

== Grid Label Break

The `grid-label-break` option (enabled by default) draws grid lines with gaps around tick labels, creating an elegant break effect. Unlike a white-box approach, this works on any background color:

#example-full(
  [```typst
#plot(
  width: 10, height: 8,
  xmin: -4, xmax: 4, ymin: -3, ymax: 3,
  xlabel: $x$, ylabel: $y$,
  show-grid: "both",
  minor-grid-step: 5,
  grid-label-break: true,  // Default
  (fn: x => calc.sin(x) * 2, stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 10, height: 8,
      xmin: -4, xmax: 4, ymin: -3, ymax: 3,
      xlabel: $x$, ylabel: $y$,
      show-grid: "both",
      minor-grid-step: 5,
      grid-label-break: true,
      (fn: x => calc.sin(x) * 2, stroke: blue + 1.5pt),
    )
  ]
)

#pagebreak()

// =============================================================================
// AXIS CONFIGURATION
// =============================================================================

= Axis Configuration

== Axis Position

Position axes at origin (default), bottom/left, or custom values:

#example(
  [```typst
// Through origin (default)
#plot(
  width: 5, height: 4,
  xmin: -2, xmax: 2, ymin: -2, ymax: 2,
  show-grid: "major",
)

// Bottom and left
#plot(
  width: 5, height: 4,
  xmin: 0, xmax: 4, ymin: 0, ymax: 3,
  axis-x-pos: "bottom",
  axis-y-pos: "left",
  show-grid: "major",
)
  ```],
  [
    #plot(width: 3.5, height: 3, xmin: -2, xmax: 2, ymin: -2, ymax: 2, show-grid: "major")
    #v(0.5em)
    #plot(width: 3.5, height: 3, xmin: 0, xmax: 4, ymin: 0, ymax: 3, axis-x-pos: "bottom", axis-y-pos: "left", show-grid: "major")
  ]
)

== Axis Extension

By default, axes extend 0.5 units beyond the grid on the arrow side. Customize with `axis-x-extend` and `axis-y-extend`:

#example(
  [```typst
// Default extension (0, 0.5)
#plot(
  width: 5, height: 4,
  xmin: -2, xmax: 2, ymin: -2, ymax: 2,
  show-grid: "major",
)

// Custom extension
#plot(
  width: 5, height: 4,
  xmin: -2, xmax: 2, ymin: -2, ymax: 2,
  axis-x-extend: (0.5, 1),
  axis-y-extend: (0.5, 1),
  show-grid: "major",
)
  ```],
  [
    #plot(width: 3.5, height: 3, xmin: -2, xmax: 2, ymin: -2, ymax: 2, show-grid: "major")
    #v(0.5em)
    #plot(width: 3.5, height: 3, xmin: -2, xmax: 2, ymin: -2, ymax: 2, axis-x-extend: (0.5, 1), axis-y-extend: (0.5, 1), show-grid: "major")
  ]
)

#pagebreak()

// =============================================================================
// TICK CONFIGURATION
// =============================================================================

= Tick Configuration

== Default Integer Ticks

By default, ticks are placed at every integer (step = 1):

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: -3, xmax: 4, ymin: -2, ymax: 3,
  xlabel: $x$, ylabel: $y$,
  show-grid: "major",
  (fn: x => x, stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: -3, xmax: 4, ymin: -2, ymax: 3,
      xlabel: $x$, ylabel: $y$,
      show-grid: "major",
      (fn: x => x, stroke: blue + 1.5pt),
    )
  ]
)

== Custom Tick Step

Change tick spacing with `xtick-step` and `ytick-step`:

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: 0, xmax: 3, ymin: 0, ymax: 2,
  xlabel: $x$, ylabel: $y$,
  axis-x-pos: "bottom", axis-y-pos: "left",
  xtick-step: 0.5,
  ytick-step: 0.5,
  show-grid: "major",
  (fn: x => x * x / 3, stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: 0, xmax: 3, ymin: 0, ymax: 2,
      xlabel: $x$, ylabel: $y$,
      axis-x-pos: "bottom", axis-y-pos: "left",
      xtick-step: 0.5,
      ytick-step: 0.5,
      show-grid: "major",
      (fn: x => x * x / 3, stroke: blue + 1.5pt),
    )
  ]
)

#pagebreak()

== Tick Label Step

Show labels only at every N-th tick with `xtick-label-step` and `ytick-label-step`:

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: -6, xmax: 6, ymin: -4, ymax: 4,
  xlabel: $x$, ylabel: $y$,
  xtick-label-step: 2,  // Labels at -6, -4, -2, 2, 4, 6
  ytick-label-step: 2,  // Labels at -4, -2, 2, 4
  show-grid: "major",
  (fn: x => calc.sin(x) * 3, stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: -6, xmax: 6, ymin: -4, ymax: 4,
      xlabel: $x$, ylabel: $y$,
      xtick-label-step: 2,
      ytick-label-step: 2,
      show-grid: "major",
      (fn: x => calc.sin(x) * 3, stroke: blue + 1.5pt),
    )
  ]
)

== Unit Label Only

Show only "1" on each axis for a minimal style:

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: -3, xmax: 3, ymin: -3, ymax: 3,
  xlabel: $x$, ylabel: $y$,
  unit-label-only: true,
  show-origin: false,
  show-grid: "major",
  (fn: x => x * x - 1, stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: -3, xmax: 3, ymin: -3, ymax: 3,
      xlabel: $x$, ylabel: $y$,
      unit-label-only: true,
      show-origin: false,
      show-grid: "major",
      (fn: x => x * x - 1, stroke: blue + 1.5pt),
    )
  ]
)

#pagebreak()

== Custom Tick Positions

Specify exact tick positions with `xtick` and `ytick`:

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: -4, xmax: 4, ymin: -2, ymax: 2,
  xlabel: $x$, ylabel: $y$,
  xtick: (-calc.pi, -calc.pi/2, 0, calc.pi/2, calc.pi),
  xtick-labels: ($-pi$, $-pi/2$, $0$, $pi/2$, $pi$),
  show-grid: "major",
  (fn: x => calc.sin(x), stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: -4, xmax: 4, ymin: -2, ymax: 2,
      xlabel: $x$, ylabel: $y$,
      xtick: (-calc.pi, -calc.pi/2, 0, calc.pi/2, calc.pi),
      xtick-labels: ($-pi$, $-pi/2$, $0$, $pi/2$, $pi$),
      show-grid: "major",
      (fn: x => calc.sin(x), stroke: blue + 1.5pt),
    )
  ]
)

== Hide Origin Label

Control the "0" label at the origin:

#example(
  [```typst
// With origin (default)
#plot(
  width: 5, height: 4,
  xmin: -2, xmax: 2, ymin: -2, ymax: 2,
  show-origin: true,
  show-grid: "major",
)

// Without origin
#plot(
  width: 5, height: 4,
  xmin: -2, xmax: 2, ymin: -2, ymax: 2,
  show-origin: false,
  show-grid: "major",
)
  ```],
  [
    #plot(width: 3.5, height: 3, xmin: -2, xmax: 2, ymin: -2, ymax: 2, show-origin: true, show-grid: "major")
    #v(0.5em)
    #plot(width: 3.5, height: 3, xmin: -2, xmax: 2, ymin: -2, ymax: 2, show-origin: false, show-grid: "major")
  ]
)

#pagebreak()

// =============================================================================
// MARKERS
// =============================================================================

= Markers

== Available Marker Types

The following markers are available:

#table(
  columns: (1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Marker*], [*Description*],
  [`"o"`], [Circle (outline)],
  [`"*"`], [Circle (filled)],
  [`"square"`], [Square (outline)],
  [`"square*"`], [Square (filled)],
  [`"triangle"`], [Triangle up (outline)],
  [`"triangle*"`], [Triangle up (filled)],
  [`"diamond"`], [Diamond (outline)],
  [`"diamond*"`], [Diamond (filled)],
  [`"star"`], [Star (outline)],
  [`"star*"`], [Star (filled)],
  [`"+"`], [Plus sign],
  [`"x"`], [Cross],
  [`"|"`], [Vertical bar],
  [`"-"`], [Horizontal bar],
)

== Using Markers

#example-full(
  [```typst
#plot(
  width: 8, height: 6,
  xmin: 0, xmax: 7, ymin: 0, ymax: 5,
  axis-x-pos: "bottom", axis-y-pos: "left",
  show-grid: "major",
  data(((1, 1), (2, 2), (3, 2.5)), mark: "o", mark-stroke: blue),
  data(((1, 2), (2, 3), (3, 3.5)), mark: "square*", mark-fill: red, mark-stroke: red),
  data(((1, 3), (2, 4), (3, 4.2)), mark: "triangle", mark-stroke: green),
)
  ```],
  [
    #plot(
      width: 8, height: 6,
      xmin: 0, xmax: 7, ymin: 0, ymax: 5,
      axis-x-pos: "bottom", axis-y-pos: "left",
      show-grid: "major",
      data(((1, 1), (2, 2), (3, 2.5)), mark: "o", mark-size: 0.12, mark-stroke: blue),
      data(((1, 2), (2, 3), (3, 3.5)), mark: "square*", mark-size: 0.12, mark-fill: red, mark-stroke: red),
      data(((1, 3), (2, 4), (3, 4.2)), mark: "triangle", mark-size: 0.12, mark-stroke: green),
    )
  ]
)

#pagebreak()

// =============================================================================
// CONVENIENCE FUNCTIONS
// =============================================================================

= Convenience Functions

== `plot-fn` - Quick Function Plot

Plot a single function with automatic y-scaling:

#example-full(
  [```typst
#plot-fn(
  x => calc.sin(x) * 2.0,
  domain: (-4, 4),
  stroke: blue + 1.5pt,
)
  ```],
  [
    #plot-fn(
      x => calc.sin(x) * 2.0,
      domain: (-4, 4),
      stroke: blue + 1.5pt,
    )
  ]
)

*Parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`fn`], [function], [—], [Function to plot],
  [`domain`], [array], [(-5, 5)], [X domain],
  [`ymin` / `ymax`], [float/auto], [auto], [Y bounds; `auto` = computed from samples],
  [`stroke`], [stroke], [`blue + 1.2pt`], [Line style],
  [`..args`], [any], [—], [Forwarded to `plot()`],
)

== `scatter` / `data` - Point Sets

`scatter` and `data` are identical functions. Use them to create isolated point specifications. Set `connect: true` to join points with a line.

```typst
#plot(
  xmin: 0, xmax: 4, ymin: 0, ymax: 6,
  scatter(((1, 2), (2, 4), (3, 5)), mark: "o", mark-fill: blue),
  data(((1, 1.5), (2, 3.5), (3, 4.5)), mark: "*", mark-fill: red),
)
```

*Parameters (both functions):*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`points`], [array], [—], [Array of `(x, y)` tuples],
  [`mark`], [string], [`"*"`], [Marker type],
  [`mark-size`], [float], [0.12], [Marker size in cm],
  [`mark-fill`], [color], [blue], [Marker fill color],
  [`mark-stroke`], [stroke], [`blue + 0.8pt`], [Marker stroke],
  [`connect`], [bool], [false], [Join points with a line],
  [`stroke`], [stroke], [none], [Line stroke when `connect: true`],
  [`label`], [content], [none], [Series label],
  [`label-pos`], [float], [0.8], [Position along series in \[0, 1\]],
  [`label-anchor`], [string], ["south-west"], [Label anchor],
)

== `line-plot` - Connected Line Plot

Create a line plot with markers (points joined by default):

```typst
#plot(
  xmin: 0, xmax: 4, ymin: 0, ymax: 6,
  line-plot(((1, 2), (2, 4), (3, 5)), stroke: blue + 1pt, mark: "o"),
)
```

*Parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`points`], [array], [—], [Array of `(x, y)` tuples],
  [`stroke`], [stroke], [`blue + 1.2pt`], [Line stroke],
  [`mark`], [string], [`"o"`], [Marker type],
  [`mark-size`], [float], [0.1], [Marker size in cm],
  [`mark-fill`], [color], [white], [Marker fill],
  [`mark-stroke`], [stroke], [`blue + 0.8pt`], [Marker stroke],
  [`label`], [content], [none], [Series label],
  [`label-pos`], [float], [0.8], [Position along series in \[0, 1\]],
  [`label-anchor`], [string], ["south-west"], [Label anchor],
)

== `func-plot` - Function Plot Helper

Build a function series spec with full marker and label control:

```typst
#let my-func = func-plot(
  x => calc.sin(x),
  stroke: blue + 1.5pt,
  label: $sin(x)$,
  mark: "o",
  mark-interval: 15,  // marker every 15th sample
)
#plot(xmin: -4, xmax: 4, ymin: -1.5, ymax: 1.5, my-func)
```

*Parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`fn`], [function], [—], [Function to plot],
  [`domain`], [array/auto], [auto], [X domain; `auto` = full plot range],
  [`stroke`], [stroke], [`blue + 1.2pt`], [Line style],
  [`samples`], [int], [100], [Sample count],
  [`mark`], [string], [`"none"`], [Marker type],
  [`mark-size`], [float], [0.1], [Marker size in cm],
  [`mark-fill`], [color], [blue], [Marker fill],
  [`mark-stroke`], [stroke], [`blue + 0.8pt`], [Marker stroke],
  [`mark-interval`], [int], [10], [Draw a marker every N-th sample],
  [`label`], [content], [none], [Curve label],
  [`label-pos`], [float], [0.8], [Position in \[0, 1\]],
  [`label-anchor`], [string], ["south-west"], [Label anchor],
)

== `parametric` - Ellipses and Hyperbolas

Draw curves that are not single-valued functions of `x`, such as ellipses:

```typst
#plot(
  xmin: -3, xmax: 3, ymin: -2, ymax: 2,
  parametric(t => 2 * calc.cos(t), t => calc.sin(t), domain: (0, 2 * calc.pi)),
)
```

For a hyperbola branch, use a finite parameter interval:

```typst
#plot(
  xmin: -4, xmax: 4, ymin: -3, ymax: 3,
  parametric(t => (calc.exp(t) + calc.exp(-t)) / 2, t => (calc.exp(t) - calc.exp(-t)) / 2, domain: (-1.5, 1.5)),
  parametric(t => -(calc.exp(t) + calc.exp(-t)) / 2, t => (calc.exp(t) - calc.exp(-t)) / 2, domain: (-1.5, 1.5)),
)
```

*Parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`fn-x`], [function], [—], [X coordinate as function of $t$],
  [`fn-y`], [function], [—], [Y coordinate as function of $t$],
  [`domain`], [array], [(0.0, 1.0)], [Parameter range $(t_1, t_2)$],
  [`stroke`], [stroke], [`blue + 1.2pt`], [Curve stroke],
  [`samples`], [int], [100], [Number of parameter samples],
)

== `fill-area` - Fill Under a Curve

Fill the region between a function and a baseline (default: $y = 0$):

```typst
#plot(
  xmin: 0, xmax: calc.pi, ymin: -0.2, ymax: 1.2,
  fill-area(x => calc.sin(x), domain: (0, calc.pi), color: blue.lighten(70%)),
  (fn: x => calc.sin(x), domain: (0, calc.pi), stroke: blue + 1.5pt),
)
```

Use `baseline` for a non-zero base level, or `hatch` for hatched fills:

```typst
fill-area(x => calc.sin(x), domain: (0, calc.pi),
          hatch: "ne", hatch-spacing: 5pt, hatch-stroke: blue + 0.5pt)
```

*Parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`fn`], [function], [—], [Function $f(x)$ bounding the top of the region],
  [`domain`], [array/auto], [auto], [X interval; `auto` = full plot range],
  [`baseline`], [float], [0.0], [Y-value of the bottom of the region],
  [`color`], [color], [`luma(220)`], [Fill color; `none` for hatch-only],
  [`hatch`], [string/none], [none], [Hatch pattern: `"ne"`, `"nw"`, `"h"`, `"v"`, `"cross"`, `"grid"`],
  [`hatch-spacing`], [length], [`5pt`], [Spacing between hatch lines],
  [`hatch-stroke`], [stroke], [`luma(80) + 0.5pt`], [Hatch line stroke],
  [`samples`], [int], [80], [Sample count],
)

== `area-between` - Fill Between Two Curves

Fill the region enclosed by two functions:

```typst
#plot(
  xmin: -1, xmax: 3, ymin: -1, ymax: 10,
  area-between(x => x * x, x => 3 * x, domain: (0, 3),
               color: green.lighten(60%)),
  (fn: x => x * x, stroke: blue + 1.5pt),
  (fn: x => 3 * x, stroke: red + 1.5pt),
)
```

*Parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`fn1`], [function], [—], [First bounding function],
  [`fn2`], [function], [—], [Second bounding function],
  [`domain`], [array/auto], [auto], [X interval; `auto` = full plot range],
  [`color`], [color], [`luma(220)`], [Fill color; `none` for hatch-only],
  [`hatch`], [string/none], [none], [Hatch pattern],
  [`hatch-spacing`], [length], [`5pt`], [Hatch line spacing],
  [`hatch-stroke`], [stroke], [`luma(80) + 0.5pt`], [Hatch line stroke],
  [`samples`], [int], [80], [Sample count],
)

== `fill-closed` - Fill a Parametric Closed Curve

Fill the interior of a closed parametric curve (the curve should start and end at the same point):

```typst
#plot(
  xmin: -3, xmax: 3, ymin: -2, ymax: 2,
  fill-closed(t => 2 * calc.cos(t), t => calc.sin(t),
              domain: (0, 2 * calc.pi), color: blue.lighten(70%)),
  parametric(t => 2 * calc.cos(t), t => calc.sin(t),
             domain: (0, 2 * calc.pi), stroke: blue + 1.5pt),
)
```

*Parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`fn-x`], [function], [—], [X coordinate as function of $t$],
  [`fn-y`], [function], [—], [Y coordinate as function of $t$],
  [`domain`], [array], [(0.0, 1.0)], [Parameter range; curve should be closed],
  [`color`], [color], [`luma(220)`], [Fill color; `none` for hatch-only],
  [`hatch`], [string/none], [none], [Hatch pattern],
  [`hatch-spacing`], [length], [`5pt`], [Hatch line spacing],
  [`hatch-stroke`], [stroke], [`luma(80) + 0.5pt`], [Hatch line stroke],
  [`samples`], [int], [80], [Sample count],
)

== `vline` / `hline` - Reference Lines

Draw vertical or horizontal reference lines at a fixed coordinate:

```typst
#plot(
  xmin: -3, xmax: 3, ymin: -2, ymax: 4,
  (fn: x => x * x - 1, stroke: blue + 1.5pt),
  vline(1.0, stroke: red + 0.8pt + (dash: "dashed")),
  hline(0.0, stroke: gray + 0.8pt),
)
```

Use `ymin`/`ymax` (for `vline`) or `xmin`/`xmax` (for `hline`) to draw partial lines:

```typst
vline(2.0, ymin: 0, ymax: 4)          // vertical from y=0 to y=4
hline(1.5, xmin: 0, xmax: 3)          // horizontal from x=0 to x=3
```

*`vline` parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`x0`], [float], [—], [X position of the line],
  [`stroke`], [stroke], [`luma(100) + 0.6pt`], [Line stroke],
  [`ymin`], [float/auto], [auto], [Bottom y limit (default: plot `ymin`)],
  [`ymax`], [float/auto], [auto], [Top y limit (default: plot `ymax`)],
)

*`hline` parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`y0`], [float], [—], [Y position of the line],
  [`stroke`], [stroke], [`luma(100) + 0.6pt`], [Line stroke],
  [`xmin`], [float/auto], [auto], [Left x limit (default: plot `xmin`)],
  [`xmax`], [float/auto], [auto], [Right x limit (default: plot `xmax`)],
)

== `note` - Text Annotation

Place a text annotation at a data-coordinate position:

```typst
#plot(
  xmin: -3, xmax: 3, ymin: -2, ymax: 4,
  (fn: x => x * x - 1, stroke: blue + 1.5pt),
  note([$f(x) = x^2 - 1$], pos: (1.5, 2.5), anchor: "west", size: 9pt),
)
```

*Parameters:*

#table(
  columns: (1.2fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`body`], [content], [—], [Annotation text or content],
  [`pos`], [array], [—], [`(x, y)` in data coordinates],
  [`anchor`], [string], ["center"], [Text anchor point],
  [`size`], [length], [`9pt`], [Font size],
)

#pagebreak()

== `riemann-sum` - Riemann Sum Rectangles

Draw left, right, midpoint, lower, or upper Riemann sum rectangles for a function. Use it as a plot item alongside the function curve or `fill-area`.

The five methods:
- `"left"` / `"right"` / `"mid"` — evaluation at the left endpoint, right endpoint, or midpoint of each sub-interval
- `"lower"` / `"upper"` — true infimum / supremum sampled within each sub-interval; correct for any function shape including U-curves

=== Basic Example

#example-full(
  [```typst
#plot(
  width: 8, height: 5,
  xmin: 0, xmax: calc.pi, ymin: 0, ymax: 1.2,
  axis-x-pos: "bottom", axis-y-pos: "left",
  riemann-sum(
    x => calc.sin(x),
    domain: (0.0, calc.pi),
    n: 6, method: "mid",
    color: blue.lighten(75%),
  ),
  (fn: x => calc.sin(x), domain: (0.0, calc.pi), stroke: blue + 1.5pt),
)
  ```],
  [
    #plot(
      width: 8, height: 5,
      xmin: 0, xmax: calc.pi, ymin: 0, ymax: 1.2,
      axis-x-pos: "bottom", axis-y-pos: "left",
      riemann-sum(
        x => calc.sin(x),
        domain: (0.0, calc.pi),
        n: 6, method: "mid",
        color: blue.lighten(75%),
      ),
      (fn: x => calc.sin(x), domain: (0.0, calc.pi), stroke: blue + 1.5pt),
    )
  ]
)

=== Annotations: `show-points`, `show-dx`, `show-xi`

Turn on the annotation overlays for pedagogical diagrams:

```typst
riemann-sum(
  x => x * x,
  domain: (0.0, 3.0),
  n: 6, method: "right",
  color: blue.lighten(80%),
  show-points: true,           // dots at evaluation points with arrows
  show-dx: true, dx-rect: 2,   // Δx bracket under rectangle 2
  show-xi: true,               // x₀ … x₆ labels along the axis
)
```

#plot(
  width: 11, height: 6,
  xmin: -0.2, xmax: 3.5, ymin: -0.1, ymax: 5.5,
  axis-x-pos: "bottom", axis-y-pos: "left",
  xlabel: $x$, ylabel: $y$,
  xtick: (0, 1, 2, 3), ytick: (1, 2, 3, 4, 5),
  show-origin: false,
  riemann-sum(
    x => x * x,
    domain: (0.0, 3.0),
    n: 6, method: "right",
    color: blue.lighten(80%),
    stroke: blue.darken(10%) + 0.6pt,
    show-points: true,
    show-dx: true, dx-rect: 2, dx-label: $Delta x$,
    show-xi: true,
  ),
  fill-area(x => x * x, domain: (0.0, 3.0), color: blue.transparentize(88%)),
  (fn: x => x * x, domain: (0.0, 3.2), stroke: blue + 1.5pt,
   label: $f(x)=x^2$, label-pos: 0.88, label-anchor: "south-west"),
)

=== `xi-show-values`

Set `xi-show-values: true` to display the actual numeric values of the subdivision points instead of the symbolic $x_i$ notation:

```typst
riemann-sum(fn, domain: (0.0, 4.0), n: 4, method: "left",
            show-xi: true, xi-show-values: true)
```

=== Hatch patterns

Use `hatch` together with `hatch-spacing` and `hatch-stroke` to draw hatched rectangles. Set `color: none` for hatch-only (no fill):

```typst
riemann-sum(fn, domain: ..., n: 6, method: "mid",
            color: none,
            hatch: "ne", hatch-spacing: 4pt, hatch-stroke: blue + 0.6pt)
```

Available hatch styles: `"ne"`, `"nw"`, `"h"`, `"v"`, `"cross"`, `"grid"`.

#pagebreak()

== `volume-of-revolution` - Volume of revolution diagram

Draw a 3D-style solid generated by rotating a profile $y = f(x)$ around a horizontal or oblique axis. The renderer draws the filled body, front and back cap ellipses, intermediate disk cross-sections, axis arrow, coordinate y-axis, and optional labels.

=== Basic Example

#example-full(
  [```typst
#volume-of-revolution(
  x => calc.sqrt(x),
  domain: (0.0, 4.0),
  n-disks: 5,
  width: 8.0, height: 4.0,
  show-yaxis: true,
  label-a: $0$, label-b: $4$,
  label-f: $f(x)=sqrt(x)$,
)
  ```],
  [
    #volume-of-revolution(
      x => calc.sqrt(x),
      domain: (0.0, 4.0),
      n-disks: 5,
      width: 8.0, height: 4.0,
      show-yaxis: true,
      label-a: $0$, label-b: $4$,
      label-f: $f(x)=sqrt(x)$,
    )
  ]
)

=== Axis of Revolution

Use `axis-y` to revolve around $y = c$ (shifted horizontal axis), or `axis-slope` for an oblique axis $y = m x + "axis-y"$:

```typst
// Around y = 1
#volume-of-revolution(x => 1.0 + calc.sqrt(x), domain: (0, 4), axis-y: 1.0)

// Around y = x (oblique)
#volume-of-revolution(x => x * x, domain: (0.01, 2), axis-slope: 1.0)
```

#grid(columns: (1fr, 1fr), gutter: 1em,
  align(center)[
    _Around $y = 1$_
    #volume-of-revolution(
      x => 1.0 + calc.sqrt(x), domain: (0.0, 4.0), axis-y: 1.0,
      n-disks: 4, width: 6.5, height: 3.5,
      label-a: $0$, label-b: $4$, label-f: $1+sqrt(x)$,
    )
  ],
  align(center)[
    _Around $y = x$ (oblique)_
    #volume-of-revolution(
      x => 2.0 * x, domain: (0.01, 2.0), axis-slope: 1.0,
      n-disks: 4, width: 6.5, height: 4.0,
      label-a: $0$, label-b: $2$, label-f: $2x$,
      disk-color: rgb("#fce4ec"), disk-stroke: rgb("#c62828") + 0.6pt,
      profile-stroke: rgb("#c62828") + 1.5pt,
    )
  ],
)

=== `show-back` and `show-radius-marker`

`show-back: false` hides the dashed back half and bottom profile — useful for side-by-side comparisons. `show-radius-marker: true` draws a vertical dimension marker at the y-axis:

```typst
#volume-of-revolution(fn, domain: ...,
  show-back: false,
  show-radius-marker: true,
  yaxis-x: 2.0,   // place y-axis at x=2, not the auto left position
  label-y: $sqrt(2)$,
)
```

=== `show-y-axis` and y-axis placement

The coordinate y-axis is positioned automatically to the left of the solid by default. Use `y-axis-x` / `yaxis-x` to fix it at a specific x-value, `y-axis-offset` to change the automatic gap, and `y-axis-extend` to control how far the axis extends above and below the solid:

```typst
#volume-of-revolution(fn, domain: ...,
  show-yaxis: true,
  y-axis-offset: 0.6,           // more gap from the volume
  y-axis-extend: (0.2, 0.5),   // tighter below, more above
)
```

#pagebreak()

// =============================================================================
// GLOBAL CONFIGURATION
// =============================================================================

= Global Configuration

== Setting Defaults

Use `set-plot-defaults` to configure defaults for all subsequent plots. Any `plot` parameter can be used, including `style`:

```typst
#set-plot-defaults(
  width: 8,
  height: 6,
  show-grid: "both",
  minor-grid-step: 5,
  style: (
    axis: (stroke: navy + 0.8pt, arrow: (symbol: "stealth", fill: navy, scale: 0.55)),
    ticks: (stroke: navy + 0.6pt, label-fill: navy),
  ),
)

// All subsequent plots will use these defaults
#plot(xmin: -3, xmax: 3, ymin: -2, ymax: 2, ...)
```

Per-call `style:` arguments are merged on top of the default style, so you can override individual properties without restating the full style.

== Resetting Defaults

Reset to original defaults:

```typst
#reset-plot-defaults()
```

#pagebreak()

// =============================================================================
// STYLING
// =============================================================================

= Styling

== Custom Styles

Override default styles with the `style` parameter:

```typst
#plot(
  xmin: -3, xmax: 3, ymin: -2, ymax: 2,
  style: (
    background: (fill: rgb("#202124")),
    axis: (
      stroke: white + 1pt,
      arrow: (symbol: "stealth", fill: white, scale: 0.55),
    ),
    grid: (
      major: (stroke: luma(120) + 0.6pt),
      minor: (stroke: luma(80) + 0.3pt),
    ),
    ticks: (
      length: 0.12,
      stroke: white + 0.6pt,
      label-size: 0.7em,
      label-fill: white,
    ),
    labels: (
      fill: white,
    ),
  ),
  ...
)
```

== Default Style Values

#table(
  columns: (1.5fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Property*], [*Default*], [*Description*],
  [`background.fill`], [`none`], [Plot background fill],
  [`background.stroke`], [`none`], [Plot background stroke],
  [`axis.stroke`], [`black + 0.8pt`], [Axis line style],
  [`axis.arrow`], [`(symbol: "stealth", fill: black, scale: 0.55)`], [Arrow head style],
  [`grid.major.stroke`], [`luma(200) + 0.5pt`], [Major grid line style],
  [`grid.minor.stroke`], [`luma(230) + 0.3pt`], [Minor grid line style],
  [`ticks.length`], [`0.1`], [Tick mark length (cm)],
  [`ticks.stroke`], [`black + 0.6pt`], [Tick mark style],
  [`ticks.label-size`], [`0.65em`], [Tick label font size],
  [`ticks.label-fill`], [`black`], [Tick label color],
  [`ticks.label-offset`], [`0.15`], [Distance from tick to label],
  [`plot.stroke`], [`blue + 1.2pt`], [Default function stroke],
  [`plot.samples`], [`100`], [Default sample count],
  [`marker.size`], [`0.12`], [Default marker size],
  [`labels.size`], [`0.8em`], [Axis label font size],
  [`labels.fill`], [`black`], [Axis label color],
)

#pagebreak()

// =============================================================================
// PARAMETER REFERENCE
// =============================================================================

= Parameter Reference

== `plot` Function

*Dimensions and Bounds:*

#table(
  columns: (1.3fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`width`], [float], [6], [Plot width in cm],
  [`height`], [float], [6], [Plot height in cm],
  [`scale`], [float], [1], [Scale factor for entire plot],
  [`xmin`], [float], [-5], [Minimum x value],
  [`xmax`], [float], [5], [Maximum x value],
  [`ymin`], [float], [-5], [Minimum y value],
  [`ymax`], [float], [5], [Maximum y value],
)

#v(0.5em)
*Axis Configuration:*

#table(
  columns: (1.3fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`xlabel`], [content], [$x$], [X-axis label],
  [`ylabel`], [content], [$y$], [Y-axis label],
  [`xlabel-pos`], [string/array], ["end"], ["end", "center", or (x, y)],
  [`ylabel-pos`], [string/array], ["end"], ["end", "center", or (x, y)],
  [`xlabel-anchor`], [string], ["north"], [Anchor for x label],
  [`ylabel-anchor`], [string], ["east"], [Anchor for y label],
  [`xlabel-offset`], [array], [(0.0, -0.05)], [X label offset (cm)],
  [`ylabel-offset`], [array], [(-0.05, 0.0)], [Y label offset (cm)],
  [`axis-x-pos`], [string/float], [0], ["bottom", "center", or y-value],
  [`axis-y-pos`], [string/float], [0], ["left", "center", or x-value],
  [`axis-x-extend`], [float/array], [(0, 0.5)], [X-axis extension (left, right)],
  [`axis-y-extend`], [float/array], [(0, 0.5)], [Y-axis extension (bottom, top)],
)

#v(0.5em)
*Tick Configuration:*

#table(
  columns: (1.3fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`xtick`], [array/none], [auto], [Custom x tick positions],
  [`ytick`], [array/none], [auto], [Custom y tick positions],
  [`xtick-step`], [float], [1], [X tick spacing],
  [`ytick-step`], [float], [1], [Y tick spacing],
  [`xtick-labels`], [array/none], [auto], [Custom x tick labels],
  [`ytick-labels`], [array/none], [auto], [Custom y tick labels],
  [`xtick-label-step`], [int], [1], [Show x label every N ticks],
  [`ytick-label-step`], [int], [1], [Show y label every N ticks],
  [`show-origin`], [bool], [true], [Show "0" at origin],
  [`origin-label-offset`], [array], [(-0.11, -0.11)], [Origin "0" label offset from (0,0) in cm],
  [`origin-label-anchor`], [string], ["north-east"], [Origin "0" label anchor],
  [`origin-leader`], [bool], [true], [Draw a subtle leader line from origin label toward (0,0)],
  [`origin-leader-stroke`], [stroke], [`black + 0.6pt`], [Origin leader stroke],
  [`origin-leader-gap`], [float], [0.025], [Gap from (0,0) before leader starts (cm)],
  [`origin-leader-end-gap`], [float], [0.025], [Gap before the label anchor (cm)],
  [`unit-label-only`], [bool], [false], [Show only "1" on axes],
  [`tick-label-size`], [length], [0.65em], [Tick label font size],
  [`axis-label-size`], [length], [0.8em], [Axis label font size],
)

#pagebreak()

*Grid Configuration:*

#table(
  columns: (1.3fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`show-grid`], [bool/string], [false], [true, false, "major", "minor", "both"],
  [`minor-grid-step`], [int], [5], [Subdivisions per major tick],
  [`grid-label-break`], [bool], [true], [Break grid lines around labels],
)

#v(0.5em)
*Styling:*

#table(
  columns: (1.3fr, 0.8fr, 1fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`style`], [dictionary], [none], [Style overrides (see Styling section)],
  [`series`], [array], [none], [Pre-built array of series specs (alternative to positional args)],
)

== Function/Data Specification

Each plot item is a dictionary with these fields:

#table(
  columns: (1.2fr, 0.8fr, 2.5fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Field*], [*Type*], [*Description*],
  [`fn`], [function], [Function to plot: `x => y` (return `none` to create a hole/discontinuity)],
  [`data`], [array], [Data points: `((x1, y1), (x2, y2), ...)`],
  [`connect`], [bool], [Connect data points with a line (default: `true` for `fn`, `false` for `data`)],
  [`domain`], [array], [Function domain: `(xmin, xmax)`],
  [`samples`], [int], [Number of samples for function (default: 100)],
  [`stroke`], [stroke], [Line style (default: `blue + 1.2pt`)],
  [`mark`], [string], [Marker type (default: `"none"`)],
  [`mark-size`], [float], [Marker size in cm (default: 0.12)],
  [`mark-fill`], [color], [Marker fill color (default: black)],
  [`mark-stroke`], [stroke], [Marker stroke style (default: `black + 0.8pt`)],
  [`label`], [content], [Label text placed near the curve],
  [`label-pos`], [float], [Position along the curve in \[0, 1\] (default: 1.0)],
  [`label-side`], [string], [Label placement relative to curve: `"above"`, `"below"`, `"left"`, `"right"`, `"above-left"`, etc.],
  [`label-anchor`], [string], [CeTZ anchor override (alternative to `label-side`)],
)

#pagebreak()

== `riemann-sum` Function

#table(
  columns: (1.3fr, 0.9fr, 1.3fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`fn`], [function], [—], [Function $f(x)$ to approximate],
  [`domain`], [array], [plot range], [Interval `(a, b)`; overrides the plot's x-range],
  [`n`], [int], [4], [Number of rectangles],
  [`method`], [string], [`"right"`], [`"left"`, `"right"`, `"mid"`, `"lower"`, `"upper"`],
  [`baseline`], [float], [0.0], [Y-level of rectangle bases (default: x-axis)],
  [`color`], [color], [`luma(220)`], [Rectangle fill; `none` for hatch-only],
  [`stroke`], [stroke], [`luma(80) + 0.6pt`], [Rectangle border stroke],
  [`hatch`], [string/none], [none], [Hatch pattern: `"ne"`, `"nw"`, `"h"`, `"v"`, `"cross"`, `"grid"`],
  [`hatch-spacing`], [length], [`5pt`], [Spacing between hatch lines],
  [`hatch-stroke`], [stroke], [`luma(80) + 0.5pt`], [Stroke for hatch lines],
  [`samples`], [int], [20], [Samples per sub-interval for `"lower"` / `"upper"` methods],
  [`show-points`], [bool], [false], [Draw a dot at each evaluation point],
  [`point-color`], [color], [`rgb("#c94a00")`], [Dot fill color],
  [`point-size`], [float], [0.07], [Dot radius in cm],
  [`point-label`], [content/auto/none], [`auto`], [Arrow label near dots; `auto` = method name, `none` = dots only],
  [`point-label-pos`], [array/auto], [`auto`], [`(x, y)` in data coords; `auto` = upper-right of dots],
  [`show-dx`], [bool], [false], [Draw a Δx dimension bracket under one rectangle],
  [`dx-rect`], [int/auto], [`auto`], [Rectangle to annotate (0-based); `auto` = middle rectangle],
  [`dx-label`], [content], [`$Delta x$`], [Label displayed inside the bracket],
  [`show-xi`], [bool], [false], [Draw $x_0, x_1, \ldots, x_n$ at subdivision points],
  [`xi-labels`], [array/auto], [`auto`], [Custom label array; `auto` = subscripted $x_i$ notation],
  [`xi-show-values`], [bool], [false], [Show numeric x-values instead of $x_i$ notation],
)

#pagebreak()

== `volume-of-revolution` Function

`solid-of-revolution` is an alias kept for backward compatibility.

#table(
  columns: (1.5fr, 0.9fr, 1.3fr, 2fr),
  stroke: (x: none, y: 0.3pt + luma(85%)),
  inset: 6pt,
  [*Parameter*], [*Type*], [*Default*], [*Description*],
  [`fn`], [function], [—], [Profile function $f(x)$; the curve that is revolved],
  [`domain`], [array], [`(0.0, 4.0)`], [Interval `(a, b)` — the revolution interval],
  [`n-disks`], [int], [4], [Number of intermediate disk cross-sections to show],
  [`width` / `height`], [float], [5.0 / 3.5], [Canvas size in cm],
  [`samples`], [int], [60], [Number of points sampled along the profile curve],
  [`axis-y`], [float], [0.0], [Y-value of horizontal revolution axis ($y = c$)],
  [`axis-slope`], [float], [0.0], [Slope $m$: revolution axis is $y = m x + "axis-y"$],
  [`show-axis`], [bool], [true], [Draw the revolution axis with an arrowhead],
  [`show-y-axis` / `show-yaxis`], [bool], [false], [Draw a coordinate y-axis at the left cap],
  [`y-axis-x` / `yaxis-x`], [float/auto], [`auto`], [X-position for the y-axis; `auto` = left of volume],
  [`y-axis-offset`], [float], [0.45], [Gap between y-axis and the volume when `auto`],
  [`y-axis-extend`], [array], [`(0.35, 0.45)`], [Y-axis padding `(below, above)` the solid],
  [`show-radius-marker`], [bool], [false], [Draw a vertical radius dimension marker at `yaxis-x`],
  [`show-back`], [bool], [true], [Show the back half of the solid (dashed ellipses + bottom curve)],
  [`show-labels`], [bool], [true], [Show $a$, $b$, $f$ labels],
  [`profile-stroke`], [stroke], [`blue + 1.5pt`], [Top profile curve stroke],
  [`disk-color`], [color], [`luma(218)`], [Solid body fill color],
  [`disk-stroke`], [stroke], [`luma(90) + 0.6pt`], [Disk edge stroke],
  [`axis-stroke`], [stroke], [`black + 0.7pt`], [Revolution axis stroke],
  [`label-a` / `label-b`], [content], [`$a$` / `$b$`], [Labels at domain endpoints],
  [`label-f`], [content], [`$f$`], [Function label near the profile curve],
  [`label-y`], [content], [`$y$`], [Label for the coordinate y-axis],
)

#pagebreak()

// =============================================================================
// EXAMPLES
// =============================================================================

= Complete Examples

== Trigonometric Functions

#example-full(
  [```typst
#plot(
  width: 10, height: 6,
  xmin: -2 * calc.pi, xmax: 2 * calc.pi,
  ymin: -1.5, ymax: 1.5,
  xlabel: $x$, ylabel: $y$,
  xtick: (-2*calc.pi, -calc.pi, 0, calc.pi, 2*calc.pi),
  xtick-labels: ($-2pi$, $-pi$, $0$, $pi$, $2pi$),
  show-grid: "major",
  (fn: x => calc.sin(x), stroke: blue + 1.5pt, label: $sin(x)$, label-pos: 1),
  (fn: x => calc.cos(x), stroke: red + 1.5pt, label: $cos(x)$, label-pos: 0),
)
  ```],
  [
    #plot(
      width: 10, height: 6,
      xmin: -2 * calc.pi, xmax: 2 * calc.pi,
      ymin: -1.5, ymax: 1.5,
      xlabel: $x$, ylabel: $y$,
      xtick: (-2*calc.pi, -calc.pi, 0, calc.pi, 2*calc.pi),
      xtick-labels: ($-2pi$, $-pi$, $0$, $pi$, $2pi$),
      show-grid: "major",
      (fn: x => calc.sin(x), stroke: blue + 1.5pt, label: $sin(x)$, label-pos: 1),
      (fn: x => calc.cos(x), stroke: red + 1.5pt, label: $cos(x)$, label-pos: 0),
    )
  ]
)

== Polynomial with Fine Grid

#example-full(
  [```typst
#plot(
  width: 10, height: 8,
  xmin: -3, xmax: 3, ymin: -5, ymax: 10,
  xlabel: $x$, ylabel: $y$,
  show-grid: "both",
  minor-grid-step: 5,
  (
    fn: x => x * x * x - 3 * x + 1,
    stroke: blue + 1.5pt,
    label: $f(x) = x^3 - 3x + 1$,
    label-side: "above",
    label-pos: 0.85,
  ),
)
  ```],
  [
    #plot(
      width: 10, height: 8,
      xmin: -3, xmax: 3, ymin: -5, ymax: 10,
      xlabel: $x$, ylabel: $y$,
      show-grid: "both",
      minor-grid-step: 5,
      (
        fn: x => x * x * x - 3 * x + 1,
        stroke: blue + 1.5pt,
        label: $f(x) = x^3 - 3x + 1$,
        label-side: "above",
        label-pos: 0.85,
      ),
    )
  ]
)

#pagebreak()

== Minimal Style Plot

#example-full(
  [```typst
#plot(
  width: 10, height: 8,
  xmin: -4, xmax: 4, ymin: -2, ymax: 6,
  xlabel: $x$, ylabel: $y$,
  show-grid: "major",
  unit-label-only: true,
  show-origin: false,
  (fn: x => x * x, stroke: blue + 1.5pt),
  (fn: x => -x * x + 5, stroke: red + 1.5pt),
)
  ```],
  [
    #plot(
      width: 10, height: 8,
      xmin: -4, xmax: 4, ymin: -2, ymax: 6,
      xlabel: $x$, ylabel: $y$,
      show-grid: "major",
      unit-label-only: true,
      show-origin: false,
      (fn: x => x * x, stroke: blue + 1.5pt),
      (fn: x => -x * x + 5, stroke: red + 1.5pt),
    )
  ]
)

== Data with Trend Line

#example-full(
  [```typst
#plot(
  width: 10, height: 7,
  xmin: 0, xmax: 6, ymin: 0, ymax: 12,
  xlabel: "Time (s)", ylabel: "Distance (m)",
  axis-x-pos: "bottom", axis-y-pos: "left",
  show-grid: "both",
  minor-grid-step: 5,
  (fn: x => 2 * x, stroke: gray + 1pt, domain: (0, 6)),  // Trend line
  (
    data: ((0.5, 1.2), (1, 2.3), (2, 3.8), (3, 6.2), (4, 7.9), (5, 10.1)),
    mark: "o",
    mark-size: 0.12,
    stroke: none,
  ),
)
  ```],
  [
    #plot(
      width: 10, height: 7,
      xmin: 0, xmax: 6, ymin: 0, ymax: 12,
      xlabel: "Time (s)", ylabel: "Distance (m)",
      axis-x-pos: "bottom", axis-y-pos: "left",
      show-grid: "both",
      minor-grid-step: 5,
      (fn: x => 2 * x, stroke: gray + 1pt, domain: (0, 6)),
      (
        data: ((0.5, 1.2), (1, 2.3), (2, 3.8), (3, 6.2), (4, 7.9), (5, 10.1)),
        mark: "o",
        mark-size: 0.12,
        stroke: none,
      ),
    )
  ]
)
