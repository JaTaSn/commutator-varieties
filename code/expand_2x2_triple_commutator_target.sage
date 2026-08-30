# 2026-08-16 (Claude-Code-5f668a8d): expand [A,B,C]=[[A,B],C]'s output (E11,E12,E21; E22=-E11) as
# exact trilinear forms in u=(a12,a21,dA), v=(b12,b21,dB), w=(c12,c21,dC) -- the reduced 9-input,
# 3-output trilinear map you get after eliminating each matrix's free trace part (see
# working-notes/A_B_C-commutator.org). Dumps a sparse 27-dim (per output) monomial-coefficient
# target to target.json for search_2x2_triple_commutator_rank.py to search for a low-rank
# decomposition against. Result (2026-08-16): each output is a sum of only 4 monomials, and in
# closed form, writing A=u x v (the ordinary cross product): E11=-A1w1+A2w2, E12=2A3w1-A2w3,
# E21=-2A3w2+A1w3 -- see working-notes/beyond-chaining-search.org for the write-up.
R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3','w1','w2','w3'])
u1,u2,u3,v1,v2,v3,w1,w2,w3 = R.gens()

def cross5(p1,p2,p3,q1,q2,q3):
    m1 = (p2+p3)*q3
    m2 = p1*(q1-q2)
    m3 = (p1+p3)*(q1-q2-q3)
    m4 = p3*(q2+q3)
    m5 = (p1-p2-p3)*(q1+q3)
    X = m1-m4
    Y = -m2+m3+m4
    Z = m1-2*m2+m3+m4+m5
    return X,Y,Z   # X=[P,Q]_21, Y=[P,Q]_12, Z=[P,Q]_11=-[P,Q]_22

# stage 1: D = [A,B], traceless-repr triple (D12,D21,D11-D22)
X1,Y1,Z1 = cross5(u1,u2,u3, v1,v2,v3)
d1,d2,d3 = Y1, X1, 2*Z1   # (D12,D21,D11-D22)

# stage 2: E = [D,C]
X2,Y2,Z2 = cross5(d1,d2,d3, w1,w2,w3)
E21, E12, E11 = X2, Y2, Z2   # E22 = -E11

for name,expr in [("E11",E11),("E12",E12),("E21",E21)]:
    print(name, "=", expr)

# save monomial-coefficient vectors (27-dim: u_i*v_j*w_k, i,j,k in 1,2,3)
monoms = [u1*v1*w1]  # placeholder to build list properly below
monoms = []
uvars=[u1,u2,u3]; vvars=[v1,v2,v3]; wvars=[w1,w2,w3]
for a in uvars:
    for b in vvars:
        for c in wvars:
            monoms.append(a*b*c)

import json
out = {}
for name,expr in [("E11",E11),("E12",E12),("E21",E21)]:
    out[name] = [int(expr.monomial_coefficient(m)) for m in monoms]

with open("target.json","w") as f:
    json.dump(out, f)
print("saved target.json, 27-dim vectors per output")
