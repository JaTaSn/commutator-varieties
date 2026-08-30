# 2026-08-16 (Claude-Code-subagent-k2): explicit regular sequence for [A,B] at n=2, k=2 -- see
# working-notes/iterated-commutator-n_2-k_2.org. R/I already known Cohen-Macaulay (via the mres/pd
# check in ring_study_2x2_commutator.sage), so any h.s.o.p. (4 linear forms, dim=4) is automatically
# regular.

R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3'])
u1,u2,u3,v1,v2,v3 = R.gens()
def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5
X1,Y1,Z1 = cross5(u1,u2,u3, v1,v2,v3)
H11,H12,H21 = Z1,Y1,X1
I = R.ideal([H11,H12,H21])
gens6 = [u1,u2,u3,v1,v2,v3]

import random
def rand_linear_small():
    return sum(random.choice([-1,0,1]) * g for g in gens6)

best = None
for trial in range(300):
    theta = [rand_linear_small() for _ in range(4)]  # dim=4
    if len(set(theta)) < 4:
        continue
    J = I + R.ideal(theta)
    if J.dimension() == 0:
        best = theta
        break

if best:
    print("found regular sequence:")
    for f in best:
        print("  ", f)
else:
    print("not found in this many trials")
