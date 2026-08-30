// Changelog (reverse chronological):
// 2026-08-19 - Claude: created. A companion to article/ring-of-k-commuting-2x2-matrices.typ (the
//   canonical, unmodified version -- kept exactly as it was, per Jan's explicit instruction), using
//   a different encoding of a traceless 2x2 matrix as a triple in FF^3, found while exploring
//   alternatives to the canonical article's red()/tau() pair
//   (working-notes/alternative-encodings-musings.org has the full derivation and the comparison
//   against two other candidates). Every theorem statement below is IDENTICAL to the canonical
//   article's, and stays proven for exactly the same reason: any invertible linear re-encoding of
//   each A_i gives an ideal isomorphic to the one the canonical article studies (classical
//   GL(3)-transformation law for the cross product, verified in
//   code/verify_encoding_gl3_equivariance.sage), so nothing needed re-proving from scratch -- only
//   Section 3 (Setup)'s derivation, the explicit low-degree polynomials shown throughout, and the
//   Jacobian-recursion machinery of Section 7 needed to be redone in the new coordinates. All new
//   explicit polynomials below computed directly, not hand-derived
//   (code/compute_signed_encoding_examples.sage); the base identity and its k=3 chaining verified as
//   genuine polynomial identities in code/verify_lorentzian_encoding_identity.sage.
//   Style/tooling identical to the canonical article: theorion (@preview/theorion:0.6.0),
//   cosmos.fancy, one continuous theorem counter, hand-rolled bibliography.
//   Compile: `typst compile ring-of-k-commuting-2x2-matrices-signed-encoding.typ
//   ring-of-k-commuting-2x2-matrices-signed-encoding.pdf` from this directory.

#set page(paper: "a4", margin: 2.0cm, numbering: "1")
#set text(size: 10.5pt, lang: "en")
#set par(justify: true, leading: 0.58em, spacing: 0.72em, first-line-indent: 1.2em)
#set heading(numbering: "1.")
#show heading: set block(above: 1.4em, below: 0.75em)
#show heading: set text(size: 12pt)
#set math.equation(numbering: "(1)", supplement: none)

// --- Theorem environments via theorion --------------------------------------
#import "@preview/theorion:0.6.0": *
#import cosmos.fancy: *
#show: show-theorion
#set-inherited-levels(0)

// --- Bibliography (unaffected by theorion -- hand-rolled as before) --------
#let bibnum = (
  BrunsVetter1988: 1,
  EagonNorthcott1962: 2,
  MotzkinTaussky1955: 3,
  Stacks00OS: 4,
  Gerstenhaber1961: 5,
  ArtinHochsterConjecture: 6,
  MajidiZolbaninSnapp: 7,
  Chau2024: 8,
  Hreinsdottir2005: 9,
  Knutson2003: 10,
  Youcis2014: 11,
)
#let bcite(key, detail: none) = {
  let n = bibnum.at(key)
  let l = label("bib-" + key)
  if detail == none { link(l)[[#n]] } else { link(l)[[#n, #detail]] }
}
#let bibentry(key, body) = block(width: 100%, above: 0.55em, below: 0.55em)[
  #grid(columns: (1.5em, 1fr), gutter: 0.3em, [#text(size: 0.95em)[[#bibnum.at(key)]]], body)
  #metadata(bibnum.at(key))#label("bib-" + key)
]

#let RR = $bb(R)$
#let QQ = $bb(Q)$
#let AA = $bb(A)$
#let FF = $bb(F)$
#let PP = $bb(P)$

#let vek(x) = $overline(#x)$

// =============================================================================

#align(center)[
  #block(width: 90%)[
    #text(size: 15pt, weight: "bold")[
      The coordinate ring of the $k$-fold iterated commutator locus for $2 times 2$ matrices,
      via a signed encoding
      #footnote[Working draft, 2026-08-19. A *companion* to
      #text(style: "italic")[ring-of-k-commuting-2x2-matrices.typ] (kept exactly as it was),
      encoding a traceless matrix's free entries differently -- see
      #text(style: "italic")[working-notes/alternative-encodings-musings.org] for the derivation
      and the comparison against two other candidates, and this footnote's closing paragraph for
      why the difference is more than cosmetic. Every theorem statement below is verbatim identical
      to the canonical article's; only the Setup section, the explicit low-degree examples, and the
      Jacobian-recursion machinery of §7 needed to be redone. Uses "theorion" for theorem
      environments, matching the canonical article's own standing default.]
    ]
  ]
  #v(0.8em)
  #text(size: 11pt)[Jan Snellman
    #h(0.25em)#link("https://orcid.org/0009-0002-6676-5068")[#text(size: 8pt, fill: rgb("#a6ce39"))[iD]
    #text(size: 8pt)[0009-0002-6676-5068]]]
  #v(0.35em)
  #text(size: 9pt)[Matematiska Institutionen, Linköpings Universitet, 581 83 Linköping, Sweden]
  #v(0.15em)
  #text(size: 9pt)[#link("mailto:jan.snellman@liu.se")[jan.snellman\@liu.se]]
]

#v(1.0em)

#pad(x: 1.6cm)[
  #text(size: 9.2pt)[
    #align(center)[*Abstract*]
    #v(0.25em)
    This is a companion to #text(style: "italic")[ring-of-k-commuting-2x2-matrices.typ], proving the
    *same* four results about the coordinate ring of the $k$-fold iterated commutator locus for
    $2 times 2$ matrices -- codimension 2, exactly 3 minimal generators, Cohen-Macaulayness, and
    radicality, assembling into the same Primary Decomposition Theorem $I_k = P_2 inter dots.c inter
    P_k$ -- using a different encoding of a traceless matrix as a triple in $FF^3$. Where the
    canonical article's encoding turns the bracket into a cross product composed with the twist
    $tau(a,b,c)=(b,a,2c)$ (a coordinate swap *and* a scaling by 2), this one turns it into a cross
    product composed with $D := "diag"(-1,-1,1)$ -- no swap, no scaling beyond a sign, and $D^2=I$
    (an involution, unlike $tau$). The reason a purely-sign twist exists at all is structural, not
    luck: the invariant quadratic form of $frak(s l)_2$ in these coordinates -- the matrix
    determinant itself, $det(A_0)=-x^2-y z$ for traceless $A_0$ -- has an indefinite signature that
    Sylvester's law of inertia says $D$'s sign pattern already realizes optimally over any field of
    characteristic $eq.not 2$. Every theorem below transfers from the canonical article for free
    (any invertible linear re-encoding gives an isomorphic ideal, by the classical
    $"GL"(3)$-transformation law for the cross product), so only the exposition, not the mathematics,
    is new here.
  ]
]

#v(0.8em)

= Introduction

This article studies the *same object* as its companion
#text(style: "italic")[ring-of-k-commuting-2x2-matrices.typ]: for $2 times 2$ matrices
$A_1,dots,A_k$, the left-normed iterated commutator $[A_1,dots,A_k] :=
[dots[[A_1,A_2],A_3],dots,A_k]$, and $I_k$, the ideal in the $3k$-variable reduced-coordinate
polynomial ring $R_k$ cutting out its vanishing locus. The companion article works entirely with
the encoding $"red"(A) := (a_12,a_21,a_11-a_22)$ and the twist $tau(a,b,c) := (b,a,2c)$ needed to
turn $[A,B]$'s bracket into a cross product; this article uses instead
$ "enc"(A) := (a_11-a_22,\ a_12+a_21,\ a_12-a_21) in FF^3, $
which turns out to need only the sign-diagonal twist $D:="diag"(-1,-1,1)$ in the analogous identity
(@thm-basic-identity below) -- no coordinate swap, and only a sign rather than a scaling by 2. Both
encodings are legitimate; the point of writing this second article is that the resulting exposition
is genuinely simpler, not merely different, for reasons made precise in @rem-why-D below. Every
result proven in the companion article -- codimension, generator count, Cohen-Macaulayness,
radicality, and the resulting Primary Decomposition Theorem -- holds here too, by the *same* proofs
in substance; what changes is Section 3's derivation, the concrete low-degree formulas displayed in
examples throughout, and the Jacobian-recursion machinery of §7 (which needs $D$ in place of
$tau$). See the companion article's own Introduction for the classical-commuting-variety backstory
(Motzkin-Taussky, Gerstenhaber, the Artin-Hochster conjecture) -- not repeated here to avoid
duplicating material unrelated to the encoding question this article is actually about.

= Notation

Notation used across more than one later result; see the companion article's own Notation section
for anything not listed here (the only genuinely new symbol below is $D$, replacing $tau$).

#align(center)[
  #table(
    columns: 3,
    align: (center, left, left),
    stroke: 0.5pt,
    inset: 6pt,
    [*Symbol*], [*Meaning*], [*Defined in*],
    [$vek(v)$ (also $vek(v)_i$; components $v_(i,1),v_(i,2),v_(i,3)$, or $v_(i,j)$)],
      [reduced-coordinate vector in $FF^3$, and its blocks], [§3, Setup],
    [$D$], [the sign twist $D := "diag"(-1,-1,1)$], [§3, Setup ($D$ as a matrix throughout)],
    [$FF$], [ambient field, characteristic $eq.not 2$], [§3, after @def-wk's example],
    [$R_k$], [the polynomial ring $FF[vek(v)_1,dots,vek(v)_k]$], [@def-wk],
    [$I_k$], [the defining ideal, $I_k subset R_k$], [@def-wk],
    [$vek(w)_j$], [(a) the recursive vector in $FF^3$; (b) as a polynomial map $AA^(3j) -> AA^3$],
      [(a) @def-wk; (b) @lem-nondeg],
    [$U_j$], [the Zariski-open locus where $vek(w)_j eq.not 0$], [@lem-nondeg],
    [$pi$], [the projection $AA^(3k) -> AA^(3(k-1))$ forgetting $vek(v)_k$], [@def-y1y2],
    [$Phi$], [the map $AA^(3(k-1)) times AA^1 -> AA^(3k)$], [@def-y1y2],
    [$Y_1$, $Y_2$], [the two strata of $V(I_k)$], [@def-y1y2],
    [$P_j$ ($j=2,dots,k$)], [the primary components of $I_k$], [@def-primecomponents],
    [$J_k$], [the Jacobian of $vek(w)_k$], [@lem-jacrecursion],
    [$[u]_times$], [skew matrix with $[u]_times v = u times v$], [@lem-jacrecursion],
  )
]

= Setup: the signed encoding and the defining ideal

*Step 1: discard the scalar part.* Identical to the companion article: $[A,B]=[A_0,B_0]$ for
$A_0,B_0$ the traceless remainders, since scalar matrices are central.

*Step 2: encode the traceless remainder.* A traceless matrix $mat(x,y;z,-x)$ has three free entries.
Rather than reading them off directly ($x,y,z$ themselves -- shown in @rem-why-D below to be a
strictly *worse* choice, needing two separate factors of 2), take
$ "enc"(A) := (a_11-a_22,\ a_12+a_21,\ a_12-a_21) in FF^3, $
the traceless $(1,1)$-entry doubled (as in the companion article's $d_a$), and $A$'s two off-diagonal
entries replaced by their sum and difference. As with the companion article's $"red"$, no division
is needed to *compute* $"enc"$ -- only its inverse (recovering $a_12,a_21$ individually as
$(v_2+v_3)/2$ and $(v_2-v_3)/2$) needs $2$ invertible, exactly the same hypothesis the companion
article already carries, not a new one.

*Step 3: form the commutator.* As before, $[A_0,B_0]$ is again traceless, hence again encodable.

*Step 4: the encoded bracket is the cross product, up to one fixed sign twist.*

#theorem[the basic identity][
  For traceless $2 times 2$ matrices $A_0,B_0$ over $FF$ ($"char" FF eq.not 2$),
  $ "enc"([A_0,B_0]) = D("enc"(A_0) times "enc"(B_0)), quad D := mat(-1,0,0;0,-1,0;0,0,1). $
] <thm-basic-identity>

#proof[Proof of @thm-basic-identity][
  A direct computation, carried out symbolically over generic entries $a_11,dots,b_22$ (not merely
  checked at sampled points) in
  #text(style: "italic")[code/verify\_lorentzian\_encoding\_identity.sage]: both sides, expanded in
  the 8 free entries, agree term by term.
]

#remark[why this particular twist, and not some other one][
  Three concrete respects in which $D$ improves on the companion article's $tau(a,b,c)=(b,a,2c)$,
  each checked, not merely asserted:
  + *$D$ does not mix coordinates.* $tau$ swaps two of its three inputs; $D$ acts diagonally, one
    coordinate at a time. Consequence: the companion article needs a page-length remark ("why
    $vek(w)_j$ carries no outer $tau$") to justify that rescaling+swapping a generating set by an
    invertible linear map doesn't change the ideal generated. Here the analogous fact is immediate:
    *individually* negating two of three generators obviously leaves the ideal unchanged, generator
    by generator -- no swap to account for. (Still verified computationally, not merely asserted:
    $"ideal"(vek(w)_2) = "ideal"(D vek(w)_2)$, confirmed by direct Gröbner-basis equality in
    #text(style: "italic")[code/verify\_encoding\_gl3\_equivariance.sage].)
  + *$D$ is an involution; $tau$ is not.* $D^2 = I$ exactly (immediate from the diagonal entries
    being $plus.minus 1$), while $tau^2 = "diag"(1,1,4) eq.not I$.
  + *$D$ is not an arbitrary matrix that happens to work -- it is (up to a constant) the matrix of
    $frak(s l)_2$'s own Killing form, in these coordinates.* For traceless
    $A_0=mat(x,y;z,-x)$, $det(A_0) = -x^2-y z$, an *indefinite* quadratic form (never definite: $-y z
    = -((y+z)\/2)^2+((y-z)\/2)^2$ is a genuine difference of squares whenever $2 eq.not 0$). Checked
    directly: $-"enc"(A)_1^2 - "enc"(A)_2^2 + "enc"(A)_3^2 = 4 det(A_0)$, exactly (Sage, symbolic).
    So $D$'s sign pattern *is* $det$'s own signature, read off in these coordinates -- not a
    bookkeeping accident. (Lie-theoretically: $frak(s l)_2(RR) tilde.equiv frak(s o)(2,1)$, the
    Lorentz algebra, not the compact $frak(s o)(3)$ one gets only after adjoining $i$ -- classical,
    not cited to a specific source here, the same way the companion article leaves certain folklore
    facts uncited rather than inventing a citation.) By Sylvester's law of inertia the signature of
    a quadratic form is an invariant of the form itself, not of the coordinates chosen to express
    it -- so no linear re-encoding over a field where $-1$ is not a square of $1$ (in particular no
    real or rational one) can ever remove this sign entirely; $D$'s single-sign twist is, in this
    precise sense, already the simplest one achievable, not merely simpler than $tau$ by luck.
  See #text(style: "italic")[working-notes/alternative-encodings-musings.org] for the fuller
  discussion, including why the "obvious" un-permuted reading of the matrix entries is actually
  *worse* than either encoding (needs a swap *and* two separate factors of 2), and a remark on why
  the field-extension route to a literal, untwisted cross product ($i in FF$, giving
  $frak(s u)(2) tilde.equiv frak(s o)(3)$ instead) is a real alternative but a strictly narrower one.
] <rem-why-D>

#definition[reduced iterated commutator, signed encoding][
  $ vek(w)_2 := vek(v)_1 times vek(v)_2, quad vek(w)_j := D(vek(w)_(j-1)) times vek(v)_j quad (j=3,dots,k). $
  Let $R_k := QQ[vek(v)_1,dots,vek(v)_k]$ ($vek(v)_i in QQ^3$, $3k$ variables) and $I_k subset R_k$ the
  ideal generated by the three components of $vek(w)_k$.
] <def-wk>

As in the companion article, "$R_k := QQ[vek(v)_1,dots,vek(v)_k]$" is shorthand for the polynomial
ring in $3k$ scalar variables $v_(i,j)$, grouped into $k$ blocks of three -- see that article's own
worked-out $R_2$ display, identical here up to variable naming.

#example[$vek(w)_k$ and $I_k$, explicitly, for $k=2,3,4$][
  Computed directly (#text(style: "italic")[code/compute\_signed\_encoding\_examples.sage]), not
  hand-derived. At $k=2$, the three components of $vek(w)_2 = vek(v)_1 times vek(v)_2$:
  $ v_(1,2)v_(2,3)-v_(1,3)v_(2,2), quad v_(1,3)v_(2,1)-v_(1,1)v_(2,3), quad
    v_(1,1)v_(2,2)-v_(1,2)v_(2,1). $
  (Identical to the companion article's $k=2$ display -- the two encodings agree exactly at the very
  first stage, since neither $tau$ nor $D$ is applied yet.) At $k=3$, the three components of
  $vek(w)_3 = D(vek(w)_2) times vek(v)_3$ -- now with *every coefficient equal to $plus.minus 1$*, no
  factor of 2 anywhere, unlike the companion article's $tau$-twisted $vek(w)_3$:
  $ v_(1,2)v_(2,1)v_(3,2) - v_(1,1)v_(2,2)v_(3,2) - v_(1,3)v_(2,1)v_(3,3) + v_(1,1)v_(2,3)v_(3,3), $
  $ -v_(1,2)v_(2,1)v_(3,1) + v_(1,1)v_(2,2)v_(3,1) - v_(1,3)v_(2,2)v_(3,3) + v_(1,2)v_(2,3)v_(3,3), $
  $ v_(1,3)v_(2,1)v_(3,1) - v_(1,1)v_(2,3)v_(3,1) + v_(1,3)v_(2,2)v_(3,2) - v_(1,2)v_(2,3)v_(3,2), $
  and $I_3 := (w_(3,1),w_(3,2),w_(3,3))$. At $k=4$, $vek(w)_4 = D(vek(w)_3) times vek(v)_4$: again every
  coefficient is $plus.minus 1$; the first component of $vek(w)_4$ is
  $ -v_(1,3)v_(2,1)v_(3,1)v_(4,2) + v_(1,1)v_(2,3)v_(3,1)v_(4,2) - v_(1,3)v_(2,2)v_(3,2)v_(4,2)
    + v_(1,2)v_(2,3)v_(3,2)v_(4,2) $
  $ + v_(1,2)v_(2,1)v_(3,1)v_(4,3) - v_(1,1)v_(2,2)v_(3,1)v_(4,3) + v_(1,3)v_(2,2)v_(3,3)v_(4,3)
    - v_(1,2)v_(2,3)v_(3,3)v_(4,3), $
  the other two of the same shape (omitted for space; all three components of $vek(w)_4$, and
  $I_4:=(w_(4,1),w_(4,2),w_(4,3))$, in
  #text(style: "italic")[code/compute\_signed\_encoding\_examples.sage]'s output).
] <ex-wk-signed>

Stated over $QQ$, as in the companion article, but every result below holds over an arbitrary field
$FF$ of characteristic $eq.not 2$ (needed only for $"enc"$'s own invertibility as a map on matrices
-- see Step 2 above; $D$ itself is invertible, in fact $det D = 1$, in *every* characteristic,
though this article does not pursue whether the ring-theoretic results below could be extended to
characteristic 2 by some other route -- flagged as a genuinely open question, not investigated
here, prompted purely by the observation that every formula in @ex-wk-signed above is already free
of any numeric coefficient besides $plus.minus 1$).

= The determinantal structure and the generator count

#theorem[determinantal structure][
  For $k >= 3$, $I_k$ is exactly the ideal of $2 times 2$ minors of the $2 times 3$ matrix
  $ mat(D(vek(w)_(k-1)); vek(v)_k), $
  i.e. $V(I_k)$ is the preimage, under $(vek(v)_1,dots,vek(v)_k) |-> mat(D(vek(w)_(k-1)(vek(v)_1,dots,vek(v)_(k-1)));
  vek(v)_k)$, of the classical rank-$<=1$ determinantal variety of $2 times 3$ matrices. (At $k=2$ the
  same statement holds with $D(vek(w)_(k-1))$ replaced by $vek(v)_1$ itself.)
] <thm-determinantal>

#proof[Proof of @thm-determinantal][
  Immediate from @def-wk's recursion and the fact that a cross product's three components are, up
  to sign, exactly the $2 times 2$ minors of the $2 times 3$ matrix with the two crossed vectors as
  rows -- and checked independently at $k=2,dots,4$ against @thm-basic-identity's identity, chained
  (#text(style: "italic")[code/compute\_signed\_encoding\_examples.sage]); the underlying polynomial
  identity makes this a two-line induction valid for every $k$, exactly as in the companion
  article's own @thm-determinantal.
]

#example[the $2 times 3$ matrix of @thm-determinantal, for $k=3,4$][
  At $k=3$, the first row is $D(vek(w)_2) = (-w_(2,1),-w_(2,2),w_(2,3))$ -- note this is *literally*
  $vek(w)_2$ with its first two components negated, not a mix of $vek(w)_2$'s components the way the
  companion article's $tau(vek(w)_2)$ swaps two of them:
  $ mat(D(vek(w)_2); vek(v)_3) = mat(
      -v_(1,2)v_(2,3)+v_(1,3)v_(2,2), -v_(1,3)v_(2,1)+v_(1,1)v_(2,3), v_(1,1)v_(2,2)-v_(1,2)v_(2,1);
      v_(3,1), v_(3,2), v_(3,3)
    ). $
  At $k=4$, the first row is $D(vek(w)_3)$, entries cubic, every coefficient $plus.minus 1$:
  $ mat(
      -v_(1,2)v_(2,1)v_(3,2) + v_(1,1)v_(2,2)v_(3,2) + v_(1,3)v_(2,1)v_(3,3) - v_(1,1)v_(2,3)v_(3,3), quad dots.h.c, quad dots.h.c;
      v_(4,1), v_(4,2), v_(4,3)
    ) $
  (other two entries of the same shape, omitted for width -- all displayed in full in
  #text(style: "italic")[code/compute\_signed\_encoding\_examples.sage]).
]

#lemma[non-degeneracy][
  For every $j >= 2$, the polynomial map $vek(w)_j : AA^(3j) -> AA^3$ is not identically zero. Hence
  $U_j := {p in AA^(3j) : vek(w)_j (p) eq.not 0}$ is a nonempty Zariski-open subset.
] <lem-nondeg>

#proof[Proof of @lem-nondeg][
  By induction: $vek(w)_2(e_1,e_2)=e_1 times e_2=e_3 eq.not 0$; given $c := vek(w)_(j-1)(p) eq.not 0$,
  $D(c) eq.not 0$ since $D$ is invertible ($det D = 1 eq.not 0$, in *every* characteristic -- a
  strictly weaker requirement than the companion article's own use of $tau$'s invertibility, which
  needs characteristic $eq.not 2$ specifically), so at least one standard basis vector is not
  proportional to $D(c)$, and a cross product vanishes only on linearly dependent pairs, giving
  $vek(w)_j(p,e_i) = D(c) times e_i eq.not 0$ for a suitable $e_i$.
]

#lemma[independent same-degree generators are minimal][
  If a homogeneous ideal in a graded ring is generated by finitely many forms of the same degree
  that are linearly independent over the base field, that generating set is minimal.
] <lem-mingens-generic>

#proof[Proof of @lem-mingens-generic][
  A polynomial-coefficient combination reproducing one of the generators from the others, while
  staying in the same degree, can only use degree-0 (constant) coefficients -- so a redundant
  generator would violate linear independence directly.
]

#lemma[the three generators of $I_k$ are independent][
  The three components of $vek(w)_k$ are linearly independent over $FF$, for every $k >= 2$.
] <lem-mingens-indep>

#proof[Proof of @lem-mingens-indep][
  Checked directly (coefficient-matrix rank 3) at $k=2,3,4$. Structurally: a nontrivial constant
  linear relation among the components of $vek(w)_k = D(vek(w)_(k-1)) times vek(v)_k$ would force
  $D(vek(w)_(k-1))$ itself to be a constant vector, which it is not for $k >= 3$ (@lem-nondeg's
  non-degeneracy, $D$ invertible) nor for $k=2$ ($vek(v)_1$ is a free variable block).
]

#theorem[$I_k$ has exactly 3 minimal generators][
  For every $k >= 2$: $I_k$ has exactly 3 minimal generators.
] <thm-mingens>

#proof[Proof of @thm-mingens][
  Immediate from @lem-mingens-generic applied to @lem-mingens-indep's independence.
]

= The geometric structure of $V(I_k)$

This section's topological lemma (continuous images and closures preserve irreducibility) and the
remark on why the closure, not the raw image, is what @thm-codim's proof needs, are identical to the
companion article's own §5 material and not repeated here -- neither uses $tau$ or $D$ at all, so
nothing changes.

#definition[the strata $Y_1$, $Y_2$][
  For $k >= 3$, write $pi$ for the projection forgetting $vek(v)_k$, and $Phi$ for
  $ Phi : AA^(3(k-1)) times AA^1 -> AA^(3k), quad Phi(p,lambda) := (p,\ lambda D(vek(w)_(k-1)(p))). $
  $ Y_1 := V(I_(k-1)) times AA^3, quad Y_2 := overline(Phi(AA^(3k-2))). $
  At $k=2$, $Y_2 := V(I_2)$ directly, matching @thm-determinantal's base case.
] <def-y1y2>

#lemma[$Y_2$ is irreducible][
  For $k >= 3$: $Y_2$ is irreducible, and its defining ideal (the graph ideal of $Phi$ with
  $lambda$ eliminated) is prime.
] <lem-y2-irred>

#proof[Proof of @lem-y2-irred][
  Identical argument to the companion article's own @lem-y2-irred: $Phi$ is a polynomial map, hence
  Zariski-continuous, with irreducible domain, so its image and closure are irreducible; the
  elimination ideal is the kernel of a map into a domain, hence prime. Additionally corroborated
  computationally at $k=3,4$ by computing the elimination ideal directly (below) and confirming
  primality in Sage.
]

#example[the defining ideal of $Y_2$, at $k=3,4$][
  Computed directly by eliminating $lambda$ from the graph ideal of $Phi$
  (#text(style: "italic")[code/compute\_signed\_encoding\_examples.sage]). At $k=3$:
  $ v_(2,1)v_(3,1) + v_(2,2)v_(3,2) - v_(2,3)v_(3,3), quad
    v_(1,1)v_(3,1) + v_(1,2)v_(3,2) - v_(1,3)v_(3,3), $
  $ v_(1,2)v_(2,1)v_(3,2) - v_(1,1)v_(2,2)v_(3,2) - v_(1,3)v_(2,1)v_(3,3) + v_(1,1)v_(2,3)v_(3,3) $
  -- again every coefficient $plus.minus 1$, in contrast with the companion article's $k=3$ display,
  which has explicit factors of 2 on two of the three generators (an artifact of $tau$'s own
  doubling, not present here). This ideal is a proper factor of $I_3$, matching $P_3$ in the
  component-count example below. At $k=4$:
  $ v_(3,1)v_(4,1) + v_(3,2)v_(4,2) - v_(3,3)v_(4,3), $
  $ v_(1,3)v_(2,2)v_(4,1) - v_(1,2)v_(2,3)v_(4,1) - v_(1,3)v_(2,1)v_(4,2)
    + v_(1,1)v_(2,3)v_(4,2) + v_(1,2)v_(2,1)v_(4,3) - v_(1,1)v_(2,2)v_(4,3), $
  $ v_(1,3)v_(2,1)v_(3,1)v_(4,2) - v_(1,1)v_(2,3)v_(3,1)v_(4,2) + v_(1,3)v_(2,2)v_(3,2)v_(4,2)
    - v_(1,2)v_(2,3)v_(3,2)v_(4,2) $
  $ - v_(1,2)v_(2,1)v_(3,1)v_(4,3) + v_(1,1)v_(2,2)v_(3,1)v_(4,3) - v_(1,3)v_(2,2)v_(3,3)v_(4,3)
    + v_(1,2)v_(2,3)v_(3,3)v_(4,3). $
]

#example[a suitable point of $Y_2$, concretely, at $k=3$][
  Take $vek(v)_1=(1,0,0)$, $vek(v)_2=(0,1,0)$ (so $vek(v)_1 in U_2$, @lem-nondeg), giving
  $vek(w)_2=vek(v)_1 times vek(v)_2=(0,0,1)$ and $D(vek(w)_2) = (0,0,1)$ -- here $D$ acts as the identity,
  since both of $vek(w)_2$'s sign-flipped coordinates already vanish, a strictly cleaner example than
  the companion article's own $D$-analogue point ($tau(vek(w)_2)=(0,0,2)$ there, carrying an explicit
  factor of 2). Taking $lambda=1$, i.e. $vek(v)_3 := D(vek(w)_2) = (0,0,1)$, gives
  $ (vek(v)_1,vek(v)_2,vek(v)_3) = ((1,0,0),(0,1,0),(0,0,1)) in Y_2 subset AA^9. $
  Directly: $vek(w)_3 = D(vek(w)_2) times vek(v)_3 = (0,0,1) times (0,0,1) = 0$, confirming this point
  lies in $V(I_3)$.
]

#lemma[dimension of $Y_2$, and where it lives][
  With $Y_2$ as in @lem-y2-irred and $U_(k-1)$ as in @lem-nondeg: $dim Y_2 = 3k-2$, and $Y_2$ meets
  $pi^(-1)(U_(k-1))$ nonemptily.
] <lem-y2-dim>

#proof[Proof of @lem-y2-dim][
  Over $U_(k-1)$, $Phi$ is injective: $p$ is recovered directly, and $lambda$ by dividing any
  nonzero coordinate of $vek(v)_k = lambda D(vek(w)_(k-1)(p))$ by the corresponding coordinate of
  $D(vek(w)_(k-1)(p))$ -- a division by a nonzero *field element*, needing nothing about
  characteristic beyond that coordinate being nonzero, which $D(vek(w)_(k-1)(p)) eq.not 0$ guarantees
  on $U_(k-1)$ ($D$ invertible). Injectivity gives $dim Y_2 = dim(U_(k-1) times AA^1) = 3k-2$; since
  $U_(k-1)$ is nonempty (@lem-nondeg), $Phi(U_(k-1) times {1}) subset.eq Y_2 inter pi^(-1)(U_(k-1))$
  is nonempty.
]

#theorem[$I_k$ has codimension 2][
  For every $k >= 2$: $dim V(I_k) = 3k-2$, i.e. $"codim"(I_k) = 2$.
] <thm-codim>

#proof[Proof of @thm-codim][
  Induction on $k$, identical in structure to the companion article's @thm-codim: base case
  $k=2$ is the standard dimension of a generic rank-$<=1$ locus of a $2 times 3$ matrix
  #bcite("MotzkinTaussky1955"); inductive step splits $V(I_k) = Y_1 union Y_2$ by whether
  $D(vek(w)_(k-1))=0$ or $vek(v)_k$ is proportional to it (a direct case split, needing no closure
  argument, exactly as before), giving $dim Y_1 = 3k-2$ by the inductive hypothesis and
  $dim Y_2 = 3k-2$ by @lem-y2-dim.
]

#proposition[$Y_2 subset.not.eq Y_1$][ With $Y_1,Y_2$ as above: $Y_2 subset.not.eq Y_1$. ] <prop-y2-not-in-y1>

#proof[Proof of @prop-y2-not-in-y1][
  Pick $p in U_(k-1)$; $Phi(p,0)=(p,0) in Y_2$ but $vek(w)_(k-1)(p) eq.not 0$ puts $(p,0) in.not Y_1$.
]

#proposition[no component of $Y_1$ lies in $Y_2$][
  No irreducible component $Z$ of $V(I_(k-1))$ has $Z times AA^3 subset.eq Y_2$.
] <prop-y1-not-in-y2>

#proof[Proof of @prop-y1-not-in-y2][
  Both irreducible, same dimension $3k-2$ (@thm-codim, @lem-y2-dim), so containment forces equality;
  refuted since $Z times AA^3$ is disjoint from $pi^(-1)(U_(k-1))$ ($vek(w)_(k-1)$ vanishes on $Z$)
  while $Y_2$ meets it (@lem-y2-dim).
]

#theorem[component count][
  For every $k >= 2$: $V(I_k)$ has exactly $k-1$ irreducible components, each of dimension $3k-2$.
] <thm-componentcount>

#proof[Proof of @thm-componentcount][
  Induction on $k$: base case $k=2$ is the irreducibility of the rank-$<=1$ locus of a generic
  $2 times 3$ matrix #bcite("MotzkinTaussky1955"); step combines the inductive hypothesis's $k-2$
  components of $Y_1$ with $Y_2$ itself, no containments among them by
  @prop-y2-not-in-y1/@prop-y1-not-in-y2, giving $(k-2)+1=k-1$.
]

#definition[the components $P_j$][
  As in the companion article: $P_j$ ($j=2,dots,k$) is $Y_2$'s own defining ideal run at parameter
  $j$, viewed inside $R_k$ by leaving $vek(v)_(j+1),dots,vek(v)_k$ free.
] <def-primecomponents>

#example[the components, worked out at $k=3,4$][
  *At $k=3$*: $I_3 = P_2 inter P_3$, $P_2$ (block pattern $\{1,2\}$) generated by $I_2$'s three
  generators from @ex-wk-signed, and $P_3$ (block pattern $\{1,2,3\}$) exactly the $Y_2$-ideal
  displayed above. *At $k=4$*: $P_2,P_3$ inherited verbatim from $k=3$, $vek(v)_4$ left free; $P_4$ is
  the $k=4$ row of the $Y_2$-defining-ideal example above.
]

= Cohen-Macaulayness

#proposition[Eagon-Northcott / Hilbert-Burch, applied][
  Let $M$ be a $2 times 3$ matrix over a polynomial ring $R$ and $J$ the ideal of its $2 times 2$
  minors. If $J$ has codimension $2$, then $R\/J$ is Cohen-Macaulay.
] <prop-detideal>

#proof[Proof of @prop-detideal][
  Bruns and Vetter #bcite("BrunsVetter1988"), Theorem (2.7), p. 13 -- unchanged from the companion
  article's use of the same theorem, applying it here to the matrix
  $mat(D(vek(w)_(k-1)); vek(v)_k)$ instead of $mat(tau(vek(w)_(k-1)); vek(v)_k)$.
]

#theorem[$R_k \/ I_k$ is Cohen-Macaulay][
  For every $k >= 2$: $R_k \/ I_k$ is Cohen-Macaulay.
] <thm-cm>

#proof[Proof of @thm-cm][
  By @thm-codim, $I_k$ has the expected codimension 2 for @thm-determinantal's presenting matrix;
  @prop-detideal applies directly.
]

= Radicality

Cohen-Macaulayness and §5's component structure combine via Serre's criterion to give radicality,
exactly as in the companion article's §7; the reduction-via-Serre lemma and the two Jacobian-rank
lemmas (the Jacobian-rank-bound statements) are pure commutative algebra, independent of the
encoding, and are not repeated here -- only the Jacobian *recursion* itself needs $D$ in place of
$tau$.

#lemma[the Jacobian's own recursion][
  Write $J_k$ for the $3 times 3k$ Jacobian of $vek(w)_k$ and $[u]_times$ for the skew matrix with
  $[u]_times v = u times v$. Then $J_2 = [ -[vek(v)_2]_times mid(|) [vek(v)_1]_times ]$, and for
  $k >= 3$,
  $ J_k = [ -[vek(v)_k]_times D J_(k-1) mid(|) [D(vek(w)_(k-1))]_times ]. $
] <lem-jacrecursion>

#proof[Proof of @lem-jacrecursion][
  Identical derivation to the companion article's own @lem-jacrecursion with $D$ in place of $T$
  (the matrix of $tau$): $vek(w)_k = D(vek(w)_(k-1)) times vek(v)_k = [D(vek(w)_(k-1))]_times vek(v)_k$
  is linear in $vek(v)_k$ with $vek(v)_k$-free coefficient matrix, giving the second block; and
  $∂_t vek(w)_k = (D ∂_t vek(w)_(k-1)) times vek(v)_k = -[vek(v)_k]_times D ∂_t vek(w)_(k-1)$ for $t$
  among $vek(v)_1,dots,vek(v)_(k-1)$, using $a times b = -[b]_times a$, gives the first.
]

#example[$J_3$, explicitly][
  With variables ordered $v_(1,1),dots,v_(3,3)$, the $3 times 9$ Jacobian of $vek(w)_3$, in the two
  blocks of @lem-jacrecursion's formula -- computed directly
  (#text(style: "italic")[code/compute\_signed\_encoding\_examples.sage]), *every entry a
  $plus.minus 1$-coefficient binomial or monomial*, in contrast with the companion article's own
  $J_3$ example, which has several entries with explicit factors of 2. First,
  $-[vek(v)_3]_times D J_2$ ($3 times 6$):
  #text(size: 7pt)[
    $ mat(
        -v_(2,2)v_(3,2)+v_(2,3)v_(3,3), v_(2,1)v_(3,2), -v_(2,1)v_(3,3),
        v_(1,2)v_(3,2)-v_(1,3)v_(3,3), -v_(1,1)v_(3,2), v_(1,1)v_(3,3);
        v_(2,2)v_(3,1), -v_(2,1)v_(3,1)+v_(2,3)v_(3,3), -v_(2,2)v_(3,3),
        -v_(1,2)v_(3,1), v_(1,1)v_(3,1)-v_(1,3)v_(3,3), v_(1,2)v_(3,3);
        -v_(2,3)v_(3,1), -v_(2,3)v_(3,2), v_(2,1)v_(3,1)+v_(2,2)v_(3,2),
        v_(1,3)v_(3,1), v_(1,3)v_(3,2), -v_(1,1)v_(3,1)-v_(1,2)v_(3,2)
      ) $
  ]
  and $[D(vek(w)_2)]_times$ ($3 times 3$):
  $ mat(
      0, v_(1,2)v_(2,1)-v_(1,1)v_(2,2), -v_(1,3)v_(2,1)+v_(1,1)v_(2,3);
      -v_(1,2)v_(2,1)+v_(1,1)v_(2,2), 0, v_(1,3)v_(2,2)-v_(1,2)v_(2,3);
      v_(1,3)v_(2,1)-v_(1,1)v_(2,3), -v_(1,3)v_(2,2)+v_(1,2)v_(2,3), 0
    ) $
]

#lemma[rank-2 witness on the new component][
  For every $k >= 2$, there is a point $x=(p,0)$, $p$ the @lem-nondeg witness at level $k-1$, with
  $x in V(I_k)$ and $"rank" J_k(x) = 2$.
] <lem-witness-new>

#proof[Proof of @lem-witness-new][
  $J_k(p,0) = [0 mid(|) [D(vek(w)_(k-1)(p))]_times]$ since $-[0]_times D J_(k-1)(p)=0$, and
  $D(vek(w)_(k-1)(p)) eq.not 0$ since $vek(w)_(k-1)(p) eq.not 0$ (@lem-nondeg) and $D$ is invertible.
  For $u eq.not 0$, $ker[u]_times = FF u$, so $[D(vek(w)_(k-1)(p))]_times$ has rank 2.
]

#example[the rank-2 witness, at $k=3$][
  Taking $p = (vek(v)_1,vek(v)_2) = ((1,0,0),(0,1,0))$ (the same point used in the $Y_2$-point example
  above, where $vek(w)_2(p)=(0,0,1) eq.not 0$), $x = (p,0) in V(I_3)$ and
  $J_3(x) = [0 mid(|) [(0,0,1)]_times]$, which has rank 2 directly from the explicit $[D(vek(w)_2)]_times$
  block of the $J_3$ example above, evaluated at $p$.
]

#lemma[rank-2 witness on an inherited component][
  For every $k >= 3$ and every component $Z$ of $V(I_(k-1))$ with a rank-2 witness $q in Z$, there
  is $x=(q,e_i) in Z times AA^3 subset V(I_k)$ with $"rank" J_k(x) = 2$.
] <lem-witness-inherited>

#proof[Proof of @lem-witness-inherited][
  Identical to the companion article's own proof with $D$ in place of $T$: $W := D dot "im" J_(k-1)(q)$
  is 2-dimensional ($D$ invertible, $"rank" J_(k-1)(q)=2$); since $W eq.not FF^3$ some $e_i in.not W$;
  $J_k(q,e_i) = [-[e_i]_times D J_(k-1)(q) mid(|) 0]$ has rank $dim([e_i]_times W) = 2$ since
  $ker[e_i]_times = FF e_i$ meets $W$ trivially.
]

#theorem[$I_k$ is radical][ For every $k >= 2$: $I_k$ is radical. ] <thm-radical>

#proof[Proof of @thm-radical][
  Induction on $k$, mirroring @thm-componentcount: @lem-witness-new and @lem-witness-inherited
  exhibit a rank-2-Jacobian point on every one of the $k-1$ components, giving $R_0$; Cohen-Macaulayness
  (@thm-cm) gives $S_1$ via Serre's criterion (the reduction-via-Serre step is pure commutative
  algebra, identical to the companion article's own reduction-via-Serre lemma, not repeated here).
]

Verified independently in Sage at $k=2,3,4$: the Jacobian recursion checked as a polynomial identity
(#text(style: "italic")[code/compute\_signed\_encoding\_examples.sage] builds $J_3$ directly from
$vek(w)_3$'s own Jacobian, not from the recursive formula, giving an independent cross-check).

= The Primary Decomposition Theorem

#theorem[Primary Decomposition Theorem][
  For every $k >= 2$, over any field of characteristic $eq.not 2$: $I_k$ has exactly $k-1$
  irreducible, radical, primary components $P_2,dots,P_k$, and $I_k = P_2 inter dots.c inter P_k$
  is an irredundant primary decomposition.
] <thm-primarydecomp>

#proof[Proof of @thm-primarydecomp][
  Identical to the companion article's own proof: @thm-radical gives $I_k = sqrt(I_k) =
  inter_(P in "Min"(I_k)) P$; @thm-componentcount identifies $"Min"(I_k) = \{P_2,dots,P_k\}$;
  irredundancy is @thm-componentcount's own no-containment conclusion.
]

= Summary

For every $k >= 2$, over any field $FF$ of characteristic $eq.not 2$: $I_k$ has codimension 2
(@thm-codim), presented as the ideal of $2 times 2$ minors of an explicit $2 times 3$ matrix
(@thm-determinantal); exactly 3 minimal generators (@thm-mingens); $R_k\/I_k$ Cohen-Macaulay
(@thm-cm); $I_k$ radical (@thm-radical); and $V(I_k)$ has exactly $k-1$ irreducible components
assembling into the irredundant Primary Decomposition Theorem (@thm-primarydecomp). Every statement
is identical to the companion article's; what differs is the route -- the signed encoding
(@thm-basic-identity) replaces every occurrence of the coordinate-swap-and-doubling map $tau$ with
the sign-diagonal involution $D$, removing the swap entirely and reducing every displayed formula
in this article to $plus.minus 1$ coefficients throughout, traced (@rem-why-D) to $D$ being, up to a
constant, the matrix of $frak(s l)_2$'s own Killing form in these coordinates -- an explanation for
the twist's existence that the companion article's own $tau$ does not have.

#v(1.5em)
= References
#v(0.5em)

#bibentry("BrunsVetter1988")[W. Bruns, U. Vetter, #emph[Determinantal Rings], Lecture Notes in
  Mathematics 1327, Springer-Verlag, 1988. Freely available at
  #link("https://www.home.uni-osnabrueck.de/wbruns/brunsw/detrings.pdf")[the first author's own
  page].]
#bibentry("EagonNorthcott1962")[J.A. Eagon, D.G. Northcott, #emph[Ideals defined by matrices and a
  certain complex associated with them], Proc. Roy. Soc. London Ser. A 269(1337) (1962), 188-204.
  Superseded here, as in the companion article, by Bruns-Vetter's more general treatment.]
#bibentry("MotzkinTaussky1955")[T. Motzkin, O. Taussky, #emph[Pairs of matrices with property L.
  II], Trans. Amer. Math. Soc. 80 (1955), 387-401.]
#bibentry("Stacks00OS")[#emph[The Stacks Project], tag 00OS, and equivalently D. Eisenbud,
  #emph[Commutative Algebra with a View Toward Algebraic Geometry], Springer GTM 150, 1995, Cor.
  13.4. Open access at
  #link("https://stacks.math.columbia.edu/tag/00OS")[stacks.math.columbia.edu/tag/00OS]. (Not
  directly cited in this article's own proofs, listed for completeness with the shared
  bibliography -- see the companion article's Radicality section for where it is used.)]
#bibentry("Gerstenhaber1961")[M. Gerstenhaber, #emph[On dominance and varieties of commuting
  matrices], Ann. of Math. 73 (1961), 324-348.]
#bibentry("ArtinHochsterConjecture")[M. Artin, M. Hochster, attributed conjecture: for $I$ the ideal
  generated by the entries of $X Y - Y X$, $"Spec"(R\/I)$ is reduced and Cohen-Macaulay.]
#bibentry("MajidiZolbaninSnapp")[M. Majidi-Zolbanin, B. Snapp, #emph[A note on the variety of pairs
  of matrices whose product is symmetric], undated preprint.]
#bibentry("Chau2024")[T. Chau, #emph[The $F$-regularity of algebraic sets related to commutator
  matrices], J. Algebra 652 (2024), 52-66.]
#bibentry("Hreinsdottir2005")[F. Hreinsdóttir, #emph[Conjectures on the ring of commuting matrices],
  arXiv:math/0501465.]
#bibentry("Knutson2003")[A. Knutson, #emph[Some Schemes Related to the Commuting Variety],
  arXiv:math/0306275.]
#bibentry("Youcis2014")[A. Youcis, answer to "What can we say about the image of a regular map?",
  Mathematics Stack Exchange, question 731178, answer 732415, 2014.]

#v(1.0em)
#text(size: 8.5pt, style: "italic")[
  Acknowledgements: as with the companion article, the computational verification and drafting of
  this article were carried out with substantial assistance from Claude (Anthropic), acting as an
  AI research assistant under the author's direction and review -- not as a co-author. Every
  displayed formula in this article was computed directly
  (#text(style: "italic")[code/compute\_signed\_encoding\_examples.sage],
  #text(style: "italic")[code/verify\_lorentzian\_encoding\_identity.sage],
  #text(style: "italic")[code/verify\_encoding\_gl3\_equivariance.sage]), not hand-derived from the
  companion article's own displays by pattern.
]
