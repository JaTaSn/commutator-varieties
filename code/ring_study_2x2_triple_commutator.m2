-- 2026-08-16 (Claude-Code-5f668a8d): ring-theoretic study of R=k[u,v,w]/I for the zero locus of
-- [A,B,C]=[[A,B],C], n=2, reduced coordinates -- prompted by Jan wanting this to go into an
-- article. See working-notes/varieties-of-triple-commutators.org for the write-up.
--
-- Confirms: dim(R/I)=7, codim(I)=2; I is RADICAL (verified separately in Sage, see
-- ring_study_2x2_triple_commutator.sage); the multigraded (Z^3, one degree per block u/v/w)
-- Hilbert series, and its specialization to the ordinary Z-graded series as a cross-check
-- (caught and fixed a hand-arithmetic slip in an earlier attempt at this specialization --
-- worth rerunning this exact check if the formula is ever edited by hand again).
--
-- Run: M2 --script ring_study_2x2_triple_commutator.m2

R = QQ[u1,u2,u3,v1,v2,v3,w1,w2,w3,
       Degrees => {{1,0,0},{1,0,0},{1,0,0},{0,1,0},{0,1,0},{0,1,0},{0,0,1},{0,0,1},{0,0,1}}]
E11 = u3*v2*w1 - u2*v3*w1 + u3*v1*w2 - u1*v3*w2
E12 = -2*u2*v1*w1 + 2*u1*v2*w1 - u3*v1*w3 + u1*v3*w3
E21 = 2*u2*v1*w2 - 2*u1*v2*w2 - u3*v2*w3 + u2*v3*w3
I = ideal(E11,E12,E21)
S = R/I

print "dim(R/I), codim(I):"
print dim I
print codim I

print "3-graded (Z^3) Hilbert series -- T_0=u-degree, T_1=v-degree, T_2=w-degree:"
HS = hilbertSeries(S, Reduce=>true)
print toString numerator HS
print toString denominator HS

-- ordinary (single Z-grading) series, computed independently in a plain (ungraded-option) ring
-- as a cross-check that the multigraded one specializes correctly
R2 = QQ[u1,u2,u3,v1,v2,v3,w1,w2,w3]
I2 = sub(I, R2)
S2 = R2/I2
print "ordinary Z-graded Hilbert series (independent computation, plain grading):"
print hilbertSeries(S2, Reduce=>true)
