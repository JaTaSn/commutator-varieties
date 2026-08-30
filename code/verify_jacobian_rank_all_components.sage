# 2026-08-16 (Claude-Code-opus-subagent): the R_0 half of the Serre-criterion route to radicality of
# I_k, flagged as a lead in Step 4.4 of working-notes/proof-plan-conjectures.org and worked out in
# that note's Step 5.
#
# Recall (Step 0 / Step 4 of the proof plan):
#   w_2 = v_1 x v_2,   w_j = tau(w_{j-1}) x v_j,   tau(a,b,c) = (b,a,2c),   I_k = (w_k),
# and (Theorem 4.6) V(I_k) is equidimensional of codimension 2 with exactly k-1 components
#   C_j := Y_2^{(j)} x A^{3(k-j)},   j = 2,...,k,
# component C_j involving exactly the first j coordinate blocks.
#
# R_k/I_k Cohen-Macaulay gives Serre's S_1 for free, so radicality reduces to R_0: for each minimal
# prime P_j, (R_k/I_k)_{P_j} must be a field. It suffices to exhibit ONE rational point x on C_j at
# which the 3 x 3k Jacobian J_k := (d w_{k,a} / d x_b) has rank exactly 2 = codim: the Zariski
# cotangent space of R_k/I_k at x then has dimension 3k-2 = dim O_{X,x}, so O_{X,x} is regular,
# hence so is its localization at P_j.
#
# This script, for each requested k:
#   (0) rebuilds I_k both ways (chained cross5 vs. the tau-recursion) and confirms equality, so the
#       Jacobian below is the Jacobian of the ACTUAL commutator generators;
#   (1) verifies the structural block formula the induction rests on, as an identity of polynomial
#       matrices:   J_k = [ -[v_k]_x . T . J_{k-1}  |  [tau(w_{k-1})]_x ],
#       where [u]_x is the skew matrix with [u]_x v = u x v and T is the matrix of tau.
#       NOTE this is exactly the point where the naive guess "the old Jacobian just gains zero
#       columns for the new free variables" is FALSE: the old columns are multiplied by
#       -[v_k]_x . T, which can and does drop rank for bad choices of v_k;
#   (2) builds a witness point on each component C_j by the inductive recipe of Step 5:
#         j = k  (the new component):  (p, 0) with p a Lemma-4.2 point where w_{k-1}(p) != 0;
#         j < k  (inherited):          (q, e_i) with q the level-(k-1) witness on C_j and e_i any
#                                      standard basis vector outside W_q := T . im J_{k-1}(q);
#   (3) checks each witness really lies on V(I_k), computes rank J_k there, and -- via Singular's
#       primary decomposition -- checks the point lies on EXACTLY ONE component and identifies which
#       (by block involvement), so "witness for component j" is verified, not assumed.
#
# Usage: sage verify_jacobian_rank_all_components.sage [k ...]        (default: 2 3 4 5 6)
#        pass "nopd" to skip step (3)'s primary decomposition (the only slow part; ~60s at k=6).

import sys

BLOCK = ['u', 'v', 'w', 'x', 'y', 'z']

NOPD = 'nopd' in sys.argv

_print = print


def print(*a, **kw):                      # line-buffered, so progress is visible mid-run
    kw.setdefault('flush', True)
    _print(*a, **kw)


def cross(p, q):
    return (p[1]*q[2] - p[2]*q[1], p[2]*q[0] - p[0]*q[2], p[0]*q[1] - p[1]*q[0])


def tau(a):
    return (a[1], a[0], 2*a[2])


T_MAT = matrix(QQ, 3, 3, [[0, 1, 0], [1, 0, 0], [0, 0, 2]])     # tau as a matrix


def skew(u, ring):
    """[u]_x, the matrix with [u]_x . v = u x v."""
    return matrix(ring, 3, 3, [[0, -u[2], u[1]],
                               [u[2], 0, -u[0]],
                               [-u[1], u[0], 0]])


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


def jacobian_of(k):
    """The 3 x 3k Jacobian of w_k, as a matrix over R_k."""
    R, vs = ring_for(k)
    wk = w_of(vs)
    return R, vs, matrix(R, 3, 3*k, [[f.derivative(x) for x in R.gens()] for f in wk])


def blocks_involved(I):
    seen = set()
    for f in I.gens():
        for m in f.monomials():
            for i, e in enumerate(m.exponents()[0]):
                if e:
                    seen.add(i // 3)
    return sorted(seen)


# --------------------------------------------------------------------------------------------
# numeric evaluation helpers (points live in QQ^{3k})
# --------------------------------------------------------------------------------------------

def w_num(k, pt):
    """w_k evaluated at a rational point pt (list of 3k rationals)."""
    vs = [vector(QQ, pt[3*i:3*i+3]) for i in range(k)]
    cur = vs[0].cross_product(vs[1])
    for j in range(2, k):
        cur = vector(QQ, tau(tuple(cur))).cross_product(vs[j])
    return cur


def jac_num(k, pt):
    """J_k evaluated at pt, built numerically by the same recursion (no symbolic ring needed).

    J_2 = [ -[v_2]_x | [v_1]_x ]  and  J_k = [ -[v_k]_x . T . J_{k-1} | [tau(w_{k-1})]_x ].
    """
    vs = [vector(QQ, pt[3*i:3*i+3]) for i in range(k)]
    J = block_matrix(QQ, 1, 2, [-skew(vs[1], QQ), skew(vs[0], QQ)], subdivide=False)
    cur = vs[0].cross_product(vs[1])                       # w_2
    for j in range(2, k):
        u = vector(QQ, tau(tuple(cur)))                    # tau(w_{j-1})
        J = block_matrix(QQ, 1, 2,
                         [-skew(vs[j], QQ) * T_MAT * J, skew(u, QQ)], subdivide=False)
        cur = u.cross_product(vs[j])                       # w_j
    return J


E = [vector(QQ, [1, 0, 0]), vector(QQ, [0, 1, 0]), vector(QQ, [0, 0, 1])]


def lemma42_point(m):
    """A point of A^{3m} with w_m != 0, by the inductive recipe of Lemma 4.2."""
    pts = [E[0], E[1]]
    cur = E[0].cross_product(E[1])
    for j in range(2, m):
        t = vector(QQ, tau(tuple(cur)))
        pick = next(e for e in E if t.cross_product(e) != 0)
        pts.append(pick)
        cur = t.cross_product(pick)
    return [c for p in pts for c in p]


def witness(k, j):
    """Witness point on component C_j of V(I_k), by the Step 5 inductive recipe.

    Returns (point, provenance-string).
    """
    if j == k:
        if k == 2:
            return list(E[0]) + [0, 0, 0], "(e_1, 0): base case, J_2 = [0 | [e_1]_x]"
        p = lemma42_point(k-1)
        return p + [0, 0, 0], "(p, 0) with p the Lemma 4.2 point, w_{k-1}(p) != 0"
    q, prov = witness(k-1, j)
    Jq = jac_num(k-1, q)
    W = (T_MAT * Jq).column_space()                  # W = T . im J_{k-1}(q), expect dim 2
    pick = next((i for i in range(3) if E[i] not in W), None)
    if pick is None:
        raise RuntimeError("no standard basis vector outside W -- W would have to be all of QQ^3")
    return q + list(E[pick]), ("(q, e_%d) with q the level-%d witness; dim W_q = %d, "
                               "e_%d not in W_q" % (pick+1, k-1, W.dimension(), pick+1))


# --------------------------------------------------------------------------------------------

def run(k):
    print("=" * 78)
    print("k = %d   (ambient A^{%d}, expected codim 2, expected %d components)" % (k, 3*k, k-1))
    print("=" * 78)

    R, vs, J = jacobian_of(k)

    # ---- (0) the Jacobian is the Jacobian of the real commutator ideal ---------------
    I_off = official_ideal(R, vs)
    I_str = R.ideal(list(w_of(vs)))
    print("[0] I_k (cross5 chaining) == ideal(w_k) (tau-recursion)? %s" % (I_off == I_str))

    # ---- (1) the block formula, as an identity of polynomial matrices ----------------
    if k >= 3:
        Rp, vsp = ring_for(k-1)
        _, _, Jprev = jacobian_of(k-1)
        emb = Rp.hom([R.gens()[i] for i in range(Rp.ngens())], R)
        Jprev_R = matrix(R, 3, 3*(k-1), [[emb(e) for e in row] for row in Jprev.rows()])
        wprev_R = tuple(emb(f) for f in w_of(vsp))
        lhs = J
        rhs = block_matrix(R, 1, 2,
                           [-skew(vs[k-1], R) * T_MAT.change_ring(R) * Jprev_R,
                            skew(tau(wprev_R), R)], subdivide=False)
        print("[1] J_k == [ -[v_k]_x . T . J_{k-1} | [tau(w_{k-1})]_x ] as polynomial matrices? %s"
              % (lhs == rhs))
        print("    (so the level-(k-1) columns are NOT inherited unchanged: they are hit by")
        print("     -[v_k]_x . T, which drops rank whenever v_k lies in T . im J_{k-1}.)")
    else:
        print("[1] base case k=2: J_2 = [ -[v_2]_x | [v_1]_x ] by direct differentiation")

    # ---- (2)/(3) witnesses, ranks, component identification --------------------------
    if NOPD:
        PD = None
        print("[2] primary decomposition: (skipped, nopd)")
    else:
        PD = official_ideal(R, vs).primary_decomposition()
        print("[2] primary decomposition of I_k: %d components (expect %d)" % (len(PD), k-1))
        for i, Q in enumerate(PD):
            print("      comp %d: dim=%d blocks=%s" % (i, Q.dimension(), blocks_involved(Q)))

    print("[3] witness points and Jacobian ranks:")
    all_ok = True
    for j in range(2, k+1):
        pt, prov = witness(k, j)
        wv = w_num(k, pt)
        Jn = jac_num(k, pt)
        # cross-check the numeric Jacobian against substituting into the symbolic one
        Jsym = matrix(QQ, 3, 3*k, [[e(*pt) for e in row] for row in J.rows()])
        r = Jn.rank()
        on = []
        if PD is not None:
            for i, Q in enumerate(PD):
                if all(f(*pt) == 0 for f in Q.gens()):
                    on.append((i, blocks_involved(Q)))
        ok = (wv == 0) and (r == 2) and (Jn == Jsym)
        comp_ok = True
        if PD is not None:
            comp_ok = (len(on) == 1 and on[0][1] == list(range(j)))
            ok = ok and comp_ok
        all_ok = all_ok and ok
        print("    component C_%d  (blocks 0..%d)" % (j, j-1))
        print("      point      = %s" % (tuple(pt),))
        print("      recipe     = %s" % prov)
        print("      w_k(point) = %s   (in V(I_k)? %s)" % (tuple(wv), wv == 0))
        print("      numeric J_k == symbolic J_k at the point? %s" % (Jn == Jsym))
        print("      rank J_k(point) = %d   (want exactly 2 = codim)  %s"
              % (r, "OK" if r == 2 else "*** WRONG ***"))
        if PD is not None:
            print("      lies on components %s   (want exactly one, with blocks %s)  %s"
                  % ([i for i, _ in on], list(range(j)), "OK" if comp_ok else "*** WRONG ***"))
    print("    ALL CHECKS PASSED for k = %d? %s" % (k, all_ok))


def naive_transfer_fails():
    """The choice of v_k in the inherited case is NOT cosmetic: the two obvious guesses both fail.

    Level-2 witness on C_2 is q = (e_1, 0), with rank J_2(q) = 2 and W_q = T . im J_2(q).
    Extending q by v_3 = 0 ("just append the new free block, the extra columns are zero") gives
    rank 0; extending by a NONZERO v_3 that happens to lie in W_q gives rank 1; only v_3 outside
    W_q gives the required rank 2.
    """
    print("=" * 78)
    print("[4] why the choice of v_k matters (k = 3, inherited component C_2)")
    print("=" * 78)
    q = list(E[0]) + [0, 0, 0]
    Jq = jac_num(2, q)
    W = (T_MAT * Jq).column_space()
    print("    level-2 witness q = %s, rank J_2(q) = %d" % (tuple(q), Jq.rank()))
    print("    W_q = T . im J_2(q) has dimension %d, basis %s"
          % (W.dimension(), [tuple(b) for b in W.basis()]))
    for label, v3 in [("v_3 = 0            (the 'append zero columns' guess)", [0, 0, 0]),
                      ("v_3 = e_1  in W_q  (nonzero, but a bad direction)", list(E[0])),
                      ("v_3 = e_3  in W_q  (nonzero, but a bad direction)", list(E[2])),
                      ("v_3 = e_2  not in W_q  (what the recipe picks)", list(E[1]))]:
        pt = q + v3
        print("      %s:  w_3 = %s, rank J_3 = %d"
              % (label, tuple(w_num(3, pt)), jac_num(3, pt).rank()))


ks = [int(a) for a in sys.argv[1:] if a.isdigit()] or [2, 3, 4, 5, 6]
for k in ks:
    run(k)
    print()
naive_transfer_fails()
