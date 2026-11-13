/-
Copyright (c) 2026 Jan Snellman. All rights reserved.

# `thm-componentcount` over `F`, algebraically: the minimal primes of `I_k`

The article finds the components of `V(I_k)` geometrically, over `F̄`, with
Zariski closures and dimensions of images.  Here the same count is proved as a
statement about ideals, over the base field `F` itself and in any
characteristic:

    the minimal primes of I_k are exactly P₂, …, P_k     (`minimalPrimes_Ik`)

so there are `k - 1` of them (`ncard_minimalPrimes_Ik`), and
`√I_k = P₂ ∩ ⋯ ∩ P_k` (`radical_Ik`).  Through Mathlib's
`Ideal.minimalPrimes ↔ irreducibleComponents` dictionary this is the
set-theoretic half of `thm-componentcount` and `thm-primarydecomp`; what it does
not say is that `I_k` itself is radical, which needs `(S₁)` (Tier 2 of the
2026-11-12 working note).  `RZero.lean` proves `(R₀)`.

## The argument

Write `u` for the direction `dir n` (`v₁`, or `D(w_{k-1})`), so that
`w_k = u ⨯ v_k` (`w_eq_dir_cross`).  Three facts.

1. **Every prime `Q ⊇ I_k` contains some `P_j`** (`exists_P_le`), by induction
   on `k`.  If some `uᵢ ∉ Q`, then `Q ⊇ P_k`, because of the *saturation*
   `P_k ⊆ (I_k : uᵢ^∞)` (`exists_pow_mul_mem_Ik`): after inverting `uᵢ`, the
   minors `uᵢ v_j − u_j vᵢ` say `v_k ≡ (vᵢ/uᵢ)·u`, so modulo `I_k` every
   polynomial factors through `φ_k`.  If instead `u ⊆ Q`, then `Q ⊇ I_{k-1}`
   (as `D` only flips signs) and induction applies — except at `k = 2`, where
   `u = v₁ ⊆ Q` and there is no `I₁`.  That case is a degeneration
   (`P_zero_le`): `(0, b)` is the limit of the points `(t b, b)`, which lie on
   the line `v₂ = t⁻¹ v₁`.
2. **`I_k ⊆ P_j`** for `j ≤ k`: `Ik_le_P`, in `PrimeComponents.lean`.
3. **The `P_j` are pairwise incomparable** (`P_le_P_iff`), by explicit
   elements and explicit points over `F`:
   - for `i < j`, the components of `w_i` lie in `P_i` but not in `P_j`;
   - for `i < j`, the incidence form `v_{j-1} · D(v_j)` (`inc`) lies in `P_j`
     but not in `P_i`.

One lemma does all the work of getting into `P_j`'s kernel, three times over
(`aeval_eq_zero_of_mem_P`): a point whose block `j` is a multiple of the
direction at that point factors through `φ_j`, so it kills `P_j`.  It is used
with points in `Localization.Away uᵢ ⧸ I_k` (the saturation), in a localized
polynomial ring `F[…][t, t⁻¹]` (the degeneration) and in `F` (the separating
points).

No dimension theory, no closures, no base change from `F̄`: the descent remark
`rem-base-field` is not needed for this statement.

## Indexing

As in `PrimeComponents.lean`: `P n` is the article's `P_{n+2}`, with new block
`n + 1` (the article's `v_{n+2}`), and `Ik (n + 2)` is the article's
`I_{n+2}`.  So `minimalPrimes_Ik n` is the statement for `k = n + 2`, and
`P '' Set.Iic n` is `{P₂, …, P_k}`.

## The ambient ring

Everything lives in the one ring `MvPolynomial (Fin 3 × ℕ) F`, whereas the
article's `I_k` lives in `R_k = F[v₁, …, v_k]`.  The ring here is a polynomial
ring over `R_k`, and minimal primes extend and contract bijectively along a
polynomial extension, so the two statements say the same thing.  That
standard transfer is not formalized here.
-/
import KCommuting.PrimeComponents
import KCommuting.NonDegeneracy
import Mathlib.RingTheory.Ideal.MinimalPrime.Basic
import Mathlib.RingTheory.Localization.Away.Basic
import Mathlib.RingTheory.Localization.Ideal

open MvPolynomial Matrix

namespace KCommuting

variable {F : Type*} [Field F]

/-! ### Points on the parametrization -/

/-- **Points on the parametrization kill `P m`.**  If block `m + 1` of `x` is `μ`
times the direction at `x`, then evaluation at `x` factors through `φ_m`, so it
vanishes on `P m = ker φ_m`.  The point may take values in any commutative
`F`-algebra. -/
theorem aeval_eq_zero_of_mem_P {K : Type*} [CommRing K] [Algebra F K] {m : ℕ}
    (x : Fin 3 × ℕ → K) (μ : K) (hx : ∀ j, x (j, m + 1) = μ * aeval x (dir (F := F) m j))
    {f : MvPolynomial (Fin 3 × ℕ) F} (hf : f ∈ P m) : aeval x f = 0 := by
  let y : Option (Fin 3 × ℕ) → K := fun o => o.elim μ x
  have hy : y ∘ some = x := rfl
  have hfac : (aeval x : MvPolynomial (Fin 3 × ℕ) F →ₐ[F] K) = (aeval y).comp (phi m) := by
    apply algHom_ext
    rintro ⟨j, i⟩
    by_cases hi : i = m + 1
    · subst hi
      simp [phi, aeval_rename, hy, hx, y]
    · simp [phi, hi, y]
  rw [hfac, AlgHom.comp_apply, (RingHom.mem_ker).1 hf, map_zero]

/-- The direction involves only blocks `≤ m`, so its value depends only on them. -/
lemma evalv_dir_congr {x y : Fin 3 × ℕ → F} (m : ℕ)
    (h : ∀ q : Fin 3 × ℕ, q.2 < m + 1 → x q = y q) :
    evalv x (dir m) = evalv y (dir m) := by
  funext i
  exact eval_congr_vars fun q hq => h q (vars_dir m i q hq)

/-- The `F`-point form: a point on the parametrization of `P m` at which `f` does
not vanish shows `f ∉ P m`. -/
theorem not_mem_P_of_eval {m : ℕ} (x : Fin 3 × ℕ → F) (μ : F)
    (hx : ∀ j, x (j, m + 1) = μ * eval x (dir m j)) {f : MvPolynomial (Fin 3 × ℕ) F}
    (hf : eval x f ≠ 0) : f ∉ P m := fun h => by
  have := aeval_eq_zero_of_mem_P (F := F) x μ (by simpa [coe_aeval_eq_eval] using hx) h
  exact hf (by simpa using this)

/-- The direction does not vanish at the witness point. -/
theorem evalv_dir_ptNd_ne_zero (m : ℕ) : evalv (ptNd (F := F)) (dir m) ≠ 0 := by
  cases m with
  | zero =>
    show evalv ptNd (v 0) ≠ 0
    rw [evalv_v_ptNd_of_ne (by decide)]
    exact fun h => by simpa using congrFun h 0
  | succ m =>
    show evalv ptNd (D (w (m + 2))) ≠ 0
    rw [evalv_D, Ne, Dv_eq_zero_iff]
    exact evalv_w_ptNd_ne_zero m

lemma exists_evalv_dir_ptNd_ne_zero (m : ℕ) : ∃ i, evalv (ptNd (F := F)) (dir m) i ≠ 0 := by
  by_contra hc
  push Not at hc
  exact evalv_dir_ptNd_ne_zero m (funext hc)

/-! ### The saturation `P_k ⊆ (I_k : uᵢ^∞)` -/

/-- The minor `uᵢ v_j − u_j vᵢ` lies in `I_k`. -/
lemma minor_mem_Ik (n : ℕ) (i j : Fin 3) :
    dir n i * X (j, n + 1) - dir n j * X (i, n + 1) ∈ Ik (F := F) (n + 2) := by
  have h : minor2 (dir (F := F) n) (v (n + 1)) i j ∈ minorIdeal (dir n) (v (n + 1)) :=
    Ideal.subset_span ⟨(i, j), rfl⟩
  rw [Ik, w_eq_dir_cross, span_cross_eq_minorIdeal]
  simpa [minor2_eq, v] using h

/-- **The saturation.**  Every element of `P_k` is brought into `I_k` by a power
of any one component `uᵢ` of the direction.  (When `uᵢ` happens to lie in `P_k`
this is empty, which is why `exists_P_le` and `RZero.lean` pick an `i` with
`uᵢ ∉ Q`.) -/
theorem exists_pow_mul_mem_Ik {n : ℕ} (i : Fin 3) {f : MvPolynomial (Fin 3 × ℕ) F}
    (hf : f ∈ P n) : ∃ N : ℕ, dir n i ^ N * f ∈ Ik (n + 2) := by
  set d := dir (F := F) n i with hd
  let S := Localization.Away d
  let J : Ideal S := (Ik (F := F) (n + 2)).map (algebraMap _ S)
  let g : MvPolynomial (Fin 3 × ℕ) F →ₐ[F] S ⧸ J :=
    (Ideal.Quotient.mkₐ F J).comp (IsScalarTower.toAlgHom F _ S)
  have hg : ∀ p, aeval (g ∘ X) p = g p := fun p => by rw [← aeval_unique]
  have hinv := IsLocalization.Away.mul_invSelf (S := S) d
  have key : g f = 0 := by
    rw [← hg]
    refine aeval_eq_zero_of_mem_P (g ∘ X)
      (g (X (i, n + 1)) * Ideal.Quotient.mk J (IsLocalization.Away.invSelf d)) (fun j => ?_) hf
    rw [hg]
    simp only [Function.comp_apply, g, AlgHom.comp_apply, Ideal.Quotient.mkₐ_eq_mk,
      IsScalarTower.coe_toAlgHom', ← map_mul]
    rw [Ideal.Quotient.eq]
    have hm : algebraMap _ S (d * X (j, n + 1) - dir (F := F) n j * X (i, n + 1)) ∈ J :=
      Ideal.mem_map_of_mem _ (minor_mem_Ik n i j)
    let A := algebraMap (MvPolynomial (Fin 3 × ℕ) F) S
    have : A (X (j, n + 1)) - A (X (i, n + 1)) * IsLocalization.Away.invSelf d * A (dir n j) =
        IsLocalization.Away.invSelf d * A (d * X (j, n + 1) - dir n j * X (i, n + 1)) := by
      rw [map_sub, map_mul, map_mul]
      linear_combination (-(A (X (j, n + 1)))) * hinv
    rw [this]
    exact Ideal.mul_mem_left _ _ hm
  have hJ : algebraMap _ S f ∈ J := by
    rw [← Ideal.Quotient.eq_zero_iff_mem]
    exact key
  obtain ⟨⟨⟨a, ha⟩, ⟨s, hs⟩⟩, h⟩ :=
    (IsLocalization.mem_map_algebraMap_iff (Submonoid.powers d) S).1 hJ
  rw [← map_mul, IsLocalization.eq_iff_exists (Submonoid.powers d) S] at h
  obtain ⟨⟨c, hc⟩, hcs⟩ := h
  obtain ⟨N₁, rfl⟩ := hc
  obtain ⟨N₂, rfl⟩ := hs
  refine ⟨N₁ + N₂, ?_⟩
  have e : d ^ (N₁ + N₂) * f = d ^ N₁ * (f * d ^ N₂) := by ring
  rw [e]
  simp only at hcs
  rw [hcs]
  exact Ideal.mul_mem_left _ _ ha

/-- A prime containing `I_k` and missing some `uᵢ` contains `P_k`. -/
theorem P_le_of_dir_not_mem {n : ℕ} {Q : Ideal (MvPolynomial (Fin 3 × ℕ) F)} [hQ : Q.IsPrime]
    (hI : Ik (n + 2) ≤ Q) (h : ∃ i, dir (F := F) n i ∉ Q) : P n ≤ Q := by
  obtain ⟨i, hi⟩ := h
  intro f hf
  obtain ⟨N, hN⟩ := exists_pow_mul_mem_Ik i hf
  exact (hQ.mem_or_mem (hI hN)).resolve_left fun h' => hi (hQ.mem_of_pow_mem N h')

/-! ### The degeneration at `k = 2` -/

/-- **`P₂ ⊆ (v₁)`.**  Any ideal containing the three coordinates of `v₁` contains
`P₂`.  The point `(0, b)` is the limit as `t → 0` of `(t b, b)`, which is on the
line `v₂ = t⁻¹ v₁`; algebraically, evaluate in `F[…][t]`, check the value is `0`
after inverting `t`, and set `t = 0`. -/
theorem P_zero_le {Q : Ideal (MvPolynomial (Fin 3 × ℕ) F)} (hQ : ∀ j, X (j, 0) ∈ Q) :
    P 0 ≤ Q := by
  intro f hf
  let T : MvPolynomial (Option (Fin 3 × ℕ)) F := X none
  let ρ : MvPolynomial (Fin 3 × ℕ) F →ₐ[F] MvPolynomial (Option (Fin 3 × ℕ)) F :=
    aeval fun q => if q.2 = 0 then T * X (some (q.1, 1)) else X (some q)
  let S := Localization.Away T
  have hρ : ρ f = 0 := by
    apply IsLocalization.injective S (M := Submonoid.powers T)
      (powers_le_nonZeroDivisors_of_noZeroDivisors (X_ne_zero _))
    rw [map_zero]
    let g : MvPolynomial (Fin 3 × ℕ) F →ₐ[F] S := (IsScalarTower.toAlgHom F _ S).comp ρ
    have hg : ∀ p, aeval (g ∘ X) p = g p := fun p => by rw [← aeval_unique]
    show g f = 0
    rw [← hg]
    refine aeval_eq_zero_of_mem_P (m := 0) (g ∘ X) (IsLocalization.Away.invSelf T)
      (fun j => ?_) hf
    rw [hg]
    have hinv := IsLocalization.Away.mul_invSelf (S := S) T
    show algebraMap _ S (ρ (X (j, 1))) = _ * algebraMap _ S (ρ (X (j, 0)))
    simp only [ρ, aeval_X]
    simp only [one_ne_zero, ↓reduceIte, map_mul]
    linear_combination
      (-(algebraMap (MvPolynomial (Option (Fin 3 × ℕ)) F) S (X (some (j, 1))))) * hinv
  let ε : MvPolynomial (Option (Fin 3 × ℕ)) F →ₐ[F] MvPolynomial (Fin 3 × ℕ) F ⧸ Q :=
    aeval fun o => o.elim 0 fun q => Ideal.Quotient.mk Q (X q)
  have hε : ε.comp ρ = Ideal.Quotient.mkₐ F Q := by
    apply algHom_ext
    rintro ⟨j, i⟩
    by_cases hi : i = 0
    · subst hi
      simp [ε, ρ, T, Ideal.Quotient.eq_zero_iff_mem.2 (hQ j)]
    · simp [ε, ρ, hi]
  rw [← Ideal.Quotient.eq_zero_iff_mem, ← Ideal.Quotient.mkₐ_eq_mk F, ← hε, AlgHom.comp_apply,
    hρ, map_zero]

/-! ### Every prime over `I_k` contains a `P_j` -/

/-- **Every prime `Q ⊇ I_k` contains some `P_j`, `2 ≤ j ≤ k`** (Lean: `k = n + 2`,
`j = m + 2`). -/
theorem exists_P_le (n : ℕ) {Q : Ideal (MvPolynomial (Fin 3 × ℕ) F)} [hQ : Q.IsPrime]
    (hI : Ik (n + 2) ≤ Q) : ∃ m ≤ n, P m ≤ Q := by
  induction n with
  | zero =>
    by_cases h : ∃ i, dir (F := F) 0 i ∉ Q
    · exact ⟨0, le_rfl, P_le_of_dir_not_mem hI h⟩
    · push Not at h
      exact ⟨0, le_rfl, P_zero_le fun j => h j⟩
  | succ n ih =>
    by_cases h : ∃ i, dir (F := F) (n + 1) i ∉ Q
    · exact ⟨n + 1, le_rfl, P_le_of_dir_not_mem hI h⟩
    · push Not at h
      have hI' : Ik (n + 2) ≤ Q := by
        rw [Ik, ← span_D, Ideal.span_le]
        rintro _ ⟨j, rfl⟩
        exact h j
      obtain ⟨m, hm, hP⟩ := ih hI'
      exact ⟨m, by omega, hP⟩

/-! ### The `P_j` are pairwise incomparable -/

/-- The incidence form `v_n · D(v_{n+1})` (article: `v_{j-1} · D(v_j)` with
`j = n + 2`). -/
noncomputable def inc (n : ℕ) : MvPolynomial (Fin 3 × ℕ) F := v n ⬝ᵥ D (v (n + 1))

/-- `inc` at a point. -/
lemma eval_inc (x : Fin 3 × ℕ → F) (n : ℕ) :
    eval x (inc n) = (fun j => x (j, n)) ⬝ᵥ Dv (fun j => x (j, n + 1)) := by
  simp [inc, dotProduct, Fin.sum_univ_three, D, Dv, v]

/-- **The incidence form lies in `P_j`**, `j ≥ 3`: on the parametrization,
`v_j = λ D(w_{j-1})`, so `v_{j-1} · D(v_j) = λ v_{j-1} · w_{j-1} = 0`. -/
theorem inc_mem_P (n : ℕ) : inc (F := F) (n + 1) ∈ P (n + 1) := by
  have h0 : (v (n + 1) : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) ⬝ᵥ w (n + 2) = 0 := by
    rw [w_eq_dir_cross]
    exact dot_cross_self _ _
  have h1 := congrArg (rename (some : Fin 3 × ℕ → Option (Fin 3 × ℕ)) (R := F)) h0
  simp only [dotProduct, Fin.sum_univ_three, map_add, map_mul, map_zero, v, rename_X] at h1
  have hn : n ≠ n + 1 := by omega
  rw [P, RingHom.mem_ker]
  simp only [inc, dotProduct, Fin.sum_univ_three, D, v, map_add, map_mul, map_neg, phi, aeval_X,
    dir, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two, Matrix.head_cons,
    Matrix.tail_cons, Nat.add_right_cancel_iff, hn, ↓reduceIte, map_neg]
  linear_combination (X none : MvPolynomial (Option (Fin 3 × ℕ)) F) * h1

/-- **The incidence form is not in the earlier `P_m`**: at a point on `P_m`'s
parametrization whose block `n + 1` is `D(eᵢ)` it takes the value `aᵢ ≠ 0`. -/
theorem inc_not_mem_P {m n : ℕ} (h : m < n) : inc (F := F) n ∉ P m := by
  set a := evalv (ptNd (F := F)) (dir m) with ha
  obtain ⟨i, hi⟩ := exists_evalv_dir_ptNd_ne_zero (F := F) m
  let x : Fin 3 × ℕ → F := fun q =>
    if q.2 = n + 1 then Dv (Pi.single i 1) q.1
    else if q.2 = m + 1 ∨ q.2 = n then a q.1 else ptNd q
  have hdir : evalv x (dir m) = a :=
    evalv_dir_congr m fun q hq => by
      have h1 : q.2 ≠ n + 1 := by omega
      have h2 : ¬ (q.2 = m + 1 ∨ q.2 = n) := by omega
      simp [x, h1, h2]
  refine not_mem_P_of_eval x 1 (fun j => ?_) ?_
  · have h1 : m ≠ n := by omega
    have := congrFun hdir j
    simp only [evalv_apply] at this
    simp [x, h1, this]
  · rw [eval_inc]
    have hn : (fun j => x (j, n)) = a := by funext j; simp [x]
    have hn1 : (fun j => x (j, n + 1)) = Dv (Pi.single i 1) := by funext j; simp [x]
    rw [hn, hn1, Dv_Dv, dotProduct_single, mul_one]
    exact hi

/-- For `n < m`, `P n ⊄ P m`: the components of `w (n + 2)` are in `P n`, and one
of them survives at the witness point with block `m + 1` set to zero. -/
theorem not_P_le_of_lt {n m : ℕ} (h : n < m) : ¬ P (F := F) n ≤ P m := by
  intro hle
  obtain ⟨j, hj⟩ : ∃ j, evalv (ptNd (F := F)) (w (n + 2)) j ≠ 0 := by
    by_contra hc
    push Not at hc
    exact evalv_w_ptNd_ne_zero n (funext hc)
  let x : Fin 3 × ℕ → F := fun q => if q.2 = m + 1 then 0 else ptNd q
  have hw : evalv x (w (n + 2)) = evalv ptNd (w (n + 2)) :=
    evalv_w_congr (n + 2) fun q hq => by
      have : q.2 ≠ m + 1 := by omega
      simp [x, this]
  have hmem : w (n + 2) j ∈ P (F := F) n := Ik_le_P le_rfl (Ideal.subset_span ⟨j, rfl⟩)
  refine not_mem_P_of_eval x 0 (fun i => by simp [x]) ?_ (hle hmem)
  have := congrFun hw j
  simp only [evalv_apply] at this
  rw [this]
  exact hj

/-- **The `P_j` are pairwise incomparable.** -/
theorem P_le_P_iff {n m : ℕ} : P (F := F) n ≤ P m ↔ n = m := by
  constructor
  · intro hle
    rcases lt_trichotomy n m with h | h | h
    · exact absurd hle (not_P_le_of_lt h)
    · exact h
    · obtain ⟨n, rfl⟩ : ∃ n', n = n' + 1 := ⟨n - 1, by omega⟩
      exact absurd (hle (inc_mem_P n)) (inc_not_mem_P h)
  · rintro rfl
    exact le_rfl

theorem P_injective : Function.Injective (P (F := F)) := fun _ _ h =>
  P_le_P_iff.1 h.le

/-! ### The minimal primes -/

/-- **`thm-componentcount`, algebraically, over `F`.**  The minimal primes of
`I_k` are exactly `P₂, …, P_k` (Lean: `k = n + 2`, and `P m` is `P_{m+2}`). -/
theorem minimalPrimes_Ik (n : ℕ) :
    (Ik (F := F) (n + 2)).minimalPrimes = P '' Set.Iic n := by
  ext Q
  constructor
  · intro hQ
    have : Q.IsPrime := hQ.1.1
    obtain ⟨m, hm, hP⟩ := exists_P_le n hQ.1.2
    exact ⟨m, hm, le_antisymm hP (hQ.2 ⟨P_isPrime m, Ik_le_P (by omega)⟩ hP)⟩
  · rintro ⟨m, hm, rfl⟩
    refine ⟨⟨P_isPrime m, Ik_le_P (by simpa using hm)⟩, fun Q' hQ' hle => ?_⟩
    have : Q'.IsPrime := hQ'.1
    obtain ⟨m', -, hP'⟩ := exists_P_le n hQ'.2
    obtain rfl := P_le_P_iff.1 (hP'.trans hle)
    exact hP'

/-- **`I_k` has exactly `k − 1` minimal primes.** -/
theorem ncard_minimalPrimes_Ik (n : ℕ) :
    (Ik (F := F) (n + 2)).minimalPrimes.ncard = n + 1 := by
  rw [minimalPrimes_Ik, Set.ncard_image_of_injective _ P_injective, ← Finset.coe_Iic,
    Set.ncard_coe_finset, Nat.card_Iic]

/-- **`√I_k = P₂ ∩ ⋯ ∩ P_k`.**  Set-theoretically, `V(I_k)` is the union of the
`V(P_j)`.  That `I_k` itself equals this intersection is `thm-radical`, which
needs `(S₁)` on top of this and `RZero.lean`. -/
theorem radical_Ik (n : ℕ) :
    (Ik (F := F) (n + 2)).radical = ⨅ m ∈ Set.Iic n, P m := by
  rw [← Ideal.sInf_minimalPrimes, minimalPrimes_Ik, sInf_image]

end KCommuting
