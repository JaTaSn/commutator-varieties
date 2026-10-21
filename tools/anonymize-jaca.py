#!/usr/bin/env python3
"""Make the anonymized PDF that JACA's submission form asks for ("Manuscript without author
details") from the elsarticle build, by REDACTING the built PDF -- not by editing the source.

Changelog (reverse-chronological)
  2026-10-21  Claude-Code-3c0af632 (jts-pc), at Jan's request: "black out my affiliation and
              email, maybe you can apply that to the pdf, rather than to the TeX source file",
              and the Zenodo DOIs, whose record names the author.  Created.

Why redaction and not black rectangles.  A box drawn over text in a PDF hides it from the eye
only: the characters stay in the content stream, and select-and-copy or pdftotext recovers them.
PyMuPDF's redactions DELETE the characters (and vector art) under each box.  Link annotations
are separate objects that redaction does not touch, so the identifying ones are deleted
explicitly; and the document-information Author field ("Jan Snellman", from hyperref) is cleared.
The file is saved with garbage collection, so no orphaned object keeps an old copy.

What is blacked out, and why each:
  page 1   the author's name (title block, and again in the e-mail footnote), the ORCID icon
           (and its link), the affiliation line, the e-mail footnote;
  Methods  the Zenodo DOIs (concept and version) and their links -- the Zenodo record names the
           author, so the DOI identifies him at one click;
  Appendix the Zenodo DOI again;
  Acknowledgements, first paragraph -- "learned of the ring of commuting matrices some thirty
           years ago from Professor Jan-Erik Roos, in a course he held" narrows the author to
           Roos's students.  Double-anonymized review conventionally drops acknowledgements; this
           keeps the second paragraph (software credits), which identifies no one.

The script FAILS rather than writing a PDF if any target is not found exactly as expected, and
then re-reads its own output and fails if any identifying string, link or metadata survives.

Requires PyMuPDF (pip install pymupdf).  Usage, after tools/make-jaca.sh:
    python3 tools/anonymize-jaca.py          # writes article/jaca/main-anonymized.pdf
"""
import os
import re
import sys

import pymupdf

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "article", "jaca", "main.pdf")
OUT = os.path.join(ROOT, "article", "jaca", "main-anonymized.pdf")

# Identifying strings: none may survive in the output's text.
LEAKS = re.compile(r"Snellman|Link[oö]ping|liu\.se|zenodo\.2343372|zenodo\.2343373|0009-0002-6676-5068"
                   r"|Jan-Erik Roos, in a course|JaTaSn|jansn19|2609\.05386|LiTH-MAT-R", re.I)
# Identifying link targets: none may survive as annotations.
BAD_URI = re.compile(r"orcid\.org|mailto:|zenodo|gitlab|github", re.I)


def fail(msg):
    sys.exit("anonymize-jaca: FAIL: " + msg)


def rects_for(page, needle, expect):
    hits = page.search_for(needle)
    if len(hits) != expect:
        fail("expected %d hit(s) of %r on page %d, found %d" % (expect, needle, page.number + 1, len(hits)))
    return hits


def block_containing(page, needle):
    blocks = [b for b in page.get_text("blocks") if needle in b[4].replace("\n", " ")]
    if len(blocks) != 1:
        fail("expected one text block containing %r on page %d, found %d"
             % (needle, page.number + 1, len(blocks)))
    return pymupdf.Rect(blocks[0][:4])


def main():
    doc = pymupdf.open(SRC)
    targets = {}  # page index -> list of rects

    def add(page, rects):
        if rects:  # an empty hit list must not register the page: the checks below rely on it
            targets.setdefault(page.number, []).extend(rects)

    p1 = doc[0]
    add(p1, rects_for(p1, "Jan Snellman", 2))
    add(p1, [block_containing(p1, "Department of Mathematics")])
    add(p1, [block_containing(p1, "Email address")])
    add(p1, [pymupdf.Rect(l["from"]) for l in p1.get_links() if "orcid.org" in (l.get("uri") or "")])

    found_doi = 0
    for page in doc:
        for doi in ("10.5281/zenodo.23433730", "10.5281/zenodo.23433729"):
            hits = page.search_for(doi)
            found_doi += len(hits)
            add(page, hits)
        if "first learned of the ring of commuting matrices" in page.get_text().replace("\n", " "):
            add(page, [block_containing(page, "first learned of the ring of commuting matrices")])
    if found_doi != 3:
        fail("expected 3 Zenodo DOI occurrences, found %d" % found_doi)
    if not any("first learned" in doc[i].get_text() for i in targets):
        fail("Acknowledgements paragraph not found")

    for pno, rects in targets.items():
        page = doc[pno]
        for r in rects:
            page.add_redact_annot(r, fill=(0, 0, 0))
        page.apply_redactions(images=pymupdf.PDF_REDACT_IMAGE_NONE,
                              graphics=pymupdf.PDF_REDACT_LINE_ART_REMOVE_IF_TOUCHED,
                              text=pymupdf.PDF_REDACT_TEXT_REMOVE)
        for link in page.get_links():
            if BAD_URI.search(link.get("uri") or ""):
                page.delete_link(link)

    title = doc.metadata.get("title", "")
    doc.set_metadata({})
    doc.set_metadata({"title": title})
    doc.del_xml_metadata()
    doc.save(OUT, garbage=4, deflate=True, clean=True)
    doc.close()

    # ---- verify the file actually written --------------------------------
    chk = pymupdf.open(OUT)
    text = "\n".join(p.get_text() for p in chk)
    m = LEAKS.search(text)
    if m:
        fail("identifying text survived: %r" % m.group(0))
    for p in chk:
        for l in p.get_links():
            if BAD_URI.search(l.get("uri") or ""):
                fail("identifying link survived on page %d: %s" % (p.number + 1, l["uri"]))
    meta = {k: v for k, v in chk.metadata.items() if v and k not in ("format", "title", "encryption")}
    if any(re.search("Snellman", str(v)) for v in meta.values()):
        fail("identifying metadata survived: %r" % meta)
    print("anonymize-jaca: wrote %s -- %d pages, %d redactions on pages %s; text, links and metadata "
          "verified clean" % (os.path.relpath(OUT, ROOT), chk.page_count,
                              sum(len(v) for v in targets.values()),
                              ", ".join(str(k + 1) for k in sorted(targets))))


if __name__ == "__main__":
    main()
