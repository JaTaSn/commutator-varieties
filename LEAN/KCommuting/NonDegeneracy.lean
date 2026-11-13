/-
Copyright (c) 2026 Jan Snellman. All rights reserved.

# `lem-nondeg`: an explicit point where `w_j` does not vanish, and `prop-y2-not-in-y1`

The article's Lemma (non-degeneracy, with an explicit witness): for every
`j ≥ 2` the point

    p⁽ʲ⁾ := (e₁, e₂, e₁, …, e₁) ∈ 𝔸^(3j)

satisfies `w_j(p⁽ʲ⁾) = e₃` for `j` even and `e₂` for `j` odd.  Here `ptNd` is
that point with *every* later block also `e₁`, which changes nothing, since `w_j`
involves only blocks `< j` (`evalv_w_congr`).  In Lean's block numbering,
block `0` is `e₁`, block `1` is `e₂`, and every other block is `e₁`; and
`j = n + 2`, so "`j` even" is "`n` even".

Consequences proved here:

* `w_ne_zero`: `w_j` is not the zero vector of polynomials, for every `j ≥ 2`.
* `prop-y2-not-in-y1`, at the level of points: for every `k ≥ 3` there is a
  point of `V(I_k)` that lies on `Φ`'s image but not on `Y₁ = V(I_{k-1}) × 𝔸³` —
  namely `(p⁽ᵏ⁻¹⁾, 0)`.  The article states `Y₂ ⊄ Y₁` for the Zariski closure
  `Y₂` of `Φ`'s image; a point of the image itself is the content.
-/
import KCommuting.IteratedIdentity

open MvPolynomial Matrix

namespace KCommuting

variable {F : Type*} [Field F]

/-- The witness point: block `1` is `e₂`, every other block is `e₁`. -/
def ptNd : Fin 3 × ℕ → F := fun q =>
  if q.2 = 1 then (Pi.single 1 1 : Fin 3 → F) q.1 else (Pi.single 0 1 : Fin 3 → F) q.1

lemma evalv_v_ptNd_of_ne {i : ℕ} (hi : i ≠ 1) :
    evalv (ptNd (F := F)) (v i) = Pi.single 0 1 := by
  funext j; simp [ptNd, v, hi]

lemma evalv_v_ptNd_one : evalv (ptNd (F := F)) (v 1) = Pi.single 1 1 := by
  funext j; simp [ptNd, v]

/-- **`lem-nondeg`.**  `w (n+2)` at the witness is `e₃` for `n` even and `e₂` for
`n` odd. -/
theorem evalv_w_ptNd (n : ℕ) :
    evalv (ptNd (F := F)) (w (n + 2)) =
      if Even n then Pi.single 2 1 else Pi.single 1 1 := by
  induction n with
  | zero =>
    show evalv ptNd (v 0 ⨯₃ v 1) = _
    rw [evalv_cross, evalv_v_ptNd_of_ne (by decide), evalv_v_ptNd_one]
    funext j; fin_cases j <;> simp [cross_apply]
  | succ n ih =>
    show evalv ptNd (D (w (n + 2)) ⨯₃ v (n + 2)) = _
    rw [evalv_cross, evalv_D, ih, evalv_v_ptNd_of_ne (by omega)]
    by_cases h : Even n
    · have h' : ¬ Even (n + 1) := by rw [Nat.even_add_one]; exact not_not.2 h
      simp only [h, h', ↓reduceIte]
      funext j; fin_cases j <;> simp [Dv, cross_apply]
    · have h' : Even (n + 1) := by rw [Nat.even_add_one]; exact h
      simp only [h, h', ↓reduceIte]
      funext j; fin_cases j <;> simp [Dv, cross_apply]

/-- The witness value is never zero. -/
theorem evalv_w_ptNd_ne_zero (n : ℕ) : evalv (ptNd (F := F)) (w (n + 2)) ≠ 0 := by
  rw [evalv_w_ptNd]
  split_ifs
  · exact fun h => by simpa using congrFun h 2
  · exact fun h => by simpa using congrFun h 1

/-- `w_j` is not identically zero, for every `j ≥ 2`. -/
theorem w_ne_zero (n : ℕ) : (w (n + 2) : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ≠ 0 := by
  intro h
  apply evalv_w_ptNd_ne_zero (F := F) n
  rw [h, evalv_zero]

/-! ### `prop-y2-not-in-y1` -/

/-- The point `(p⁽ᵏ⁻¹⁾, 0)` for `k = n + 3`: the witness, with block `k - 1`
(Lean: `n + 2`) set to zero. -/
def ptY2 (n : ℕ) : Fin 3 × ℕ → F := fun q => if q.2 = n + 2 then 0 else ptNd q

/-- **`prop-y2-not-in-y1`, pointwise.**  For `k = n + 3`, the point `ptY2 n`
* lies on the image of `Φ`: its last block is `λ • D(w_{k-1})` at the point, with `λ = 0`;
* lies in `V(I_k)`;
* does **not** lie in `Y₁ = V(I_{k-1}) × 𝔸³`, since `w_{k-1}` does not vanish there. -/
theorem ptY2_mem_Y2_not_mem_Y1 (n : ℕ) :
    (fun j => ptY2 (F := F) n (j, n + 2)) = (0 : F) • Dv (evalv (ptY2 n) (w (n + 2))) ∧
    evalv (ptY2 (F := F) n) (w (n + 3)) = 0 ∧
    evalv (ptY2 (F := F) n) (w (n + 2)) ≠ 0 := by
  have hold : evalv (ptY2 (F := F) n) (w (n + 2)) = evalv ptNd (w (n + 2)) :=
    evalv_w_congr _ fun q hq => by simp [ptY2, Nat.ne_of_lt hq]
  refine ⟨?_, ?_, ?_⟩
  · funext j; simp [ptY2]
  · show evalv (ptY2 n) (D (w (n + 2)) ⨯₃ v (n + 2)) = 0
    have hv : evalv (ptY2 (F := F) n) (v (n + 2)) = 0 := by funext j; simp [ptY2, v]
    rw [evalv_cross, hv]
    funext j; fin_cases j <;> simp [cross_apply]
  · rw [hold]; exact evalv_w_ptNd_ne_zero n

end KCommuting
