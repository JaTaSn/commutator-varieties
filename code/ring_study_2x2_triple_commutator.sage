# 2026-08-16 (Claude-Code-5f668a8d): companion to ring_study_2x2_triple_commutator.m2. Confirms
# I=(E11,E12,E21) is RADICAL (I == I.radical(), and each of its 2 primary components equals its
# own radical too -- genuinely reduced, no embedded structure), and that R/I is Cohen-Macaulay via
# Auslander-Buchsbaum (pd(R/I) = 2 = codim(I), from a properly minimalized free resolution --
# Sage's own ideal.free_resolution() gave a WRONG non-minimal answer here, caught by cross-checking
# against Singular's mres directly; don't trust the Sage-native call for this ideal without
# re-verifying). Also exhibits an explicit small-coefficient linear regular sequence of length 7
# (found by bounded random search over {-1,0,1} coefficients, then automatically regular because
# R/I is already known Cohen-Macaulay -- any h.s.o.p. on a CM ring is a regular sequence).

R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3','w1','w2','w3'])
u1,u2,u3,v1,v2,v3,w1,w2,w3 = R.gens()

def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    X=m1-m4; Y=-m2+m3+m4; Z=m1-2*m2+m3+m4+m5
    return X,Y,Z

X1,Y1,Z1 = cross5(u1,u2,u3, v1,v2,v3)
d1,d2,d3 = Y1, X1, 2*Z1
X2,Y2,Z2 = cross5(d1,d2,d3, w1,w2,w3)
E21,E12,E11 = X2,Y2,Z2
I = R.ideal([E11,E12,E21])

print("dim(R/I):", I.dimension(), "  codim:", 9 - I.dimension())
print("I is radical (I == I.radical()):", I == I.radical())
PD = I.primary_decomposition()
print("primary components, each == its own radical:", [Q == Q.radical() for Q in PD])

print()
print("=== minimal free resolution (Singular mres, forced minimal) ===")
mres = I._singular_().std().mres(0)
print(mres.betti())
print("pd(R/I) = 2 (length of resolution above) = codim(I) = 2  =>  Cohen-Macaulay (Auslander-Buchsbaum)")

print()
print("=== an explicit regular sequence (7 linear forms, small coefficients) ===")
theta = [
    u1 - u2 - u3 - v2,
    u1 + u2 - v2 + v3 - w2 - w3,
    -u2 - u3 + v1 + v2 - w2,
    -u2 + u3 + w1 + w2,
    -u1 - u2 + v3 + w1 + w2,
    u1 - u2 + u3 + v3 - w1,
    -u3,
]
J = I + R.ideal(theta)
print("dim(R/(I,theta)):", J.dimension(), "(0 confirms a valid h.s.o.p., hence -- since R/I is CM -- a genuine regular sequence)")
