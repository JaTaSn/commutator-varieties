# 2026-09-03 (Claude-Code-jts-pc): the explicit non-degeneracy witness of lem-nondeg,
# in the SIGNED encoding (S = diag(-1,-1,1)), for j = 2..8.
#
# Why this exists.  lem-nondeg's proof was one sentence and asserted its induction
# rather than running it: the induction variable was unnamed, the base case was not
# marked as a base case, the inductive hypothesis (an EXISTENTIAL over p, which is the
# crux -- "not identically zero" means "some point survives") was silent, and the
# choice of e_i was left to the reader.  Worse, lem-witness-new downstream speaks of
# "the lem-nondeg non-degeneracy witness at level k-1" as though lem-nondeg produced a
# named point.  It did not.  This script computes the point the induction actually
# constructs, so the lemma can state it.
#
# What the recipe is.  Base j=2: take (e1, e2), giving w_2 = e1 x e2 = e3 != 0.  Step:
# given p with c := w_{j-1}(p) != 0, the vector S(c) is nonzero (S is invertible), so
# F.S(c) is a LINE; the three e_i span F^3 and a line cannot contain all three, so some
# e_i is not proportional to S(c), and then w_j(p, e_i) = S(c) x e_i != 0 because a
# cross product vanishes exactly on linearly dependent pairs.
#
# What comes out, and it is cleaner than the recipe promises: taking the least such i
# every time, the witness is (e1, e2, e1, e1, ..., e1) -- the SAME vector e1 at every
# step from j=3 on -- and w_j alternates e3 (j even) / e2 (j odd, j >= 3), with every
# coordinate in {0, +-1}.
#
# Contrast worth recording.  Under the retired reshuffle tau(a,b,c) = (b,a,2c) the same
# recipe returns (e1,e2,e1) with w_3 = (0,2,0) and (e1,e2,e1,e2) with w_4 = (0,0,2) --
# a factor of 2 at every level, and a witness that has to alternate.  Both are checked
# below, side by side, since the comparison is the article's own running theme and is
# the sort of claim that decays into folklore if only one side is ever computed.
#
# Output: runs/nondegeneracy-witness-results.txt

def cross(a, b):
    return vector(a.base_ring(), [a[1]*b[2] - a[2]*b[1],
                                  a[2]*b[0] - a[0]*b[2],
                                  a[0]*b[1] - a[1]*b[0]])

def S(u):
    # diag(-1,-1,1).  An involution, det 1, invertible in EVERY characteristic.
    return vector(u.base_ring(), [-u[0], -u[1], u[2]])

def tau(u):
    # The retired reshuffle (a,b,c) |-> (b,a,2c).  det = -2, hence singular in
    # characteristic 2 -- and the source of every stray factor of 2 below.
    return vector(u.base_ring(), [u[1], u[0], 2*u[2]])


def basis(F):
    return [vector(F, b) for b in ([1, 0, 0], [0, 1, 0], [0, 0, 1])]


def name(u):
    """Render a vector as +-e_i when it is one, else as a plain triple."""
    for i in range(3):
        for s in (1, -1):
            if list(u) == [s if j == i else 0 for j in range(3)]:
                return ("" if s == 1 else "-") + "e%d" % (i + 1)
    return str(tuple(u))


def build_witness(twist, jmax, F=QQ):
    """Run the lem-nondeg induction, returning (witness blocks, w values)."""
    e = basis(F)
    blocks = [e[0], e[1]]
    w = cross(e[0], e[1])
    ws = {2: w}
    for j in range(3, jmax + 1):
        c = twist(w)
        assert c != 0, "twist killed a nonzero vector at j=%d -- impossible, it is invertible" % j
        # "at least one e_i is not proportional to S(c)": F.c is a line, the e_i span
        # F^3, so at most ONE e_i can lie on it.  Check that, rather than assume it.
        onthe = [i for i in range(3) if cross(c, e[i]) == 0]
        assert len(onthe) <= 1, "a line cannot contain two basis vectors (j=%d)" % j
        i = min(i for i in range(3) if cross(c, e[i]) != 0)
        blocks.append(e[i])
        w = cross(c, e[i])
        assert w != 0, "cross product vanished on an independent pair at j=%d" % j
        ws[j] = w
    return blocks, ws


def recompute_from_scratch(twist, blocks, F=QQ):
    """Independent re-evaluation: feed the witness back through the recursion.

    Deliberately does not reuse build_witness's running w -- the point is to check
    the witness as a POINT of A^{3j}, the way the lemma states it, not to re-play
    the loop that produced it."""
    w = cross(blocks[0], blocks[1])
    out = {2: w}
    for j in range(3, len(blocks) + 1):
        w = cross(twist(w), blocks[j - 1])
        out[j] = w
    return out


def run(jmax=8):
    for label, twist in (("S = diag(-1,-1,1)  (the article's encoding)", S),
                         ("tau(a,b,c) = (b,a,2c)  (retired)", tau)):
        print("=" * 74)
        print(label)
        print("=" * 74)
        blocks, ws = build_witness(twist, jmax)
        check = recompute_from_scratch(twist, blocks)
        print("j    witness (v_1,...,v_j)                  w_j        nonzero?  agrees?")
        print("-" * 74)
        for j in range(2, jmax + 1):
            wit = ",".join(name(b) for b in blocks[:j])
            ok = ws[j] != 0
            same = ws[j] == check[j]
            print("%-4d %-38s %-10s %-9s %s"
                  % (j, "(" + wit + ")", name(ws[j]),
                     "yes" if ok else "NO", "yes" if same else "NO -- MISMATCH"))
            assert ok and same
        coeffs = sorted(set(abs(x) for j in ws for x in ws[j] if x != 0))
        print("\nnonzero |coefficients| appearing in w_j: %s" % coeffs)
        print()

    print("=" * 74)
    print("Both recipes verified for j = 2..%d, each by two independent evaluations." % jmax)
    print("Under S every witness coordinate and every w_j coordinate lies in {0,+-1};")
    print("under tau a factor of 2 enters at j = 3 and never leaves.")

run()
