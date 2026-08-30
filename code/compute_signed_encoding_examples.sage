# 2026-08-19 (Claude): explicit low-k data for the companion article
# article/ring-of-k-commuting-2x2-matrices-signed-encoding.typ, computed directly (not hand-derived)
# -- mirrors the current article's own code/verify_determinantal_structure_all_k.sage in spirit, but
# for the enc()/D() encoding (working-notes/alternative-encodings-musings.org) instead of red()/tau().
#
# Convention matching the new article: w_2 := v_1 x v_2 (no D at the very first stage, same as the
# original article's own base case), w_j := D(w_{j-1}) x v_j for j >= 3. D = diag(-1,-1,1).

D = matrix(QQ, 3, 3, [[-1,0,0],[0,-1,0],[0,0,1]])

def cross(u, v):
    return vector(u.base_ring(), [u[1]*v[2]-u[2]*v[1], u[2]*v[0]-u[0]*v[2], u[0]*v[1]-u[1]*v[0]])

def block(R, i):
    return vector(R, [R.gens()[3*(i-1)+0], R.gens()[3*(i-1)+1], R.gens()[3*(i-1)+2]])

def wvec(R, k):
    v = [block(R, i) for i in range(1, k+1)]
    w = cross(v[0], v[1])
    for j in range(3, k+1):
        w = cross(D * w, v[j-1])
    return w

print("=" * 70)
print("w_2, w_3, w_4 (abstract, D-recursion)")
print("=" * 70)
for k in [2, 3, 4]:
    R = PolynomialRing(QQ, ['v%d_%d' % (i, j) for i in range(1, k+1) for j in range(1, 4)])
    w = wvec(R, k)
    print("k=%d:" % k)
    for comp in w:
        print("  ", comp)
    print()

print("=" * 70)
print("thm-determinantal matrix rows [D(w_{k-1}) ; v_k] for k=3,4 (k=2 row is just v_1)")
print("=" * 70)
for k in [3, 4]:
    R = PolynomialRing(QQ, ['v%d_%d' % (i, j) for i in range(1, k+1) for j in range(1, 4)])
    w_prev = wvec(R, k-1)
    Dw_prev = D * w_prev
    print("k=%d, D(w_%d) =" % (k, k-1))
    for comp in Dw_prev:
        print("  ", comp)
    print()

print("=" * 70)
print("Y2 defining ideal (eliminate lambda from graph of Phi) at k=3,4")
print("Phi(p,lambda) := (p, lambda * D(w_{k-1}(p)))")
print("=" * 70)
for k in [3, 4]:
    Rbig = PolynomialRing(QQ, ['v%d_%d' % (i, j) for i in range(1, k+1) for j in range(1, 4)] + ['lam'])
    lam = Rbig.gens()[-1]
    w_prev = wvec(PolynomialRing(QQ, ['v%d_%d' % (i, j) for i in range(1, k) for j in range(1, 4)]), k-1)
    # re-embed w_prev's variables into Rbig (same names, first 3(k-1) gens)
    w_prev_big = vector(Rbig, [Rbig(str(c)) for c in w_prev])
    Dw_prev_big = D * w_prev_big
    vk = vector(Rbig, [Rbig.gens()[3*(k-1)+j] for j in range(3)])
    graph_gens = [vk[j] - lam*Dw_prev_big[j] for j in range(3)]
    J = Rbig.ideal(graph_gens)
    Jelim = J.elimination_ideal(lam)
    print("k=%d, elimination ideal generators:" % k)
    for g in Jelim.gens():
        print("  ", g)
    print()

print("=" * 70)
print("Jacobian J_3 of w_3 (3x9), column-blocked as [-[v_3]_x D J_2 | [D(w_2)]_x]")
print("=" * 70)
R = PolynomialRing(QQ, ['v%d_%d' % (i, j) for i in range(1, 4) for j in range(1, 4)])
w3 = wvec(R, 3)
J3 = jacobian(list(w3), list(R.gens()))
print(J3)
