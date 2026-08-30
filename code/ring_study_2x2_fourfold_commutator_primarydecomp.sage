# 2026-08-16 (Claude-Code-5f668a8d): primary decomposition of the [A,B,C,D] zero locus, n=2 --
# see working-notes/four-fold-commutator-n2.org. Finds 3 components (not 2!), each radical,
# dimension 10. Two of them (components 0,1) turn out to be EXACTLY the k=3 case's own two
# components (verify_2x2_triple_commutator_varieties -- same generators, checked by direct
# comparison), just with the 4th matrix D appearing nowhere in the generators (hence unconstrained/
# free) -- i.e. "[[[A,B],C],D]=0" trivially inherits every stratum where the k=3 sub-bracket
# [[A,B],C] already vanished. Component 2 is genuinely new: the first "generic" stratum for k=4,
# where D is constrained relative to the (generically nonzero) [[A,B],C]. This gives an inductive
# mechanism (old components embed trivially + one new generic component per level) suggesting
# exactly k-1 components at bracket-length k in general (k=2: 1 [classical commuting variety,
# irreducible]; k=3: 2; k=4: 3) -- verified for the k=2->3->4 transitions, not proven for general k.

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

PD = I.primary_decomposition()
print("number of primary components:", len(PD))
for i,Q in enumerate(PD):
    P = Q.radical()
    print(f"component {i}: dim={P.dimension()}, Q==Q.radical()? {Q==Q.radical()}")
    print("   generators:", P.gens())
