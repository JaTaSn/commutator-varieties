# 2026-08-16 (Claude-Code-subagent-k2): basic ring invariants for R=k[u,v]/I, the single (k=2)
# commutator [A,B] at n=2, reduced 6-var coordinates -- base case of the ring-study battery run at
# k=3,4,5,6 in ring_study_2x2_{triple,fourfold,fivefold,sixfold}_commutator.sage, filling in the
# e(R/I) gap left blank for k=2 in six-fold-commutator-n2.org's synthesis table. Uses cross5, the
# optimal 5-multiplication cross-product formula from verify_2x2_commutator_5mult.sage. Confirms
# dim(R/I)=4 (ambient 6, codim 2), I radical, exactly 3 minimal generators, pd(R/I)=2=codim =>
# Cohen-Macaulay -- same signature as every k=3..6 data point. See
# working-notes/iterated-commutator-n_2-k_2.org.

R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3'])
u1,u2,u3,v1,v2,v3 = R.gens()

def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5

X1,Y1,Z1 = cross5(u1,u2,u3, v1,v2,v3)
H11,H12,H21 = Z1,Y1,X1

print("total multiplications (5*1):", 5)
I = R.ideal([H11,H12,H21])
print("dim(R/I):", I.dimension(), " ambient:", 6, " codim:", 6-I.dimension())
print("I radical?", I == I.radical())

print()
print("=== minimal free resolution ===")
mres = I._singular_().std().mres(0)
print(mres.betti())
print(mres)
