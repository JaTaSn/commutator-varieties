# 2026-08-16 (Claude-Code-5f668a8d): verify the hand-derived 6-multiplication formula for the
# commutator of two 2x2 matrices against the schoolbook AB-BA, symbolically over Q(a_ij, b_ij).

R = PolynomialRing(QQ, ['a11', 'a12', 'a21', 'a22', 'b11', 'b12', 'b21', 'b22'])
a11, a12, a21, a22, b11, b12, b21, b22 = R.gens()

A = matrix(R, [[a11, a12], [a21, a22]])
B = matrix(R, [[b11, b12], [b21, b22]])
schoolbook = A * B - B * A

x = a12 * b21 - a21 * b12
y = (a11 - a22) * b12 - a12 * (b11 - b22)
z = a21 * (b11 - b22) - (a11 - a22) * b21
derived = matrix(R, [[x, y], [z, -x]])

assert schoolbook == derived, "6-multiplication formula does NOT match AB-BA"
print("OK: 6-multiplication formula matches AB-BA exactly.")

products_used = [
    a12 * b21, a21 * b12,
    (a11 - a22) * b12, a12 * (b11 - b22),
    a21 * (b11 - b22), (a11 - a22) * b21,
]
print(f"Number of scalar products used: {len(products_used)}")
