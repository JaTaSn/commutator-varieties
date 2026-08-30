#!/usr/bin/env python3
"""Second pass of the Typst->LaTeX migration: markers to environments.

Changelog (reverse-chronological)
  2026-08-30  Created.  sed cannot do this: closing a marker requires knowing
              which environment was opened, i.e. a stack.

tools/typ2tex.sh feeds pandoc a stub preamble that turns every theorion call
into  '⟦KIND|title⟧ ... ⟦END⟧'.  This pass rewrites those into real LaTeX
environments, and #bcite keys into \\cite.
"""
import re, sys

ENV = {"THM": "theorem", "PRP": "proposition", "LEM": "lemma", "REM": "remark",
       "DEF": "definition", "EXA": "example", "PRF": "proof", "BIB": "bibitem"}
OPEN = re.compile(r"⟦(" + "|".join(ENV) + r")(?:\\textbar\s*|\|)?([^⟧]*)⟧")

def convert(text):
    out, stack, i = [], [], 0
    for m in re.finditer(r"⟦(?:END)⟧|" + OPEN.pattern, text):
        out.append(text[i:m.start()]); i = m.end()
        if m.group(0) == "⟦END⟧":
            out.append("\\end{%s}" % stack.pop() if stack else "")
        else:
            kind, title = m.group(1), (m.group(2) or "").strip()
            env = ENV[kind]
            if env == "bibitem":
                stack.append("__bib__"); out.append("\\bibitem{%s}" % title)
            else:
                stack.append(env)
                out.append("\\begin{%s}%s" % (env, "[%s]" % title if title else ""))
    out.append(text[i:])
    s = "".join(out).replace("\\end{__bib__}", "")
    return s

if __name__ == "__main__":
    sys.stdout.write(convert(sys.stdin.read()))
