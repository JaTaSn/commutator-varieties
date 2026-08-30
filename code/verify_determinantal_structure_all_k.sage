# Verify: I_k = ideal of 2x2 minors of the 2x3 matrix [tau(w_{k-1}); v_k],
# where w_2 = v1 x v2 (standard cross product), w_j = tau(w_{j-1}) x v_j,
# tau(a,b,c) := (b,a,2c).

R = PolynomialRing(QQ, ['u%d'%i for i in range(1,4)]+['v%d'%i for i in range(1,4)]+
                        ['w%d'%i for i in range(1,4)]+['x%d'%i for i in range(1,4)]+
                        ['y%d'%i for i in range(1,4)]+['z%d'%i for i in range(1,4)])
gens = R.gens()
u = gens[0:3]; v = gens[3:6]; w = gens[6:9]; x = gens[9:12]; y = gens[12:15]; z = gens[15:18]

def cross(p,q):
    return (p[1]*q[2]-p[2]*q[1], p[2]*q[0]-p[0]*q[2], p[0]*q[1]-p[1]*q[0])

def tau(a):
    return (a[1],a[0],2*a[2])

def cross5(p1,p2,p3,q1,q2,q3):
    m1=(p2+p3)*q3; m2=p1*(q1-q2); m3=(p1+p3)*(q1-q2-q3); m4=p3*(q2+q3); m5=(p1-p2-p3)*(q1+q3)
    return m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5

def minors2x3(a,b):
    # three 2x2 minors of [[a0,a1,a2],[b0,b1,b2]]
    return (a[1]*b[2]-a[2]*b[1], a[0]*b[2]-a[2]*b[0], a[0]*b[1]-a[1]*b[0])

blocks = [u,v,w,x,y,z]

for k in range(2,7):
    vs = blocks[:k]
    # official H's via cross5 chaining (matching the actual code)
    X1,Y1,Z1 = cross5(*vs[0], *vs[1])
    d = (Y1,X1,2*Z1)
    for j in range(2,k-1):
        Xn,Yn,Zn = cross5(*d, *vs[j])
        d = (Yn,Xn,2*Zn)
    if k==2:
        H11,H12,H21 = Z1,Y1,X1
    else:
        Xn,Yn,Zn = cross5(*d, *vs[k-1])
        H11,H12,H21 = Zn,Yn,Xn
    I_official = R.ideal([H11,H12,H21])

    # my claimed structural formula: w_2=v1 x v2, w_j = tau(w_{j-1}) x v_j
    wk = cross(vs[0],vs[1])
    for j in range(2,k):
        wk = cross(tau(wk), vs[j])
    I_claim = R.ideal(list(wk))

    same = (I_official == I_claim)
    print(f"k={k}: official ideal == claimed cross/minors ideal? {same}")
