#!/bin/bash
# Typst -> LaTeX, for migrating this article off Typst.
#
# Changelog (reverse-chronological)
#   2026-08-30  Created.
#
# pandoc 3.7 has a real Typst READER, but it *evaluates* the source, so it dies
# on the first theorion call ("Identifier \"proposition\" not found").  Feeding
# it stub definitions first makes the whole document parse: the stubs turn each
# theorem-like call into a bracketed marker that survives into the LaTeX, where
# a second pass rewrites markers into environments.
#
# What survives the round trip, verified on the Cohen-Macaulayness section:
# headings, inline and display maths, \overline, \text, bold/emphasis, labels
# (\phantomsection\label), cross-references (\hyperref), lists.
# What does NOT and needs the second pass: theorem environments, #bcite -> \cite,
# and figures.
#
# Usage:  tools/typ2tex.sh article/source-complete.typ > /tmp/out.tex
set -euo pipefail
SRC="$1"
DIR="$(cd "$(dirname "$0")" && pwd)"
# Strip the source preamble (everything before the first "= " heading): it
# imports theorion, which pandoc's evaluator cannot run ("Content does not have
# a method \"final\""), and redefines macros the stub file already supplies.
awk '/^= /{f=1} f' "$SRC" > /tmp/.t2t.body
cat "$DIR/typst-stubs.typ" /tmp/.t2t.body > /tmp/.t2t.typ
pandoc -f typst -t latex --wrap=none /tmp/.t2t.typ | python3 "$DIR/markers2env.py"
