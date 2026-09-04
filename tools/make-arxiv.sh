#!/bin/bash
# Build the arXiv upload bundle from the Typst source, in one command.
#
# Changelog (reverse-chronological)
#   2026-09-01  Created.  Assembles article/arxiv/main.tex as a SINGLE
#               self-contained file -- documentclass + preamble + front matter +
#               converted body + bibliography -- because one file is the least
#               fragile thing to hand to arXiv, and builds it with xelatex.
#               arXiv's TeX Live does run xelatex, so fontspec (which
#               article/preamble.tex needs) is fine.
#
# Inputs, all tracked:
#   article/ring-of-k-commuting-2x2-matrices.typ   canonical source, never edited
#   article/preamble.tex                            all typography
#   article/frontmatter.tex                         title/author/ORCID/abstract
#   tools/typ2tex.sh + typst-stubs.typ + markers2env.py + fig-phi-y2.tex
#
# Output:
#   article/arxiv/main.tex, main.pdf   (plus xelatex's own aux/log files)
#
# Usage:  tools/make-arxiv.sh          # from anywhere in the repo
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
ART="$ROOT/article"
OUT="$ART/arxiv"
SRC="$ART/ring-of-k-commuting-2x2-matrices.typ"

mkdir -p "$OUT"

echo "==> Typst -> LaTeX body"
"$HERE/typ2tex.sh" "$SRC" > "$OUT/.body.tex"

echo "==> assembling main.tex"
{
  cat <<'HEADER'
% main.tex -- GENERATED, do not edit.  Regenerate with tools/make-arxiv.sh.
%
% Assembled from, in order:
%   article/preamble.tex        (typography; edit there)
%   article/frontmatter.tex     (title block and abstract; edit there)
%   the Typst source, converted by tools/typ2tex.sh
%
% Build:  xelatex main.tex  (twice, for cross-references and citations)
\documentclass[11pt,a4paper]{scrartcl}
HEADER
  cat "$ART/preamble.tex"
  echo
  echo '\begin{document}'
  echo
  cat "$ART/frontmatter.tex"
  echo
  cat "$OUT/.body.tex"
  echo
  echo '\end{document}'
  # File-local variables, so opening the generated main.tex in Emacs picks the
  # right engine without anyone having to remember.  Must follow \end{document};
  # added 2026-09-03 from an edit Jan had made in the generated file itself.
  echo
  echo '% Local Variables:'
  echo '% TeX-engine: xetex'
  echo '% End:'
} > "$OUT/main.tex"
rm -f "$OUT/.body.tex"

echo "==> ancillary files"
# The manuscript names computer-algebra scripts by path, at the point of use.
# Those names are only worth printing if a reader can actually get the files, so
# they ship as arXiv ancillary files.  arXiv never compiles anything under anc/
# -- its own rule is that no TeX file may appear there, and none does.
#
# Rebuilt from scratch every run: a script renamed in the manuscript must not
# leave its old copy sitting in the bundle, which is the failure a plain "copy
# if missing" would produce.
rm -rf "$OUT/anc"
mkdir -p "$OUT/anc/code" "$OUT/anc/runs"

# The script list is DERIVED from the manuscript's own citations rather than
# kept by hand here.  A hand list drifts the moment a citation is added or a
# file renamed, and the failure is silent in the worst way: a reader follows a
# filename that is not in the tarball.  Deriving it also buys the reverse check
# for free -- a citation to a file that does not exist becomes a build failure.
#
# The source writes them Typst-escaped (code/verify\_over\_finite\_fields.sage),
# hence the tr.
mapfile -t CITED < <(grep -oP 'code/[A-Za-z0-9_\\]+\.(sage|m2|py)' "$SRC" | tr -d '\\' | sort -u)
if [ "${#CITED[@]}" -eq 0 ]; then
  echo "FAIL: no code/ citations found in $SRC -- has the citation style changed?" >&2
  exit 1
fi
for f in "${CITED[@]}"; do
  if [ ! -f "$ROOT/$f" ]; then
    echo "FAIL: the manuscript cites $f, which does not exist." >&2
    exit 1
  fi
  cp "$ROOT/$f" "$OUT/anc/code/"
done
# runs/ ships whole.  The script -> transcript naming follows two different
# conventions (verify_generator_independence.sage -> generator-independence-
# results.txt, but verify_over_finite_fields.sage -> verify-over-finite-
# fields.txt), so any derived mapping would be fragile for no gain: the whole
# directory is a couple of hundred kilobytes and carries its own README.
cp "$ROOT"/runs/* "$OUT/anc/runs/"

echo "==> xelatex (pass 1/2)"
(cd "$OUT" && xelatex -interaction=nonstopmode main.tex >/dev/null) || true
echo "==> xelatex (pass 2/2)"
(cd "$OUT" && xelatex -interaction=nonstopmode main.tex >/dev/null) || true

echo
echo "==> report"
cd "$OUT"
printf '  errors ................ %s\n' "$(grep -c '^!' main.log || true)"
printf '  undefined references .. %s\n' \
  "$(grep -c 'LaTeX Warning: Reference .* undefined' main.log || true)"
printf '  undefined citations ... %s\n' \
  "$(grep -c 'LaTeX Warning: Citation .* undefined' main.log || true)"
printf '  \\bibitem ............... %s\n' "$(grep -o '\\bibitem{' main.tex | wc -l)"
printf '  \\cite .................. %s\n' "$(grep -o '\\cite[[{]' main.tex | wc -l)"
# backtick check is body-only: preamble.tex legitimately contains `\sfcode`\.`
# and the string `thebibliography', neither of which is an apostrophe artefact.
printf '  lone backticks (body) . %s\n' \
  "$(sed -n '/^\\begin{document}/,$p' main.tex | grep -oP '(?<!`)`(?!`)' | wc -l)"
sed -n '/^\\begin{document}/,$p' main.tex > .body-only
printf '  quotes ................ %s opening / %s closing (must be equal)\n' \
  "$(grep -o '``' .body-only | wc -l)" "$(grep -o "''" .body-only | wc -l)"
printf '  boxed environments .... %s\n' \
  "$(grep -oE '\\begin\{(theorem|proposition|lemma|remark|definition|example|problem|question)\}' .body-only | wc -l)"
printf '  figure (tikzpicture) .. %s\n' "$(grep -c 'begin{tikzpicture}' main.tex)"
printf '  overfull hboxes ....... %s\n' "$(grep -c 'Overfull \\hbox' main.log || true)"
printf '  pages ................. %s\n' "$(pdfinfo main.pdf 2>/dev/null | awk '/^Pages/{print $2}')"

# ---- pandoc semicolon-eating guard ---------------------------------------
# pandoc's Typst reader treats a ";" directly after a #-expression as a
# statement terminator and SILENTLY DROPS IT: "#emph[mathlib]; this" converts to
# "\emph{mathlib} this".  A comma survives, a semicolon does not, and nothing
# warns.  Cost one sentence in the Acknowledgements before it was noticed by
# reading the rendered page.  Markup emphasis is immune, so write "_x_;".
if grep -nE '#(emph|text|strong)\[[^]]*\];' "$SRC"; then
  echo >&2
  echo "FAIL: '#expr[...];' in the Typst -- pandoc drops the semicolon." >&2
  echo "      Use markup emphasis instead: _x_;" >&2
  exit 1
fi

# ---- stray-linebreak guard ------------------------------------------------
# In Typst MATH, "\ " is a LINE BREAK, not a thin space.  Written inside a tuple
# it silently stacks the thing vertically:
#
#     Phi(p,\ lambda S(w))   typesets as   (p,
#                                               lambda S(w))
#
# and nothing warns, in either build route.  This bit three times in this one
# manuscript: eqn 1 (Jan, reading the PDF, 2026-09-03), then eqns 23 and 33,
# which survived that fix because it repaired the one site rather than sweeping.
# Hence a guard instead of a fourth repair.
#
# Done in Python, not grep: math spans run across lines here, so a line-oriented
# check misses exactly the case that bit (eqn 33's "$" opened on the line above).
# A backslash at END of line is the legitimate alignment break -- Example 7's
# A/B/C list uses it -- so only mid-line "\ " followed by more content counts.
if ! python3 - "$SRC" <<'PYEOF'
import re, sys
src = open(sys.argv[1]).read()
body = src.split("\n", 206)[-1] if src.count("\n") > 206 else src
bad = []
for m in re.finditer(r"\$.*?\$", body, flags=re.S):
    span = m.group(0)
    for mm in re.finditer(r"\\ (?=\S)", span):
        line = body[: m.start()].count("\n") + span[: mm.start()].count("\n") + 207
        bad.append((line, " ".join(span.split())[:100]))
if bad:
    for line, ctx in bad:
        print("  line ~%d:  %s" % (line, ctx), file=sys.stderr)
    sys.exit(1)
sys.exit(0)
PYEOF
then
  echo >&2
  echo "FAIL: '\ ' used mid-line inside math (offending spans above)." >&2
  echo "      In Typst that is a LINE BREAK, not a thin space: it stacks tuples" >&2
  echo "      vertically.  Use a plain space, or 'thin' for a real thin space." >&2
  exit 1
fi
printf '  stray linebreaks ...... none\n'

# ---- internal-matter guard ------------------------------------------------
# The front matter in article/frontmatter.tex is transcribed BY HAND from the
# Typst, so it is a second copy and can drift -- it did, within a day of being
# written: the title footnote still advertised the "theorion" package (false in
# this build, which uses tcolorbox), a /TRASH path inside Jan's workspace, and
# pointers to working notes the reader cannot obtain.  Jan caught it by reading
# page 1.
#
# Guarding the SOURCE would miss it, because the drift can live in either copy.
# Guard the BUILT PDF instead: whatever the route in, internal scaffolding must
# not reach a submission.  Comments in the sources are fine -- they do not
# render -- which is why this greps the PDF text and not the .tex.
# NB "working note" is on this list on purpose and should stay: the failure it
# guards against is a pointer to a note the reader cannot obtain.  If the prose
# legitimately needs to DESCRIBE the practice of keeping such notes -- as the
# Methods section now does -- reword it ("short standalone notes") rather than
# loosening the pattern.  Weakening a guard to admit one true sentence is how
# guards stop catching the false ones.
INTERNAL='theorion|/TRASH|[Ww]orking draft|not distributed|workspace top level|working note'
if pdftotext main.pdf - 2>/dev/null | grep -inE "$INTERNAL"; then
  echo
  echo "FAIL: internal working matter reached the built PDF (matches above)." >&2
  echo "      Fix the .typ and mirror it into article/frontmatter.tex." >&2
  exit 1
fi
printf '  internal matter ....... none\n'

# ---- macro-leakage guard --------------------------------------------------
# A macro NAME that reaches the rendered page means a substitution ran in
# markup mode, where "signtwist()" is literal text rather than a call.  It is
# only a call inside $...$.
#
# Cost, 2026-09-03: the D -> S rename (commit 26b6a25) was applied textually and
# hit two author initials inside #bibentry bodies, so reference [2] credited
# "signtwist().G. Northcott" and [4] cited "signtwist(). Eisenbud" -- on the
# printed page of BOTH routes, undetected for a day.  Neither existing guard
# could see it: the strings are legitimate prose to the semicolon guard, and
# contain none of the internal-matter patterns above.
#
# Same principle as the guard directly above: check the BUILT PDF, because the
# defect can enter from either the .typ or article/frontmatter.tex.
LEAKED='signtwist\(|vek\(|bcite\(|bibentry\(|#emph\[|#text\['
if pdftotext main.pdf - 2>/dev/null | grep -nE "$LEAKED"; then
  echo
  echo "FAIL: a source macro name reached the built PDF (matches above)." >&2
  echo "      A macro is only a call inside \$...\$; in markup it is literal text." >&2
  exit 1
fi
printf '  macro leakage ......... none\n'

# SUBMISSION-FIELDS.txt is hand-authored, not generated, and holds a second copy
# of the title, abstract and MSC.  That makes it drift-prone in exactly the way
# frontmatter.tex already is.  A warning, not a failure: it is not part of the
# build, and a stale copy is only a problem at submission time.
if [ -f "$OUT/SUBMISSION-FIELDS.txt" ] && [ "$SRC" -nt "$OUT/SUBMISSION-FIELDS.txt" ]; then
  printf '  submission fields ..... STALE (source is newer -- re-check title/abstract/MSC)\n'
else
  printf '  submission fields ..... current\n'
fi
printf '  ancillary ............. %s script(s), %s transcript(s), %s\n' \
  "$(ls -1 "$OUT/anc/code" | wc -l)" "$(ls -1 "$OUT/anc/runs" | wc -l)" \
  "$(du -sh "$OUT/anc" | cut -f1)"

# Leave only what would actually be uploaded, plus the built PDF and the log.
rm -f main.aux main.out .body-only submission.tar.gz

# The bundle is no longer a single file, so it goes up as a tarball.  main.pdf
# is deliberately excluded: arXiv objects to a PDF submitted alongside TeX
# source, and it stays in article/arxiv/ for local reading regardless.
(cd "$OUT" && tar czf submission.tar.gz main.tex anc)

echo
echo "Bundle: $OUT"
echo "Upload: $OUT/submission.tar.gz"
ls -1 "$OUT"
