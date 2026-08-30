# 2026-08-16 (Claude-Code-5f668a8d): explicit regular sequence for [A,B,C,D,E,F] at n=2 -- see
# working-notes/six-fold-commutator-n2.org. R/I already known Cohen-Macaulay, so any h.s.o.p. (16
# linear forms, dim=16) is automatically regular.

R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3','w1','w2','w3','x1','x2','x3','y1','y2','y3','z1','z2','z3'])
u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3,y1,y2,y3,z1,z2,z3 = R.gens()
def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5
X1,Y1,Z1 = cross5(u1,u2,u3, v1,v2,v3); d1=(Y1,X1,2*Z1)
X2,Y2,Z2 = cross5(*d1, w1,w2,w3); d2=(Y2,X2,2*Z2)
X3,Y3,Z3 = cross5(*d2, x1,x2,x3); d3=(Y3,X3,2*Z3)
X4,Y4,Z4 = cross5(*d3, y1,y2,y3); d4=(Y4,X4,2*Z4)
X5,Y5,Z5 = cross5(*d4, z1,z2,z3)
H11,H12,H21 = Z5,Y5,X5
I = R.ideal([H11,H12,H21])
gens18 = [u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3,y1,y2,y3,z1,z2,z3]

import random
def rand_linear_small():
    return sum(random.choice([-1,0,1]) * g for g in gens18)

best = None
for trial in range(300):
    theta = [rand_linear_small() for _ in range(16)]  # dim=16
    if len(set(theta)) < 16:
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
