-- referee_geometry_pdim.m2
--
-- Changelog:
--   2026-08-31  Claude (adversarial referee, geometry/CM scope): created.
--
-- Verifies the Cohen-Macaulayness section: under the signed encoding
-- D = diag(-1,-1,1), the ideal I_k (components of w_k, w_2 = v1 x v2,
-- w_j = D(w_{j-1}) x v_j) should have pdim(R_k/I_k) = 2 for every k,
-- i.e. R_k/I_k Cohen-Macaulay (Auslander-Buchsbaum: depth = 3k-2 = dim).
-- Checked here for k = 3,4,5,6.  Also reprints codim as a cross-check.
--
-- Output: runs/referee-geometry-pdim.txt

cross = (a, b) -> {a#1*b#2 - a#2*b#1, a#2*b#0 - a#0*b#2, a#0*b#1 - a#1*b#0};
Dtw = a -> {-a#0, -a#1, a#2};

for k from 3 to 6 do (
    R := QQ[apply(flatten apply(k, i -> apply(3, j -> (i+1, j+1))),
                  p -> value("symbol v" | toString(p#0) | "_" | toString(p#1)))];
    g := gens R;
    v := apply(k, i -> {g#(3*i), g#(3*i+1), g#(3*i+2)});
    w := cross(v#0, v#1);
    for j from 2 to k-1 do w = cross(Dtw w, v#j);
    I := ideal w;
    << "k = " << k
      << "   codim = " << codim I
      << "   pdim(R/I) = " << pdim comodule I
      << "   CM (pdim==codim==2): " << (pdim comodule I == 2 and codim I == 2)
      << endl;
);
