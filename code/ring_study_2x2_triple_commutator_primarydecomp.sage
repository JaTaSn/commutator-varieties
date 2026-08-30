# 2026-08-16 (Claude-Code-subagent-k3): standalone primary decomposition of the [A,B,C] zero
# locus, n=2 -- see working-notes/varieties-of-triple-commutators.org and
# working-notes/iterated-commutator-n_2-k_3.org. Split out to match the naming convention the
# k=4,5,6 notes use (`ring_study_..._primarydecomp.sage`); the same computation already exists
# inline in analyze_2x2_triple_commutator_varieties.sage (which also checks the Jacobian rank of
# the image map) and as part of ring_study_2x2_triple_commutator.sage's radical check -- this file
# adds nothing numerically new, it exists purely so k=3 has a same-named counterpart to the
# k=4,5,6 primarydecomp scripts.
#
# Result: exactly 2 components (=k-1 for k=3), each radical, each dimension 7. Component 0 is
# "A,B commute" ([A,B]=0); component 1 is "[A,B] commutes with C" generically (the "generic"
# stratum). This is the k=3 anchor for the "exactly k-1 components" conjecture later tracked
# across k=4,5,6.

R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3','w1','w2','w3'])
u1,u2,u3,v1,v2,v3,w1,w2,w3 = R.gens()

def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5

X1,Y1,Z1 = cross5(u1,u2,u3, v1,v2,v3); d1=(Y1,X1,2*Z1)
X2,Y2,Z2 = cross5(*d1, w1,w2,w3)
E11,E12,E21 = Z2,Y2,X2
I = R.ideal([E11,E12,E21])

PD = I.primary_decomposition()
print("number of primary components:", len(PD))
for i,Q in enumerate(PD):
    P = Q.radical()
    print(f"component {i}: dim={P.dimension()}, Q==Q.radical()? {Q==Q.radical()}")
    print("   generators:", P.gens())
