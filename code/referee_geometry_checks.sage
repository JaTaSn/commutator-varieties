# referee_geometry_checks.sage
#
# Changelog:
#   2026-08-31  Claude (adversarial referee, geometry/CM scope): created.
#
# Adversarial-referee verification for the manuscript sections
#   "The geometric structure of V(I_k)"  and  "Cohen-Macaulayness"
# of article/ring-of-k-commuting-2x2-matrices.typ, under the CURRENT signed
# encoding D = diag(-1,-1,1)  (w_2 = v1 x v2, w_j = D(w_{j-1}) x v_j).
#
# Checks performed (labels match the report):
#   [A] I_2's displayed generators (Example, k=2 case) vs. computed w_2.
#   [B] P_3's displayed generators (BOTH display sites) vs. an INDEPENDENT
#       characterisation: the displayed ideal is prime, has dim 3j-2, and
#       vanishes identically on the parametrisation v_j = lam*D(w_{j-1}) --
#       which forces it to equal I(Y_2) exactly.  Also cross-checked against
#       a fresh elimination computation.
#   [C] Same for P_4's displayed generators.
#   [D] Prose claims attached to those displays: which generators are linear
#       in the last block; whether the third generator involves v_3 / v_4;
#       whether the two bilinear generators are literally components of the
#       cross product v_3 x D(w_2) ("the proportionality condition").
#   [E] The explicit Y_2 point at k=3: w_2, D(w_2), v_3 values, and the
#       manuscript's "(0,0,2) x (0,0,2)" claim.
#   [F] dim(R_k/I_k) = 3k-2 for k=2..5 (Thm 19 + the dimension table).
#   [G] Minimal primes of I_k for k=3,4: count = k-1, all of dim 3k-2,
#       identified with {P_j} (elimination ideals, embedded), block support
#       "exactly the first j blocks" (Thm 23's statement).
#   [H] I_3 = P_2 \cap P_3 as IDEALS (Example 28's claim "matching
#       I_3 = P_2 inter P_3").
#   [I] Proposition 26's parametrisation at k=4: for j=2,3 the closure of
#       (p,lam,q) |-> (Phi_j(p,lam), q) has vanishing ideal equal to the
#       corresponding minimal prime of I_4.  (j=4 is [C].)
#   [J] lem-y2-irred's side claim: elimination ideal is prime at k=3,4.
#   [K] coefficient scan: every displayed generator has coefficients +-1 only.
#
# k=5 minimal primes are in referee_geometry_k5_minprimes.sage (slow, separate).
# Cohen-Macaulayness (pdim = 2) is in referee_geometry_pdim.m2 (Macaulay2).
#
# Output: runs/referee-geometry-checks.txt

import sys

FAIL = []

def report(label, ok, detail=""):
    tag = "PASS" if ok else "FAIL"
    if not ok:
        FAIL.append(label)
    print("[%s] %s  %s" % (tag, label, detail))

def ring(k, extra=()):
    names = ['v%d_%d' % (i, j) for i in range(1, k + 1) for j in range(1, 4)] + list(extra)
    return PolynomialRing(QQ, names)

def vecs(R, k):
    g = R.gens()
    return [vector(R, g[3 * i:3 * i + 3]) for i in range(k)]

def Dv(u):
    return vector(u.base_ring() if hasattr(u, 'base_ring') else u[0].parent(),
                  [-u[0], -u[1], u[2]])

def w_list(v, k):
    """w_2..w_k with the D-recursion; returns dict."""
    ws = {2: v[0].cross_product(v[1])}
    for j in range(3, k + 1):
        ws[j] = Dv(ws[j - 1]).cross_product(v[j - 1])
    return ws

def sub_blocks(f, R, k):
    """Map polynomial in v-variables of R_small into R (matching names)."""
    return R(str(f))

# --------------------------------------------------------------------------
# The manuscript's displayed generators, transcribed from the .typ source.
# (v%d_%d here = v_(i,c) in the article.)
def displayed(Rstr):
    R = Rstr
    v = {(i, c): R('v%d_%d' % (i, c)) for i in range(1, 5) for c in range(1, 4)
         if 'v%d_%d' % (i, c) in [str(g) for g in R.gens()]}
    return v

print("=" * 78)
print("referee_geometry_checks.sage -- all checks under D = diag(-1,-1,1)")
print("=" * 78)

# ---- [A] I_2 display -------------------------------------------------------
R2 = ring(2)
v2 = vecs(R2, 2)
w2 = w_list(v2, 2)[2]
d = displayed(R2)
I2_displayed = [d[1,2]*d[2,3] - d[1,3]*d[2,2],
                d[1,3]*d[2,1] - d[1,1]*d[2,3],
                d[1,1]*d[2,2] - d[1,2]*d[2,1]]
ok = sorted([str(x) for x in I2_displayed]) == sorted([str(x) for x in w2]) or \
     R2.ideal(I2_displayed) == R2.ideal(list(w2)) and \
     all(any(x == y or x == -y for y in w2) for x in I2_displayed)
report("A: I_2 displayed gens = components of w_2 (up to sign)", ok,
       str([ [x == y or x == -y for y in w2] for x in I2_displayed ]))

# ---- displayed P_3 (two sites -- transcribed independently) ---------------
R3 = ring(3)
d = displayed(R3)
P3_site1 = [  # lines ~795-798
    d[2,1]*d[3,1] + d[2,2]*d[3,2] - d[2,3]*d[3,3],
    d[1,1]*d[3,1] + d[1,2]*d[3,2] - d[1,3]*d[3,3],
    d[1,2]*d[2,1]*d[3,2] - d[1,1]*d[2,2]*d[3,2] - d[1,3]*d[2,1]*d[3,3] + d[1,1]*d[2,3]*d[3,3]]
P3_site2 = [  # lines ~1003-1006
    d[2,1]*d[3,1] + d[2,2]*d[3,2] - d[2,3]*d[3,3],
    d[1,1]*d[3,1] + d[1,2]*d[3,2] - d[1,3]*d[3,3],
    d[1,2]*d[2,1]*d[3,2] - d[1,1]*d[2,2]*d[3,2] - d[1,3]*d[2,1]*d[3,3] + d[1,1]*d[2,3]*d[3,3]]
report("B0: the two P_3 display sites agree verbatim",
       [str(x) for x in P3_site1] == [str(x) for x in P3_site2])

R4 = ring(4)
d4 = displayed(R4)
P4_displayed = [  # lines ~806-812
    d4[3,1]*d4[4,1] + d4[3,2]*d4[4,2] - d4[3,3]*d4[4,3],
    d4[1,3]*d4[2,2]*d4[4,1] - d4[1,2]*d4[2,3]*d4[4,1] - d4[1,3]*d4[2,1]*d4[4,2]
      + d4[1,1]*d4[2,3]*d4[4,2] + d4[1,2]*d4[2,1]*d4[4,3] - d4[1,1]*d4[2,2]*d4[4,3],
    d4[1,3]*d4[2,1]*d4[3,1]*d4[4,2] - d4[1,1]*d4[2,3]*d4[3,1]*d4[4,2]
      + d4[1,3]*d4[2,2]*d4[3,2]*d4[4,2] - d4[1,2]*d4[2,3]*d4[3,2]*d4[4,2]
      - d4[1,2]*d4[2,1]*d4[3,1]*d4[4,3] + d4[1,1]*d4[2,2]*d4[3,1]*d4[4,3]
      - d4[1,3]*d4[2,2]*d4[3,3]*d4[4,3] + d4[1,2]*d4[2,3]*d4[3,3]*d4[4,3]]

# ---- [B]/[C] independent verification that displayed P_j = I(Y_2 at j) ----
def verify_Pj(j, gens_displayed, label):
    Rj = ring(j)
    A = Rj.ideal([Rj(str(g)) for g in gens_displayed])
    # (1) vanish on the parametrisation v_j := lam * D(w_{j-1}(p))
    S = ring(j - 1, extra=('lam',))
    lam = S('lam')
    vS = vecs(S, j - 1)
    wS = w_list(vS, j - 1)[j - 1] if j - 1 >= 2 else None
    vj_par = lam * Dv(wS)
    subs_map = {}
    for i in range(1, j):
        for c in range(1, 4):
            subs_map['v%d_%d' % (i, c)] = S('v%d_%d' % (i, c))
    for c in range(1, 4):
        subs_map['v%d_%d' % (j, c)] = vj_par[c - 1]
    vanish = all(g.subs({Rj(k_): val for k_, val in subs_map.items()}) == 0
                 for g in A.gens())
    # (2) prime
    prime = A.is_prime()
    # (3) dimension 3j-2
    dim_ok = (A.dimension() == 3 * j - 2)
    # (1)+(2)+(3) ==> A = I(Y_2):  A \subseteq I(Y_2) by (1) (Y_2 is the closure
    # of the parametrised set, so vanishing on the parametrisation = vanishing
    # on Y_2);  hence V(A) \supseteq Y_2;  both irreducible (A prime, Y_2 irred)
    # of the same dimension 3j-2  ==>  V(A) = Y_2;  A prime = radical ==> A = I(Y_2).
    report("%s: displayed gens vanish on parametrisation" % label, vanish)
    report("%s: displayed ideal is prime" % label, prime)
    report("%s: displayed ideal has dim 3j-2 = %d" % (label, 3 * j - 2), dim_ok,
           "got %s" % A.dimension())
    # (4) cross-check: fresh elimination
    T = ring(j, extra=('lam',))
    lamT = T('lam')
    vT = vecs(T, j)
    wT = w_list(vT, j - 1)[j - 1]
    graph = T.ideal([vT[j - 1][c] - lamT * Dv(wT)[c] for c in range(3)])
    elim = graph.elimination_ideal([lamT])
    Aelim = Rj.ideal([Rj(str(g)) for g in elim.gens()])
    report("%s: displayed ideal == elimination ideal" % label, A == Aelim)
    return A

P3 = verify_Pj(3, P3_site1, "B")
P4 = verify_Pj(4, P4_displayed, "C")

# ---- [D] prose claims about the displayed generators ----------------------
# k=3 prose: "two of the three generators are linear in v_3 (exactly the two
# components of the proportionality condition v_3 prop D(w_2)), and only the
# third, not involving v_3 at all, carries the full complexity of D(w_2)."
v3vars = [R3('v3_%d' % c) for c in range(1, 4)]
lin_in_v3 = [all(g.degree(x) <= 1 for x in v3vars) and
             max(sum(m.degree(x) for x in v3vars) for m in g.monomials()) <= 1
             for g in P3_site1]
involves_v3 = [any(g.degree(x) > 0 for x in v3vars) for g in P3_site1]
print("    k=3 displayed gens: linear-in-v3 flags =", lin_in_v3,
      "; involves-v3 flags =", involves_v3)
report("D1: PROSE 'the third generator does not involve v_3'  (manuscript claim)",
       involves_v3[2] == False, "third gen involves v_3: %s" % involves_v3[2])
# are the two bilinear gens components of v_3 x D(w_2)?
w2_in_R3 = w_list(vecs(R3, 3), 2)[2]
cross = vecs(R3, 3)[2].cross_product(Dv(w2_in_R3))
comp_match = [any(g == c or g == -c for c in cross) for g in P3_site1[:2]]
report("D2: PROSE 'the two linear gens are exactly two components of v_3 x D(w_2)'",
       all(comp_match), "component-of-cross-product flags: %s" % comp_match)
# k=4 prose: "two of the three generators are linear in v_4 and the third is not"
v4vars = [R4('v4_%d' % c) for c in range(1, 4)]
lin_in_v4 = [max(sum(m.degree(x) for x in v4vars) for m in g.monomials()) <= 1
             for g in P4_displayed]
report("D3: PROSE 'the third k=4 generator is NOT linear in v_4'",
       lin_in_v4[2] == False, "linear-in-v4 flags: %s" % lin_in_v4)

# ---- [E] the explicit point ------------------------------------------------
p_w2 = w2.subs({R2('v1_1'): 1, R2('v1_2'): 0, R2('v1_3'): 0,
                R2('v2_1'): 0, R2('v2_2'): 1, R2('v2_3'): 0})
p_w2 = vector(QQ, [w2[i].subs({R2('v1_1'): 1, R2('v1_2'): 0, R2('v1_3'): 0,
                               R2('v2_1'): 0, R2('v2_2'): 1, R2('v2_3'): 0})
                   for i in range(3)])
report("E1: w_2(e1,e2) = (0,0,1)", p_w2 == vector(QQ, [0, 0, 1]), str(p_w2))
Dp = vector(QQ, [-p_w2[0], -p_w2[1], p_w2[2]])
report("E2: D(w_2)(e1,e2) = (0,0,1)  [manuscript line 952: correct]",
       Dp == vector(QQ, [0, 0, 1]), str(Dp))
report("E3: MANUSCRIPT line 954 says w_3 = (0,0,2) x (0,0,2); true value is (0,0,1) x (0,0,1)",
       Dp == vector(QQ, [0, 0, 2]),  # deliberately: PASS would mean article right
       "D(w_2)=%s, v_3=lambda*D(w_2)=%s at lambda=1; (0,0,2) is the tau-era value" % (Dp, Dp))
pt = {R3('v1_1'): 1, R3('v1_2'): 0, R3('v1_3'): 0,
      R3('v2_1'): 0, R3('v2_2'): 1, R3('v2_3'): 0,
      R3('v3_1'): 0, R3('v3_2'): 0, R3('v3_3'): 1}
w3 = w_list(vecs(R3, 3), 3)[3]
report("E4: the point ((1,0,0),(0,1,0),(0,0,1)) lies in V(I_3)",
       all(w3[i].subs(pt) == 0 for i in range(3)))

# ---- [F] dimensions --------------------------------------------------------
for k in range(2, 6):
    Rk = ring(k)
    wk = w_list(vecs(Rk, k), k)[k]
    Ik = Rk.ideal(list(wk))
    dk = Ik.dimension()
    report("F: dim(R_%d/I_%d) = %d  (expect %d)" % (k, k, dk, 3 * k - 2),
           dk == 3 * k - 2)

# ---- [G] minimal primes at k=3,4 ------------------------------------------
def Pj_in_Rk(j, Rk):
    """P_j (elimination ideal at parameter j) embedded in R_k."""
    T = ring(j, extra=('lam',))
    lamT = T('lam')
    vT = vecs(T, j)
    if j == 2:
        # base convention: Y_2 at k=2 is V(I_2) itself
        R2l = ring(2)
        w = w_list(vecs(R2l, 2), 2)[2]
        return Rk.ideal([Rk(str(g)) for g in w])
    wT = w_list(vT, j - 1)[j - 1]
    graph = T.ideal([vT[j - 1][c] - lamT * Dv(wT)[c] for c in range(3)])
    elim = graph.elimination_ideal([lamT])
    return Rk.ideal([Rk(str(g)) for g in elim.gens()])

for k in (3, 4):
    Rk = ring(k)
    wk = w_list(vecs(Rk, k), k)[k]
    Ik = Rk.ideal(list(wk))
    mp = Ik.minimal_associated_primes()
    report("G: I_%d has exactly %d minimal primes (expect %d)" % (k, len(mp), k - 1),
           len(mp) == k - 1)
    dims_ok = all(P.dimension() == 3 * k - 2 for P in mp)
    report("G: all minimal primes of I_%d have dim %d" % (k, 3 * k - 2), dims_ok,
           str([P.dimension() for P in mp]))
    expected = [Pj_in_Rk(j, Rk) for j in range(2, k + 1)]
    match = all(any(P == E for P in mp) for E in expected) and len(mp) == len(expected)
    report("G: minimal primes of I_%d = {P_2..P_%d} as ideals" % (k, k), match)
    # block-support claim of Thm 23: P_j involves exactly blocks 1..j
    for j, E in zip(range(2, k + 1), expected):
        blocks_used = set()
        for g in E.gens():
            for x in g.variables():
                blocks_used.add(int(str(x).split('_')[0][1:]))
        report("G: P_%d (in R_%d) involves exactly blocks 1..%d" % (j, k, j),
               blocks_used == set(range(1, j + 1)), str(sorted(blocks_used)))

# ---- [H] I_3 = P_2 \cap P_3 ------------------------------------------------
R3b = ring(3)
w3b = w_list(vecs(R3b, 3), 3)[3]
I3 = R3b.ideal(list(w3b))
P2_in_R3 = Pj_in_Rk(2, R3b)
P3_in_R3 = Pj_in_Rk(3, R3b)
report("H: I_3 == P_2 \\cap P_3 as ideals (Example 28's claim)",
       I3 == P2_in_R3.intersection(P3_in_R3))

# ---- [I] Prop 26 parametrisations inside R_4 ------------------------------
# j=2: (p, lam, q) |-> (p, lam*p, q); j=3: (p, lam, q) |-> (p, lam*D(w_2(p)), q).
R4b = ring(4)
w4b = w_list(vecs(R4b, 4), 4)[4]
I4 = R4b.ideal(list(w4b))
mp4 = I4.minimal_associated_primes()
for j in (2, 3):
    T = ring(4, extra=('lam',))
    lamT = T('lam')
    vT = vecs(T, 4)
    if j == 2:
        target = vT[0]           # Phi_2(p,lam) = (p, lam*p)
    else:
        target = Dv(w_list(vT, 2)[2])   # Phi_3(p,lam) = (p, lam*D(w_2))
    graph = T.ideal([vT[j - 1][c] - lamT * target[c] for c in range(3)])
    elim = graph.elimination_ideal([lamT])
    A = R4b.ideal([R4b(str(g)) for g in elim.gens()])
    matches = [A == P for P in mp4]
    report("I: Prop 26 parametrisation at j=%d gives a minimal prime of I_4" % j,
           any(matches), "matches: %s" % matches)

# ---- [J] primality of elimination ideals (lem-y2-irred corroboration) ------
report("J: elimination ideal prime at k=3", P3.is_prime())
report("J: elimination ideal prime at k=4", P4.is_prime())

# ---- [K] coefficient scan of every displayed generator ---------------------
alldisp = I2_displayed + P3_site1 + P4_displayed
coeffs_ok = all(all(c in (1, -1) for c in g.coefficients()) for g in alldisp)
report("K: every displayed generator has coefficients +-1 only", coeffs_ok)

print()
print("=" * 78)
if FAIL:
    print("CHECKS NOT PASSING (n=%d):" % len(FAIL))
    for f in FAIL:
        print("   ", f)
else:
    print("ALL CHECKS PASS")
print("=" * 78)
