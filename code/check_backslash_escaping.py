"""Scan a generated .md file for the CommonMark backslash-escaping trap: a SINGLE backslash
followed by comma/brace, which GitLab's markdown renderer eats before KaTeX/MathJax sees it.
A doubled backslash (\\\\, or \\\\{) is the correct, already-fixed form and should NOT be flagged.
Content inside a backtick code span is verbatim under CommonMark -- backslash-escaping does not
apply there at all -- so it is skipped too (a pandoc Org->Markdown =verbatim= span, e.g. a literal
`\\,` mentioned in prose, renders as a real backtick span even though pandoc also tacks on a
`{.verbatim}` attribute suffix after it; that suffix is plain text, not part of the span).
See blog/BEST-PRACTICES.md's "Working around GitLab/CommonMark Markdown-rendering quirks" section.
"""
import sys

def scan(path):
    with open(path) as f:
        text = f.read()
    bad = []
    i = 0
    n = len(text)
    in_code_span = False
    while i < n:
        if text[i] == "`":
            in_code_span = not in_code_span
            i += 1
            continue
        if in_code_span:
            i += 1
            continue
        if text[i] == "\\":
            if i + 1 < n and text[i + 1] == "\\":
                i += 2  # a doubled backslash pair -- safe, skip both chars
                continue
            nxt = text[i + 1] if i + 1 < n else ""
            if nxt in ",{}":
                bad.append(text[max(0, i - 20):i + 20])
            i += 1
        else:
            i += 1
    return bad

for path in sys.argv[1:]:
    bad = scan(path)
    if bad:
        print(f"{path}: {len(bad)} risky sequence(s)")
        for b in bad:
            print("  ", repr(b))
    else:
        print(f"{path}: clean")
