# Raw computational output --- \[A,B\] at n=2, k=2 (base case)

Full, unedited stdout from every script run for the $k=2$ ring-study battery (the base case that
$k=3,\ldots,6$ chain from --- see `working-notes/iterated-commutator-n_2-k_2.org`{.verbatim} for the write-up
and interpretation, =six-fold-commutator-n2.org=step 6\'s synthesis table for how this fills the
previously-blank $e(R/I)$ entry at $k=2$). Every block below is copy-pasted verbatim from an actual
run, nothing hand-edited or fabricated.

# Step 1: basic ring invariants --- `code/ring_study_2x2_commutator.sage`{.verbatim}

    $ sage code/ring_study_2x2_commutator.sage
    total multiplications (5*1): 5
    dim(R/I): 4  ambient: 6  codim: 2
    I radical? True

    === minimal free resolution ===
         1     0     0
         0     3     2
    [1]:
       _[1]=u3*v2-u2*v3
       _[2]=u3*v1-u1*v3
       _[3]=u2*v1-u1*v2
    [2]:
       _[1]=v1*gen(1)-v2*gen(2)+v3*gen(3)
       _[2]=u1*gen(1)-u2*gen(2)+u3*gen(3)
    [3]:
       _[1]=0
    [4]:
       _[1]=gen(1)
    [5]:
       _[1]=0
    [6]:
       _[1]=gen(1)

Reading the `betti()`{.verbatim} table: position 0 has rank 1 ($R$ itself), position 1 has 3 minimal
generators (the three $2\times2$ minors printed just below --- degree 2, i.e. bilinear in $A,B$, as
expected), position 2 has 2 first syzygies. Resolution length (projective dimension)
$\mathrm{pd}(R/I)=2=\mathrm{codim}(I)$ --- Cohen--Macaulay by Auslander--Buchsbaum, same signature as
every $k=3,\ldots,6$ data point.

# Step 2: primary decomposition --- `code/ring_study_2x2_commutator_primarydecomp.sage`{.verbatim}

    $ sage code/ring_study_2x2_commutator_primarydecomp.sage
    starting primary decomposition...
    elapsed: 0.02056741714477539 seconds
    number of primary components: 1
    component 0: dim=4, Q==Q.radical()? True, num_gens=3

    === is I itself prime? ===
    I.is_prime(): True

Exactly $1=k-1$ component for $k=2$, radical, prime --- the base case of conjecture 2 from the
$k=3,\ldots,6$ battery, confirmed here directly rather than by extrapolation.

# Step 3: Hilbert series, both gradings --- `code/hilbert_series_2x2_commutator.m2`{.verbatim}

    $ M2 --script code/hilbert_series_2x2_commutator.m2
    dim, codim:
    4
    2
    2-graded Hilbert series (T0,T1 = u,v degree):
    1-3*T_0*T_1+T_0^2*T_1+T_0*T_1^2
    (1-T_1)^3*(1-T_0)^3
    ordinary Z-graded Hilbert series (independent check):
     1 + 2T
    --------
           4
    (1 - T)

Independent cross-check (not part of the M2 script itself --- run separately, direct Taylor-series
comparison via sympy) that the 2-graded series, specialized to $T_0=T_1=T$, reproduces the ordinary
series\' coefficients exactly:

    $ python3 -c "
    from sympy import symbols, series, simplify
    T = symbols('T')
    f1 = (1+2*T)/(1-T)**4
    s1 = series(f1, T, 0, 8).removeO()
    print('ordinary series terms:', [s1.coeff(T,i) for i in range(8)])

    T0,T1 = symbols('T0 T1')
    num = 1-3*T0*T1+T0**2*T1+T0*T1**2
    den = (1-T0)**3*(1-T1)**3
    f2 = (num/den).subs({T0:T, T1:T})
    s2 = series(simplify(f2), T, 0, 8).removeO()
    print('specialized series terms:', [s2.coeff(T,i) for i in range(8)])
    "
    ordinary series terms: [1, 6, 18, 40, 75, 126, 196, 288]
    specialized series terms: [1, 6, 18, 40, 75, 126, 196, 288]

Both agree exactly through degree 7 --- the specialization checks out, same discipline as $k=3,\ldots,6$
(never trust the multi-graded formula\'s shape alone). Degree/multiplicity read off the ordinary
series\' numerator at $t=1$: $e(R/I)=1+2=3$ --- this is the previously-blank entry in the synthesis
table.

# Step 4: explicit regular sequence --- `code/regular_sequence_2x2_commutator.sage`{.verbatim}

    $ sage code/regular_sequence_2x2_commutator.sage
    found regular sequence:
        v3
        -u1 + u2 + v1 - v2 + v3
        -u2 + v1 + v3
        -u2 + u3 - v1 + v2

Four linear forms ($=\dim R/I$), automatically regular since $R/I$ is already known
Cohen--Macaulay (Step 1).

# Step 0 (reference, pre-existing): the 5-multiplication formula itself --- `code/verify_2x2_commutator_5mult.sage`{.verbatim}

Not re-run as new work (this script predates this task and is unmodified) --- included here only for
completeness, since every other step builds directly on the `cross5`{.verbatim} formula it verifies.

    $ sage code/verify_2x2_commutator_5mult.sage
    OK: 5-multiplication formula matches AB-BA exactly.
    Number of scalar products used: 5 (p1..p5)
