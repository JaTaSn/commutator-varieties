-- 2026-08-31 (Claude-Code-jts-pc): projective dimension of R_k/I_k over several finite fields,
-- completing code/verify_over_finite_fields.sage (Sage's resolution API would not give pd here).
-- pd = 2 = codim is exactly Cohen-Macaulayness, by Auslander-Buchsbaum.
-- Output: runs/verify-cm-over-finite-fields.txt
Dv = u -> {-u_0, -u_1, u_2};
cross = (a,b) -> {a_1*b_2-a_2*b_1, a_2*b_0-a_0*b_2, a_0*b_1-a_1*b_0};
wk = (R,k) -> (
    v := for i from 0 to k-1 list for c from 0 to 2 list R_(3*i+c);
    w := cross(v#0, v#1);
    for t from 2 to k-1 do w = cross(Dv w, v#t);
    w);
flds = {(ZZ/2,"GF(2)"), (ZZ/3,"GF(3)"), (ZZ/5,"GF(5)"), (GF(4),"GF(4)"), (QQ,"QQ")};
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
