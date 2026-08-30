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

### Status 2026-08-30, end of first session

**The full complete manuscript now converts and compiles: 0 LaTeX errors, 17 pages**, against the
new `article/preamble.tex`, with all 39 boxed environments, the coloured theorem styling, and the
11-entry bibliography. Four real bugs were found and fixed by building rather than by reading:

1. pandoc **line-wraps at ~72 columns** by default, splitting the markers and silently halving the
   conversion rate. `--wrap=none`.
2. Closing a marker needs a **stack**, not a regex.
3. tcolorbox's third argument is a label **suffix** and always prepends a colon, so
   `\begin{thm}{t}{foo}` defines `:foo`. Putting an ordinary `\label` in the body instead does
   *not* help -- it captures the *section* counter, rendering "Proof of Section 1".
4. **A theorem title can itself contain brackets.** One remark's title holds
   `\hyperref[def-wk]{...}`, so a regex ending the optional argument at the first `]` split the
   title mid-command and produced `Incomplete \iffalse; Emergency stop`. The label slot is now a
   sentinel filled without ever re-parsing the title.

### Converter, later the same session

Added a symbol pass, which was needed and which cost more than it looked. Typst writes Greek as bare
identifiers, so `tau`, `Phi`, `lambda`, `pi` arrived unescaped (66, 30, 21, 12 occurrences) and would
have typeset as italic *t-a-u*. Restoring the backslashes then exposed three further bugs, each found
by looking at output rather than by reasoning:

- the substitution fired **inside label names** — `rem-red-tau-omitted` became
  `rem-red-\tau-omitted`, silently breaking a cross-reference. Labels are now masked first, and
  `fix_references` runs *before* `fix_symbols` so cross-refs are already `\cref{...}` and get masked
  by the same rule;
- the masking helper stashed `m.group(0)` — the whole match — while the caller re-emitted group 1
  alongside it, duplicating text and swallowing spans. Greek substitution silently stopped and the
  build went 0 → 106 errors;
- `≔` was mapped to `r"\coloneqq"`, a **literal double backslash**, which inside a table is a row
  separator. Six errors from one stray backslash.

Also worth recording: a run of "errors" turned out to be TeX choking on a **stale `.aux`** left by the
corrupted build, not on the current source. Delete auxiliaries before believing an error count.

**Current state: 8 errors, 17 pages.** Greek renders (τ, Φ, λ, π all present), labels are intact,
and cross-references resolve — "Definition 3.2", "Theorem 4.1", "Lemma 4.3" appear correctly in the
PDF. The remaining 8 are `Missing $` / `Extra }` in specific spots, not a structural failure.

### Known residue, all bounded

- **Cross-references render as `??` (108 of them).** Diagnosed but not fixed: the labels *are*
  defined (`\newlabel{:def-wk}`, 136 of them) and *are* referenced under matching names
  (`\cref{:def-wk}`, 12 times), so this is a cleveref type-resolution problem with tcolorbox
  labels, not a naming mismatch. One step, not a redesign.
- `#bcite` keys arrive bare; they want `\cite{}` against `literature/references.bib`.
- The 11 bibliography entries are wrapped in a `thebibliography` but still hold Typst-era text.

### Older notes, kept

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
