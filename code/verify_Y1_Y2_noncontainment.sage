# 2026-08-16 (Claude-Code-opus-subagent): close the "no containment either way" gap in Step 1 of
# working-notes/proof-plan-conjectures.org, computationally, at the k-1 -> k transition.
#
# Recall (Step 0 of the proof plan, now also proven by hand -- see Step 4 of that note):
#   w_2 = v_1 x v_2,   w_j = tau(w_{j-1}) x v_j,   tau(a,b,c) = (b,a,2c),
#   I_k = ideal of the three entries of w_k = ideal of 2x2 minors of [tau(w_{k-1}); v_k].
# Set-theoretically V(I_k) = Y_1 u Y_2 with
#   Y_1 = V(I_{k-1}) x A^3            (previous sub-bracket vanishes, v_k free)
#   Y_2 = closure of image of Phi(v_1..v_{k-1}, lam) = (v_1..v_{k-1}, lam*tau(w_{k-1})).
# This script, for each requested k:
#   (1) primary-decomposes I_{k-1} and I_k (Singular, via Sage) -- the "ground truth";
#   (2) computes I(Y_2) HONESTLY BY ELIMINATION of lam from the graph ideal of Phi
#       (no radical/primary-decomposition shortcut);
#   (3) checks exact ideal equality between I(Y_2) and the one "new" component of I_k, and
#       between the extended components of I_{k-1} and the remaining components of I_k;
#   (4) checks non-containment BOTH WAYS directly (J1 <= J2? J2 <= J1?) between I(Y_2) and each
#       piece of Y_1 -- deliberately NOT inferred from the primary decomposition finding them as
#       separate components (that would be circular).
#
# Usage: sage verify_Y1_Y2_noncontainment.sage [k ...]     (default: 4 5)

import sys

BLOCK = ['u', 'v', 'w', 'x', 'y', 'z']

# Pass "light" on the command line to skip the expensive-but-inessential extras
# (per-component radicality, I_k.radical(), the ideal intersections, J2.is_prime()).
# The load-bearing checks -- exact ideal equality in [3] and the direct containment tests
# in [4] -- always run. At k=6 the full battery does not finish in reasonable wall time.
LIGHT = 'light' in sys.argv

_print = print


def print(*a, **kw):                      # line-buffered, so progress is visible mid-run
    kw.setdefault('flush', True)
    _print(*a, **kw)


def cross(p, q):
    return (p[1]*q[2] - p[2]*q[1], p[2]*q[0] - p[0]*q[2], p[0]*q[1] - p[1]*q[0])


def tau(a):
    return (a[1], a[0], 2*a[2])


def cross5(p1, p2, p3, q1, q2, q3):
    m1 = (p2+p3)*q3; m2 = p1*(q1-q2); m3 = (p1+p3)*(q1-q2-q3)
    m4 = p3*(q2+q3); m5 = (p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5


def ring_for(k):
    names = []
    for b in BLOCK[:k]:
        names += ['%s%d' % (b, i) for i in (1, 2, 3)]
    R = PolynomialRing(QQ, names)
    g = R.gens()
    vs = [tuple(g[3*i:3*i+3]) for i in range(k)]
    return R, vs


def w_of(vs):
    """w_k built by the structural recursion, in whatever ring vs lives in."""
    wk = cross(vs[0], vs[1])
    for j in range(2, len(vs)):
        wk = cross(tau(wk), vs[j])
    return wk


def official_ideal(R, vs):
    """The ideal actually produced by chaining cross5, i.e. the real [A_1,...,A_k] entries."""
    k = len(vs)
    X1, Y1, Z1 = cross5(*vs[0], *vs[1]); d = (Y1, X1, 2*Z1)
    for j in range(2, k-1):
        Xn, Yn, Zn = cross5(*d, *vs[j]); d = (Yn, Xn, 2*Zn)
    if k == 2:
        H = (Z1, Y1, X1)
    else:
        Xn, Yn, Zn = cross5(*d, *vs[k-1]); H = (Zn, Yn, Xn)
    return R.ideal(list(H))


def blocks_involved(I, R, k):
    """Which of the k coordinate blocks actually appear in a generating set of I."""
    seen = set()
    for f in I.gens():
        for m in f.monomials():
            for i, e in enumerate(m.exponents()[0]):
                if e:
                    seen.add(i // 3)
    return sorted(seen)


def extend_ideal(I_small, R_small, R_big):
    """Extend an ideal from the first 3(k-1) variables into the 3k-variable ring."""
    phi = R_small.hom([R_big.gens()[i] for i in range(R_small.ngens())], R_big)
    return R_big.ideal([phi(f) for f in I_small.gens()])


def run(k):
    print("=" * 78)
    print("k = %d   (transition k-1 = %d  ->  k = %d)" % (k, k-1, k))
    print("=" * 78)

    R, vs = ring_for(k)
    Rprev, vsprev = ring_for(k-1)

    # ---- (0) structural sanity: official cross5 ideal == ideal of w_k -----------------
    I_off = official_ideal(R, vs)
    I_str = R.ideal(list(w_of(vs)))
    print("[0] I_k (cross5 chaining) == ideal(w_k) (tau-recursion)? %s" % (I_off == I_str))
    # The two are the SAME IDEAL (just checked), but not the same generating set, and Singular's
    # primary_decomposition is dramatically sensitive to which one it is handed: at k=6 the cross5
    # generators decompose in ~61s while the tau-recursion generators had not finished after 15
    # minutes. So everything below uses the cross5 generating set for the decompositions.
    I = I_off
    print("    dim V(I_k) = %d   (ambient %d, codim %d)"
          % (I.dimension(), R.ngens(), R.ngens() - I.dimension()))

    # ---- (1) primary decompositions -------------------------------------------------
    Iprev = official_ideal(Rprev, vsprev)
    PDprev = Iprev.primary_decomposition()
    print("[1] primary decomposition of I_{k-1}: %d components (expect k-2 = %d)"
          % (len(PDprev), k-2))
    for i, Q in enumerate(PDprev):
        rad = "(skipped)" if LIGHT else str(Q == Q.radical())
        print("      comp %d: dim=%d radical? %s  blocks=%s"
              % (i, Q.dimension(), rad, blocks_involved(Q, Rprev, k-1)))

    PD = I.primary_decomposition()
    print("    primary decomposition of I_k:     %d components (expect k-1 = %d)"
          % (len(PD), k-1))
    for i, Q in enumerate(PD):
        rad = "(skipped)" if LIGHT else str(Q == Q.radical())
        print("      comp %d: dim=%d radical? %s  blocks=%s"
              % (i, Q.dimension(), rad, blocks_involved(Q, R, k)))
    if LIGHT:
        print("    I_k radical? (skipped)   I_k == intersection of components? (skipped)")
    else:
        print("    I_k radical? %s   I_k == intersection of components? %s"
              % (I == I.radical(), I == reduce(lambda a, b: a.intersection(b), PD)))

    # ---- (2) I(Y_2) by honest elimination -------------------------------------------
    # ambient ring + one extra variable lam; graph of Phi is  v_k - lam*tau(w_{k-1}) = 0.
    names = list(R.variable_names()) + ['lam']
    S = PolynomialRing(QQ, names)
    Sg = S.gens()
    vsS = [tuple(Sg[3*i:3*i+3]) for i in range(k)]
    lam = Sg[-1]
    twprev = tau(w_of(vsS[:k-1]))
    graph = S.ideal([vsS[k-1][i] - lam*twprev[i] for i in range(3)])
    elim = graph.elimination_ideal([lam])
    back = S.hom(list(R.gens()) + [R.zero()], R)   # lam-free generators map back verbatim
    J2 = R.ideal([back(f) for f in elim.gens()])
    print("[2] I(Y_2) by elimination of lam from the graph ideal of Phi:")
    print("      %d generators, dim = %d, prime? %s"
          % (len(J2.gens()), J2.dimension(),
             "(skipped)" if LIGHT else str(J2.is_prime())))
    print("      generators: %s" % (J2.gens(),))

    # ---- (3) Y_1's pieces, and exact matching against I_k's components ---------------
    J1s = [extend_ideal(Q, Rprev, R) for Q in PDprev]
    print("[3] exact ideal-equality matching (I_k's components vs. Y_1 pieces / Y_2):")
    matched = {}
    for i, Q in enumerate(PD):
        hit = None
        for j, J1 in enumerate(J1s):
            if Q == J1:
                hit = "Y_1 piece %d  (component %d of I_{k-1}, v_k free)" % (j, j)
        if Q == J2:
            hit = "Y_2 (eliminated graph ideal)" if hit is None else hit + " AND Y_2 (!)"
        print("      comp %d  ==  %s" % (i, hit if hit else "*** NO MATCH ***"))
        matched[i] = hit
    print("    every Y_1 piece equals some component of I_k? %s"
          % all(any(J1 == Q for Q in PD) for J1 in J1s))
    print("    Y_2 equals some component of I_k?             %s"
          % any(J2 == Q for Q in PD))
    if LIGHT:
        print("    V(I_k) = Y_1 u Y_2 as ideals (I_k.radical() == intersection)? (skipped)")
    else:
        print("    V(I_k) = Y_1 u Y_2 as ideals (I_k.radical() == intersection)? %s"
              % (I.radical() == reduce(lambda a, b: a.intersection(b), J1s + [J2])))

    # ---- (4) direct non-containment tests, NOT read off the decomposition ------------
    print("[4] direct containment tests (V(J) <= V(J') iff J' <= J as ideals):")
    for j, J1 in enumerate(J1s):
        # Y_1 piece j contained in Y_2  <=>  J2 subset of J1
        c1 = all(f in J1 for f in J2.gens())
        # Y_2 contained in Y_1 piece j  <=>  J1 subset of J2
        c2 = all(f in J2 for f in J1.gens())
        print("      Y_1 piece %d  <=  Y_2 ?  %s        Y_2  <=  Y_1 piece %d ?  %s"
              % (j, c1, j, c2))
    # and Y_2 vs the whole of Y_1 (union): Y_2 <= Y_1 iff I(Y_1) = intersection of J1s <= J2
    if LIGHT:
        print("      Y_2  <=  Y_1 (whole union) ?  (skipped)")
        print("      Y_1 (union)  <=  Y_2 ?        (skipped)")
    else:
        IY1 = reduce(lambda a, b: a.intersection(b), J1s)
        print("      Y_2  <=  Y_1 (whole union) ?  %s" % all(f in J2 for f in IY1.gens()))
        print("      Y_1 (union)  <=  Y_2 ?        %s" % all(f in IY1 for f in J2.gens()))

    # ---- (5) w_{k-1} is not the zero polynomial map: explicit witness ----------------
    # Built exactly the way the inductive proof does it: start from v_1=e_1, v_2=e_2 (so
    # w_2 = e_3 != 0); at each further step tau(w_{j-1}) != 0, so at least one standard basis
    # vector e_i is not parallel to it -- pick the first such as v_j, forcing w_j != 0.
    print("[5] w_{k-1} not identically zero -- witness built by the inductive recipe:")
    E = [vector(QQ, [1, 0, 0]), vector(QQ, [0, 1, 0]), vector(QQ, [0, 0, 1])]
    pts = [E[0], E[1]]
    cur = E[0].cross_product(E[1])
    for j in range(2, k-1):
        t = vector(QQ, tau(tuple(cur)))
        pick = next(e for e in E if t.cross_product(e) != 0)
        pts.append(pick)
        cur = t.cross_product(pick)
    pt = [c for p in pts for c in p]
    wprev = w_of(vsprev)
    val = tuple(f(*pt) for f in wprev)
    print("      point (v_1,...,v_{k-1}) = %s" % (tuple(pt),))
    print("      w_{k-1} there = %s   (nonzero? %s)" % (val, any(v != 0 for v in val)))


ks = [int(a) for a in sys.argv[1:] if a.isdigit()] or [4, 5]
for k in ks:
    run(k)
    print()
