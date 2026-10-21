#!/bin/bash
# Build the Journal of Computational Algebra (Elsevier, elsarticle) version from the Typst source.
#
# Changelog (reverse-chronological)
#   2026-10-21  Claude-Code-3c0af632 (jts-pc), at Jan's request.  Created.  Until today
#               article/jaca/main.tex was the make-arxiv.sh build (scrartcl, coloured
#               tcolorbox theorems) copied across by hand, which made its "GENERATED" header
#               untrue in the one place it mattered.  This script makes the JACA build a
#               build: Elsevier's elsarticle class, with article/preamble-elsarticle.tex and
#               article/frontmatter-elsarticle.tex in place of the arXiv pair, and four
#               structural edits to the converted body that belong to the journal format rather
#               than to the mathematics, so they live here and not in the .typ:
#                 - Acknowledgements unnumbered;
#                 - the appendix after \appendix ("Appendix A"), not a numbered section 11;
#                 - Elsevier's AI declaration unnumbered, immediately before the references
#                   (its placement and heading are Elsevier's own requirement);
#                 - the body's "\section{References}" dropped, as elsarticle's bibliography
#                   prints its own heading.
#               Each edit must match exactly once or the build fails: a silent no-op is how a
#               format edit quietly stops happening.
#               Builds with pdflatex (what Elsevier's Editorial Manager runs) AND xelatex (the
#               house rule), and fails on errors, undefined references or citations, overfull
#               boxes, a Zenodo placeholder, leaked source macros or internal working matter.
#               The source-level guards are copied from make-arxiv.sh, where their histories
#               are written up; keep the two in step.
#               Same day: the semicolon guard (here and in make-arxiv.sh) widened to catch
#               '#call(...)[...];', which had let three dropped semicolons through.
#
# Inputs, all tracked:
#   article/ring-of-k-commuting-2x2-matrices.typ   canonical source
#   article/preamble-elsarticle.tex                typography for this build
#   article/frontmatter-elsarticle.tex             title/author/affiliation/abstract/keywords
#   tools/typ2tex.sh + typst-stubs.typ + markers2env.py + fig-phi-y2.tex
#
# Output:
#   article/jaca/main.tex, main.pdf    (main.tex is self-contained: the only file to upload,
#                                      the figure being TikZ inside it)
#
# Usage:  tools/make-jaca.sh          # from anywhere in the repo
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
ART="$ROOT/article"
OUT="$ART/jaca"
SRC="$ART/ring-of-k-commuting-2x2-matrices.typ"

mkdir -p "$OUT"

# ---- source guards (copied from make-arxiv.sh) ------------------------------
if grep -nE '#[a-zA-Z][a-zA-Z0-9-]*(\([^)]*\))?(\[[^]]*\])*;' "$SRC" | grep -vE '^[0-9]+:\s*//'; then
  echo "FAIL: '#expr[...];' or '#call(...);' in the Typst -- pandoc drops the semicolon." >&2
  exit 1
fi

echo "==> Typst -> LaTeX body"
"$HERE/typ2tex.sh" "$SRC" > "$OUT/.body.tex"

echo "==> journal-format edits to the body"
python3 - "$OUT/.body.tex" <<'PYEOF'
import sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
DECL = ("Declaration of generative AI and AI-assisted technologies in the manuscript "
        "preparation process")
edits = [
    ("\\section{Acknowledgements}\n", "\\section*{Acknowledgements}\n"),
    ("\\section{Appendix: the explicit computations}\\label{sec-appendix}",
     "\\appendix\n\\section{The explicit computations}\\label{sec-appendix}"),
    ("\\section{" + DECL + "}\n", "\\section*{" + DECL + "}\n"),
    ("\\section{References}\n", ""),
]
for old, new in edits:
    n = s.count(old)
    if n != 1:
        sys.exit("FAIL: format edit expected exactly 1 match, found %d: %r" % (n, old[:70]))
    s = s.replace(old, new)
# Elsevier: the declaration goes at the end, immediately before the reference list.
i, j = s.index("\\section*{" + DECL + "}"), s.index("\\begin{thebibliography}")
if "\\section" in s[i + 10:j]:
    sys.exit("FAIL: a section sits between the AI declaration and the references")
open(p, "w", encoding="utf-8").write(s)
PYEOF

echo "==> assembling main.tex"
{
  cat <<'HEADER'
% main.tex -- GENERATED, do not edit.  Regenerate with tools/make-jaca.sh.
%
% Journal of Computational Algebra (Elsevier) submission build.  Assembled from:
%   article/preamble-elsarticle.tex     (typography; edit there)
%   article/frontmatter-elsarticle.tex  (title block, abstract, keywords; edit there)
%   the Typst source, converted by tools/typ2tex.sh
%
% Build:  pdflatex main.tex  (twice; xelatex works too)
\documentclass[preprint,12pt]{elsarticle}
HEADER
  cat "$ART/preamble-elsarticle.tex"
  echo
  echo '\journal{Journal of Computational Algebra}'
  echo
  echo '\begin{document}'
  echo
  cat "$ART/frontmatter-elsarticle.tex"
  echo
  cat "$OUT/.body.tex"
  echo
  echo '\end{document}'
} > "$OUT/main.tex"
rm -f "$OUT/.body.tex"

cd "$OUT"
build() {  # $1 = engine; leaves main.pdf/main.log from the LAST engine run
  rm -f main.aux main.out
  "$1" -interaction=nonstopmode main.tex >/dev/null || true
  "$1" -interaction=nonstopmode main.tex >/dev/null || true
}
report() {  # $1 = engine; prints a line, returns 1 on any defect
  local e u c o
  e=$(grep -c '^!' main.log || true)
  u=$(grep -c 'LaTeX Warning: Reference .* undefined' main.log || true)
  c=$(grep -cE '(LaTeX|natbib) Warning: Citation .* undefined' main.log || true)
  o=$(grep -c 'Overfull \\hbox' main.log || true)
  printf '  %-9s errors %s, undefined refs %s, undefined cites %s, overfull %s, %s pp.\n' \
    "$1" "$e" "$u" "$c" "$o" "$(pdfinfo main.pdf 2>/dev/null | awk '/^Pages/{print $2}')"
  [ "$e" -eq 0 ] && [ "$u" -eq 0 ] && [ "$c" -eq 0 ] && [ "$o" -eq 0 ]
}

echo "==> xelatex (house rule: both engines)"
build xelatex
XOK=0; report xelatex || XOK=1
echo "==> pdflatex (what Elsevier's Editorial Manager runs; this PDF is kept)"
build pdflatex
POK=0; report pdflatex || POK=1

echo
echo "==> checks on the built PDF"
FAILED=0
INTERNAL='theorion|/TRASH|[Ww]orking draft|not distributed|workspace top level|working note'
if pdftotext main.pdf - 2>/dev/null | grep -inE "$INTERNAL"; then
  echo "FAIL: internal working matter reached the built PDF (matches above)." >&2; FAILED=1
else printf '  internal matter ....... none\n'; fi
LEAKED='signtwist\(|vek\(|bcite\(|bibentry\(|#emph\[|#text\['
if pdftotext main.pdf - 2>/dev/null | grep -nE "$LEAKED"; then
  echo "FAIL: a source macro name reached the built PDF (matches above)." >&2; FAILED=1
else printf '  macro leakage ......... none\n'; fi
# grep -c, not grep -q: see make-arxiv.sh for the SIGPIPE/pipefail trap this avoids.
ZPEND=$(pdftotext main.pdf - 2>/dev/null | grep -c 'ZENODO-DOI-PENDING' || true)
if [ "${ZPEND:-0}" -gt 0 ]; then
  echo "FAIL: Zenodo DOI placeholder x$ZPEND still in the text." >&2; FAILED=1
else printf '  zenodo DOI ............ real (no placeholder)\n'; fi
DECLPDF=$(pdftotext main.pdf - 2>/dev/null | tr '\n' ' ' | grep -c 'Declaration of generative AI and AI-assisted technologies' || true)
printf '  AI declaration ........ %s\n' "$([ "${DECLPDF:-0}" -gt 0 ] && echo present || echo MISSING)"
[ "${DECLPDF:-0}" -gt 0 ] || FAILED=1
printf '  environments .......... %s theorem-like\n' \
  "$(grep -oE '\\begin\{(theorem|proposition|lemma|remark|definition|example|problem|question)\}' main.tex | wc -l)"

rm -f main.aux main.out main.spl
echo
if [ "$XOK$POK$FAILED" != "000" ]; then
  echo "BUILD NOT CLEAN -- see above.  Log: $OUT/main.log" >&2
  exit 1
fi
echo "Clean.  Upload: $OUT/main.tex   (PDF for reading: $OUT/main.pdf)"
