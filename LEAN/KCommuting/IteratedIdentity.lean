/-
Copyright (c) 2026 Jan Snellman. All rights reserved.

# The iterated basic identity: `w k` *is* the encoded iterated commutator

`BasicIdentity.lean` proves `thm-basic-identity` for **one** commutator, and
`Independence.lean` defines `w k` by the recursion of `def-wk`.  Until this file
nothing in Lean connected the two: `w k` was a polynomial vector defined by a
recursion that the article *says* encodes `[A₁, …, A_k]`, and that claim lived
in prose.

Here it is a theorem.  Write `icomm A k` for the left-normed iterated commutator
`[[…[A₀, A₁], …], A_{k-1}]` of a sequence of `2 × 2` matrices, and evaluate `w k`
at the point whose `i`-th block is `enc (A i)`.  Then

    enc (icomm A k) = D (w k evaluated at (enc A₀, …, enc A_{k-1}))      (k ≥ 2)

(`enc_icomm`).  And in characteristic `≠ 2`, where `enc` is injective on traceless
matrices, this becomes the statement the whole article rests on:

    icomm A k = 0  ↔  w k vanishes at (enc A₀, …, enc A_{k-1})

(`icomm_eq_zero_iff`) — so the zero locus of the ideal `I_k` in reduced
coordinates is exactly the locus of `k`-tuples whose iterated commutator vanishes.

## Stronger than the article in one respect

No traceless hypothesis on the `A i`.  The article restricts to traceless
matrices because those are its coordinates; but `enc` is blind to the scalar
part and every commutator is traceless, so the statement holds for arbitrary
`2 × 2` matrices, as `enc_commutator` already does for one step.

## Indexing

Blocks are numbered from `0` here, as everywhere in the Lean sources: the
article's `A₁, …, A_k` and `v₁, …, v_k` are `A 0, …, A (k-1)` and
`v 0, …, v (k-1)`.
-/
import KCommuting.Independence
import KCommuting.BasicIdentity

open MvPolynomial Matrix

namespace KCommuting

/-! ### Evaluating a vector of polynomials at a point -/

section Eval

variable {F : Type*} [Field F]

/-- Evaluate a vector of polynomials at a point `x : Fin 3 × ℕ → F`, where
`x (j, i)` is coordinate `j` of block `i`. -/
noncomputable def evalv (x : Fin 3 × ℕ → F) (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    Fin 3 → F :=
  fun i => eval x (u i)

@[simp] lemma evalv_apply (x : Fin 3 × ℕ → F) (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F)
    (i : Fin 3) : evalv x u i = eval x (u i) := rfl

@[simp] lemma evalv_zero (x : Fin 3 × ℕ → F) : evalv x 0 = 0 := by
  funext i; simp [evalv]

/-- Evaluation commutes with the cross product. -/
lemma evalv_cross (x : Fin 3 × ℕ → F) (a b : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    evalv x (a ⨯₃ b) = evalv x a ⨯₃ evalv x b := by
  funext i; fin_cases i <;> simp [evalv, cross_apply]

/-- Evaluation turns the polynomial twist `D` into the scalar twist `Dv`. -/
lemma evalv_D (x : Fin 3 × ℕ → F) (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    evalv x (D u) = Dv (evalv x u) := by
  funext i; fin_cases i <;> simp [evalv, D, Dv]

/-- Evaluating block `i` reads off that block of the point. -/
@[simp] lemma evalv_v (x : Fin 3 × ℕ → F) (i : ℕ) :
    evalv x (v i) = fun j => x (j, i) := by
  funext j; simp [evalv, v]

/-- A polynomial's value depends only on the coordinates of its own variables. -/
lemma eval_congr_vars {p : MvPolynomial (Fin 3 × ℕ) F} {x y : Fin 3 × ℕ → F}
    (h : ∀ q ∈ MvPolynomial.vars p, x q = y q) : eval x p = eval y p :=
  hom_congr_vars (by ext; simp) (fun q hq _ => by simp [h q hq]) rfl

/-- `w n` involves only blocks `< n` (`vars_w_subset`), so its value at a point
depends only on those blocks. -/
lemma evalv_w_congr {x y : Fin 3 × ℕ → F} (n : ℕ) (h : ∀ q : Fin 3 × ℕ, q.2 < n → x q = y q) :
    evalv x (w n) = evalv y (w n) := by
  funext i
  exact eval_congr_vars fun q hq => h q (vars_w_subset n i q hq)

end Eval

/-! ### The iterated commutator -/

section Iterated

variable {R : Type*} [CommRing R]

/-- The left-normed iterated commutator `[[…[A 0, A 1], …], A (k-1)]`.
`icomm A 1 = A 0` makes the recursion uniform; `icomm A 0` is junk. -/
def icomm (A : ℕ → Matrix (Fin 2) (Fin 2) R) : ℕ → Matrix (Fin 2) (Fin 2) R
  | 0 => 0
  | 1 => A 0
  | (n + 2) => icomm A (n + 1) * A (n + 1) - A (n + 1) * icomm A (n + 1)

example (A : ℕ → Matrix (Fin 2) (Fin 2) R) : icomm A 2 = A 0 * A 1 - A 1 * A 0 := rfl

/-- The scalar twist is an involution. -/
@[simp] lemma Dv_Dv (u : Fin 3 → R) : Dv (Dv u) = u := by
  funext j; fin_cases j <;> simp [Dv]

/-- The scalar twist kills only zero. -/
@[simp] lemma Dv_eq_zero_iff (u : Fin 3 → R) : Dv u = 0 ↔ u = 0 := by
  constructor
  · intro h; rw [← Dv_Dv u, h]; funext j; fin_cases j <;> simp [Dv]
  · rintro rfl; funext j; fin_cases j <;> simp [Dv]

/-- Every iterated commutator of length `≥ 2` is traceless. -/
lemma trace_icomm (A : ℕ → Matrix (Fin 2) (Fin 2) R) (n : ℕ) :
    (icomm A (n + 2)).trace = 0 := by
  simp [icomm, Matrix.trace_sub, Matrix.trace_mul_comm (icomm A (n + 1))]

end Iterated

/-! ### The theorem -/

variable {F : Type*} [Field F]

/-- The point of `F^(Fin 3 × ℕ)` whose `i`-th block is `enc (A i)`. -/
def encPt (A : ℕ → Matrix (Fin 2) (Fin 2) F) : Fin 3 × ℕ → F := fun p => enc (A p.2) p.1

@[simp] lemma evalv_v_encPt (A : ℕ → Matrix (Fin 2) (Fin 2) F) (i : ℕ) :
    evalv (encPt A) (v i) = enc (A i) := by
  funext j; simp [encPt, v]

/-- **The iterated basic identity.**  For every `k ≥ 2` (written `n + 2`), the
encoded iterated commutator is the twist of `w k` evaluated at the encodings.
No traceless hypothesis and no hypothesis on the characteristic. -/
theorem enc_icomm (A : ℕ → Matrix (Fin 2) (Fin 2) F) (n : ℕ) :
    enc (icomm A (n + 2)) = Dv (evalv (encPt A) (w (n + 2))) := by
  induction n with
  | zero =>
    show enc (A 0 * A 1 - A 1 * A 0) = Dv (evalv (encPt A) (v 0 ⨯₃ v 1))
    rw [enc_commutator, evalv_cross, evalv_v_encPt, evalv_v_encPt]
  | succ n ih =>
    show enc (icomm A (n + 2) * A (n + 2) - A (n + 2) * icomm A (n + 2)) =
      Dv (evalv (encPt A) (D (w (n + 2)) ⨯₃ v (n + 2)))
    rw [enc_commutator, ih, evalv_cross, evalv_D, evalv_v_encPt]

/-- In characteristic `≠ 2` the encoding is injective on traceless matrices.
This is where the article's standing hypothesis is spent, and only here. -/
theorem eq_zero_of_enc_eq_zero {C : Matrix (Fin 2) (Fin 2) F} (h2 : (2 : F) ≠ 0)
    (hC : C.trace = 0) (he : enc C = 0) : C = 0 := by
  have e0 := congrFun he 0
  have e1 := congrFun he 1
  have e2 := congrFun he 2
  simp [enc] at e0 e1 e2
  rw [Matrix.trace_fin_two] at hC
  have h00 : C 0 0 = 0 := by
    have : (2 : F) * C 0 0 = 0 := by linear_combination e0 + hC
    exact (mul_eq_zero.1 this).resolve_left h2
  have h01 : C 0 1 = 0 := by
    have : (2 : F) * C 0 1 = 0 := by linear_combination e1 + e2
    exact (mul_eq_zero.1 this).resolve_left h2
  have h10 : C 1 0 = 0 := by
    have : (2 : F) * C 1 0 = 0 := by linear_combination e1 - e2
    exact (mul_eq_zero.1 this).resolve_left h2
  have h11 : C 1 1 = 0 := by linear_combination hC - h00
  ext i j
  fin_cases i <;> fin_cases j <;> simp [h00, h01, h10, h11]

/-- **The vanishing locus of `I_k` is the `k`-commuting locus**, in reduced
coordinates: in characteristic `≠ 2`, the iterated commutator of `A 0, …, A (k-1)`
vanishes exactly when every component of `w k` vanishes at their encodings.

Arbitrary matrices, not only traceless ones. -/
theorem icomm_eq_zero_iff (A : ℕ → Matrix (Fin 2) (Fin 2) F) (h2 : (2 : F) ≠ 0) (n : ℕ) :
    icomm A (n + 2) = 0 ↔ evalv (encPt A) (w (n + 2)) = 0 := by
  rw [← Dv_eq_zero_iff, ← enc_icomm]
  constructor
  · rintro h; rw [h]; funext j; fin_cases j <;> simp [enc]
  · exact eq_zero_of_enc_eq_zero h2 (trace_icomm A n)

/-- The characteristic hypothesis is genuinely needed: over `ZMod 2` the scalar
matrix `1` is traceless with `enc 1 = 0`. -/
example : enc (1 : Matrix (Fin 2) (Fin 2) (ZMod 2)) = 0 ∧
    (1 : Matrix (Fin 2) (Fin 2) (ZMod 2)).trace = 0 := by
  refine ⟨?_, ?_⟩
  · funext j; fin_cases j <;> decide
  · decide

end KCommuting
