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
} > "$OUT/main.tex"
rm -f "$OUT/.body.tex"

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
  "$(grep -oE '\\begin\{(theorem|proposition|lemma|remark|definition|example|problem)\}' .body-only | wc -l)"
printf '  figure (tikzpicture) .. %s\n' "$(grep -c 'begin{tikzpicture}' main.tex)"
printf '  overfull hboxes ....... %s\n' "$(grep -c 'Overfull \\hbox' main.log || true)"
printf '  pages ................. %s\n' "$(pdfinfo main.pdf 2>/dev/null | awk '/^Pages/{print $2}')"

# Leave only what would actually be uploaded, plus the built PDF and the log.
rm -f main.aux main.out .body-only
echo
echo "Bundle: $OUT"
ls -1 "$OUT"
