// Fixtures for the reported issues, one per page. Compile with
//   typst compile tests/issue-fixtures.typ out.png --root . --ppi 200
// and check the assertions in tests/check-issues.sh.
#import "/lib.typ": *

#set page(width: 12cm, height: 7.5cm, margin: 0.5cm)
#set text(font: "New Computer Modern", size: 9pt)

// 1 — #11: a dashed stroke must read as dashed at the default width. Drawing
// the curve segment by segment restarted the pattern at every sample.
#plot((fn: x => 1, stroke: (paint: black, dash: "dashed")))
#pagebreak()

// 2 — #9: a curve through the origin used to take the "0" with it. The label
// now moves to a free corner instead of disappearing.
#plot(xmin: -3, xmax: 3, (fn: x => x))
#pagebreak()

// 3 — empty custom labels must not open gaps in the grid.
#plot(show-grid: true, xmin: -3, xmax: 3, ymin: -3, ymax: 3,
  xtick: (-3, -2, -1, 0, 1, 2, 3), xtick-labels: ("", "", "", "", "1", "", ""),
  ytick: (-3, -2, -1, 0, 1, 2, 3), ytick-labels: ("", "", "", "", "1", "", ""),
  (fn: x => x / 3))
#pagebreak()

// 4 — #7: samples is settable for the whole plot, not only per curve.
#plot(xmin: -5, xmax: 5, samples: 2000, (fn: x => calc.sin(x * 10)))
