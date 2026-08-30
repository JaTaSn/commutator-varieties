-- 2026-08-16 (Claude-Code-5f668a8d): ordinary and 6-graded Hilbert series for [A,B,C,D,E,F] at
-- n=2 -- see working-notes/six-fold-commutator-n2.org. Same numerator pattern as k=3,4,5.
-- Specialization checked against the ordinary series via direct Taylor-coefficient comparison.

R = QQ[u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3,y1,y2,y3,z1,z2,z3,
       Degrees => {{1,0,0,0,0,0},{1,0,0,0,0,0},{1,0,0,0,0,0},
                    {0,1,0,0,0,0},{0,1,0,0,0,0},{0,1,0,0,0,0},
                    {0,0,1,0,0,0},{0,0,1,0,0,0},{0,0,1,0,0,0},
                    {0,0,0,1,0,0},{0,0,0,1,0,0},{0,0,0,1,0,0},
                    {0,0,0,0,1,0},{0,0,0,0,1,0},{0,0,0,0,1,0},
                    {0,0,0,0,0,1},{0,0,0,0,0,1},{0,0,0,0,0,1}}]

crossX = (p1,p2,p3,q1,q2,q3) -> (
  m1 := (p2+p3)*q3; m2 := p1*(q1-q2); m3 := (p1+p3)*(q1-q2-q3); m4 := p3*(q2+q3); m5 := (p1-p2-p3)*(q1+q3);
  {m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5}
)

r1 = crossX(u1,u2,u3, v1,v2,v3)
d1 = {r1_1,r1_0,2*r1_2}
r2 = crossX(d1_0,d1_1,d1_2, w1,w2,w3)
d2 = {r2_1,r2_0,2*r2_2}
r3 = crossX(d2_0,d2_1,d2_2, x1,x2,x3)
d3 = {r3_1,r3_0,2*r3_2}
r4 = crossX(d3_0,d3_1,d3_2, y1,y2,y3)
d4 = {r4_1,r4_0,2*r4_2}
r5 = crossX(d4_0,d4_1,d4_2, z1,z2,z3)
H11 = r5_2; H12 = r5_1; H21 = r5_0

I = ideal(H11,H12,H21)
S = R/I
print "dim, codim:"
print dim I
print codim I
print "6-graded Hilbert series (T0..T5 = u,v,w,x,y,z degree):"
HS = hilbertSeries(S, Reduce=>true)
print toString numerator HS
print toString denominator HS

R2 = QQ[u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3,y1,y2,y3,z1,z2,z3]
I2 = sub(I,R2)
S2 = R2/I2
print "ordinary Z-graded Hilbert series (independent check):"
print hilbertSeries(S2, Reduce=>true)
