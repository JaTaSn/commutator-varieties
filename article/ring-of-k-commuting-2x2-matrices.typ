// Changelog (reverse chronological):
// 2026-08-17 - Claude: correction to the previous entry below. Earlier this same day, asked
//   whether Remark 14's non-closed-image example traced to a Stack Exchange source, a fresh
//   WebSearch turned up nothing and no citation was added. That was a real miss: this exact
//   question, and the exact source (Alex Youcis's answer, math.SE 731178/732415), had already been
//   researched and written up the *previous day* in working-notes/topological-irreducibility-of-
//   image.org -- found only now, after Jan pointed at agent-shell's own verbatim session
//   transcripts (.agent-shell/transcripts/) as a resource and this file's absence from that search
//   got checked directly. Added #bcite("Youcis2014") to both Remark 14 (the (x,y)->(x,xy) example
//   itself) and Lemma 7 (continuous images/closures preserve irreducibility, the general fact the
//   working note is about), plus a pointer to the working note itself. Lesson for next time,
//   recorded here rather than only in chat: check this project's own working-notes/ before running
//   a fresh web search on a question this specific -- the answer may already be sitting there.
// 2026-08-17 - Claude: review round on blankrev-5 (annotated, returned via INBOX after Jan's
//   post-lunch review). Fixed a real notation collision Jan caught: the new Introduction used
//   plain "k" for the base field (matching classical-literature convention k[X,Y]) while the rest
//   of the article uses k for the integer chain length and FF for the field -- both intro spots
//   (dim_k k[A,B], k[A,B]/I) now use FF, consistently. Definition 21 (components P_j) restructured
//   into an itemized list; added a new worked Example (an explicit numeric point of Y_2 at k=3,
//   verified directly: w_3 = tau(w_2) x tau(w_2) = 0). Lemma 26 (reduction via Serre) now states
//   Serre's condition S_n explicitly (depth(A_P) >= min(n, dim A_P)) with the one-line proof that
//   CM implies S_n for every n, rather than asserting it uncited. Theorem 37 (Primary Decomposition
//   Theorem): the defining equation is now its own displayed equation, and the proof is spelled out
//   in full (why radical = intersection of minimal primes; why each P_j is trivially its own
//   primary component; where irredundancy actually comes from) rather than a one-line conjunction.
//   Example 24 (the components at k=3) restructured into a uniform by-k itemized list (previously
//   inconsistent: k=2 and k=4 in prose, only k=3 itemized). Added a new "Summary" section (distinct
//   from the existing "summary" Remark, which explains the four-separate-theorems framing rather
//   than listing results) -- a plain itemized list of what the article actually proves. Did a
//   bounded style pass (fewer em-dash parenthetical inserts, more linear sentences) on the four
//   proofs the annotation specifically pointed at (Lemma 15, Theorem 16, Proposition 19) -- the
//   same em-dash-heavy style is used throughout the rest of the article by original design; a
//   whole-article pass was judged too large and risky to rush this round, flagged back to Jan
//   rather than either silently doing it everywhere or silently skipping it. Declined (with reasons
//   reported back, not silently) a "Y_1 -> Y_1^k" style superscript rename Jan himself flagged as
//   "if sensible" -- P_j's own remark already handles the parallel issue, and the mechanical rename
//   would touch many already-correct, cross-referenced sections for a modest clarity gain. Drafted
//   (not applied) an image-generation prompt for a "snazzier" Figure 1 incorporating Jan's own
//   sketch (Y_2's interior called out separately) -- working-notes/figure1-snazzy-prompt.org,
//   per his explicit "do not edit now" instruction. Researched (not fabricated) whether Remark 14's
//   standard non-closed-image example traces to a specific Stack Exchange source -- it doesn't;
//   it's classical/folklore algebraic-geometry course material (e.g. Mustata's Michigan notes), so
//   no citation was added rather than inventing one.
// 2026-08-17 - Claude: expanded the Introduction (~3/4 page) with the classical-commuting-variety
//   backstory, at Jan's request while he was at lunch -- Motzkin-Taussky/Gerstenhaber irreducibility,
//   the attributed (undated) Artin-Hochster reduced+Cohen-Macaulay conjecture (precisely stated in
//   Majidi-Zolbanin & Snapp as "Conjecture 1.1"; a related but distinctly-dated 1984 reducedness
//   conjecture attributed to Hochster alone, per Chau 2024), Hreinsdottir's case-by-case (n=3,4)
//   attack on it, and Knutson's minimal-primes work -- then connects this article's own results to
//   that backstory precisely: I_2 (k=2) literally IS the n=2 classical commuting variety in reduced
//   coordinates (for which CM-ness is comparatively easy, reproven here as a special case), while
//   the genuinely new object is the iterated k>=3 generalization -- not the classical commuting
//   variety, a structurally analogous determinantal ideal -- for which this article gives a complete,
//   unconditional answer to the same flavor of question the classical conjecture asks, still open in
//   general for the classical object itself. All six new citations (Gerstenhaber 1961,
//   Artin-Hochster, Majidi-Zolbanin-Snapp, Chau 2024, Hreinsdottir 2005, Knutson 2003) drawn from
//   literature/REFERENCES.org's own already-vetted entries (11-24), not freshly researched --
//   bibliographic details and relevance notes already established there from an earlier session.
// 2026-08-17 - Claude: Jan confirmed overline as the standing vector convention going forward
//   ("I like it a lot!") and asked for blankrev-5 built with it. While building, caught a leftover
//   from the bold-to-overline switch: the Notation section's own prose explanation of the
//   convention still said "bold denotes a vector ... never bold" -- correct at the time it was
//   written, stale after the style itself changed underneath it. Fixed to say "overline" (the
//   rendering itself was already correct throughout; this was purely the descriptive prose lagging
//   behind).
// 2026-08-17 - Claude: two follow-ups from Jan, same conversation as the notation pass below.
//   (1) Switched the vector style from bold to overline (v_1 -> a bar over v_1) -- Jan's
//   suggestion, tried side by side, genuinely reads more clearly next to plain scalar components at
//   this font size. (2) Retrofitted a real macro instead of the literal "bold(v)_1" sprinkled
//   throughout the source: every vector now calls one function, vek(x); the visual style is a
//   one-line edit to vek's own definition, not a find-and-replace. Caught and fixed a genuine Typst
//   gotcha while doing this: `#let vek(x) = overline(x)` compiles with no error but silently fails
//   to render the bar at all -- overline() called from code mode (a #let body) behaves differently
//   from overline() called natively inside math mode. The fix is to define vek as a math template,
//   `#let vek(x) = $overline(#x)$`, not a bare code-mode function call. Jan noticed the missing bar
//   by eye; isolated with a minimal test file before touching the real article.
// 2026-08-17 - Claude: notation pass, at Jan's request, to make the
//   vector/component distinction typographically explicit throughout (as
//   if for an undergraduate audience): v_i, w_j and other block-level
//   vectors are now bold (e.g. bold(v)_1) everywhere, while a plain letter
//   with a two-index comma subscript (v_(i,j)) denotes one scalar
//   component -- applied mechanically via a Python regex pass distinguishing
//   "comma inside the subscript" (component, left plain) from "no comma"
//   (vector, bolded), then spot-checked across every section. The
//   convention itself is now stated up front in the Notation section. Also
//   added: a fully spelled-out R_2 = QQ[v_{1,1},...,v_{2,3}] example
//   (Definition 2 was previously only "R_k := QQ[v_1,...,v_k]", easy to
//   misread as k vector-valued ring generators rather than 3k scalar
//   ones); and, in Section 3's Step 4, replaced a bare-letter u,v shorthand
//   for red(A),red(B) that collided with Step 3's plain scalar matrix
//   entries u,v,w of the same name -- now spelled out in full instead of
//   abbreviated, avoiding the collision rather than just bolding through
//   it. Deliberately did NOT bold generic proof-local dummy vectors (e_i,
//   points p,q,x, the skew-matrix argument u,v in [u]_times's own generic
//   definition) -- only the two specifically named objects v_i and w_j
//   from Section 3 get the treatment, to avoid diluting the distinction
//   Jan actually asked for.
// 2026-08-17 - Claude: fixed a real error Jan caught in chat (not a review
//   round) in Figure 1's caption: it claimed Y_1 "lives entirely outside
//   this picture," which is false -- Y_1 := V(I_{k-1}) x A^3 is manifestly
//   a subset of A^(3(k-1)) x A^3 ~= A^(3k), the same ambient space as Y_2,
//   confusing "not part of Phi's image" (true) with "not in the same
//   ambient space" (false). Worse, they are not even disjoint: Phi(p,0) =
//   (p,0) for every p (no closure needed), so Y_1 and Y_2 meet in
//   V(I_{k-1}) x {0}, dimension 3k-5. Figure redrawn to show both strata
//   as overlapping regions inside the same A^(3k), caption corrected.
// 2026-08-17 - Claude: review round 2 (blankrev-2, annotated by hand and
//   returned via INBOX). All of round 1's changes confirmed good ("Good!",
//   "OK") including an explicit "keep it like this for now" on Section 3's
//   prose exposition (a future-polish note, not an ask to restructure now).
//   Both previously-unclear items from round 1 were resolved by Jan
//   directly this round, not guessed at: "WLOG (rev) A" confirmed already
//   covered by Section 3's Step 1-2 framing (no further text change); "the
//   map defined by subst." clarified with an explicit sketch (w_j as a
//   substitution map A^(3j)->A^3) -- now stated explicitly right after
//   Definition 2, alongside a new sentence naming w_j as an element of the
//   free module R_j^3. New, all directly from this round's annotations:
//   Definition 11's parenthetical aside removed; pi and Phi now displayed
//   as separate equations instead of inline; a new Figure 1 (Phi's image
//   Y_2 inside A^(3k), via Typst's native ellipse/place primitives) added
//   per "complete this picture and include it"; Example 13 extended to
//   give Y_1's defining ideal alongside Y_2's, not just Y_2's; and a new
//   Proposition 22 + Remark 23 directly answering Jan's "is there a
//   rational parametrization of Y_1?" -- Y_1 itself is reducible for k>=4
//   so not meaningfully "rational" as one object, but every individual
//   component (including Y_1's own pieces) has an explicit birational
//   parametrization via Phi run at the appropriate parameter, which the
//   new proposition proves from already-established machinery (Lemma 15's
//   injectivity argument, generalized).
// 2026-08-17 - Claude: review round 1 (blankrev-1, annotated by hand on the
//   A3 side-by-side packet, plus a separate scribbled derivation PDF -- both
//   filed under article/review-1-*.pdf). Expanded §3's setup into an
//   explicit four-step derivation (discard scalar part; encode traceless
//   remainder as a triple via a newly-named "red" map, used but never
//   formally defined before now; form the commutator; identify the encoded
//   bracket as the cross product composed with tau) plus a new remark
//   explaining why Definition 1's w_j recursion carries no outer tau (an
//   invertible linear reshuffle of a generating set doesn't change the
//   ideal it generates) -- addresses the review's circled query on §3's
//   opening paragraph, and independently matches Jan's own by-hand
//   verification in the scribbled-derivation PDF (same tau-twist pattern
//   found both ways). Example 2 (now "w_k and I_k, explicitly") rewritten
//   to display w_2, w_3, w_4 as vectors directly rather than only listing
//   "I_k is generated by ..." -- per the review's explicit instruction
//   ("give w_3 instead of I_3, both w_2, I_2"). Two other annotations on
//   the same review round ("WLOG (rev) A"; "the map defined by subst.")
//   were not clear enough to act on with confidence -- see
//   article/review-2026-08-17/blankrev-2.pdf's own lead pages for why, and
//   review-2026-08-17/blankrev-1's annotations for the source.
// 2026-08-16 - Claude: this file is now the sole, canonical version -- at
//   Jan's request, the older hand-rolled-macro version (previously at this
//   same path) has been retired to /TRASH/fast-commutators-ring-of-k-
//   commuting-2x2-matrices.typ (top-level TRASH/, not deleted, per this
//   workspace's standing convention), and this file -- originally created as
//   a parallel port using the community "theorion" theorem-environment
//   package (https://typst.app/universe/package/theorion/, v0.6.0) instead
//   of hand-rolled thmblock()/thmref() macros, to let Jan compare the two
//   approaches directly -- was renamed into the now-vacated canonical path.
//   Verdict on the comparison ("garish but good") and the numbering/
//   referencing advantages below settled the choice: theorion is now this
//   project's standing default for Typst theorem-heavy documents going
//   forward (not retroactively applied to sibling files
//   k-iterated-commutators-complexity.typ or fast-commutators.typ, which stay
//   as they are). Also added, same day: a general topological lemma
//   ("continuous images and closures preserve irreducibility") that the
//   existing "$Y_2$ is irreducible" lemma now cites directly, plus a remark
//   answering the natural follow-up ("does the fact that a morphism's image
//   need not be closed cause a problem here?" -- no, since $Y_2$ is defined
//   as the closure from the outset and the set-theoretic decomposition
//   $V(I_k)=Y_1\cup Y_2$ is proven by a direct case split, never needing the
//   raw image itself to be closed) -- see
//   working-notes/topological-irreducibility-of-image.org for the full
//   discussion this condenses.
//
//   Real behavioral differences discovered while first porting to theorion,
//   worth recording:
//   - Native `@label` referencing already renders "Kind N" (e.g. "Theorem 1")
//     out of the box -- no custom thmref() needed, theorion's own supplement
//     mechanism does exactly what this project's manual metadata/thmref()
//     fix (same day, ring-of-k-commuting-2x2-matrices.typ) had to build by
//     hand.
//   - By default theorion's shared counter RESETS at every top-level
//     heading (confirmed by direct test: two `=` sections each started their
//     own "Theorem 1"), which would have silently broken global uniqueness
//     of "Theorem 24 (Primary Decomposition Theorem)"-style final-result
//     numbering across this article's 7 sections. Fixed via
//     `#set-inherited-levels(0)` for one continuous document-wide counter --
//     not the package's default behavior, a real configuration step.
//   - `#corollary[...]` numbers as a sub-item ("N.1") of the immediately
//     preceding theorem-like statement by default, rather than continuing
//     the main sequence -- not used in this article's actual content
//     (no corollary appears), but discovered while testing and worth
//     recording since it would matter if this file is ever extended.
//   - Proof blocks (`#proof[...][...]`) auto-append a "☐"-style QED mark at
//     the end of the body with no extra syntax needed for ordinary prose
//     proofs; `#qedhere` is only needed when a proof ends in a displayed
//     equation or list, per the package's own documentation.
//
//   Style: cosmos.fancy (one of four bundled styles -- simple/fancy/rainbow/
//   clouds -- swappable by changing the one import line below).
//   Compile: `typst compile ring-of-k-commuting-2x2-matrices.typ ring-of-k-commuting-2x2-matrices.pdf`
//   from this directory (needs network access once, to fetch
//   @preview/theorion:0.6.0 and its dependencies into the local package
//   cache; cached thereafter).

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
// One continuous counter for the whole document -- theorion's default resets
// per top-level heading, which is not what a single-thread article wants.
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
  Stacks031O: 12,
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

// Vector-vs-component notation (Jan, 2026-08-17): vek(x) renders a block-level vector
// (v_1, w_j, ...) distinctly from a plain scalar component (v_(i,j)) -- every such vector in the
// article calls this one function, so the visual style is a one-line change here, not a rewrite.
// Currently: overline. Swap the body to bold(x) or arrow(x) to compare.
// NB (2026-08-17): must be a math template ($overline(#x)$), not a bare code-mode call
// (overline(x)) -- the latter compiles with no error but silently fails to render the bar at all,
// a genuine Typst gotcha (overline resolved outside math-mode context loses its math-layout
// behavior). Caught by Jan noticing the bar simply wasn't there in the compiled PDF.
#let vek(x) = $overline(#x)$

// =============================================================================

#align(center)[
  #block(width: 90%)[
    #text(size: 15pt, weight: "bold")[
      The coordinate ring of the $k$-fold iterated commutator locus for $2 times 2$ matrices
      #footnote[Working draft, 2026-08-16. Uses the community "theorion" package for theorem
      environments -- this project's standing default going forward, after a same-day side-by-side
      comparison against hand-rolled macros; the retired hand-rolled version is kept, not deleted,
      at #text(style: "italic")[/TRASH/fast-commutators-ring-of-k-commuting-2x2-matrices.typ] at
      the workspace top level. Every result cites only strictly-earlier results or external
      literature, no forward references. See
      #text(style: "italic")[working-notes/proof-plan-conjectures.org], Steps 0, 4, and 5, and
      #text(style: "italic")[working-notes/topological-irreducibility-of-image.org], for the fuller
      discussions this article condenses.]
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
    For $2 times 2$ matrices $A_1,dots,A_k$, write $[A_1,dots,A_k]$ for the left-normed iterated
    commutator $[dots[[A_1,A_2],A_3],dots,A_k]$, and $I_k$ for the ideal, in the $3k$-variable
    reduced-coordinate polynomial ring $R_k$, cutting out its vanishing locus. We prove, for every
    $k >= 2$ over any field of characteristic $eq.not 2$, and as four independently-established
    results rather than one bundled claim: $I_k$ has codimension 2; $I_k$ has exactly 3 minimal
    generators; $R_k \/ I_k$ is Cohen-Macaulay; and $I_k$ is radical. Combined with an explicit
    non-containment argument for the component count, these assemble into the *Primary
    Decomposition Theorem*: $I_k = P_2 inter dots.c inter P_k$ is an irredundant primary
    decomposition into exactly $k-1$ radical primes, following an explicit recursive
    block-involvement pattern. The proof identifies $I_k$ as the ideal of $2 times 2$ minors of an
    explicit $2 times 3$ matrix (a determinantal ideal, not merely determinantal-*looking*), and
    invokes classical determinantal-ideal theory (Bruns-Vetter) and an explicit rank-2 Jacobian
    witness on every component (Serre's criterion) for the algebraic and radicality halves
    respectively.
  ]
]

#v(0.8em)

= Introduction

$2 times 2$ matrices $A,B$ have commutator $[A,B] = A B - B A$, and the *iterated* left-normed
commutator of $k$ matrices is $[A_1,dots,A_k] := [dots[[A_1,A_2],A_3],dots,A_k]$, matching the
standard lower-central-series convention for Lie algebras. This object arose out of a question in
algebraic complexity theory -- how many scalar multiplications are needed to *compute*
$[A_1,dots,A_k]$? -- which remains genuinely open for $k >= 3$ and is treated in full in the
companion note #text(style: "italic")[k-iterated-commutators-complexity.typ]. The one fact from
that story needed here is purely algebraic, not complexity-theoretic: an explicit bilinear formula
for the ordinary $2 times 2$ commutator, chained across $k$ matrices, gives an explicit polynomial
parametrization of $[A_1,dots,A_k]$'s reduced coordinates (@def-wk below), and it is the *vanishing
locus* of this parametrization, as an algebraic variety and its coordinate ring, that is the actual
subject of this article. (One naming note: the filename this article is kept under,
#text(style: "italic")[ring-of-k-commuting-2x2-matrices], uses "commuting" in this generalized
iterated-commutator-vanishing sense -- $[A_1,dots,A_k]=0$ -- not literally "every pair of
$A_1,dots,A_k$ commutes," a weaker condition than the classical pairwise commuting variety it
specializes to at $k=2$.)

*The classical commuting variety.* For $A,B$ arbitrary (not necessarily $2 times 2$) $n times n$
matrices, the variety $C_n := {(A,B) in M_n times M_n : A B = B A}$ -- the ordinary, unreduced,
un-iterated case this article's own $k=2$ specializes to -- has been studied since the 1950s. Its
irreducibility was proven independently by Motzkin and Taussky #bcite("MotzkinTaussky1955") and by
Gerstenhaber #bcite("Gerstenhaber1961"), the latter also establishing the now-standard bound
$dim_FF FF[A,B] <= n$ for the subalgebra generated by two commuting matrices. Whether the coordinate
ring $FF[A,B]\/I$, $I$ the ideal generated by the entries of $A B - B A$, is *reduced* and
*Cohen-Macaulay* for every $n$ is a much harder question, attributed to Michael Artin and Melvin
Hochster -- an unpublished, informally-circulated conjecture with no single dateable original
source #bcite("ArtinHochsterConjecture"), stated precisely as "Conjecture 1.1" in Majidi-Zolbanin
and Snapp #bcite("MajidiZolbaninSnapp"). (A closely related, more specifically dated 1984
reducedness conjecture, for a different but adjacent ideal built from a commutator matrix's
diagonal/anti-diagonal entries, is attributed to Hochster alone by Chau #bcite("Chau2024").) Freyja
Hreinsdóttir's body of work #bcite("Hreinsdottir2005") -- building on her own 1997 Stockholm
doctoral thesis -- attacks the Artin-Hochster conjecture case by case at $n=3,4$: syzygies, Betti
numbers, the canonical module, and a Koszul-dual structure theorem, verified computationally through
$n=7$ but proven in general only in these small cases. Knutson #bcite("Knutson2003") studies the
minimal primes of closely related schemes from a different angle. Cohen-Macaulayness of the
*classical* commuting variety therefore remains open, for every $n >= 3$, at the time of writing.

At $n=2$ specifically -- this article's $k=2$ base case -- the question is comparatively easy, and
is in effect answered again, as a special case, by @thm-cm below: $I_2$ (@def-wk) is literally the
ideal of the $n=2$ commuting variety, expressed in reduced (trace-removed) coordinates rather than
the full matrix-entry coordinates the classical literature typically uses. The genuinely new object
in this article is the *iterated* generalization to $k >= 3$: not the classical commuting variety at
all (see the naming note above), but a structurally analogous determinantal ideal, built by chaining
the same bilinear cross-product formula that governs the $n=2$ case. It is exactly the same *flavor*
of question the Artin-Hochster conjecture asks -- is this natural, geometrically meaningful ideal
Cohen-Macaulay? is it reduced? -- for a different, recursively-defined family of ideals, and this
article answers it completely and unconditionally, for every $k >= 2$ (@thm-primarydecomp), rather
than case by case or conjecturally. In that sense the results below can be read as a fully worked
structural analogue of the still-open classical question, in a setting simple enough ($n=2$, but $k$
unbounded) to admit a complete answer.

= Notation

Notation used across more than one later result, in order of first appearance; symbols local to a
single proof are omitted.

*A typographic convention, used throughout*: an *overline* denotes a *vector* -- an element of
$FF^3$ (or, for $R_k$ itself, of the free module $R_k^3$) -- while the *same letter, plain, with a
two-index comma subscript*, denotes one of that vector's three individual scalar *components*. So
$vek(v)_i in FF^3$ is block $i$'s whole reduced-coordinate vector, while its three components are
the plain scalars $v_(i,1), v_(i,2), v_(i,3) in FF$ (equivalently $v_(i,j)$ for $j=1,2,3$) -- never
overlined, since a single scalar entry is not itself a vector. The same convention applies to
$vek(w)_j$ versus its components $w_(j,1), w_(j,2), w_(j,3)$.

#align(center)[
  #table(
    columns: 3,
    align: (center, left, left),
    stroke: 0.5pt,
    inset: 6pt,
    [*Symbol*], [*Meaning*], [*Defined in*],
    [$vek(v)$ (also $vek(v)_i$; components $v_(i,1),v_(i,2),v_(i,3)$, or $v_(i,j)$)],
      [reduced-coordinate vector in $FF^3$, and its blocks], [§3, Setup],
    [$D$], [the sign twist $D = "diag"(-1,-1,1)$ of @thm-basic-identity],
      [§3, Setup ($D$: @lem-jacrecursion)],
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

*Step 1: discard the scalar part.* Write $A = mat(a_11,a_12;a_21,a_22)$ as the sum of its scalar
part $("tr"(A)\/2) I$ and its traceless remainder $A_0 := A - ("tr"(A)\/2) I = mat(d_a\/2,a_12;
a_21,-d_a\/2)$, $d_a := a_11-a_22$. Scalar matrices are central, so they never contribute to a
commutator: $[c I, B] = c I B - B c I = c B - c B = 0$ for every $B$ and every scalar $c$, hence
$[A,B]=[A_0,B_0]$ identically -- no information relevant to *any* bracket is lost by discarding the
scalar part, so from here on only the traceless remainder matters.

*Step 2: encode the traceless remainder.* A traceless matrix $mat(x,y;z,-x)$ has three free entries.
Rather than reading them off directly ($x,y,z$ themselves -- shown in @rem-why-D below to be a
strictly *worse* choice, needing two separate factors of 2), take
$ "enc"(A) := (a_11-a_22,\ a_12+a_21,\ a_12-a_21) in FF^3, $
the traceless $(1,1)$-entry doubled (the quantity $d_a$ of Step 1), and $A$'s two off-diagonal
entries replaced by their sum and difference. As with the naive encoding $"red"$ of @rem-why-D, no division
is needed to *compute* $"enc"$ -- only its inverse (recovering $a_12,a_21$ individually as
$(v_2+v_3)/2$ and $(v_2-v_3)/2$) needs $2$ invertible, which is the standing hypothesis the
article already carries, not a new one.


*Step 3: form the commutator.* Given traceless $A_0=mat(x,y;z,-x)$ and $B_0=mat(u,v;w,-u)$, the
ordinary matrix commutator $[A_0,B_0]=A_0 B_0-B_0 A_0$ is again traceless automatically
($"tr"(P Q)="tr"(Q P)$ for any $P,Q$, so $"tr"([P,Q])=0$ always), hence again encodable by $"red"$.


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
  Three concrete respects in which $D$ improves on the naive reshuffle $tau(a,b,c)=(b,a,2c)$ that
  the encoding $"red"(A):=(a_12,a_21,d_a)$ forces,
  each checked, not merely asserted:
  + *$D$ does not mix coordinates.* $tau$ swaps two of its three inputs; $D$ acts diagonally, one
    coordinate at a time. Consequence: $"red"$ would need a page-length remark ("why
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
    not cited to a specific source here, the same way this article leaves certain folklore
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
  Let $R_k := QQ[vek(v)_1,dots,vek(v)_k]$ ($vek(v)_i in QQ^3$, $3k$ variables) and $I_k subset R_k$ the ideal
  generated by the three components of $vek(w)_k$ -- the vanishing ideal of $[A_1,dots,A_k]=0$ in
  reduced coordinates.
] <def-wk>

To spell out exactly what this means: "$R_k := QQ[vek(v)_1,dots,vek(v)_k]$" is shorthand for *the
polynomial ring in the $3k$ scalar variables $v_(i,j)$ ($i=1,dots,k$, $j=1,2,3$)*, grouped into $k$
blocks of 3 -- *not* a ring with $k$ vector-valued generators (a polynomial ring's generators are
always scalars). At $k=2$, written out in full:
$ R_2 = QQ[v_(1,1),v_(1,2),v_(1,3),v_(2,1),v_(2,2),v_(2,3)], $
six ordinary scalar indeterminates, with $vek(v)_1=(v_(1,1),v_(1,2),v_(1,3))$ and
$vek(v)_2=(v_(2,1),v_(2,2),v_(2,3))$ merely a notational grouping of them into two blocks of
three -- convenient because $vek(w)_2 = vek(v)_1 times vek(v)_2$ is most naturally written as a
cross product of two block-vectors, not as some formula in six unrelated scalars.

Each $vek(w)_j$ is a triple of polynomials, i.e. $vek(w)_j in R_j^3$ (the free rank-3 module over $R_j$) --
equivalently, exactly as recorded in the Notation table's entry (b) for $vek(w)_j$, the polynomial map
$vek(w)_j : AA^(3j) -> AA^3$ *given by substitution*: evaluating each of $vek(w)_j$'s three polynomial
components at a point $(vek(v)_1,dots,vek(v)_j) in AA^(3j)$. Concretely at $k=2$, writing out all six
variables, $vek(w)_2$ is the substitution map
$ mat(v_(1,1); v_(1,2); v_(1,3); v_(2,1); v_(2,2); v_(2,3)) in AA^6 quad |->quad
  mat(v_(1,2)v_(2,3)-v_(1,3)v_(2,2); v_(1,3)v_(2,1)-v_(1,1)v_(2,3); v_(1,1)v_(2,2)-v_(1,2)v_(2,1))
  in AA^3, $
and $I_k$ (@def-wk) is, equivalently, the ideal generated by the three coordinate functions of
$vek(w)_k : AA^(3k) -> AA^3$ pulled back along this substitution.


#example[$vek(w)_k$ and $I_k$, explicitly, for $k=2,3,4$][
  Computed directly (#text(style: "italic")[code/compute\_signed\_encoding\_examples.sage]), not
  hand-derived. At $k=2$, the three components of $vek(w)_2 = vek(v)_1 times vek(v)_2$:
  $ v_(1,2)v_(2,3)-v_(1,3)v_(2,2), quad v_(1,3)v_(2,1)-v_(1,1)v_(2,3), quad
    v_(1,1)v_(2,2)-v_(1,2)v_(2,1). $
  (Identical to the $"red"$ display -- the two encodings agree exactly at the very
  first stage, since neither $tau$ nor $D$ is applied yet.) At $k=3$, the three components of
  $vek(w)_3 = D(vek(w)_2) times vek(v)_3$ -- now with *every coefficient equal to $plus.minus 1$*, no
  factor of 2 anywhere, unlike the $tau$-twisted $vek(w)_3$ that $"red"$ produces:
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

Stated over $QQ$, but every result below holds over an arbitrary field
$FF$ of characteristic $eq.not 2$. Where that hypothesis is actually spent is not where one first
expects, and the answer leaves a question we are happy to hand on:

#problem[characteristic 2][
  The hypothesis is *not* spent on $D$. Since $det D = 1$, the twist is invertible over every
  field, and @rem-why-D's "an invertible change of generators does not change the ideal" needs no
  hypothesis whatsoever. Under the naive reshuffle it would: $det tau = -2$, so $tau$ is singular
  in characteristic 2 precisely.

  It is spent in *Step 1*, earlier than Step 2's division by $2$ and more seriously. In
  characteristic 2 one has $"tr"(c I) = 2c = 0$, so *scalar matrices are themselves traceless*.
  The splitting $A = ("tr"(A)\/2)I + A_0$ then has no meaning at all: the scalars do not sit
  beside a complement, they sit *inside* the traceless matrices.

  The bracket is unbothered --- scalars are central in every characteristic --- so $[dot,dot]$
  still descends to the three-dimensional quotient $frak(g l)_2 \/ (FF dot I)$. The question is
  whether the rest of the article descends with it.

  *Question.* Over a field of characteristic 2, is there a linear isomorphism
  $frak(g l)_2 \/ (FF dot I) tilde.equiv FF^3$ carrying the induced bracket to a twisted cross
  product $E(dot times dot)$ for some invertible $E$? And if so, do @thm-codim, @thm-mingens,
  @thm-cm, @thm-radical and @thm-primarydecomp hold verbatim?

  What makes this more than idle curiosity: *every polynomial displayed in @ex-wk-signed has
  coefficients $plus.minus 1$ only*. No $2$ appears anywhere in the output. Whatever the
  obstruction is, it lives entirely in the setup and not in the ideal --- which is exactly the
  situation in which a different setup might dissolve it.
] <prob-char2>


= The determinantal structure and the generator count

#theorem[determinantal structure][
  For $k >= 3$, $I_k$ is exactly the ideal of $2 times 2$ minors of the $2 times 3$ matrix
  $ mat(D(vek(w)_(k-1)); vek(v)_k), $
  i.e. $V(I_k)$ is the preimage, under $(vek(v)_1,dots,vek(v)_k) |-> mat(D(vek(w)_(k-1)(vek(v)_1,dots,vek(v)_(k-1)));
  vek(v)_k)$, of the classical rank-$<=1$ determinantal variety of $2 times 3$ matrices. (At $k=2$ the
  same statement holds with $D(vek(w)_(k-1))$ replaced by $vek(v)_1$ itself, matching @def-wk's base
  case $vek(w)_2 = vek(v)_1 times vek(v)_2$ directly.)
] <thm-determinantal>

#proof[Proof of @thm-determinantal][
  Immediate from the fact that the three components of a cross product $a times b$ are (up to sign)
  exactly the $2 times 2$ minors of the $2 times 3$ matrix with rows $a,b$, combined with
  @def-wk's recursion -- and checked independently: comparing an independent implementation of the
  $D$/cross-product recursion against the ideal actually produced by the chained bilinear formula
  gives the *exact same ideal* (Gröbner-basis containment both ways) at $k=2,dots,6$
  (#text(style: "italic")[code/verify\_determinantal\_structure\_all\_k.sage]); the underlying
  polynomial identity $"enc"([A,B]) = D("enc"(A) times "enc"(B))$ of @thm-basic-identity makes this a two-line induction
  valid for *every* $k$, not merely a pattern checked at small $k$
  (#text(style: "italic")[code/verify\_lorentzian\_encoding\_identity.sage]).
]

This theorem is the engine behind the geometric results of §5: $R_k \/ I_k$ is not merely
*determinantal-looking*, it is literally an iterated extension of the coordinate ring of a
classical determinantal variety.

#example[the $2 times 3$ matrix of @thm-determinantal, for $k=2,3,4$][
  At $k=2$: $ mat(vek(v)_1; vek(v)_2) = mat(v_(1,1), v_(1,2), v_(1,3); v_(2,1), v_(2,2), v_(2,3)). $
  At $k=3$, the first row is $D(vek(w)_2) = (-w_(2,1), -w_(2,2), w_(2,3))$ where
  $vek(w)_2 = vek(v)_1 times vek(v)_2$ is as in the previous example, giving
  $ mat(D(vek(w)_2); vek(v)_3) = mat(
      v_(1,3)v_(2,2)-v_(1,2)v_(2,3), -v_(1,3)v_(2,1)+v_(1,1)v_(2,3), -v_(1,2)v_(2,1)+v_(1,1)v_(2,2);
      v_(3,1), v_(3,2), v_(3,3)
    ). $
  At $k=4$, the first row is $D(vek(w)_3)$, entries cubic with up to 4 terms:
  $ mat(
      -v_(1,2)v_(2,1)v_(3,2) + v_(1,1)v_(2,2)v_(3,2) + v_(1,3)v_(2,1)v_(3,3) - v_(1,1)v_(2,3)v_(3,3), quad dots.h.c, quad dots.h.c;
      v_(4,1), v_(4,2), v_(4,3)
    ) $
  (the other two entries of the first row, of the same shape, omitted for width -- all displayed in
  full in #text(style: "italic")[code/verify\_determinantal\_structure\_all\_k.sage]). The row
  degree grows by one at each step ($1,2,3,dots$), while the second row is always the fresh, free
  vector $vek(v)_k$ -- exactly the "one fixed complicated row, one free row" shape @prop-detideal needs.
]

#lemma[non-degeneracy][
  For every $j >= 2$, the polynomial map $vek(w)_j : AA^(3j) -> AA^3$ is not identically zero. Hence
  $U_j := {p in AA^(3j) : vek(w)_j (p) eq.not 0}$ is a nonempty Zariski-open subset.
] <lem-nondeg>

#proof[Proof of @lem-nondeg][
  By induction: $vek(w)_2(e_1,e_2)=e_1 times e_2=e_3 eq.not 0$; given $c := vek(w)_(j-1)(p) eq.not 0$, at
  least one standard basis vector is not proportional to $D(c)$, and a cross product vanishes
  only on linearly dependent pairs, so $vek(w)_j(p,e_i) = D(c) times e_i eq.not 0$ for a suitable
  $e_i$.
]

The generator count of $I_k$ needs nothing beyond the definition and non-degeneracy -- not
codimension, not the determinantal-structure theorem above, not any external citation:

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
  By induction on $k$, and the induction hypothesis must be *independence* itself; see
  @rem-nondeg-insufficient for why the weaker non-degeneracy of @lem-nondeg does not suffice.

  *Base case $k=2$.* The three components of $vek(w)_2 = vek(v)_1 times vek(v)_2$ are the $2 times 2$
  minors of the generic $2 times 3$ matrix with rows $vek(v)_1,vek(v)_2$, displayed in
  @ex-wk-signed. Each contains a monomial the other two do not --- $v_(1,2)v_(2,3)$ occurs only in
  the first, $v_(1,3)v_(2,1)$ only in the second, $v_(1,1)v_(2,2)$ only in the third --- so no
  nontrivial constant relation is possible.

  *Induction step.* Suppose the components of $vek(w)_(k-1)$ are linearly independent over $FF$, and
  let $c in FF^3$ satisfy $c dot vek(w)_k = 0$. Writing $a := D(vek(w)_(k-1))$, the scalar triple
  product identity gives
  $ 0 = c dot (a times vek(v)_k) = (c times a) dot vek(v)_k . $
  The variables $vek(v)_k$ are a *fresh* block, occurring in neither $a$ nor $c$, and the
  right-hand side is linear in them; so each of its three coefficients vanishes separately, i.e.
  $ c times a = 0 . $

  Suppose $c eq.not 0$. Then $c times a = 0$ forces $a = f dot c$ for a single polynomial $f$ ---
  over the fraction field $c times a = 0$ says $a$ lies in the line spanned by $c$, and $f = a_i\/c_i$
  is a polynomial for any index with $c_i eq.not 0$. But then $a$'s three components are pairwise
  proportional, hence linearly *dependent* over $FF$ (any $d$ with $d dot c = 0$ gives
  $d dot a = (d dot c) f = 0$, and such a nonzero $d$ exists since $c$ spans only a line in $FF^3$).
  Since $D$ is invertible, the components of $vek(w)_(k-1) = D^(-1)(a)$ are then linearly dependent
  too, contradicting the induction hypothesis. Hence $c = 0$.

  Corroborated computationally: the coefficient matrix has rank 3 at $k=2,dots,6$
  (#text(style: "italic")[code/verify\_generator\_independence.sage]).
]

#remark[why non-degeneracy is not enough here][
  It is tempting to argue instead that a constant relation would force $D(vek(w)_(k-1))$ to be a
  *constant vector*, and to rule that out by @lem-nondeg. That argument is not valid. The relation
  forces only $c times D(vek(w)_(k-1)) = 0$, which makes the components of $D(vek(w)_(k-1))$
  pairwise proportional --- not constant. A vector such as $(f,2f,3f)$ with $f eq.not 0$ is
  nonvanishing, so @lem-nondeg does not exclude it, yet its components are visibly dependent.
  Non-degeneracy is strictly weaker than what the step needs, which is why the induction above
  carries linear independence itself.
] <rem-nondeg-insufficient>

#theorem[$I_k$ has exactly 3 minimal generators][
  For every $k >= 2$: $I_k$ has exactly 3 minimal generators.
] <thm-mingens>

#proof[Proof of @thm-mingens][
  Immediate from @lem-mingens-generic applied to @lem-mingens-indep's independence, since $I_k$
  is generated by the three (same-degree-$k$-homogeneous) components of $vek(w)_k$ by definition.
]

= The geometric structure of $V(I_k)$

#lemma[continuous images and closures preserve irreducibility][
  Let $f : X -> Y$ be a continuous map of topological spaces with $X$ irreducible. Then $f(X)$
  (with the subspace topology) is irreducible, and hence so is $overline(f(X))$.
] <lem-top-irred>

#proof[Proof of @lem-top-irred][
  *Image.* Suppose $f(X) = C_1 union C_2$ with $C_1,C_2$ closed in $f(X)$. By continuity,
  $f^(-1)(C_1)$ and $f^(-1)(C_2)$ are closed in $X$, and $X = f^(-1)(C_1) union f^(-1)(C_2)$. Since
  $X$ is irreducible, one of the two equals $X$ -- say $f^(-1)(C_1)=X$ -- so $f(X) subset.eq C_1$,
  i.e. $C_1 = f(X)$, not proper. Hence $f(X)$ is irreducible. *Closure.* If $A subset.eq Y$ is
  irreducible and $overline(A) = C_1 union C_2$ with $C_1,C_2$ closed in $Y$, then
  $A = (A inter C_1) union (A inter C_2)$; irreducibility of $A$ forces, say,
  $A subset.eq C_1$; since $C_1$ is closed, $overline(A) subset.eq C_1$, and combined with
  $C_1 subset.eq overline(A)$, $C_1 = overline(A)$, not proper. Apply both parts with
  $A := f(X)$.
]

This is purely topological -- continuity of $f$ is the only hypothesis used, nothing about $f$
being a polynomial map or morphism of varieties #bcite("Youcis2014") (working-notes/
topological-irreducibility-of-image.org has the fuller discussion, including why this observation
matters for a possible future Lean formalization of this article).

#definition[the strata $Y_1$, $Y_2$][
  For $k >= 3$, write $pi$ for the projection *forgetting $vek(v)_k$*,
  $ pi : AA^(3k) -> AA^(3(k-1)), quad pi(vek(v)_1,dots,vek(v)_k) := (vek(v)_1,dots,vek(v)_(k-1)), $
  and $Phi$ for the map
  $ Phi : AA^(3(k-1)) times AA^1 -> AA^(3k), quad Phi(p,lambda) := (p,\ lambda D(vek(w)_(k-1)(p))). $
  Define two subsets of $AA^(3k)$:
  $ Y_1 := V(I_(k-1)) times AA^3, quad Y_2 := overline(Phi(AA^(3k-2))). $
  $Y_1$ is the locus where the previous bracket already vanishes, with $vek(v)_k$ completely free;
  $Y_2$ is the closure of the locus swept out as $vek(v)_k$ ranges over scalar multiples of
  $D(vek(w)_(k-1)(p))$, over all $p in AA^(3(k-1))$. At $k=2$ there is no "previous bracket" to chain
  from, so neither $Y_1$ nor $Phi$ is defined; by convention $Y_2 := V(I_2)$ directly there,
  matching @thm-determinantal's own base-case treatment.
] <def-y1y2>

#figure(
  align(center)[
    #box(width: 6.4cm, height: 8.4cm)[
      #place(top + center, dx: 0.85cm, dy: 0cm)[
        #ellipse(stroke: 0.6pt, inset: 8pt)[$AA^(3(k-1)) times AA^1$]
      ]
      #place(top + center, dx: 0.85cm, dy: 1.55cm)[$Phi$]
      #place(top + center, dx: 0.85cm, dy: 1.95cm)[#sym.arrow.b]
      #place(top + center, dy: 2.5cm)[
        #box(width: 6cm, height: 5.4cm, stroke: 0.6pt, radius: 50%)[
          #place(top + left, dx: 0.3cm, dy: 0.2cm)[#text(size: 9pt)[$AA^(3k)$]]
          #place(top + center, dx: -0.95cm, dy: 1.5cm)[
            #box(width: 2.85cm, height: 2.95cm,
                 stroke: (paint: black, thickness: 0.5pt, dash: "dashed"),
                 radius: 50%, fill: rgb(90%, 90%, 100%, 60%))[
              #place(top + left, dx: 0.12cm, dy: 0.12cm)[#text(size: 7.5pt)[$Y_1$]]
            ]
          ]
          #place(top + center, dx: 0.95cm, dy: 1.75cm)[
            #box(width: 2.85cm, height: 2.4cm,
                 stroke: (paint: black, thickness: 0.5pt, dash: "dashed"),
                 radius: 50%, fill: rgb(100%, 90%, 90%, 60%))[
              #place(bottom + right, dx: -0.12cm, dy: -0.12cm)[#text(size: 7.5pt)[$Y_2$]]
            ]
          ]
        ]
      ]
    ]
  ],
  caption: [Both strata of $V(I_k)=Y_1 union Y_2$ inside the same ambient $AA^(3k)$: $Y_1 :=
    V(I_(k-1)) times AA^3$ (identifying $AA^(3(k-1)) times AA^3 tilde.equiv AA^(3k)$) and
    $Y_2 := overline(Phi(AA^(3k-2)))$, $Phi$'s image ($Phi$ shown mapping in from above, into
    $Y_2$ specifically -- $Y_1$ is not part of $Phi$'s image). The two overlap (not disjoint,
    Propositions 17-18 rule out either containing the other): $Phi(p,0)=(p,0)$ for *every* $p$, so
    the whole zero-section $\{(p,0)\}$ lies in $Y_2$, and its intersection with $Y_1$ is
    $V(I_(k-1)) times \{0\}$, of dimension $3k-5$ -- properly smaller than either stratum's own
    dimension $3k-2$.]
) <fig-phi-y2>

#lemma[$Y_2$ is irreducible][
  For $k >= 3$: $Y_2$ (@def-y1y2) is irreducible, and in fact its defining ideal (the graph ideal
  of $Phi$ with $lambda$ eliminated) is prime.
] <lem-y2-irred>

#proof[Proof of @lem-y2-irred][
  $Phi$ is a polynomial map, hence continuous for the Zariski topology (preimages of Zariski-closed
  sets under a polynomial map are again Zariski-closed, by substitution), and its domain
  $AA^(3k-2)$ is irreducible (the polynomial ring over $FF$ is a domain, so the zero ideal is
  prime). @lem-top-irred gives $Y_2$ irreducible directly. Primality of the elimination ideal
  follows the same way: it is the kernel of a map into a domain
  ($FF[vek(v)_1,dots,vek(v)_k]\/(dot) tilde.equiv FF[vek(v)_1,dots,vek(v)_(k-1),lambda]$), hence prime -- this holds for
  every $k$ by this argument alone, additionally corroborated computationally at $k=4$ by computing
  the elimination ideal directly and confirming primality in Sage, as an independent check rather
  than a substitute for the argument.
]

#example[the defining ideals of $Y_1$ *and* $Y_2$, for $k=2,3,4$][
  Writing $vek(v)_i = (v_(i,1),v_(i,2),v_(i,3))$ for the three coordinates of block $vek(v)_i$: at $k=2$,
  $Y_2 := V(I_2)$ (the base-case convention above), so its ideal *is* $I_2$, generated by
  $ v_(1,2) v_(2,3) - v_(1,3) v_(2,2), quad v_(1,3) v_(2,1) - v_(1,1) v_(2,3), quad
    v_(1,1) v_(2,2) - v_(1,2) v_(2,1). $
  ($Y_1$ is not defined at $k=2$, @def-y1y2.) For $k>=3$, $Y_1$'s defining ideal is simply $I_(k-1)$
  itself, viewed inside $R_k$ by leaving $vek(v)_k$ free -- at $k=3$, exactly the three generators
  displayed above for $I_2$, now inside $R_3$ with $vek(v)_3$ not appearing at all; at $k=4$, exactly
  $I_3$'s three generators (displayed below in this same example) inside $R_4$ with $vek(v)_4$ free.
  Unlike $Y_2$, no elimination is needed to compute $Y_1$'s ideal -- it is already $I_(k-1)$'s own
  generating set, unchanged. At $k=3$, $Y_2$'s elimination ideal (computed directly, not inferred)
  is generated by
  $ v_(2,1) v_(3,1) + v_(2,2) v_(3,2) - v_(2,3) v_(3,3), quad
    v_(1,1) v_(3,1) + v_(1,2) v_(3,2) - v_(1,3) v_(3,3), $
  $ v_(1,2) v_(2,1) v_(3,2) - v_(1,1) v_(2,2) v_(3,2) - v_(1,3) v_(2,1) v_(3,3)
    + v_(1,1) v_(2,3) v_(3,3) $
  -- notably, two of the three generators are *linear* in $vek(v)_3$ (exactly the two components of the
  "proportionality" condition $vek(v)_3 prop D(vek(w)_2)$), and only the third, not involving $vek(v)_3$ at all,
  carries the full complexity of $D(vek(w)_2)$ itself. *This ideal is a proper factor of $I_3$, not
  equal to it* -- $I_3$ is the intersection of this ideal with a second prime (the "$Y_1$" piece,
  where the $k=2$ bracket already vanishes); see the component-count example after @thm-componentcount
  below, where this exact ideal reappears as one of $I_3$'s two primary components. At $k=4$, by the
  same pattern, two of the three generators are linear in $vek(v)_4$ and the third is not, now degree 4:
  $ v_(3,1) v_(4,1) + v_(3,2) v_(4,2) - v_(3,3) v_(4,3), $
  $ v_(1,3) v_(2,2) v_(4,1) - v_(1,2) v_(2,3) v_(4,1) - v_(1,3) v_(2,1) v_(4,2)
    + v_(1,1) v_(2,3) v_(4,2) + v_(1,2) v_(2,1) v_(4,3) - v_(1,1) v_(2,2) v_(4,3), $
  $ v_(1,3) v_(2,1) v_(3,1) v_(4,2) - v_(1,1) v_(2,3) v_(3,1) v_(4,2)
    + v_(1,3) v_(2,2) v_(3,2) v_(4,2) - v_(1,2) v_(2,3) v_(3,2) v_(4,2) $
  $ - v_(1,2) v_(2,1) v_(3,1) v_(4,3) + v_(1,1) v_(2,2) v_(3,1) v_(4,3)
    - v_(1,3) v_(2,2) v_(3,3) v_(4,3) + v_(1,2) v_(2,3) v_(3,3) v_(4,3). $
  All computed directly (elimination of $lambda$ from the graph ideal of $Phi$, in Sage), not just
  asserted from the pattern.
]

#remark[the closure, not the raw image, is what is needed][
  A polynomial map's image need not itself be closed -- the standard example is
  $AA^2 -> AA^2$, $(x,y) |-> (x,x y)$, whose image is not even locally closed, though it is
  *constructible* (a finite union of locally closed sets) by Chevalley's theorem, which has no
  purely topological analogue for general continuous maps #bcite("Youcis2014"). This never causes
  a problem for $Y_2$,
  because $Y_2$ is *defined* as $overline(Phi(dot))$ from the outset, and the decomposition used in
  @thm-codim's proof below, $V(I_k) = Y_1 union Y_2$, is established by a direct case split rather
  than by taking closures and hoping: a point $(p,vek(v)_k) in V(I_k)$ either has $D(vek(w)_(k-1)(p))=0$,
  putting it in $Y_1$ directly, or has $vek(v)_k = lambda D(vek(w)_(k-1)(p))$ for some $lambda$, so
  $(p,vek(v)_k) = Phi(p,lambda)$ is *literally* a value of $Phi$ -- not merely a limit point -- hence in
  $Y_2$ with no appeal to closure at all. The reverse containment
  $Y_1 union Y_2 subset.eq V(I_k)$ needs only that $Phi(dot) subset.eq V(I_k)$ (a cross product of
  a vector with itself vanishes: $D(vek(w)_(k-1)) times (lambda D(vek(w)_(k-1))) = 0$ identically)
  together with $V(I_k)$ already being closed, automatic since it is a vanishing locus by
  definition. So the theorem never needs "the image of $Phi$ is closed" -- only that it is
  contained in the already-closed $V(I_k)$, which is immediate.
] <rem-closure-suffices>

#lemma[dimension of $Y_2$, and where it lives][
  With $Y_2$ as in @lem-y2-irred and $U_(k-1)$ as in @lem-nondeg: $dim Y_2 = 3k-2$, and $Y_2$ meets
  $pi^(-1)(U_(k-1))$ nonemptily, where $pi$ is the projection of @def-y1y2, forgetting $vek(v)_k$.
] <lem-y2-dim>

#proof[Proof of @lem-y2-dim][
  $pi : AA^(3k) -> AA^(3(k-1))$ discards the last block: $pi(vek(v)_1,dots,vek(v)_k) =
  (vek(v)_1,dots,vek(v)_(k-1))$. Hence $pi^(-1)(U_(k-1)) = U_(k-1) times AA^3$, the set of points
  whose *first* $k-1$ blocks lie in $U_(k-1)$ and whose $vek(v)_k$ is completely unconstrained. Over
  $U_(k-1)$, $Phi$ is injective. Both $p$ and $lambda$ can be recovered from $Phi(p,lambda)$: $p$
  directly, and $lambda$ by dividing any nonzero coordinate of $vek(v)_k=lambda D(vek(w)_(k-1)(p))$
  by the corresponding coordinate of $D(vek(w)_(k-1)(p))$; this division is well-defined since
  $D(vek(w)_(k-1)(p)) eq.not 0$ on $U_(k-1)$. Injectivity gives
  $dim Y_2 = dim (U_(k-1) times AA^1) = 3(k-1)+1 = 3k-2$. Since $U_(k-1)$ is nonempty by
  @lem-nondeg, $Phi(U_(k-1) times {1})$ is a nonempty subset of $Y_2 inter pi^(-1)(U_(k-1))$.
]

#theorem[$I_k$ has codimension 2][
  For every $k >= 2$: $dim V(I_k) = 3k-2$, i.e. $"codim"(I_k) = 2$.
] <thm-codim>

#proof[Proof of @thm-codim][
  Induction on $k$. *Base case $k=2$*: $V(I_2)$ is the rank-$<=1$ locus of a $2 times 3$ matrix
  with independent-indeterminate entries, of the standard dimension $4 = 3 dot 2 - 2$ for the
  generic determinantal variety of this shape #bcite("MotzkinTaussky1955"). *Inductive step*: by
  @thm-determinantal, and since $a times b = 0$ if and only if $a,b$ are linearly dependent,
  $V(I_k) = Y_1 union Y_2$ (@def-y1y2). The locus $D(vek(w)_(k-1))=0$ gives $Y_1$, with $vek(v)_k$
  unconstrained; the locus $D(vek(w)_(k-1)) eq.not 0$ with $vek(v)_k$ proportional to it gives a
  subset of $Y_2$. This is the direct case split of @rem-closure-suffices, not merely a
  closure-level approximation. By the inductive hypothesis, $dim V(I_(k-1)) = 3(k-1)-2$, so
  $dim Y_1 = 3(k-1)-2+3 = 3k-2$. Also $dim Y_2 = 3k-2$, by @lem-y2-dim. Hence
  $dim V(I_k) = dim(Y_1 union Y_2) = 3k-2$. This dimension statement alone needs no containment
  argument; that is needed only for the sharper component-count result below.
]

#example[dimension and codimension, for $k=2,3,4$][
  Values of $dim R_k$ (the ambient dimension, $=3k$), $dim(R_k \/ I_k)$ (the dimension of the
  variety $V(I_k)$ -- *not* "$dim I_k$", an ideal is not a variety and does not itself have a
  dimension in this sense), and $"codim"(I_k) := dim R_k - dim(R_k \/ I_k)$:
  #align(center)[
    #table(
      columns: 4,
      align: center,
      stroke: 0.5pt,
      inset: 6pt,
      [$k$], [$dim R_k$], [$dim(R_k \/ I_k)$], [$"codim"(I_k)$],
      [2], [6], [4], [2],
      [3], [9], [7], [2],
      [4], [12], [10], [2],
    )
  ]
  All three rows follow directly from @thm-codim's formula $dim(R_k\/I_k)=3k-2$; also confirmed by
  direct Gröbner-basis dimension computation in Sage at each $k$, as an independent check.
]

#proposition[$Y_2 subset.not.eq Y_1$][
  With $Y_1, Y_2$ as in the proof of @thm-codim: $Y_2 subset.not.eq Y_1$.
] <prop-y2-not-in-y1>

#proof[Proof of @prop-y2-not-in-y1][
  Pick $p in U_(k-1)$ (@lem-nondeg); then $Phi(p,0)=(p,0) in Y_2$ but $vek(w)_(k-1)(p) eq.not 0$ puts
  $(p,0) in.not Y_1$.
]

#proposition[no component of $Y_1$ lies in $Y_2$][
  No irreducible component $Z$ of $V(I_(k-1))$ (each of dimension $3(k-1)-2$, by @thm-codim applied
  at $k-1$) has $Z times AA^3 subset.eq Y_2$.
] <prop-y1-not-in-y2>

#proof[Proof of @prop-y1-not-in-y2][
  Both $Z times AA^3$ and $Y_2$ are irreducible: $Y_2$ by @lem-y2-irred, and $Z times AA^3$ because
  a product of irreducible varieties is irreducible ($Z$ is irreducible by hypothesis, and $AA^3$
  trivially is). Both have the *same* dimension $3k-2$, by @thm-codim and @lem-y2-dim. Containment
  would therefore force equality. This is refuted: $Z times AA^3$ is disjoint from
  $pi^(-1)(U_(k-1))$, since $vek(w)_(k-1)$ vanishes identically on $Z subset V(I_(k-1))$; but $Y_2$
  meets $pi^(-1)(U_(k-1))$, by @lem-y2-dim.
]

#theorem[component count][
  For every $k >= 2$: $V(I_k)$ has exactly $k-1$ irreducible components, each of dimension $3k-2$.
  The component indexed $j=2,dots,k$ involves exactly the first $j$ coordinate blocks and nothing
  later.
] <thm-componentcount>

#proof[Proof of @thm-componentcount][
  Induction on $k$. *Base case $k=2$*: the rank-$<=1$ locus of a generic $2 times 3$ matrix is
  irreducible -- the affine cone over the Segre embedding $PP^1 times PP^2 arrow.hook PP^5$,
  equivalently the Motzkin-Taussky #bcite("MotzkinTaussky1955") irreducibility of the $2 times 2$
  commuting variety -- so exactly 1 component, matching $k-1=1$. *Step*: $V(I_k) = Y_1 union Y_2$
  as in @thm-codim's proof; by the inductive hypothesis $Y_1$ has $k-2$ irreducible components,
  each of dimension $3k-2$ (@thm-codim), none contained in another; @prop-y2-not-in-y1 and
  @prop-y1-not-in-y2 rule out containment between $Y_2$ and any of them or vice versa. A finite
  union of irreducible closed sets with no containments is irredundant, giving exactly
  $(k-2)+1=k-1$ components.
]

This gives $I_k$'s minimal primes and their count, but not yet that $I_k$ is radical (so not yet
that these are literally the components of a *primary* decomposition of $I_k$ itself, as opposed to
of $sqrt(I_k)$) -- that is closed in §6, after Cohen-Macaulayness is available.

#definition[the components $P_j$][
  For $k >= 2$ and $j=2,dots,k$, write $P_j$ for the vanishing ideal of the component of $V(I_k)$
  indexed $j$ in @thm-componentcount -- the one involving exactly the first $j$ coordinate blocks.
  Explicitly, recursively in $j$:
  - *Base case, $j=k$*: $P_k$ is $Y_2$'s own defining ideal at parameter $k$ (@lem-y2-irred).
  - *Recursive case, $j<k$*: $P_j$ is that same ideal computed at parameter $j$ instead -- i.e.
    $Y_2$'s defining ideal when the construction is run with $k=j$ -- viewed inside $R_k$ by
    leaving $vek(v)_(j+1),dots,vek(v)_k$ free.
  - *Consequence*: $P_j$ does not depend on which $k>=j$ it is viewed inside of -- it is the same
    ideal, just embedded in a ring with more or fewer free variables.
] <def-primecomponents>

#example[a suitable point of $Y_2$, concretely, at $k=3$][
  Rather than only the defining ideal (Example 24 below), a single explicit point: take
  $vek(v)_1=(1,0,0)$, $vek(v)_2=(0,1,0)$ (so $vek(v)_1 in U_2$, @lem-nondeg), giving
  $vek(w)_2=vek(v)_1 times vek(v)_2=(0,0,1)$ and $D(vek(w)_2)=(0,0,1)$. Taking $lambda=1$ in
  @def-y1y2's $Phi$, i.e. $vek(v)_3 := D(vek(w)_2)=(0,0,1)$, gives the point
  $ (vek(v)_1,vek(v)_2,vek(v)_3) = ((1,0,0),(0,1,0),(0,0,1)) in Y_2 subset AA^9. $
  Directly: $vek(w)_3 = D(vek(w)_2) times vek(v)_3 = (0,0,2) times (0,0,2) = 0$ (a vector crossed
  with itself), confirming this point lies in $V(I_3)$, as any point of the form $Phi(p,lambda)$
  must (@def-y1y2). This is also, concretely, a point of the largest-dimension inherited case: it
  is *not* a rank-2 witness in @lem-witness-new's sense (that witness uses $lambda=0$, not
  $lambda=1$) -- it illustrates $Y_2$ itself, not the radicality argument's own witness points.
]

#proposition[rational parametrization of each component][
  For $k >= 2$ and $j=2,dots,k$, the component of $V(I_k)$ indexed $j$ (@thm-componentcount) is a
  *rational* variety: it is the closure of the image of the polynomial map
  $ AA^(3(j-1)) times AA^1 times AA^(3(k-j)) -> AA^(3k), quad (p,lambda,q) |-> (Phi_j (p,lambda), q), $
  where $Phi_j$ is $Phi$ (@def-y1y2) run at parameter $j$ in @def-primecomponents' sense (at $j=2$,
  $Phi_2(p,lambda):=(p,lambda p)$, matching @thm-determinantal's own base-case convention), and $q$
  fills the remaining free blocks $vek(v)_(j+1),dots,vek(v)_k$. This map is moreover *birational* onto the
  component: it is injective over $U_(j-1) times AA^1 times AA^(3(k-j))$, by the same argument as
  @lem-y2-dim, applied at parameter $j$.
] <prop-rational>

#proof[Proof of @prop-rational][
  By @def-primecomponents, $P_j$'s defining ideal is $Y_2$'s own defining ideal run at parameter
  $j$ -- i.e. the component itself *is* $Y_2$ at parameter $j$, crossed with the free blocks
  $vek(v)_(j+1),dots,vek(v)_k$. @lem-y2-dim's injectivity argument (over $U_(j-1)$, via @lem-nondeg at level
  $j-1$) applies verbatim at parameter $j$, and appending the free blocks $q$ unchanged does not
  affect injectivity.
]

#remark[a reducible variety is not itself "rational" -- component-by-component is what @prop-rational answers][
  $Y_1 := V(I_(k-1)) times AA^3$ (@def-y1y2) is *not* irreducible for $k >= 4$ -- it is a union of
  $k-2$ of the components above (@thm-componentcount's inductive step) -- so a single rational
  parametrization *of $Y_1$ as one object* is not meaningful in the usual sense (rationality is a
  property of irreducible varieties). What *is* meaningful, and what @prop-rational supplies, is a
  rational parametrization of each of $Y_1$'s irreducible pieces individually -- exactly the
  components inherited from $V(I_(k-1))$.
]

#example[the components, worked out at $k=3$][
  Uniformly by $k$, since the components' *count* and *block pattern* are already known
  (@thm-componentcount, @def-primecomponents) and only their explicit generators change:
  - *At $k=2$*: $I_2$ is already prime (@thm-componentcount's base case), so $V(I_2)$ has exactly
    $k-1=1$ component -- itself.
  - *At $k=3$*: exactly $k-1=2$ components, both computed directly (Gröbner bases, not inferred
    from the pattern alone), matching $I_3 = P_2 inter P_3$:
    - $P_2$, the "$Y_1$" piece (block pattern $\{1,2\}$, matching that the length-2 sub-bracket
      already vanishes with $vek(v)_3$ free) -- generated by exactly $I_2$'s three generators from
      the first example, now inside $R_3$ with $vek(v)_3$ simply not appearing:
      $ v_(1,2)v_(2,3)-v_(1,3)v_(2,2), quad v_(1,3)v_(2,1)-v_(1,1)v_(2,3), quad
        v_(1,1)v_(2,2)-v_(1,2)v_(2,1). $
    - $P_3$, the "$Y_2$" piece (block pattern $\{1,2,3\}$) -- exactly the ideal already computed
      in the $Y_2$-defining-ideal example above:
      $ v_(2,1)v_(3,1)+v_(2,2)v_(3,2)-v_(2,3)v_(3,3), quad
        v_(1,1)v_(3,1)+v_(1,2)v_(3,2)-v_(1,3)v_(3,3), $
      $ v_(1,2)v_(2,1)v_(3,2) - v_(1,1)v_(2,2)v_(3,2) - v_(1,3)v_(2,1)v_(3,3)
        + v_(1,1)v_(2,3)v_(3,3). $
  - *At $k=4$*: exactly $k-1=3$ components, block patterns $\{1,2\}$, $\{1,2,3\}$, $\{1,2,3,4\}$:
    - The first two, $P_2$ and $P_3$, are inherited *verbatim* from $k=3$ above, with $vek(v)_4$
      simply left free -- not recomputed, per @def-primecomponents' own "does not depend on which
      $k$" clause.
    - The third, $P_4$, is the new "$Y_2$" stratum -- exactly the $k=4$ row of the earlier
      $Y_2$-defining-ideal example (generators omitted here to avoid repeating that display; same
      growth pattern, quartic with up to 8 terms per generator).
]

= Cohen-Macaulayness

#proposition[Eagon-Northcott / Hilbert-Burch, applied][
  Let $M$ be a $2 times 3$ matrix with entries in a polynomial ring $R$ over a field (arbitrary
  entries, not necessarily independent indeterminates), and $J$ the ideal of its $2 times 2$
  minors. If $J$ has the *expected* codimension $3-2+1=2$, then $J$ is a perfect ideal of grade 2
  -- $"pd"(R\/J)=2$, hence $R\/J$ is Cohen-Macaulay.
] <prop-detideal>

#proof[Proof of @prop-detideal][
  Bruns and Vetter #bcite("BrunsVetter1988"), Theorem (2.7), p. 13, gives exactly this for an
  *arbitrary* matrix, as needed since one row of our $2 times 3$ matrix ($D(vek(w)_(k-1))$) is a
  fixed polynomial vector, not a row of independent indeterminates. (The original construction,
  Eagon and Northcott #bcite("EagonNorthcott1962"), is superseded here by Bruns-Vetter's more
  general treatment -- confirmed closed-access via Unpaywall, not used directly.)
]

#remark[why the generator count above wasn't proven this way][
  It is tempting to expect @prop-detideal to also hand over the generator count for free via
  Bruns-Vetter's Theorem (16.36), p. 217 ("The Theorem of Hilbert-Burch") -- but that theorem, as
  actually stated, gives only $I = a dot I_m (f)$ for a nonzerodivisor $a$, not a generator count
  on its own: at expected codimension, an *arbitrary* $2 times 3$ matrix's minors can be perfect
  and Cohen-Macaulay while one minor vanishes identically or is a scalar combination of the others
  (concretely: $mat(x,y,0;0,0,1)$ over $FF[x,y]$ has minors $0,x,y$, height 2 as expected,
  $J=(x,y)$ perfect and Cohen-Macaulay with only *2* generators). This is exactly why @thm-mingens
  was proven directly from linear independence instead of cited from this section's machinery.
]

#theorem[$R_k \/ I_k$ is Cohen-Macaulay][
  For every $k >= 2$: $R_k \/ I_k$ is Cohen-Macaulay.
] <thm-cm>

#proof[Proof of @thm-cm][
  By @thm-codim, $I_k$ has codimension 2, the expected value for the $2 times 3$ matrix of
  @thm-determinantal presenting it. @prop-detideal applies directly. (This uses @thm-codim only --
  not @thm-mingens's generator count, not @thm-componentcount's component count -- genuinely
  independent of both.)
]

= Radicality

Cohen-Macaulayness and the explicit component structure of §5 combine, via Serre's criterion, to
give radicality -- which then closes both the generator-count (§4) / Cohen-Macaulay (§6) story
(making $I_k$ itself, not just $sqrt(I_k)$, the object with those properties) and upgrades §5's
component count to a genuine primary decomposition.

#lemma[reduction via Serre][
  Recall Serre's condition $S_n$: a Noetherian ring $A$ satisfies $S_n$ if
  $"depth"(A_P) >= min(n, dim A_P)$ for every prime $P subset A$ (Cohen-Macaulay means
  $"depth"(A_P) = dim A_P$ at *every* prime -- the extremal case, $n=infinity$ in effect). Cohen-Macaulay
  rings satisfy $S_n$ for every $n$: $"depth"(A_P) = dim A_P >= min(n,dim A_P)$ trivially, whatever
  $n$ is -- this needs nothing beyond the two definitions just given, standard for Serre's
  conditions in general (see e.g. Bruns and Vetter #bcite("BrunsVetter1988") or Eisenbud's
  #emph[Commutative Algebra with a View Toward Algebraic Geometry]). In particular $S_1$. Serre's
  criterion for reducedness -- a Noetherian ring is reduced if and only if it satisfies $R_0$ and
  $S_1$ #bcite("Stacks031O") -- then says that, given @thm-cm, radicality of $I_k$ is equivalent to
  $R_0$ alone: regularity of $R_k \/ I_k$ at each of its minimal primes.
] <lem-serre>

The three lemmas that follow are the standard Jacobian criterion, split into its two genuinely
separate ingredients -- one linear-algebraic (@lem-cotangent), one dimension-theoretic
(@lem-localdim) -- before either is used. The order is deliberate: the rank bound and the
regularity criterion each draw on *both* ingredients and on neither each other, which a single
pair of mutually-citing lemmas (as in an earlier draft of this section) obscures.

#lemma[the cotangent identity][
  Let $S=FF[x_1,dots,x_n]$, $I=(f_1,dots,f_m)$, $A=S\/I$, and $x in V(I)$ an $FF$-rational point,
  with $frak(n) subset S$ the maximal ideal at $x$ and $frak(m) = frak(n)\/I subset A$ its image.
  Then
  $ dim_FF frak(m)\/frak(m)^2 = n - "rank" "Jac"(x). $
] <lem-cotangent>

#proof[Proof of @lem-cotangent][
  Linear algebra only; no hypothesis on $A$ is needed. Sending $g$ to its gradient at $x$
  identifies the cotangent space $frak(n)\/frak(n)^2$ with $FF^n$. Under that identification the
  image of $I$ is the span of the linear parts at $x$ of $f_1,dots,f_m$: a general element of $I$
  is $sum_i g_i f_i$, whose linear part at $x$ is $sum_i g_i (x)$ times that of $f_i$, since every
  $f_i$ vanishes at $x$. That span is the row space of $"Jac"(x)$, of dimension
  $"rank" "Jac"(x)$. As $frak(m)\/frak(m)^2 tilde.equiv (frak(n)\/frak(n)^2) \/ "im"(I)$, the
  claim follows.
]

#lemma[the local dimension at a rational point][
  Let $S=FF[x_1,dots,x_n]$, $I=(f_1,dots,f_m)$, $A=S\/I$ equidimensional of dimension $n-c$, and
  $x in V(I)$ an $FF$-rational point with maximal ideal $frak(m) subset A$ and Jacobian
  $"Jac"(x) in FF^(m times n)$. Then $dim A_frak(m) = n-c$.
] <lem-localdim>

#proof[Proof of @lem-localdim][
  $dim A_frak(m) = max{dim (A\/P)_frak(m) : P in "Min"(A), P subset.eq frak(m)}$, and each
  $A\/P = S\/tilde(P)$ is an affine domain over a field, for which
  $dim (S\/tilde(P))_frak(M) = dim S\/tilde(P)$ at *every* maximal ideal $frak(M)$ -- affine
  domains over a field are catenary and equicodimensional (Eisenbud, #emph[Commutative Algebra],
  Cor. 13.4; equivalently the Stacks Project, tag 00OS #bcite("Stacks00OS") -- a dimension formula
  for finitely generated field extensions, holding over an arbitrary field, not needing a
  perfect-field hypothesis by accident). By equidimensionality every such $dim S\/tilde(P)$ equals
  $n-c$.
]

#lemma[Jacobian criterion: the rank bound][
  Hypotheses as in @lem-localdim. Then $"rank" "Jac"(x) <= c$.
] <lem-jacobian-rankbound>

#proof[Proof of @lem-jacobian-rankbound][
  $dim_FF frak(m)\/frak(m)^2 >= dim A_frak(m)$ in any Noetherian local ring. By @lem-cotangent the
  left-hand side is $n - "rank" "Jac"(x)$, and by @lem-localdim the right-hand side is $n-c$;
  rearranging gives $"rank" "Jac"(x) <= c$.
]

#lemma[Jacobian criterion: regularity at rank $=c$][
  Hypotheses as in @lem-localdim. If $"rank" "Jac"(x) = c$, then $A_frak(m)$ is regular of
  dimension $n-c$; in particular $x$ lies on a *unique* component of $V(I)$, whose local ring there
  is a field.
] <lem-jacobian-regularity>

#proof[Proof of @lem-jacobian-regularity][
  If $"rank" "Jac"(x) = c$ then $dim_FF frak(m)\/frak(m)^2 = n-c$ by @lem-cotangent, while
  $dim A_frak(m) = n-c$ by @lem-localdim; equality of the two is the definition of regularity. A
  regular local ring is a domain, so $frak(m)$ contains a unique minimal prime of $A$, and the
  local ring at that prime is a further localization of a regular local ring at its own maximal
  ideal in dimension 0, hence a field.
]

#lemma[the Jacobian's own recursion][
  Write $J_k$ for the $3 times 3k$ Jacobian of $vek(w)_k$, $[u]_times$ for the skew matrix with
  $[u]_times v = u times v$. Then
  $J_2 = [ -[vek(v)_2]_times mid(|) [vek(v)_1]_times ]$, and for $k >= 3$,
  $ J_k = [ -[vek(v)_k]_times D J_(k-1) mid(|) [D(vek(w)_(k-1))]_times ]. $
] <lem-jacrecursion>

#proof[Proof of @lem-jacrecursion][
  For the second block, $vek(w)_k = D(vek(w)_(k-1)) times vek(v)_k = [D(vek(w)_(k-1))]_times vek(v)_k$ is linear in
  $vek(v)_k$ with coefficient matrix free of $vek(v)_k$. For the first, differentiating
  $vek(w)_k = D(vek(w)_(k-1)) times vek(v)_k$ with respect to any variable $t$ among $vek(v)_1,dots,vek(v)_(k-1)$ gives
  $∂_t vek(w)_k = (D ∂_t vek(w)_(k-1)) times vek(v)_k = -[vek(v)_k]_times D ∂_t vek(w)_(k-1)$, using
  $a times b = -[b]_times a$; assembling columns gives the stated product.
]

#example[$J_3$, explicitly][
  With variables ordered $v_(1,1),v_(1,2),v_(1,3),v_(2,1),v_(2,2),v_(2,3),v_(3,1),v_(3,2),v_(3,3)$,
  the $3 times 9$ Jacobian of $vek(w)_3$ (the three generators of $I_3$ from the earlier example),
  column-blocked to match @lem-jacrecursion's formula $J_3 = [ -[vek(v)_3]_times D J_2 mid(|)
  [D(vek(w)_2)]_times ]$ -- shown here as the two blocks separately, since side by side the full
  $3 times 9$ matrix does not fit the page width. First, $-[vek(v)_3]_times D J_2$ ($3 times 6$):
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
  and then $[D(vek(w)_2)]_times$ ($3 times 3$, the skew matrix of $D(vek(w)_2)$'s three coordinates from
  the earlier matrix example):
  $ mat(
      0, v_(1,2)v_(2,1)-v_(1,1)v_(2,2), -v_(1,3)v_(2,1)+v_(1,1)v_(2,3);
      -v_(1,2)v_(2,1)+v_(1,1)v_(2,2), 0, -v_(1,3)v_(2,2)+v_(1,2)v_(2,3);
      v_(1,3)v_(2,1)-v_(1,1)v_(2,3), v_(1,3)v_(2,2)-v_(1,2)v_(2,3), 0
    ) $
  Both blocks computed directly, not merely asserted from the recursive formula.
]

#remark[a false shortcut, caught and corrected][
  A naive reading of @lem-jacrecursion suggests appending $vek(v)_k=0$ preserves rank on an inherited
  component -- this is false: the old-variable block is left-multiplied by $-[vek(v)_k]_times D$, not
  merely padded with zero rows. At the first inherited case ($k=2 arrow.r 3$), appending $vek(v)_3=0$
  actually drops the rank to 0. The correct witness (@lem-witness-inherited below) instead picks
  $vek(v)_k = e_i$ for a standard basis vector *not* lying in $D dot "im" J_(k-1)(q)$ -- a genuine
  choice, not a formality.
]

#lemma[rank-2 witness on the new component][
  For every $k >= 3$, there is a point $x = (p,0)$, $p$ the @lem-nondeg non-degeneracy witness at
  level $k-1$, with $x in V(I_k)$ and $"rank" J_k(x) = 2$. At $k=2$ the same conclusion holds with
  $x=(p,0)$ for any $p eq.not 0$.
] <lem-witness-new>

#proof[Proof of @lem-witness-new][
  *The case $k=2$ separately*, because the statement above cannot be read at $k=2$: it would refer
  to a non-degeneracy witness "at level 1", and neither $vek(w)_1$ nor @lem-nondeg exists there ---
  @def-wk starts the recursion at $j=2$. Nor does @lem-jacrecursion's $k >= 3$ formula apply. Argue
  directly instead: $J_2 = [ -[vek(v)_2]_times mid(|) [vek(v)_1]_times ]$ carries no $D$ at all, so
  for any $p eq.not 0$, $J_2(p,0) = [ 0 mid(|) [p]_times ]$, which has rank 2 by the kernel
  computation below. And $(p,0) in V(I_2)$ since $vek(w)_2(p,0) = p times 0 = 0$.

  *For $k >= 3.$* By @lem-jacrecursion, $J_k(p,0) = [ 0 mid(|) [D(vek(w)_(k-1)(p))]_times ]$ since
  $-[0]_times D J_(k-1)(p) = 0$; and $D(vek(w)_(k-1)(p)) eq.not 0$ since $vek(w)_(k-1)(p) eq.not 0$
  (@lem-nondeg) and $D$ is invertible. For $u eq.not 0$,
  $ker [u]_times = {v : u times v = 0} = FF u$ (a cross product vanishes exactly on linearly
  dependent pairs), so $[D(vek(w)_(k-1)(p))]_times$ has rank 2, giving $"rank" J_k(p,0) = 2$.
]

#lemma[rank-2 witness on an inherited component][
  For every $k >= 3$ and every component $Z$ of $V(I_(k-1))$ with a rank-2 witness $q in Z$
  (@lem-witness-new, or this lemma applied at $k-1$), there is $x = (q,e_i) in Z times AA^3 subset
  V(I_k)$ with $"rank" J_k(x) = 2$.
] <lem-witness-inherited>

#proof[Proof of @lem-witness-inherited][
  Let $W := D dot "im" J_(k-1)(q)$, a 2-dimensional subspace of $FF^3$ since $D$ is invertible and
  $"rank" J_(k-1)(q)=2$. Since $e_1,e_2,e_3$ span $FF^3$ and $W eq.not FF^3$, some $e_i in.not W$;
  fix such an $i$. Since $q in V(I_(k-1))$, $vek(w)_(k-1)(q)=0$, so @lem-jacrecursion gives
  $J_k(q,e_i) = [ -[e_i]_times D J_(k-1)(q) mid(|) 0 ] $, of rank $dim([e_i]_times W)$ since
  $D J_(k-1)(q)$ has image exactly $W$. As $ker [e_i]_times = FF e_i$ and $W inter FF e_i = 0$
  (else $e_i in W$), $[e_i]_times$ is injective on $W$, so $dim([e_i]_times W) = 2$.
]

#theorem[$I_k$ is radical][
  For every $k >= 2$: $I_k$ is radical.
] <thm-radical>

#proof[Proof of @thm-radical][
  By induction on $k$ (mirroring @thm-componentcount's own induction), @lem-witness-new and
  @lem-witness-inherited exhibit a rank-2-Jacobian point on *every* one of the $k-1$ components of
  @thm-componentcount. @lem-jacobian-regularity then gives $R_0$ at every one (and, by its
  "unique component" clause, confirms each witness lies only on its intended component -- an
  independent check on @thm-componentcount's count, not merely assumed); @lem-serre gives $S_1$,
  using @thm-cm's Cohen-Macaulayness. Serre's criterion #bcite("Stacks031O") gives radicality.
]

Verified independently in Sage, for the signed encoding, at every $k=2,dots,6$: the Jacobian
recursion (@lem-jacrecursion) checked as a polynomial identity, not just at points, and every
witness confirmed to lie on $V(I_k)$ with $"rank" J_k = 2$
(#text(style: "italic")[code/referee\_radicality\_D\_check.sage]). The sharper claim --- that each
witness lies on *exactly* its intended component --- is confirmed by an independently-computed
primary decomposition at every $k=3,4,5,6$, which returns $k-1$ components in each case, in
agreement with @thm-componentcount; the $k=6$ decomposition takes some hours.

= The Primary Decomposition Theorem

Every ingredient is now in hand for the fully general statement -- component count (§5) and
radicality (§7) together, neither sufficient alone:

#theorem[Primary Decomposition Theorem][
  For every $k >= 2$, over any field of characteristic $eq.not 2$: $I_k$ has exactly $k-1$
  irreducible, radical, primary components, namely $P_2,dots,P_k$ of @def-primecomponents, and
  $ I_k = P_2 inter dots.c inter P_k $
  is an irredundant primary decomposition into $k-1$ primes.
] <thm-primarydecomp>

#proof[Proof of @thm-primarydecomp][
  Spelled out in full, combining the two independent halves proven above rather than left as a
  one-line conjunction. By @thm-radical, $I_k$ is radical, i.e. $I_k = sqrt(I_k)$. A standard fact
  about radical ideals in a Noetherian ring: a radical ideal equals the intersection of its own
  minimal primes, $I_k = inter_(P in "Min"(I_k)) P$ -- since $sqrt(I_k)$ is, by definition, the
  intersection of *all* primes containing $I_k$, and the minimal ones already suffice (every
  non-minimal prime containing $I_k$ contains some minimal one, hence is redundant in the
  intersection). @thm-componentcount identifies $"Min"(I_k)$ explicitly: exactly $k-1$ primes, one
  per block pattern $j=2,dots,k$, named $P_2,dots,P_k$ by @def-primecomponents. Substituting gives
  the displayed equation. Each $P_j$, being prime, is trivially its own primary-decomposition
  component ($P_j$-primary with associated prime $P_j$ itself) -- no separate argument for
  "primary" beyond "prime" is needed, and primality of each $P_j$ is exactly @lem-y2-irred (applied
  at the appropriate parameter, via @thm-radical's own induction). Irredundancy -- no $P_j$ can be
  omitted, i.e. no $P_j$ contains $inter_(i eq.not j) P_i$ -- is exactly @thm-componentcount's own
  no-containment conclusion (Proposition 17 and Proposition 18, applied at every level of that
  theorem's induction), not a fact needing any further proof here.
]

#remark[summary][
  @thm-codim (codimension 2), @thm-mingens (3 minimal generators), @thm-cm (Cohen-Macaulay), and
  @thm-radical (radical) together say exactly what a single bundled "$I_k$ has codimension 2, is
  radical, has exactly 3 minimal generators, and is Cohen-Macaulay" statement would -- now as four
  independently-proven results, each established at the point in this article where its actual
  dependencies (and no others) were available, rather than one claim proven in parts across
  several sections.
]

= Summary

For every $k >= 2$, over any field $FF$ of characteristic $eq.not 2$:

- $I_k$ has codimension 2 (@thm-codim), presented as the ideal of $2 times 2$ minors of an explicit
  $2 times 3$ matrix (@thm-determinantal) -- a genuine determinantal ideal, not merely
  determinantal-looking.
- $I_k$ has exactly 3 minimal generators (@thm-mingens), proven directly from linear independence,
  independent of the determinantal presentation.
- $R_k \/ I_k$ is Cohen-Macaulay (@thm-cm), from the determinantal presentation and classical
  Eagon-Northcott/Hilbert-Burch theory (@prop-detideal).
- $I_k$ is radical (@thm-radical), via Serre's criterion: Cohen-Macaulayness gives $S_1$
  (@lem-serre), and an explicit rank-2 Jacobian witness on every component gives $R_0$
  (@lem-witness-new, @lem-witness-inherited).
- $V(I_k)$ has exactly $k-1$ irreducible components (@thm-componentcount), each rational --
  in fact birational to an explicit affine parameter space (@prop-rational) -- and these assemble,
  via the two facts above, into the irredundant primary decomposition of the Primary Decomposition
  Theorem (@thm-primarydecomp): $I_k = P_2 inter dots.c inter P_k$.

Nothing above is conjectural or checked only at small $k$: every statement is proven for *every*
$k >= 2$, over an *arbitrary* field of the stated characteristic. The one running computational
thread -- Sage verification of the determinantal identity, the Jacobian recursion, and the witness
points, at $k=2,dots,6$ -- corroborates the general proofs; it is not a substitute for them anywhere
in this article.

#v(1.5em)
= References
#v(0.5em)

#bibentry("BrunsVetter1988")[W. Bruns, U. Vetter, #emph[Determinantal Rings], Lecture Notes in
  Mathematics 1327, Springer-Verlag, 1988. Out of print; freely available with Springer's
  permission at
  #link("https://www.home.uni-osnabrueck.de/wbruns/brunsw/detrings.pdf")[the first author's own
  page]. Theorem (2.7) and Theorem (16.36) verified directly against this copy, 2026-08-16.]
#bibentry("EagonNorthcott1962")[J.A. Eagon, D.G. Northcott, #emph[Ideals defined by matrices and a
  certain complex associated with them], Proc. Roy. Soc. London Ser. A 269(1337) (1962), 188-204.
  DOI: #link("https://doi.org/10.1098/rspa.1962.0170")[10.1098/rspa.1962.0170]. Closed access
  (confirmed via Unpaywall, 2026-08-16); superseded here by Bruns-Vetter's more general treatment.]
#bibentry("MotzkinTaussky1955")[T. Motzkin, O. Taussky, #emph[Pairs of matrices with property L.
  II], Trans. Amer. Math. Soc. 80 (1955), 387-401.]
#bibentry("Stacks00OS")[#emph[The Stacks Project], tag 00OS (dimension formula for finitely
  generated field extensions / equicodimensionality of affine domains), and equivalently
  D. Eisenbud, #emph[Commutative Algebra with a View Toward Algebraic Geometry], Springer GTM 150,
  1995, Cor. 13.4. Open access at
  #link("https://stacks.math.columbia.edu/tag/00OS")[stacks.math.columbia.edu/tag/00OS].]
#bibentry("Gerstenhaber1961")[M. Gerstenhaber, #emph[On dominance and varieties of commuting
  matrices], Ann. of Math. 73 (1961), 324-348. JSTOR-gated; not freely available.]
#bibentry("ArtinHochsterConjecture")[M. Artin, M. Hochster, attributed conjecture: for $I$ the ideal
  generated by the entries of $X Y - Y X$, $"Spec"(R\/I)$ is reduced and Cohen-Macaulay. No single
  dateable original publication found; stated as "Conjecture 1.1 (M. Artin, M. Hochster)" in
  Majidi-Zolbanin and Snapp below.]
#bibentry("MajidiZolbaninSnapp")[M. Majidi-Zolbanin, B. Snapp, #emph[A note on the variety of pairs
  of matrices whose product is symmetric], undated preprint. Open access at
  #link("https://people.math.osu.edu/snapp.14/SymmetrizingVariety.pdf")[people.math.osu.edu/
  snapp.14/SymmetrizingVariety.pdf].]
#bibentry("Chau2024")[T. Chau, #emph[The $F$-regularity of algebraic sets related to commutator
  matrices], J. Algebra 652 (2024), 52-66. DOI:
  #link("https://doi.org/10.1016/j.jalgebra.2024.04.008")[10.1016/j.jalgebra.2024.04.008]. Closed
  access (confirmed via Unpaywall); obtained via Jan's LiU institutional access.]
#bibentry("Hreinsdottir2005")[F. Hreinsdóttir, #emph[Conjectures on the ring of commuting matrices],
  arXiv:math/0501465. Open access at
  #link("https://arxiv.org/abs/math/0501465")[arxiv.org/abs/math/0501465].]
#bibentry("Knutson2003")[A. Knutson, #emph[Some Schemes Related to the Commuting Variety],
  arXiv:math/0306275 (to appear in J. Algebraic Geom.). Open access at
  #link("https://arxiv.org/abs/math/0306275")[arxiv.org/abs/math/0306275].]
#bibentry("Stacks031O")[#emph[The Stacks Project], tag 031O, Lemma 10.157.3 (Serre's criterion for
  reducedness): "Let $R$ be a Noetherian ring. The following are equivalent: (1) $R$ is reduced,
  and (2) $R$ has properties $(R_0)$ and $(S_1)$." Statement checked verbatim against the live
  source, 2026-08-30. Open access at
  #link("https://stacks.math.columbia.edu/tag/031O")[stacks.math.columbia.edu/tag/031O].]
#bibentry("Youcis2014")[A. Youcis, answer to "What can we say about the image of a regular map?",
  Mathematics Stack Exchange, question 731178, answer 732415, 2014. States both the
  point-set-topology fact that the continuous image of an irreducible space is irreducible, and the
  $(x,y) |-> (x,x y)$ non-closed-image example cited above. CC BY-SA 3.0. Open access at
  #link("https://math.stackexchange.com/questions/731178/what-can-we-say-about-the-image-of-a-regular-map")[math.stackexchange.com/questions/731178].]

#v(1.0em)
#text(size: 8.5pt, style: "italic")[
  Acknowledgements: the computational verification, literature search, and drafting of this
  article were carried out with substantial assistance from Claude (Anthropic), acting as an AI
  research assistant under the author's direction and review -- not as a co-author. Every claim
  above has been checked by the method stated -- symbolic/computational verification against the
  actual generating ideal, or citation checked directly against the cited primary source -- rather
  than presented on the strength of a pattern or a memory of the literature.
]
