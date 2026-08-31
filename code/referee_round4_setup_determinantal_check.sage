# 2026-08-30 (Claude, referee round 4): independent verification of the Setup and
#   determinantal-structure sections (article lines ~405-687) after today's merge of the
#   red/tau and enc/D source versions. Checks, numerically/symbolically:
#   (A) thm-basic-identity: enc([A,B]) = D(enc(A) x enc(B)), symbolically over ZZ, and
#       whether it also holds over GF(2) (bearing on where char != 2 is actually spent);
#   (B) consistency of def-wk: enc([A_1,...,A_k]) = D(w_k(enc(A_1),...,enc(A_k))) at k=3,4;
#   (C) the remark's premise: red([A,B]) = tau(red(A) x red(B)) for red=(a12,a21,d_a),
#       tau(a,b,c)=(b,a,2c);
#   (D) Sylvester claim: -enc_1^2 - enc_2^2 + enc_3^2 = 4 det(A_0);
#   (E) raw encoding (x,y,z): the twist it forces (claimed: a swap AND two factors of 2);
#   (F) manuscript displays: w_3 (all three), w_4 (first component), Thm6-example matrices
#       at k=3 and k=4, transcribed literally from the .typ and diffed against the recursion;
#   (G) the tau-twisted w_3 really has a coefficient 2 (line ~517's "unlike ..." claim);
#   (H) thm-determinantal: ideal of 2x2 minors of [D(w_{k-1}); v_k] == I_k, k=2..5;
#   (I) lem-mingens-indep corroboration: coefficient-matrix rank 3 at k=2..6; deg w_k = k;
#       base-case private monomials;
#   (J) tau^2 = diag(1,1,4), det tau = -2, D^2 = I, det D = 1;
#   (K) the remark's Sylvester overreach: over GF(3) (-1 not a square), is
#       -x^2-y^2+z^2 equivalent to x^2+y^2+z^2? (If yes, the "over a field where -1 is
#       not a square" criterion is false as a general-field statement.)
# Output: runs/referee-round4-setup-determinantal.txt

import sys

results = []
def check(label, ok):
    results.append((label, ok))
    print(("PASS " if ok else "FAIL ") + label)

# ---------- (A) basic identity over ZZ and GF(2) ----------
for base, name in [(ZZ, "ZZ"), (GF(2), "GF(2)")]:
    R = PolynomialRing(base, ['a11','a12','a21','a22','b11','b12','b21','b22'])
    a11,a12,a21,a22,b11,b12,b21,b22 = R.gens()
    A = matrix(R,2,2,[a11,a12,a21,a22]); B = matrix(R,2,2,[b11,b12,b21,b22])
    def enc(M): return vector(R,[M[0,0]-M[1,1], M[0,1]+M[1,0], M[0,1]-M[1,0]])
    def cross(p,q): return vector(R,[p[1]*q[2]-p[2]*q[1], p[2]*q[0]-p[0]*q[2], p[0]*q[1]-p[1]*q[0]])
    Dm = matrix(base,3,3,[[-1,0,0],[0,-1,0],[0,0,1]])
    lhs = enc(A*B-B*A); rhs = Dm*cross(enc(A),enc(B))
    check("(A) enc([A,B]) == D(enc(A) x enc(B)) over %s" % name, lhs == rhs)

# ---------- (B) def-wk consistency: enc([...[A1,A2],...,Ak]) = D(w_k(enc(A_i))) ----------
for k in [3,4]:
    names = []
    for i in range(1,k+1):
        names += ['x%d_%d' % (i,j) for j in range(4)]
    R = PolynomialRing(QQ, names)
    g = R.gens()
    mats = [matrix(R,2,2,list(g[4*i:4*i+4])) for i in range(k)]
    def enc(M): return vector(R,[M[0,0]-M[1,1], M[0,1]+M[1,0], M[0,1]-M[1,0]])
    def cross(p,q): return vector(R,[p[1]*q[2]-p[2]*q[1], p[2]*q[0]-p[0]*q[2], p[0]*q[1]-p[1]*q[0]])
    Dm = matrix(QQ,3,3,[[-1,0,0],[0,-1,0],[0,0,1]])
    # left-nested iterated commutator
    C = mats[0]
    for M in mats[1:]:
        C = C*M - M*C
    # w_k recursion evaluated at v_i = enc(A_i)
    vs = [enc(M) for M in mats]
    w = cross(vs[0], vs[1])
    for j in range(2,k):
        w = cross(Dm*w, vs[j])
    check("(B) enc([A_1,...,A_%d]) == D(w_%d(enc(A_i))) " % (k,k), enc(C) == Dm*w)

# ---------- (C) red/tau identity ----------
R = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22'])
a11,a12,a21,a22,b11,b12,b21,b22 = R.gens()
A = matrix(R,2,2,[a11,a12,a21,a22]); B = matrix(R,2,2,[b11,b12,b21,b22])
def red(M): return vector(R,[M[0,1], M[1,0], M[0,0]-M[1,1]])
def crossR(p,q): return vector(R,[p[1]*q[2]-p[2]*q[1], p[2]*q[0]-p[0]*q[2], p[0]*q[1]-p[1]*q[0]])
tau = matrix(QQ,3,3,[[0,1,0],[1,0,0],[0,0,2]])
check("(C) red([A,B]) == tau(red(A) x red(B))", red(A*B-B*A) == tau*crossR(red(A),red(B)))

# ---------- (D) Sylvester / Killing-form claim ----------
Rt = PolynomialRing(QQ, ['a11','a12','a21','a22'])
a11,a12,a21,a22 = Rt.gens()
A = matrix(Rt,2,2,[a11,a12,a21,a22])
e1 = a11-a22; e2 = a12+a21; e3 = a12-a21
# det of the traceless part A0 = A - (tr/2)I: det(A0) = -(d/2)^2 - a12*a21 with d = a11-a22.
detA0 = -( (a11-a22)/2 )**2 - a12*a21
check("(D) -enc1^2 - enc2^2 + enc3^2 == 4 det(A_0)", -e1**2 - e2**2 + e3**2 == 4*detA0)

# ---------- (E) raw encoding's forced twist ----------
Rw = PolynomialRing(QQ, ['x','y','z','u','v','w'])
x,y,z,u,v,w = Rw.gens()
A0 = matrix(Rw,2,2,[x,y,z,-x]); B0 = matrix(Rw,2,2,[u,v,w,-u])
Cm = A0*B0 - B0*A0
rawC = vector(Rw,[Cm[0,0], Cm[0,1], Cm[1,0]])   # (x,y,z)-reading of the commutator
p = vector(Rw,[y*w-z*v, z*u-x*w, x*v-y*u])      # raw(A0) x raw(B0)
E = matrix(QQ,3,3,[[1,0,0],[0,0,2],[0,2,0]])    # swap of coords 2,3 with two factors of 2
check("(E) raw([A0,B0]) == E(raw x raw), E = swap(2,3) * diag(1,2,2)", rawC == E*p)

# ---------- shared setup for (F)-(I): the w_k recursion in v-variables ----------
def build(k):
    names = []
    for i in range(1,k+1):
        names += ['v%d_1'%i, 'v%d_2'%i, 'v%d_3'%i]
    Rk = PolynomialRing(QQ, names)
    g = Rk.gens()
    vs = [vector(Rk, g[3*i:3*i+3]) for i in range(k)]
    Dm = matrix(QQ,3,3,[[-1,0,0],[0,-1,0],[0,0,1]])
    def crossk(p,q): return vector(Rk,[p[1]*q[2]-p[2]*q[1], p[2]*q[0]-p[0]*q[2], p[0]*q[1]-p[1]*q[0]])
    ws = [None, None, crossk(vs[0], vs[1])]     # ws[j] = w_j
    for j in range(3, k+1):
        ws.append(crossk(Dm*ws[j-1], vs[j-1]))
    return Rk, vs, ws, Dm, crossk

# ---------- (F) manuscript displays, transcribed literally ----------
Rk, vs, ws, Dm, crossk = build(4)
v1_1,v1_2,v1_3,v2_1,v2_2,v2_3,v3_1,v3_2,v3_3,v4_1,v4_2,v4_3 = Rk.gens()
# ex-wk-signed, w_2 (article lines ~512-513)
m_w2 = [v1_2*v2_3-v1_3*v2_2, v1_3*v2_1-v1_1*v2_3, v1_1*v2_2-v1_2*v2_1]
check("(F) manuscript w_2 display", list(ws[2]) == m_w2)
# ex-wk-signed, w_3 (article lines ~518-520)
m_w3 = [ v1_2*v2_1*v3_2 - v1_1*v2_2*v3_2 - v1_3*v2_1*v3_3 + v1_1*v2_3*v3_3,
        -v1_2*v2_1*v3_1 + v1_1*v2_2*v3_1 - v1_3*v2_2*v3_3 + v1_2*v2_3*v3_3,
         v1_3*v2_1*v3_1 - v1_1*v2_3*v3_1 + v1_3*v2_2*v3_2 - v1_2*v2_3*v3_2 ]
check("(F) manuscript w_3 display (all three components)", list(ws[3]) == m_w3)
# ex-wk-signed, w_4 first component (article lines ~523-526)
m_w41 = (-v1_3*v2_1*v3_1*v4_2 + v1_1*v2_3*v3_1*v4_2 - v1_3*v2_2*v3_2*v4_2 + v1_2*v2_3*v3_2*v4_2
         + v1_2*v2_1*v3_1*v4_3 - v1_1*v2_2*v3_1*v4_3 + v1_3*v2_2*v3_3*v4_3 - v1_2*v2_3*v3_3*v4_3)
check("(F) manuscript w_4 first component", ws[4][0] == m_w41)
# Thm6 example, k=3 first row D(w_2) (article lines ~594-597)
m_row_k3 = [ v1_3*v2_2-v1_2*v2_3, -v1_3*v2_1+v1_1*v2_3, -v1_2*v2_1+v1_1*v2_2 ]
check("(F) Thm6-example k=3 first row == D(w_2)", list(Dm*ws[2]) == m_row_k3)
# Thm6 example, k=4 first row, first entry (article line ~600)
m_row_k4_1 = -v1_2*v2_1*v3_2 + v1_1*v2_2*v3_2 + v1_3*v2_1*v3_3 - v1_1*v2_3*v3_3
check("(F) Thm6-example k=4 first row, first entry == (D w_3)_1", (Dm*ws[3])[0] == m_row_k4_1)
# all displayed coefficients +-1 (claim in ex-wk-signed and prob-char2)
allpm1 = all(all(c in [1,-1] for c in poly.coefficients()) for j in [2,3,4] for poly in ws[j])
check("(F) all coefficients of w_2,w_3,w_4 are +-1", allpm1)

# ---------- (G) tau-twisted w_3 really has a coefficient 2 ----------
tau3 = matrix(QQ,3,3,[[0,1,0],[1,0,0],[0,0,2]])
w3_tau = crossk(tau3*ws[2], vs[2])
has2 = any(abs(c) == 2 for poly in w3_tau for c in poly.coefficients())
check("(G) tau-twisted w_3 contains a coefficient +-2", has2)

# ---------- (H) thm-determinantal: minors ideal == I_k, k=2..6 ----------
for k in range(2,7):
    Rk, vs, ws, Dm, crossk = build(k)
    if k == 2:
        row1 = vs[0]
    else:
        row1 = Dm*ws[k-1]
    row2 = vs[k-1]
    M = matrix(Rk, [list(row1), list(row2)])
    minors = M.minors(2)
    Ik = Rk.ideal(list(ws[k]))
    Im = Rk.ideal(minors)
    check("(H) k=%d: ideal(2x2 minors of [row1; v_k]) == I_k" % k, Ik == Im)

# ---------- (I) generator independence and degrees ----------
for k in range(2,7):
    Rk, vs, ws, Dm, crossk = build(k)
    mons = sorted(set(m for poly in ws[k] for m in poly.monomials()))
    Mcoef = matrix(QQ, [[poly.monomial_coefficient(m) for m in mons] for poly in ws[k]])
    check("(I) k=%d: coefficient matrix rank == 3" % k, Mcoef.rank() == 3)
    check("(I) k=%d: components homogeneous of degree k" % k,
          all(poly.is_homogeneous() and poly.degree() == k for poly in ws[k]))
# base-case private monomials (lem-mingens-indep)
Rk, vs, ws, Dm, crossk = build(2)
v1_1,v1_2,v1_3,v2_1,v2_2,v2_3 = Rk.gens()
priv = [(v1_2*v2_3, 0), (v1_3*v2_1, 1), (v1_1*v2_2, 2)]
ok = all(all((m in ws[2][j].monomials()) == (j == owner) for j in range(3)) for m, owner in priv)
check("(I) base case: each private monomial occurs in exactly its own component", ok)

# ---------- (J) tau and D bookkeeping ----------
check("(J) tau^2 == diag(1,1,4)", tau3**2 == matrix(QQ,3,3,[[1,0,0],[0,1,0],[0,0,4]]))
check("(J) det tau == -2", tau3.det() == -2)
Dm = matrix(QQ,3,3,[[-1,0,0],[0,-1,0],[0,0,1]])
check("(J) D^2 == I and det D == 1", Dm**2 == identity_matrix(3) and Dm.det() == 1)

# ---------- (K) GF(3): -x^2-y^2+z^2 vs x^2+y^2+z^2 ----------
F3 = GF(3)
G1 = matrix(F3,3,3,[[-1,0,0],[0,-1,0],[0,0,1]])   # Gram of -x^2-y^2+z^2
G2 = identity_matrix(F3,3)                          # Gram of x^2+y^2+z^2
found = None
import itertools
for entries in itertools.product(F3, repeat=9):
    T = matrix(F3,3,3,list(entries))
    if T.is_invertible() and T.transpose()*G2*T == G1:
        found = T
        break
check("(K) over GF(3) (-1 NOT a square) the two forms ARE equivalent (T found)", found is not None)
if found is not None:
    print("    witness T =", found.rows())
    print("    -1 a square in GF(3)?", F3(-1).is_square())

print()
nfail = sum(1 for _, ok in results if not ok)
print("TOTAL: %d checks, %d failed" % (len(results), nfail))
