# Architecture, feasibility, and what is left

Written 2026-08-30, after building and testing the conversion pipeline rather than estimating from
the outside. Everything marked **measured** below was run.

## 1. The one thing that decides the architecture: Org + babel

Jan asked whether the manuscript could be generated from an Org file with SageMath and Macaulay2
source blocks, and for an estimate of the extra work. Two measurements settle it:

- **SageMath: feasible.** `ob-sagemath` and `sage-shell-mode` are both installed in the Doom config.
- **Macaulay2: NOT feasible as live evaluation.** `ob-M2` is installed and `org-babel-execute:M2`
  is bound, but it **hangs indefinitely on `C-c C-c`** — documented in this workspace on 2026-08-15
  (`hardware-software-setup/ob-M2-session-hang-bug.md`), confirmed to hang with *and without*
  `:session`, while the identical block piped to `M2` from a shell finishes in about a second. It is
  an upstream defect in `ob-M2`, not a local configuration problem, and reverting all local
  overrides did not help. Six of this article's scripts are Macaulay2.

**So: Org yes, live evaluation no** — and that is the right design regardless. Source blocks should
carry `:eval no-export` with **committed `#+RESULTS:`**, so the code is displayed and the numbers are
reproducible, while an arXiv build never tries to run Macaulay2. Re-running is then a deliberate
`make verify`, not a side effect of typesetting. This sidesteps the `ob-M2` bug completely and costs
nothing that matters.

**Extra work over writing plain LaTeX: small — perhaps a day.** The Org layer is a thin wrapper; the
real work below is the same either way.

## 2. The Typst → LaTeX pipeline, built and verified

`pandoc` 3.7 has a genuine Typst *reader*, but it **evaluates** the source, so it dies on the first
`theorion` call. Feeding it stub definitions first makes the whole document parse.

```
tools/typ2tex.sh  =  strip preamble | prepend tools/typst-stubs.typ | pandoc --wrap=none | tools/markers2env.py
```

**Measured, on both manuscripts, exit 0:**

| | source calls | LaTeX environments | balance |
|---|---|---|---|
| theorem | 7 | 7 | ok |
| proposition | 4 | 4 | ok |
| lemma | 12 | 12 | ok |
| remark | 6 | 6 | ok |
| definition | 3 | 3 | ok |
| example | 7 | 7 | ok |
| proof | 22 | 22 | ok |

Zero unconverted markers. Headings, inline and display maths, `\overline`, `\mathbb`, `\nsubseteq`,
bold/emphasis, lists, labels and cross-references all survive.

Two traps found the hard way, both now handled: pandoc **line-wraps at ~72 columns by default**,
which split the markers and silently halved the conversion rate (`--wrap=none`); and closing a
marker needs a **stack**, not a regex, since `⟦END⟧` does not say what it closes — hence
`markers2env.py` rather than more `sed`.

### Known cosmetic residue, mechanical to fix

- `\hyperref[x]{{[}x{]}}` should become `\cref{x}` — one pass.
- labels land *after* `\end{...}` and want moving inside.
- a stray `{}` at the start of some optional arguments.
- `#bcite` keys arrive bare; they want `\cite{}` against `literature/references.bib`.
- 11 hand-rolled `bibentry` blocks want replacing by real bibliography entries.

## 3. Typography

The Typst uses `theorion` with `cosmos.fancy` — the "colourful boxed theorem" look Jan wants kept.
The LaTeX equivalent is **`tcolorbox` with its `theorems` library**, which reproduces it closely.

Per Jan's instruction, **as much as possible goes in a `setup.org` / `preamble.tex` pair** so a
journal submission is a one-file swap: `scrartcl` (KOMA) as the base, with an `amsart` variant kept
beside it. Nothing about the colours or the box geometry should appear in the manuscript body.

## 4. What is left, in order

1. **Merge the two manuscripts.** The real intellectual work, and the only part that is not
   mechanical: take the complete version's content, re-express it in the signed encoding, and fold in
   the discussion of the competing encodings. Both are converted and available side by side.
2. Build `setup.org` + `preamble.tex` with the tcolorbox theorem styling.
3. Post-processing pass for the residue in §2.
4. Wire `code/` and `runs/` in as `:eval no-export` blocks with committed results.
5. A certificate of non-hallucination for the references, following the pattern already used in
   `arithmetical-functions-truncations`.
6. `SUBMISSION.txt` — arXiv metadata, MSC 2020, categories, licence.

## 5. Two things needing Jan

- **There is no Lean formalization.** `LEAN/` holds `lean-formalization-plan.org`, a plan, and
  nothing else — no `.lean` file exists anywhere in the project. Jan asked for "the partial lean
  formalization" to be included; either he means the plan, or he is thinking of
  `lattice-line-covers` or `dirichlet-truncations`, both of which do have real formalizations.
- **No certificate of non-hallucination exists yet** for this project. He said "when applicable", so
  this may simply not apply yet; it would be new work.
