# Changelog
# 2026-08-31 (Claude-Code-jts-pc): new.  Answers a direct question from Jan -- where, if anywhere,
#   does making the article's results hold over finite (and more generally non-closed) fields cost
#   real complexity?
#
# Motivation: every computational check in this project so far ran over QQ.  Rank, dimension and
# radicality are NOT characteristic-independent in general -- a 0/+-1 coefficient matrix of rank 3
# over QQ can drop rank mod p -- so "verified over QQ" licenses nothing about F_p.  The four
# headline results are re-run here over small prime fields and two non-prime ones.
#
# What is checked, for k = 2..5 over QQ, GF(2), GF(3), GF(5), GF(7), GF(4), GF(9):
#   [1] codim(I_k) = 2                       (thm-codim; also prop-detideal's hypothesis)
#   [2] the three components of w_k are linearly independent over F   (lem-mingens-indep)
#   [3] I_k is radical                       (thm-radical)
#   [4] pd(R_k/I_k) = 2, i.e. Cohen-Macaulay (thm-cm)
#
# GF(2) is included deliberately even though the article excludes char 2: the IDEAL is defined by
# the cross-product recursion in every characteristic, and it is worth knowing which of the four
# results are genuinely char-2 phenomena and which merely lose their interpretation as a
# commutator locus (the encoding enc is what stops being invertible, not D).
#
# Output: runs/verify-over-finite-fields.txt

def build(k, F):
    R = PolynomialRing(F, ['v%d_%d' % (i, c) for i in range(1, k + 1) for c in range(1, 4)])
    g = R.gens()
    v = [vector(R, g[3 * i:3 * i + 3]) for i in range(k)]
    D = lambda u: vector(R, [-u[0], -u[1], u[2]])
    w = v[0].cross_product(v[1])
    for t in range(2, k):
        w = D(w).cross_product(v[t])
    return R, list(w)


def independence_rank(comps, F):
    """Rank over F of the coefficient matrix of the three components."""
    mons = sorted(set(m for c in comps for m in c.monomials()))
    idx = {m: i for i, m in enumerate(mons)}
    M = matrix(F, 3, len(mons))
    for r, c in enumerate(comps):
        for coeff, mon in zip(c.coefficients(), c.monomials()):
            M[r, idx[mon]] = coeff
    return M.rank(), len(mons)


FIELDS = [(QQ, 'QQ'), (GF(2), 'GF(2)'), (GF(3), 'GF(3)'), (GF(5), 'GF(5)'),
          (GF(7), 'GF(7)'), (GF(4, 'a'), 'GF(4)'), (GF(9, 'b'), 'GF(9)')]

rows = []
print("%-7s %-3s  %-8s %-10s %-9s %-8s" % ("field", "k", "codim", "indep rank", "radical", "pd"))
print("-" * 60)
for F, fname in FIELDS:
    for k in range(2, 6):
        R, comps = build(k, F)
        I = R.ideal(comps)
        codim = 3 * k - I.dimension()
        rk, nmon = independence_rank(comps, F)
        try:
            rad = (I.radical() == I)
            rads = "yes" if rad else "NO"
        except Exception as e:
            rads = "err"
        try:
            pd = len(R.free_resolution(I)) - 1 if hasattr(R, 'free_resolution') else None
        except Exception:
            pd = None
        if pd is None:
            try:
                pd = I.graded_free_resolution().length()
            except Exception:
                pd = "n/a"
        print("%-7s %-3d  %-8s %-10s %-9s %-8s"
              % (fname, k, codim, "%d/3" % rk, rads, pd))
        rows.append((fname, k, codim, rk, rads, pd))

print()
print("=" * 60)
bad = [r for r in rows if r[2] != 2 or r[3] != 3 or r[4] == "NO"]
print("rows deviating from (codim 2, rank 3, radical): %s" % (bad if bad else "none"))
print("=" * 60)
