# 2026-08-16 (Claude-Code-5f668a8d): basic ring invariants for R=k[u,v,w,x]/I, [A,B,C,D] at n=2 --
# see working-notes/four-fold-commutator-n2.org. Confirms dim(R/I)=10 (ambient 12, codim 2), I
# radical, exactly 3 minimal generators (no redundancy -- matches the literal defining generators
# again), and pd(R/I)=2=codim (Auslander-Buchsbaum) => Cohen-Macaulay, via a properly-forced
# minimal resolution (Singular's mres, printed in full to confirm actual termination at position
# 3, not just trusted from the betti() summary table alone).

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

print("dim(R/I):", I.dimension(), " codim:", 12 - I.dimension())
print("I radical?", I == I.radical())

mres = I._singular_().std().mres(0)
print(mres.betti())
print(mres)
