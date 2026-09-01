#!/usr/bin/env python3
"""Second pass of the Typst -> LaTeX migration: markers into environments.

Changelog (reverse-chronological)
  2026-09-01  arXiv build.  Five fixes:
              (a) fix_references no longer prefixes cref targets with ':'.  That
                  prefixing was a correct workaround for tcolorbox's default
                  label prefix, but article/preamble.tex was independently fixed
                  by passing an EMPTY prefix to every \\newtcbtheorem.  Two
                  correct fixes for one problem = 190 undefined references.
              (b) SEP: the '|' inside every marker is escaped by pandoc, and not
                  always the same way -- '\\textbar ' before a space, but
                  '\\textbar{}' before anything else.  One separator pattern is
                  now used everywhere instead of ad-hoc alternations.
              (c) CIT markers -> \\cite / \\cite[detail].  typst-stubs.typ used
                  to render #bcite as the bare key, dropping the citation and
                  leaving BibTeX keys loose in the prose.
              (d) fix_backticks: pandoc turns Typst's apostrophe into a LEFT
                  quote, so "Theorem's" arrives as "Theorem`s", 49 times.
                  Doubled backticks (real LaTeX opening quotes) are left alone.
                  fix_stray_close_quotes handles the mirror case: a possessive
                  on a word ending in "s" comes back as a closing '' instead.
              (f) fix_wide_tables: pandoc's width-less longtable columns pushed
                  the Notation table's third column, thirteen cross-references,
                  off the right edge of the paper, silently.
              (e) replace_figure: swaps the one hand-drawn Typst diagram, which
                  pandoc flattens into stray braces, for the TikZ equivalent in
                  fig-phi-y2.tex.  The caption converts correctly and is kept.
  2026-08-30b Rewritten as a plain file.  The first version was patched in place
              through several layers of shell/Python string escaping, and two
              consecutive fixes failed for escaping reasons rather than logic
              ones.  Cheaper to write it out than to keep patching it.
  2026-08-30a Created.

tools/typ2tex.sh feeds pandoc a stub preamble that renders every theorion call
as  '<<KIND|title>> ... <<END>>'.  This pass turns those into real environments.

TWO TRAPS, both hit and both handled here:

1. tcolorbox's \\newtcbtheorem takes a label SUFFIX as its third argument and by
   default prepends a prefix, so \\begin{theorem}{t}{foo} would define ":foo",
   never "foo", and every \\cref{foo} inherited from the Typst source would
   render "??".  This is fixed ONCE, in article/preamble.tex, by passing an
   empty prefix; nothing is prefixed here.  (Doing both -- as an earlier version
   did -- gives \\cref{:foo} against \\label{foo}: 190 undefined references.)
2. Putting an ordinary \\label inside the box body instead does NOT fix it: the
   label captures the *section* counter, giving "Proof of Section 1".

So: use the supported third argument, and leave references alone.
"""
import os
import re
import sys

ENV = {"THM": "theorem", "PRP": "proposition", "LEM": "lemma", "REM": "remark",
       "DEF": "definition", "EXA": "example", "PRF": "proof", "BIB": "bibitem",
       "PRB": "problem"}

# The '|' separator inside a marker never survives pandoc literally: it comes
# back as "\textbar " before a space and "\textbar{}" before anything else.
# Both spellings, plus the raw bar, in one place -- longest alternative first,
# or "\textbar" would match and leave a stray "{}" at the head of every title.
SEP = r"(?:\\textbar\{\}|\\textbar\s*|\|)"

OPEN = re.compile(r"\u27e6(" + "|".join(ENV) + r")" + SEP + r"?([^\u27e7]*)\u27e7")
CLOSE = "\u27e6END\u27e7"
ANY = re.compile(re.escape(CLOSE) + "|" + OPEN.pattern)
CITE = re.compile(r"\u27e6CIT" + SEP + r"([^\u27e7]*)\u27e7")


def citations(text):
    """CIT markers -> \\cite.  #bcite("k") becomes \\cite{k}; the optional
    detail (rendered "[n, detail]" by the Typst) becomes \\cite[detail]{k}."""
    def one(m):
        parts = re.split(SEP, m.group(1))
        key = parts[0].strip()
        detail = parts[1].strip() if len(parts) > 1 and parts[1].strip() else None
        return "\\cite[%s]{%s}" % (detail, key) if detail else "\\cite{%s}" % key
    return CITE.sub(one, text)

# environments that carry a tcolorbox label suffix (proof does not)
BOXED = "theorem|proposition|lemma|remark|definition|example|problem"


def markers_to_environments(text):
    out, stack, i = [], [], 0
    for m in ANY.finditer(text):
        out.append(text[i:m.start()])
        i = m.end()
        if m.group(0) == CLOSE:
            out.append("\\end{%s}" % stack.pop() if stack else "")
            continue
        kind, title = m.group(1), (m.group(2) or "").strip()
        env = ENV[kind]
        if env == "bibitem":
            stack.append("__bib__")
            out.append("\\bibitem{%s}" % title)
        elif env == "proof":
            stack.append("proof")
            # The optional argument is BRACED.  Proof titles are "Proof of
            # @lem-foo", which becomes \hyperref[:lem-foo]{...}: without the
            # extra braces LaTeX ends the optional argument at the "]" inside
            # \hyperref, and the document collapses (204 errors).
            out.append("\\begin{proof}[{%s}]" % title if title else "\\begin{proof}")
        else:
            stack.append(env)
            # Emit the label slot as a sentinel rather than round-tripping the
            # title through "[...]".  Titles can THEMSELVES contain brackets --
            # one remark's title holds \hyperref[def-wk]{...} -- so a regex that
            # ends the optional argument at the first "]" splits the title mid
            # command and produces "Incomplete \iffalse; Emergency stop".
            out.append("\\begin{%s}{%s}{@@LBL@@}" % (env, title))
    out.append(text[i:])
    return "".join(out).replace("\\end{__bib__}", "")


def attach_labels(text):
    """Fill the @@LBL@@ sentinels from the Typst <label> pandoc strands after
    \\end{}.  Operates on the sentinel, never on the title, so a title that
    itself contains brackets cannot confuse the match.

    The body pattern must not be a plain ".*?".  It was, and an environment
    carrying NO Typst label then went on searching past its own \\end{} and
    claimed the NEXT environment's label: with 45 boxes and 8 of them unlabelled,
    every reference after the first gap pointed one environment too early
    ("Example 20 and Proposition 22" where the article says "Proposition 21 and
    Proposition 22").  Invisible until the references started resolving at all.
    So: the body may not contain a closing \\end{} of a boxed environment, which
    pins each sentinel to its own.

    The consumed strand is deleted -- it duplicates a label tcolorbox already
    defines, and it is bound to the SECTION counter, so leaving it in place is
    what makes \\cref{foo} silently render "Section 5"."""
    counter = [0]
    body = r"(?:(?!\\end\{(?:" + BOXED + r")\}).)*?"

    def fill(m):
        return "{%s}%s\\end{%s}" % (m.group(3), m.group(1), m.group(2))

    text = re.sub(
        r"\{@@LBL@@\}(" + body + r")\\end\{(" + BOXED + r")\}\s*"
        r"\\protect\\phantomsection\\label\{([^}]*)\}\{\}",
        fill, text, flags=re.S)

    def auto(m):
        counter[0] += 1
        return "{auto%d}" % counter[0]

    text = re.sub(r"\{@@LBL@@\}", auto, text)
    if counter[0]:
        sys.stderr.write(
            "markers2env: %d boxed environment(s) carried no Typst label; "
            "given auto1..auto%d\n" % (counter[0], counter[0]))
    return text


def fix_references(text):
    """pandoc renders Typst cross-refs as \\hyperref[x]{[x]}.  Rewrite each one
    to name its own environment and number, exactly as the Typst does
    ("Definition 14", "Lemma 13", "Proposition 21").

    Why not \\cref -- the whole story, since three plausible fixes are wrong:

    * tcolorbox ALWAYS prepends a colon to the third argument, whatever the
      \\newtcbtheorem prefix is.  An empty prefix gives ":foo", not "foo".
      (Verified in the .aux: "\\newlabel{:def-y1y2}{{14}...}".)
    * pandoc ALSO emits its own "\\protect\\phantomsection\\label{foo}" from the
      Typst "<foo>" strand, right after \\end{definition}.  That one is bound to
      the SECTION counter.  So plain \\cref{foo} is not undefined -- it silently
      renders "Section 5" where the Typst says "Definition 14".  Trading 190
      undefined references for 187 silently wrong ones is not an improvement.
    * \\cref{:foo} does resolve to the right number, but every boxed environment
      shares one counter (tcb@cnt@theorem, via "use counter from=theorem"), so
      cleveref has exactly one name to give them all: every Lemma, Definition
      and Proposition would be announced as a Theorem.

    So: emit \\thmref{Supplement}{label} (defined in preamble.tex), taking the
    supplement from the environment the label was actually attached to.
    (attach_labels has already deleted the phantomsection twins, so the trap
    cannot silently come back.)
    """
    supplement = {"theorem": "Theorem", "proposition": "Proposition",
                  "lemma": "Lemma", "remark": "Remark",
                  "definition": "Definition", "example": "Example",
                  "problem": "Problem"}
    ours = dict((lbl, supplement[env]) for env, lbl in re.findall(
        r"\\begin\{(" + BOXED + r")\}\{.*?\}\{([^{}]+)\}", text, flags=re.S))

    def one(m):
        lbl = m.group(1)
        if lbl in ours:
            return "\\thmref{%s}{%s}" % (ours[lbl], lbl)
        return "\\cref{%s}" % lbl

    text = re.sub(r"\\hyperref\[([^\]]*)\]\{\{\[\}.*?\{\]\}\}", one, text)
    dangling = [l for l in re.findall(
        r"\\protect\\phantomsection\\label\{([^}]*)\}\{\}", text) if l in ours]
    if dangling:
        sys.stderr.write("markers2env: %d section-bound duplicate label(s) "
                         "survived attach_labels: %s\n"
                         % (len(dangling), ", ".join(dangling)))
    return text


def fix_backticks(text):
    """Typst's apostrophe comes back from pandoc as a LEFT quote, so every
    possessive reads "Theorem`s".  Rewrite a LONE backtick (never one of a
    doubled ``...'' opening quote, which is genuine LaTeX) into an apostrophe.
    Restricted to the possessive `s, which is what all 49 of them are in this
    document; anything else is reported rather than silently rewritten, since a
    lone backtick is also how pandoc spells a genuine single opening quote."""
    text = re.sub(r"(?<!`)`(?=s\b)", "'", text)
    left = re.findall(r"(?<!`)`(?!`).{0,12}", text)
    if left:
        sys.stderr.write(
            "markers2env: %d lone backtick(s) left as-is, check by hand: %s\n"
            % (len(left), "; ".join(repr(s) for s in left[:5])))
    return fix_stray_close_quotes(text)


def fix_stray_close_quotes(text):
    """The mirror-image artefact.  A possessive on a word that already ends in
    "s" is written in Typst with a bare closing apostrophe (@def-primecomponents'
    own, the components' count), and pandoc reads THAT as a closing double quote:
    "Definition 24'' map" where the article says "Definition 24's map".

    A backtick heuristic cannot help here, because '' is also how pandoc spells
    a genuine closing quote, of which this document has 33.  Match them instead:
    within a paragraph, an '' with no unclosed `` before it cannot be closing
    anything, so it is an apostrophe.  (Checked first that neither delimiter
    ever occurs inside inline maths, where '' would mean a double prime.)"""
    out, fixed = [], []
    for para in text.split("\n\n"):
        depth, i, buf = 0, 0, []
        for m in re.finditer(r"``|''", para):
            buf.append(para[i:m.start()])
            i = m.end()
            if m.group(0) == "``":
                depth += 1
                buf.append("``")
            elif depth:
                depth -= 1
                buf.append("''")
            else:
                fixed.append(para[max(0, m.start() - 40):m.end()])
                buf.append("'")
        buf.append(para[i:])
        out.append("".join(buf))
    if fixed:
        sys.stderr.write("markers2env: %d stray closing quote(s) read as "
                         "apostrophes: %s\n"
                         % (len(fixed), " | ".join(repr(f) for f in fixed)))
    return "\n\n".join(out)


GREEK = ("alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu nu xi "
         "pi rho sigma tau upsilon phi chi psi omega "
         "Gamma Delta Theta Lambda Xi Pi Sigma Upsilon Phi Psi Omega").split()


def fix_symbols(text):
    """Typst writes Greek letters as bare identifiers (`tau`, `Phi`), and
    pandoc has no way to know they are Greek, so they arrive as `tau` and would
    typeset as italic t-a-u.  Restore the backslashes, and translate the few
    non-ASCII symbols pandoc passes through verbatim.

    Label names are masked out first.  They are hyphenated words, so
    `rem-red-tau-omitted` contains a bare `tau` that the loop below would
    cheerfully turn into `rem-red-\\tau-omitted`, silently breaking the
    cross-reference.  Found by looking at the output, not by reasoning about it.
    """
    store = []

    def stash(s):
        """Park a literal string and return its placeholder."""
        store.append(s)
        return "\x00%d\x00" % (len(store) - 1)

    # \thmref takes TWO arguments and the label is the second, so it needs its
    # own pattern; the generic one below would mask only the supplement and let
    # a label like "rem-red-tau-omitted" become "rem-red-\tau-omitted".
    text = re.sub(r"\\thmref\{[^}]*\}\{[^}]*\}", lambda m: stash(m.group(0)), text)
    text = re.sub(r"\\hyperref\[[^\]]*\]", lambda m: stash(m.group(0)), text)
    text = re.sub(r"\\(?:label|cref|ref\*?|eqref|bibitem|cite)(?:\[[^\]]*\])?\{[^}]*\}",
                  lambda m: stash(m.group(0)), text)
    # The tcolorbox label suffix, i.e. the SECOND brace group.  Stash only that
    # group -- an earlier version stashed m.group(0), the whole match, and then
    # re-emitted group(1) alongside it, which both duplicated text and swallowed
    # large spans.  Symptom: Greek substitution silently stopped happening and
    # the build went from 0 to 106 errors.
    text = re.sub(r"(\\begin\{(?:" + BOXED + r")\}\{.*?\})(\{[^}]*\})",
                  lambda m: m.group(1) + stash(m.group(2)), text, flags=re.S)

    for g in GREEK:
        text = re.sub(r"(?<![\\A-Za-z])" + g + r"(?![A-Za-z])", "\\\\" + g, text)

    text = re.sub("\x00(\\d+)\x00", lambda m: store[int(m.group(1))], text)
    # Single backslashes.  An earlier version had r"\\coloneqq" here, which is a
    # LITERAL double backslash -- inside a table that is a row separator, so the
    # Notation table exploded with "Missing $ inserted" and "Bad math environment
    # delimiter".  Six errors from one stray backslash.
    for uni, tex in ((chr(0x2254), r"\coloneqq "), ("\u00a7", r"\S{}"),
                     (chr(0x2193), r"\downarrow ")):
        text = text.replace(uni, tex)
    return text


def fix_wide_tables(text):
    """pandoc emits "{@{}cll@{}}" -- natural-width columns that never wrap --
    for a Typst table whose cells are whole sentences.  The Notation table then
    runs straight off the right-hand edge: its "Defined in" column, thirteen
    cross-references, was simply not on the page, and the "Meaning" column was
    cut mid-word.  Nothing warns about this; the text is in the PDF's page
    stream, just outside the paper.

    So: measure the widest row, and if the table cannot plausibly fit, respec it
    as equal-width p-columns keeping each column's original alignment.  Equal
    widths are an approximation -- the Typst gives Meaning slightly more than a
    third -- but they are predictable, and every column is on the page.
    Narrow tables (the k / dim R_k / codim one) are left untouched.
    """
    def visible(s):
        s = re.sub(r"\\[A-Za-z]+\s*", "", s)
        return re.sub(r"[{}\\]", "", s)

    def one(m):
        spec, body = m.group(1), m.group(2)
        cols = re.findall(r"[clr]", spec)
        widest = max([len(visible(r)) for r in body.split("\\\\\n")] or [0])
        if len(cols) < 2 or widest <= 100:
            return m.group(0)
        align = {"c": "\\centering", "l": "\\raggedright", "r": "\\raggedleft"}
        n = len(cols)
        newspec = "".join(
            ">{%s\\arraybackslash}p{\\dimexpr(\\linewidth-%d\\tabcolsep)/%d\\relax}"
            % (align[c], 2 * n, n) for c in cols)
        return ("\\begin{longtable}[]{@{}" + newspec + "@{}}" + body
                + "\\end{longtable}")

    return re.sub(
        r"\\begin\{longtable\}\[\]\{@\{\}([clr]+)@\{\}\}(.*?)\\end\{longtable\}",
        one, text, flags=re.S)


def fit_wide_displays(text):
    """Two things to every display, both restoring Typst behaviour that pandoc
    drops on the floor:

    * \\fitdisplay (preamble.tex) scales the display down only if it is wider
      than the measure.  Typst does this natively; LaTeX just lets it run off
      the paper, and Example 38's 3x6 Jacobian block went 144pt past the right
      edge with nothing in the log but an Overfull \\hbox.
    * "equation" rather than "\\[ \\]", because the Typst sets
      math.equation(numbering: "(1)") and its 41 displays are numbered (1)-(41).
      pandoc's Typst reader emits unnumbered displays and the numbers vanish.
      Nothing in the article cross-references an equation number (there are no
      <eq-...> labels in the source), so this is presentation, not linking.

    The lookbehind matters: "\\\\[" (a line break with a length) would otherwise
    be read as the start of a display.  There are none in this document today,
    but there is no reason for the pass to depend on that."""
    n = [0]

    def one(m):
        n[0] += 1
        return ("\\begin{equation}\\fitdisplay{" + m.group(1)
                + "}\\end{equation}")

    text = re.sub(r"(?<!\\)\\\[(.*?)(?<!\\)\\\]", one, text, flags=re.S)
    sys.stderr.write("markers2env: %d numbered displays\n" % n[0])
    return text


def wrap_bibliography(text):
    """The 11 \\bibitem come from Typst's hand-rolled bibentry blocks and land
    outside any list environment -- 11 "Lonely \\item", 11 "Undefined control
    sequence" and 11 "You can't use \\relax after \\the", one triple per entry.
    Wrap the run in a thebibliography."""
    first = text.find("\\bibitem{")
    if first < 0:
        return text
    last = text.rfind("\\bibitem{")
    end = text.find("\n\n", last)
    end = len(text) if end < 0 else end
    return (text[:first] + "\\begin{thebibliography}{99}\n" + text[first:end]
            + "\n\\end{thebibliography}\n" + text[end:])


def replace_figure(text):
    """The single Typst figure is drawn with #place/#ellipse/#box primitives.
    pandoc's Typst reader has nothing to map them onto, so it flattens the whole
    construction to a run of stray braces and loose maths -- the only four LaTeX
    errors in the converted document.  Swap that body (everything between
    \\centering and \\caption) for the TikZ picture in fig-phi-y2.tex, and pull
    the trailing \\label inside the float where it belongs.

    The caption itself converts correctly and is left exactly as pandoc made it.
    """
    tikz = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        "fig-phi-y2.tex")
    if not os.path.exists(tikz):
        sys.stderr.write("markers2env: %s missing, figure left mangled\n" % tikz)
        return text
    body = open(tikz, encoding="utf-8").read().rstrip("\n")

    pat = re.compile(
        r"(\\begin\{figure\}\n\\centering\n).*?(\\caption\{)", re.S)
    n = len(pat.findall(text))
    if n != 1:
        sys.stderr.write("markers2env: expected 1 figure, found %d\n" % n)
        if n == 0:
            return text
    text = pat.sub(lambda m: m.group(1) + body + "\n" + m.group(2), text, count=1)

    # move "\end{figure}\n\n\protect\phantomsection\label{...}{}" inside
    return re.sub(
        r"\\end\{figure\}\s*\\protect\\phantomsection\\label\{([^}]*)\}\{\}",
        lambda m: "\\label{%s}\n\\end{figure}" % m.group(1), text, count=1)


if __name__ == "__main__":
    s = sys.stdin.read()
    s = citations(s)        # before markers_to_environments: CIT has no ⟦END⟧
    s = markers_to_environments(s)
    s = attach_labels(s)
    s = fix_references(s)   # must precede fix_symbols: turns \hyperref into
    s = fix_symbols(s)      # \cref, which fix_symbols knows to mask
    s = fix_backticks(s)
    s = replace_figure(s)   # after fix_symbols: the TikZ is finished LaTeX and
    s = fix_wide_tables(s)  # must not be run through the Greek substitution
    s = fit_wide_displays(s)
    s = wrap_bibliography(s)
    sys.stdout.write(s)
