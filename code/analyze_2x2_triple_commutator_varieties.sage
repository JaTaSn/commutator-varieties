# 2026-08-16 (Claude-Code-5f668a8d): the two varieties attached to [A,B,C]=[[A,B],C] at n=2, in the
# reduced 3+3+3->3 coordinates u=(a12,a21,dA), v=(b12,b21,dB), w=(c12,c21,dC) -- see
# working-notes/varieties-of-triple-commutators.org for the write-up. Computes: (1) the Krull
# dimension and primary decomposition of the zero locus {[A,B,C]=0} (result: dimension 7 in the
# reduced ring / 10 in the full R^12 picture, exactly 2 prime components of that dimension each);
# (2) the Jacobian rank of the image map at a generic point (result: full rank 3, confirming the
# map is dominant / consistent with the surjectivity established separately by explicit
# construction).

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
print("Krull dimension of R/I (9 ambient vars):", I.dimension())

PD = I.primary_decomposition()
print("number of primary components:", len(PD))
for i,Q in enumerate(PD):
    P = Q.radical()
    print(f"component {i}: dim={P.dimension()}, gens={P.gens()}")

J = jacobian([E11,E12,E21], [u1,u2,u3,v1,v2,v3,w1,w2,w3])
pt = {u1:2,u2:-1,u3:3,v1:1,v2:4,v3:-2,w1:-3,w2:2,w3:1}
print("Jacobian rank at a generic test point:", J.subs(pt).rank())
