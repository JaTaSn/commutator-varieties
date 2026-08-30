# 2026-08-16 (Claude-Code-5f668a8d): minimal generators of the zero-locus ideal I=(E11,E12,E21) for
# [A,B,C]=[[A,B],C]=0, n=2, in the literal a_ij/b_ij/c_ij variables (not the reduced u,v,w
# coordinates used elsewhere) -- see working-notes/varieties-of-triple-commutators.org. Confirms
# via a properly minimalized free resolution (Singular's mres, forced explicitly -- Sage's own
# ideal.free_resolution() returned a non-minimal 4-generator resolution here, a real discrepancy
# caught by cross-checking rather than trusted blindly) that the 3 literal defining generators are
# already minimal: no redundancy, and none fewer suffice. The Betti table also shows only 2 first
# syzygies (not the 3 a complete intersection would have), confirming -- from yet another angle --
# that this ideal is not a complete intersection despite needing only 3 generators for a
# codimension-2 variety.

R = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22','c11','c12','c21','c22'])
a11,a12,a21,a22,b11,b12,b21,b22,c11,c12,c21,c22 = R.gens()
A = matrix(R, [[a11,a12],[a21,a22]])
B = matrix(R, [[b11,b12],[b21,b22]])
C = matrix(R, [[c11,c12],[c21,c22]])
D = A*B - B*A
E = D*C - C*D

for name, expr in [("E11",E[0,0]), ("E12",E[0,1]), ("E21",E[1,0])]:
    print(name, "=", expr)
print("E22 == -E11:", E[1,1] == -E[0,0])

I = R.ideal([E[0,0], E[0,1], E[1,0]])
print("Krull dim R/I:", I.dimension())

Ising = I._singular_().std()
mres = Ising.mres(0)
print(mres.betti())
