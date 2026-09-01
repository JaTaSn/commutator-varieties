/-
Copyright (c) 2026 Jan Snellman. All rights reserved.

# Orthogonality, the `Y₂` incidence conditions, and the kernel of `[u]ₓ`

The three items the 2026-08-31 survey in `README.md` listed as *"still easy, not
yet done"*.  As with `BasicIdentity.lean`, these were chosen for cheapness
rather than for depth — but two of them turn out to be load-bearing in places
the article words informally.

## What is here

* **Orthogonality.**  `w j` is a cross product, so it is orthogonal to both its
  factors.  mathlib supplies this outright (`dot_self_cross`, `dot_cross_self`);
  all that is needed is to specialise it to the recursion's two shapes.

* **The `Y₂` incidence conditions.**  This is the one worth having.  The article
  identifies two of the three generators of `P₃` as `v₁ · D(v₃)` and
  `v₂ · D(v₃)`, and explains that these are *consequences* of the
  proportionality `v₃ ∝ D(w₂)` rather than components of it — obtained by
  substituting and using `D² = 1` together with `w₂ ⊥ v₁, v₂`.  That reasoning
  was corrected during referee round 4, after the surrounding prose was found to
  be wrong about the very displays beside it.  `dot_D_smul_D` is that argument,
  and it is general in the parameter rather than special to `k = 3`.

* **`ker [u]ₓ = F·u`.**  Used in `lem-witness-new` to conclude that
  `[D(w_{k-1}(p))]ₓ` has rank 2, which is what makes the witness a *rank-2*
  witness and hence what `lem-jacobian-regularity` consumes.  The article states
  it as "a cross product vanishes exactly on linearly dependent pairs", which is
  true but is doing more work than it looks: over a field it needs `u ≠ 0` and a
  division.  mathlib's `crossProduct_ne_zero_iff_linearIndependent` carries most
  of the weight.
-/
import KCommuting.Independence

open Matrix

namespace KCommuting

variable {F : Type*} [Field F]

/-! ### `D` commutes with scalars -/

/-- `D` is linear, so it passes through a scalar. -/
lemma D_smul (c : MvPolynomial (Fin 3 × ℕ) F) (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) :
    D (c • u) = c • D u := by
  funext j
  fin_cases j <;> simp [D] <;> ring

/-! ### Orthogonality

`w j` is a cross product, hence orthogonal to both of its factors.  Two shapes,
matching the two branches of the recursion. -/

/-- `w 2 = v 0 ⨯₃ v 1` is orthogonal to `v 0`. -/
lemma dot_v_zero_w_two : (v 0 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ⬝ᵥ w 2 = 0 :=
  dot_self_cross _ _

/-- `w 2` is orthogonal to `v 1`. -/
lemma dot_v_one_w_two : (v 1 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ⬝ᵥ w 2 = 0 :=
  dot_cross_self _ _

/-- Each `w (n+3) = D (w (n+2)) ⨯₃ v (n+2)` is orthogonal to the twisted previous
term. -/
lemma dot_D_w_w_succ (n : ℕ) :
    (D (w (F := F) (n + 2))) ⬝ᵥ w (n + 3) = 0 :=
  dot_self_cross _ _

/-- …and to the fresh block it is crossed with. -/
lemma dot_v_w_succ (n : ℕ) :
    (v (n + 2) : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ⬝ᵥ w (n + 3) = 0 :=
  dot_cross_self _ _

/-! ### The `Y₂` incidence conditions

On `Y₂` at parameter `j` the fresh block is `v_j = λ · D(w_{j-1})`.  Anything
orthogonal to `w_{j-1}` is then orthogonal to `D(v_j)` — which is where the two
low-degree generators of `P_j` come from.  Note this is *not* the proportionality
condition itself (whose components are one degree higher); it is what
proportionality implies. -/

/-- **The incidence condition, in general.**  If `u ⊥ p`, then `u ⊥ D (λ • D p)`
for every `λ`.  Two applications of `D² = 1`, and nothing else. -/
lemma dot_D_smul_D {u p : Fin 3 → MvPolynomial (Fin 3 × ℕ) F}
    (c : MvPolynomial (Fin 3 × ℕ) F) (hu : u ⬝ᵥ p = 0) :
    u ⬝ᵥ D (c • D p) = 0 := by
  rw [D_smul, D_D, dotProduct_smul, hu, smul_zero]

/-- At parameter 3, with `v₃ = λ · D(w₂)`: the first of the two quadratic
generators of `P₃`, `v₁ · D(v₃) = 0`. -/
lemma incidence_v_zero (c : MvPolynomial (Fin 3 × ℕ) F) :
    (v 0 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ⬝ᵥ D (c • D (w 2)) = 0 :=
  dot_D_smul_D c dot_v_zero_w_two

/-- …and the second, `v₂ · D(v₃) = 0`. -/
lemma incidence_v_one (c : MvPolynomial (Fin 3 × ℕ) F) :
    (v 1 : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ⬝ᵥ D (c • D (w 2)) = 0 :=
  dot_D_smul_D c dot_v_one_w_two

/-- The same at every later parameter: the twisted previous term is orthogonal
to the new block, so it yields an incidence condition too. -/
lemma incidence_D_w (n : ℕ) (c : MvPolynomial (Fin 3 × ℕ) F) :
    (D (w (F := F) (n + 2))) ⬝ᵥ D (c • D (w (n + 3))) = 0 :=
  dot_D_smul_D c (dot_D_w_w_succ n)

/-! ### The kernel of `[u]ₓ`

`lem-witness-new` needs that `[u]ₓ` has rank 2 for `u ≠ 0`, which is exactly the
statement that its kernel is the line `F·u`.  Stated here over an arbitrary
field, since that is where the article uses it — the witness points have entries
in `F`, not in the polynomial ring. -/

/-- **`ker [u]ₓ = F·u`.**  For `u ≠ 0` in `F³`, the cross product with `u`
vanishes exactly on the multiples of `u`.

The forward direction is where the content is, and it needs a division: from
`u ⨯₃ x = 0` mathlib gives that `![u, x]` is linearly *dependent*, which names
`u` as a multiple of `x`; inverting that scalar is what turns it into the
statement wanted. -/
theorem cross_eq_zero_iff_smul {u x : Fin 3 → F} (hu : u ≠ 0) :
    u ⨯₃ x = 0 ↔ ∃ c : F, x = c • u := by
  constructor
  · intro h
    by_cases hx : x = 0
    · exact ⟨0, by simp [hx]⟩
    · have hni : ¬ LinearIndependent F ![u, x] := fun hli =>
        (crossProduct_ne_zero_iff_linearIndependent.2 hli) h
      rw [linearIndependent_fin2] at hni
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one, not_and_or, not_forall,
        not_not] at hni
      rcases hni with h0 | ⟨a, ha⟩
      · exact absurd h0 hx
      · have ha0 : a ≠ 0 := by
          rintro rfl
          rw [zero_smul] at ha
          exact hu ha.symm
        exact ⟨a⁻¹, by rw [← ha, smul_smul, inv_mul_cancel₀ ha0, one_smul]⟩
  · rintro ⟨c, rfl⟩
    funext j
    fin_cases j <;> simp <;> ring

/-- The kernel of `[u]ₓ`, as a set: exactly the line spanned by `u`. -/
theorem ker_cross_eq_span {u : Fin 3 → F} (hu : u ≠ 0) :
    {x : Fin 3 → F | u ⨯₃ x = 0} = Set.range (fun c : F => c • u) := by
  ext x
  simp only [Set.mem_setOf_eq, Set.mem_range]
  rw [cross_eq_zero_iff_smul hu]
  exact ⟨fun ⟨c, hc⟩ => ⟨c, hc.symm⟩, fun ⟨c, hc⟩ => ⟨c, hc.symm⟩⟩

/-! ### A sanity check on the hypothesis

`u ≠ 0` is not decoration: at `u = 0` the cross product vanishes identically, so
the kernel is everything rather than a line. -/

example : ({x : Fin 3 → F | (0 : Fin 3 → F) ⨯₃ x = 0}) = Set.univ := by
  ext x
  simp only [Set.mem_setOf_eq, Set.mem_univ, iff_true]
  funext j
  fin_cases j <;> simp

end KCommuting
