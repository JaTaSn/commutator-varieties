# 2026-08-16 (Claude-Code-opus-subagent): the base identity underpinning Step 0 of
# working-notes/proof-plan-conjectures.org, checked as a polynomial identity in generic entries
# rather than only as an ideal equality at k = 2..6.
#
# Write red(A) := (a12, a21, a11 - a22) for a 2x2 matrix A (the "reduced traceless coordinates").
# Claim:      red([A,B]) = tau( red(A) x red(B) ),      tau(a,b,c) = (b, a, 2c).
# Both sides are vectors of polynomials in the 8 generic entries; the check below is a genuine
# identity of polynomials (all three coordinates identically zero after subtraction), which is what
# makes the k-fold statement  red([A_1,...,A_k]) = tau(w_k)  a two-line induction valid for EVERY k,
# instead of a pattern confirmed only up to k = 6.

R = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22'])
a11,a12,a21,a22,b11,b12,b21,b22 = R.gens()

A = matrix(R, 2, 2, [a11,a12,a21,a22])
B = matrix(R, 2, 2, [b11,b12,b21,b22])
C = A*B - B*A

def red(M):
    return (M[0,1], M[1,0], M[0,0] - M[1,1])

def cross(p,q):
    return (p[1]*q[2]-p[2]*q[1], p[2]*q[0]-p[0]*q[2], p[0]*q[1]-p[1]*q[0])

def tau(a):
    return (a[1], a[0], 2*a[2])

lhs = red(C)
rhs = tau(cross(red(A), red(B)))
diff = tuple(l - r for l, r in zip(lhs, rhs))

print("red([A,B])            =", lhs)
print("tau(red(A) x red(B))  =", rhs)
print("difference            =", diff)
print("identity holds as polynomials in the 8 generic entries?", all(d == 0 for d in diff))

# Sanity: [A,B] really is traceless, so red() loses nothing (its three coordinates determine it).
print("trace([A,B]) == 0?", C.trace() == 0)

# tau is invertible over QQ (needed so that ideal(entries of tau(w_k)) == ideal(entries of w_k)).
T = matrix(QQ, 3, 3, [[0,1,0],[1,0,0],[0,0,2]])
print("tau as a matrix:\n", T)
print("det(tau) =", T.det(), "-- invertible over any field of characteristic != 2")
