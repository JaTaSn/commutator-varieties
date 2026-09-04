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
//
// NB: cosmos/fancy.typ:360 defines this as (theorem-counter.set-inherited-levels),
// so it targets the THEOREM counter and nothing else.  A frame built with its own
// counter is unaffected -- see the question environment below, which relies on that.
#set-inherited-levels(0)

// Question: a referenceable environment for the open question inside prob-char2
// (Jan, 2026-09-03: "break out the Question as its own environment, so that it can
// be referred to").
//
// It gets its OWN counter, deliberately, and this is the whole design decision.
// theorion's make-frame (core.typ:317) builds a fresh richer-counter keyed by the
// identifier when no `counter:` argument is given; every shared-counter environment
// in cosmos/fancy.typ opts IN by passing `counter: theorem-counter` explicitly.  So
// omitting it is the supported way to get an independent sequence, and the default
// inherited-levels of 0 makes that sequence globally continuous -- the same
// behaviour the line above buys for the theorem family, on a separate thread.
//
// Why not join the shared counter: inserting a numbered environment before
// thm-determinantal would renumber Theorem 6 -> 7, Example 7 -> 8, Lemma 8 -> 9, ...
// Remark 45 -> 46.  Those numbers are cited by name in LEAN/KCommuting/*.lean,
// LEAN/README.md, article/preamble.tex, tools/markers2env.py and in Jan's review
// annotations, which still have unapplied items keyed to them.  LEAN/README.md
// already carries a section apologising for the last renumbering; doing it again
// for a presentational change is not a trade worth making.
//
// MIRROR ANY CHANGE INTO tools/typst-stubs.typ (the two-copy rule -- see the
// signtwist note below for why).
#let (question-counter, question-box, question, show-question) = make-frame(
  "question",
  "Question",
  render: fancy-box.with(
    get-border-color: get-tertiary-border-color,
    get-body-color: get-tertiary-body-color,
    get-symbol: get-tertiary-symbol,
  ),
)
#show: show-question

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
  Stacks031R: 12,
  Tambour2000: 13,
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

// The sign twist of @thm-basic-identity, diag(-1,-1,1).  ONE definition, so the
// symbol is a one-line change here rather than a 90-site rewrite (Jan, 2026-09-03:
// "make it a macro with descriptive name so we can change it easily later").
//
// Renamed D -> S the same day: D collides visually with the Jacobian material of
// the later sections, and a bare D beside a Jacobian is asking for trouble.  S is
// for the *signature* of the Lorentzian form it encodes -- diag(-1,-1,1) is that
// form's matrix.
//
// MIRROR ANY CHANGE INTO tools/typst-stubs.typ.  tools/typ2tex.sh strips
// everything above the first "= " heading before pandoc sees the file, so a macro
// defined only here is invisible to the arXiv build -- the same two-copy rule the
// vek/FF macros above already live under.
#let signtwist(..a) = if a.pos().len() == 0 { $S$ } else { $S(#a.pos().at(0))$ }

// =============================================================================

#align(center)[
  #block(width: 90%)[
    #text(size: 15pt, weight: "bold")[
      The coordinate ring of the $k$-fold iterated commutator locus for $2 times 2$ matrices
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
    generators; $R_k \/ I_k$ is Cohen-Macaulay; and $I_k$ is radical. The last of these, together
    with an explicit component count resting on a non-containment argument, assembles into the
    *Primary Decomposition Theorem*: $I_k = P_2 inter dots.c inter P_k$ is an irredundant primary
    decomposition into exactly $k-1$ primes, following an explicit recursive block-involvement
    pattern. The proof identifies $I_k$ as the ideal of $2 times 2$ minors of an
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
standard lower-central-series convention for Lie algebras. This object arose out of

- a study of the corresponding formal word in the theory of fiber-counting of word-maps
  $pi: F_n -> G$, where $F_n$ is the free group on $n$ letters; in particular, after a close
  reading of Tambour's result #bcite("Tambour2000");
- a question in algebraic complexity theory -- how many scalar multiplications are needed to
  *compute* $[A_1,dots,A_k]$? -- which remains genuinely open for $k >= 3$ and which the author
  is presently investigating.

The one fact from that story needed here is purely algebraic, not complexity-theoretic: an explicit bilinear formula
for the ordinary $2 times 2$ commutator, chained across $k$ matrices, gives an explicit polynomial
parametrization of $[A_1,dots,A_k]$'s reduced coordinates (@def-wk below), and it is the *vanishing
locus* of this parametrization, as an algebraic variety and its coordinate ring, that is the actual
subject of this article. One naming note: one could alternatively refer to the coordinate ring of
the variety here studied as the "ring-of-k-commuting-2x2-matrices", using "commuting" in this
generalized iterated-commutator-vanishing sense. This means that $[A_1,dots,A_k]=0$, and not
literally "every pair of $A_1,dots,A_k$ commutes". The two concepts agree at $k=2$, where this
article's locus *is* the classical commuting variety; for $k >= 3$ the vanishing of the iterated
bracket is the *weaker* of the two conditions, so the locus studied here properly contains the
pairwise-commuting one.

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
and Snapp #bcite("MajidiZolbaninSnapp"). Chau #bcite("Chau2024") records a more specifically dated
1984 conjecture, attributed to Hochster alone and asking only for *reducedness*, about these same
commuting loci -- settled at $n=3$ by Thompson shortly afterwards, and open for $n >= 4$. Freyja
Hreinsdóttir's manuscript #bcite("Hreinsdottir2005"), building on her 1997 Stockholm doctoral
thesis under Jan-Erik Roos, attacks the Artin-Hochster conjecture case by case at $n=3,4$: syzygies, Betti
numbers, the canonical module, and a Koszul-dual structure theorem, verified computationally through
$n=7$ but proven in general only in these small cases. Knutson #bcite("Knutson2003") studies the
minimal primes of closely related schemes from a different angle. The state of play for the
*classical* commuting variety at the time of writing is therefore: Cohen-Macaulayness is

- settled by hand at $n <= 2$;
- settled by machine computation at $n=3$ and $n=4$, as both Majidi-Zolbanin and Snapp
  #bcite("MajidiZolbaninSnapp") and Hreinsdóttir #bcite("Hreinsdottir2005") record; and
- open for every $n >= 5$.

Reducedness is settled for $n <= 3$ and open for $n >= 4$ #bcite("Chau2024").

At $n=2$ specifically -- this article's $k=2$ base case -- the question is comparatively easy, and
is in effect answered again, as a special case, by @thm-cm below: $I_2$ (@def-wk) is literally the
ideal of the $n=2$ commuting variety, expressed in reduced (trace-removed) coordinates rather than
the full matrix-entry coordinates the classical literature typically uses. The genuinely new object
in this article is the *iterated* generalization to $k >= 3$: not the classical commuting variety at
all (see the naming note above), but a structurally analogous determinantal ideal, built by chaining
the same bilinear cross-product formula that governs the $n=2$ case. It is exactly the same *flavor*
of question the Artin-Hochster conjecture asks. Is this natural, geometrically meaningful ideal
Cohen-Macaulay? Is it reduced? Here those two questions are asked of a different,
recursively-defined family of ideals, and this article answers them completely and
unconditionally, for every $k >= 2$ (@thm-primarydecomp), rather than case by case or
conjecturally. In that sense the results below can be read as a fully worked
structural analogue of the still-open classical question, in a setting simple enough ($n=2$, but $k$
unbounded) to admit a complete answer.

= Notation

We present the notation used across more than one later result, in order of first appearance.
Symbols local to a single proof are omitted. Throughout, $FF$ denotes the ambient field; it is
fixed in @sec-setup to be of characteristic $eq.not 2$, and nothing in this section depends on
that.

*The following typographic convention is used throughout.* An *overline* denotes a *vector* -- an element of
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
    [$signtwist()$], [the sign twist $signtwist() = "diag"(-1,-1,1)$, used both as a map and as a matrix],
      [§3, Setup (@thm-basic-identity)],
    [$FF$], [ambient field, characteristic $eq.not 2$; $overline(FF)$ a fixed algebraic closure],
      [§3, opening paragraph; $overline(FF)$ at @rem-base-field],
    [$R_k$], [the polynomial ring $FF[vek(v)_1,dots,vek(v)_k]$], [@def-wk],
    [$I_k$], [the defining ideal, $I_k subset R_k$], [@def-wk],
    [$vek(w)_j$], [(a) the recursive vector of *polynomials*, an element of $R_j^3$ (its
      *evaluations* lie in $FF^3$); (b) as a polynomial map $AA^(3j) -> AA^3$],
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

= Setup: the signed encoding and the defining ideal <sec-setup>

Throughout, $FF$ is a field of characteristic $eq.not 2$, and all matrices, vectors and polynomial
rings are over $FF$ unless said otherwise. (Where exactly that characteristic hypothesis is spent
is a question in its own right, taken up in @prob-char2 at the end of this section; the displayed
examples below are computed over $QQ$, but nothing in the definitions is special to it.)

*Step 1: discard the scalar part.* Write $A = mat(a_11,a_12;a_21,a_22)$ as the sum of its scalar
part $("tr"(A)\/2) I$ and its traceless remainder
$ A_0 := A - ("tr"(A)\/2) I = mat(d_a\/2,a_12;a_21,-d_a\/2), quad d_a := a_11 - a_22 . $
Scalar matrices are central, so they never contribute to a commutator:
$ [c I, B] = c I B - B c I = c B - c B = 0 $
for every $B$ and every scalar $c$, hence $[A,B]=[A_0,B_0]$ identically -- no information relevant to *any* bracket is lost by discarding the
scalar part, so from here on only the traceless remainder matters.

*Step 2: encode the traceless remainder.* A traceless matrix $mat(x,y;z,-x)$ has three free entries.
Rather than reading them off directly ($x,y,z$ themselves -- shown in @rem-why-D below to be a
strictly *worse* choice, forcing a swap *and* two separate factors of 2), take
$ "enc"(A) := (a_11-a_22, a_12+a_21, a_12-a_21) in FF^3, $
the traceless $(1,1)$-entry doubled. (On the traceless part $a_22 = -a_11$, so
$d_a = a_11 - a_22 = 2 a_11$: the quantity $d_a$ of Step 1 is literally twice that entry.) The
remaining two coordinates are $A$'s two off-diagonal
entries replaced by their sum and difference. As with the naive encoding $"red"$ of @rem-why-D, no division
is needed to *compute* $"enc"$ -- only its inverse (recovering $a_12,a_21$ individually as
$(v_2+v_3)/2$ and $(v_2-v_3)/2$) needs $2$ invertible, which is the standing hypothesis the
article already carries, not a new one.


*Step 3: form the commutator.* Given traceless $A_0=mat(x,y;z,-x)$ and $B_0=mat(u,v;w,-u)$, the
ordinary matrix commutator $[A_0,B_0]=A_0 B_0-B_0 A_0$ is again traceless automatically, since
$"tr"(P Q)="tr"(Q P)$ for any $P,Q$ and therefore $"tr"([P,Q])=0$ always, so it is again encodable
by $"enc"$.


*Step 4: the encoded bracket is the cross product, up to one fixed sign twist.*

For the following theorem, the article's standing hypothesis $"char" FF eq.not 2$ is deliberately
not used: the identity holds over every commutative ring.

#theorem[the basic identity][
  For traceless $2 times 2$ matrices $A_0,B_0$ over $FF$, with no hypothesis on the characteristic,
  $ "enc"([A_0,B_0]) = signtwist("enc"(A_0) times "enc"(B_0)), quad signtwist() := mat(-1,0,0;0,-1,0;0,0,1). $
] <thm-basic-identity>

#proof[Proof of @thm-basic-identity][
  The proof is a direct computation, carried out symbolically over generic entries
  $a_11,dots,b_22$ rather than checked at sampled points, in
  #text(style: "italic")[code/verify\_lorentzian\_encoding\_identity.sage]. Both sides, expanded in
  the 8 free entries, agree term by term; they are displayed in full in @app-identity.

  Both sides are integer polynomials in those entries, so the identity descends to every commutative
  ring. It was also checked directly over $ZZ$ and, separately, over $FF_2$ --- where it still
  holds --- in #text(style: "italic")[code/referee\_round4\_setup\_determinantal\_check.sage],
  precisely to confirm that this step is not one of the places where $"char" FF eq.not 2$ is spent
  (@qst-char2).
]

#remark[why this particular twist, and not some other one][
  There are three concrete respects in which $signtwist()$ improves on the naive reshuffle $tau(a,b,c)=(b,a,2c)$ that
  the encoding $"red"(A):=(a_12,a_21,d_a)$ forces,
  each checked, not merely asserted:
  + *$signtwist()$ does not mix coordinates.* $tau$ swaps two of its three inputs; $signtwist()$ acts diagonally, one
    coordinate at a time. Consequence: $"red"$ would need a page-length remark ("why
    $vek(w)_j$ carries no outer $tau$") to justify that rescaling+swapping a generating set by an
    invertible linear map doesn't change the ideal generated. Here the analogous fact is immediate:
    *individually* negating two of three generators obviously leaves the ideal unchanged, generator
    by generator -- no swap to account for. (Still verified computationally, not merely asserted:
    $"ideal"(vek(w)_2) = "ideal"(signtwist() vek(w)_2)$, confirmed by direct Gröbner-basis equality in
    #text(style: "italic")[code/verify\_encoding\_gl3\_equivariance.sage]; the three generators are
    written out in @app-remark2.)
  + *$signtwist()$ is an involution; $tau$ is not.* $signtwist()^2 = I$ exactly (immediate from the diagonal entries
    being $plus.minus 1$), while $tau^2 = "diag"(1,1,4) eq.not I$.
  + *$signtwist()$ is not an arbitrary matrix that happens to work -- it is (up to a constant) the matrix of
    $frak(s l)_2$'s own Killing form, in these coordinates.* For traceless
    $A_0=mat(x,y;z,-x)$, $det(A_0) = -x^2-y z$, an *indefinite* quadratic form (never definite: $-y z
    = -((y+z)\/2)^2+((y-z)\/2)^2$ is a genuine difference of squares whenever $2 eq.not 0$). Checked
    directly: $-"enc"(A)_1^2 - "enc"(A)_2^2 + "enc"(A)_3^2 = 4 det(A_0)$, exactly (Sage, symbolic;
    @app-remark2).
    So $signtwist()$'s sign pattern *is* $det$'s own signature, read off in these coordinates -- not a
    bookkeeping accident. (Lie-theoretically: $frak(s l)_2(RR) tilde.equiv frak(s o)(2,1)$, the
    Lorentz algebra, not the compact $frak(s o)(3)$ one gets only after adjoining $i$ -- classical,
    not cited to a specific source here, the same way this article leaves certain folklore
    facts uncited rather than inventing a citation.) Over $RR$, or over any formally real field such
    as $QQ$, that sign cannot be removed by *any* invertible linear re-encoding: $-x^2-y^2+z^2$ is
    isotropic, vanishing at $(1,0,1)$, whereas $x^2+y^2+z^2$ is anisotropic, since over a formally
    real field a sum of squares vanishes only when every term does -- and isotropy is manifestly
    preserved by invertible linear substitution. (This is the content of Sylvester's law of inertia
    in the case at hand; the law itself is a statement about $RR$.) In that precise sense $signtwist()$'s
    single-sign twist is already the simplest one achievable, not merely simpler than $tau$ by luck.

    Over a general field the claim genuinely fails, and it fails already in the smallest interesting
    case, so the restriction above is not idle caution: over $FF_3$, where $-1$ is *not* a square,
    $"diag"(-1,-1,1)$ is nevertheless congruent to the identity form, via
    $T = mat(0,0,1;1,1,0;1,2,0)$ (of determinant $1$) with
    $T^tack.b T = "diag"(2,2,1) = "diag"(-1,-1,1)$. So "$-1$ is not a square" is *not* the right
    criterion; formal reality is.
  The "obvious" un-permuted reading of the matrix entries, $"raw"(A) := (x,y,z)$, is worse than
  either encoding: the twist it forces is $"swap"(2,3) dot "diag"(1,2,2)$ -- a coordinate swap
  *and* two separate factors of $2$. A different escape, adjoining $i$ to get a literal untwisted
  cross product ($frak(s u)(2) tilde.equiv frak(s o)(3)$ in place of $frak(s o)(2,1)$), is a genuine
  alternative but a strictly narrower one, since it constrains the field.
] <rem-why-D>


#definition[reduced iterated commutator, signed encoding][
  $ vek(w)_2 := vek(v)_1 times vek(v)_2, quad vek(w)_j := signtwist(vek(w)_(j-1)) times vek(v)_j quad (j=3,dots,k). $
  Let $R_k := FF[vek(v)_1,dots,vek(v)_k]$ ($vek(v)_i in FF^3$, $3k$ variables) and $I_k subset R_k$ the ideal
  generated by the three components of $vek(w)_k$ -- the ideal cutting out $[A_1,dots,A_k]=0$ in
  reduced coordinates. Two deliberate understatements are worth flagging. First, $I_k$ is at this point only the
  *generated* ideal; that it is also the full vanishing ideal of that locus is @thm-radical, in §7
  below, and is not to be assumed before then. Second, the encoded bracket is strictly
  $signtwist(vek(w)_k)$, not $vek(w)_k$ -- but $signtwist()$ merely negates two of three coordinates, so the two
  triples generate the same ideal, and it is cleaner to carry the untwisted one.
] <def-wk>

To spell out exactly what this means: "$R_k := FF[vek(v)_1,dots,vek(v)_k]$" is shorthand for *the
polynomial ring in the $3k$ scalar variables $v_(i,j)$ ($i=1,dots,k$, $j=1,2,3$)*, grouped into $k$
blocks of 3 -- *not* a ring with $k$ vector-valued generators (a polynomial ring's generators are
always scalars). At $k=2$, written out in full:
$ R_2 = FF[v_(1,1),v_(1,2),v_(1,3),v_(2,1),v_(2,2),v_(2,3)], $
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
  Everything below was computed directly
  (#text(style: "italic")[code/compute\_signed\_encoding\_examples.sage]) rather than derived by
  hand. At $k=2$, the three components of $vek(w)_2 = vek(v)_1 times vek(v)_2$:
  $ v_(1,2)v_(2,3)-v_(1,3)v_(2,2), quad v_(1,3)v_(2,1)-v_(1,1)v_(2,3), quad
    v_(1,1)v_(2,2)-v_(1,2)v_(2,1). $
  (This is what $"red"$ would give at this stage too -- the two encodings agree exactly at the very
  first stage, since neither $tau$ nor $signtwist()$ is applied yet.) At $k=3$, the three components of
  $vek(w)_3 = signtwist(vek(w)_2) times vek(v)_3$ -- now with *every coefficient equal to $plus.minus 1$*, no
  factor of 2 anywhere, unlike the $tau$-twisted $vek(w)_3$ that $"red"$ produces:
  $ v_(1,2)v_(2,1)v_(3,2) - v_(1,1)v_(2,2)v_(3,2) - v_(1,3)v_(2,1)v_(3,3) + v_(1,1)v_(2,3)v_(3,3), $
  $ -v_(1,2)v_(2,1)v_(3,1) + v_(1,1)v_(2,2)v_(3,1) - v_(1,3)v_(2,2)v_(3,3) + v_(1,2)v_(2,3)v_(3,3), $
  $ v_(1,3)v_(2,1)v_(3,1) - v_(1,1)v_(2,3)v_(3,1) + v_(1,3)v_(2,2)v_(3,2) - v_(1,2)v_(2,3)v_(3,2), $
  and $I_3 := (w_(3,1),w_(3,2),w_(3,3))$. At $k=4$, $vek(w)_4 = signtwist(vek(w)_3) times vek(v)_4$: again every
  coefficient is $plus.minus 1$; the first component of $vek(w)_4$ is
  $ -v_(1,3)v_(2,1)v_(3,1)v_(4,2) + v_(1,1)v_(2,3)v_(3,1)v_(4,2) - v_(1,3)v_(2,2)v_(3,2)v_(4,2)
    + v_(1,2)v_(2,3)v_(3,2)v_(4,2) $
  $ + v_(1,2)v_(2,1)v_(3,1)v_(4,3) - v_(1,1)v_(2,2)v_(3,1)v_(4,3) + v_(1,3)v_(2,2)v_(3,3)v_(4,3)
    - v_(1,2)v_(2,3)v_(3,3)v_(4,3), $
  the other two of the same shape (omitted for space; all three components of $vek(w)_4$, and
  $I_4:=(w_(4,1),w_(4,2),w_(4,3))$, in
  #text(style: "italic")[code/compute\_signed\_encoding\_examples.sage]'s output). The same data at
  $k=6$, where the generators reach 32 terms apiece and the $plus.minus 1$ pattern is still
  unbroken, is in @app-i6.
] <ex-wk-signed>

The displayed examples above were computed over $QQ$, but every result below holds over the
arbitrary field $FF$ of characteristic $eq.not 2$ fixed at the start of this section. Where that
hypothesis is actually spent is not where one first expects, and the answer leaves a question we
are happy to hand on:

#problem[characteristic 2][
  The hypothesis is *not* spent on $signtwist()$. Since $det signtwist() = 1$, the twist is invertible over every
  field, and @rem-why-D's "an invertible change of generators does not change the ideal" needs no
  hypothesis whatsoever. Under the naive reshuffle it would: $det tau = -2$, so $tau$ is singular
  in characteristic 2 precisely.

  It is spent in *Step 1*, earlier than Step 2's division by $2$ and more seriously. In
  characteristic 2 one has $"tr"(c I) = 2c = 0$, so *scalar matrices are themselves traceless*.
  The splitting $A = ("tr"(A)\/2)I + A_0$ then has no meaning at all: the scalars do not sit
  beside a complement, they sit *inside* the traceless matrices.

  The bracket is unbothered --- scalars are central in every characteristic --- so $[dot,dot]$
  still descends to the three-dimensional quotient $frak(g l)_2 \/ (FF dot I)$. Whether the rest of
  the article descends with it is @qst-char2 below.
] <prob-char2>

#question[a twisted-cross-product model in characteristic 2][
  Over a field of characteristic 2, is there a linear isomorphism
  $frak(g l)_2 \/ (FF dot I) tilde.equiv FF^3$ carrying the induced bracket to a twisted cross
  product $E(dot times dot)$ for some invertible $E$? And if so, do @thm-codim, @thm-mingens,
  @thm-cm, @thm-radical and @thm-primarydecomp hold verbatim?
] <qst-char2>

What makes @qst-char2 more than idle curiosity: *every polynomial displayed in @ex-wk-signed has
coefficients $plus.minus 1$ only*. No $2$ appears anywhere in the output. Whatever the
obstruction is, it lives entirely in the setup and not in the ideal --- which is exactly the
situation in which a different setup might dissolve it.

*Computational evidence, bearing on the second half of @qst-char2 only.* Nothing in @def-wk's
recursion needs a characteristic hypothesis: $vek(w)_2 = vek(v)_1 times vek(v)_2$ and
$vek(w)_j = signtwist(vek(w)_(j-1)) times vek(v)_j$ define an ideal $I_k subset R_k$ over *any* field.
Taking that recursion as the definition and running the four results in characteristic 2 anyway,
for $k=2,dots,5$ over $FF_2$ and $FF_4$: the codimension is $2$, the three generators are
linearly independent over the base field, $I_k$ is radical, and $"pd"(R_k \/ I_k) = 2$, so
$R_k \/ I_k$ is Cohen-Macaulay --- in every case, with no deviation whatever from the
characteristic-zero behaviour (#text(style: "italic")[code/verify\_over\_finite\_fields.sage] and
#text(style: "italic")[code/verify\_cm\_over\_finite\_fields.m2]; the same runs also cover
$FF_3, FF_5, FF_7, FF_9$ and $QQ$). The *conclusions*, then, appear to survive characteristic 2
untouched --- which is evidence for the paragraph above, not against it.

What no computation of this kind can settle is the *first* half of @qst-char2: whether a
twisted-cross-product model of $frak(g l)_2 \/ (FF dot I)$ exists there at all, so that this
$I_k$ is once again the ideal of an iterated-commutator locus rather than merely a recursion that
happens to go on behaving well. That is where the exercise lies.


= The determinantal structure and the generator count

#theorem[determinantal structure][
  For $k >= 3$, $I_k$ is the ideal of $2 times 2$ minors of the $2 times 3$ matrix
  $ mat(signtwist(vek(w)_(k-1)); vek(v)_k), $
  i.e. $V(I_k)$ is the preimage, under $(vek(v)_1,dots,vek(v)_k) |-> mat(signtwist(vek(w)_(k-1)(vek(v)_1,dots,vek(v)_(k-1)));
  vek(v)_k)$, of the classical rank-$<=1$ determinantal variety of $2 times 3$ matrices. (At $k=2$ the
  same statement holds with $signtwist(vek(w)_(k-1))$ replaced by $vek(v)_1$ itself, matching @def-wk's base
  case $vek(w)_2 = vek(v)_1 times vek(v)_2$ directly.)
] <thm-determinantal>

#proof[Proof of @thm-determinantal][
  The claim is immediate from two facts taken together. The three components of a cross product
  $a times b$ are, up to sign, the $2 times 2$ minors of the $2 times 3$ matrix with rows $a$ and
  $b$; and @def-wk's recursion builds $vek(w)_k$ from exactly such a cross product. The statement
  was also checked independently at $k=2,dots,6$ in
  #text(style: "italic")[code/verify\_determinantal\_structure\_all\_k.sage], in two separate ways.
  First, $I_k$ and the ideal of the displayed minors are shown equal by reducing each ideal's
  generators to zero against the other's Gröbner basis, in *both* directions, rather than by
  containment one way. Second -- and this is what makes "independent" mean something here -- the
  recursion itself is checked against honest $2 times 2$ matrix multiplication: the $A_i$ are
  reconstructed from their $"enc"$-coordinates, the iterated commutator is formed by repeated
  matrix products, and the result encoded and compared against $signtwist(vek(w)_k)$. The two routes share
  no code. The underlying
  polynomial identity $"enc"([A,B]) = signtwist("enc"(A) times "enc"(B))$ of @thm-basic-identity makes this a two-line induction
  valid for *every* $k$, not merely a pattern checked at small $k$
  (#text(style: "italic")[code/verify\_lorentzian\_encoding\_identity.sage]).
]

This theorem is the engine behind the geometric results of §5: $R_k \/ I_k$ is not merely
*determinantal-looking*, it is literally an iterated extension of the coordinate ring of a
classical determinantal variety.

#example[the $2 times 3$ matrix of @thm-determinantal, for $k=2,3,4$][
  At $k=2$: $ mat(vek(v)_1; vek(v)_2) = mat(v_(1,1), v_(1,2), v_(1,3); v_(2,1), v_(2,2), v_(2,3)). $
  At $k=3$, the first row is $signtwist(vek(w)_2) = (-w_(2,1), -w_(2,2), w_(2,3))$ where
  $vek(w)_2 = vek(v)_1 times vek(v)_2$ is as in the previous example, giving
  $ mat(signtwist(vek(w)_2); vek(v)_3) = mat(
      v_(1,3)v_(2,2)-v_(1,2)v_(2,3), -v_(1,3)v_(2,1)+v_(1,1)v_(2,3), -v_(1,2)v_(2,1)+v_(1,1)v_(2,2);
      v_(3,1), v_(3,2), v_(3,3)
    ). $
  At $k=4$ the first row is $signtwist(vek(w)_3)$, whose three entries are cubic with four terms
  each. Naming them $A$, $B$, $C$ keeps the matrix legible:
  $ mat(A, B, C; v_(4,1), v_(4,2), v_(4,3)), $
  where
  $ A &= -v_(1,2)v_(2,1)v_(3,2) + v_(1,1)v_(2,2)v_(3,2) + v_(1,3)v_(2,1)v_(3,3) - v_(1,1)v_(2,3)v_(3,3), \
    B &= v_(1,2)v_(2,1)v_(3,1) - v_(1,1)v_(2,2)v_(3,1) + v_(1,3)v_(2,2)v_(3,3) - v_(1,2)v_(2,3)v_(3,3), \
    C &= v_(1,3)v_(2,1)v_(3,1) - v_(1,1)v_(2,3)v_(3,1) + v_(1,3)v_(2,2)v_(3,2) - v_(1,2)v_(2,3)v_(3,2). $
  The row degree grows by one at each step ($1,2,3,dots$), while the second row is always the fresh,
  free vector $vek(v)_k$ -- exactly the "one fixed complicated row, one free row" shape
  @prop-detideal needs.
]

#lemma[non-degeneracy, with an explicit witness][
  For every $j >= 2$, the polynomial map $vek(w)_j : AA^(3j) -> AA^3$ is not identically zero.
  Concretely, the point
  $ p^((j)) := (e_1, e_2, underbrace(e_1\, dots\, e_1, j-2)) in AA^(3j) $
  satisfies $vek(w)_j (p^((j))) eq.not 0$; explicitly $vek(w)_j (p^((j))) = e_3$ for $j$ even and
  $e_2$ for $j$ odd. Hence $U_j := {p in AA^(3j) : vek(w)_j (p) eq.not 0}$ is a nonempty
  Zariski-open subset of $AA^(3j)$.
] <lem-nondeg>

#proof[Proof of @lem-nondeg][
  The induction is on $j$, and it carries more than the statement "some point survives": it carries
  a *named* point, because @lem-witness-new later needs one rather than a mere existence claim.

  *Base case $j=2$.* By @def-wk, $vek(w)_2 = vek(v)_1 times vek(v)_2$, so
  $vek(w)_2(e_1,e_2) = e_1 times e_2 = e_3 eq.not 0$. Thus $p^((2)) = (e_1,e_2)$ works.

  *Induction step.* Let $j >= 3$ and suppose $p in AA^(3(j-1))$ satisfies
  $c := vek(w)_(j-1)(p) eq.not 0$. The step rests on three observations, taken in order:

  + $signtwist(c) eq.not 0$, since $det signtwist() = 1$ makes $signtwist()$ invertible over every
    field (@rem-why-D), so it kills no nonzero vector.
  + Therefore $FF dot signtwist(c)$ is a *line* in $FF^3$. The three vectors $e_1,e_2,e_3$ span
    $FF^3$, and a line contains at most one of them; so at least two indices $i$ have
    $e_i in.not FF dot signtwist(c)$. Fix any such $i$.
  + A cross product vanishes exactly on linearly dependent pairs --- $ker [u]_times = FF u$ for
    $u eq.not 0$, the computation carried out in the proof of @lem-witness-inherited --- so
    $signtwist(c) times e_i eq.not 0$.

  By @def-wk, $vek(w)_j (p, e_i) = signtwist(vek(w)_(j-1)(p)) times e_i = signtwist(c) times e_i eq.not 0$.
  (The twist falls on $c$ rather than on the result because that is where @def-wk's recursion puts
  it.) So $vek(w)_j$ is not identically zero, and appending $e_i$ to a witness at level $j-1$ gives
  one at level $j$.

  *The witness in closed form.* Running the step from $p^((2)) = (e_1,e_2)$ and taking the least
  admissible $i$ each time, the choice is $i=1$ at *every* level: $vek(w)_2 = e_3$ and
  $signtwist(e_3) = e_3$, which is not proportional to $e_1$, giving $vek(w)_3 = e_3 times e_1 = e_2$;
  then $signtwist(e_2) = -e_2$, again not proportional to $e_1$, giving
  $vek(w)_4 = (-e_2) times e_1 = e_3$; and the pair $(e_3, e_2)$ now repeats. Hence the closed form
  in the statement, and every coordinate of both the witness and its image lies in
  $\{0, plus.minus 1\}$. This has been verified for $j=2,dots,8$, by two independent evaluations
  per level, in #text(style: "italic")[code/verify\_nondegeneracy\_witness.sage], and the results
  are tabulated in @app-witness.

  *Openness.* $U_j$ is the complement of the Zariski-closed set $V(w_(j,1),w_(j,2),w_(j,3))$, hence
  open; it is nonempty because $p^((j))$ lies in it.
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
  let $c in FF^3$ satisfy $c dot vek(w)_k = 0$. Writing $a := signtwist(vek(w)_(k-1))$, the scalar triple
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
  Since $signtwist()$ is invertible, the components of $vek(w)_(k-1) = signtwist()^(-1)(a)$ are then linearly dependent
  too, contradicting the induction hypothesis. Hence $c = 0$.

  Corroborated computationally: the coefficient matrix has rank 3 at $k=2,dots,6$
  (#text(style: "italic")[code/verify\_generator\_independence.sage]); the full table is in
  @app-independence.
]

#remark[why non-degeneracy is not enough here][
  It is tempting to argue instead that a constant relation would force $signtwist(vek(w)_(k-1))$ to be a
  *constant vector*, and to rule that out by @lem-nondeg. That argument is not valid. The relation
  forces only $c times signtwist(vek(w)_(k-1)) = 0$, which makes the components of $signtwist(vek(w)_(k-1))$
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
  i.e. $C_1 = f(X)$, which is not proper. Hence $f(X)$ is irreducible. *Closure.* If $A subset.eq Y$ is
  irreducible and $overline(A) = C_1 union C_2$ with $C_1,C_2$ closed in $Y$, then
  $A = (A inter C_1) union (A inter C_2)$; irreducibility of $A$ forces, say,
  $A subset.eq C_1$; since $C_1$ is closed, $overline(A) subset.eq C_1$, and combined with
  $C_1 subset.eq overline(A)$, $C_1 = overline(A)$, not proper. Apply both parts with
  $A := f(X)$.
]

This is purely topological -- continuity of $f$ is the only hypothesis used, nothing about $f$
being a polynomial map or morphism of varieties #bcite("Youcis2014").

#definition[the strata $Y_1$, $Y_2$][
  For $k >= 3$, write $pi$ for the projection *forgetting $vek(v)_k$*,
  $ pi : AA^(3k) -> AA^(3(k-1)), quad pi(vek(v)_1,dots,vek(v)_k) := (vek(v)_1,dots,vek(v)_(k-1)), $
  and $Phi$ for the map
  $ Phi : AA^(3(k-1)) times AA^1 -> AA^(3k), quad Phi(p,lambda) := (p, lambda signtwist(vek(w)_(k-1)(p))). $
  Define two subsets of $AA^(3k)$:
  $ Y_1 := V(I_(k-1)) times AA^3, quad Y_2 := overline(Phi(AA^(3k-2))). $
  Here $Y_1$ is the locus where the previous bracket already vanishes, with $vek(v)_k$ completely
  free, while $Y_2$ is the closure of the locus swept out as $vek(v)_k$ ranges over scalar
  multiples of $signtwist(vek(w)_(k-1)(p))$, over all $p in AA^(3(k-1))$. At $k=2$ there is no
  "previous bracket" to chain
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
    @prop-y2-not-in-y1 and @prop-y1-not-in-y2 rule out either containing the other):
    $Phi(p,0)=(p,0)$ for *every* $p$, so
    the whole zero-section $\{(p,0)\}$ lies in $Y_2$, and its intersection with $Y_1$ is
    $V(I_(k-1)) times \{0\}$, of dimension $3k-5$ -- properly smaller than either stratum's own
    dimension $3k-2$.]
) <fig-phi-y2>

#lemma[$Y_2$ is irreducible][
  For $k >= 3$: $Y_2$ (@def-y1y2) is irreducible, and in fact its defining ideal (the graph ideal
  of $Phi$ with $lambda$ eliminated) is prime.
] <lem-y2-irred>

#proof[Proof of @lem-y2-irred][
  The map $Phi$ is polynomial, hence continuous for the Zariski topology, since preimages of
  Zariski-closed sets under a polynomial map are again Zariski-closed by substitution. Its domain
  $AA^(3k-2)$ is irreducible, because the polynomial ring over $FF$ is a domain and so its zero
  ideal is prime. @lem-top-irred then gives $Y_2$ irreducible directly. Primality of the elimination ideal
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
  -- and these three repay a careful reading, because their shape is not the one the
  parametrization first suggests. *All three* are linear in the new block $vek(v)_3$; what separates
  them is total degree, $2,2,3$. The two quadratic ones are, up to sign, the incidence conditions
  $ vek(v)_1 dot signtwist(vek(v)_3) = 0, quad vek(v)_2 dot signtwist(vek(v)_3) = 0. $
  These are *consequences* of the proportionality $vek(v)_3 prop signtwist(vek(w)_2)$, not its components:
  substituting $vek(v)_3 = lambda signtwist(vek(w)_2)$ and using $signtwist()^2 = I$ turns them into
  $lambda (vek(v)_i dot vek(w)_2) = 0$, which holds because $vek(w)_2 = vek(v)_1 times vek(v)_2$ is
  orthogonal to both of its factors. (The components of $vek(v)_3 times signtwist(vek(w)_2)$, which *are* the
  proportionality condition, are cubic, and none of them appears above.) The third generator, of
  degree 3, is verbatim the first component of $vek(w)_3$. Note that no generator of this ideal
  could avoid $vek(v)_3$ altogether: $Y_2$ projects dominantly onto $AA^6$, so the elimination ideal
  meets $R_2$ in $0$. *This ideal is a proper factor of $I_3$, not
  equal to it* -- $I_3$ is the intersection of this ideal with a second prime (the "$Y_1$" piece,
  where the $k=2$ bracket already vanishes); see the component-count example after @thm-componentcount
  below, where this exact ideal reappears as one of $I_3$'s two primary components. At $k=4$ the
  same pattern repeats one degree higher, the three generators now having degrees $2,3,4$ and again
  all three linear in the new block $vek(v)_4$. The first two are once more incidence conditions
  forced by $vek(w)_3 perp signtwist(vek(w)_2), vek(v)_3$, namely $vek(v)_3 dot signtwist(vek(v)_4) = 0$ and
  $vek(w)_2 dot vek(v)_4 = 0$; the third is the negative of $vek(w)_4$'s first component:
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
  A polynomial map's image need not itself be closed. The standard example is
  $AA^2 -> AA^2$, $(x,y) |-> (x,x y)$, whose image is not even locally closed. It is
  *constructible*, a finite union of locally closed sets, by Chevalley's theorem -- a result with no
  purely topological analogue for general continuous maps #bcite("Youcis2014").

  None of this troubles $Y_2$, for two reasons. First, @def-y1y2 *defines* $Y_2$ as
  $overline(Phi(dot))$ from the outset. Second, the decomposition $V(I_k) = Y_1 union Y_2$ used in
  @thm-codim's proof below comes from a direct case split rather than from taking closures and
  hoping. Take a point $(p,vek(v)_k) in V(I_k)$. Either $signtwist(vek(w)_(k-1)(p))=0$, which puts
  it in $Y_1$ directly; or $vek(v)_k = lambda signtwist(vek(w)_(k-1)(p))$ for some $lambda$, in
  which case $(p,vek(v)_k) = Phi(p,lambda)$ is *literally* a value of $Phi$ rather than merely a
  limit point, and so lies in $Y_2$ with no appeal to closure at all.

  The reverse containment
  $Y_1 union Y_2 subset.eq V(I_k)$ needs only that $Phi(dot) subset.eq V(I_k)$ (a cross product of
  a vector with itself vanishes: $signtwist(vek(w)_(k-1)) times (lambda signtwist(vek(w)_(k-1))) = 0$ identically)
  together with $V(I_k)$ already being closed, automatic since it is a vanishing locus by
  definition. So the theorem never needs "the image of $Phi$ is closed" -- only that it is
  contained in the already-closed $V(I_k)$, which is immediate.
] <rem-closure-suffices>

#lemma[dimension of $Y_2$, and where it lives][
  With $Y_2$ as in @lem-y2-irred and $U_(k-1)$ as in @lem-nondeg: $dim Y_2 = 3k-2$, and $Y_2$ meets
  $pi^(-1)(U_(k-1))$ nonemptily, where $pi$ is the projection of @def-y1y2, forgetting $vek(v)_k$.
] <lem-y2-dim>

#proof[Proof of @lem-y2-dim][
  The projection $pi : AA^(3k) -> AA^(3(k-1))$ discards the last block, so that
  $pi(vek(v)_1,dots,vek(v)_k) = (vek(v)_1,dots,vek(v)_(k-1))$. Hence $pi^(-1)(U_(k-1)) = U_(k-1) times AA^3$, the set of points
  whose *first* $k-1$ blocks lie in $U_(k-1)$ and whose $vek(v)_k$ is completely unconstrained. Over
  $U_(k-1)$, $Phi$ is injective. Both $p$ and $lambda$ can be recovered from $Phi(p,lambda)$: $p$
  directly, and $lambda$ by dividing any nonzero coordinate of $vek(v)_k=lambda signtwist(vek(w)_(k-1)(p))$
  by the corresponding coordinate of $signtwist(vek(w)_(k-1)(p))$; this division is well-defined since
  $signtwist(vek(w)_(k-1)(p)) eq.not 0$ on $U_(k-1)$. Injectivity gives
  $dim Y_2 = dim (U_(k-1) times AA^1) = 3(k-1)+1 = 3k-2$. Since $U_(k-1)$ is nonempty by
  @lem-nondeg, $Phi(U_(k-1) times {1})$ is a nonempty subset of $Y_2 inter pi^(-1)(U_(k-1))$.
]

#theorem[$I_k$ has codimension 2][
  For every $k >= 2$: $dim V(I_k) = 3k-2$, i.e. $"codim"(I_k) = 2$.
] <thm-codim>

#proof[Proof of @thm-codim][
  The proof is by induction on $k$. *Base case $k=2$*: $V(I_2)$ is the rank-$<=1$ locus of a $2 times 3$ matrix
  with independent-indeterminate entries. Its dimension is the standard $4 = 3 dot 2 - 2$ for a
  generic determinantal variety of this shape: the classical codimension formula for the rank-$<= t$
  locus of a generic $m times n$ matrix gives $(m-t)(n-t) = 1 dot 2 = 2$ here
  #bcite("BrunsVetter1988"), and the same value falls out of viewing $V(I_2)$ as the affine cone
  over the Segre embedding $PP^1 times PP^2 arrow.hook PP^5$, of dimension $1+2+1=4$. The value is
  confirmed directly by Gröbner-basis computation as well (@ex-dim-codim). *Inductive step*: by
  @thm-determinantal, and since $a times b = 0$ if and only if $a,b$ are linearly dependent,
  $V(I_k) = Y_1 union Y_2$ (@def-y1y2). The locus $signtwist(vek(w)_(k-1))=0$ gives $Y_1$, with $vek(v)_k$
  unconstrained; the locus $signtwist(vek(w)_(k-1)) eq.not 0$ with $vek(v)_k$ proportional to it gives a
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
] <ex-dim-codim>

#proposition[$Y_2 subset.not.eq Y_1$][
  With $Y_1, Y_2$ as in the proof of @thm-codim: $Y_2 subset.not.eq Y_1$.
] <prop-y2-not-in-y1>

#proof[Proof of @prop-y2-not-in-y1][
  Pick $p in U_(k-1)$ (@lem-nondeg); then $Phi(p,0)=(p,0) in Y_2$ but $vek(w)_(k-1)(p) eq.not 0$ puts
  $(p,0) in.not Y_1$.
]

#proposition[no component of $Y_1$ lies in $Y_2$][
  Let $Z$ be an irreducible component of $V(I_(k-1))$ *of dimension $3(k-1)-2$*. Then
  $Z times AA^3 subset.eq.not Y_2$.

  The dimension hypothesis is stated rather than cited. @thm-codim gives the dimension of the
  *union* $V(I_(k-1))$, which does not by itself say that every component attains it; the
  per-component statement is part of @thm-componentcount, and this proposition is used inside that
  theorem's own induction, where it is available as the inductive hypothesis at level $k-1$.
] <prop-y1-not-in-y2>

#proof[Proof of @prop-y1-not-in-y2][
  Both $Z times AA^3$ and $Y_2$ are irreducible: $Y_2$ by @lem-y2-irred, and $Z times AA^3$ because
  a product of irreducible varieties is irreducible ($Z$ is irreducible by hypothesis, and $AA^3$
  trivially is). Both have the *same* dimension $3k-2$: $Z times AA^3$ by the hypothesis on $Z$,
  and $Y_2$ by @lem-y2-dim. Containment
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
  The proof is by induction on $k$. *Base case $k=2$*: the rank-$<=1$ locus of a generic $2 times 3$ matrix is
  irreducible -- the affine cone over the Segre embedding $PP^1 times PP^2 arrow.hook PP^5$,
  equivalently the Motzkin-Taussky #bcite("MotzkinTaussky1955") irreducibility of the $2 times 2$
  commuting variety -- so exactly 1 component, matching $k-1=1$. *Step*: $V(I_k) = Y_1 union Y_2$
  as in @thm-codim's proof. By the inductive hypothesis --- this theorem at level $k-1$, which is
  where the per-component dimension comes from --- $V(I_(k-1))$ has $k-2$ irreducible components,
  each of dimension $3(k-1)-2$, none contained in another; crossing with $AA^3$ makes them $Y_1$'s
  components, each of dimension $3k-2$. That is exactly the hypothesis @prop-y1-not-in-y2 asks for,
  so it and @prop-y2-not-in-y1 together rule out containment between $Y_2$ and any of them, in
  either direction. A finite
  union of irreducible closed sets with no containments is irredundant, giving exactly
  $(k-2)+1=k-1$ components.
]

This gives $I_k$'s minimal primes and their count, but not yet that $I_k$ is radical (so not yet
that these are literally the components of a *primary* decomposition of $I_k$ itself, as opposed to
of $sqrt(I_k)$) -- that is closed in §7, after Cohen-Macaulayness is available.

#definition[the components $P_j$][
  For $k >= 2$ and $j=2,dots,k$, let $Phi_j$ be @def-y1y2's map $Phi$ run at parameter $j$ (with
  the base convention $Phi_2(p,lambda) := (p,lambda p)$), and let
  $ Psi_j : AA^(3(j-1)) times AA^1 times AA^(3(k-j)) -> AA^(3k), quad
    (p,lambda,q) |-> (Phi_(j)(p,lambda), q) $
  be $Phi_j$ with the remaining blocks $vek(v)_(j+1),dots,vek(v)_k$ carried along untouched. Since
  $Psi_j$ is a polynomial map it *is*, read backwards, a homomorphism of $FF$-algebras
  $ phi_j : R_k -> FF[p,lambda,q] = FF[t_1,dots,t_(3k-2)], $
  sending each variable $v_(i,c)$ to the corresponding coordinate polynomial of $Psi_j$. Define
  $ P_j := ker phi_j subset R_k. $
  Two consequences come for free. First, each $P_j$ is *prime*, being the kernel of a
  homomorphism into a domain -- for every $j$ including $j=2$, with no case distinction and no
  appeal to @lem-y2-irred, which is stated only for $k >= 3$. Second, $P_j$ does not depend on
  which $k >= j$ it
  is viewed inside of: enlarging $k$ appends free variables to source and target alike.

  *Why the kernel rather than the vanishing ideal.* It is tempting to define $P_j$ as the vanishing
  ideal of the $j$-th component of $V(I_k)$, and over $overline(FF)$ the two agree --
  @prop-rational identifies that component as the closure of $Psi_j$'s image. But over a *finite*
  field "vanishing ideal" is the wrong notion outright: $V(I_k)(FF)$ is then a finite set of
  points, and $x^q - x$ vanishes on all of $AA^1(FF_q)$ without being the zero polynomial. The
  kernel is the right object over every field at once, is well defined with no convention attached,
  and is what makes the base-change statement in @rem-base-field an identity rather than a
  coincidence.
] <def-primecomponents>

#example[a suitable point of $Y_2$, concretely, at $k=3$][
  It is worth having a single explicit point, and not only the defining ideal of
  @ex-components-k3 below. Take $vek(v)_1=(1,0,0)$ and $vek(v)_2=(0,1,0)$, so that
  $vek(v)_1 in U_2$ by @lem-nondeg, giving
  $vek(w)_2=vek(v)_1 times vek(v)_2=(0,0,1)$ and $signtwist(vek(w)_2)=(0,0,1)$. Taking $lambda=1$ in
  @def-y1y2's $Phi$, i.e. $vek(v)_3 := signtwist(vek(w)_2)=(0,0,1)$, gives the point
  $ (vek(v)_1,vek(v)_2,vek(v)_3) = ((1,0,0),(0,1,0),(0,0,1)) in Y_2 subset AA^9. $
  One checks this directly: $vek(w)_3 = signtwist(vek(w)_2) times vek(v)_3 = (0,0,1) times (0,0,1)
  = 0$, a vector crossed with itself. So the point lies in $V(I_3)$, as any point of the form
  $Phi(p,lambda)$ must (@def-y1y2). The point lies on the *new* component $P_3$, not on the inherited $P_2$ --
  $vek(v)_1$ and $vek(v)_2$ are independent here, so the $k=2$ bracket does not already vanish. It
  is *not* a rank-2 witness in @lem-witness-new's sense (that witness uses $lambda=0$, not
  $lambda=1$) -- it illustrates $Y_2$ itself, not the radicality argument's own witness points.
]

#proposition[rational parametrization of each component][
  For $k >= 2$ and $j=2,dots,k$, the component of $V(I_k)$ indexed $j$ (@thm-componentcount, over
  $overline(FF)$ per @rem-base-field) is exactly the closure of the image of @def-primecomponents'
  map $Psi_j$; equivalently, $P_j = ker phi_j$ is its vanishing ideal. In particular that component
  is a *rational* variety. The parametrization is moreover *birational* onto the component: $Psi_j$
  is injective over $U_(j-1) times AA^1 times AA^(3(k-j))$ -- where, at $j=2$, the symbol $U_1$ is
  to be read as $\{vek(v)_1 eq.not 0\}$, since @lem-nondeg defines $U_j$ only for $j >= 2$ and
  $vek(w)_1$ does not exist.
] <prop-rational>

#proof[Proof of @prop-rational][
  At parameter $j=k$ the map $Psi_k$ is $Phi$ itself, whose image closure is $Y_2$ (@def-y1y2), and
  @thm-componentcount's induction identifies $Y_2$ with the component indexed $k$. For $j<k$ the
  same construction run at parameter $j$ gives that level's $Y_2$, and appending the free blocks
  $vek(v)_(j+1),dots,vek(v)_k$ crosses it with $AA^(3(k-j))$ -- which is exactly
  @thm-componentcount's description of the inherited component indexed $j$. That the vanishing
  ideal of the closure of a polynomial map's image is the kernel of the corresponding algebra
  homomorphism is the standard identification, over $overline(FF)$.

  For birationality, @lem-y2-dim's injectivity argument (over $U_(j-1)$, via @lem-nondeg at level
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
] <ex-components-k3>

= Cohen-Macaulayness

#proposition[Eagon-Northcott / Hilbert-Burch, applied][
  Let $M$ be a $2 times 3$ matrix with entries in a polynomial ring $R$ over a field (arbitrary
  entries, not necessarily independent indeterminates), and $J$ the ideal of its $2 times 2$
  minors. If $J$ has the *expected* codimension $3-2+1=2$, then $J$ is a perfect ideal of grade 2
  -- $"pd"(R\/J)=2$, hence $R\/J$ is Cohen-Macaulay.
] <prop-detideal>

#proof[Proof of @prop-detideal][
  Bruns and Vetter #bcite("BrunsVetter1988"), Theorem (2.7), p. 13, gives exactly this for an
  *arbitrary* matrix, as needed since one row of our $2 times 3$ matrix ($signtwist(vek(w)_(k-1))$) is a
  fixed polynomial vector, not a row of independent indeterminates. (The original construction,
  Eagon and Northcott #bcite("EagonNorthcott1962"), is superseded here by Bruns-Vetter's more
  general treatment -- confirmed closed-access via Unpaywall, not used directly.)
]

#remark[why the generator count above wasn't proven this way][
  One might expect @prop-detideal to hand over the generator count as well, for free, via
  Bruns-Vetter's Theorem (16.36), p. 217, the Theorem of Hilbert-Burch. It does not. That theorem
  as actually stated gives $I = a dot I_m (f)$ for a nonzerodivisor $a$, and a generator count is
  not among its conclusions.

  Nor could it be. At expected codimension the minors of an *arbitrary* $2 times 3$ matrix can be
  perfect and Cohen-Macaulay while one minor vanishes identically, or is a scalar combination of
  the other two. A single example settles it: over $FF[x,y]$ the matrix $mat(x,y,0;0,0,1)$ has
  minors $0, x, y$ and height 2, exactly as expected, yet $J=(x,y)$ is perfect and Cohen-Macaulay
  with only *two* generators.

  This is why @thm-mingens is proven directly from linear independence rather than cited from this
  section's machinery.
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
  Recall Serre's condition $S_n$. A Noetherian ring $A$ satisfies $S_n$ if
  $"depth"(A_P) >= min(n, dim A_P)$ for every prime $P subset A$. Cohen-Macaulayness is the
  extremal case: it asks for $"depth"(A_P) = dim A_P$ at *every* prime, which is $n = infinity$ in
  effect.

  A Cohen-Macaulay ring therefore satisfies $S_n$ for every $n$, since
  $"depth"(A_P) = dim A_P >= min(n, dim A_P)$ holds trivially whatever $n$ is. This needs nothing
  beyond the two definitions just given, and it is standard for Serre's conditions in general: see
  Bruns and Vetter #bcite("BrunsVetter1988"), or Eisenbud's
  #emph[Commutative Algebra with a View Toward Algebraic Geometry]. In particular $R_k \/ I_k$
  satisfies $S_1$.

  Serre's criterion for reducedness says that a Noetherian ring is reduced if and only if it
  satisfies both $R_0$ and $S_1$ #bcite("Stacks031R"). Given @thm-cm, then, radicality of $I_k$ is
  equivalent to $R_0$ alone: regularity of $R_k \/ I_k$ at each of its minimal primes.
] <lem-serre>

The four lemmas that follow are the standard Jacobian criterion, split into its two genuinely
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
  Only linear algebra is needed here; in particular, no hypothesis on $A$ is required. Sending
  $g$ to its gradient at $x$
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
  The local dimension is computed componentwise:
  $ dim A_frak(m) = max{dim (A\/P)_frak(m) : P in "Min"(A), P subset.eq frak(m)}, $
  and each $A\/P = S\/tilde(P)$ is an affine domain over a field, for which
  $dim (S\/tilde(P))_frak(M) = dim S\/tilde(P)$ at *every* maximal ideal $frak(M)$ -- affine
  domains over a field are catenary and equicodimensional (Eisenbud, #emph[Commutative Algebra],
  Cor. 13.4; equivalently the Stacks Project, tag 00OS #bcite("Stacks00OS") -- a dimension formula
  for finitely generated field extensions, holding over an arbitrary field, not needing a
  perfect-field hypothesis by accident). By equidimensionality every such $dim S\/tilde(P)$ equals
  $n-c$.
]

#lemma[Jacobian criterion: the rank bound][
  The hypotheses are those of @lem-localdim. Then $"rank" "Jac"(x) <= c$.
] <lem-jacobian-rankbound>

#proof[Proof of @lem-jacobian-rankbound][
  In any Noetherian local ring one has $dim_FF frak(m)\/frak(m)^2 >= dim A_frak(m)$. By
  @lem-cotangent the left-hand side is $n - "rank" "Jac"(x)$, and by @lem-localdim the right-hand
  side is $n-c$; rearranging gives $"rank" "Jac"(x) <= c$.
]

#lemma[Jacobian criterion: regularity at rank $=c$][
  The hypotheses are those of @lem-localdim. If $"rank" "Jac"(x) = c$, then $A_frak(m)$ is regular of
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
  $ J_k = [ -[vek(v)_k]_times signtwist() J_(k-1) mid(|) [signtwist(vek(w)_(k-1))]_times ]. $
] <lem-jacrecursion>

#proof[Proof of @lem-jacrecursion][
  For the second block, $vek(w)_k = signtwist(vek(w)_(k-1)) times vek(v)_k = [signtwist(vek(w)_(k-1))]_times vek(v)_k$ is linear in
  $vek(v)_k$ with coefficient matrix free of $vek(v)_k$. For the first, differentiating
  $vek(w)_k = signtwist(vek(w)_(k-1)) times vek(v)_k$ with respect to any variable $t$ among $vek(v)_1,dots,vek(v)_(k-1)$ gives
  $∂_t vek(w)_k = (signtwist() ∂_t vek(w)_(k-1)) times vek(v)_k = -[vek(v)_k]_times signtwist() ∂_t vek(w)_(k-1)$, using
  $a times b = -[b]_times a$; assembling columns gives the stated product.
]

#example[$J_3$, explicitly][
  With variables ordered $v_(1,1),v_(1,2),v_(1,3),v_(2,1),v_(2,2),v_(2,3),v_(3,1),v_(3,2),v_(3,3)$,
  the $3 times 9$ Jacobian of $vek(w)_3$ (the three generators of $I_3$ from the earlier example),
  column-blocked to match @lem-jacrecursion's formula $J_3 = [ -[vek(v)_3]_times signtwist() J_2 mid(|)
  [signtwist(vek(w)_2)]_times ]$ -- shown here as the two blocks separately, since side by side the full
  $3 times 9$ matrix does not fit the page width. First, $-[vek(v)_3]_times signtwist() J_2$ ($3 times 6$):
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
  and then $[signtwist(vek(w)_2)]_times$ ($3 times 3$, the skew matrix of $signtwist(vek(w)_2)$'s three coordinates from
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
  component -- this is false: the old-variable block is left-multiplied by $-[vek(v)_k]_times signtwist()$, not
  merely padded with zero rows. At the first inherited case ($k=2 arrow.r 3$), appending $vek(v)_3=0$
  actually drops the rank to 0. The correct witness (@lem-witness-inherited below) instead picks
  $vek(v)_k = e_i$ for a standard basis vector *not* lying in $signtwist() dot "im" J_(k-1)(q)$ -- a genuine
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
  directly instead: $J_2 = [ -[vek(v)_2]_times mid(|) [vek(v)_1]_times ]$ carries no $signtwist()$ at all, so
  for any $p eq.not 0$, $J_2(p,0) = [ 0 mid(|) [p]_times ]$, which has rank 2 by the kernel
  computation below. And $(p,0) in V(I_2)$ since $vek(w)_2(p,0) = p times 0 = 0$.

  *For $k >= 3.$* By @lem-jacrecursion, $J_k(p,0) = [ 0 mid(|) [signtwist(vek(w)_(k-1)(p))]_times ]$ since
  $-[0]_times signtwist() J_(k-1)(p) = 0$; and $signtwist(vek(w)_(k-1)(p)) eq.not 0$ since $vek(w)_(k-1)(p) eq.not 0$
  (@lem-nondeg) and $signtwist()$ is invertible. For $u eq.not 0$,
  $ker [u]_times = {v : u times v = 0} = FF u$ (a cross product vanishes exactly on linearly
  dependent pairs), so $[signtwist(vek(w)_(k-1)(p))]_times$ has rank 2, giving $"rank" J_k(p,0) = 2$.
]

#lemma[rank-2 witness on an inherited component][
  For every $k >= 3$ and every component $Z$ of $V(I_(k-1))$ with a rank-2 witness $q in Z$
  (@lem-witness-new, or this lemma applied at $k-1$), there is $x = (q,e_i) in Z times AA^3 subset
  V(I_k)$ with $"rank" J_k(x) = 2$.
] <lem-witness-inherited>

#proof[Proof of @lem-witness-inherited][
  Let $W := signtwist() dot "im" J_(k-1)(q)$, a 2-dimensional subspace of $FF^3$ since $signtwist()$ is invertible and
  $"rank" J_(k-1)(q)=2$. Since $e_1,e_2,e_3$ span $FF^3$ and $W eq.not FF^3$, some $e_i in.not W$;
  fix such an $i$. Since $q in V(I_(k-1))$, $vek(w)_(k-1)(q)=0$, so @lem-jacrecursion gives
  $J_k(q,e_i) = [ -[e_i]_times signtwist() J_(k-1)(q) mid(|) 0 ] $, of rank $dim([e_i]_times W)$ since
  $signtwist() J_(k-1)(q)$ has image exactly $W$. As $ker [e_i]_times = FF e_i$ and $W inter FF e_i = 0$
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
  using @thm-cm's Cohen-Macaulayness. Serre's criterion #bcite("Stacks031R") gives radicality.
]

This has been verified independently in Sage, for the signed encoding, at every $k=2,dots,6$: the Jacobian
recursion (@lem-jacrecursion) checked as a polynomial identity, not just at points, and every
witness confirmed to lie on $V(I_k)$ with $"rank" J_k = 2$
(#text(style: "italic")[code/referee\_radicality\_S\_check.sage]). The sharper claim --- that each
witness lies on *exactly* its intended component --- is confirmed by an independently-computed
primary decomposition at every $k=3,4,5,6$, which returns $k-1$ components in each case, in
agreement with @thm-componentcount; the $k=6$ decomposition takes some hours.

= The Primary Decomposition Theorem

Every ingredient is now in hand for the fully general statement -- component count (§5) and
radicality (§7) together, neither sufficient alone. One convention has to be made explicit first,
because it is the hinge on which the statement's claimed generality turns.

#remark[the geometric arguments run over $overline(FF)$, and the conclusion descends][
  Sections 5-7 argue geometrically: they speak of $V(I_k)$, of its irreducible components, and of
  the closure of the image of a parametrization, and at the decisive step they identify
  $"Min"(I_k)$ with the vanishing ideals of those components. That identification is a
  Nullstellensatz statement and is *false over a general field* -- over $FF_3$, for instance,
  $V(I_k)(FF_3)$ is a finite set of points and carries no such information at all. So throughout
  §§5-7, and in the theorem below, $V(dot)$ means the vanishing locus in
  $AA^(3k)(overline(FF))$ over a fixed algebraic closure, and "component" means an irreducible
  component there. This is the usual convention and is what the classical literature on the
  commuting variety assumes as well (Artin-Hochster is stated over an algebraically closed field
  in #bcite("MajidiZolbaninSnapp")).

  The conclusion nonetheless descends to $FF$ itself, so the theorem may be read over any field of
  characteristic $eq.not 2$, as stated. The reason is that each $P_j$ is not merely prime but
  *absolutely* prime. By @def-primecomponents, $P_j$ *is* the kernel of an $FF$-algebra
  homomorphism $phi_j : R_k -> FF[t_1,dots,t_(3k-2)]$ into a polynomial ring, so $R_k \/ P_j$
  embeds in that polynomial ring. Since $overline(FF)$ is flat over $FF$, tensoring preserves the embedding:
  $ overline(FF) ⊗_FF (R_k \/ P_j) arrow.r.hook overline(FF)[t_1,dots,t_m], $
  whose target is a domain, so the extension of $P_j$ to $overline(FF) ⊗_FF R_k$ is
  again prime. Formation of a finite intersection of ideals likewise commutes with the flat base
  change $FF -> overline(FF)$. Hence the displayed decomposition, established over
  $overline(FF)$, holds already over $FF$, with the same $k-1$ primes.
] <rem-base-field>


#theorem[Primary Decomposition Theorem][
  For every $k >= 2$, over any field of characteristic $eq.not 2$: $I_k$ has exactly $k-1$
  irreducible, radical, primary components, namely $P_2,dots,P_k$ of @def-primecomponents, and
  $ I_k = P_2 inter dots.c inter P_k $
  is an irredundant primary decomposition into $k-1$ primes.
] <thm-primarydecomp>

#proof[Proof of @thm-primarydecomp][
  The two halves were proven independently above, so this combines them in full rather than
  asserting the conjunction in one line.

  *The decomposition itself.* By @thm-radical, $I_k$ is radical, so $I_k = sqrt(I_k)$. A radical
  ideal in a Noetherian ring equals the intersection of its own minimal primes:
  $ I_k = inter_(P in "Min"(I_k)) P. $
  This holds because $sqrt(I_k)$ is the intersection of *all* primes containing $I_k$ -- Krull's
  theorem, not the definition of the radical, which is instead the set of elements with a power in
  $I_k$ -- and the minimal primes already suffice. Every non-minimal prime containing $I_k$
  contains a minimal one, and is therefore redundant in the intersection.

  @thm-componentcount identifies $"Min"(I_k)$ explicitly, over $overline(FF)$ as @rem-base-field
  requires: exactly $k-1$ primes, one per block pattern $j=2,dots,k$, named $P_2,dots,P_k$ in
  @def-primecomponents. Substituting them gives the displayed equation.

  *Why the components are primary.* Each $P_j$ is prime, so it is trivially its own
  primary-decomposition component, being $P_j$-primary with associated prime $P_j$. Nothing beyond
  primality has to be argued.

  *Why they are prime.* Nothing is left to prove here either. @def-primecomponents *defines* $P_j$
  as $ker phi_j$, and the kernel of a homomorphism into a domain is prime. That argument covers
  $j=2$ along with the rest, at no extra cost. @lem-y2-irred would give the same conclusion for
  $j >= 3$, but it is stated for $k >= 3$ and so misses $j=2$; $P_2$ is $I_2$ itself, the ideal of
  maximal minors of a generic $2 times 3$ matrix, which is classically prime. Neither of those
  routes is needed.

  Extending $P_j$ from $R_j$ to $R_k$ by adjoining the free blocks
  $vek(v)_(j+1),dots,vek(v)_k$ preserves primality, since $R_k \/ P_j R_k$ is a polynomial ring
  over the domain $R_j \/ P_j$.

  *Irredundancy.* No $P_j$ can be omitted, i.e. no $P_j$ contains $inter_(i eq.not j) P_i$. This is
  exactly @thm-componentcount's own no-containment conclusion, obtained from @prop-y2-not-in-y1 and
  @prop-y1-not-in-y2 applied at every level of that theorem's induction. It needs no further proof
  here.
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
  in fact birational to an explicit affine parameter space (@prop-rational). Radicality and this
  component count together -- rationality plays no part in the assembly -- give the irredundant
  primary decomposition of the Primary Decomposition Theorem (@thm-primarydecomp):
  $I_k = P_2 inter dots.c inter P_k$.

#v(1.5em)
= Methods

This article was produced by a workflow that is not the usual one. Since the workflow bears on how
some of the claims above should be read, it is set out here rather than left to be inferred.

*Computer algebra, in two roles that should not be confused.* SageMath and Macaulay2 were used
throughout, for two quite different purposes. The first is *conjecture*: the component count of
@thm-componentcount, its block-involvement pattern, and the shape of the primary decomposition were
found by computing primary decompositions of $I_k$ at small $k$ and reading off the pattern, well
before any of it was proved. The second is *verification*: once proved, the general statements were
checked against independent computation --- the determinantal structure of @thm-determinantal by
Gröbner-basis equality in both directions and, separately, against ordinary $2 times 2$ matrix
multiplication, the two routes sharing no code; the Jacobian recursion of @lem-jacrecursion as a
polynomial identity rather than at sampled points; the witness points of @lem-witness-new and
@lem-witness-inherited confirmed to lie on $V(I_k)$ with the stated Jacobian rank, and on exactly
the intended component; and the decomposition itself recomputed at $k=3,4,5,6$.

Because rank, dimension and radicality are *not* characteristic-independent --- a matrix of rank 3
over $QQ$ may drop rank modulo $p$ --- computations over $QQ$ license nothing about $FF_p$, and the
four main results were therefore re-run over $FF_2$, $FF_3$, $FF_4$, $FF_5$, $FF_7$ and $FF_9$ as
well. No deviation appeared. The scripts are named at the point of use, and are included with this
submission as ancillary files under `anc/code/`, with their full output transcripts under
`anc/runs/`; the paths cited in the text are the paths inside that directory. The explicit
computations they produce are displayed in @sec-appendix.

Nothing in this article is conjectural, or checked only at small $k$: every statement is proven for
*every* $k >= 2$, over an *arbitrary* field of the stated characteristic. The computational thread
corroborates the general proofs; nowhere does it substitute for one.

*Source of truth, and a partial formalization.* The manuscript is written in Typst, and that source
is canonical: the LaTeX is generated from it mechanically, so the two cannot drift apart. The same
source supplied the statements for a partial formalization in Lean 4 against #emph[mathlib].
Machine-checked, with no proof gaps and depending on no axioms beyond the three that every
#emph[mathlib] development uses: the basic identity (@thm-basic-identity), in the strengthened form
that drops the traceless hypothesis; the minimal-generator theorem (@thm-mingens) for the actual
$vek(w)_k$, together with the whole chain beneath it --- the general lemma that independent
same-degree generators are minimal (@lem-mingens-generic), the homogeneity of $vek(w)_k$, the
freshness of each new variable block, and the linear independence itself (@lem-mingens-indep); the
Jacobian recursion (@lem-jacrecursion); and the smaller computational claims of §3 and §5,
including the identity of @rem-why-D.

*Not* formalized: everything resting on determinantal-ideal theory or on dimension theory --- the
codimension (@thm-codim), Cohen-Macaulayness (@thm-cm), radicality (@thm-radical), the component
count (@thm-componentcount) and the Primary Decomposition Theorem (@thm-primarydecomp) --- for
which the necessary libraries do not presently exist. The formalization is therefore a *partial*
guarantee, and is described as one: it should not be read as covering the article's main results.

*Adversarial review.* The manuscript was put through five rounds of deliberately adversarial
review, each instructed to find errors rather than to approve, and each required to verify by
computation rather than by reading. This was not a formality. The rounds found: a genuine gap in
the proof of @lem-mingens-indep, where non-degeneracy was doing work that only linear independence
can do; explicit displays that had not been recomputed after a change of encoding, and so still
showed the superseded values; a false statement about the state of the literature, contradicted by
the very sources cited for it; a citation to the wrong tag of a reference work, made under an
explicit assurance that it had been verified; a stretch of prose that described the formulas
printed beside it incorrectly; and the gap in generality that @rem-base-field now closes. All are
corrected above. The mention is not decorative: a reader is entitled to know what kind of error an
adversarial pass actually catches, and to calibrate accordingly.

*What this workflow is, and is not, good for.* Its strength is coverage of the mechanical: a
recomputation notices a stale display, an inconsistent index or an unverified citation reliably,
and does so at a scale and patience that re-reading does not sustain. Its weakness is that none of
that establishes that the argument is *right*; every substantive correction above was found by an
adversarial reading, not by a passing test. The machine checks and the Lean formalization narrow
the space in which an error can hide; they do not empty it, and the responsibility statement below
is meant literally.

#v(1.5em)
= Acknowledgements

The author first learned of the ring of commuting matrices some thirty years ago from Professor
Jan-Erik Roos, in a course he held on the then fledgling field of computer algebra. It is a
pleasant debt to record here, given how much of what follows was found with a computer algebra
system open beside the page.

The computations were carried out in SageMath and Macaulay2, and the formalization in Lean 4 with
_mathlib_; this article would have a different and smaller content without them. The nature
and extent of the assistance from a large language model is set out in §10 and in the disclosure
below.

#v(1.5em)
= Disclosure of AI assistance

This manuscript was produced with substantial assistance from a large language model, Claude
(Anthropic), and the extent of it is stated here rather than left to be inferred. The itemised
account is §10: which results were machine-checked and which were not, what the computer algebra
established and what it merely corroborated, and what the adversarial review found. Claude is not a
co-author, and is not credited as one.

Every computational claim has been checked along a route independent of the statement being tested,
and the reference list has been checked against the sources cited --- with the one exception that
where a source is a printed book outside this project's open-access policy, an independently
verified equivalent is cited alongside it. The author has verified the results to the best of his
ability, made the final edits, and assumes full responsibility for any errors, mistakes or gaps
that remain.

#v(1.5em)
= Appendix: the explicit computations <sec-appendix>

The results above are stated with their computations named rather than displayed, so that the
argument stays legible. This appendix displays them. Everything here is *corroboration*: no proof
in the article rests on a computation, and nothing below is offered as one. Each block names the
script that produced it, and the scripts ship with this submission as ancillary files under
`anc/code/`, with their full transcripts under `anc/runs/`.

One naming point, since the scripts ship as they are. Most of them were written while the sign
twist was called $D$, and they still write `D` internally for the matrix this article calls
$signtwist()$. It is the same matrix, $"diag"(-1,-1,1)$; only the article's name for it changed.
Their contents were not rewritten for the rename, on the grounds that editing working verification
code for cosmetic reasons is a worse risk than a sentence saying so.

Every polynomial below was recomputed for this appendix from the recursion of @def-wk rather than
transcribed from an earlier draft. That distinction is not pedantry here: the article changed
encoding partway through its life, from the reshuffle $tau(a,b,c)=(b,a,2c)$ to $signtwist()$, and
a computed polynomial cannot be carried across such a change by substituting symbols --- it has to
be recomputed. Output that still carries a literal coefficient $2$ in the $vek(v)$-coordinates is
the tell that it was not.

== Both sides of the basic identity <app-identity>

@thm-basic-identity asserts $"enc"([A_0,B_0]) = signtwist("enc"(A_0) times "enc"(B_0))$. Expanded
over generic entries $a_11,dots,b_22$, the two sides are, component by component:

#text(size: 8pt)[
```
lhs_1 = rhs_1 = -2*a21*b12 + 2*a12*b21
lhs_2 = rhs_2 = -a12*b11 + a21*b11 + a11*b12 - a22*b12 - a11*b21 + a22*b21
                + a12*b22 - a21*b22
lhs_3 = rhs_3 = -a12*b11 - a21*b11 + a11*b12 - a22*b12 + a11*b21 - a22*b21
                + a12*b22 + a21*b22
```
]

The difference is $(0,0,0)$ identically. Chaining once more gives the triple commutator
$"enc"([[A,B],C])$, which the recursion computes as
$signtwist(signtwist("enc"(A) times "enc"(B)) times "enc"(C))$; its three components have
$8$, $20$ and $20$ terms:

#text(size: 8pt)[
```
comp_1 = -2*a21*b11*c12 + 2*a11*b21*c12 - 2*a22*b21*c12 + 2*a21*b22*c12
         - 2*a12*b11*c21 + 2*a11*b12*c21 - 2*a22*b12*c21 + 2*a12*b22*c21

comp_2 = a12*b11*c11 + a21*b11*c11 - a11*b12*c11 + a22*b12*c11 - a11*b21*c11
         + a22*b21*c11 - a12*b22*c11 - a21*b22*c11 - 2*a21*b12*c12
         + 2*a12*b21*c12 + 2*a21*b12*c21 - 2*a12*b21*c21 - a12*b11*c22
         - a21*b11*c22 + a11*b12*c22 - a22*b12*c22 + a11*b21*c22
         - a22*b21*c22 + a12*b22*c22 + a21*b22*c22

comp_3 = a12*b11*c11 - a21*b11*c11 - a11*b12*c11 + a22*b12*c11 + a11*b21*c11
         - a22*b21*c11 - a12*b22*c11 + a21*b22*c11 - 2*a21*b12*c12
         + 2*a12*b21*c12 - 2*a21*b12*c21 + 2*a12*b21*c21 - a12*b11*c22
         + a21*b11*c22 + a11*b12*c22 - a22*b12*c22 - a11*b21*c22
         + a22*b21*c22 + a12*b22*c22 - a21*b22*c22
```
]

The factors of $2$ here are expected and are *not* a symptom of the retired encoding: on the
traceless part $a_22 = -a_11$, so $d_a = a_11 - a_22 = 2a_11$. The article's claim that no $2$
appears is about the $vek(v)$-coordinates of @ex-wk-signed, which is a different expansion in
different variables. Both routes agree exactly
(#text(style: "italic")[code/regenerate\_displays\_S.sage],
#text(style: "italic")[code/verify\_lorentzian\_encoding\_identity.sage]).

== The three assertions of @rem-why-D <app-remark2>

*The ideal is unchanged by the twist.* The three components of $vek(w)_2$, which are also the
entries of $signtwist(vek(w)_2)$ up to sign, are
$ -v_(1,3)v_(2,2) + v_(1,2)v_(2,3), quad v_(1,3)v_(2,1) - v_(1,1)v_(2,3), quad
  -v_(1,2)v_(2,1) + v_(1,1)v_(2,2), $
so $"ideal"(vek(w)_2) = "ideal"(signtwist() vek(w)_2)$ generator by generator: two of the three are
negated and the third is fixed, and negating a generator does not change the ideal it generates.
Confirmed independently by Gröbner-basis equality in
#text(style: "italic")[code/verify\_encoding\_gl3\_equivariance.sage].

*The Lorentzian form.* With $A_0$ the traceless part of a generic $A$, the polynomial
$-"enc"(A_0)_1^2 - "enc"(A_0)_2^2 + "enc"(A_0)_3^2 - 4 det(A_0)$ is identically $0$ --- not zero at
sampled points, but the zero polynomial in $a_11,dots,a_22$.

*The involution, and the $FF_3$ congruence.* $signtwist()^2 = I$ exactly, while
$tau^2 = "diag"(1,1,4) eq.not I$ and $det tau = -2$. Over $FF_3$, with
$T = mat(0,0,1;1,1,0;1,2,0)$ of determinant $1$,
$ T^tack.b T = "diag"(2,2,1) = "diag"(-1,-1,1) quad "in" FF_3, $
so $signtwist()$'s form is congruent to the identity form there. This is why the article's claim is
stated for formally real fields rather than for fields in which $-1$ is a non-square: the latter
condition is the wrong one, and $FF_3$ is the counterexample.

== The generators of $I_6$ <app-i6>

@thm-mingens gives $I_k$ three minimal generators for every $k$. At $k=6$ they are degree-$6$
forms in the $18$ variables $v_(1,1),dots,v_(6,3)$, with $32$ terms each and *every coefficient
equal to $plus.minus 1$*:

#text(size: 6.5pt)[
```
w_6,1 = -v1_3*v2_1*v3_1*v4_1*v5_1*v6_2 + v1_1*v2_3*v3_1*v4_1*v5_1*v6_2
        - v1_3*v2_2*v3_2*v4_1*v5_1*v6_2 + v1_2*v2_3*v3_2*v4_1*v5_1*v6_2
        - v1_2*v2_1*v3_2*v4_3*v5_1*v6_2 + v1_1*v2_2*v3_2*v4_3*v5_1*v6_2
        + v1_3*v2_1*v3_3*v4_3*v5_1*v6_2 - v1_1*v2_3*v3_3*v4_3*v5_1*v6_2
        - v1_3*v2_1*v3_1*v4_2*v5_2*v6_2 + v1_1*v2_3*v3_1*v4_2*v5_2*v6_2
        - v1_3*v2_2*v3_2*v4_2*v5_2*v6_2 + v1_2*v2_3*v3_2*v4_2*v5_2*v6_2
        + v1_2*v2_1*v3_1*v4_3*v5_2*v6_2 - v1_1*v2_2*v3_1*v4_3*v5_2*v6_2
        + v1_3*v2_2*v3_3*v4_3*v5_2*v6_2 - v1_2*v2_3*v3_3*v4_3*v5_2*v6_2
        + v1_2*v2_1*v3_1*v4_1*v5_1*v6_3 - v1_1*v2_2*v3_1*v4_1*v5_1*v6_3
        + v1_3*v2_2*v3_3*v4_1*v5_1*v6_3 - v1_2*v2_3*v3_3*v4_1*v5_1*v6_3
        + v1_2*v2_1*v3_2*v4_2*v5_1*v6_3 - v1_1*v2_2*v3_2*v4_2*v5_1*v6_3
        - v1_3*v2_1*v3_3*v4_2*v5_1*v6_3 + v1_1*v2_3*v3_3*v4_2*v5_1*v6_3
        + v1_3*v2_1*v3_1*v4_2*v5_3*v6_3 - v1_1*v2_3*v3_1*v4_2*v5_3*v6_3
        + v1_3*v2_2*v3_2*v4_2*v5_3*v6_3 - v1_2*v2_3*v3_2*v4_2*v5_3*v6_3
        - v1_2*v2_1*v3_1*v4_3*v5_3*v6_3 + v1_1*v2_2*v3_1*v4_3*v5_3*v6_3
        - v1_3*v2_2*v3_3*v4_3*v5_3*v6_3 + v1_2*v2_3*v3_3*v4_3*v5_3*v6_3
```
]

The other two components, $w_(6,2)$ and $w_(6,3)$, have the same shape and the same $32$-term,
$plus.minus 1$ profile; all three are printed in full in
#text(style: "italic")[code/regenerate\_displays\_S.sage]'s transcript, which ships as
`anc/runs/display-ground-truth-S.txt`. The script asserts the coefficient profile rather than
merely printing it, so a regression to the retired encoding fails the run instead of producing a
plausible-looking table.

== The non-degeneracy witness <app-witness>

The following table evaluates the point constructed in the proof of @lem-nondeg.

#text(size: 8pt)[
```
j    witness (v_1,...,v_j)              w_j
2    (e1,e2)                            e3
3    (e1,e2,e1)                         e2
4    (e1,e2,e1,e1)                      e3
5    (e1,e2,e1,e1,e1)                   e2
6    (e1,e2,e1,e1,e1,e1)                e3
7    (e1,e2,e1,e1,e1,e1,e1)             e2
8    (e1,e2,e1,e1,e1,e1,e1,e1)          e3
```
]

Each level is checked twice in #text(style: "italic")[code/verify\_nondegeneracy\_witness.sage]:
once as the induction runs, and once by feeding the finished witness back through @def-wk's
recursion as a point of $AA^(3j)$, which is how @lem-nondeg states it. The same script runs the
retired $tau$ alongside, where the witness must alternate, $(e_1,e_2,e_1,e_2,dots)$, and the images
are $(0,2,0)$, $(0,0,2)$, $(0,4,0)$, $dots$, doubling at every level and reaching $8$ by $j=8$.
That column reproduces values recorded before the encoding changed, which is what makes the
$signtwist()$ column above a check rather than merely a new computation.

== Independence of the generators <app-independence>

This is the corroboration cited in the proof of @lem-mingens-indep. For each $k$, the three components of
$vek(w)_k$ are expanded over the monomials that actually occur and the resulting $3 times N$
coefficient matrix is checked to have rank $3$ --- which is exactly the assertion that no
nontrivial constant relation holds among them:

#align(center)[
  #table(
    columns: 6,
    align: center,
    stroke: 0.5pt,
    inset: 6pt,
    [$k$], [\#variables], [degree], [\#monomials], [rank], [independent?],
    [2], [6], [2], [6], [3], [yes],
    [3], [9], [3], [12], [3], [yes],
    [4], [12], [4], [24], [3], [yes],
    [5], [15], [5], [48], [3], [yes],
    [6], [18], [6], [96], [3], [yes],
  )
]

The monomial count doubles at each step while the rank stays at $3$, so the margin widens rather
than narrows as $k$ grows (#text(style: "italic")[code/verify\_generator\_independence.sage]).

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
  of matrices whose product is symmetric], in #emph[Commutative Algebra and Its Connections to
  Geometry], Contemporary Mathematics 555, American Mathematical Society, 2011, pp. 145-150.
  Author's open-access copy at
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
  J. Algebraic Geom. 14 (2005), 283-294; preprint arXiv:math/0306275. (The arXiv abstract page's
  "to appear" note long predates publication.) Open access at
  #link("https://arxiv.org/abs/math/0306275")[arxiv.org/abs/math/0306275].]
#bibentry("Youcis2014")[A. Youcis, answer to "What can we say about the image of a regular map?",
  Mathematics Stack Exchange, question 731178, answer 732415, 2014. States both the
  point-set-topology fact that the continuous image of an irreducible space is irreducible, and the
  $(x,y) |-> (x,x y)$ non-closed-image example cited above. CC BY-SA 3.0. Open access at
  #link("https://math.stackexchange.com/questions/731178/what-can-we-say-about-the-image-of-a-regular-map")[math.stackexchange.com/questions/731178].]
#bibentry("Stacks031R")[#emph[The Stacks Project], tag *031R* = Lemma 10.157.3, Serre's criterion
  for reducedness: "Let $R$ be a Noetherian ring. The following are equivalent: (1) $R$ is reduced,
  and (2) $R$ has properties $(R_0)$ and $(S_1)$." Open access at
  #link("https://stacks.math.columbia.edu/tag/031R")[stacks.math.columbia.edu/tag/031R].
  Note for anyone re-checking: the enclosing *section* 10.157 is tag 031O and is titled "Serre's
  criterion for #emph[normality]"; its own Lemma 10.157.4 (tag 031S) is the normality criterion
  $R_1 + S_2$, a different statement. Fetching 031O displays the whole section, this lemma
  included, so it is easy to confirm the quoted text on a page whose tag is nevertheless the wrong
  one -- which is exactly the error this entry carried until 2026-08-31.]

#bibentry("Tambour2000")[T. Tambour, #emph[The Number of Solutions of Some Equations in Finite
  Groups and a New Proof of Itô's Theorem], Communications in Algebra *28* (2000), no. 11,
  5353--5361. #link("https://doi.org/10.1080/00927870008827160")[doi:10.1080/00927870008827160].
  Earlier version: #emph[On the Number of Solutions of Some Equations in Finite Groups], Stockholm
  University Research Reports in Mathematics No. 15 (1998), ISSN 1401-5617.]
