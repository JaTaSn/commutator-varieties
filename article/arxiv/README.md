# `article/arxiv/` — the arXiv submission bundle

**Generated. Do not hand-edit.** Regenerate with:

```
tools/make-arxiv.sh
```

which converts `article/ring-of-k-commuting-2x2-matrices.typ` (the canonical source) and prints a
report of the checks below.

## What to upload

`main.tex` alone. It is fully self-contained — documentclass, preamble, front matter, body and
bibliography in one file, no `\input`, no `\includegraphics`, no external `.bib`. The figure is
TikZ, drawn inline.

**Engine: xelatex.** The preamble uses `fontspec`. arXiv has supported xelatex since November 2025
(confirmed 2026-09-01 against arXiv's own TeX Live page); before that it would have needed a
pdflatex rewrite.

## Checks the generator asserts

| check | value |
|---|---|
| LaTeX errors | 0 |
| undefined references | 0 |
| undefined citations | 0 |
| `\bibitem` | 12 |
| `\cite` | 21 |
| backtick-apostrophe artifacts | 0 |
| quotes, opening / closing | 33 / 33 |
| boxed environments | 45 |
| figures | 1 |
| overfull hboxes | 0 |
| pages | 23 |

Numbering is **identical** to the Typst reference PDF — the extracted environment sequences diff
empty, 45 each. That matters beyond tidiness: `LEAN/`, the working notes and the project's commit
history all cite these numbers (Theorem 12, Lemma 37, Theorem 44).

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
