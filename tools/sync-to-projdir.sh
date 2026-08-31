#!/bin/bash
# Sync the current manuscript into ai-workspace/projects/fast-commutators/article/.
#
# Changelog (reverse-chronological)
#   2026-08-31  Created.
#
# WHY THIS EXISTS
#
# The manuscript is developed here, in commutator-varieties.  But the *project*
# outlives the manuscript -- fast-commutators is where an n = 3 attempt, or any
# successor, would be worked out -- so the project directory needs to carry a
# readable, current copy of the paper rather than a link to a repo that may not
# be checked out.
#
# The failure mode this guards against is not hypothetical.  On 2026-08-31 the
# file sitting in the project directory under the current filename turned out to
# be byte-identical to article/source-complete.typ -- the PRE-MERGE draft, two
# weeks and five referee rounds out of date, under a name that gave no hint of
# it.  Copies without provenance rot silently; that is the whole reason for the
# stamped hash below.
#
# WHAT IS SYNCED, AND WHAT IS NOT
#
#   synced      ring-of-k-commuting-2x2-matrices.typ   -- the source, to read
#               ring-of-k-commuting-2x2-matrices.pdf   -- the built article
#
#   NOT synced  preamble.tex and anything else LaTeX   -- Jan's instruction,
#                 2026-08-31: build machinery belongs with the build, not beside
#                 the reading copy
#               source-complete.typ, source-signed-encoding.typ -- the two
#                 pre-merge inputs; kept here as history, and copying them into
#                 the project directory would recreate exactly the stale-lookalike
#                 problem this script exists to prevent
#               code/, runs/, LEAN/, literature/ -- not currently synced.  If a
#                 successor project wants them, extend this script deliberately
#                 rather than letting them drift over by hand.
#
# Usage:  tools/sync-to-projdir.sh          # sync, and stamp the README
#         tools/sync-to-projdir.sh --check  # report drift, change nothing

set -euo pipefail

SRC_REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="/backup/Repositories/ai-workspace/projects/fast-commutators/article"
STEM="ring-of-k-commuting-2x2-matrices"
README="$DEST/README.md"

[ -d "$DEST" ] || { echo "sync: destination not found: $DEST" >&2; exit 1; }

HASH="$(git -C "$SRC_REPO" rev-parse --short HEAD)"
# A hash only identifies the content if the tracked article is clean.  Say so
# when it is not, rather than stamping a hash that names different bytes.
if ! git -C "$SRC_REPO" diff --quiet -- article/ || \
   ! git -C "$SRC_REPO" diff --cached --quiet -- article/; then
    HASH="${HASH}+dirty"
fi
STAMP="$(date '+%Y-%m-%d %H:%M')"

if [ "${1:-}" = "--check" ]; then
    rc=0
    for ext in typ pdf; do
        if ! cmp -s "$SRC_REPO/article/$STEM.$ext" "$DEST/$STEM.$ext"; then
            echo "DRIFT: $STEM.$ext differs from $SRC_REPO/article/"
            rc=1
        fi
    done
    [ $rc -eq 0 ] && echo "in sync (source $HASH)"
    exit $rc
fi

# Rebuild only when the source is newer than the PDF.  Typst's output is NOT
# byte-reproducible -- it embeds a build timestamp, so two compiles of identical
# input differ -- and an unconditional rebuild would therefore mark article/
# dirty on every single run, making the +dirty warning above cry wolf and lose
# all its value.  Rebuild on demand instead.
if [ "$SRC_REPO/article/$STEM.typ" -nt "$SRC_REPO/article/$STEM.pdf" ]; then
    echo "source is newer than the PDF; rebuilding"
    ( cd "$SRC_REPO" && typst compile "article/$STEM.typ" )
    # The rebuild just changed tracked bytes, so re-derive the dirty flag.
    if ! git -C "$SRC_REPO" diff --quiet -- article/; then
        HASH="${HASH%+dirty}+dirty"
    fi
fi

for ext in typ pdf; do
    cp -- "$SRC_REPO/article/$STEM.$ext" "$DEST/$STEM.$ext"
done

# Re-stamp the provenance line in the README, in place.
if [ -f "$README" ]; then
    python3 - "$README" "$STAMP" "$HASH" <<'PY'
import re, sys
path, stamp, hash_ = sys.argv[1:4]
text = open(path).read()
new = "Copied **%s**, from `commutator-varieties` commit **`%s`**." % (stamp, hash_)
text, n = re.subn(r"^Copied \*\*.*?\*\*, from `commutator-varieties` commit \*\*`.*?`\*\*\.$",
                  new, text, count=1, flags=re.M)
if n == 0:
    raise SystemExit("sync: provenance line not found in %s -- not stamping" % path)
open(path, "w").write(text)
PY
fi

echo "synced $STEM.{typ,pdf} -> $DEST"
echo "stamped $HASH at $STAMP"
[ "${HASH%+dirty}" != "$HASH" ] && \
    echo "NOTE: article/ has uncommitted changes; the stamped hash does not identify these bytes." >&2
exit 0
