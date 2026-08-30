# Raw computation log: \[A,B,C\] at n=2 (k=3), fresh re-run

Fresh re-execution of every script behind
[varieties-of-triple-commutators.org](../working-notes/varieties-of-triple-commutators.org) and
[A~B~\_C-commutator.org](../working-notes/A_B_C-commutator.org) (and their successor
[iterated-commutator-n~2~-k~3~.org](../working-notes/iterated-commutator-n_2-k_3.org)), captured
verbatim -- Sage/Macaulay2 invoked live, stdout captured below, nothing copied from the original
notes without re-executing. Two scripts genuinely new this session (filling a naming-convention
gap the $k=4,5,6$ notes already have, per the task that produced this file):
`code/verify_2x2_triple_commutator_numeric_crosscheck.sage`{.verbatim} and
`code/ring_study_2x2_triple_commutator_primarydecomp.sage`{.verbatim}. All numbers below match the originally
committed results exactly: $\dim(R/I)=7$, codim 2, radical, 3 minimal generators, Cohen-Macaulay,
2 primary components.

# Step 1a: the 10-multiplication chaining algorithm

Script: `code/verify_2x2_triple_commutator_10mult.sage`{.verbatim}

    Matches true [[A,B],C] exactly: True
    Total scalar multiplications used: 10

# Step 1b: numeric crosscheck (new script, fills the k=4/5/6 naming-convention gap)

Script: `code/verify_2x2_triple_commutator_numeric_crosscheck.sage`{.verbatim}

    ground truth E11,E12,E21: -2 -17 -19
    reduced-formula   E11,E12,E21: -2 -17 -19
    MATCH: True

# Step 1c: ring invariants (dim, codim, radical?)

Script: `code/ring_study_2x2_triple_commutator.sage`{.verbatim} (this single script also produces Steps 2 and
5\'s output below -- all one fresh run, split here by which battery step each part answers)

    dim(R/I): 7   codim: 2
    I is radical (I == I.radical()): True
    primary components, each == its own radical: [True, True]

# Step 2: minimal free resolution and Cohen-Macaulay check

Script: `code/ring_study_2x2_triple_commutator.sage`{.verbatim} (continued)

    === minimal free resolution (Singular mres, forced minimal) ===
         1     0     0
         0     0     0
         0     3     1
         0     0     1
    pd(R/I) = 2 (length of resolution above) = codim(I) = 2  =>  Cohen-Macaulay (Auslander-Buchsbaum)

Reading of the resolution shape: ranks $1,3,1$ at homological degrees $0,1,2$ -- i.e.
$0\to R^2\to R^3\to R\to R/I\to0$, exactly 3 minimal generators, 2 first syzygies,
$\mathrm{pd}(R/I)=2=\mathrm{codim}(I)\Rightarrow$ Cohen-Macaulay.

Cross-check in the literal $a_{ij},b_{ij},c_{ij}$ variables (not the reduced $u,v,w$ coordinates),
confirming the same minimal-generator count and Betti shape independently:

Script: `code/verify_2x2_triple_commutator_minimal_generators.sage`{.verbatim}

    E11 = -a21*b11*c12 + a11*b21*c12 - a22*b21*c12 + a21*b22*c12 - a12*b11*c21 + a11*b12*c21 - a22*b12*c21 + a12*b22*c21
    E12 = a12*b11*c11 - a11*b12*c11 + a22*b12*c11 - a12*b22*c11 - 2*a21*b12*c12 + 2*a12*b21*c12 - a12*b11*c22 + a11*b12*c22 - a22*b12*c22 + a12*b22*c22
    E21 = a21*b11*c11 - a11*b21*c11 + a22*b21*c11 - a21*b22*c11 + 2*a21*b12*c21 - 2*a12*b21*c21 - a21*b11*c22 + a11*b21*c22 - a22*b21*c22 + a21*b22*c22
    E22 == -E11: True
    Krull dim R/I: 10
         1     0     0
         0     0     0
         0     3     1
         0     0     1

(Krull dim 10 here is the full ambient-$a_{ij}$-variable picture, $9+3$ = reduced-dim-7 $+3$ free
trace directions $+$ ... consistent with the reduced computation\'s dim 7 once the 3 trace
directions are accounted for, exactly as documented in the original note.)

# Step 3: primary decomposition (new standalone script, matching k=4/5/6 naming)

Script: `code/ring_study_2x2_triple_commutator_primarydecomp.sage`{.verbatim}

    number of primary components: 2
    component 0: dim=7, Q==Q.radical()? True
       generators: [u3*v2 - u2*v3, u3*v1 - u1*v3, u2*v1 - u1*v2]
    component 1: dim=7, Q==Q.radical()? True
       generators: [2*v2*w1 + 2*v1*w2 + v3*w3, 2*u2*w1 + 2*u1*w2 + u3*w3, 2*u2*v1*w2 - 2*u1*v2*w2 - u3*v2*w3 + u2*v3*w3]

Exactly $k-1=2$ components, matching the conjecture later tracked across $k=4,5,6$: component 0 is
\"$[A,B]=0$\" ($A,B$ commute, involves only blocks $u,v$); component 1 is the generic stratum
\"$[A,B]$ commutes with $C$\" (involves $u,v,w$).

# Step 4: Hilbert series, both gradings

Script: `code/ring_study_2x2_triple_commutator.m2`{.verbatim}

    dim(R/I), codim(I):
    7
    2
    3-graded (Z^3) Hilbert series -- T_0=u-degree, T_1=v-degree, T_2=w-degree:
    1-3*T_0*T_1*T_2+T_0*T_1*T_2^2+T_0^2*T_1^2*T_2
    (1-T_2)^3*(1-T_1)^3*(1-T_0)^3
    ordinary Z-graded Hilbert series (independent computation, plain grading):
               2    3
    1 + 2T + 3T  + T
    -----------------
                7
         (1 - T)

# Step 5: explicit regular sequence

Script: `code/ring_study_2x2_triple_commutator.sage`{.verbatim} (continued, same run as Steps 1c/2)

    === an explicit regular sequence (7 linear forms, small coefficients) ===
    dim(R/(I,theta)): 0 (0 confirms a valid h.s.o.p., hence -- since R/I is CM -- a genuine regular sequence)

7 linear forms ($=\dim R/I$), verified by the script to cut $R/(I,\theta)$ to dimension 0 exactly;
automatically a regular sequence since $R/I$ is already known Cohen-Macaulay (Step 2). The explicit
$\theta$ itself is quoted in `code/ring_study_2x2_triple_commutator.sage`{.verbatim} and in
[varieties-of-triple-commutators.org](../working-notes/varieties-of-triple-commutators.org) (not
re-quoted here since the script\'s stdout above only prints the resulting dimension, not $\theta$
itself -- see the script source for the exact linear forms).

# Additional scripts re-run (image variety / projective structure; not part of the strict 6-step

battery, but part of the full k=3 picture and explicitly listed as \"existing k=3 code\")

## Target expansion (feeds the rank-search thread, TODO.org)

Script: `code/expand_2x2_triple_commutator_target.sage`{.verbatim}

    E11 = u3*v2*w1 - u2*v3*w1 + u3*v1*w2 - u1*v3*w2
    E12 = -2*u2*v1*w1 + 2*u1*v2*w1 - u3*v1*w3 + u1*v3*w3
    E21 = 2*u2*v1*w2 - 2*u1*v2*w2 - u3*v2*w3 + u2*v3*w3
    saved target.json, 27-dim vectors per output

## Image/zero-locus analysis (dimension, primary decomposition, Jacobian rank)

Script: `code/analyze_2x2_triple_commutator_varieties.sage`{.verbatim}

    Krull dimension of R/I (9 ambient vars): 7
    number of primary components: 2
    component 0: dim=7, gens=[u3*v2 - u2*v3, u3*v1 - u1*v3, u2*v1 - u1*v2]
    component 1: dim=7, gens=[2*v2*w1 + 2*v1*w2 + v3*w3, 2*u2*w1 + 2*u1*w2 + u3*w3, 2*u2*v1*w2 - 2*u1*v2*w2 - u3*v2*w3 + u2*v3*w3]
    Jacobian rank at a generic test point: 3

## Projective-dimension cross-check

Script: `code/verify_2x2_triple_commutator_projective_dimension.sage`{.verbatim}

    u3*v2*w1 - u2*v3*w1 + u3*v1*w2 - u1*v3*w2 -> u-deg {1} v-deg {1} w-deg {1}
    -2*u2*v1*w1 + 2*u1*v2*w1 - u3*v1*w3 + u1*v3*w3 -> u-deg {1} v-deg {1} w-deg {1}
    2*u2*v1*w2 - 2*u1*v2*w2 - u3*v2*w3 + u2*v3*w3 -> u-deg {1} v-deg {1} w-deg {1}
    affine dim(R/I) per component: [7, 7]
    dim in chart u1=v1=w1=1 (= P^2 x P^2 x P^2 dimension) per component: [4, 4]

## Surjectivity witness (explicit construction hitting an arbitrary target)

Script: `code/verify_2x2_triple_commutator_surjectivity_witness.sage`{.verbatim}

    A = [1 0]
    [0 0]
    B = [ 0 -2]
    [-3  0]
    C = [   1    0]
    [-1/2    0]
    D=[A,B] = [ 0 -2]
    [ 3  0]
    E=[[A,B],C] = [ 1  2]
    [ 3 -1]
    OK: matches target (E11,E12,E21,E22)=(1,2,3,-1) exactly

# Summary of re-computed invariants

  invariant              re-computed value   matches original committed note?
  ---------------------- ------------------- ----------------------------------
  mult. count (10mult)   10                  yes
  dim(R/I)               7                   yes
  codim                  2                   yes
  radical?               yes                 yes
  minimal generators     3                   yes
  pd(R/I)                2                   yes
  Cohen-Macaulay?        yes                 yes
  primary components     2                   yes
  e(R/I)                 7                   yes (1+2+3+1)

No discrepancies found against
[varieties-of-triple-commutators.org](../working-notes/varieties-of-triple-commutators.org) or
[A~B~\_C-commutator.org](../working-notes/A_B_C-commutator.org).
