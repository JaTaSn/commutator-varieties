/-
Copyright (c) 2026 Jan Snellman. All rights reserved.

# `def-primecomponents`: the primes `P_j`, and `I_k ⊆ P_j`

The article defines, for `2 ≤ j ≤ k`, the polynomial map `Ψ_j` that keeps blocks
`1, …, j-1` free, sets block `j` to `λ` times the direction `D(w_{j-1})` (or `λ v₁`
at `j = 2`), and carries the later blocks along; read backwards it is an algebra
map `φ_j : R_k → F[p, λ, q]`, and `P_j := ker φ_j`.  It notes two consequences
"for free": each `P_j` is **prime**, being the kernel of a map into a domain, and
`P_j` does not depend on which `k ≥ j` it is viewed inside.

Both are immediate here.  The second is built in: there is one ambient ring
`MvPolynomial (Fin 3 × ℕ) F` for every `k`, and `φ` is defined on all of it.  The
target is `MvPolynomial (Option (Fin 3 × ℕ)) F`, with `none` playing `λ` and
`some q` the untouched variable `q`.

The one thing proved with any content is the containment the article uses
without comment when it says the `P_j` are the components *of `V(I_k)`*:

    I_k ⊆ P_j   for every 2 ≤ j ≤ k        (`Ik_le_P`)

At `k = j` this is "a vector crossed with a multiple of itself vanishes", once
one knows that `φ_j` leaves the direction alone — which is freshness again
(`vars_w_subset`), since the direction involves only blocks below `j`.  For
`k > j` it is induction: `w_{k+1} = D(w_k) ⨯ v_{k+1}` vanishes under `φ_j` once
`w_k` does.

## Indexing

`P n` is the article's `P_{n+2}`.  Its new block is Lean's block `n + 1` (the
article's `v_{n+2}`), and its direction `dir n` is `v 0` for `n = 0` and
`D (w (n+1))` otherwise, so that `w (n + 2) = dir n ⨯₃ v (n + 1)` for every `n`
(`w_eq_dir_cross`) — one formula covering both branches of the recursion.
-/
import KCommuting.Determinantal
import KCommuting.BasicIdentity

open MvPolynomial Matrix

namespace KCommuting

variable {F : Type*} [Field F]

/-! ### The direction, and one formula for `w` -/

/-- The direction the new block is proportional to on the component `P_{n+2}`:
`v₁` for the first component, `D(w_{n+1})` for the later ones. -/
noncomputable def dir : ℕ → Fin 3 → MvPolynomial (Fin 3 × ℕ) F
  | 0 => v 0
  | (n + 1) => D (w (n + 2))

/-- Both branches of the recursion for `w` at once. -/
lemma w_eq_dir_cross (n : ℕ) : (w (n + 2) : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) =
    dir n ⨯₃ v (n + 1) := by
  cases n <;> rfl

/-- The direction involves only blocks `≤ n`, so the new block `n + 1` is fresh
for it. -/
lemma vars_dir (n : ℕ) : ∀ i, ∀ q ∈ MvPolynomial.vars (dir (F := F) n i), q.2 < n + 1 := by
  cases n with
  | zero => exact vars_v_subset (S := {q : Fin 3 × ℕ | q.2 < 0 + 1}) 0 fun _ => by simp
  | succ n =>
    exact vars_D_subset (S := {q : Fin 3 × ℕ | q.2 < n + 1 + 1}) (vars_w_subset (n + 2))

/-! ### The map `φ` and the prime `P` -/

/-- The parametrization, read as an algebra map: block `n + 1` goes to
`λ • dir n` (with `λ = X none`), every other variable `q` to `X (some q)`. -/
noncomputable def phi (n : ℕ) :
    MvPolynomial (Fin 3 × ℕ) F →ₐ[F] MvPolynomial (Option (Fin 3 × ℕ)) F :=
  aeval fun q => if q.2 = n + 1 then X none * rename some (dir n q.1) else X (some q)

/-- **`def-primecomponents`.**  The article's `P_{n+2}`: the kernel of `φ`. -/
noncomputable def P (n : ℕ) : Ideal (MvPolynomial (Fin 3 × ℕ) F) :=
  RingHom.ker (phi (F := F) n)

/-- Each `P_j` is prime: the kernel of a map into a polynomial ring over a field,
which is a domain. -/
instance P_isPrime (n : ℕ) : (P (F := F) n).IsPrime :=
  RingHom.ker_isPrime _

/-- On a polynomial not involving block `n + 1`, `φ` is just the renaming. -/
lemma phi_eq_rename {n : ℕ} {p : MvPolynomial (Fin 3 × ℕ) F}
    (hp : ∀ q ∈ MvPolynomial.vars p, q.2 ≠ n + 1) : phi n p = rename some p := by
  show (phi n).toRingHom p = (rename some : _ →ₐ[F] _).toRingHom p
  refine hom_congr_vars ?_ (fun q hq _ => ?_) rfl
  · ext a; simp [phi]
  · simp [phi, hp q hq]

/-! ### Vectors under a ring hom -/

section MapVec

variable {R S : Type*} [CommRing R] [CommRing S]

/-- Apply a ring hom to each component. -/
def mapv (f : R →+* S) (u : Fin 3 → R) : Fin 3 → S := fun i => f (u i)

lemma mapv_cross (f : R →+* S) (a b : Fin 3 → R) :
    mapv f (a ⨯₃ b) = mapv f a ⨯₃ mapv f b := by
  funext i; fin_cases i <;> simp [mapv, cross_apply]

end MapVec

lemma mapv_D {S : Type*} [CommRing S] (f : MvPolynomial (Fin 3 × ℕ) F →+* S)
    (u : Fin 3 → MvPolynomial (Fin 3 × ℕ) F) : mapv f (D u) = Dv (mapv f u) := by
  funext i; fin_cases i <;> simp [mapv, D, Dv]

/-! ### `I_k ⊆ P_j` -/

/-- Under `φ_{n}`, the direction is untouched and the new block becomes `λ` times
it, so `w (n + 2) = dir n ⨯₃ v (n + 1)` goes to `d ⨯₃ (λ • d) = 0`. -/
theorem mapv_phi_w_self (n : ℕ) :
    mapv (phi (F := F) n).toRingHom (w (n + 2)) = 0 := by
  have hd : mapv (phi (F := F) n).toRingHom (dir n) =
      fun i => rename some (dir n i) := by
    funext i
    exact phi_eq_rename fun q hq => Nat.ne_of_lt (vars_dir n i q hq)
  have hv : mapv (phi (F := F) n).toRingHom (v (n + 1)) =
      fun i => X none * rename some (dir n i) := by
    funext i; simp [mapv, phi, v]
  rw [w_eq_dir_cross, mapv_cross, hd, hv]
  funext i; fin_cases i <;> simp [cross_apply] <;> ring

/-- Once `w k` vanishes under `φ`, so does `w (k + 1) = D (w k) ⨯₃ v k` (`k ≥ 2`). -/
theorem mapv_phi_w (n m : ℕ) :
    mapv (phi (F := F) n).toRingHom (w (n + 2 + m)) = 0 := by
  induction m with
  | zero => exact mapv_phi_w_self n
  | succ m ih =>
    -- `w`'s recursion is on the literal pattern `k + 3`, which `n + 2 + (m + 1)` is
    -- not, definitionally: `Nat.add` recurses on the variable `m`.
    rw [show n + 2 + (m + 1) = (n + m) + 3 by omega, show n + 2 + m = (n + m) + 2 by omega] at *
    show mapv (phi (F := F) n).toRingHom (D (w (n + m + 2)) ⨯₃ v (n + m + 2)) = 0
    rw [mapv_cross, mapv_D, ih]
    funext i; fin_cases i <;> simp [Dv, cross_apply]

/-- **`I_k ⊆ P_j` for every `2 ≤ j ≤ k`** (Lean: `j = n + 2`). -/
theorem Ik_le_P {n k : ℕ} (h : n + 2 ≤ k) : (Ik k : Ideal (MvPolynomial (Fin 3 × ℕ) F)) ≤ P n := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_add_of_le h
  rw [Ik, Ideal.span_le]
  rintro _ ⟨i, rfl⟩
  exact congrFun (mapv_phi_w n m) i

end KCommuting
