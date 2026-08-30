# 2026-08-16 (Claude-Code-5f668a8d): [A,B,C,D]=[[[A,B],C],D] at n=2, reduced 12-var coordinates
# (3 per matrix), by chaining cross5() three times -- extends the k=3 case's "reuse the previous
# bracket's output for free" trick one more level. 15 total multiplications (5 per bracket).
# Ground truth cross-checked against literal genericMatrix multiplication in
# verify_2x2_fourfold_commutator_groundtruth.m2 (dim/codim match: 14/2 there vs 10/2 here, exactly
# the +4 free-trace-dimensions difference expected) and numerically in
# verify_2x2_fourfold_commutator_numeric_crosscheck.sage (exact match at a random point). See
# working-notes/four-fold-commutator-n2.org.

R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3','w1','w2','w3','x1','x2','x3'])
u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3 = R.gens()

def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    X=m1-m4; Y=-m2+m3+m4; Z=m1-2*m2+m3+m4+m5
    return X,Y,Z, [m1,m2,m3,m4,m5]

# stage 1: D1 = [A,B]
X1,Y1,Z1,p1 = cross5(u1,u2,u3, v1,v2,v3)
d1 = (Y1, X1, 2*Z1)   # D1's traceless coords (D1_12, D1_21, D1_11-D1_22)

# stage 2: D2 = [D1,C]
X2,Y2,Z2,p2 = cross5(*d1, w1,w2,w3)
d2 = (Y2, X2, 2*Z2)

# stage 3: D3 = [D2,D]
X3,Y3,Z3,p3 = cross5(*d2, x1,x2,x3)
F11, F12, F21 = Z3, Y3, X3   # final: F11=D3_11=-D3_22, F12=D3_12, F21=D3_21

print("total multiplications used (5+5+5):", 5+5+5)
print()
print("F11 =", F11)
print()
print("F12 =", F12)
print()
print("F21 =", F21)

I = R.ideal([F11,F12,F21])
print()
print("num vars:", 12, " dim(R/I):", I.dimension(), " codim:", 12-I.dimension())
