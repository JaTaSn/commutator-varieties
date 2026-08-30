#let theorem(..a) = { let p = a.pos(); [ ⟦THM|#p.at(0, default: "")⟧ ]; p.at(-1) ; [⟦END⟧] }
#let proposition(..a) = { let p = a.pos(); [ ⟦PRP|#p.at(0, default: "")⟧ ]; p.at(-1) ; [⟦END⟧] }
#let lemma(..a) = { let p = a.pos(); [ ⟦LEM|#p.at(0, default: "")⟧ ]; p.at(-1) ; [⟦END⟧] }
#let remark(..a) = { let p = a.pos(); [ ⟦REM|#p.at(0, default: "")⟧ ]; p.at(-1) ; [⟦END⟧] }
#let proof(..a) = { let p = a.pos(); [ ⟦PRF|#p.at(0, default: "")⟧ ]; p.at(-1) ; [⟦END⟧] }
#let definition(..a) = { let p = a.pos(); [ ⟦DEF|#p.at(0, default: "")⟧ ]; p.at(-1) ; [⟦END⟧] }
#let example(..a) = { let p = a.pos(); [ ⟦EXA|#p.at(0, default: "")⟧ ]; p.at(-1) ; [⟦END⟧] }
#let bcite(key, detail: none) = [#key]
#let vek(x) = $overline(#x)$
#let RR = $bb(R)$
#let QQ = $bb(Q)$
#let FF = $bb(F)$
#let AA = $bb(A)$
#let PP = $bb(P)$
// bibentry: the hand-rolled bibliography block. Emit a marker so the second
// pass can turn the whole run into a thebibliography or a .bib-driven list.
#let bibentry(key, body) = [ ⟦BIB|#key⟧ #body ⟦END⟧ ]
#let bibnum = (:)
#let problem(..a) = { let p = a.pos(); [ ⟦PRB|#p.at(0, default: "")⟧ ]; p.at(-1) ; [⟦END⟧] }
