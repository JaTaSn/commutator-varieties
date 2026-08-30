# 2026-08-16 (Claude-Code-5f668a8d): primary decomposition of [A,B,C,D,E,F]'s zero locus, n=2 --
# see working-notes/six-fold-commutator-n2.org. Confirms conjecture 2 exactly: 5 = k-1 components
# (k=6), each radical, dim 16, 3 generators. Block-involvement pattern exactly matches the
# predicted mechanism: component j involves exactly the first j+2 blocks. Took ~57s for the
# primary_decomposition() call itself -- noticeably slower than k=5, ran as a background task.

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

print("starting primary decomposition (may be slow)...")
import time
t0 = time.time()
PD = I.primary_decomposition()
print("elapsed:", time.time()-t0, "seconds")
print("number of primary components:", len(PD))
for i,Q in enumerate(PD):
    P = Q.radical()
    print(f"component {i}: dim={P.dimension()}, Q==Q.radical()? {Q==Q.radical()}, num_gens={len(P.gens())}")

print()
print("=== block involvement per component ===")
blocknames = ['u','v','w','x','y','z']
blockvars = [[u1,u2,u3],[v1,v2,v3],[w1,w2,w3],[x1,x2,x3],[y1,y2,y3],[z1,z2,z3]]
for i,Q in enumerate(PD):
    P = Q.radical()
    gens_str = str(P.gens())
    involved = [blocknames[j] for j,bv in enumerate(blockvars) if any(str(v) in gens_str for v in bv)]
    print(f"component {i}: blocks involved = {involved}")
