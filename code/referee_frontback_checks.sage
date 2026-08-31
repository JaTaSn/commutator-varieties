# Changelog (reverse chronological):
# 2026-08-31 - Claude (adversarial-referee round 5, front/back matter): created.
#
# Referee round 5 (front matter, Primary Decomposition Theorem section, back matter) checks.
# Context: thm-primarydecomp's proof attributes primality of EVERY P_j, j=2..k, to lem-y2-irred
# "applied at the appropriate parameter" -- but lem-y2-irred is stated only for k >= 3, so the
# j=2 component (P_2 = I_2, extended by free variables) is not covered by the cited lemma.
# [1]-[2] verify the FACT is nevertheless true (miscitation, not a false claim).
# [3] re-verifies I_3 = P_2 cap P_3 (the k=3 instance of the displayed decomposition).
# [4]-[5] probe the "over any field of characteristic != 2" claim of the abstract / PDT /
# Summary at a NON-algebraically-closed and a finite field (QQ is non-closed too, but GF(3)
# is the extreme case): the written proof identifies Min(I_k) with irreducible components of
# the rational-point set V(I_k), a Nullstellensatz-type step; these checks confirm the ideal-
# theoretic STATEMENT still holds there (so the gap is in the write-up's generality, not the
# theorem's truth at these fields).
#
# Output: runs/referee-frontback-checks.txt

import sys

def w_ideals(K, k):
    """Return (R_k, [w_2..w_k as vectors]) over field K, signed encoding D."""
    names = [f"v{i}_{j}" for i in range(1, k+1) for j in range(1, 4)]
    R = PolynomialRing(K, names)
    v = [vector(R, R.gens()[3*i:3*i+3]) for i in range(k)]
    D = diagonal_matrix(R, [-1, -1, 1])
    w = v[0].cross_product(v[1])
    ws = {2: w}
    for j in range(3, k+1):
        w = (D * w).cross_product(v[j-1])
        ws[j] = w
    return R, v, ws

print("[1] I_2 prime in R_2 over QQ (the j=2 case thm-primarydecomp needs, not covered by lem-y2-irred's k>=3 statement)")
R2, v2, ws2 = w_ideals(QQ, 2)
I2 = R2.ideal(list(ws2[2]))
print("    I_2.is_prime():", I2.is_prime())

print("[2] P_2 = I_2 extended to R_3 (v_3 free) still prime")
R3, v3, ws3 = w_ideals(QQ, 3)
P2 = R3.ideal([g for g in ws3[2]])
print("    P_2.is_prime() in R_3:", P2.is_prime())

print("[3] I_3 = P_2 cap P_3 over QQ (k=3 instance of the PDT display)")
I3 = R3.ideal(list(ws3[3]))
# P_3 = elimination ideal of the graph of Phi at k=3
Rl = PolynomialRing(QQ, [str(g) for g in R3.gens()] + ["lam"])
lam = Rl.gens()[-1]
vv = [vector(Rl, Rl.gens()[3*i:3*i+3]) for i in range(3)]
Dl = diagonal_matrix(Rl, [-1, -1, 1])
w2l = vv[0].cross_product(vv[1])
graph = Rl.ideal(list(vv[2] - lam * (Dl * w2l)))
P3 = graph.elimination_ideal([lam]).change_ring(R3)
print("    I_3 == P_2 cap P_3:", I3 == P2.intersection(P3))
print("    irredundant (neither P_j alone equals I_3):", I3 != P2 and I3 != P3)

for K, name in [(GF(3), "GF(3)"), (GF(5), "GF(5)")]:
    print(f"[4/5] over {name} (char != 2, NOT algebraically closed; finite): PDT statement at k=3,4")
    for k in (3, 4):
        R, v, ws = w_ideals(K, k)
        Ik = R.ideal(list(ws[k]))
        pd = Ik.primary_decomposition()
        rad = Ik.radical() == Ik
        dims = sorted(Q.dimension() for Q in pd)
        prime = all(Q.is_prime() for Q in pd)
        print(f"    k={k}: radical={rad}, #components={len(pd)} (expected {k-1}), "
              f"all prime={prime}, dims={dims} (expected all {3*k-2})")
