# Raw computation log: \[A,B,C,D,E,F\] at n=2 (k=6), fresh re-run

Fresh re-execution of every script behind
[six-fold-commutator-n2.org](../working-notes/six-fold-commutator-n2.org) (and its sibling
[iterated-commutator-n~2~-k~6~.org](../working-notes/iterated-commutator-n_2-k_6.org)), captured
verbatim. One block per step/script, run for real (Sage/Macaulay2 invoked live, stdout captured
below, nothing copied from the original note without re-executing). All numbers below match the
originally committed results exactly: dim(R/I)=16, codim 2, radical, 3 minimal generators,
Cohen-Macaulay, 5 primary components.

# Step 1a: numeric crosscheck of the 25-multiplication algorithm

Script: `code/verify_2x2_sixfold_commutator_numeric_crosscheck.sage`{.verbatim}

    ground truth H11,H12,H21: -151 -9 -133
    reduced-formula   H11,H12,H21: -151 -9 -133
    MATCH: True

# Step 1b: ring invariants (dim, codim, radical?) and minimal free resolution

Script: `code/ring_study_2x2_sixfold_commutator.sage`{.verbatim}

    total multiplications (5*5): 25
    dim(R/I): 16  ambient: 18  codim: 2
    I radical? True

    === minimal free resolution ===
         1     0     0
         0     0     0
         0     0     0
         0     0     0
         0     0     0
         0     3     1
         0     0     0
         0     0     0
         0     0     0
         0     0     1

Reading of the `betti()`{.verbatim} table: ranks $1,3,1$ at homological degrees $0,1,2$ (interleaved zero
blocks are Singular\'s `mres`{.verbatim} padding, not extra steps) --- i.e.
$0\to R^2\to R^3\to R\to R/I\to0$ with exactly 3 minimal generators (degree 6, sextic ---
sextilinear in $A,\ldots,F$) and 2 first syzygies, $\mathrm{pd}(R/I)=2=\mathrm{codim}(I)
\Rightarrow$ Cohen-Macaulay by Auslander-Buchsbaum.

# Step 3: primary decomposition

Script: `code/ring_study_2x2_sixfold_commutator_primarydecomp.sage`{.verbatim}

Run as a background task (matching the original session\'s own note that this step is slow enough
to warrant it); timed with the shell\'s own `time`{.verbatim} as well as the script\'s internal timer.

    2026-08-16 12:16:47
    starting primary decomposition (may be slow)...
    elapsed: 59.35321521759033 seconds
    number of primary components: 5
    component 0: dim=16, Q==Q.radical()? True, num_gens=3
    component 1: dim=16, Q==Q.radical()? True, num_gens=3
    component 2: dim=16, Q==Q.radical()? True, num_gens=3
    component 3: dim=16, Q==Q.radical()? True, num_gens=3
    component 4: dim=16, Q==Q.radical()? True, num_gens=3

    === block involvement per component ===
    component 0: blocks involved = ['u', 'v']
    component 1: blocks involved = ['u', 'v', 'w']
    component 2: blocks involved = ['u', 'v', 'w', 'x']
    component 3: blocks involved = ['u', 'v', 'w', 'x', 'y']
    component 4: blocks involved = ['u', 'v', 'w', 'x', 'y', 'z']

    real    1m0.352s
    user    0m59.741s
    sys 0m0.329s

Exactly $5=k-1$ components, each radical, each dimension 16, each with 3 generators. Block
involvement is exactly the predicted mechanism: component $j$ involves exactly the first $j+2$
blocks. Wall time \$ ≈ 59.4\$s (the script\'s own internal timer) / \$ ≈ 60.4\$s (shell `time`{.verbatim},
including Sage process startup) --- consistent with the originally reported \"\$∼\$57s\", the fourth
consecutive slowdown-at-this-step data point ($k=3,4,5$ were all fast/negligible).

# Step 4: Hilbert series, both gradings

Script: `code/hilbert_series_2x2_sixfold_commutator.m2`{.verbatim}

    dim, codim:
    16
    2
    6-graded Hilbert series (T0..T5 = u,v,w,x,y,z degree):
    1-3*T_0*T_1*T_2*T_3*T_4*T_5+T_0*T_1*T_2*T_3*T_4*T_5^2+T_0^2*T_1^2*T_2^2*T_3^2*T_4^2*T_5
    (1-T_5)^3*(1-T_4)^3*(1-T_3)^3*(1-T_2)^3*(1-T_1)^3*(1-T_0)^3
    ordinary Z-graded Hilbert series (independent check):
               2     3     4     5     6     7     8    9
    1 + 2T + 3T  + 4T  + 5T  + 6T  + 4T  + 3T  + 2T  + T
    -----------------------------------------------------
                                 16
                          (1 - T)

Direct Taylor-coefficient specialization check of the 6-graded series (all $T_i\to t$) against the
ordinary series, computed independently (Python/sympy, not trusted from the formula shape alone):

    $ python3 -c "
    from sympy import symbols, series, simplify
    T = symbols('T')
    f1 = (1+2*T+3*T**2+4*T**3+5*T**4+6*T**5+4*T**6+3*T**7+2*T**8+T**9)/(1-T)**16
    s1 = series(f1, T, 0, 7).removeO()
    print('ordinary series terms:', [s1.coeff(T,i) for i in range(7)])

    T0,T1,T2,T3,T4,T5 = symbols('T0 T1 T2 T3 T4 T5')
    num = 1-3*T0*T1*T2*T3*T4*T5+T0*T1*T2*T3*T4*T5**2+T0**2*T1**2*T2**2*T3**2*T4**2*T5
    den = (1-T0)**3*(1-T1)**3*(1-T2)**3*(1-T3)**3*(1-T4)**3*(1-T5)**3
    f2 = (num/den).subs({T0:T, T1:T, T2:T, T3:T, T4:T, T5:T})
    s2 = series(simplify(f2), T, 0, 7).removeO()
    print('specialized series terms:', [s2.coeff(T,i) for i in range(7)])
    "
    ordinary series terms: [1, 18, 171, 1140, 5985, 26334, 100944]
    specialized series terms: [1, 18, 171, 1140, 5985, 26334, 100944]

Both agree exactly through degree 6 --- matches the note\'s cited coefficients
$1,18,171,1140,5985,26334,100944,\ldots$ exactly. Degree/multiplicity read off the ordinary
series\' numerator at $t=1$: $e(R/I)=1+2+3+4+5+6+4+3+2+1=31$.

# Step 5: explicit regular sequence

Script: `code/regular_sequence_2x2_sixfold_commutator.sage`{.verbatim}

    found regular sequence:
       u2 + v1 - v3 + w1 + w2 - x1 - x2 + x3 + y1 - y2 - z1 - z2 + z3
       u1 - u2 + u3 - v2 - v3 + w1 - w2 + w3 - x1 - x2 - x3 - y1 + y2 + y3 - z3
       -u3 + v1 + v2 - v3 + w1 + w2 - x1 + x2 - x3 + y1 + y3 - z1 - z2
       -u1 + u2 - v2 - v3 - w1 + w2 - w3 + x1 + x3 + y3 + z1 - z2
       -u1 + u2 - v2 - v3 + w1 - w2 + w3 - x1 - x2 + x3 - y2 + y3 - z2 + z3
       -u1 - u2 - u3 - v1 + v3 - w2 - w3 - x2 + y1 + y3 - z1 - z2 - z3
       -u1 + u2 - u3 + v3 + w1 - w2 - w3 - x1 + x2 - y1 + y2 + z1 - z2
       -v1 + v2 + w1 + w2 + w3 + x3 + y1 - y2 - z3
       u1 + u3 + v1 + v2 + w3 + x1 - x2 + x3 - y1 - z2 + z3
       -u2 - v2 + w1 + w2 - w3 + x1 - x2 + x3 - y1 + y2 - y3 - z1 - z3
       u2 + u3 + v2 - v3 - w2 - w3 + x1 - x2 + x3 - y2 - y3 - z1
       -u1 - u2 + u3 + v2 - v3 + w2 + w3 + y2 - y3 + z1 + z2 + z3
       u1 - u2 + u3 - v1 + v2 - v3 - w1 + w2 + w3 + x1 + x2 - y1 - y3 - z1 - z3
       u3 - v2 + w2 - x1 + x2 + x3 - y1 + z1 - z3
       -u1 - u3 + v1 - w3 - x3 + y1 - y2 + y3 + z2 + z3
       u1 + u2 - u3 - v1 + v2 + w1 - w2 + w3 - x1 - x3 + y1 - y2 - z3

16 linear forms ($=\dim R/I$), verified by the script to cut $R/(I,\theta)$ to dimension 0 exactly;
automatically a regular sequence since $R/I$ is already known Cohen-Macaulay (Step 2).

# Summary of re-computed invariants

  invariant                   re-computed value                                                  matches original committed note?
  --------------------------- ------------------------------------------------------------------ ----------------------------------
  dim(R/I)                    16                                                                 yes
  ambient (reduced)           18                                                                 yes
  codim                       2                                                                  yes
  radical?                    yes                                                                yes
  minimal generators          3                                                                  yes
  pd(R/I)                     2                                                                  yes
  Cohen-Macaulay?             yes                                                                yes
  primary components          5                                                                  yes
  e(R/I)                      31                                                                 yes (1+2+3+4+5+6+4+3+2+1)
  primary decomp. wall time   \$≈\$59.4s (script timer) / \$≈\$60.4s (shell `time`{.verbatim})   yes (\$∼\$57s originally)

No discrepancies found against `working-notes/six-fold-commutator-n2.org`{.verbatim}.
