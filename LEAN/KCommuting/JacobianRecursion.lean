/-
Copyright (c) 2026 Jan Snellman. All rights reserved.

# Lemma 37 (`lem-jacrecursion`): the Jacobian's own recursion

The article states, for `J_k` the `3 × 3k` Jacobian of `w_k` and `[u]ₓ` the skew
matrix with `[u]ₓ v = u × v`:

    J₂  = [ -[v₂]ₓ | [v₁]ₓ ]
    J_k = [ -[v_k]ₓ D J_{k-1} | [D(w_{k-1})]ₓ ]        (k ≥ 3)

## Why this is stated entrywise here, and why that is not a weakening

There is no `3 × 3k` matrix in this file, and deliberately so. Blocks are indexed
by `ℕ` rather than `Fin k` throughout `Independence.lean` — see its header — so
that `w` can be defined once by recursion without the ambient ring changing at
every step. Building a Jacobian *matrix* would mean choosing a `Fin (3k)`
enumeration of the variables and carrying a cast at every use, reintroducing
exactly the pain that choice was made to avoid, and adding nothing: a matrix
identity between two `3 × 3k` matrices *is* the conjunction of its columns.

So the two blocks are stated as what they are — statements about the partial
derivative of `w k` with respect to one variable at a time:

* `jac_fresh_block`: differentiating in the **new** block `k-1` gives
  `D(w_{k-1}) ⨯₃ eⱼ`, i.e. the `j`-th column of `[D(w_{k-1})]ₓ`. This is the
  article's second block.
* `jac_old_block`: differentiating in any **older** block gives
  `-(v_{k-1} ⨯₃ D(∂ w_{k-1}))`, i.e. `-[v_k]ₓ D` applied to the corresponding
  column of `J_{k-1}`. This is the article's first block.

together with `jac_two_fresh` / `jac_two_old` for the base case `J₂`.

## What the proof needs

Only three things, and one of them is already here.

1. Leibniz for the cross product (`pd_cross`) — each component is a difference of
   two products, so `pderiv` being a derivation does all the work.
2. `pd` commutes with `D` (`pd_D`) — `D` is sign flips.
3. **Freshness**, in the fresh-block case: the first Leibniz term carries
   `∂ (w (n+2))` with respect to a variable of block `n+2`, and that vanishes
   precisely because block `n+2` does not occur in `w (n+2)`. This is
   `vars_w_lt`, the lemma that cost the most to prove, being used for something
   other than what it was proved for.

Note also that `[u]ₓ` needed no construction: mathlib's `crossProduct` is already
a bilinear map, so `crossProduct u` *is* the skew matrix as a linear map. An
earlier estimate priced this file as "a real afternoon, needs `pderiv` over
vectors plus skew-matrix bookkeeping"; the skew-matrix half of that was simply
wrong.
-/
import KCommuting.Independence

open MvPolynomial Matrix

namespace KCommuting

variable {F : Type*} [Field F]

/-- The componentwise partial derivative of a vector of polynomials: one column
of the Jacobian. -/
noncomputable def pd (x : Fin 3 × ℕ) (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    Fin 3 → MvPolynomial (Fin 3 × ℕ) F := fun i => pderiv x (u i)

@[simp] lemma pd_zero (x : Fin 3 × ℕ) : pd (F := F) x 0 = 0 := by
  funext i; simp [pd]

-- mathlib has no `cross_zero`/`zero_cross`; `crossProduct` is bilinear so these
-- are instances of `map_zero`, but proving them directly is shorter than
-- unfolding the `LinearMap` coercions twice.
@[simp] lemma cross_zero_right (a : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    a ⨯₃ (0 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) = 0 := by
  funext i; fin_cases i <;> simp [cross_apply]

@[simp] lemma cross_zero_left (a : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    (0 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ⨯₃ a = 0 := by
  funext i; fin_cases i <;> simp [cross_apply]

@[simp] lemma D_zero : D (0 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) = 0 := by
  funext i; fin_cases i <;> simp [D]

/-- **Leibniz for the cross product.** Each component of `a ⨯₃ b` is a difference
of two products, so the derivation property of `pderiv` gives this directly. -/
lemma pd_cross (x : Fin 3 × ℕ) (a b : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    pd x (a ⨯₃ b) = (pd x a) ⨯₃ b + a ⨯₃ (pd x b) := by
  funext i
  fin_cases i <;> simp [pd, cross_apply] <;> ring

/-- `pd` commutes with the twist, `D` being a sign flip in each coordinate. -/
lemma pd_D (x : Fin 3 × ℕ) (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    pd x (D u) = D (pd x u) := by
  funext i
  fin_cases i <;> simp [pd, D]

/-- Differentiating a variable block with respect to a *different* block. -/
lemma pd_v_of_ne (j : Fin 3) {m i : ℕ} (h : m ≠ i) : pd (F := F) (j, m) (v i) = 0 := by
  funext r
  simp only [pd, v, pderiv_X, Pi.single_apply, Prod.mk.injEq, Pi.zero_apply]
  rw [if_neg]
  rintro ⟨-, rfl⟩
  exact h rfl

/-- Differentiating a variable block with respect to its own block gives the
standard basis vector. -/
lemma pd_v_self (j : Fin 3) (i : ℕ) : pd (F := F) (j, i) (v i) = Pi.single j 1 := by
  funext r
  simp only [pd, v, pderiv_X, Pi.single_apply, Prod.mk.injEq]
  by_cases hr : r = j
  · subst hr; simp
  · rw [if_neg, if_neg hr]
    rintro ⟨rfl, -⟩
    exact hr rfl

/-- **Freshness, as a derivative.** `w n` does not involve block `n`, so it is
killed by differentiation there. This is `vars_w_lt` in the form the recursion
needs. -/
lemma pd_w_self (j : Fin 3) (n : ℕ) : pd (F := F) (j, n) (w n) = 0 := by
  funext i
  exact pderiv_eq_zero_of_notMem_vars (vars_w_lt (le_refl n) i j)

/-! ### The two blocks -/

/-- **The second block of `J_k`.** Differentiating `w (n+3)` in its *new* block
`n+2` gives `D(w (n+2)) ⨯₃ eⱼ` — the `j`-th column of `[D(w_{k-1})]ₓ`, with no
contribution from the old-variable term.

The vanishing of that term is exactly freshness: `pd (j, n+2) (w (n+2)) = 0`. -/
theorem jac_fresh_block (j : Fin 3) (n : ℕ) :
    pd (j, n + 2) (w (F := F) (n + 3)) = D (w (n + 2)) ⨯₃ Pi.single j 1 := by
  show pd (j, n + 2) (D (w (F := F) (n + 2)) ⨯₃ v (n + 2)) = _
  rw [pd_cross, pd_D, pd_w_self, pd_v_self, D_zero, cross_zero_left, zero_add]

/-- **The first block of `J_k`.** Differentiating `w (n+3)` in any *older* block
gives `-(v (n+2) ⨯₃ D (∂ w (n+2)))` — that is, `-[v_k]ₓ D` applied to the
corresponding column of `J_{k-1}`, which is the article's `-[v_k]ₓ D J_{k-1}`.

Here it is the *new*-variable term that drops, since `v (n+2)` does not involve
the older block. -/
theorem jac_old_block (j : Fin 3) {m n : ℕ} (hm : m ≠ n + 2) :
    pd (j, m) (w (F := F) (n + 3)) = -(v (n + 2) ⨯₃ D (pd (j, m) (w (n + 2)))) := by
  show pd (j, m) (D (w (F := F) (n + 2)) ⨯₃ v (n + 2)) = _
  rw [pd_cross, pd_D, pd_v_of_ne j hm, cross_zero_right, add_zero]
  exact (cross_anticomm _ _).symm

/-- **Lemma 37, whole.** The two blocks exhaust the columns: every variable lies
either in the new block or in an older one, so this single statement *is* the
matrix identity `J_k = [ -[v_k]ₓ D J_{k-1} | [D(w_{k-1})]ₓ ]`, column by column.

Stating it makes the claim in this file's header — that a matrix identity is the
conjunction of its columns — something Lean has checked rather than something
asserted in a comment. -/
theorem jac_recursion (j : Fin 3) (m n : ℕ) :
    pd (j, m) (w (F := F) (n + 3)) =
      if m = n + 2 then D (w (n + 2)) ⨯₃ Pi.single j 1
      else -(v (n + 2) ⨯₃ D (pd (j, m) (w (n + 2)))) := by
  by_cases h : m = n + 2
  · subst h; rw [if_pos rfl, jac_fresh_block]
  · rw [if_neg h, jac_old_block j h]

/-! ### The base case `J₂ = [ -[v₂]ₓ | [v₁]ₓ ]` -/

/-- `J₂`'s second block: differentiating `w 2 = v 0 ⨯₃ v 1` in block 1 gives
`v 0 ⨯₃ eⱼ`, the `j`-th column of `[v₁]ₓ`. -/
theorem jac_two_fresh (j : Fin 3) :
    pd (j, 1) (w (F := F) 2) = v 0 ⨯₃ Pi.single j 1 := by
  show pd (j, 1) ((v 0 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ⨯₃ v 1) = _
  rw [pd_cross, pd_v_of_ne j (by decide : (1 : ℕ) ≠ 0), pd_v_self, cross_zero_left, zero_add]

/-- `J₂`'s first block: differentiating in block 0 gives `-(v 1 ⨯₃ eⱼ)`, the
`j`-th column of `-[v₂]ₓ`.  Note there is no `D` here — `J₂` carries none, which
is why `lem-witness-new` has to argue the `k = 2` case separately. -/
theorem jac_two_old (j : Fin 3) :
    pd (j, 0) (w (F := F) 2) = -(v 1 ⨯₃ Pi.single j 1) := by
  show pd (j, 0) ((v 0 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ⨯₃ v 1) = _
  rw [pd_cross, pd_v_self, pd_v_of_ne j (by decide : (0 : ℕ) ≠ 1), cross_zero_right, add_zero]
  exact (cross_anticomm _ _).symm

end KCommuting
