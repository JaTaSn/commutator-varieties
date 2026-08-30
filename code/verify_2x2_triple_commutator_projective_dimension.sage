# 2026-08-16 (Claude-Code-5f668a8d): confirms V([A,B,C]=0)'s dimension precisely, in response to
# Jan asking to unconfuse dim(R/I) vs "dimension of I", and whether the variety is affine or
# (multi-)projective. See working-notes/varieties-of-triple-commutators.org.
#
# 1. Confirms all three generators (E11,E12,E21) are separately homogeneous of degree 1 in each of
#    u,v,w -- i.e. the affine cone V(I) subset A^9 is invariant under an independent (G_m)^3 action,
#    hence descends to a well-defined subvariety of P^2 x P^2 x P^2.
# 2. Verifies (not just asserts) the standard "dim(cone) = dim(projective variety) + rank of torus"
#    relation by dehomogenizing in the chart u1=v1=w1=1 and recomputing dim(R/I) there directly:
#    affine dim 7 (both components) -> chart dim 4 (both components), confirming 7-3=4 exactly,
#    matching independent hand-derivation.

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

for f in [E11,E12,E21]:
    degs_u = set(sum(e[0:3]) for e,c in f.dict().items())
    degs_v = set(sum(e[3:6]) for e,c in f.dict().items())
    degs_w = set(sum(e[6:9]) for e,c in f.dict().items())
    print(f, "-> u-deg", degs_u, "v-deg", degs_v, "w-deg", degs_w)

print("affine dim(R/I) per component:", [Q.radical().dimension() for Q in I.primary_decomposition()])

S = PolynomialRing(QQ, ['u2','u3','v2','v3','w2','w3'])
u2s,u3s,v2s,v3s,w2s,w3s = S.gens()
subs = {u1:1,u2:u2s,u3:u3s, v1:1,v2:v2s,v3:v3s, w1:1,w2:w2s,w3:w3s}
Ichart = S.ideal([f.subs(subs) for f in [E11,E12,E21]])
PDchart = Ichart.primary_decomposition()
print("dim in chart u1=v1=w1=1 (= P^2 x P^2 x P^2 dimension) per component:",
      [Q.radical().dimension() for Q in PDchart])
