# 2026-08-30 (Claude-Code-jts-pc): ground truth for EVERY explicit display in the
# manuscript, computed under the signed encoding D = diag(-1,-1,1).
#
# Why: the two manuscripts were merged today and the tau -> D change was applied as a
# symbol substitution.  That is correct for the PROOFS -- they use only invertibility --
# but explicit computed matrices and polynomials cannot be substituted at all, they must
# be RECOMPUTED.  An adversarial review found several displays still carrying tau-era
# data; the tell is a literal coefficient 2, since the signed encoding's own selling
# point is that every coefficient is +-1.
#
# This script recomputes all of them so the manuscript can be corrected against
# computation rather than against reading.  Output goes to
# runs/display-ground-truth-D.txt.
#
# Conventions, matching the manuscript:
#   w_2     = v_1 x v_2
#   w_j     = D(w_{j-1}) x v_j          (j >= 3)
#   D(u)    = (-u_0, -u_1, u_2)
#   Thm 6's 2x3 matrix at level k has rows  D(w_{k-1})  and  v_k   (rows v_1, v_2 at k=2)
#   J_k     = Jacobian of w_k in the variables v_1..v_k
#   P_j     = vanishing ideal of Y_2 at parameter j, i.e. the closure of the image of
#             Phi(p, lam) = (p, lam * D(w_{j-1}(p))), obtained by eliminating lam.

import sys

def blocks(k):
    return PolynomialRing(QQ, ['v%d_%d' % (i, j) for i in range(1, k + 1) for j in range(1, 4)])

def setup(k):
    R = blocks(k)
    g = R.gens()
    v = [vector(R, g[3 * i:3 * i + 3]) for i in range(k)]
    return R, v

def Dv(u, R):
    return vector(R, [-u[0], -u[1], u[2]])

def w_upto(k, R, v):
    """w_2 .. w_k, indexed so ws[j] is w_j."""
    ws = {}
    ws[2] = v[0].cross_product(v[1])
    for j in range(3, k + 1):
        ws[j] = Dv(ws[j - 1], R).cross_product(v[j - 1])
    return ws

def show(label, obj):
    print("\n--- %s ---" % label)
    if isinstance(obj, (list, tuple)):
        for x in obj:
            print("   ", x)
    else:
        print("   ", obj)

print("=" * 78)
print("GROUND TRUTH under D = diag(-1,-1,1).  Any literal coefficient 2 below would be")
print("a red flag: the signed encoding should give +-1 coefficients throughout.")
print("=" * 78)

# ---- w_k, and Theorem 6's 2x3 matrix, at k = 2,3,4 -------------------------
for k in (2, 3, 4):
    R, v = setup(k)
    ws = w_upto(k, R, v)
    show("w_%d components" % k, list(ws[k]))
    if k == 2:
        show("Thm6 matrix rows at k=2", ["row1 = v_1 = %s" % list(v[0]),
                                         "row2 = v_2 = %s" % list(v[1])])
    else:
        show("Thm6 matrix rows at k=%d" % k,
             ["row1 = D(w_%d) = %s" % (k - 1, list(Dv(ws[k - 1], R))),
              "row2 = v_%d    = %s" % (k, list(v[k - 1]))])
    # sanity: the components of w_k really are the 2x2 minors of that matrix
    if k >= 3:
        M = matrix(R, [list(Dv(ws[k - 1], R)), list(v[k - 1])])
        minors = [M.matrix_from_columns([1, 2]).det(),
                  -M.matrix_from_columns([0, 2]).det(),
                  M.matrix_from_columns([0, 1]).det()]
        print("    minors match w_%d:" % k, [minors[i] == ws[k][i] for i in range(3)])

# ---- the Jacobians J_2 and J_3 --------------------------------------------
for k in (2, 3):
    R, v = setup(k)
    ws = w_upto(k, R, v)
    J = jacobian(vector(R, list(ws[k])), R.gens())
    show("J_%d  (3 x %d)" % (k, 3 * k), [list(J[i]) for i in range(3)])
    if k == 3:
        # split as the lemma does: [ -[v_3]x D J_2 | [D(w_2)]x ]
        print("\n    first block  -[v_3]x D J_2  (3x6):")
        R3, v3 = R, v
        ws2 = w_upto(2, R3, v3)
        J2 = jacobian(vector(R3, list(ws2[2])), R3.gens()[:6])
        def crossmat(u):
            return matrix(R3, [[0, -u[2], u[1]], [u[2], 0, -u[0]], [-u[1], u[0], 0]])
        Dmat = diagonal_matrix(R3, [-1, -1, 1])
        blk1 = -crossmat(v3[2]) * Dmat * J2
        for i in range(3):
            print("      ", list(blk1[i]))
        print("\n    second block  [D(w_2)]x  (3x3):")
        blk2 = crossmat(Dv(ws2[2], R3))
        for i in range(3):
            print("      ", list(blk2[i]))
        print("\n    blocks agree with J_3:",
              all(blk1[i][j] == J[i][j] for i in range(3) for j in range(6))
              and all(blk2[i][j] == J[i][j + 6] for i in range(3) for j in range(3)))

# ---- the explicit Y_2 point -----------------------------------------------
R, v = setup(2)
ws = w_upto(2, R, v)
sub = {R.gen(0): 1, R.gen(1): 0, R.gen(2): 0, R.gen(3): 0, R.gen(4): 1, R.gen(5): 0}
print("\n--- explicit point: v_1 = e_1, v_2 = e_2 ---")
print("    w_2      =", [x.subs(sub) for x in ws[2]])
print("    D(w_2)   =", [x.subs(sub) for x in Dv(ws[2], R)])

# ---- P_j : vanishing ideal of Y_2 at parameter j ---------------------------
def P(j):
    """Eliminate lam from  v_j - lam * D(w_{j-1}(p))."""
    names = ['v%d_%d' % (i, c) for i in range(1, j + 1) for c in range(1, 4)] + ['lam']
    S = PolynomialRing(QQ, names, order='degrevlex')
    gs = S.gens()
    vv = [vector(S, gs[3 * i:3 * i + 3]) for i in range(j)]
    lam = gs[-1]
    wsS = {2: vv[0].cross_product(vv[1])}
    for t in range(3, j):
        wsS[t] = vector(S, [-wsS[t-1][0], -wsS[t-1][1], wsS[t-1][2]]).cross_product(vv[t-1])
    prev = wsS[j - 1] if j >= 3 else vv[0].cross_product(vv[1])
    Dprev = vector(S, [-prev[0], -prev[1], prev[2]])
    I = S.ideal([vv[j-1][c] - lam * Dprev[c] for c in range(3)])
    return I.elimination_ideal([lam])

for j in (3, 4):
    print("\n--- P_%d generators (Y_2's ideal at parameter %d) ---" % (j, j))
    for gpoly in P(j).groebner_basis():
        print("   ", gpoly)

print("\n" + "=" * 78)
print("done")
