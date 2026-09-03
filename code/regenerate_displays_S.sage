# Ground truth for EVERY explicit display in the manuscript, computed under the
# signed encoding S = diag(-1,-1,1).
#
# Changelog (reverse-chronological)
#   2026-09-03  Renamed regenerate_displays_D.sage -> _S.sage, and D -> S throughout,
#               following the manuscript's own rename the same day (D collides
#               visually with the later Jacobian material; S is for the SIGNATURE of
#               the Lorentzian form).  Pasting this file's old output into the new
#               appendix would have reintroduced the retired symbol -- exactly the
#               drift the rename existed to end.  Added the blocks the appendix
#               needs (marked APPENDIX below) and hard-wrapped long polynomials: a
#               single generator of I_6 is ~1020 characters, unreadable in a
#               transcript and unusable in a printed appendix as one line.
#   2026-08-30  Created (Claude-Code-jts-pc).
#
# Why this exists: the two manuscripts were merged 2026-08-30 and the tau -> signed
# change was applied as a symbol substitution.  That is correct for the PROOFS -- they
# use only invertibility -- but explicit computed matrices and polynomials cannot be
# substituted at all, they must be RECOMPUTED.  An adversarial review found several
# displays still carrying tau-era data; the tell is a literal coefficient 2, since the
# signed encoding's own selling point is that every coefficient is +-1.
#
# That tell earned its keep again on 2026-09-03.  The six-variable ideal Jan asked to
# have written out in the article carried coefficients +-1, +-2 and +-4 -- tau-era
# output.  Under S the same three generators have 32 terms each and coefficients +-1
# throughout, and reproducing his paste verbatim would have contradicted the article's
# own thrice-stated claim that no 2 appears anywhere in the output.
#
# Conventions, matching the manuscript:
#   w_2     = v_1 x v_2
#   w_j     = S(w_{j-1}) x v_j          (j >= 3)
#   S(u)    = (-u_0, -u_1, u_2)
#   Thm 6's 2x3 matrix at level k has rows  S(w_{k-1})  and  v_k   (rows v_1, v_2 at k=2)
#   J_k     = Jacobian of w_k in the variables v_1..v_k
#   P_j     = vanishing ideal of Y_2 at parameter j, i.e. the closure of the image of
#             Phi(p, lam) = (p, lam * S(w_{j-1}(p))), obtained by eliminating lam.
#
# Output: runs/display-ground-truth-S.txt

import re
import sys


def wrapped(poly, width=92):
    """Break a long polynomial before a sign, never inside a monomial.

    Splitting at a fixed column can land inside a variable name, producing a
    line that looks wrong to a reader in a way indistinguishable from a genuine
    error.  Splitting before " + " / " - " cannot."""
    parts, cur, out = re.split(r"(?= [+-] )", str(poly)), "", []
    for p in parts:
        if cur and len(cur) + len(p) > width:
            out.append(cur)
            cur = p.lstrip()
        else:
            cur += p
    if cur:
        out.append(cur)
    return out


def show_poly(label, poly, indent="        "):
    print("    %s =" % label)
    for line in wrapped(poly):
        print(indent + line)

def blocks(k):
    return PolynomialRing(QQ, ['v%d_%d' % (i, j) for i in range(1, k + 1) for j in range(1, 4)])

def setup(k):
    R = blocks(k)
    g = R.gens()
    v = [vector(R, g[3 * i:3 * i + 3]) for i in range(k)]
    return R, v

def Sv(u, R):
    return vector(R, [-u[0], -u[1], u[2]])

def w_upto(k, R, v):
    """w_2 .. w_k, indexed so ws[j] is w_j."""
    ws = {}
    ws[2] = v[0].cross_product(v[1])
    for j in range(3, k + 1):
        ws[j] = Sv(ws[j - 1], R).cross_product(v[j - 1])
    return ws

def show(label, obj):
    """Print a labelled block, wrapping anything too wide to read.

    Added 2026-09-03: the w_4 rows and the Theorem 6 matrix rows ran to 178 and
    222 characters, which is fine for grepping and useless for both a human
    reader and a printed appendix."""
    print("\n--- %s ---" % label)
    items = obj if isinstance(obj, (list, tuple)) else [obj]
    for x in items:
        s = str(x)
        if len(s) <= 96:
            print("   ", s)
        else:
            for line in wrapped(s):
                print("        " + line)

print("=" * 78)
print("GROUND TRUTH under S = diag(-1,-1,1).  Any literal coefficient 2 below would be")
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
             ["row1 = S(w_%d) = %s" % (k - 1, list(Sv(ws[k - 1], R))),
              "row2 = v_%d    = %s" % (k, list(v[k - 1]))])
    # sanity: the components of w_k really are the 2x2 minors of that matrix
    if k >= 3:
        M = matrix(R, [list(Sv(ws[k - 1], R)), list(v[k - 1])])
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
        # split as the lemma does: [ -[v_3]x S J_2 | [S(w_2)]x ]
        print("\n    first block  -[v_3]x S J_2  (3x6):")
        R3, v3 = R, v
        ws2 = w_upto(2, R3, v3)
        J2 = jacobian(vector(R3, list(ws2[2])), R3.gens()[:6])
        def crossmat(u):
            return matrix(R3, [[0, -u[2], u[1]], [u[2], 0, -u[0]], [-u[1], u[0], 0]])
        Smat = diagonal_matrix(R3, [-1, -1, 1])
        blk1 = -crossmat(v3[2]) * Smat * J2
        for i in range(3):
            print("      ", list(blk1[i]))
        print("\n    second block  [S(w_2)]x  (3x3):")
        blk2 = crossmat(Sv(ws2[2], R3))
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
print("    S(w_2)   =", [x.subs(sub) for x in Sv(ws[2], R)])

# ---- P_j : vanishing ideal of Y_2 at parameter j ---------------------------
def P(j):
    """Eliminate lam from  v_j - lam * S(w_{j-1}(p)).

    The local ring is Rj, not S: S now names the sign twist."""
    names = ['v%d_%d' % (i, c) for i in range(1, j + 1) for c in range(1, 4)] + ['lam']
    Rj = PolynomialRing(QQ, names, order='degrevlex')
    gs = Rj.gens()
    vv = [vector(Rj, gs[3 * i:3 * i + 3]) for i in range(j)]
    lam = gs[-1]
    wsS = {2: vv[0].cross_product(vv[1])}
    for t in range(3, j):
        wsS[t] = vector(Rj, [-wsS[t-1][0], -wsS[t-1][1], wsS[t-1][2]]).cross_product(vv[t-1])
    prev = wsS[j - 1] if j >= 3 else vv[0].cross_product(vv[1])
    Sprev = vector(Rj, [-prev[0], -prev[1], prev[2]])
    I = Rj.ideal([vv[j-1][c] - lam * Sprev[c] for c in range(3)])
    return I.elimination_ideal([lam])

for j in (3, 4):
    print("\n--- P_%d generators (Y_2's ideal at parameter %d) ---" % (j, j))
    for gpoly in P(j).groebner_basis():
        for line in wrapped(gpoly):
            print("        " + line)

# ===========================================================================
# APPENDIX BLOCKS (added 2026-09-03).  Everything below feeds the article's
# appendix directly, one block per item on Jan's revision list.
# ===========================================================================

# ---- A1: both sides of Theorem 1's identity, and its chained k=3 form ------
# revisions.org, l91.  The triple Jan pasted is the TRIPLE commutator
# enc([[A,B],C]), not Theorem 1's own two-matrix identity, so both are printed
# and the article can display whichever it means.  Expanded in the free matrix
# entries -- where factors of 2 are legitimate and expected, since d_a = a11-a22
# = 2*a11 on the traceless part.  That is a DIFFERENT claim from "coefficients
# are +-1", which is about the v-coordinates.  Conflating the two is exactly the
# confusion this block exists to settle.
print("\n" + "=" * 78)
print("A1.  Theorem 1's identity, both sides, in the free matrix entries")
print("=" * 78)
Rm = PolynomialRing(QQ, ['a11', 'a12', 'a21', 'a22', 'b11', 'b12', 'b21', 'b22',
                         'c11', 'c12', 'c21', 'c22'])
ga = Rm.gens()
A = matrix(Rm, [[ga[0], ga[1]], [ga[2], ga[3]]])
B = matrix(Rm, [[ga[4], ga[5]], [ga[6], ga[7]]])
C = matrix(Rm, [[ga[8], ga[9]], [ga[10], ga[11]]])

def enc(M):
    return vector(Rm, [M[0, 0] - M[1, 1], M[0, 1] + M[1, 0], M[0, 1] - M[1, 0]])

def Sm(u):
    return vector(Rm, [-u[0], -u[1], u[2]])

def br(X, Y):
    return X * Y - Y * X

lhs2 = enc(br(A, B))
rhs2 = Sm(enc(A).cross_product(enc(B)))
print("\n--- k=2:  enc([A,B])   vs   S(enc(A) x enc(B)) ---")
for i in range(3):
    show_poly("lhs_%d" % (i + 1), lhs2[i])
    show_poly("rhs_%d" % (i + 1), rhs2[i])
print("    difference:", tuple(lhs2 - rhs2))
assert lhs2 == rhs2

lhs3 = enc(br(br(A, B), C))
rhs3 = Sm(Sm(enc(A).cross_product(enc(B))).cross_product(enc(C)))
print("\n--- k=3:  enc([[A,B],C])   vs   S(S(enc(A) x enc(B)) x enc(C)) ---")
print("    (this is the triple pasted at revisions.org l91)")
for i in range(3):
    show_poly("lhs_%d" % (i + 1), lhs3[i])
print("    difference from the recursion:", tuple(lhs3 - rhs3))
print("    terms per component:", [len(p.monomials()) for p in lhs3])
assert lhs3 == rhs3

# ---- A2: Remark 2's three checked-but-unshown assertions ------------------
print("\n" + "=" * 78)
print("A2.  Remark 2's three computational assertions")
print("=" * 78)
A0 = A - (A.trace() / 2) * matrix.identity(Rm, 2)
ee = enc(A0)
print("\n--- the Lorentzian form:  -enc_1^2 - enc_2^2 + enc_3^2 = 4 det(A_0) ---")
print("    lhs - 4*det(A_0) =", (-ee[0]^2 - ee[1]^2 + ee[2]^2) - 4 * A0.det())
print("\n--- S is an involution; tau is not ---")
Smat = diagonal_matrix(QQ, [-1, -1, 1])
taumat = matrix(QQ, [[0, 1, 0], [1, 0, 0], [0, 0, 2]])
print("    S     =", Smat.list(), "  det =", Smat.det())
print("    S^2   =", (Smat * Smat).list(), "  (= identity)")
print("    tau   =", taumat.list(), "  det =", taumat.det())
print("    tau^2 =", (taumat * taumat).list(), "  (= diag(1,1,4), NOT the identity)")
print("\n--- over F_3, diag(-1,-1,1) is congruent to the identity form ---")
print("    so \"-1 is not a square\" is not the right criterion; formal reality is.")
F3 = GF(3)
T = matrix(F3, [[0, 0, 1], [1, 1, 0], [1, 2, 0]])
print("    T             =", T.list(), "  det =", T.det())
print("    T^t * T       =", (T.transpose() * T).list())
print("    diag(-1,-1,1) =", diagonal_matrix(F3, [-1, -1, 1]).list())
print("    equal:", T.transpose() * T == diagonal_matrix(F3, [-1, -1, 1]))

# ---- A3: I_6's three generators -------------------------------------------
# revisions.org, Section 4: "is not *that* enormous, write it out, table, small
# font".  The version pasted there carries coefficients +-1, +-2 and +-4, which
# is tau-era output; under S every coefficient is +-1.  The assert at the end is
# the guard against that ever silently coming back.
print("\n" + "=" * 78)
print("A3.  The three generators of I_6, under S")
print("=" * 78)
R6, v6 = setup(6)
ws6 = w_upto(6, R6, v6)
for i in range(3):
    show_poly("w_6,%d" % (i + 1), ws6[6][i])
allc = sorted(set(abs(c) for p in ws6[6] for c in p.coefficients()))
print("\n    terms per generator:", [len(p.monomials()) for p in ws6[6]])
print("    degree:              %d in %d variables" % (ws6[6][0].degree(), 18))
print("    |coefficients| used:", allc,
      "<- must be [1]; anything else is tau-era output creeping back")
assert allc == [1], "coefficient other than +-1 at k=6: the encoding is wrong"

print("\n" + "=" * 78)
print("done")
