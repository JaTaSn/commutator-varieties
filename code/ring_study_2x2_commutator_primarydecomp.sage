# 2026-08-16 (Claude-Code-subagent-k2): primary decomposition of [A,B]'s zero locus, n=2, k=2 --
# see working-notes/iterated-commutator-n_2-k_2.org. Base case of conjecture 2 from the k=3..6
# battery (I_k has exactly k-1 radical primary components): here k-1=1, i.e. I itself should
# already be prime. Geometrically this is the classical variety of rank-<=1 2x3 matrices (u,v
# parallel as vectors in R^3, matching [A,B]=0 <=> u x v=0 under the sl2~so(3) identification) --
# a generic determinantal variety, always irreducible.

R = PolynomialRing(QQ, ['u1','u2','u3','v1','v2','v3'])
u1,u2,u3,v1,v2,v3 = R.gens()
def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5
X1,Y1,Z1 = cross5(u1,u2,u3, v1,v2,v3)
H11,H12,H21 = Z1,Y1,X1
I = R.ideal([H11,H12,H21])

print("starting primary decomposition...")
import time
t0 = time.time()
PD = I.primary_decomposition()
print("elapsed:", time.time()-t0, "seconds")
print("number of primary components:", len(PD))
for i,Q in enumerate(PD):
    P = Q.radical()
    print(f"component {i}: dim={P.dimension()}, Q==Q.radical()? {Q==Q.radical()}, num_gens={len(P.gens())}")

print()
print("=== is I itself prime? ===")
print("I.is_prime():", I.is_prime())
