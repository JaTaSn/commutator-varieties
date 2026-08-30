# \[A,B,C,D\] at n=2 (k=4) --- raw re-run output, 2026-08-16

Verbatim stdout from a fresh, independent re-run of every script behind
`working-notes/iterated-commutator-n_2-k_4.org`{.verbatim} (itself matching the earlier
`working-notes/four-fold-commutator-n2.org`{.verbatim}). Environment: SageMath 10.9, Macaulay2 1.26.06, run
2026-08-16 \~12:00-12:20. Every number below matches the originally committed note exactly --- no
discrepancies found. One extra ad hoc verification (Hilbert-series specialization Taylor-coefficient
check) is included at the end of Step 4\'s block since the original note reports doing this but no
dedicated script for it exists among the seven listed in the task.

# Step 1a: 15-multiplication algorithm --- code/verify~2x2~\_fourfold~commutator~\_15mult.sage

    total multiplications used (5+5+5): 15

    F11 = -2*u2*v1*w2*x1 + 2*u1*v2*w2*x1 + u3*v2*w3*x1 - u2*v3*w3*x1 - 2*u2*v1*w1*x2 + 2*u1*v2*w1*x2 - u3*v1*w3*x2 + u1*v3*w3*x2

    F12 = 2*u3*v2*w1*x1 - 2*u2*v3*w1*x1 + 2*u3*v1*w2*x1 - 2*u1*v3*w2*x1 + 2*u2*v1*w1*x3 - 2*u1*v2*w1*x3 + u3*v1*w3*x3 - u1*v3*w3*x3

    F21 = -2*u3*v2*w1*x2 + 2*u2*v3*w1*x2 - 2*u3*v1*w2*x2 + 2*u1*v3*w2*x2 + 2*u2*v1*w2*x3 - 2*u1*v2*w2*x3 - u3*v2*w3*x3 + u2*v3*w3*x3

    num vars: 12  dim(R/I): 10  codim: 2

# Step 1b: ground-truth via literal genericMatrix multiplication (M2, 16-var) --- code/verify~2x2~\_fourfold~commutator~\_groundtruth.m2

    F11 (M2, literal matrix mult):
    a21*b11*c11*d12-a11*b21*c11*d12+a22*b21*c11*d12-a21*b22*c11*d12+2*a21*b12*c21*d12-2*a12*b21*c21*d12-a21*b11*c22*d12+a11*b21*c22*d12-a22*b21*c22*d12+a21*b22*c22*d12-a12*b11*c11*d21+a11*b12*c11*d21-a22*b12*c11*d21+a12*b22*c11*d21+2*a21*b12*c12*d21-2*a12*b21*c12*d21+a12*b11*c22*d21-a11*b12*c22*d21+a22*b12*c22*d21-a12*b22*c22*d21
    F12:
    -a21*b11*c11*d11+a11*b21*c11*d11-a22*b21*c11*d11+a21*b22*c11*d11-2*a21*b12*c21*d11+2*a12*b21*c21*d11+a21*b11*c22*d11-a11*b21*c22*d11+a22*b21*c22*d11-a21*b22*c22*d11-2*a21*b11*c12*d21+2*a11*b21*c12*d21-2*a22*b21*c12*d21+2*a21*b22*c12*d21-2*a12*b11*c21*d21+2*a11*b12*c21*d21-2*a22*b12*c21*d21+2*a12*b22*c21*d21+a21*b11*c11*d22-a11*b21*c11*d22+a22*b21*c11*d22-a21*b22*c11*d22+2*a21*b12*c21*d22-2*a12*b21*c21*d22-a21*b11*c22*d22+a11*b21*c22*d22-a22*b21*c22*d22+a21*b22*c22*d22
    F21:
    a12*b11*c11*d11-a11*b12*c11*d11+a22*b12*c11*d11-a12*b22*c11*d11-2*a21*b12*c12*d11+2*a12*b21*c12*d11-a12*b11*c22*d11+a11*b12*c22*d11-a22*b12*c22*d11+a12*b22*c22*d11+2*a21*b11*c12*d12-2*a11*b21*c12*d12+2*a22*b21*c12*d12-2*a21*b22*c12*d12+2*a12*b11*c21*d12-2*a11*b12*c21*d12+2*a22*b12*c21*d12-2*a12*b22*c21*d12-a12*b11*c11*d22+a11*b12*c11*d22-a22*b12*c11*d22+a12*b22*c11*d22+2*a21*b12*c12*d22-2*a12*b21*c12*d22+a12*b11*c22*d22-a11*b12*c22*d22+a22*b12*c22*d22-a12*b22*c22*d22
    F22 == -F11?
    true

Dimension/codimension of the literal 16-variable ideal $J=(F_{11},F_{12},F_{21})$ (not printed by
the original script itself --- computed here with a small supplementary M2 snippet, same
`genericMatrix`{.verbatim} construction):

    dim J (i.e. dim R/J):
    14
    codim J:
    2

# Step 1c: numeric cross-check --- code/verify~2x2~\_fourfold~commutator~\_numeric~crosscheck~.sage

    ground truth F11,F12,F21: -17 51 -53
    reduced-formula   F11,F12,F21: -17 51 -53
    MATCH: True

# Step 2: basic ring invariants + minimal free resolution --- code/ring~study~\_2x2~fourfold~\_commutator.sage

    dim(R/I): 10  codim: 2
    I radical? True
         1     0     0
         0     0     0
         0     0     0
         0     3     1
         0     0     0
         0     0     1
    [1]:
       _[1]=2*u3*v2*w1*x2-2*u2*v3*w1*x2+2*u3*v1*w2*x2-2*u1*v3*w2*x2-2*u2*v1*w2*x3+2*u1*v2*w2*x3+u3*v2*w3*x3-u2*v3*w3*x3
       _[2]=2*u2*v1*w2*x1-2*u1*v2*w2*x1-u3*v2*w3*x1+u2*v3*w3*x1+2*u2*v1*w1*x2-2*u1*v2*w1*x2+u3*v1*w3*x2-u1*v3*w3*x2
       _[3]=2*u3*v2*w1*x1-2*u2*v3*w1*x1+2*u3*v1*w2*x1-2*u1*v3*w2*x1+2*u2*v1*w1*x3-2*u1*v2*w1*x3+u3*v1*w3*x3-u1*v3*w3*x3
    [2]:
       _[1]=x1*gen(1)-x2*gen(3)+x3*gen(2)
       _[2]=2*u2*v1*w1*gen(1)-2*u1*v2*w1*gen(1)-2*u3*v2*w1*gen(2)+2*u2*v3*w1*gen(2)+2*u2*v1*w2*gen(3)-2*u3*v1*w2*gen(2)-2*u1*v2*w2*gen(3)+2*u1*v3*w2*gen(2)+u3*v1*w3*gen(1)-u3*v2*w3*gen(3)-u1*v3*w3*gen(1)+u2*v3*w3*gen(3)
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

Wall time: 1.4s. Betti table shows 3 minimal generators in homological degree 0 and 2 first syzygies
in degree 1, with the resolution provably terminating at position 3 (`mres`{.verbatim} printed in full,
consistent with the earlier discipline of not trusting the `betti()`{.verbatim} summary alone) --- i.e.
$\mathrm{pd}(R/I)=2=\mathrm{codim}(I)\Rightarrow$ Cohen-Macaulay.

# Step 3: primary decomposition --- code/ring~study~\_2x2~fourfold~\_commutator~primarydecomp~.sage

    number of primary components: 3
    component 0: dim=10, Q==Q.radical()? True
       generators: [u3*v2 - u2*v3, u3*v1 - u1*v3, u2*v1 - u1*v2]
    component 1: dim=10, Q==Q.radical()? True
       generators: [2*v2*w1 + 2*v1*w2 + v3*w3, 2*u2*w1 + 2*u1*w2 + u3*w3, 2*u2*v1*w2 - 2*u1*v2*w2 - u3*v2*w3 + u2*v3*w3]
    component 2: dim=10, Q==Q.radical()? True
       generators: [2*w2*x1 + 2*w1*x2 + w3*x3, u3*v2*x1 - u2*v3*x1 - u3*v1*x2 + u1*v3*x2 + u2*v1*x3 - u1*v2*x3, 2*u3*v2*w1*x2 - 2*u2*v3*w1*x2 + 2*u3*v1*w2*x2 - 2*u1*v3*w2*x2 - 2*u2*v1*w2*x3 + 2*u1*v2*w2*x3 + u3*v2*w3*x3 - u2*v3*w3*x3]

Wall time: 1.1s (negligible at this chain length, unlike the \~57s seen at k=6). Component 0
generators are byte-for-byte the plain commuting-variety generators ($u,v$ only, $w,x$ free);
component 1 generators are byte-for-byte the $k=3$ case\'s own \"component B\" ($u,v,w$ only,
$x$ free); component 2 is the new generic stratum, involving all four blocks.

# Step 4: Hilbert series, both gradings --- code/hilbert~series~\_2x2~fourfold~\_commutator.m2

    dim, codim:
    10
    2
    4-graded Hilbert series (T0=u,T1=v,T2=w,T3=x degree):
    1-3*T_0*T_1*T_2*T_3+T_0*T_1*T_2*T_3^2+T_0^2*T_1^2*T_2^2*T_3
    (1-T_3)^3*(1-T_2)^3*(1-T_1)^3*(1-T_0)^3
    ordinary Z-graded Hilbert series (independent, plain grading):
               2     3     4    5
    1 + 2T + 3T  + 4T  + 2T  + T
    -----------------------------
                     10
              (1 - T)

Wall time: 0.6s. Supplementary specialization cross-check (not one of the seven listed scripts ---
reproduced ad hoc here since the original note reports doing this check but no dedicated script for
it exists in `code/`{.verbatim}): setting $T_0=T_1=T_2=T_3=t$ in the 4-graded numerator/denominator
$(1-3t^4+t^5+t^7)/(1-t)^{12}$ and comparing its Taylor expansion against the ordinary series
$(1+2t+3t^2+4t^3+2t^4+t^5)/(1-t)^{10}$, computed independently in Sage:

    sage: R.<t> = PowerSeriesRing(QQ, default_prec=25)
    sage: num_ord = 1 + 2*t + 3*t^2 + 4*t^3 + 2*t^4 + t^5
    sage: ord_series = num_ord / (1-t)^10
    sage: num_4g = 1 - 3*t^4 + t^5 + t^7
    sage: g4_series = num_4g / (1-t)^12
    sage: ord_series.list()[:20]
    [1, 12, 78, 364, 1362, 4333, 12154, 30811, 71863, 156299, 320320, 623701, 1161524, 2080222, 3599036, 6038162, 9855053, 15690542, 24426666, 37258298]
    sage: g4_series.list()[:20]
    [1, 12, 78, 364, 1362, 4333, 12154, 30811, 71863, 156299, 320320, 623701, 1161524, 2080222, 3599036, 6038162, 9855053, 15690542, 24426666, 37258298]
    sage: ord_series.list()[:20] == g4_series.list()[:20]
    True

Exact match, and identical to the sequence reported in the originally committed note.

# Step 5: explicit regular sequence --- code/regular~sequence~\_2x2~fourfold~\_commutator.sage

    best found, total nonzero terms: 59
       v1 - v2 + w1 + x2
       u1 - v1 - v2 - w3 - x3
       u2 + u3 - w1 - w2 + w3 - x2 + x3
       -u1 + v2 + w2 + w3 + x2 + x3
       -v1 + v2 + w1 - w2 + x2 + x3
       -u1 + u2 - v2 - w2 + x3
       -u1 + v1 - v2 + v3 - w2 + x2
       u1 - u2 - v2 - w2 - w3 - x1 + x2
       -u1 + u3 - v2 - w1 - w2 + w3
       u2 + u3 + v1 - v3 - w2 - x2 - x3

Wall time: 1.4s. The search is randomized (no fixed seed in the script) and this run\'s regular
sequence differs term-by-term from the one recorded in the original note --- expected, not a
discrepancy: the script only guarantees **some** valid homogeneous system of parameters (verified
internally to cut $R/(I,\theta)$ to dimension 0) among small $\{-1,0,1\}$-coefficient trials,
with no claim of uniqueness or determinism. Since $R/I$ is already known Cohen-Macaulay (Step 2),
this is automatically a regular sequence.

# Summary: all re-computed invariants match the originally committed note exactly

  invariant                           original (four-fold-commutator-n2.org)                this re-run
  ----------------------------------- ----------------------------------------------------- -------------
  multiplications                     15                                                    15
  $\dim(R/I)$ (reduced, 12-var)       10                                                    10
  codim                               2                                                     2
  $I$ radical?                        yes                                                   yes
  minimal generators                  3                                                     3
  $\mathrm{pd}(R/I)$                  2                                                     2
  Cohen-Macaulay?                     yes                                                   yes
  native 16-var ideal: dim, codim     14, 2                                                 14, 2
  primary components                  3                                                     3
  ordinary Hilbert series numerator   $1+2t+3t^2+4t^3+2t^4+t^5$                             identical
  $e(R/I)$                            13                                                    13
  4-graded Hilbert series numerator   $1-3T_0T_1T_2T_3+T_0T_1T_2T_3^2+T_0^2T_1^2T_2^2T_3$   identical

No discrepancies found anywhere.
