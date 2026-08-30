# 2026-08-16 (Claude-Code-5f668a8d): verify a 10-multiplication straight-line algorithm for the
# left-normed length-3 commutator [A,B,C]:=[[A,B],C], 2x2 matrices -- chains cross5() (the optimal
# 5-mult 2x2-commutator formula from verify_2x2_commutator_5mult.sage) twice: once for D=[A,B],
# once for [D,C], reusing D's already-computed output coordinates (D12,D21,D11-D22) as the second
# call's input "u" vector for free (pure linear combination, no extra multiplication). This is an
# upper bound on the true rank of the [A,B,C] trilinear tensor, not a proven minimum -- see
# working-notes/small-commutators-musings.org and TODO.org.

R = PolynomialRing(QQ, ['a11','a12','a21','a22','b11','b12','b21','b22','c11','c12','c21','c22'])
a11,a12,a21,a22,b11,b12,b21,b22,c11,c12,c21,c22 = R.gens()

A = matrix(R, [[a11,a12],[a21,a22]])
B = matrix(R, [[b11,b12],[b21,b22]])
C = matrix(R, [[c11,c12],[c21,c22]])

D_true = A*B - B*A
triple_true = D_true*C - C*D_true   # [[A,B],C]

def cross5(u1,u2,u3,v1,v2,v3):
    p1 = (u2+u3)*v3
    p2 = u1*(v1-v2)
    p3 = (u1+u3)*(v1-v2-v3)
    p4 = u3*(v2+v3)
    p5 = (u1-u2-u3)*(v1+v3)
    w1 = p1-p4
    w2 = -p2+p3+p4
    w3 = p1-2*p2+p3+p4+p5
    return w1,w2,w3, [p1,p2,p3,p4,p5]

# Stage 1: D = [A,B], 5 multiplications
w1,w2,w3, stage1_products = cross5(a12,a21,a11-a22, b12,b21,b11-b22)
D11, D12, D21, D22 = w3, w2, w1, -w3

# Stage 2: E = [D,C], 5 more multiplications (u_D formed for free from D's already-computed coords)
u1,u2,u3 = D12, D21, D11-D22   # = w2, w1, 2*w3 -- all free linear combos of stage-1 results
v1,v2,v3 = c12, c21, c11-c22
x1,x2,x3, stage2_products = cross5(u1,u2,u3, v1,v2,v3)
E11, E12, E21, E22 = x3, x2, x1, -x3

E_derived = matrix(R, [[E11,E12],[E21,E22]])

print("Matches true [[A,B],C] exactly:", E_derived == triple_true)
print("Total scalar multiplications used:", len(stage1_products) + len(stage2_products))
