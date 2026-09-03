-- Projective dimension of R_k/I_k over several finite fields, completing
-- code/verify_over_finite_fields.sage (Sage's resolution API would not give pd here).
-- pd = 2 = codim is exactly Cohen-Macaulayness, by Auslander-Buchsbaum.
--
-- Changelog (reverse-chronological)
--   2026-09-03  Added GF(7) and GF(9).  An adversarial review found the manuscript
--               claiming in two places that the CM result had been re-run over F_7
--               and F_9, while this field list stopped at GF(4) and QQ -- and the
--               companion Sage script prints "n/a" in its pd column on every row,
--               because that Sage build cannot compute pd.  So over F_7 and F_9
--               only three of the four results had ever been checked.  Running the
--               case is cheaper than weakening the sentence, and leaves the
--               manuscript saying something true rather than something smaller.
--   2026-08-31  Created (Claude-Code-jts-pc).
--
-- Output: runs/verify-cm-over-finite-fields.txt
Dv = u -> {-u_0, -u_1, u_2};
cross = (a,b) -> {a_1*b_2-a_2*b_1, a_2*b_0-a_0*b_2, a_0*b_1-a_1*b_0};
wk = (R,k) -> (
    v := for i from 0 to k-1 list for c from 0 to 2 list R_(3*i+c);
    w := cross(v#0, v#1);
    for t from 2 to k-1 do w = cross(Dv w, v#t);
    w);
flds = {(ZZ/2,"GF(2)"), (ZZ/3,"GF(3)"), (ZZ/5,"GF(5)"), (GF(4),"GF(4)"),
        (ZZ/7,"GF(7)"), (GF(9),"GF(9)"), (QQ,"QQ")};
print "field    k   codim   pd   CM?";
print "-----------------------------------";
for f in flds do (
  F := f#0; nm := f#1;
  for k from 2 to 5 do (
    R := F[vars(0..3*k-1)];
    I := ideal wk(R,k);
    c := codim I;
    p := pdim (R^1/I);
    print(nm | "   " | toString k | "   " | toString c | "       " | toString p | "    " | (if p == c then "yes" else "NO"));
  );
);
