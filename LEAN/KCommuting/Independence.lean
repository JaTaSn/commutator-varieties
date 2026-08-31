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
    w (j+1) = D (w j) ⨯₃ v j

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

**Step 2 is the cost**, exactly as predicted: it needs that no variable of block
`k` occurs in `w j` for `j ≤ k`, pushed through `vars_mul` / `vars_sub_subset`
by induction.  It is isolated below as the single `sorry`, so the rest is
machine-checked independently of it.
-/
import Mathlib.LinearAlgebra.CrossProduct
import Mathlib.RingTheory.MvPolynomial.Basic
import Mathlib.Algebra.MvPolynomial.Variables
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

/-- The `i`-th block of three variables, as a vector. -/
noncomputable def v (i : ℕ) : Fin 3 → MvPolynomial (Fin 3 × ℕ) F := fun j => X (j, i)

/-- The sign twist `diag (-1, -1, 1)`.  An involution with `det = 1`, hence
invertible in *every* characteristic — unlike the naive reshuffle
`τ (a,b,c) = (b,a,2c)`, whose determinant is `-2`. -/
noncomputable def D (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) : Fin 3 → MvPolynomial (Fin 3 × ℕ) F :=
  ![-u 0, -u 1, u 2]

/-- The iterated commutator, in reduced coordinates. -/
noncomputable def w : ℕ → (Fin 3 → MvPolynomial (Fin 3 × ℕ) F)
  | 0 => v 0 ⨯₃ v 1
  | 1 => v 0 ⨯₃ v 1
  | (n + 2) => D (w (n + 1)) ⨯₃ v (n + 1)

/-- `D` is an involution. -/
@[simp] lemma D_D (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) : D (D u) = u := by
  funext j; fin_cases j <;> simp [D]

/-- `D` reflects linear dependence: a relation on `D u` gives one on `u`. -/
lemma dot_D (d u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) : d ⬝ᵥ D u = (D d) ⬝ᵥ u := by
  simp [D, dotProduct, Fin.sum_univ_three]

/-- **The freshness lemma** — the one genuinely open piece.

No variable of block `n + 1` occurs in `w n`: the recursion only ever consumes
blocks strictly below its index.  Proved by induction through `vars_mul` and
`vars_sub_subset`; see the header. -/
theorem vars_w_lt (n : ℕ) (j i : Fin 3) (m : ℕ) (hm : n ≤ m) :
    (j, m + 1) ∉ MvPolynomial.vars (w (F := F) n i) := by
  sorry

/-- Consequence of freshness: a polynomial identity linear in block `k`, with
coefficients free of block `k`, forces the coefficients to vanish. -/
theorem cross_eq_zero_of_dot_v_eq_zero {a : Fin 3 → MvPolynomial (Fin 3 × ℕ) F} {k : ℕ}
    (hfresh : ∀ j : Fin 3, ∀ i : Fin 3, (j, k) ∉ MvPolynomial.vars (a i))
    (h : a ⬝ᵥ v k = 0) : a = 0 := by
  sorry

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
