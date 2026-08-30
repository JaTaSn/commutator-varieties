# runs/ --- raw computational reproducibility logs

Added 2026-08-16, alongside a pass that gave every $k=2,\ldots,6$ case a uniformly-named working
note (`working-notes/iterated-commutator-n_2-k_2.org`{.verbatim} through `..._k_6.org`{.verbatim}). Each result here is
a **fresh, independent re-execution** of that $k$\'s battery of `code/`{.verbatim} scripts (dim/codim/radical,
minimal generators + Cohen--Macaulay via Singular\'s `mres`{.verbatim}, primary decomposition, both Hilbert
series with the specialization cross-check, an explicit regular sequence, and a numeric
crosscheck), captured verbatim --- not copied from whatever was originally committed.

# Files

- `iterated-commutator-n_2-k_2-results.org`{.verbatim}
- `iterated-commutator-n_2-k_3-results.org`{.verbatim}
- `iterated-commutator-n_2-k_4-results.org`{.verbatim}
- `iterated-commutator-n_2-k_5-results.org`{.verbatim}
- `iterated-commutator-n_2-k_6-results.org`{.verbatim}

One file per $k$, each a `#+begin_example=/=#+end_example`{.verbatim} block per battery step, dated and
signed by the subagent that produced it (`Claude-Code-subagent-k<N>`{.verbatim}). The corresponding
`working-notes/iterated-commutator-n_2-k_<N>.org`{.verbatim} links back here (and to the `code/`{.verbatim} scripts it
ran) via relative org-mode links, rather than asserting numbers as prose alone.

Added 2026-08-16, later the same day, and **not** part of the per-$k$ battery above:

- `Y1-Y2-noncontainment-results.org`{.verbatim} --- raw output backing Step 4 of
  `working-notes/proof-plan-conjectures.org`{.verbatim} (closing the $Y_1$/$Y_2$ non-containment gap in
  the Conjecture 2 proof). Organised by $k$-transition rather than by battery step, since it is a
  single targeted check run at several $k$, not the full invariant battery.
- `jacobian-rank-radicality-results.org`{.verbatim} --- raw output backing Step 5 of the same note (the $R_0$
  half of the Serre-criterion proof that $I_k$ is radical: an explicit rank-2 Jacobian witness on
  every component, at every $k=2,\ldots,6$, plus the polynomial-matrix check of the Jacobian
  block recursion and a demonstration that the naive witness-transfer fails). One `#+begin_example`{.verbatim}
  block for the whole run, since the script\'s own output is already organised by $k$.

# Why this exists

Every number in the per-$k$ working notes had already been computed once, at the time each note
was originally written. This directory exists to make that reproducible in the literal sense ---
proof that re-running the same scripts today gives the same answer, not just a record that it was
computed once. All five re-runs matched the originally committed numbers exactly, no discrepancies
(see each working note\'s own synthesis section for the explicit comparison).

# Relationship to `code/`{.verbatim} and `working-notes/`{.verbatim}

- `code/`{.verbatim} --- the scripts themselves (the actual computation).
- `runs/`{.verbatim} (here) --- raw, dated, verbatim output from actually invoking those scripts.
- `working-notes/`{.verbatim} --- the prose interpretation, linking to both of the above.

The original, pre-2026-08-16 per-$k$ notes (`varieties-of-triple-commutators.org`{.verbatim},
`four-fold-commutator-n2.org`{.verbatim}, `five-fold-commutator-n2.org`{.verbatim}, `six-fold-commutator-n2.org`{.verbatim},
`A_B_C-commutator.org`{.verbatim}, the $k=2$ material in `small-commutators-musings.org`{.verbatim}) are untouched and
still the historical record of the original session-2 work; the `iterated-commutator-n_2-k_<N>.org`{.verbatim}
files are a parallel, uniformly-named, reproducibility-linked restatement of the same content, not
a replacement.
