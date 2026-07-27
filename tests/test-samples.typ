#import "../lib.typ": *
#import "@preview/cetz-plot:0.1.4"
#import "@preview/cetz:0.5.2"

#plot(
  xmin: -5,
  xmax: 5,
  ymin: -5,
  ymax: 5,
  samples: 800,
  (fn: x => calc.sin(x * 10)),
)

\

#plot(
  xmin: -5,
  xmax: 5,
  ymin: -5,
  ymax: 5,
  (fn: x => calc.cos(x * 10)),
)

\

#cetz.canvas({
  import cetz.draw: *
  import cetz-plot: *
  plot.plot(
    size: (6, 6),
    axis-style: "school-book",
    x-min: -5,
    x-max: 5,
    y-min: -5,
    y-max: 5,
    {
      plot.add(
        domain: (-5, 5),
        samples: 800,
        style: (stroke: blue + 1.2pt),
        x => calc.sin(x * 10),
      )
    },
  )
})
