-- 2026-08-16 (Claude-Code-5f668a8d): ordinary and 4-graded (Z^4, one degree per matrix A/B/C/D)
-- Hilbert series for R=k[u,v,w,x]/I, [A,B,C,D] at n=2 -- see
-- working-notes/four-fold-commutator-n2.org. Specialization checked to match the ordinary series
-- exactly (via a direct Taylor-coefficient comparison, code/ not shown here -- see the note).

R = QQ[u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3,
       Degrees => {{1,0,0,0},{1,0,0,0},{1,0,0,0},
                    {0,1,0,0},{0,1,0,0},{0,1,0,0},
                    {0,0,1,0},{0,0,1,0},{0,0,1,0},
                    {0,0,0,1},{0,0,0,1},{0,0,0,1}}]

crossX = (p1,p2,p3,q1,q2,q3) -> (
  m1 := (p2+p3)*q3; m2 := p1*(q1-q2); m3 := (p1+p3)*(q1-q2-q3); m4 := p3*(q2+q3); m5 := (p1-p2-p3)*(q1+q3);
  {m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5}
)

r1 = crossX(u1,u2,u3, v1,v2,v3)
d1 = {r1_1,r1_0,2*r1_2}
r2 = crossX(d1_0,d1_1,d1_2, w1,w2,w3)
d2 = {r2_1,r2_0,2*r2_2}
r3 = crossX(d2_0,d2_1,d2_2, x1,x2,x3)
F11 = r3_2; F12 = r3_1; F21 = r3_0

I = ideal(F11,F12,F21)
S = R/I
print "dim, codim:"
print dim I
print codim I
print "4-graded Hilbert series (T0=u,T1=v,T2=w,T3=x degree):"
HS = hilbertSeries(S, Reduce=>true)
print toString numerator HS
print toString denominator HS

R2 = QQ[u1,u2,u3,v1,v2,v3,w1,w2,w3,x1,x2,x3]
I2 = sub(I,R2)
S2 = R2/I2
print "ordinary Z-graded Hilbert series (independent, plain grading):"
print hilbertSeries(S2, Reduce=>true)
