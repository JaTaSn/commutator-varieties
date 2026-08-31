# referee_geometry_k5_minprimes.sage
#
# Changelog:
#   2026-08-31  Claude (adversarial referee, geometry/CM scope): created.
#
# Slow check split out of referee_geometry_checks.sage: minimal primes of I_5
# under the signed encoding D = diag(-1,-1,1).  Verifies Theorem 23 at k=5:
# exactly k-1 = 4 minimal primes, each of dim 3k-2 = 13, equal as ideals to
# the elimination ideals P_2..P_5, each involving exactly blocks 1..j.
#
# Output: runs/referee-geometry-k5-minprimes.txt

def ring(k, extra=()):
    names = ['v%d_%d' % (i, j) for i in range(1, k + 1) for j in range(1, 4)] + list(extra)
    return PolynomialRing(QQ, names)

def vecs(R, k):
    g = R.gens()
    return [vector(R, g[3 * i:3 * i + 3]) for i in range(k)]

def Dv(u):
    return vector([-u[0], -u[1], u[2]])

def w_list(v, k):
    ws = {2: v[0].cross_product(v[1])}
    for j in range(3, k + 1):
        ws[j] = Dv(ws[j - 1]).cross_product(v[j - 1])
    return ws

def Pj_in_Rk(j, Rk):
    T = ring(j, extra=('lam',))
    lamT = T('lam')
    vT = vecs(T, j)
    if j == 2:
        R2l = ring(2)
        w = w_list(vecs(R2l, 2), 2)[2]
        return Rk.ideal([Rk(str(g)) for g in w])
    wT = w_list(vT, j - 1)[j - 1]
    graph = T.ideal([vT[j - 1][c] - lamT * Dv(wT)[c] for c in range(3)])
    elim = graph.elimination_ideal([lamT])
    return Rk.ideal([Rk(str(g)) for g in elim.gens()])

k = 5
Rk = ring(k)
wk = w_list(vecs(Rk, k), k)[k]
Ik = Rk.ideal(list(wk))
print("computing minimal primes of I_5 (15 variables) ...")
mp = Ik.minimal_associated_primes()
print("count:", len(mp), "(expect %d)" % (k - 1))
print("dims :", [P.dimension() for P in mp], "(expect all %d)" % (3 * k - 2))
expected = [Pj_in_Rk(j, Rk) for j in range(2, k + 1)]
match = all(any(P == E for P in mp) for E in expected) and len(mp) == len(expected)
print("minimal primes == {P_2..P_5} as ideals:", match)
for j, E in zip(range(2, k + 1), expected):
    blocks_used = set()
    for g in E.gens():
        for x in g.variables():
            blocks_used.add(int(str(x).split('_')[0][1:]))
    print("P_%d involves exactly blocks 1..%d:" % (j, j),
          blocks_used == set(range(1, j + 1)), sorted(blocks_used))
verdict = (len(mp) == k - 1 and all(P.dimension() == 3 * k - 2 for P in mp) and match)
print("VERDICT k=5:", "PASS" if verdict else "FAIL")
