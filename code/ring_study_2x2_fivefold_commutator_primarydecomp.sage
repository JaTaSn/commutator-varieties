# 2026-08-16 (Claude-Code-5f668a8d): primary decomposition of [A,B,C,D,E]'s zero locus, n=2 --
# see working-notes/five-fold-commutator-n2.org. Confirms conjecture 2 exactly: 4 = k-1 components
# (k=5), each radical, each dimension 13, block-involvement pattern exactly matching the predicted
# inductive mechanism (component i involves exactly the first i+2 blocks: {u,v}, {u,v,w},
# {u,v,w,x}, {u,v,w,x,y}).

R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3','w1','w2','w3','x1','x2','x3','y1','y2','y3'])
u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3,y1,y2,y3 = R.gens()
def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5
X1,Y1,Z1 = cross5(u1,u2,u3, v1,v2,v3); d1=(Y1,X1,2*Z1)
X2,Y2,Z2 = cross5(*d1, w1,w2,w3); d2=(Y2,X2,2*Z2)
X3,Y3,Z3 = cross5(*d2, x1,x2,x3); d3=(Y3,X3,2*Z3)
X4,Y4,Z4 = cross5(*d3, y1,y2,y3)
G11,G12,G21 = Z4,Y4,X4
I = R.ideal([G11,G12,G21])

print("starting primary decomposition...")
PD = I.primary_decomposition()
print("number of primary components:", len(PD))
for i,Q in enumerate(PD):
    P = Q.radical()
    print(f"component {i}: dim={P.dimension()}, Q==Q.radical()? {Q==Q.radical()}")
    print("   num gens:", len(P.gens()), " involves which blocks (u,v,w,x,y present?):",
          [any(str(g) in str(P.gens()) for g in [blk]) for blk in ['u','v','w','x','y']])
