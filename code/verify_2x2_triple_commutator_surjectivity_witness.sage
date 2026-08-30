# 2026-08-16 (Claude-Code-5f668a8d): a concrete, directly-verified witness that [A,B,C] hits an
# arbitrary target traceless matrix -- see working-notes/varieties-of-triple-commutators.org for
# the general construction this instantiates. Uses actual 2x2 matrix multiplication (A*B-B*A etc.),
# not the reduced-coordinate formulas, as an independent check.

A = matrix(QQ, [[1,0],[0,0]])
B = matrix(QQ, [[0,-2],[-3,0]])
C = matrix(QQ, [[1,0],[-QQ(1)/2,0]])
D = A*B - B*A
E = D*C - C*D
print("A =", A); print("B =", B); print("C =", C)
print("D=[A,B] =", D)
print("E=[[A,B],C] =", E)
assert E == matrix(QQ, [[1,2],[3,-1]])
print("OK: matches target (E11,E12,E21,E22)=(1,2,3,-1) exactly")
