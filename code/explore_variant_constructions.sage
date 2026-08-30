# 2026-08-20 (Claude): exploratory verification for
# working-notes/variant-constructions-product-and-central.org -- Jan asked about two variants of
# the k-fold iterated commutator, still for 2x2 matrices:
#   (A) the PRODUCT of n disjoint pairwise commutators, [A1,A2]*[A3,A4]*...*[A_{2n-1},A_{2n}]
#       (ordinary associative matrix multiplication, not a further Lie bracket);
#   (B) a "central"/balanced iterated commutator -- recursively bracket PAIRS of sub-results,
#       building a balanced binary tree, e.g. C_2 := [[A1,A2],[A3,A4]], rather than the article's
#       existing left-normed chain [[[A1,A2],A3],A4].
# Everything here is checked as a genuine polynomial identity in generic matrix entries, not
# sampled points, matching this project's own house style.

# --- Shared machinery: the signed encoding enc()/D() from the alternative-encodings note --------
# enc(A) := (a11-a22, a12+a21, a12-a21);  psi is its inverse on traceless matrices.
def enc(M):
    return vector([M[0,0]-M[1,1], M[0,1]+M[1,0], M[0,1]-M[1,0]])

def psi(R, e):
    return matrix(R, 2, 2, [e[0]/2, (e[1]+e[2])/2, (e[1]-e[2])/2, -e[0]/2])

D = matrix(QQ, 3, 3, [[-1,0,0],[0,-1,0],[0,0,1]])

R8 = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22'])
a11,a12,a21,a22,b11,b12,b21,b22 = R8.gens()
A = matrix(R8,2,2,[a11,a12,a21,a22]); B = matrix(R8,2,2,[b11,b12,b21,b22])
A0 = A - (A.trace()/2)*identity_matrix(R8,2)
B0 = B - (B.trace()/2)*identity_matrix(R8,2)

print("=" * 70)
print("Sanity: psi(enc(A0)) == A0 (round trip), and base bracket identity")
print("=" * 70)
print("psi(enc(A0)) == A0 ?", psi(R8, enc(A0)) == A0)
lhs = enc(A0*B0 - B0*A0)
rhs = D * enc(A0).cross_product(enc(B0))
print("enc([A,B]) == D(enc(A) x enc(B)) ?", (lhs - rhs) == 0)

# ==================================================================================================
# Construction A: the PRODUCT of pairwise commutators
# ==================================================================================================
print()
print("=" * 70)
print("Construction A: psi(a)*psi(b) for generic a,b in F^3 (a plain matrix product,")
print("NOT a further commutator) -- trace, traceless part, and the twist needed to relate")
print("the traceless part back to cross(a,b).")
print("=" * 70)

Rv = PolynomialRing(QQ, ['a1','a2','a3','b1','b2','b3'])
a1,a2,a3,b1,b2,b3 = Rv.gens()
avec = vector(Rv, [a1,a2,a3]); bvec = vector(Rv, [b1,b2,b3])
Xa = psi(Rv, avec); Xb = psi(Rv, bvec)
P = Xa * Xb
print("psi(a)*psi(b) =\n", P)
tr = P.trace()
print("trace(psi(a)*psi(b)) =", tr)

# Compare to the D-twisted quadratic form's bilinear polarization: B(a,b) := -a1*b1-a2*b2+a3*b3
Bform = -a1*b1 - a2*b2 + a3*b3
print("bilinear form B(a,b) = -a1 b1 - a2 b2 + a3 b3 =", Bform)
print("trace(psi(a)psi(b)) == 2*B(a,b) ?", (tr - 2*Bform) == 0)

P0 = P - (tr/2)*identity_matrix(Rv,2)
print("traceless part of psi(a)*psi(b):\n", P0)
enc_P0 = enc(P0)
print("enc(traceless part) =", enc_P0)
cross_ab = avec.cross_product(bvec)
print("cross(a,b) =", cross_ab)
# Discovered relation: enc(traceless part) == (1/2) * D(cross(a,b)) -- the SAME twist D as the
# commutator identity, just scaled by 1/2 (no swap, no extra sign pattern needed).
D_Rv = D.change_ring(Rv)
half_D_cross = (D_Rv * cross_ab) / 2
print("(1/2) D(cross(a,b)) =", half_D_cross)
print("enc(traceless part of psi(a)psi(b)) == (1/2) D(cross(a,b)) ?", (enc_P0 - half_D_cross) == 0)

# ==================================================================================================
# Construction A, n=2: characterizing exactly when psi(w1)*psi(w2) = 0.
#
# psi(w) is nilpotent (rank <= 1, psi(w)^2 = 0) exactly when Q(w) := -w1^2-w2^2+w3^2 = 0 (the
# "isotropic cone" from the alternative-encodings note -- Q(w) = 4 det(psi(w)), trace is always 0).
# A nonzero rank-1 nilpotent 2x2 matrix N always has ker(N) = im(N) (both 1-dimensional, and
# N^2=0 forces im(N) subset ker(N), so equality by dimension) -- and N is determined, up to
# scalar, by that single common line (N = v (x) phi_v, phi_v the essentially unique covector with
# phi_v(v)=0). So w |-> (that line) is an INJECTIVE map from the projectivized isotropic cone to
# P^1 -- elementary linear algebra, no field hypothesis needed. Consequence, checked below both
# ways: psi(w1)*psi(w2) = 0 with w1, w2 BOTH nonzero forces w1, w2 to be proportional (and both
# isotropic) -- two genuinely different isotropic vectors can NEVER be a nontrivial zero-divisor
# pair, contrary to the naive "kernel/image alignment" expectation.
# ==================================================================================================
print()
print("=" * 70)
print("Construction A: exactly when does psi(w1)*psi(w2) = 0, for w1, w2 both nonzero?")
print("=" * 70)

w1 = vector(QQ, [3,4,5])   # isotropic: Q = -9-16+25 = 0
w2 = vector(QQ, [0,1,1])   # isotropic: Q = -0-1+1 = 0, NOT proportional to w1
Psi1, Psi2 = psi(QQ, w1), psi(QQ, w2)
print("w1 =", w1, " Q(w1) =", -w1[0]^2-w1[1]^2+w1[2]^2, " psi(w1)^2 == 0 ?", Psi1*Psi1 == 0)
print("w2 =", w2, " Q(w2) =", -w2[0]^2-w2[1]^2+w2[2]^2, " psi(w2)^2 == 0 ?", Psi2*Psi2 == 0)
print("Two DIFFERENT (non-proportional) isotropic vectors:")
print("  psi(w1)*psi(w2) =", (Psi1*Psi2).list(), " -- zero?", Psi1*Psi2 == 0)
print("  psi(w2)*psi(w1) =", (Psi2*Psi1).list(), " -- zero?", Psi2*Psi1 == 0)
print("  (both nonzero -- confirms non-proportional isotropic vectors can NOT be a zero-divisor pair)")
print()
w2_prop = 5*w1   # proportional to w1, still isotropic (Q is homogeneous of degree 2)
Psi2_prop = psi(QQ, w2_prop)
print("A PROPORTIONAL pair instead: w2' = 5*w1 =", w2_prop)
print("  psi(w1)*psi(5*w1) =", (Psi1*Psi2_prop).list(), " -- zero?", Psi1*Psi2_prop == 0)
print()
print("Conclusion: away from the trivial components {w1=0} and {w2=0}, the vanishing locus of")
print("psi(w1)*psi(w2) is exactly {w2 = lambda*w1, Q(w1)=0} -- a single 1-parameter family sitting")
print("inside the isotropic cone, NOT some larger/messier kernel-alignment variety.")

# ==================================================================================================
# Construction B: the "central"/balanced iterated commutator, C_2 := [[A1,A2],[A3,A4]]
# ==================================================================================================
print()
print("=" * 70)
print("Construction B: C_2 := [[A1,A2],[A3,A4]] (balanced/central), vs. the article's own")
print("left-normed chain [[A1,A2],A3],A4]. Verify the balanced version stays entirely inside")
print("the reduced/enc coordinates: enc(C_2) = D( D(v1 x v2) x D(v3 x v4) ).")
print("=" * 70)

R16 = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22',
                           'c11','c12','c21','c22','d11','d12','d21','d22'])
g = R16.gens()
A1 = matrix(R16,2,2,g[0:4]);  A2 = matrix(R16,2,2,g[4:8])
A3 = matrix(R16,2,2,g[8:12]); A4 = matrix(R16,2,2,g[12:16])

def comm(X,Y):
    return X*Y - Y*X

C2_direct = comm(comm(A1,A2), comm(A3,A4))
print("trace(C2) == 0 ?", C2_direct.trace() == 0)

v1, v2, v3, v4 = enc(A1), enc(A2), enc(A3), enc(A4)
D_R16 = D.change_ring(R16)
c1 = D_R16 * v1.cross_product(v2)     # enc([A1,A2])
c2 = D_R16 * v3.cross_product(v4)     # enc([A3,A4])
enc_C2_formula = D_R16 * c1.cross_product(c2)   # enc([[A1,A2],[A3,A4]])

enc_C2_direct = enc(C2_direct)
print("enc(C2) via direct matrix computation  == enc(C2) via D(D(v1xv2) x D(v3xv4)) formula ?",
      (enc_C2_direct - enc_C2_formula) == 0)

# Compare to the article's OWN left-normed chain at k=4, [[[A1,A2],A3],A4], to make the contrast
# concrete: same 4 matrices, genuinely different polynomial map.
w2 = v1.cross_product(v2)             # article's own w_2 (no D at the base stage)
w3 = (D_R16 * w2).cross_product(v3)   # article's own w_3
w4 = (D_R16 * w3).cross_product(v4)   # article's own w_4 (left-normed chain, signed encoding)
print("Left-normed w_4 == balanced enc(C_2) ? (expect False -- genuinely different constructions)",
      (w4 - enc_C2_formula) == 0)
