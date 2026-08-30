# The ring of k-commuting 2×2 matrices

Manuscript repository, split out of `ai-workspace/projects/fast-commutators/` on 2026-08-30. The
project directory stays the working home — **review rounds, working notes and the LOGBOOK live
there**, deliberately, since more review is expected. This repo is the arXiv-bound artefact.

## Status: migration in progress, not yet a finished manuscript

| | |
|---|---|
| `article/source-complete.typ` | the fuller manuscript (81 KB) — Typst, the input |
| `article/source-signed-encoding.typ` | the leaner rewrite in the better coordinates (38 KB) — Typst, the input |
| `tools/` | the Typst → LaTeX conversion pipeline, **working and verified** |
| `code/` | 47 SageMath / Macaulay2 / Python scripts |
| `runs/` | 16 result files |
| `literature/` | 12 open-access PDFs + `references.bib`; `subscription/` for LiU-subscription copies |
| `LEAN/` | **a formalization *plan* only — no formalization exists yet** |
| `references/` | reserved for a certificate of non-hallucination |

The target, per Jan: everything the complete version has, in the signed encoding, with the
discussion of the competing encodings, as arXiv-acceptable xelatex, ideally generated from Org with
SageMath/Macaulay2 source blocks, keeping the coloured boxed-theorem look.

See `PLAN.md` for the architecture, the feasibility findings, and what is left.
