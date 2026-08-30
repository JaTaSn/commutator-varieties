# 2026-08-30 (Claude-Code-jts-pc, adversarial-referee round 3): independent re-verification of the
# Radicality section (Lemmas 32-39, Theorem 40) of article/ring-of-k-commuting-2x2-matrices.typ
# AFTER the red/tau -> enc/D merge.  The script previously cited by that section,
# verify_jacobian_rank_all_components.sage, still uses the OLD tau encoding
# (tau(a,b,c)=(b,a,2c)), so it verifies the old ideal, not the manuscript's current one.
# This script redoes every numerically checkable claim of the section for D = diag(-1,-1,1):
#
#   [A] the Jacobian recursion (lem-jacrecursion), as a polynomial-matrix identity, k=2..6:
#         J_2 = [ -[v_2]_x | [v_1]_x ],   J_k = [ -[v_k]_x . D . J_{k-1} | [D(w_{k-1})]_x ];
#   [B] the explicit k=3 example blocks printed in the manuscript, compared entrywise against
#       (i) the true D-encoding blocks and (ii) the old tau-encoding blocks -- to determine
#       whether the printed matrices are stale merge leftovers;
#   [C] the "false shortcut" remark: appending v_3 = 0 to a rank-2 witness on V(I_2) drops
#       rank J_3 to 0;
#   [D] the witness recipe of lem-witness-new / lem-witness-inherited, k=2..6: build the
#       inductive witness on every component, confirm membership in V(I_k) and rank J_k = 2;
#   [E] via primary decomposition (k=3..6), confirm each witness lies on EXACTLY its intended
#       component (identified by which coordinate blocks its prime involves);
#   [F] the displayed w_3 generators (article lines ~518-520) against the D recursion.
#
# Output: runs/referee-radicality-D-check.txt
# Usage:  sage code/referee_radicality_D_check.sage   (from the repo root; ~2-3 min, PD at k=6 slow)

import sys

_print = print
def print(*a, **kw):
    kw.setdefault('flush', True)
    _print(*a, **kw)

def ring(k):
    names = ['v%d_%d' % (i, j) for i in range(1, k + 1) for j in range(1, 4)]
    R = PolynomialRing(QQ, names)
    g = R.gens()
    vs = [vector(R, g[3 * i:3 * i + 3]) for i in range(k)]
    return R, vs

def Dmap(u):
    return vector(u.base_ring(), [-u[0], -u[1], u[2]])

D_MAT = matrix(QQ, 3, 3, [[-1, 0, 0], [0, -1, 0], [0, 0, 1]])
T_MAT = matrix(QQ, 3, 3, [[0, 1, 0], [1, 0, 0], [0, 0, 2]])   # old tau, for comparison in [B]

def taumap(u):
    return vector(u.base_ring(), [u[1], u[0], 2 * u[2]])

def w_of(vs, twist):
    w = vs[0].cross_product(vs[1])
    for j in range(2, len(vs)):
        w = twist(w).cross_product(vs[j])
    return w

def skew(u, R):
    return matrix(R, 3, 3, [[0, -u[2], u[1]], [u[2], 0, -u[0]], [-u[1], u[0], 0]])

def jac(w, R):
    return matrix(R, 3, R.ngens(), [[w[a].derivative(g) for g in R.gens()] for a in range(3)])

print("=" * 78)
print("[A] Jacobian recursion (lem-jacrecursion) as polynomial identity, D encoding")
print("=" * 78)
for k in range(2, 7):
    R, vs = ring(k)
    w = w_of(vs, Dmap)
    J = jac(w, R)
    if k == 2:
        rhs = block_matrix(R, 1, 2, [-skew(vs[1], R), skew(vs[0], R)], subdivide=False)
    else:
        wprev = w_of(vs[:-1], Dmap).change_ring(R)
        # J_{k-1} viewed in R: w_{k-1} involves only the first 3(k-1) variables, so its
        # Jacobian in R restricted to those columns IS J_{k-1}
        Jprev = jac(wprev, R).matrix_from_columns(range(3 * (k - 1)))
        rhs = block_matrix(R, 1, 2,
                           [-skew(vs[-1], R) * D_MAT.change_ring(R) * Jprev,
                            skew(Dmap(wprev), R)], subdivide=False)
    print("  k=%d: J_k == recursion RHS?  %s" % (k, J == rhs))

print()
print("=" * 78)
print("[B] the printed k=3 example blocks: stale tau version, or correct D version?")
print("=" * 78)
R3, vs3 = ring(3)
v = {}
for i in range(1, 4):
    for j in range(1, 4):
        v[(i, j)] = R3('v%d_%d' % (i, j))

# Block 1 as printed in the manuscript (3 x 6), lines ~1129-1136:
B1_printed = matrix(R3, 3, 6, [
    [-2*v[2,2]*v[3,2],  2*v[2,1]*v[3,2] + v[2,3]*v[3,3],  -v[2,2]*v[3,3],
      2*v[1,2]*v[3,2], -2*v[1,1]*v[3,2] - v[1,3]*v[3,3],   v[1,2]*v[3,3]],
    [ 2*v[2,2]*v[3,1] + v[2,3]*v[3,3], -2*v[2,1]*v[3,1],  -v[2,1]*v[3,3],
     -2*v[1,2]*v[3,1] - v[1,3]*v[3,3],  2*v[1,1]*v[3,1],   v[1,1]*v[3,3]],
    [-v[2,3]*v[3,2], -v[2,3]*v[3,1],  v[2,2]*v[3,1] + v[2,1]*v[3,2],
      v[1,3]*v[3,2],  v[1,3]*v[3,1], -v[1,2]*v[3,1] - v[1,1]*v[3,2]],
])
# Block 2 as printed (3 x 3), lines ~1140-1144:
B2_printed = matrix(R3, 3, 3, [
    [0, 2*v[1,2]*v[2,1] - 2*v[1,1]*v[2,2], -v[1,3]*v[2,2] + v[1,2]*v[2,3]],
    [-2*v[1,2]*v[2,1] + 2*v[1,1]*v[2,2], 0, -v[1,3]*v[2,1] + v[1,1]*v[2,3]],
    [v[1,3]*v[2,2] - v[1,2]*v[2,3], v[1,3]*v[2,1] - v[1,1]*v[2,3], 0],
])

w2 = vs3[0].cross_product(vs3[1])
J2_in_R3 = block_matrix(R3, 1, 2, [-skew(vs3[1], R3), skew(vs3[0], R3)], subdivide=False)
B1_D   = -skew(vs3[2], R3) * D_MAT.change_ring(R3) * J2_in_R3
B1_tau = -skew(vs3[2], R3) * T_MAT.change_ring(R3) * J2_in_R3
B2_D   = skew(Dmap(w2), R3)
B2_tau = skew(taumap(w2), R3)

print("  Block 1 printed == D version?   %s" % (B1_printed == B1_D))
print("  Block 1 printed == tau version? %s" % (B1_printed == B1_tau))
print("  Block 2 printed == D version?   %s" % (B2_printed == B2_D))
print("  Block 2 printed == tau version? %s" % (B2_printed == B2_tau))
print("  Correct D-version block 1 (rows):")
for r in B1_D.rows():
    print("    %s" % (list(r),))
print("  Correct D-version block 2 (rows):")
for r in B2_D.rows():
    print("    %s" % (list(r),))
# sanity: the printed blocks should ALSO agree with the actual Jacobian of the tau-w_3
w3_tau = w_of(vs3, taumap)
J3_tau = jac(w3_tau, R3)
print("  [printed blocks side-by-side] == J_3 of tau-encoding w_3?  %s"
      % (block_matrix(R3, 1, 2, [B1_printed, B2_printed], subdivide=False) == J3_tau))
w3_D = w_of(vs3, Dmap)
J3_D = jac(w3_D, R3)
print("  [D-version blocks side-by-side] == J_3 of D-encoding w_3?  %s"
      % (block_matrix(R3, 1, 2, [B1_D, B2_D], subdivide=False) == J3_D))

print()
print("=" * 78)
print("[F] displayed w_3 generators (article ex-wk-signed) vs D recursion")
print("=" * 78)
g1 = v[1,2]*v[2,1]*v[3,2] - v[1,1]*v[2,2]*v[3,2] - v[1,3]*v[2,1]*v[3,3] + v[1,1]*v[2,3]*v[3,3]
g2 = -v[1,2]*v[2,1]*v[3,1] + v[1,1]*v[2,2]*v[3,1] - v[1,3]*v[2,2]*v[3,3] + v[1,2]*v[2,3]*v[3,3]
g3 = v[1,3]*v[2,1]*v[3,1] - v[1,1]*v[2,3]*v[3,1] + v[1,3]*v[2,2]*v[3,2] - v[1,2]*v[2,3]*v[3,2]
print("  displayed (g1,g2,g3) == w_3 (D)?  %s" % (vector(R3, [g1, g2, g3]) == w3_D))

print()
print("=" * 78)
print("[C] false-shortcut remark: rank J_3(q, 0) for q a rank-2 witness on V(I_2)")
print("=" * 78)
q23 = [QQ(t) for t in (1, 0, 0, 0, 0, 0, 0, 0, 0)]   # ((1,0,0),(0,0,0),(0,0,0))
subs = dict(zip(R3.gens(), q23))
J3_at = J3_D.subs(subs).change_ring(QQ)
print("  q = ((1,0,0),(0,0,0)) on V(I_2); rank J_3(q,0) = %d  (remark claims 0)"
      % J3_at.rank())

print()
print("=" * 78)
print("[D]+[E] witness recipe on every component, D encoding, k=2..6")
print("=" * 78)

def eval_at(M, R, pt):
    return M.subs(dict(zip(R.gens(), pt))).change_ring(QQ)

def blocks_involved(P, k):
    inv = set()
    for gpoly in P.gens():
        for gv in gpoly.variables():
            inv.add(int(str(gv).split('_')[0][1:]))
    return inv

E = [vector(QQ, [1, 0, 0]), vector(QQ, [0, 1, 0]), vector(QQ, [0, 0, 1])]

# nondeg witness chain p_j (lem-nondeg): p_2=(e1,e2); p_j=(p_{j-1}, e_i), e_i not parallel D(c)
nondeg = {2: [QQ(1), 0, 0, 0, QQ(1), 0]}
def w_at(j, pt):
    Rj, vsj = ring(j)
    return vector(QQ, [c(*pt) for c in w_of(vsj, Dmap)])
for j in range(3, 7):
    p = nondeg[j - 1]
    c = w_at(j - 1, p)
    Dc = vector(QQ, [-c[0], -c[1], c[2]])
    for e in E:
        if Dc.cross_product(e) != 0:
            nondeg[j] = list(p) + [x for x in e]
            break
print("  nondeg chain: " + "; ".join("w_%d(p_%d)=%s" % (j, j, tuple(w_at(j, nondeg[j])))
                                     for j in range(2, 7)))

witness = {2: {2: [QQ(1), 0, 0, 0, 0, 0]}}   # witness[k][j] = point on component j of V(I_k)
for k in range(2, 7):
    Rk, vsk = ring(k)
    wk = w_of(vsk, Dmap)
    Jk = jac(wk, Rk)
    if k > 2:
        witness[k] = {}
        # inherited components j < k
        for j in range(2, k):
            q = witness[k - 1][j]
            Rprev, vsprev = ring(k - 1)
            Jprev = jac(w_of(vsprev, Dmap), Rprev)
            Jq = eval_at(Jprev, Rprev, q)
            W = (D_MAT * Jq).column_space()
            ei = None
            for e in E:
                if e not in W:
                    ei = e
                    break
            witness[k][j] = list(q) + [x for x in ei]
        # new component j = k
        witness[k][k] = list(nondeg[k - 1]) + [0, 0, 0]
    # rank + membership checks
    PD = None
    if k >= 3:
        Ik = Rk.ideal(list(wk))
        PD = Ik.primary_decomposition()
    for j in sorted(witness[k]):
        x = witness[k][j]
        on_V = (w_at(k, x) == 0)
        rk = eval_at(Jk, Rk, x).rank()
        line = "  k=%d comp j=%d: witness=%s  on V(I_k)=%s  rank J_k=%d" % (
            k, j, tuple(x), on_V, rk)
        if PD is not None:
            hits = []
            for P in PD:
                if all(gpoly(*x) == 0 for gpoly in P.gens()):
                    hits.append(sorted(blocks_involved(P, k)))
            line += "  lies on %d component(s), blocks %s (intended: first %d)" % (
                len(hits), hits, j)
        print(line)
    if PD is not None:
        print("    (k=%d: %d primary components found; expected %d)" % (k, len(PD), k - 1))

print()
print("done.")
