# 2026-08-16 (Claude-Code-5f668a8d): verify a 5-multiplication formula for the 2x2 commutator
# [A,B]=AB-BA, found by a randomized local search (see search_5mult_cross_product.py) over a small
# integer ansatz, then translated from the cross-product form via u=(a12,a21,a11-a22),
# v=(b12,b21,b11-b22). This matches the known-optimal bilinear complexity R(T_sl2)=5 (Mirwald 1985,
# cited in literature/bari_structure-tensor-sln-thesis.pdf; also Gustafson & Aluru 1996 for the
# cross-product form directly) -- improves on the naive 6-multiplication formula in
# verify_2x2_commutator.sage.

R = PolynomialRing(QQ, ['a11', 'a12', 'a21', 'a22', 'b11', 'b12', 'b21', 'b22'])
a11, a12, a21, a22, b11, b12, b21, b22 = R.gens()

A = matrix(R, [[a11, a12], [a21, a22]])
B = matrix(R, [[b11, b12], [b21, b22]])
schoolbook = A * B - B * A

da = a11 - a22
db = b11 - b22

p1 = (a21 + da) * db
p2 = a12 * (b12 - b21)
p3 = (a12 + da) * (b12 - b21 - db)
p4 = da * (b21 + db)
p5 = (a12 - a21 - da) * (b12 + db)

z = p1 - p4
y = p3 - p2 + p4
x = p1 - 2*p2 + p3 + p4 + p5

derived = matrix(R, [[x, y], [z, -x]])
assert derived == schoolbook, "5-multiplication formula does NOT match AB-BA"
print("OK: 5-multiplication formula matches AB-BA exactly.")
print("Number of scalar products used: 5 (p1..p5)")
