-- 2026-08-16 (Claude-Code-5f668a8d): ground-truth [A,B,C,D]=[[[A,B],C],D], n=2, via literal
-- genericMatrix multiplication in the native 16-variable ring (no reduced coordinates, no cross5
-- shortcut) -- cross-checks verify_2x2_fourfold_commutator_15mult.sage. dim(R/J)=14, codim=2 here
-- vs dim=10, codim=2 in the reduced 12-var ring -- the +4 is exactly the four matrices' free trace
-- directions, codim unchanged as expected.

R = QQ[a11,a12,a21,a22,b11,b12,b21,b22,c11,c12,c21,c22,d11,d12,d21,d22]
A = genericMatrix(R,a11,2,2)
B = genericMatrix(R,b11,2,2)
C = genericMatrix(R,c11,2,2)
D = genericMatrix(R,d11,2,2)
E1 = A*B - B*A
E2 = E1*C - C*E1
E3 = E2*D - D*E2
print "F11 (M2, literal matrix mult):"
print toString E3_(0,0)
print "F12:"
print toString E3_(0,1)
print "F21:"
print toString E3_(1,0)
print "F22 == -F11?"
print (E3_(1,1) == -E3_(0,0))
