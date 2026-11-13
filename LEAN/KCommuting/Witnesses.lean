/-
Copyright (c) 2026 Jan Snellman. All rights reserved.

# `lem-witness-new` and `lem-witness-inherited`: rank-2 Jacobian witnesses

The radicality proof needs, on every component of `V(I_k)`, a point of `V(I_k)`
where the Jacobian `J_k` of `w_k` has rank `2`.  The article gets them from two
lemmas, both linear algebra over `F` on top of the Jacobian recursion
(`JacobianRecursion.lean`) and `ker [u]ₓ = F·u` (`CrossFacts.lean`):

* **`lem-witness-new`** — on the component new at level `k`: the point
  `(p⁽ᵏ⁻¹⁾, 0)`, i.e. the non-degeneracy witness with the last block zeroed.
  There `J_k = [ 0 | [D w_{k-1}(p)]ₓ ]`, of rank 2 because `D w_{k-1}(p) ≠ 0`.
  At `k = 2`, the point `(p, 0)` for any `p ≠ 0`.
* **`lem-witness-inherited`** — on a component inherited from level `k - 1`: given
  a rank-2 witness `q` there, the point `(q, eᵢ)` for a suitable `i`.  There
  `J_k = [ -[eᵢ]ₓ D J_{k-1}(q) | 0 ]`, and `i` is chosen with `eᵢ` outside the
  plane `D · im J_{k-1}(q)`, so that `[eᵢ]ₓ` is injective on it.

## How rank is stated

`J_k` has a column for every variable.  Blocks are indexed by `ℕ` here, so it is
not a `3 × 3k` matrix but a family of columns indexed by `Fin 3 × ℕ`; its rank is
the dimension of the span of its columns, `jacSpan k x`.  The columns for blocks
`≥ k` are zero (freshness), so this is the rank of the article's `3 × 3k` matrix.

## A lemma mathlib lacks

`vars_pderiv_subset`: differentiating a polynomial introduces no new variables.
Needed so that `J_{k-1}` evaluated at `(q, eᵢ)` is `J_{k-1}` evaluated at `q`.
-/
import KCommuting.JacobianRecursion
import KCommuting.CrossFacts
import KCommuting.NonDegeneracy
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

open MvPolynomial Matrix Module

namespace KCommuting

variable {F : Type*} [Field F]

/-! ### Differentiation introduces no new variables -/

lemma vars_pderiv_subset {σ : Type*} (i : σ) (p : MvPolynomial σ F) :
    MvPolynomial.vars (pderiv i p) ⊆ MvPolynomial.vars p := by
  classical
  conv_lhs => rw [p.as_sum, map_sum]
  refine (vars_sum_subset _ _).trans ?_
  intro x hx
  simp only [Finset.mem_biUnion] at hx
  obtain ⟨d, hd, hx⟩ := hx
  rw [pderiv_monomial] at hx
  by_cases h0 : coeff d p * d i = 0
  · rw [h0, monomial_zero, vars_0] at hx
    exact absurd hx (Finset.notMem_empty x)
  · rw [vars_monomial h0] at hx
    exact (mem_vars_iff_mem_support x).2 ⟨d, hd, Finsupp.support_tsub hx⟩

/-! ### Evaluation lemmas -/

@[simp] lemma evalv_neg (x : Fin 3 × ℕ → F) (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    evalv x (-u) = -evalv x u := by
  funext i; simp [evalv]

@[simp] lemma evalv_single (x : Fin 3 × ℕ → F) (j : Fin 3) :
    evalv x (Pi.single j 1 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) = Pi.single j 1 := by
  funext r; by_cases h : r = j <;> simp [evalv, h]

/-- A column of the Jacobian of a block of variables. -/
lemma pd_v (j : Fin 3) (m i : ℕ) :
    pd (F := F) (j, m) (v i) = if m = i then Pi.single j 1 else 0 := by
  split_ifs with h
  · subst h; exact pd_v_self j m
  · exact pd_v_of_ne j h

/-- Columns of a polynomial vector depend only on the coordinates of `w`'s blocks. -/
lemma evalv_pd_w_congr {x y : Fin 3 × ℕ → F} (n : ℕ) (z : Fin 3 × ℕ)
    (h : ∀ q : Fin 3 × ℕ, q.2 < n → x q = y q) :
    evalv x (pd z (w n)) = evalv y (pd z (w n)) := by
  funext i
  exact eval_congr_vars fun q hq => h q (vars_w_subset n i q (vars_pderiv_subset _ _ hq))

/-- The Jacobian recursion (`jac_recursion`), evaluated at a point. -/
lemma evalv_jac (x : Fin 3 × ℕ → F) (j : Fin 3) (m n : ℕ) :
    evalv x (pd (j, m) (w (n + 3))) =
      if m = n + 2 then Dv (evalv x (w (n + 2))) ⨯₃ Pi.single j 1
      else -(evalv x (v (n + 2)) ⨯₃ Dv (evalv x (pd (j, m) (w (n + 2))))) := by
  rw [jac_recursion]
  split_ifs <;> simp [evalv_cross, evalv_D]

/-! ### Rank -/

/-- The column space of the Jacobian of `w k` at `x`; its dimension is the rank. -/
noncomputable def jacSpan (k : ℕ) (x : Fin 3 × ℕ → F) : Submodule F (Fin 3 → F) :=
  Submodule.span F (Set.range fun z : Fin 3 × ℕ => evalv x (pd z (w k)))

/-- `ker [u]ₓ` as a submodule: the line through `u`. -/
lemma ker_crossProduct {u : Fin 3 → F} (hu : u ≠ 0) :
    LinearMap.ker (crossProduct u) = F ∙ u := by
  ext x
  rw [LinearMap.mem_ker, cross_eq_zero_iff_smul hu, Submodule.mem_span_singleton]
  exact ⟨fun ⟨c, hc⟩ => ⟨c, hc.symm⟩, fun ⟨c, hc⟩ => ⟨c, hc.symm⟩⟩

/-- **`[u]ₓ` has rank 2** for `u ≠ 0`. -/
lemma finrank_range_crossProduct {u : Fin 3 → F} (hu : u ≠ 0) :
    finrank F (LinearMap.range (crossProduct u)) = 2 := by
  have h := LinearMap.finrank_range_add_finrank_ker (crossProduct u)
  rw [ker_crossProduct hu, finrank_span_singleton hu, Module.finrank_fin_fun] at h
  omega

/-- The columns `u ⨯₃ eⱼ` of `[u]ₓ` span its range. -/
lemma span_cross_single (u : Fin 3 → F) :
    Submodule.span F (Set.range fun j : Fin 3 => u ⨯₃ (Pi.single j 1 : Fin 3 → F)) =
      LinearMap.range (crossProduct u) := by
  rw [LinearMap.range_eq_map, ← (Pi.basisFun F (Fin 3)).span_eq, Submodule.map_span,
    ← Set.range_comp]
  simp only [Function.comp_def, Pi.basisFun_apply]

/-- A Jacobian whose only nonzero columns are those of `[u]ₓ`, in block `c`, has
the column space of `[u]ₓ`. -/
lemma span_cols_eq {c : ℕ} {u : Fin 3 → F} {col : Fin 3 × ℕ → Fin 3 → F}
    (h : ∀ j m, col (j, m) = if m = c then u ⨯₃ Pi.single j 1 else 0) :
    Submodule.span F (Set.range col) = LinearMap.range (crossProduct u) := by
  rw [← span_cross_single]
  apply le_antisymm
  · rw [Submodule.span_le]
    rintro _ ⟨⟨j, m⟩, rfl⟩
    rw [h]
    split_ifs
    · exact Submodule.subset_span ⟨j, rfl⟩
    · exact Submodule.zero_mem _
  · rw [Submodule.span_le]
    rintro _ ⟨j, rfl⟩
    exact Submodule.subset_span ⟨(j, c), by simp [h]⟩

/-! ### `lem-witness-new` -/

/-- **`lem-witness-new`, the case `k = 2`.**  At `(p, 0)` with `p ≠ 0`, the point
lies in `V(I₂)` and `J₂` has rank 2. -/
theorem witness_two {p : Fin 3 → F} (hp : p ≠ 0) :
    let x : Fin 3 × ℕ → F := fun q => if q.2 = 0 then p q.1 else 0
    evalv x (w 2) = 0 ∧ finrank F (jacSpan 2 x) = 2 := by
  intro x
  have h0 : evalv x (v 0) = p := by funext j; simp [x, v]
  have h1 : evalv x (v 1) = 0 := by funext j; simp [x, v]
  refine ⟨?_, ?_⟩
  · show evalv x (v 0 ⨯₃ v 1) = 0
    rw [evalv_cross, h1]; funext j; fin_cases j <;> simp [cross_apply]
  · rw [jacSpan, span_cols_eq (c := 1) (u := p), finrank_range_crossProduct hp]
    intro j m
    show evalv x (pd (j, m) (v 0 ⨯₃ v 1)) = _
    rw [pd_cross]
    have hadd : ∀ a b : Fin 3 → MvPolynomial (Fin 3 × ℕ) F,
        evalv x (a + b) = evalv x a + evalv x b := by
      intro a b; funext i; simp [evalv]
    rw [hadd, evalv_cross, evalv_cross, h0, h1, pd_v, pd_v]
    split_ifs <;> funext i <;> fin_cases i <;> simp [cross_apply]

/-- **`lem-witness-new`, `k ≥ 3`** (written `n + 3`).  At `(p⁽ᵏ⁻¹⁾, 0)` the point
lies in `V(I_k)` and `J_k` has rank 2. -/
theorem witness_new (n : ℕ) :
    evalv (ptY2 (F := F) n) (w (n + 3)) = 0 ∧ finrank F (jacSpan (n + 3) (ptY2 (F := F) n)) = 2 := by
  obtain ⟨-, hzero, hne⟩ := ptY2_mem_Y2_not_mem_Y1 (F := F) n
  have hv : evalv (ptY2 (F := F) n) (v (n + 2)) = 0 := by funext j; simp [ptY2, v]
  refine ⟨hzero, ?_⟩
  have hu : Dv (evalv (ptY2 (F := F) n) (w (n + 2))) ≠ 0 := by
    rwa [Ne, Dv_eq_zero_iff]
  rw [jacSpan, span_cols_eq (c := n + 2) (u := Dv (evalv (ptY2 n) (w (n + 2)))),
    finrank_range_crossProduct hu]
  intro j m
  rw [evalv_jac, hv]
  split_ifs
  · rfl
  · funext i; fin_cases i <;> simp

/-! ### `lem-witness-inherited` -/

/-- The scalar twist as a linear map. -/
def DvL : (Fin 3 → F) →ₗ[F] (Fin 3 → F) where
  toFun := Dv
  map_add' a b := by funext i; fin_cases i <;> simp [Dv] <;> ring
  map_smul' c a := by funext i; fin_cases i <;> simp [Dv]

/-- The point `(q, eᵢ)`: block `n + 2` replaced by `eᵢ`. -/
def upd (n : ℕ) (x : Fin 3 × ℕ → F) (i : Fin 3) : Fin 3 × ℕ → F := fun q =>
  if q.2 = n + 2 then (Pi.single i 1 : Fin 3 → F) q.1 else x q

lemma Dv_single (i : Fin 3) :
    ∃ s : F, s ≠ 0 ∧ Dv (Pi.single i 1 : Fin 3 → F) = s • Pi.single i 1 := by
  fin_cases i
  · exact ⟨-1, by simp, by funext r; fin_cases r <;> simp [Dv]⟩
  · exact ⟨-1, by simp, by funext r; fin_cases r <;> simp [Dv]⟩
  · exact ⟨1, one_ne_zero, by funext r; fin_cases r <;> simp [Dv]⟩

/-- **`lem-witness-inherited`** (for `k = n + 3`).  If `x` lies in `V(I_{k-1})` with
`J_{k-1}` of rank 2 there, then for some `i` the point `(x, eᵢ)` — `x` with its
block `k - 1` replaced by `eᵢ`, all earlier blocks unchanged — lies in `V(I_k)`
with `J_k` of rank 2. -/
theorem witness_inherited (n : ℕ) (x : Fin 3 × ℕ → F) (hx : evalv x (w (n + 2)) = 0)
    (hr : finrank F (jacSpan (n + 2) x) = 2) :
    ∃ i : Fin 3, evalv (upd n x i) (w (n + 3)) = 0 ∧
      finrank F (jacSpan (n + 3) (upd n x i)) = 2 ∧
      ∀ q : Fin 3 × ℕ, q.2 ≠ n + 2 → upd n x i q = x q := by
  set W := jacSpan (n + 2) x with hW
  -- Some standard basis vector lies outside the plane `W`.
  obtain ⟨i, hi⟩ : ∃ i : Fin 3, (Pi.single i 1 : Fin 3 → F) ∉ W := by
    by_contra hall
    push Not at hall
    have htop : W = ⊤ := by
      rw [eq_top_iff, ← (Pi.basisFun F (Fin 3)).span_eq, Submodule.span_le]
      rintro _ ⟨j, rfl⟩
      simpa using hall j
    rw [htop, finrank_top, Module.finrank_fin_fun] at hr
    omega
  -- the earlier blocks are untouched
  have hagree : ∀ q : Fin 3 × ℕ, q.2 < n + 2 → upd n x i q = x q :=
    fun q hq => by simp [upd, Nat.ne_of_lt hq]
  have hw : evalv (upd n x i) (w (n + 2)) = 0 := by rw [evalv_w_congr _ hagree, hx]
  have hv : evalv (upd n x i) (v (n + 2)) = Pi.single i 1 := by funext j; simp [upd, v]
  refine ⟨i, ?_, ?_, fun q hq => by simp [upd, hq]⟩
  · show evalv (upd n x i) (D (w (n + 2)) ⨯₃ v (n + 2)) = 0
    rw [evalv_cross, evalv_D, hw]; funext j; fin_cases j <;> simp [Dv, cross_apply]
  · -- `L := -[eᵢ]ₓ ∘ D`, and every column of `J_k` at `(x, eᵢ)` is `L` of the
    -- corresponding column of `J_{k-1}` at `x`.
    let L : (Fin 3 → F) →ₗ[F] (Fin 3 → F) := -((crossProduct (Pi.single i 1)) ∘ₗ DvL)
    have hcol : ∀ z : Fin 3 × ℕ,
        evalv (upd n x i) (pd z (w (n + 3))) = L (evalv x (pd z (w (n + 2)))) := by
      rintro ⟨j, m⟩
      rw [evalv_jac, hv]
      split_ifs with hm
      · subst hm
        rw [hw, pd_w_self, evalv_zero, map_zero]
        funext r; fin_cases r <;> simp [Dv, cross_apply]
      · rw [evalv_pd_w_congr (n + 2) (j, m) hagree]
        rfl
    have hspan : jacSpan (n + 3) (upd n x i) = W.map L := by
      have hfun : (fun z : Fin 3 × ℕ => evalv (upd n x i) (pd z (w (n + 3)))) =
          ⇑L ∘ fun z : Fin 3 × ℕ => evalv x (pd z (w (n + 2))) := funext hcol
      rw [hW, jacSpan, jacSpan, Submodule.map_span, hfun, Set.range_comp]
    -- `L` is injective on `W`, since its kernel is the line through `D eᵢ = ±eᵢ`.
    have hinj : Function.Injective (L ∘ₗ W.subtype) := by
      rw [← LinearMap.ker_eq_bot, LinearMap.ker_eq_bot']
      rintro ⟨y, hyW⟩ hy
      have hLy : (Pi.single i 1 : Fin 3 → F) ⨯₃ Dv y = 0 := by
        have := hy
        simp only [LinearMap.coe_comp, Function.comp_apply, Submodule.coe_subtype,
          LinearMap.neg_apply, neg_eq_zero, L] at this
        exact this
      have hei : (Pi.single i 1 : Fin 3 → F) ≠ 0 := by
        intro h; simpa using congrFun h i
      obtain ⟨c, hc⟩ := (cross_eq_zero_iff_smul hei).1 hLy
      obtain ⟨s, hs, hDs⟩ := Dv_single (F := F) i
      have hyc : y = (c * s) • (Pi.single i 1 : Fin 3 → F) := by
        rw [← Dv_Dv y, hc]
        have : Dv (c • (Pi.single i 1 : Fin 3 → F)) = c • Dv (Pi.single i 1) :=
          (DvL (F := F)).map_smul c _
        rw [this, hDs, smul_smul]
      by_cases hcs : c * s = 0
      · ext1; simpa [hcs] using hyc
      · exfalso
        apply hi
        have : (Pi.single i 1 : Fin 3 → F) = (c * s)⁻¹ • y := by
          rw [hyc, smul_smul, inv_mul_cancel₀ hcs, one_smul]
        rw [this]
        exact W.smul_mem _ hyW
    rw [hspan, ← Submodule.range_subtype W, ← LinearMap.range_comp,
      LinearMap.finrank_range_of_inj hinj, hr]

/-- **The hypotheses of `witness_inherited` are satisfiable** — a regression test
against a vacuous statement.  The witness that `witness_new` produces on the new
component at level `k` feeds straight into `witness_inherited` at level `k + 1`,
which is exactly how `thm-radical`'s induction uses the two lemmas. -/
example (n : ℕ) : ∃ i : Fin 3,
    evalv (upd (n + 1) (ptY2 (F := F) n) i) (w (n + 4)) = 0 ∧
      finrank F (jacSpan (n + 4) (upd (n + 1) (ptY2 (F := F) n) i)) = 2 ∧
      ∀ q : Fin 3 × ℕ, q.2 ≠ n + 3 → upd (n + 1) (ptY2 (F := F) n) i q = ptY2 n q :=
  witness_inherited (n + 1) (ptY2 n) (witness_new n).1 (witness_new n).2

end KCommuting
