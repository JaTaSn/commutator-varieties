# 2026-08-16 (Claude-Code-5f668a8d): numeric cross-check between the reduced-coordinate
# cross5-chained formula (verify_2x2_fourfold_commutator_15mult.sage) and literal matrix
# multiplication -- evaluates both at the same random rational point and confirms exact agreement,
# a stronger check than just matching dim/codim (which could in principle coincide for the wrong
# polynomials).

import random
R = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22','c11','c12','c21','c22','d11','d12','d21','d22'])
a11,a12,a21,a22,b11,b12,b21,b22,c11,c12,c21,c22,d11,d12,d21,d22 = R.gens()
A = matrix(R,[[a11,a12],[a21,a22]])
B = matrix(R,[[b11,b12],[b21,b22]])
C = matrix(R,[[c11,c12],[c21,c22]])
D = matrix(R,[[d11,d12],[d21,d22]])
E1 = A*B-B*A
E2 = E1*C-C*E1
E3 = E2*D-D*E2

vals = {a11:2,a12:-1,a21:3,a22:1, b11:0,b12:4,b21:-2,b22:1, c11:1,c12:1,c21:-1,c22:2, d11:2,d12:0,d21:1,d22:-1}
F11_true = E3[0,0].subs(vals); F12_true=E3[0,1].subs(vals); F21_true=E3[1,0].subs(vals)
print("ground truth F11,F12,F21:", F11_true, F12_true, F21_true)

# reduced formulas
u1v = vals[a12]; u2v=vals[a21]; u3v=vals[a11]-vals[a22]
v1v = vals[b12]; v2v=vals[b21]; v3v=vals[b11]-vals[b22]
w1v = vals[c12]; w2v=vals[c21]; w3v=vals[c11]-vals[c22]
x1v = vals[d12]; x2v=vals[d21]; x3v=vals[d11]-vals[d22]

def cross5n(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    X=m1-m4; Y=-m2+m3+m4; Z=m1-2*m2+m3+m4+m5
    return X,Y,Z

X1,Y1,Z1 = cross5n(u1v,u2v,u3v, v1v,v2v,v3v)
d1 = (Y1,X1,2*Z1)
X2,Y2,Z2 = cross5n(*d1, w1v,w2v,w3v)
d2 = (Y2,X2,2*Z2)
X3,Y3,Z3 = cross5n(*d2, x1v,x2v,x3v)
F11,F12,F21 = Z3,Y3,X3
print("reduced-formula   F11,F12,F21:", F11, F12, F21)
print("MATCH:", (F11,F12,F21) == (F11_true,F12_true,F21_true))
