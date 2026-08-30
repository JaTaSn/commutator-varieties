# 2026-08-16 (Claude-Code-5f668a8d): [A,B,C,D,E]=[[[[A,B],C],D],E] at n=2, reduced 15-var
# coordinates -- fourth data point (k=2,3,4,5) testing the two conjectures from
# four-fold-commutator-n2.org. 20-multiplication algorithm (5 per bracket, 4 brackets).
# Numerically cross-checked against literal matrix multiplication in
# verify_2x2_fivefold_commutator_numeric_crosscheck.sage. Confirms: dim(R/I)=13, codim=2 (same as
# k=3,4), I radical, exactly 3 minimal generators, pd(R/I)=2=codim => Cohen-Macaulay (same
# signature as k=3,4 -- three consecutive confirmations of conjecture 1 now). See
# working-notes/five-fold-commutator-n2.org.

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

print("total multiplications (5*4):", 20)
I = R.ideal([G11,G12,G21])
print("dim(R/I):", I.dimension(), " ambient:", 15, " codim:", 15-I.dimension())
print("I radical?", I == I.radical())

print()
print("=== minimal free resolution ===")
mres = I._singular_().std().mres(0)
print(mres.betti())
print(mres)
