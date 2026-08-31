# Changelog
# 2026-08-31 (Claude-Code-jts-pc): new.  Backs the base-field remark (rem-base-field) in the
#   article, and the working note "absolute-primeness-and-descent.org", with computation rather
#   than assertion.
#
# What is checked:
#   [A] P_j really is the kernel of the parametrization map.  For j = 2,3,4 inside R_k, build the
#       F-algebra homomorphism phi_j : R_k -> F[p, lam, q] induced by prop-rational's
#       parametrization, compute its kernel by elimination, and compare against the minimal primes
#       of I_k computed independently.  This is what licenses "P_j = ker of a map into a polynomial
#       ring", on which the whole absolute-primeness argument rests.
#   [B] Each such kernel is prime -- and STAYS prime after base extension.  Checked over QQ and,
#       as a positive-characteristic probe, over GF(2), GF(3), GF(5) and the extensions GF(9),
#       GF(25).  (Absolute primeness is a statement about every extension and cannot be checked
#       exhaustively; these are corroboration, not proof.  The proof is the flatness argument.)
#   [C] The decomposition itself descends: I_k == intersection of the P_j, over each of those
#       fields, at k = 3,4.
#   [D] The two standard failure modes, for contrast -- an ideal that is prime but NOT absolutely
#       prime, and one whose extension is not even reduced.  These are what the criterion has to
#       rule out, and they show "prime" alone is not enough.
#
# Output: runs/verify-absolute-primeness.txt

def parametrization_kernel(k, j, F=QQ):
    """P_j as ker(phi_j), phi_j induced by prop-rational's parametrization at parameter j.

    Phi_j(p, lam, q) = (p_1,...,p_{j-1}, lam * D(w_{j-1}(p)), q),  with the j=2 convention
    Phi_2(p, lam) = (p_1, lam * p_1).  Source ring has 3(j-1) + 1 + 3(k-j) = 3k-2 variables.
    """
    src_names = (['p%d_%d' % (i, c) for i in range(1, j) for c in range(1, 4)]
                 + ['lam']
                 + ['q%d_%d' % (i, c) for i in range(j + 1, k + 1) for c in range(1, 4)])
    tgt_names = ['v%d_%d' % (i, c) for i in range(1, k + 1) for c in range(1, 4)]
    # one big ring holding both, so the graph ideal can be eliminated
    S = PolynomialRing(F, tgt_names + src_names, order='degrevlex')
    g = S.gens()
    v = [vector(S, g[3 * i:3 * i + 3]) for i in range(k)]
    src = g[3 * k:]
    p = [vector(S, src[3 * i:3 * i + 3]) for i in range(j - 1)]
    lam = src[3 * (j - 1)]
    q = [vector(S, src[3 * (j - 1) + 1 + 3 * i:3 * (j - 1) + 4 + 3 * i]) for i in range(k - j)]

    def D(u):
        return vector(S, [-u[0], -u[1], u[2]])

    if j == 2:
        last = p[0]                                    # Phi_2(p, lam) = (p, lam*p)
    else:
        wj = p[0].cross_product(p[1])
        for t in range(2, j - 1):
            wj = D(wj).cross_product(p[t])
        last = D(wj)
    image = list(p) + [lam * last] + list(q)           # the point Phi_j(p, lam, q)
    graph = S.ideal([v[i][c] - image[i][c] for i in range(k) for c in range(3)])
    elim = graph.elimination_ideal(list(src))
    R = PolynomialRing(F, tgt_names, order='degrevlex')
    return R, R.ideal([R(f) for f in elim.gens() if f != 0])


def I_of(k, R):
    g = R.gens()
    v = [vector(R, g[3 * i:3 * i + 3]) for i in range(k)]
    D = lambda u: vector(R, [-u[0], -u[1], u[2]])
    w = v[0].cross_product(v[1])
    for t in range(2, k):
        w = D(w).cross_product(v[t])
    return R.ideal(list(w))


fails = []
def check(label, ok):
    print(("PASS  " if ok else "FAIL  ") + label)
    if not ok:
        fails.append(label)

print("=" * 78)
print("[A] P_j = ker(phi_j), and [B] primality, over several fields")
print("=" * 78)

FIELDS = [(QQ, 'QQ'), (GF(2), 'GF(2)'), (GF(3), 'GF(3)'), (GF(5), 'GF(5)'),
          (GF(9, 'a'), 'GF(9)'), (GF(25, 'b'), 'GF(25)')]

for F, fname in FIELDS:
    for k in (3, 4):
        R = None
        Ps = []
        for j in range(2, k + 1):
            R, Pj = parametrization_kernel(k, j, F)
            check("%-6s k=%d j=%d : ker(phi_j) is prime" % (fname, k, j), Pj.is_prime())
            Ps.append(Pj)
        Ik = I_of(k, R)
        inter = Ps[0]
        for P in Ps[1:]:
            inter = inter.intersection(P)
        check("%-6s k=%d      : I_k == P_2 cap ... cap P_k" % (fname, k), inter == Ik)
        # irredundancy: dropping any one factor must enlarge the intersection
        if len(Ps) > 1:
            ok = True
            for drop in range(len(Ps)):
                rest = [P for i, P in enumerate(Ps) if i != drop]
                cur = rest[0]
                for P in rest[1:]:
                    cur = cur.intersection(P)
                ok = ok and (cur != Ik)
            check("%-6s k=%d      : the decomposition is irredundant" % (fname, k), ok)

print()
print("=" * 78)
print("[A'] the kernels agree with the minimal primes computed independently (QQ, k=3,4)")
print("=" * 78)
for k in (3, 4):
    R, _ = parametrization_kernel(k, 2, QQ)
    mins = I_of(k, R).minimal_associated_primes()
    kers = []
    for j in range(2, k + 1):
        _, Pj = parametrization_kernel(k, j, QQ)
        kers.append(Pj)
    same = (len(mins) == len(kers)
            and all(any(P == M for M in mins) for P in kers))
    check("k=%d : {ker phi_j} == Min(I_k)  (%d each)" % (k, len(kers)), same)

print()
print("=" * 78)
print("[D] the two failure modes -- why 'prime' alone is not enough")
print("=" * 78)

# (i) prime over QQ, splits over QQ(i).  QQbar is unusable here -- Singular's primdecSY refuses a
# ring over it -- so take the concrete number field where the splitting actually happens.
A = PolynomialRing(QQ, 'x,y')
Pq = A.ideal(A('x^2 + 1'))
Ki = NumberField(polygen(QQ)**2 + 1, 'i')
B = PolynomialRing(Ki, 'x,y')
Pext = B.ideal(B('x^2 + 1'))
print("  (i)  (x^2+1) over QQ    : prime = %s" % Pq.is_prime())
print("       (x^2+1) over QQ(i) : prime = %s, factors = %s"
      % (Pext.is_prime(), factor(B('x^2 + 1'))))
check("(i) prime over QQ but NOT after extension (so not absolutely prime)",
      Pq.is_prime() and not Pext.is_prime())

# (ii) inseparable: irreducible over F_p(t), but its extension is a p-th power, so the extended
# ring is not even reduced.  Realised concretely by the base change F_p(t) -> F_p(u), t |-> u^p.
p = 3
Kt = GF(p)['t'].fraction_field()
ft = polygen(Kt)**p - Kt.gen()
Ku = GF(p)['u'].fraction_field()
u = Ku.gen()
fu = polygen(Ku)**p - u**p            # the image of ft under t |-> u^p
print("  (ii) x^%d - t over GF(%d)(t)          : irreducible = %s" % (p, p, ft.is_irreducible()))
print("       its image over GF(%d)(u), t=u^%d : x^%d - u^%d = %s" % (p, p, p, p, factor(fu)))
check("(ii) irreducible, but its base change is a p-th power (extension not reduced)",
      ft.is_irreducible() and factor(fu)[0][1] == p)

print()
print("=" * 78)
print("FAILURES: %s" % (fails if fails else "none"))
print("=" * 78)
