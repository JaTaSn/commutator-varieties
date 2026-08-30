# Jacobian rank 2 on every component --- raw verification output

Raw, verbatim output backing Step 5 of
[working-notes/proof-plan-conjectures.org](../working-notes/proof-plan-conjectures.org) --- the
$R_0$ half of the Serre-criterion ($R_0+S_1$) proof that $I_k$ is radical. Same role as the
other files here: `code/`{.verbatim} holds the script, this holds what it actually printed,
`working-notes/`{.verbatim} holds the interpretation.

Script:
[`code/verify_jacobian_rank_all_components.sage`{.verbatim}](../code/verify_jacobian_rank_all_components.sage).

What each numbered block means (see Step 5.6 of the proof-plan note for the full description):

- `[0]`{.verbatim} --- $I_k$ rebuilt both ways (chained `cross5`{.verbatim} vs. the $\tau$-recursion) and compared, so
  the Jacobian below is the Jacobian of the actual commutator generators.
- `[1]`{.verbatim} --- Lemma 5.3, $J_k=[\,-[v_k]_\times T J_{k-1}\mid[\tau(w_{k-1})]_\times\,]$, checked as an
  identity of **polynomial** matrices over $R_k$, not just at the witness points.
- `[2]`{.verbatim} --- Singular\'s primary decomposition of $I_k$, handed the `cross5`{.verbatim} generating set (Step 4.2
  of the proof-plan note records why the choice of generators matters enormously for wall time).
- `[3]`{.verbatim} --- the Proposition 5.5 witness for each component $C_j$: the point, the recipe branch that
  produced it, confirmation that $w_k$ vanishes there, the Jacobian rank computed two independent
  ways (numeric recursion vs. substitution into the symbolic derivative) and compared, and a check
  against `[2]`{.verbatim} that the point lies on **exactly one** component with the expected block involvement.
- `[4]`{.verbatim} --- the Remark 5.4 demonstration that the choice of $v_k$ in the inherited case is not
  cosmetic: at the first inherited case the \"just append zero columns\" reading gives rank 0, a
  nonzero but badly-chosen $v_k$ gives rank 1, and only $v_k\notin W_q$ gives the required 2.

Wall time for the full $k=2,\ldots,6$ run below, measured with `/usr/bin/time`{.verbatim} on jts-pc:
**62.2 seconds**, the bulk of it Singular\'s $k=6$ primary decomposition in `[2]`{.verbatim}. The run was
executed twice, and the two outputs are byte-identical through the end of the $k=6$ block.

# Full run, $k=2,\ldots,6$

`sage verify_jacobian_rank_all_components.sage 2 3 4 5 6`{.verbatim}

    ==============================================================================
    k = 2   (ambient A^{6}, expected codim 2, expected 1 components)
    ==============================================================================
    [0] I_k (cross5 chaining) == ideal(w_k) (tau-recursion)? True
    [1] base case k=2: J_2 = [ -[v_2]_x | [v_1]_x ] by direct differentiation
    [2] primary decomposition of I_k: 1 components (expect 1)
          comp 0: dim=4 blocks=[0, 1]
    [3] witness points and Jacobian ranks:
        component C_2  (blocks 0..1)
          point      = (1, 0, 0, 0, 0, 0)
          recipe     = (e_1, 0): base case, J_2 = [0 | [e_1]_x]
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [0]   (want exactly one, with blocks [0, 1])  OK
        ALL CHECKS PASSED for k = 2? True

    ==============================================================================
    k = 3   (ambient A^{9}, expected codim 2, expected 2 components)
    ==============================================================================
    [0] I_k (cross5 chaining) == ideal(w_k) (tau-recursion)? True
    [1] J_k == [ -[v_k]_x . T . J_{k-1} | [tau(w_{k-1})]_x ] as polynomial matrices? True
        (so the level-(k-1) columns are NOT inherited unchanged: they are hit by
         -[v_k]_x . T, which drops rank whenever v_k lies in T . im J_{k-1}.)
    [2] primary decomposition of I_k: 2 components (expect 2)
          comp 0: dim=7 blocks=[0, 1]
          comp 1: dim=7 blocks=[0, 1, 2]
    [3] witness points and Jacobian ranks:
        component C_2  (blocks 0..1)
          point      = (1, 0, 0, 0, 0, 0, 0, 1, 0)
          recipe     = (q, e_2) with q the level-2 witness; dim W_q = 2, e_2 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [0]   (want exactly one, with blocks [0, 1])  OK
        component C_3  (blocks 0..2)
          point      = (1, 0, 0, 0, 1, 0, 0, 0, 0)
          recipe     = (p, 0) with p the Lemma 4.2 point, w_{k-1}(p) != 0
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [1]   (want exactly one, with blocks [0, 1, 2])  OK
        ALL CHECKS PASSED for k = 3? True

    ==============================================================================
    k = 4   (ambient A^{12}, expected codim 2, expected 3 components)
    ==============================================================================
    [0] I_k (cross5 chaining) == ideal(w_k) (tau-recursion)? True
    [1] J_k == [ -[v_k]_x . T . J_{k-1} | [tau(w_{k-1})]_x ] as polynomial matrices? True
        (so the level-(k-1) columns are NOT inherited unchanged: they are hit by
         -[v_k]_x . T, which drops rank whenever v_k lies in T . im J_{k-1}.)
    [2] primary decomposition of I_k: 3 components (expect 3)
          comp 0: dim=10 blocks=[0, 1]
          comp 1: dim=10 blocks=[0, 1, 2]
          comp 2: dim=10 blocks=[0, 1, 2, 3]
    [3] witness points and Jacobian ranks:
        component C_2  (blocks 0..1)
          point      = (1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0)
          recipe     = (q, e_1) with q the level-3 witness; dim W_q = 2, e_1 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [0]   (want exactly one, with blocks [0, 1])  OK
        component C_3  (blocks 0..2)
          point      = (1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1)
          recipe     = (q, e_3) with q the level-3 witness; dim W_q = 2, e_3 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [1]   (want exactly one, with blocks [0, 1, 2])  OK
        component C_4  (blocks 0..3)
          point      = (1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0)
          recipe     = (p, 0) with p the Lemma 4.2 point, w_{k-1}(p) != 0
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [2]   (want exactly one, with blocks [0, 1, 2, 3])  OK
        ALL CHECKS PASSED for k = 4? True

    ==============================================================================
    k = 5   (ambient A^{15}, expected codim 2, expected 4 components)
    ==============================================================================
    [0] I_k (cross5 chaining) == ideal(w_k) (tau-recursion)? True
    [1] J_k == [ -[v_k]_x . T . J_{k-1} | [tau(w_{k-1})]_x ] as polynomial matrices? True
        (so the level-(k-1) columns are NOT inherited unchanged: they are hit by
         -[v_k]_x . T, which drops rank whenever v_k lies in T . im J_{k-1}.)
    [2] primary decomposition of I_k: 4 components (expect 4)
          comp 0: dim=13 blocks=[0, 1]
          comp 1: dim=13 blocks=[0, 1, 2]
          comp 2: dim=13 blocks=[0, 1, 2, 3]
          comp 3: dim=13 blocks=[0, 1, 2, 3, 4]
    [3] witness points and Jacobian ranks:
        component C_2  (blocks 0..1)
          point      = (1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0)
          recipe     = (q, e_2) with q the level-4 witness; dim W_q = 2, e_2 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [0]   (want exactly one, with blocks [0, 1])  OK
        component C_3  (blocks 0..2)
          point      = (1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1)
          recipe     = (q, e_3) with q the level-4 witness; dim W_q = 2, e_3 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [1]   (want exactly one, with blocks [0, 1, 2])  OK
        component C_4  (blocks 0..3)
          point      = (1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0)
          recipe     = (q, e_2) with q the level-4 witness; dim W_q = 2, e_2 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [2]   (want exactly one, with blocks [0, 1, 2, 3])  OK
        component C_5  (blocks 0..4)
          point      = (1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0)
          recipe     = (p, 0) with p the Lemma 4.2 point, w_{k-1}(p) != 0
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [3]   (want exactly one, with blocks [0, 1, 2, 3, 4])  OK
        ALL CHECKS PASSED for k = 5? True

    ==============================================================================
    k = 6   (ambient A^{18}, expected codim 2, expected 5 components)
    ==============================================================================
    [0] I_k (cross5 chaining) == ideal(w_k) (tau-recursion)? True
    [1] J_k == [ -[v_k]_x . T . J_{k-1} | [tau(w_{k-1})]_x ] as polynomial matrices? True
        (so the level-(k-1) columns are NOT inherited unchanged: they are hit by
         -[v_k]_x . T, which drops rank whenever v_k lies in T . im J_{k-1}.)
    [2] primary decomposition of I_k: 5 components (expect 5)
          comp 0: dim=16 blocks=[0, 1]
          comp 1: dim=16 blocks=[0, 1, 2]
          comp 2: dim=16 blocks=[0, 1, 2, 3]
          comp 3: dim=16 blocks=[0, 1, 2, 3, 4]
          comp 4: dim=16 blocks=[0, 1, 2, 3, 4, 5]
    [3] witness points and Jacobian ranks:
        component C_2  (blocks 0..1)
          point      = (1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0)
          recipe     = (q, e_1) with q the level-5 witness; dim W_q = 2, e_1 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [0]   (want exactly one, with blocks [0, 1])  OK
        component C_3  (blocks 0..2)
          point      = (1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1)
          recipe     = (q, e_3) with q the level-5 witness; dim W_q = 2, e_3 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [1]   (want exactly one, with blocks [0, 1, 2])  OK
        component C_4  (blocks 0..3)
          point      = (1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0)
          recipe     = (q, e_1) with q the level-5 witness; dim W_q = 2, e_1 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [2]   (want exactly one, with blocks [0, 1, 2, 3])  OK
        component C_5  (blocks 0..4)
          point      = (1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1)
          recipe     = (q, e_3) with q the level-5 witness; dim W_q = 2, e_3 not in W_q
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [3]   (want exactly one, with blocks [0, 1, 2, 3, 4])  OK
        component C_6  (blocks 0..5)
          point      = (1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0)
          recipe     = (p, 0) with p the Lemma 4.2 point, w_{k-1}(p) != 0
          w_k(point) = (0, 0, 0)   (in V(I_k)? True)
          numeric J_k == symbolic J_k at the point? True
          rank J_k(point) = 2   (want exactly 2 = codim)  OK
          lies on components [4]   (want exactly one, with blocks [0, 1, 2, 3, 4, 5])  OK
        ALL CHECKS PASSED for k = 6? True

    ==============================================================================
    [4] why the choice of v_k matters (k = 3, inherited component C_2)
    ==============================================================================
        level-2 witness q = (1, 0, 0, 0, 0, 0), rank J_2(q) = 2
        W_q = T . im J_2(q) has dimension 2, basis [(1, 0, 0), (0, 0, 1)]
          v_3 = 0            (the 'append zero columns' guess):  w_3 = (0, 0, 0), rank J_3 = 0
          v_3 = e_1  in W_q  (nonzero, but a bad direction):  w_3 = (0, 0, 0), rank J_3 = 1
          v_3 = e_3  in W_q  (nonzero, but a bad direction):  w_3 = (0, 0, 0), rank J_3 = 1
          v_3 = e_2  not in W_q  (what the recipe picks):  w_3 = (0, 0, 0), rank J_3 = 2
