# Raw computation log: \[A,B,C,D,E\] at n=2 (k=5), fresh re-run

Fresh re-execution of every script behind
[five-fold-commutator-n2.org](../working-notes/five-fold-commutator-n2.org) (and its successor
[iterated-commutator-n~2~-k~5~.org](../working-notes/iterated-commutator-n_2-k_5.org)), captured
verbatim. One block per step/script, run for real (Sage/Macaulay2 invoked live, stdout captured
below, nothing copied from the original note without re-executing). All numbers below match the
originally committed results exactly: dim(R/I)=13, codim 2, radical, 3 minimal generators,
Cohen-Macaulay, 4 primary components.

# Step 1a: numeric crosscheck of the 20-multiplication algorithm

Script: `code/verify_2x2_fivefold_commutator_numeric_crosscheck.sage`{.verbatim}

    ground truth G11,G12,G21: 55 -119 -87
    reduced-formula   G11,G12,G21: 55 -119 -87
    MATCH: True

# Step 1b: ring invariants (dim, codim, radical?) and minimal free resolution

Script: `code/ring_study_2x2_fivefold_commutator.sage`{.verbatim}

    total multiplications (5*4): 20
    dim(R/I): 13  ambient: 15  codim: 2
    I radical? True

    === minimal free resolution ===
         1     0     0
         0     0     0
         0     0     0
         0     0     0
         0     3     1
         0     0     0
         0     0     0
         0     0     1
    [1]:
       _[1]=4*u2*v1*w2*x1*y2-4*u1*v2*w2*x1*y2-2*u3*v2*w3*x1*y2+2*u2*v3*w3*x1*y2+4*u2*v1*w1*x2*y2-4*u1*v2*w1*x2*y2+2*u3*v1*w3*x2*y2-2*u1*v3*w3*x2*y2-2*u3*v2*w1*x2*y3+2*u2*v3*w1*x2*y3-2*u3*v1*w2*x2*y3+2*u1*v3*w2*x2*y3+2*u2*v1*w2*x3*y3-2*u1*v2*w2*x3*y3-u3*v2*w3*x3*y3+u2*v3*w3*x3*y3
       _[2]=2*u3*v2*w1*x2*y1-2*u2*v3*w1*x2*y1+2*u3*v1*w2*x2*y1-2*u1*v3*w2*x2*y1-2*u2*v1*w2*x3*y1+2*u1*v2*w2*x3*y1+u3*v2*w3*x3*y1-u2*v3*w3*x3*y1+2*u3*v2*w1*x1*y2-2*u2*v3*w1*x1*y2+2*u3*v1*w2*x1*y2-2*u1*v3*w2*x1*y2+2*u2*v1*w1*x3*y2-2*u1*v2*w1*x3*y2+u3*v1*w3*x3*y2-u1*v3*w3*x3*y2
       _[3]=4*u2*v1*w2*x1*y1-4*u1*v2*w2*x1*y1-2*u3*v2*w3*x1*y1+2*u2*v3*w3*x1*y1+4*u2*v1*w1*x2*y1-4*u1*v2*w1*x2*y1+2*u3*v1*w3*x2*y1-2*u1*v3*w3*x2*y1+2*u3*v2*w1*x1*y3-2*u2*v3*w1*x1*y3+2*u3*v1*w2*x1*y3-2*u1*v3*w2*x1*y3+2*u2*v1*w1*x3*y3-2*u1*v2*w1*x3*y3+u3*v1*w3*x3*y3-u1*v3*w3*x3*y3
    [2]:
       _[1]=y1*gen(1)-y2*gen(3)+y3*gen(2)
       _[2]=2*u3*v2*w1*x1*gen(1)-2*u2*v3*w1*x1*gen(1)-4*u2*v1*w2*x1*gen(2)+2*u3*v1*w2*x1*gen(1)+4*u1*v2*w2*x1*gen(2)-2*u1*v3*w2*x1*gen(1)+2*u3*v2*w3*x1*gen(2)-2*u2*v3*w3*x1*gen(2)-4*u2*v1*w1*x2*gen(2)+4*u1*v2*w1*x2*gen(2)+2*u3*v2*w1*x2*gen(3)-2*u2*v3*w1*x2*gen(3)+2*u3*v1*w2*x2*gen(3)-2*u1*v3*w2*x2*gen(3)-2*u3*v1*w3*x2*gen(2)+2*u1*v3*w3*x2*gen(2)+2*u2*v1*w1*x3*gen(1)-2*u1*v2*w1*x3*gen(1)-2*u2*v1*w2*x3*gen(3)+2*u1*v2*w2*x3*gen(3)+u3*v1*w3*x3*gen(1)+u3*v2*w3*x3*gen(3)-u1*v3*w3*x3*gen(1)-u2*v3*w3*x3*gen(3)
    [3]:
       _[1]=0
    [4]:
       _[1]=gen(1)
    [5]:
       _[1]=0
    [6]:
       _[1]=gen(1)
    [7]:
       _[1]=0
    [8]:
       _[1]=gen(1)
    [9]:
       _[1]=0
    [10]:
       _[1]=gen(1)
    [11]:
       _[1]=0
    [12]:
       _[1]=gen(1)
    [13]:
       _[1]=0

Reading of the resolution shape: ranks $1,3,1$ at homological degrees $0,1,2$ (interleaved zero
blocks are Singular\'s `mres`{.verbatim} padding, not extra steps) --- i.e.
$0\to R^2\to R^3\to R\to R/I\to0$ with exactly 3 minimal generators (the three degree-5 forms
above) and 2 first syzygies, $\mathrm{pd}(R/I)=2=\mathrm{codim}(I)\Rightarrow$ Cohen-Macaulay by
Auslander-Buchsbaum.

# Step 3: primary decomposition

Script: `code/ring_study_2x2_fivefold_commutator_primarydecomp.sage`{.verbatim}

    starting primary decomposition...
    number of primary components: 4
    component 0: dim=13, Q==Q.radical()? True
       num gens: 3  involves which blocks (u,v,w,x,y present?): [True, True, False, False, False]
    component 1: dim=13, Q==Q.radical()? True
       num gens: 3  involves which blocks (u,v,w,x,y present?): [True, True, True, False, False]
    component 2: dim=13, Q==Q.radical()? True
       num gens: 3  involves which blocks (u,v,w,x,y present?): [True, True, True, True, False]
    component 3: dim=13, Q==Q.radical()? True
       num gens: 3  involves which blocks (u,v,w,x,y present?): [True, True, True, True, True]

Fast (no noticeable wall-time cost at this $k$, unlike the \~57s seen at $k=6$).

# Step 4: Hilbert series, both gradings

Script: `code/hilbert_series_2x2_fivefold_commutator.m2`{.verbatim}

    dim, codim:
    13
    2
    5-graded Hilbert series (T0..T4 = u,v,w,x,y degree):
    1-3*T_0*T_1*T_2*T_3*T_4+T_0*T_1*T_2*T_3*T_4^2+T_0^2*T_1^2*T_2^2*T_3^2*T_4
    (1-T_4)^3*(1-T_3)^3*(1-T_2)^3*(1-T_1)^3*(1-T_0)^3
    ordinary Z-graded Hilbert series (independent check):
               2     3     4     5     6    7
    1 + 2T + 3T  + 4T  + 5T  + 3T  + 2T  + T
    -----------------------------------------
                           13
                    (1 - T)

Direct Taylor-coefficient specialization check of the 5-graded series (all $T_i\to t$) against the
ordinary series, computed independently (Python/sympy, not trusted from the formula shape alone):
expanding $\dfrac{1+2t+3t^2+4t^3+5t^4+3t^5+2t^6+t^7}{(1-t)^{13}}$ to order 7 gives
$1+15t+120t^2+680t^3+3060t^4+11625t^5+38716t^6+115935t^7+\cdots$ --- matches the note\'s cited
coefficients $1,15,120,680,3060,11625,38716,\ldots$ exactly.

# Step 5: explicit regular sequence

Script: `code/regular_sequence_2x2_fivefold_commutator.sage`{.verbatim}

    found, total nonzero terms: 119
       -u1 - u2 + u3 - v1 + v2 - v3 - w2 + w3 + x1 - x2 + x3 + y2
       u2 - v1 - v3 + w1 - w2 + x1 - y2 - y3
       u1 + u2 + v1 + w1 + w2 - x1 - x2 + x3 + y1
       u2 + u3 - v1 - v3 - w2 + w3 - x1 + y3
       u3 - w1 + x1 + x2 + x3 + y2
       u2 + u3 - v1 - v3 - w1 - w3 - x2 - y1
       u2 - u3 + v2 + w1 + w2 - x1 - x2 + y3
       u2 + v1 + v3 + w3 - x2 - x3 - y3
       u1 + u3 + v1 + v2 - w1 - w2 + w3 + x1 + x2 - x3 - y3
       -u1 - u2 - v2 + w3 + x1 - x2 + y2
       -u1 - u2 + u3 - v1 - v2 + v3 + w1 - w2 - x1 - x2 + x3 - y1 + y2 + y3
       u1 + u2 - u3 - v2 + v3 - w1 - w3 + x1 - x2 - x3 + y2 + y3
       u2 + u3 - v2 - v3 - w1 + w2 - x2 - x3 - y3

13 linear forms ($=\dim R/I$), verified by the script to cut $R/(I,\theta)$ to dimension 0
exactly; automatically a regular sequence since $R/I$ is already known Cohen-Macaulay (Step 2).

# Summary of re-computed invariants

  invariant            re-computed value   matches original committed note?
  -------------------- ------------------- ----------------------------------
  dim(R/I)             13                  yes
  codim                2                   yes
  radical?             yes                 yes
  minimal generators   3                   yes
  pd(R/I)              2                   yes
  Cohen-Macaulay?      yes                 yes
  primary components   4                   yes
  e(R/I)               21                  yes (1+2+3+4+5+3+2+1)

No discrepancies found against `working-notes/five-fold-commutator-n2.org`{.verbatim}.
