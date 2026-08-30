# 2026-08-16 (Claude-Code-5f668a8d): randomized local search for a rank-5 bilinear decomposition
# of the 3D cross product w=u x v (equivalently, since [A,B] for 2x2 matrices is the cross product
# of (a12,a21,a11-a22) and (b12,b21,b11-b22) on the traceless part -- see
# working-notes/small-commutators-musings.org -- a rank-5 decomposition of the 2x2
# commutator). Ansatz: each of the 5 terms is (integer linear form in u) * (integer linear form in
# v), entries restricted to {-1,0,1}. Existence of a 5-term decomposition is known (Mirwald 1985;
# Gustafson & Aluru 1996); this script rediscovers an explicit one by search rather than looking it
# up. Requires numpy (run with sage's own python, which bundles it: `sage -python` doesn't take
# -python as a flag on this install -- resolve the interpreter path via
# `sage -c "import sys; print(sys.executable)"` and invoke that directly).
#
# Verified output (2026-08-16): found L,R direction pairs
#   (0,1,1)&(0,0,1), (1,0,0)&(1,-1,0), (1,0,1)&(1,-1,-1), (0,0,1)&(0,1,1), (1,-1,-1)&(1,0,1)
# giving p1..p5 with w1=p1-p4, w2=-p2+p3+p4, w3=p1-2p2+p3+p4+p5 -- confirmed exactly by
# verify_2x2_commutator_5mult.sage after translating to the commutator setting.

import itertools
import random
import time

import numpy as np


def canon(v):
    for x in v:
        if x != 0:
            return v if x > 0 else tuple(-y for y in v)
    return None


def build_candidates():
    dirs = set()
    for v in itertools.product([-1, 0, 1], repeat=3):
        if any(v):
            dirs.add(canon(v))
    dirs = sorted(dirs)
    cands = []
    for L in dirs:
        for Rv in dirs:
            M = tuple(L[i] * Rv[j] for i in range(3) for j in range(3))
            cands.append((L, Rv, M))
    return cands


def target_matrices():
    def E(i, j):
        m = [[0] * 3 for _ in range(3)]
        m[i][j] = 1
        return m

    def flat(m):
        return tuple(m[i][j] for i in range(3) for j in range(3))

    def sub(a, b):
        return [[a[i][j] - b[i][j] for j in range(3)] for i in range(3)]

    S1 = flat(sub(E(1, 2), E(2, 1)))
    S2 = flat(sub(E(2, 0), E(0, 2)))
    S3 = flat(sub(E(0, 1), E(1, 0)))
    return np.array([S1, S2, S3], dtype=float)


def residual(cand_mats, target, subset_idx):
    M = cand_mats[list(subset_idx)]
    r1 = np.linalg.matrix_rank(M, tol=1e-8)
    r2 = np.linalg.matrix_rank(np.vstack([M, target]), tol=1e-8)
    return r2 - r1  # 0 means target subspace contained in span(M)


def search(time_budget_seconds=75, seed=1):
    cands = build_candidates()
    cand_mats = np.array([c[2] for c in cands], dtype=float)
    target = target_matrices()
    N = len(cands)

    random.seed(seed)
    found = None
    t0 = time.time()
    while time.time() - t0 < time_budget_seconds:
        cur = random.sample(range(N), 5)
        cur_res = residual(cand_mats, target, cur)
        for _ in range(300):
            if cur_res == 0:
                break
            i = random.randrange(5)
            trial = cur.copy()
            trial[i] = random.randrange(N)
            tr_res = residual(cand_mats, target, trial)
            if tr_res <= cur_res:
                cur, cur_res = trial, tr_res
        if cur_res == 0:
            found = cur
            break
    return cands, found


if __name__ == "__main__":
    cands, found = search()
    if found is None:
        print("No exact solution found within time budget.")
    else:
        print("FOUND:")
        for i in found:
            print("  L =", cands[i][0], " R =", cands[i][1])
