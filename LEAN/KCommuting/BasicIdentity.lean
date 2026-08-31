/-
Copyright (c) 2026 Jan Snellman. All rights reserved.

# The Setup section's computational claims

Everything in §3 of the article that is a *closed-form computation* rather than
an argument.  Until now each of these rested on a Sage run alone
(`code/verify_lorentzian_encoding_identity.sage`,
`code/referee_round4_setup_determinantal_check.sage`); here they are checked by
Lean, over an arbitrary commutative ring.

Chosen because they are **easy**, not because they are the deepest thing left
unformalized.  They happen also to be foundational: `enc_commutator` is the
identity the entire article is built on — it is what turns the iterated
commutator into an iterated cross product, and so what makes `def-wk`'s
recursion mean anything.

## What is proved here, and one strengthening

* `enc_commutator` — `thm-basic-identity`.  **Stated for arbitrary `A`, `B`,
  with no traceless hypothesis**, which is stronger than the article's version
  and simpler to state.  The article assumes traceless because that is the case
  it uses, but the hypothesis is not needed: `enc` already depends only on the
  traceless part (`A 0 0 - A 1 1` and the off-diagonal entries are unchanged by
  adding a scalar matrix), and `[A, B] = [A₀, B₀]` in any case.  The traceless
  statement is recovered as an immediate instance below.
* `lorentzian_enc` — the Sylvester/Killing computation of `rem-why-D`:
  `-enc₁² - enc₂² + enc₃² = 4 det A₀` for traceless `A₀`.  Here the traceless
  hypothesis *is* needed and is used.
* `Dm_det`, `Dm_involution`, `taum_det`, `taum_sq` — the arithmetic behind
  `rem-why-D`'s comparison of `D` against the naive reshuffle `τ`: `det D = 1`
  and `D² = 1`, versus `det τ = -2` and `τ² = diag(1,1,4)`.  These are what the
  remark's claim that `D` is invertible in *every* characteristic while `τ` is
  not rests on.

## Characteristic

None of this assumes anything about the characteristic — everything is over an
arbitrary `CommRing`.  That is deliberate and it is the point of `prob-char2`:
the article's standing `char F ≠ 2` is spent in Step 1, on splitting off the
trace, and *not* on this identity.  An explicit `ZMod 2` instance at the end of
the file pins that down, since it is the case the article excludes.
-/
import Mathlib.LinearAlgebra.CrossProduct
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.LinearCombination

open Matrix

namespace KCommuting

variable {R : Type*} [CommRing R]

/-- The signed encoding of a `2 × 2` matrix:
`enc A = (a₁₁ - a₂₂, a₁₂ + a₂₁, a₁₂ - a₂₁)`.

Note it is blind to the scalar part, so `enc A = enc A₀` for the traceless
remainder `A₀` — which is why `enc_commutator` needs no traceless hypothesis. -/
def enc (A : Matrix (Fin 2) (Fin 2) R) : Fin 3 → R :=
  ![A 0 0 - A 1 1, A 0 1 + A 1 0, A 0 1 - A 1 0]

/-- The sign twist `diag(-1, -1, 1)`, acting on a vector. -/
def Dv (u : Fin 3 → R) : Fin 3 → R := ![-u 0, -u 1, u 2]

/-- **`thm-basic-identity`.**  The encoded commutator is the twisted cross
product of the encodings:
`enc [A, B] = D (enc A ⨯₃ enc B)`.

No traceless hypothesis, and no hypothesis on the characteristic. -/
theorem enc_commutator (A B : Matrix (Fin 2) (Fin 2) R) :
    enc (A * B - B * A) = Dv (enc A ⨯₃ enc B) := by
  funext j
  fin_cases j <;>
    simp [enc, Dv, cross_apply, Matrix.mul_apply, Fin.sum_univ_two] <;> ring

/-- The article's form of the identity, for traceless matrices, as an instance
of the general one.  The hypotheses are unused; that is the content. -/
theorem enc_commutator_traceless (A B : Matrix (Fin 2) (Fin 2) R)
    (_hA : Matrix.trace A = 0) (_hB : Matrix.trace B = 0) :
    enc (A * B - B * A) = Dv (enc A ⨯₃ enc B) :=
  enc_commutator A B

/-- **The Sylvester / Killing computation of `rem-why-D`.**  For traceless `A`,
`-enc₁² - enc₂² + enc₃² = 4 det A`, so `D`'s sign pattern is the signature of
`det` read off in these coordinates, not a bookkeeping accident.

Unlike `enc_commutator`, this one genuinely needs `trace A = 0`. -/
theorem lorentzian_enc (A : Matrix (Fin 2) (Fin 2) R) (hA : Matrix.trace A = 0) :
    -(enc A 0) ^ 2 - (enc A 1) ^ 2 + (enc A 2) ^ 2 = 4 * A.det := by
  have h : A 1 1 = -A 0 0 := by
    have h0 := hA
    simp [Matrix.trace_fin_two] at h0
    -- `linarith` is unavailable here: `R` is an arbitrary `CommRing`, not ordered.
    linear_combination h0
  simp [enc, Matrix.det_fin_two, h]
  ring

/-! ### The twist arithmetic behind `rem-why-D`

`D` against the naive reshuffle `τ(a,b,c) = (b,a,2c)` that the encoding
`red(A) = (a₁₂, a₂₁, d_a)` forces. -/

/-- The sign twist as a matrix. -/
def Dm : Matrix (Fin 3) (Fin 3) R := !![-1, 0, 0; 0, -1, 0; 0, 0, 1]

/-- The naive reshuffle `τ(a,b,c) = (b,a,2c)` as a matrix. -/
def taum : Matrix (Fin 3) (Fin 3) R := !![0, 1, 0; 1, 0, 0; 0, 0, 2]

/-- `det D = 1`, so `D` is invertible over *every* commutative ring — in
particular in characteristic 2, where `τ` is not. -/
theorem Dm_det : (Dm : Matrix (Fin 3) (Fin 3) R).det = 1 := by
  simp [Dm, Matrix.det_fin_three]

/-- `D` is an involution. -/
theorem Dm_involution : (Dm : Matrix (Fin 3) (Fin 3) R) * Dm = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Dm, Matrix.mul_apply, Fin.sum_univ_three]

/-- `det τ = -2`.  This is the whole reason `τ` fails in characteristic 2 and
`D` does not. -/
theorem taum_det : (taum : Matrix (Fin 3) (Fin 3) R).det = -2 := by
  simp [taum, Matrix.det_fin_three]

/-- `τ² = diag(1,1,4) ≠ 1`: `τ` is not an involution. -/
theorem taum_sq : (taum : Matrix (Fin 3) (Fin 3) R) * taum = !![1, 0, 0; 0, 1, 0; 0, 0, 4] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [taum, Matrix.mul_apply, Fin.sum_univ_three] <;> norm_num

/-! ### Characteristic 2

`prob-char2` argues that the obstruction in characteristic 2 lives in the
*setup* — the trace splitting — and not in the identity or the ideal.  The
instance below is the identity half of that claim, machine-checked in the one
characteristic the article excludes. -/

/-- The basic identity holds over `ZMod 2`. -/
example (A B : Matrix (Fin 2) (Fin 2) (ZMod 2)) :
    enc (A * B - B * A) = Dv (enc A ⨯₃ enc B) := enc_commutator A B

/-! ### A concrete instance, to pin the conventions

`enc_commutator` is an equation between two *definitions*.  If `enc` or `Dv` had
a sign or an index wrong, the theorem would very likely still be provable — it
would simply be about a different object, and nothing above would notice.  The
example below is computed by hand from the article's own definitions and then
checked, which is what makes it a test of the conventions rather than of Lean.

With `A = ![[0,1],[0,0]]` and `B = ![[0,0],[1,0]]`:
`[A,B] = ![[1,0],[0,-1]]`, so `enc [A,B] = (2,0,0)`;
`enc A = (0,1,1)`, `enc B = (0,1,-1)`, their cross product is `(-2,0,0)`,
and `D (-2,0,0) = (2,0,0)`.  The two agree, and note the sign twist is doing
visible work — without `D` the right-hand side would be `(-2,0,0)`. -/
example :
    enc (R := ℤ) (!![0,1; 0,0] * !![0,0; 1,0] - !![0,0; 1,0] * !![0,1; 0,0]) = ![2, 0, 0] := by
  funext j
  fin_cases j <;> simp [enc, Matrix.mul_apply, Fin.sum_univ_two]

example :
    Dv (enc (R := ℤ) !![0,1; 0,0] ⨯₃ enc (R := ℤ) !![0,0; 1,0]) = ![2, 0, 0] := by
  funext j
  fin_cases j <;> simp [enc, Dv, cross_apply] <;> decide

/-- And `D` is still invertible there, while `τ` is not: `det τ = -2 = 0`. -/
example : (taum : Matrix (Fin 3) (Fin 3) (ZMod 2)).det = 0 := by
  rw [taum_det]; decide

example : (Dm : Matrix (Fin 3) (Fin 3) (ZMod 2)).det = 1 := Dm_det

end KCommuting
