# 2026-08-16 (Claude-Code-subagent-k3): numeric cross-check between the reduced-coordinate
# cross5-chained formula (verify_2x2_triple_commutator_10mult.sage) and literal matrix
# multiplication -- evaluates both at the same random rational point and confirms exact agreement.
# verify_2x2_triple_commutator_10mult.sage already does an exact SYMBOLIC check over all 12 free
# variables (stronger than this), but this script fills the naming-convention gap left by the
# k=4,5,6 notes, each of which has its own standalone `..._numeric_crosscheck.sage` -- added here
# for k=3 to match that pattern, not because the symbolic check left any real doubt.

R = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22','c11','c12','c21','c22'])
a11,a12,a21,a22,b11,b12,b21,b22,c11,c12,c21,c22 = R.gens()
A = matrix(R,[[a11,a12],[a21,a22]])
B = matrix(R,[[b11,b12],[b21,b22]])
C = matrix(R,[[c11,c12],[c21,c22]])
E1 = A*B-B*A
E2 = E1*C-C*E1

vals = {a11:2,a12:-1,a21:3,a22:1, b11:0,b12:4,b21:-2,b22:1, c11:1,c12:1,c21:-1,c22:2}
E11_true = E2[0,0].subs(vals); E12_true=E2[0,1].subs(vals); E21_true=E2[1,0].subs(vals)
print("ground truth E11,E12,E21:", E11_true, E12_true, E21_true)

# reduced formulas
u1v = vals[a12]; u2v=vals[a21]; u3v=vals[a11]-vals[a22]
v1v = vals[b12]; v2v=vals[b21]; v3v=vals[b11]-vals[b22]
w1v = vals[c12]; w2v=vals[c21]; w3v=vals[c11]-vals[c22]

def cross5n(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    X=m1-m4; Y=-m2+m3+m4; Z=m1-2*m2+m3+m4+m5
    return X,Y,Z

X1,Y1,Z1 = cross5n(u1v,u2v,u3v, v1v,v2v,v3v)
d1 = (Y1,X1,2*Z1)
X2,Y2,Z2 = cross5n(*d1, w1v,w2v,w3v)
E11,E12,E21 = Z2,Y2,X2
print("reduced-formula   E11,E12,E21:", E11, E12, E21)
print("MATCH:", (E11,E12,E21) == (E11_true,E12_true,E21_true))
