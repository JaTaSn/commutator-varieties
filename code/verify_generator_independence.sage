# 2026-08-30 (Claude-Code-jts-pc): linear independence over F of the three components of
# w_k, in the SIGNED encoding (D = diag(-1,-1,1)), for k = 2..6 -- the computational
# corroboration cited by lem-mingens-indep in the manuscript.
#
# Why this exists: the lemma's original proof argued that a constant relation among the
# components of w_k = D(w_{k-1}) x v_k would force D(w_{k-1}) to be a CONSTANT VECTOR, and
# ruled that out by lem-nondeg's non-degeneracy.  That is a gap.  The relation forces only
#     c x D(w_{k-1}) = 0,
# i.e. the components of D(w_{k-1}) pairwise PROPORTIONAL, which is strictly weaker than
# constant -- (f, 2f, 3f) with f != 0 is nonvanishing yet visibly dependent, so lem-nondeg
# does not exclude it.  The corrected proof runs an induction carrying linear independence
# itself.  This script checks the conclusion directly, independently of that argument.
#
# Method: build w_k by the recursion, extract each component's coefficient vector over the
# monomials actually occurring, and check the 3 x N coefficient matrix has rank 3.  Rank 3
# is exactly "no nontrivial constant linear relation", which is the lemma.

def run(kmax=6):
    print("k   #vars  deg  #monomials  rank   independent?")
    print("-" * 52)
    for k in range(2, kmax + 1):
        names = ['v%d_%d' % (i, j) for i in range(1, k + 1) for j in range(1, 4)]
        R = PolynomialRing(QQ, names)
        g = R.gens()
        v = [vector(R, g[3 * i:3 * i + 3]) for i in range(k)]

        def D(u):
            # diag(-1,-1,1): an involution, det 1, invertible in EVERY characteristic --
            # unlike the naive reshuffle tau(a,b,c)=(b,a,2c), whose det is -2.
            return vector(R, [-u[0], -u[1], u[2]])

        w = v[0].cross_product(v[1])
        for j in range(2, k):
            w = D(w).cross_product(v[j])

        comps = list(w)
        monomials = sorted(set(m for c in comps for m in c.monomials()))
        index = {m: i for i, m in enumerate(monomials)}
        M = matrix(QQ, 3, len(monomials))
        for r, c in enumerate(comps):
            for coeff, mon in zip(c.coefficients(), c.monomials()):
                M[r, index[mon]] = coeff
        rk = M.rank()
        print("%-3d %-6d %-4d %-11d %-6d %s"
              % (k, 3 * k, comps[0].degree(), len(monomials), rk,
                 "yes" if rk == 3 else "NO -- LEMMA FALSE"))
        assert rk == 3, "rank %d at k=%d: the lemma fails" % (rk, k)
    print("\nAll k checked: rank 3 throughout, so no nontrivial constant relation exists.")

run()
