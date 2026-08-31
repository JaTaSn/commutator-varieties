/-
Copyright (c) 2026 Jan Snellman. All rights reserved.

# The three components of `w k` are linearly independent

The second half of Theorem 12 (`thm-mingens`; numbered Theorem 6 before the
2026-08-30 merge).  `MinimalGenerators.lean` proved the general
statement (independent same-degree generators are minimal); this file supplies
the hypothesis for the actual `w k`.

## The construction

Variables are indexed by `Fin 3 × ℕ`: `X (j, i)` is the `j`-th coordinate of the
`i`-th matrix.  Blocks are indexed by `ℕ` rather than `Fin k` so that `w` can be
defined once, by recursion, without the ambient ring changing with `k` — carrying
`Fin k` here would mean a different polynomial ring at every step and a cast at
every use.

    v i    = (X (0,i), X (1,i), X (2,i))
    D u    = (-u 0, -u 1, u 2)        the sign twist; `det D = 1`
    w 2    = v 0 ⨯₃ v 1
    w (j+1) = D (w j) ⨯₃ v j          for j ≥ 2

### A base-case bug in this definition, found and fixed 2026-08-31

The recursion above was originally written

    | 0 => v 0 ⨯₃ v 1
    | 1 => v 0 ⨯₃ v 1
    | (n + 2) => D (w (n + 1)) ⨯₃ v (n + 1)

which does **not** define the object in the display.  Lean's match sends `2` to
the recursive branch with `n = 0`, so the code's `w 2` was `D (w 1) ⨯₃ v 1`, not
`v 0 ⨯₃ v 1` — the two `| 0` / `| 1` clauses seeded the recursion instead of
being overridden by a base case at 2.  Every `w k` was therefore off by one
twisted cross product from the article's `w_k`, and the file's own docstring
above was the thing that was right.

Confirmed rather than eyeballed: `example : w 2 = D (w 1) ⨯₃ v 1 := rfl`
type-checks, and `example : w 2 = v 0 ⨯₃ v 1 := rfl` does not.  Nothing proved
before that date depended on it — `D_D`, `dot_D` and `exists_dot_eq_zero` never
mention `w` — so the fix costs no proof, but the object being formalized was the
wrong one until now.  The base case is now pinned at 2 explicitly, and 0 and 1
are junk (`0`), since the article's recursion simply does not start there.

## The proof, and where the work is

The manuscript's corrected argument (see `lem-mingens-indep`, and the remark
`rem-nondeg-insufficient` recording why the original was a gap) runs:

1. `c ⬝ᵥ (a ⨯₃ v k) = (c ⨯₃ a) ⬝ᵥ v k`                    -- triple product
2. `v k` is a *fresh* variable block, so `c ⨯₃ a = 0`      -- FRESHNESS
3. `c ≠ 0` gives a nonzero `d` with `d ⬝ᵥ a = 0`
4. `D` invertible carries that dependence back to `w (k-1)`

Step 3 is where mathlib is unexpectedly generous.  The obvious route divides —
`c ⨯₃ a = 0` with `c ≠ 0` gives `a = f • c` — and division in a polynomial ring
is a nuisance.  It is avoidable: take `d := c ⨯₃ e` for a constant `e` with
`c ⨯₃ e ≠ 0`.  Then

    d ⬝ᵥ a = (c ⨯₃ e) ⬝ᵥ a = e ⬝ᵥ (a ⨯₃ c) = -e ⬝ᵥ (c ⨯₃ a) = 0

by `triple_product_permutation` and `cross_anticomm` alone.  No division, and no
passage to the fraction field.

**Step 2 was the cost**, exactly as predicted: it needs that no variable of block
`k` occurs in `w j` for `j ≤ k`, pushed through `vars_mul` / `vars_sub_subset`
by induction.

### Closed 2026-08-31

Both remaining `sorry`s are gone; the file contains none.

* `vars_w_subset` / `vars_w_lt` — freshness.  The load-bearing step is the
  containment `vars (w n i) ⊆ {blocks < n}`, which inducts where the membership
  form does not.  Four small helpers carry it through the four constructors the
  recursion uses.  The statement of `vars_w_lt` had to be corrected first; see
  the restatement note at that lemma.
* `cross_eq_zero_of_dot_v_eq_zero` — via `pderiv`, not `coeff`.  Freshness enters
  as `pderiv_eq_zero_of_notMem_vars`.

Two imports had to be added for this: `Mathlib.Algebra.MvPolynomial.CommRing`
(for `vars_neg` and `vars_sub_subset`, which are *not* reachable through
`Mathlib.Algebra.MvPolynomial.Variables`, contrary to what the names suggest)
and `Mathlib.Algebra.MvPolynomial.PDeriv`.
-/
import Mathlib.LinearAlgebra.CrossProduct
import Mathlib.RingTheory.MvPolynomial.Basic
import Mathlib.Algebra.MvPolynomial.Variables
-- `vars_neg` and `vars_sub_subset` live here, and are NOT reachable through any
-- of the other imports (checked 2026-08-31: without this line both are "unknown
-- constant", even with `Variables` and `RingTheory.MvPolynomial.Basic` present).
import Mathlib.Algebra.MvPolynomial.CommRing
-- `pderiv`, and `pderiv_eq_zero_of_notMem_vars`, which is what turns freshness
-- into a usable statement in `cross_eq_zero_of_dot_v_eq_zero`.
import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.RingTheory.MvPolynomial.Homogeneous
import Mathlib.LinearAlgebra.LinearIndependent.Defs

open MvPolynomial Matrix

namespace KCommuting

variable {F : Type*} [Field F]

-- No abbreviation for the ambient ring.  An `abbrev` is reducible, so `R F`
-- unfolds to `AddMonoidAlgebra` and `(p : R F).vars` fails to elaborate; a plain
-- `def` needs its `CommRing` instance transported, which drags in a pile of
-- noncomputable `AddMonoidAlgebra` internals.  Writing the type out is shorter
-- than either and costs nothing.
--
-- Note also: `.vars` dot-notation does NOT resolve even on the explicit type --
-- Lean unfolds MvPolynomial to AddMonoidAlgebra and reports "the environment
-- does not contain AddMonoidAlgebra.vars".  Write `MvPolynomial.vars p`.
--
-- 2026-08-31: the same trap a second time, now with `.IsHomogeneous` ("the
-- environment does not contain AddMonoidAlgebra.IsHomogeneous").  So it is a
-- rule, not a quirk of `vars`: for ANY field projected off a term of type
-- `MvPolynomial σ F`, write the namespace out.  Dot-notation on a *hypothesis*
-- of type `MvPolynomial.IsHomogeneous _ _` is fine -- `h.mul`, `h.sub`, `h.neg`
-- all resolve.  It is only projection off the polynomial itself that fails.

/-- The `i`-th block of three variables, as a vector. -/
noncomputable def v (i : ℕ) : Fin 3 → MvPolynomial (Fin 3 × ℕ) F := fun j => X (j, i)

/-- The sign twist `diag (-1, -1, 1)`.  An involution with `det = 1`, hence
invertible in *every* characteristic — unlike the naive reshuffle
`τ (a,b,c) = (b,a,2c)`, whose determinant is `-2`. -/
noncomputable def D (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) : Fin 3 → MvPolynomial (Fin 3 × ℕ) F :=
  ![-u 0, -u 1, u 2]

/-- The iterated commutator, in reduced coordinates.  The article's recursion
starts at `k = 2`, so `w 0` and `w 1` are junk; see the base-case note in this
file's header for why they must not be `v 0 ⨯₃ v 1`. -/
noncomputable def w : ℕ → (Fin 3 → MvPolynomial (Fin 3 × ℕ) F)
  | 0 => 0
  | 1 => 0
  | 2 => v 0 ⨯₃ v 1
  | (n + 3) => D (w (n + 2)) ⨯₃ v (n + 2)

/-- Regression tests for the base case, as `rfl`-checks rather than prose. -/
example : (w (F := F) 2) = (v 0 ⨯₃ v 1 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) := rfl
example : (w (F := F) 3) = D (v 0 ⨯₃ v 1) ⨯₃ v 2 := rfl

/-- `D` is an involution. -/
@[simp] lemma D_D (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) : D (D u) = u := by
  funext j; fin_cases j <;> simp [D]

/-- `D` reflects linear dependence: a relation on `D u` gives one on `u`. -/
lemma dot_D (d u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) : d ⬝ᵥ D u = (D d) ⬝ᵥ u := by
  simp [D, dotProduct, Fin.sum_univ_three]

/-!
### Homogeneity

`three_generators_minimal` in `MinimalGenerators.lean` takes homogeneity as a
hypothesis (`hhom`) alongside independence.  For the real `w k` that obligation
is discharged here.  It was the third missing ingredient the first pass did not
count, and — unlike the freshness lemma — it is cheap: the recursion is built
from variables, products, differences and sign flips, every one of which has a
mathlib lemma for its effect on degree.
-/

/-- Each variable is homogeneous of degree 1. -/
lemma isHomogeneous_v (i : ℕ) (j : Fin 3) :
    MvPolynomial.IsHomogeneous ((v (F := F) i) j) 1 :=
  MvPolynomial.isHomogeneous_X _ _

/-- `D` only flips signs, so it preserves degree. -/
lemma isHomogeneous_D {p : ℕ} {u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F}
    (hu : ∀ j, MvPolynomial.IsHomogeneous (u j) p) (j : Fin 3) :
    MvPolynomial.IsHomogeneous ((D u) j) p := by
  fin_cases j
  · simpa [D] using (hu 0).neg
  · simpa [D] using (hu 1).neg
  · simpa [D] using hu 2

/-- Each component of a cross product is a difference of two products, so degrees
add. -/
lemma isHomogeneous_cross {p q : ℕ} {a b : Fin 3 → MvPolynomial (Fin 3 × ℕ) F}
    (ha : ∀ j, MvPolynomial.IsHomogeneous (a j) p)
    (hb : ∀ j, MvPolynomial.IsHomogeneous (b j) q) (j : Fin 3) :
    MvPolynomial.IsHomogeneous ((a ⨯₃ b) j) (p + q) := by
  fin_cases j
  · simpa [cross_apply] using ((ha 1).mul (hb 2)).sub ((ha 2).mul (hb 1))
  · simpa [cross_apply] using ((ha 2).mul (hb 0)).sub ((ha 0).mul (hb 2))
  · simpa [cross_apply] using ((ha 0).mul (hb 1)).sub ((ha 1).mul (hb 0))

/-- **The homogeneity obligation.**  Every component of `w (n+2)` is homogeneous
of degree `n+2`.  Stated in `+2` form because that is what the induction wants;
`isHomogeneous_w'` gives the `2 ≤ k` form the article states. -/
theorem isHomogeneous_w (n : ℕ) :
    ∀ j : Fin 3, MvPolynomial.IsHomogeneous ((w (F := F) (n + 2)) j) (n + 2) := by
  induction n with
  | zero => exact fun j => isHomogeneous_cross (isHomogeneous_v 0) (isHomogeneous_v 1) j
  | succ n ih => exact fun j => isHomogeneous_cross (isHomogeneous_D ih) (isHomogeneous_v (n + 2)) j

/-- The article's form: for every `k ≥ 2`, the three components of `w k` are
homogeneous of degree `k`. -/
theorem isHomogeneous_w' {k : ℕ} (hk : 2 ≤ k) (j : Fin 3) :
    MvPolynomial.IsHomogeneous ((w (F := F) k) j) k := by
  obtain ⟨n, rfl⟩ : ∃ n, k = n + 2 := ⟨k - 2, by omega⟩
  exact isHomogeneous_w n j

/-!
### Freshness

`w n` consumes exactly the blocks `0, …, n-1`, so every block `≥ n` is fresh for
it.  The whole argument is the single containment `vars (w n i) ⊆ blocks < n`,
pushed through the recursion; the four helper lemmas below are just that
containment for the four constructors the recursion is built from (product minus
product, cross product, sign twist, variable block).

They are all phrased as `∀ x ∈ MvPolynomial.vars p, x ∈ S` for an ambient
`S : Set (Fin 3 × ℕ)` rather than as `Finset` inclusions.  That is deliberate:
`vars` is a `Finset`, so a `⊆` statement would force a `DecidableEq` on the
index type into every statement and make the union bookkeeping in
`vars_mul_sub_mul_subset` visible at every call site.  With a `Set` the
side conditions become `omega` goals about `x.2`, which is what they actually
are.

### A restatement, 2026-08-31

The `sorry`'d statement this replaces read

    theorem vars_w_lt (n : ℕ) (j i : Fin 3) (m : ℕ) (hm : n ≤ m) :
        (j, m + 1) ∉ MvPolynomial.vars (w (F := F) n i)

which was written against the pre-fix `w` and never updated.  It is *true*, but
too weak to be usable: with `n ≤ m` it excludes only blocks `≥ n + 1`, and the
block the argument needs excluded is `n` itself — `w (k+1) = D (w k) ⨯₃ v k`
crosses `w k` with block `k`, and freshness is exactly the claim that block `k`
does not already occur in `w k`.  Under the old statement that instance would
need `n = k, m = k - 1`, i.e. `k ≤ k - 1`, which is false.  The statement now
says: for every `m ≥ n`, block `m` is absent from `w n`.
-/

/-- Variables of `p * q - r * s`: contained in the union of the four factors'.
The one place where `vars_sub_subset` and `vars_mul` are used. -/
lemma vars_mul_sub_mul_subset {S : Set (Fin 3 × ℕ)}
    (p q r s : MvPolynomial (Fin 3 × ℕ) F)
    (hp : ∀ x ∈ MvPolynomial.vars p, x ∈ S) (hq : ∀ x ∈ MvPolynomial.vars q, x ∈ S)
    (hr : ∀ x ∈ MvPolynomial.vars r, x ∈ S) (hs : ∀ x ∈ MvPolynomial.vars s, x ∈ S) :
    ∀ x ∈ MvPolynomial.vars (p * q - r * s), x ∈ S := by
  classical
  intro x hx
  -- `vars_sub_subset` takes `p` and `q` as *explicit* section variables, so the
  -- positional application `vars_sub_subset hx` misparses `hx` as a polynomial;
  -- name them.
  rcases Finset.mem_union.1
      (MvPolynomial.vars_sub_subset (p := p * q) (q := r * s) hx) with h | h
  · rcases Finset.mem_union.1 (MvPolynomial.vars_mul _ _ h) with h | h
    · exact hp x h
    · exact hq x h
  · rcases Finset.mem_union.1 (MvPolynomial.vars_mul _ _ h) with h | h
    · exact hr x h
    · exact hs x h

/-- Each component of `a ⨯₃ b` is a difference of two products of components, so
a set containing every variable of every component of `a` and of `b` contains
every variable of every component of `a ⨯₃ b`. -/
lemma vars_cross_subset {a b : Fin 3 → MvPolynomial (Fin 3 × ℕ) F} {S : Set (Fin 3 × ℕ)}
    (ha : ∀ j, ∀ x ∈ MvPolynomial.vars (a j), x ∈ S)
    (hb : ∀ j, ∀ x ∈ MvPolynomial.vars (b j), x ∈ S) :
    ∀ i, ∀ x ∈ MvPolynomial.vars ((a ⨯₃ b) i), x ∈ S := by
  intro i
  fin_cases i
  · simpa [cross_apply] using
      vars_mul_sub_mul_subset (a 1) (b 2) (a 2) (b 1) (ha 1) (hb 2) (ha 2) (hb 1)
  · simpa [cross_apply] using
      vars_mul_sub_mul_subset (a 2) (b 0) (a 0) (b 2) (ha 2) (hb 0) (ha 0) (hb 2)
  · simpa [cross_apply] using
      vars_mul_sub_mul_subset (a 0) (b 1) (a 1) (b 0) (ha 0) (hb 1) (ha 1) (hb 0)

/-- `D` only flips signs, so it does not change any component's variables
(`vars_neg`). -/
lemma vars_D_subset {u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F} {S : Set (Fin 3 × ℕ)}
    (hu : ∀ j, ∀ x ∈ MvPolynomial.vars (u j), x ∈ S) :
    ∀ j, ∀ x ∈ MvPolynomial.vars ((D u) j), x ∈ S := by
  intro j
  fin_cases j
  · simpa [D] using hu 0
  · simpa [D] using hu 1
  · simpa [D] using hu 2

/-- The only variable of `(v i) j` is `(j, i)` itself. -/
lemma vars_v_subset {S : Set (Fin 3 × ℕ)} (i : ℕ) (h : ∀ j : Fin 3, (j, i) ∈ S) :
    ∀ j, ∀ x ∈ MvPolynomial.vars ((v (F := F) i) j), x ∈ S := by
  intro j x hx
  simp only [v, MvPolynomial.vars_X, Finset.mem_singleton] at hx
  subst hx
  exact h j

/-- **Freshness, in the form that inducts.**  Every variable occurring in any
component of `w n` lies in a block strictly below `n`.

The case split is the recursion's own: `n = 0, 1` are the junk value `0`, whose
`vars` is empty; `n = 2` is `v 0 ⨯₃ v 1`, blocks `0` and `1`; and the step takes
`w (n+2)` — blocks `< n+2` by the inductive hypothesis, unchanged by `D` — and
crosses it with block `n+2`, giving blocks `< n+3`. -/
lemma vars_w_subset (n : ℕ) :
    ∀ i, ∀ x ∈ MvPolynomial.vars (w (F := F) n i), x.2 < n := by
  match n with
  | 0 => intro i x hx; simp [w] at hx
  | 1 => intro i x hx; simp [w] at hx
  | (n + 2) =>
    induction n with
    | zero =>
        exact vars_cross_subset (S := {y : Fin 3 × ℕ | y.2 < 0 + 2})
          (vars_v_subset 0 fun _ => show (0 : ℕ) < 0 + 2 by omega)
          (vars_v_subset 1 fun _ => show (1 : ℕ) < 0 + 2 by omega)
    | succ n ih =>
        exact vars_cross_subset (S := {y : Fin 3 × ℕ | y.2 < n + 1 + 2})
          (vars_D_subset fun j x hx => show x.2 < n + 1 + 2 from by
            have := ih j x hx; omega)
          (vars_v_subset (n + 2) fun _ => show n + 2 < n + 1 + 2 by omega)

/-- **The freshness lemma.**  For every `m ≥ n`, no variable of block `m` occurs
in `w n` — in particular none of block `n`, which is the instance the
independence argument consumes.  See the restatement note above. -/
theorem vars_w_lt {n m : ℕ} (hm : n ≤ m) (i j : Fin 3) :
    (j, m) ∉ MvPolynomial.vars (w (F := F) n i) := fun h =>
  absurd (vars_w_subset n i (j, m) h) (Nat.not_lt.2 hm)

/-- **The instance the independence argument consumes**: block `k` is fresh for
`w k`, so `w (k+1) = D (w k) ⨯₃ v k` is linear in a block absent from its own
coefficient.

Kept as a regression test rather than left implicit, because it is exactly the
instance the pre-2026-08-31 statement of `vars_w_lt` could *not* produce — under
that version it required `k ≤ k - 1`.  If a future edit weakens the lemma back
in that direction, this line stops compiling. -/
example (k : ℕ) (i j : Fin 3) : (j, k) ∉ MvPolynomial.vars (w (F := F) k i) :=
  vars_w_lt (le_refl k) i j

/-- Consequence of freshness: a polynomial identity linear in block `k`, with
coefficients free of block `k`, forces the coefficients to vanish.

Proved by differentiation rather than by extracting coefficients.  `pderiv (j,k)`
is a derivation, so it passes through the sum and each product by the Leibniz
rule; freshness kills `pderiv (j,k) (a i)` outright via
`pderiv_eq_zero_of_notMem_vars`, leaving `∑ i, a i * pderiv (j,k) (X (i,k))`,
and `pderiv_X` collapses that sum to its single surviving term `a j`.  Reading
off a coefficient instead would have required naming the monomial and arguing
that the `a i` contribute nothing to it — the same content, with bookkeeping.

One ordering constraint: the three `pderiv_eq_zero_of_notMem_vars` rewrites must
fire *before* `fin_cases j`.  Afterwards the `j` in `hfresh j i` has become
`⟨0, ⋯⟩` while the goal carries the literal `0`, and `simp` no longer matches the
two, so a single combined `fin_cases j <;> simpa [...]` leaves the derivative
terms standing. -/
theorem cross_eq_zero_of_dot_v_eq_zero {a : Fin 3 → MvPolynomial (Fin 3 × ℕ) F} {k : ℕ}
    (hfresh : ∀ j : Fin 3, ∀ i : Fin 3, (j, k) ∉ MvPolynomial.vars (a i))
    (h : a ⬝ᵥ v k = 0) : a = 0 := by
  classical
  funext j
  show a j = 0
  have h3 : a 0 * X (0, k) + a 1 * X (1, k) + a 2 * X (2, k) = (0 : MvPolynomial (Fin 3 × ℕ) F) := by
    simpa [dotProduct, Fin.sum_univ_three, v] using h
  have hd := congrArg (pderiv ((j, k) : Fin 3 × ℕ)) h3
  simp only [map_add, pderiv_mul,
    pderiv_eq_zero_of_notMem_vars (hfresh j 0),
    pderiv_eq_zero_of_notMem_vars (hfresh j 1),
    pderiv_eq_zero_of_notMem_vars (hfresh j 2),
    zero_mul, zero_add, map_zero] at hd
  fin_cases j <;> simpa [pderiv_X, Prod.ext_iff] using hd

/-- **Step 3, division-free.**  If `c ⨯₃ a = 0` for a nonzero constant `c`, then
some nonzero constant `d` annihilates `a`. -/
theorem exists_dot_eq_zero {c : Fin 3 → F} (hc : c ≠ 0) {a : Fin 3 → MvPolynomial (Fin 3 × ℕ) F}
    (h : (fun j => C (c j)) ⨯₃ a = 0) :
    ∃ d : Fin 3 → F, d ≠ 0 ∧ (fun j => C (d j)) ⬝ᵥ a = 0 := by
  classical
  -- Pick a standard basis vector not parallel to `c`.  If all three were
  -- parallel, `c` would be zero: `c ⨯₃ e₀ = (0, c₂, -c₁)` and cyclically, so the
  -- three conditions together say every coordinate of `c` vanishes.
  obtain ⟨t, ht⟩ : ∃ t : Fin 3, c ⨯₃ (Pi.single t 1) ≠ 0 := by
    by_contra hall
    push_neg at hall
    apply hc
    funext i
    -- c ⨯₃ e₀ = (0, c₂, -c₁) and c ⨯₃ e₁ = (-c₂, 0, c₀): between them every
    -- coordinate of c is named.
    have h0 := congrFun (hall 0) 1
    have h1 := congrFun (hall 0) 2
    have h2 := congrFun (hall 1) 2
    simp [cross_apply] at h0 h1 h2
    fin_cases i <;> simp_all
  refine ⟨c ⨯₃ (Pi.single t 1), ht, ?_⟩
  -- `C` is a ring hom, so it commutes with the cross product entrywise.
  -- Every `C` needs its target type pinned: with three of them in one statement
  -- Lean cannot infer sigma/R, and the errors point at the `have`, not at the
  -- rewrite that follows.
  have hC : (fun j => (C ((c ⨯₃ (Pi.single t 1)) j) : MvPolynomial (Fin 3 × ℕ) F))
      = (fun j => (C (c j) : MvPolynomial (Fin 3 × ℕ) F))
        ⨯₃ (fun j => (C ((Pi.single t 1 : Fin 3 → F) j) : MvPolynomial (Fin 3 × ℕ) F)) := by
    funext j; fin_cases j <;> simp [cross_apply, map_sub, map_mul]
  rw [hC, dotProduct_comm, triple_product_permutation, triple_product_permutation]
  have hzero : a ⨯₃ (fun j => (C (c j) : MvPolynomial (Fin 3 × ℕ) F)) = 0 := by
    rw [← cross_anticomm]
    simp [h]
  rw [hzero, dotProduct_zero]

end KCommuting
