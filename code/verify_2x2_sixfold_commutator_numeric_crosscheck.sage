# 2026-08-16 (Claude-Code-5f668a8d): numeric cross-check for [A,B,C,D,E,F] at n=2 -- see
# ring_study_2x2_sixfold_commutator.sage and working-notes/six-fold-commutator-n2.org.

import random
R = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22','c11','c12','c21','c22',
                          'd11','d12','d21','d22','e11','e12','e21','e22','f11','f12','f21','f22'])
a11,a12,a21,a22,b11,b12,b21,b22,c11,c12,c21,c22,d11,d12,d21,d22,e11,e12,e21,e22,f11,f12,f21,f22 = R.gens()
A=matrix(R,[[a11,a12],[a21,a22]]); B=matrix(R,[[b11,b12],[b21,b22]])
C=matrix(R,[[c11,c12],[c21,c22]]); D=matrix(R,[[d11,d12],[d21,d22]])
E=matrix(R,[[e11,e12],[e21,e22]]); Fm=matrix(R,[[f11,f12],[f21,f22]])
T1=A*B-B*A; T2=T1*C-C*T1; T3=T2*D-D*T2; T4=T3*E-E*T3; T5=T4*Fm-Fm*T4

vals = {a11:2,a12:-1,a21:3,a22:1, b11:0,b12:4,b21:-2,b22:1, c11:1,c12:1,c21:-1,c22:2,
        d11:2,d12:0,d21:1,d22:-1, e11:1,e12:2,e21:-1,e22:0, f11:0,f12:1,f21:2,f22:1}
H11t=T5[0,0].subs(vals); H12t=T5[0,1].subs(vals); H21t=T5[1,0].subs(vals)
print("ground truth H11,H12,H21:", H11t,H12t,H21t)

u1v,u2v,u3v = vals[a12],vals[a21],vals[a11]-vals[a22]
v1v,v2v,v3v = vals[b12],vals[b21],vals[b11]-vals[b22]
w1v,w2v,w3v = vals[c12],vals[c21],vals[c11]-vals[c22]
x1v,x2v,x3v = vals[d12],vals[d21],vals[d11]-vals[d22]
y1v,y2v,y3v = vals[e12],vals[e21],vals[e11]-vals[e22]
z1v,z2v,z3v = vals[f12],vals[f21],vals[f11]-vals[f22]

def cross5n(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5

X1,Y1,Z1 = cross5n(u1v,u2v,u3v, v1v,v2v,v3v); d1=(Y1,X1,2*Z1)
X2,Y2,Z2 = cross5n(*d1, w1v,w2v,w3v); d2=(Y2,X2,2*Z2)
X3,Y3,Z3 = cross5n(*d2, x1v,x2v,x3v); d3=(Y3,X3,2*Z3)
X4,Y4,Z4 = cross5n(*d3, y1v,y2v,y3v); d4=(Y4,X4,2*Z4)
X5,Y5,Z5 = cross5n(*d4, z1v,z2v,z3v)
H11,H12,H21 = Z5,Y5,X5
print("reduced-formula   H11,H12,H21:", H11,H12,H21)
print("MATCH:", (H11,H12,H21)==(H11t,H12t,H21t))
