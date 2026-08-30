# 2026-08-19 (Claude): checking a candidate alternative to red()/tau() (see
# code/verify_tau_cross_identity.sage) prompted by Jan's request to explore other ways to encode a
# traceless 2x2 matrix as a triple in FF^3.
#
# Candidate encoding:  enc(A) := (a11 - a22, a12 + a21, a12 - a21)   [no division needed to compute]
# Candidate claim:     enc([A,B]) = D( enc(A) x enc(B) ),   D := diag(-1,-1,1)
# i.e. the SAME cross product as before, just post-composed with a fixed sign-diagonal involution
# instead of red()/tau()'s coordinate-swap-plus-times-2. Checked here as a genuine polynomial
# identity in the 8 generic entries, exactly as verify_tau_cross_identity.sage did for the original
# encoding -- not merely at small numeric/random points.
#
# Also checked: whether the SAME D works uniformly when chaining (composing enc([A,B]) with C, i.e.
# enc([[A,B],C]) = D(enc([A,B]) x enc(C))) with NO extra correction map needed at the second stage --
# this is the a-priori nonobvious claim that would make the recursion strictly simpler than the
# tau-based one (which reapplies tau at every stage, see def-wk's own remark on why that's needed).

R = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22','c11','c12','c21','c22'])
a11,a12,a21,a22,b11,b12,b21,b22,c11,c12,c21,c22 = R.gens()

A = matrix(R, 2, 2, [a11,a12,a21,a22])
B = matrix(R, 2, 2, [b11,b12,b21,b22])
C = matrix(R, 2, 2, [c11,c12,c21,c22])

def enc(M):
    return (M[0,0]-M[1,1], M[0,1]+M[1,0], M[0,1]-M[1,0])

def cross(p, q):
    return (p[1]*q[2]-p[2]*q[1], p[2]*q[0]-p[0]*q[2], p[0]*q[1]-p[1]*q[0])

D = matrix(QQ, 3, 3, [[-1,0,0],[0,-1,0],[0,0,1]])

def apply_D(v):
    return tuple((D * vector(R, v)).list())

# --- Step 1: base identity, single bracket -----------------------------------
AB = A*B - B*A
lhs = enc(AB)
rhs = apply_D(cross(enc(A), enc(B)))
diff = tuple(l - r for l, r in zip(lhs, rhs))
print("enc([A,B])            =", lhs)
print("D(enc(A) x enc(B))    =", rhs)
print("difference            =", diff)
print("base identity holds as polynomials?", all(d == 0 for d in diff))

# D is an involution -- a genuine structural difference from tau (whose square is diag(1,1,4), not
# the identity).
print()
print("D =\n", D)
print("D^2 =\n", D*D)
print("D^2 == identity?", D*D == identity_matrix(QQ, 3))
print("det(D) =", D.det())

# --- Step 2: chaining, k=3 (the actual triple commutator [[A,B],C]) ----------
# Test the CANDIDATE recursion w_2 := enc(A) x enc(B) [no D needed on the raw cross product itself --
# see below], w_3 := D(w_2) x enc(C), against the TRUE enc([[A,B],C]) computed directly from the
# matrices. If this matches, D need only be inserted once per NEW stage, exactly mirroring tau's own
# recursive role in the current article -- worth knowing precisely, since a priori it could have
# needed no D at all (if D happened to be self-cancelling across stages) or a DIFFERENT correction
# at each stage (which would be no improvement over tau).
ABC = AB*C - C*AB
lhs3 = enc(ABC)

w2 = cross(enc(A), enc(B))          # raw cross product, no D
w3_candidate = apply_D(cross(apply_D(w2), enc(C)))
diff3 = tuple(l - r for l, r in zip(lhs3, w3_candidate))
print()
print("enc([[A,B],C])                    =", lhs3)
print("D( D(w2) x enc(C) )  [recursion]  =", w3_candidate)
print("difference                        =", diff3)
print("k=3 recursion (apply D at each new stage) holds?", all(d == 0 for d in diff3))

# --- Step 3: does the recursion even need the FIRST D (i.e. is w_2 itself already fine unadorned,
# matching how the current article's w_2 := v_1 x v_2 also carries no outer tau)? Test the leaner
# candidate w_3 := D(w2) x enc(C) directly (this is exactly what Step 2 already tested, restated for
# clarity): the SAME single fixed involution D reappears once per bracket stage after the first, just
# like tau does now -- no simplification of the recursion's *shape*, only of the linear map itself
# (an involution instead of a swap-plus-times-2).
print()
print("(Step 3 is the same check as Step 2, restated: D reapplies once per new stage, same shape as")
print(" the tau recursion, but D is simpler as a map: an involution, not swap+scale.)")
