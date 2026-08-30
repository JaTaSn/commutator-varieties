# 2026-08-16 (Claude-Code-5f668a8d): searches for a genuine low trilinear-rank decomposition of
# [A,B,C]=[[A,B],C]'s reduced 3+3+3->3 target (run expand_2x2_triple_commutator_target.sage first
# to produce target.json), directly on the 4-way tensor rather than via the 5+5 chaining
# construction -- would answer whether the true minimal rank is below 10 (a rank-r trilinear
# decomposition costs 2r multiplications, so r<=4 would beat 10). Run with sage's own bundled
# python (system python lacks numpy): `<sage-python> search_2x2_triple_commutator_rank.py`.
#
# Result (2026-08-16): r=4 and r=5 both came up empty (best residual stuck at 3, thousands of
# restarts) under two ansätze -- integer directions in {-1,0,1}^3 first, then {-2,...,2}^3 here.
# A sanity check confirmed the search mechanism itself works (large r, e.g. 40, does reach exact
# rank-0 residual), so the small-ansatz failure is a real signal, not a bug -- but it's a heuristic
# local search, not exhaustive or a proof: doesn't rule out r=4/5 with non-integer (e.g.
# half-integer) coefficients, or a smaller true circuit complexity via reuse tricks the pure
# rank-decomposition model can't express (our own 10-multiplication chaining algorithm already
# beats what its own "naive expanded rank" would suggest, for exactly this reason -- see
# working-notes/beyond-chaining-search.org).

import itertools, random, time, json
import numpy as np

with open("target.json") as f:
    target_raw = json.load(f)
target = np.array([target_raw["E11"], target_raw["E12"], target_raw["E21"]], dtype=float)

def canon(v):
    for x in v:
        if x != 0:
            return v if x > 0 else tuple(-y for y in v)
    return None

dirs = set()
for v in itertools.product([-2,-1,0,1,2], repeat=3):
    if any(v):
        dirs.add(canon(v))
dirs = sorted(dirs)
print("num directions:", len(dirs))

cands = []
for L in dirs:
    for M in dirs:
        for N in dirs:
            vec = [a*b*c for a in L for b in M for c in N]
            cands.append((L, M, N, vec))
cand_mats = np.array([c[3] for c in cands], dtype=float)
N_cand = len(cands)
print("num candidates:", N_cand)

def residual(idx):
    M = cand_mats[list(idx)]
    r1 = np.linalg.matrix_rank(M, tol=1e-8)
    r2 = np.linalg.matrix_rank(np.vstack([M, target]), tol=1e-8)
    return r2 - r1

def search_for_r(r, time_budget, seed):
    random.seed(seed)
    t0 = time.time()
    best = 999
    restarts = 0
    while time.time() - t0 < time_budget:
        restarts += 1
        cur = random.sample(range(N_cand), r)
        cur_res = residual(cur)
        for _ in range(300):
            if cur_res == 0:
                return cur, restarts
            i = random.randrange(r)
            trial = cur.copy()
            trial[i] = random.randrange(N_cand)
            tr = residual(trial)
            if tr <= cur_res:
                cur, cur_res = trial, tr
        best = min(best, cur_res)
    print(f"  r={r}: no exact hit, best residual {best} over {restarts} restarts")
    return None, restarts

for r in [4,5]:
    print(f"Trying r={r} (entries in -2..2) ...")
    found, restarts = search_for_r(r, time_budget=70, seed=r+500)
    if found:
        print(f"  FOUND at r={r} after {restarts} restarts:")
        for i in found:
            L,M,N,_ = cands[i]
            print("   L(u)=",L," M(v)=",M," N(w)=",N)
