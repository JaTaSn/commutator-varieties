# 2026-08-16 (Claude-Code-5f668a8d): explicit regular sequence for R=k[u,v,w,x]/I, [A,B,C,D] at
# n=2 -- see working-notes/four-fold-commutator-n2.org. R/I is already known Cohen-Macaulay
# (ring_study_2x2_fourfold_commutator.sage), so any homogeneous system of parameters (10 linear
# forms, dim=10) is automatically regular -- this just searches small {-1,0,1}-coefficient linear
# combinations for one that cuts the quotient down to dimension 0.

R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3','w1','w2','w3','x1','x2','x3'])
u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3 = R.gens()
def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5
X1,Y1,Z1 = cross5(u1,u2,u3, v1,v2,v3); d1=(Y1,X1,2*Z1)
X2,Y2,Z2 = cross5(*d1, w1,w2,w3); d2=(Y2,X2,2*Z2)
X3,Y3,Z3 = cross5(*d2, x1,x2,x3)
F11,F12,F21 = Z3,Y3,X3
I = R.ideal([F11,F12,F21])
gens12 = [u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3]

import random
def rand_linear_small():
    return sum(random.choice([-1,0,1]) * g for g in gens12)

best = None
for trial in range(500):
    theta = [rand_linear_small() for _ in range(10)]  # dim=10, need 10 elements
    if len(set(theta)) < 10:
        continue
    J = I + R.ideal(theta)
    if J.dimension() == 0:
        cost = sum(sum(1 for c in f.coefficients()) for f in theta)
        if best is None or cost < best[0]:
            best = (cost, theta)

print("best found, total nonzero terms:", best[0] if best else None)
if best:
    for f in best[1]:
        print("  ", f)
else:
    print("no h.s.o.p. found in this many trials with small coefficients")
