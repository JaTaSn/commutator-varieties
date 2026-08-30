#!/usr/bin/env python3
"""Second pass of the Typst -> LaTeX migration: markers into environments.

Changelog (reverse-chronological)
  2026-08-30b Rewritten as a plain file.  The first version was patched in place
              through several layers of shell/Python string escaping, and two
              consecutive fixes failed for escaping reasons rather than logic
              ones.  Cheaper to write it out than to keep patching it.
  2026-08-30a Created.

tools/typ2tex.sh feeds pandoc a stub preamble that renders every theorion call
as  '<<KIND|title>> ... <<END>>'.  This pass turns those into real environments.

TWO TRAPS, both hit and both handled here:

1. tcolorbox's \\newtcbtheorem takes a label SUFFIX as its third argument and
   always prepends a colon, so \\begin{theorem}{t}{foo} defines ":foo", never
   "foo".  Every \\cref{foo} inherited from the Typst source then renders "??".
2. Putting an ordinary \\label inside the box body instead does NOT fix it: the
   label captures the *section* counter, giving "Proof of Section 1".

So: use the supported third argument, and prefix every reference that points at
one of the labels we ourselves defined.  Section labels are left alone.
"""
import re
import sys

ENV = {"THM": "theorem", "PRP": "proposition", "LEM": "lemma", "REM": "remark",
       "DEF": "definition", "EXA": "example", "PRF": "proof", "BIB": "bibitem",
       "PRB": "problem"}

OPEN = re.compile(r"\u27e6(" + "|".join(ENV) + r")(?:\\textbar\s*|\|)?([^\u27e7]*)\u27e7")
CLOSE = "\u27e6END\u27e7"
ANY = re.compile(re.escape(CLOSE) + "|" + OPEN.pattern)

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
            out.append("\\begin{proof}[%s]" % title if title else "\\begin{proof}")
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
    itself contains brackets cannot confuse the match."""
    counter = [0]

    def fill(m):
        return m.group(0).replace("@@LBL@@", m.group(2), 1)

    text = re.sub(
        r"\{@@LBL@@\}.*?\\end\{(" + BOXED + r")\}\s*"
        r"\\protect\\phantomsection\\label\{([^}]*)\}\{\}",
        fill, text, flags=re.S)

    def auto(m):
        counter[0] += 1
        return "{auto%d}" % counter[0]

    return re.sub(r"\{@@LBL@@\}", auto, text)


def fix_references(text):
    """pandoc renders Typst cross-refs as \\hyperref[x]{[x]}; make them \\cref,
    then prefix the ones pointing at our own boxed environments (trap 1)."""
    text = re.sub(r"\\hyperref\[([^\]]*)\]\{\{\[\}.*?\{\]\}\}", r"\\cref{\1}", text)
    ours = set(re.findall(
        r"\\begin\{(?:" + BOXED + r")\}\{.*?\}\{([^{}]+)\}", text, flags=re.S))
    return re.sub(r"\\cref\{([^{}]+)\}",
                  lambda m: "\\cref{:%s}" % m.group(1) if m.group(1) in ours else m.group(0),
                  text)


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

    text = re.sub(r"\\(?:label|cref|ref|eqref|bibitem|cite)\{[^}]*\}",
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


if __name__ == "__main__":
    s = sys.stdin.read()
    s = markers_to_environments(s)
    s = attach_labels(s)
    s = fix_references(s)   # must precede fix_symbols: turns \hyperref into
    s = fix_symbols(s)      # \cref, which fix_symbols knows to mask
    s = wrap_bibliography(s)
    sys.stdout.write(s)
