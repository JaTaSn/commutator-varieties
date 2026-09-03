# `article/arxiv/` — the arXiv submission bundle

**Generated. Do not hand-edit.** Regenerate with:

```
tools/make-arxiv.sh
```

which converts `article/ring-of-k-commuting-2x2-matrices.typ` (the canonical source) and prints a
report of the checks below.

## What to upload

`submission.tar.gz` — `main.tex` plus an `anc/` directory. **Not `main.tex` alone**, as it was
until 2026-09-03: the manuscript names ten computer-algebra scripts by path, at the point of use,
and those names are only worth printing if a reader can actually get the files. They ship, with
their transcripts, as arXiv **ancillary files**.

- `main.tex` is still fully self-contained *for the build* — documentclass, preamble, front matter,
  body and bibliography in one file, no `\input`, no `\includegraphics`, no external `.bib`. The
  figure is TikZ, drawn inline. Nothing under `anc/` is ever compiled.
- `anc/code/` and `anc/runs/` **preserve the paths the manuscript cites**, so
  `code/verify_over_finite_fields.sage` in the text is literally `anc/code/verify_over_finite_fields.sage`
  in the bundle. A flat `anc/` would have made every cited path wrong.
- The script list is **derived from the manuscript's own citations at build time**, not kept by hand
  here — a hand list drifts the moment a citation changes, and the failure mode is a reader
  following a filename that is not in the tarball. The derivation runs in both directions: a
  citation to a file that does not exist is a hard build failure, verified by injecting one.
- `runs/` ships whole. The script→transcript naming follows two different conventions
  (`verify_generator_independence.sage` → `generator-independence-results.txt`, but
  `verify_over_finite_fields.sage` → `verify-over-finite-fields.txt`), so a derived mapping would be
  fragile for no gain at 316 KB.
- **No TeX file appears under `anc/`** — that is arXiv's own rule, and it is what keeps AutoTeX from
  trying to build anything there.
- `main.pdf` is deliberately **not** in the tarball: arXiv objects to a PDF submitted alongside TeX
  source. It stays in `article/arxiv/` for local reading.

`anc/` and `submission.tar.gz` are `.gitignore`d — both are rebuilt wholesale on every run.

**Engine: xelatex.** The preamble uses `fontspec`. arXiv has supported xelatex since November 2025
(confirmed 2026-09-01 against arXiv's own TeX Live page); before that it would have needed a
pdflatex rewrite.

## Checks the generator asserts

| check | value |
|---|---|
| LaTeX errors | 0 |
| undefined references | 0 |
| undefined citations | 0 |
| `\bibitem` | 13 |
| `\cite` | 22 |
| backtick-apostrophe artifacts | 0 |
| quotes, opening / closing | 34 / 34 |
| boxed environments | 46 |
| figures | 1 |
| overfull hboxes | 0 |
| pages | 28 |
| ancillary | 10 scripts, 31 transcripts, 316K |
| internal matter | none |
| macro leakage | none |

Numbering is **identical** to the Typst reference PDF — the extracted environment sequences diff
empty, 46 each. That matters beyond tidiness: `LEAN/`, the working notes and the project's commit
history all cite these numbers (Theorem 12, Lemma 37, Theorem 44).

Two of these rows are worth knowing the provenance of.

**`overfull hboxes` is the appendix's automatic proofreader.** Section 13 sets long polynomials in
`verbatim`, and a line that runs past the measure is exactly what that counter detects. If it ever
leaves 0, a display in the appendix has outgrown the page.

**`macro leakage` was added 2026-09-03, after it was needed.** The `D → S` rename was applied
textually and hit two author initials inside `#bibentry` bodies, where a macro name is literal text
rather than a call — so the bibliography printed "J.A. Eagon, `signtwist().G.` Northcott" in *both*
routes for a day. Neither of the two existing guards could see it: the strings are ordinary prose to
the semicolon guard and match none of the internal-matter patterns. Like the internal-matter guard,
it greps the **built PDF** rather than the source, because the defect can enter from either the
`.typ` or `frontmatter.tex`.

## The one thing to know if you touch the pipeline

Cross-references do **not** go through `\cref`. They go through `\thmref{Type}{label}`, defined in
`preamble.tex`. Three separate reasons, each of which independently rules out the obvious approach:

1. tcolorbox prepends a colon to labels *unconditionally* — an empty `\newtcbtheorem` prefix still
   gives `:def-y1y2`, so bare `\cref{def-y1y2}` does not resolve to the box.
2. pandoc *also* emits a `\label{def-y1y2}` of its own from the Typst `<def-y1y2>`, bound to the
   **section** counter. So bare `\cref{def-y1y2}` is not undefined — it silently renders
   "Section 5" where the article says "Definition 14". Silently wrong is worse than visibly broken.
3. All the boxes share one counter (`use counter from=theorem`, to match Typst's global numbering),
   so cleveref can only ever call any of them "Theorem".

`\thmref` takes the supplement from the environment the label actually belongs to, which is the only
thing that gets all three right.
