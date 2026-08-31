# Changelog
# 2026-08-31 (Claude-Code-jts-pc): REWRITTEN for the signed encoding.  Referee round 4 found that
#   this file was entirely tau-era -- it implemented w_j = tau(w_{j-1}) x v_j with
#   tau(a,b,c)=(b,a,2c), contained no D anywhere, and (worse) defined a minors2x3 helper that it
#   never called, so it did not check the minors claim even for tau.  Yet the proof of
#   thm-determinantal cited it as the independent check of the theorem, and the following example
#   cited it for matrix rows "displayed in full" that it never printed.  Both citations were
#   therefore false.  This rewrite makes them true: it checks the actual theorem under
#   D = diag(-1,-1,1), and prints the rows.
# 2026-08-16 (Claude): original tau-era version.
#
# What is checked:
#   [1] THE THEOREM.  I_k = ideal of the 2x2 minors of the 2x3 matrix [D(w_{k-1}) ; v_k], for
#       k = 2..6, by Groebner-basis equality in both directions -- not containment one way only.
#       (At k=2 the first row is v_1 itself, matching def-wk's base case.)
#   [2] AN INDEPENDENT IMPLEMENTATION.  That w_k really does compute the encoded iterated
#       commutator, checked against honest 2x2 matrix multiplication rather than against another
#       cross-product routine: build traceless A_i from enc-coordinates, form
#       [...[[A_1,A_2],A_3]...,A_k] by repeated matrix products, encode, and compare against
#       D(w_k).  This is what makes the word "independent" in the proof mean something -- the two
#       routes share no code.
#   [3] THE DISPLAYS.  The 2x3 matrix printed in full at k = 2,3,4, so the example's claim that the
#       omitted entries are "displayed in full" here is actually true.
#
# Conventions, matching the manuscript:
#   enc(A) = (a11 - a22, a12 + a21, a12 - a21)
#   D(u)   = (-u_0, -u_1, u_2)          involution, det 1, invertible in every characteristic
#   w_2    = v_1 x v_2 ,  w_j = D(w_{j-1}) x v_j   (j >= 3)
#
# Output: runs/verify-determinantal-structure-all-k.txt

def blocks(k):
    return PolynomialRing(QQ, ['v%d_%d' % (i, j)
                               for i in range(1, k + 1) for j in range(1, 4)])

def setup(k):
    R = blocks(k)
    g = R.gens()
    return R, [vector(R, g[3 * i:3 * i + 3]) for i in range(k)]

def Dv(u, R):
    return vector(R, [-u[0], -u[1], u[2]])

def w_upto(k, R, v):
    ws = {2: v[0].cross_product(v[1])}
    for j in range(3, k + 1):
        ws[j] = Dv(ws[j - 1], R).cross_product(v[j - 1])
    return ws

def top_row(k, R, v, ws):
    """The first row of thm-determinantal's 2x3 matrix at level k."""
    return v[0] if k == 2 else Dv(ws[k - 1], R)

def minors2x3(a, b):
    """The three 2x2 minors of [[a0,a1,a2],[b0,b1,b2]], signed so that they ARE a x b."""
    return [a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0]]

failures = []
def check(label, ok):
    print(("PASS  " if ok else "FAIL  ") + label)
    if not ok:
        failures.append(label)

print("=" * 78)
print("thm-determinantal under the SIGNED encoding, D = diag(-1,-1,1)")
print("=" * 78)

# ---- [1] the theorem: I_k = ideal of 2x2 minors of [D(w_{k-1}) ; v_k] -------
print("\n[1] I_k == ideal of the 2x2 minors of [D(w_{k-1}) ; v_k], both directions")
for k in range(2, 7):
    R, v = setup(k)
    ws = w_upto(k, R, v)
    I_k = R.ideal(list(ws[k]))
    I_minors = R.ideal(minors2x3(top_row(k, R, v, ws), v[k - 1]))
    # Containment in BOTH directions, checked by generator-wise normal-form reduction
    # against the other ideal's Groebner basis -- not by == alone, and not one way only.
    # (Sage's MPolynomialIdeal has no .is_subset; reduce() is the honest primitive.)
    fwd = all(I_minors.reduce(g) == 0 for g in I_k.gens())
    bwd = all(I_k.reduce(g) == 0 for g in I_minors.gens())
    check("k=%d : I_k subset minors (%s), minors subset I_k (%s), and I_k == minors (%s)"
          % (k, fwd, bwd, I_k == I_minors), fwd and bwd and I_k == I_minors)

# ---- [2] independent implementation: honest matrix multiplication -----------
print("\n[2] enc([A_1,...,A_k]) == D(w_k), against real 2x2 matrix products")
for k in range(2, 7):
    R, v = setup(k)
    ws = w_upto(k, R, v)
    half = R.base_ring()(1) / 2
    # Invert enc on traceless matrices: a11 = v1/2, a22 = -v1/2,
    # a12 = (v2+v3)/2, a21 = (v2-v3)/2.
    def A_of(vi):
        return matrix(R, [[half * vi[0], half * (vi[1] + vi[2])],
                          [half * (vi[1] - vi[2]), -half * vi[0]]])
    def enc(M):
        return vector(R, [M[0, 0] - M[1, 1], M[0, 1] + M[1, 0], M[0, 1] - M[1, 0]])
    C = A_of(v[0]) * A_of(v[1]) - A_of(v[1]) * A_of(v[0])
    for j in range(2, k):
        Aj = A_of(v[j])
        C = C * Aj - Aj * C
    check("k=%d : enc of the iterated matrix commutator == D(w_k)" % k,
          enc(C) == Dv(ws[k], R))

# ---- [3] the displays the manuscript defers to this file for ----------------
print("\n[3] the 2x3 matrix [D(w_{k-1}) ; v_k], in full, at k = 2,3,4")
for k in (2, 3, 4):
    R, v = setup(k)
    ws = w_upto(k, R, v)
    r1, r2 = top_row(k, R, v, ws), v[k - 1]
    print("\n  --- k = %d ---" % k)
    print("  row 1 = %s :" % ("v_1" if k == 2 else "D(w_%d)" % (k - 1)))
    for c, e in enumerate(r1):
        print("     [%d] %s" % (c + 1, e))
    print("  row 2 = v_%d :" % k)
    for c, e in enumerate(r2):
        print("     [%d] %s" % (c + 1, e))

print("\n" + "=" * 78)
print("FAILURES: %s" % (failures if failures else "none"))
print("=" * 78)
