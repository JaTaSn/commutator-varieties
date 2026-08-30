-- 2026-08-16 (Claude-Code-subagent-k2): ordinary and 2-graded Hilbert series for [A,B] at n=2,
-- k=2 (base case) -- see working-notes/iterated-commutator-n_2-k_2.org. Companion to
-- hilbert_series_2x2_{triple,fourfold,fivefold,sixfold}_commutator.m2 for k=3..6. Specialization
-- checked against the ordinary series via direct Taylor-coefficient comparison, same discipline as
-- k=3..6 (never trust the k-graded formula's shape alone).

R = QQ[u1,u2,u3,v1,v2,v3,
       Degrees => {{1,0},{1,0},{1,0},
                    {0,1},{0,1},{0,1}}]

crossX = (p1,p2,p3,q1,q2,q3) -> (
  m1 := (p2+p3)*q3; m2 := p1*(q1-q2); m3 := (p1+p3)*(q1-q2-q3); m4 := p3*(q2+q3); m5 := (p1-p2-p3)*(q1+q3);
  {m1-m4, -m2+m3+m4, m1-2*m2+m3+m4+m5}
)

r1 = crossX(u1,u2,u3, v1,v2,v3)
H11 = r1_2; H12 = r1_1; H21 = r1_0

I = ideal(H11,H12,H21)
S = R/I
print "dim, codim:"
print dim I
print codim I
print "2-graded Hilbert series (T0,T1 = u,v degree):"
HS = hilbertSeries(S, Reduce=>true)
print toString numerator HS
print toString denominator HS

R2 = QQ[u1,u2,u3,v1,v2,v3]
I2 = sub(I,R2)
S2 = R2/I2
print "ordinary Z-graded Hilbert series (independent check):"
print hilbertSeries(S2, Reduce=>true)
