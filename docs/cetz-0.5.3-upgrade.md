# simple-plot: CeTZ 0.5.3 upgrade, progress tracker

Source: investigation of 2026-10-19. On hold until CeTZ 0.5.3 is on Typst Universe.
Status legend: [ ] todo · [~] in progress · [x] done · [-] dropped (with reason)

## 0. Blockers
- [ ] CeTZ 0.5.3 is published on Typst Universe. On 2026-10-19 it was not: the
      tag exists on GitHub (2026-10-16) but Universe stops at 0.5.2.
- [ ] Accept dropping Typst 0.14: CeTZ 0.5.3 declares `compiler = "0.15.0"`
      (`typst.toml` here says `0.13.0`, already below CeTZ 0.5.2's `0.14.0`).

## 1. What CeTZ 0.5.3 brings
- `draw.clip(region, body)`: clips strokes and fills of any path by a closed
  region. New in 0.5.3, not listed in its CHANGES.md.
- Mark `inset:` no longer applied twice (#1099): the `Δx` bracket ends of
  `riemann-sum` move by a sub-pixel amount.
- `make-ctx`, point anchors on lines, `hobby`/`boolean` 2D-vector fixes.

## 2. Compatibility check (done 2026-10-19, nothing committed)
- [x] Typst 0.15.1 + CeTZ 0.5.2 and + CeTZ 0.5.3: every test file compiles,
      tests/check-issues.sh and tests/check-helpers.sh pass.
- [x] Snapshots, CeTZ 0.5.2 vs 0.5.3 on Typst 0.15.1: 11 pages differ, all
      sub-pixel (dash phase, anti-aliasing, the Riemann `Δx` bracket ends,
      page heights ±4 px). No visible change.
- [x] Snapshots, Typst 0.14.2 vs 0.15.1: 56 of 83 pages differ. In the pages
      inspected this is text rendering (e.g. the `✗` glyph in the manual), not the plots.

## 3. Does `clip` fix anything here? Little.
simple-plot already clips by computation: curves with `clip-segment`, fills by
clamping y (`clamp-y`), zoom insets with `clip-seg-z`. Checked on 2026-10-19:
a `fill-closed` disk larger than the window, a hatched `area-between` going past
`ymax` and a `parametric` curve leaving the window all render correctly today.
`clip` would mainly allow removing that code, not fixing bugs.

## 4. Plan (at the next release after the blockers clear)
- [ ] `lib.typ`: `@preview/cetz:0.5.2` → `0.5.3`.
- [ ] `typst.toml`: `compiler = "0.15.0"`.
- [ ] Snapshot before/after (tests/snapshot.sh + tests/compare-snapshots.sh)
      and check the diffs match §2.
- [ ] Optional: replace the manual clipping of fills and zoom insets by
      `cetz.draw.clip`, only if it removes code without changing any snapshot.

## 5. Pending on this branch (claude/pending-repos-review-iklato)
- [x] `hermite-spline` (reworked from #15) and `tangent-line` (from #16),
      credited to @amjmeyer; tests in tests/hermite-spline.typ,
      tests/tangent-line.typ, tests/check-helpers.sh.
- [ ] Push: blocked by a GitHub 403 on 2026-10-19 (session lacked repo access).
- [ ] After merge: close #15, #16 and #13 with thanks to Arthur, explaining the
      rework (function series, so curves are clipped at the plot edges).
- [ ] At release: bump the version, update the README `[Unreleased]` entries,
      add both helpers to `docs/manual.typ`, regenerate the gallery and manual.
