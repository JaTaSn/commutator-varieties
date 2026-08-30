#!/usr/bin/env python3
"""
Changelog (reverse chronological):
- 2026-08-17 - Claude: initial version. A pure-Python (pypdf + reportlab)
  alternative to the pdflatex+pdfpages review-packet pipeline used in
  article/review-2026-08-17/blankrev-*.tex, built at Jan's request to
  compare against that established LaTeX-based approach: same output
  shape (A4 ruled notepaper generation, then side-by-side A3-landscape
  stitching of content|ruled pages), no LaTeX involved at all. See
  __main__ below for a self-test that reproduces blankrev-5.pdf's
  structure from this project's own real article + lead-page PDFs, timed
  against the equivalent LaTeX build for a direct comparison.

Two independent pieces:
  1. make_ruled_a4(...)   -- draws N pages of light-blue ruled A4 notepaper
                             directly (reportlab), matching review-2026-08-17/
                             ruled_a4*.tex's visual spec exactly (same margin,
                             line spacing, line color/weight).
  2. stitch_side_by_side(...) -- combines two same-length PDFs page-by-page
                             into one A3-landscape PDF, left page | right
                             page per sheet (pypdf's merge_transformed_page).

Neither step touches LaTeX, tikz, or pdfpages.

Dependencies (not vendored elsewhere in this repo): `pip install pypdf reportlab`.

Usage:
  python3 pdf_stitch.py packet <content.pdf> <out.pdf> [--lead <lead.pdf>]
  python3 pdf_stitch.py ruled <n_pages> <out.pdf>
  python3 pdf_stitch.py stitch <left.pdf> <right.pdf> <out.pdf>
  python3 pdf_stitch.py bench <content.pdf> <lead.pdf>

Benchmark result (2026-08-17, this machine, `python3 pdf_stitch.py bench`,
15-sheet packet = this project's real 14-page article + 1 lead page):
reportlab ruled-page drawing and pypdf's own file I/O are both near-instant
(~5-30ms total) -- the entire runtime is merge_transformed_page itself,
~150ms *per page*, ~2.3s total. Contrary to the offhand "pypdf would surely
be much faster, no LaTeX startup cost" guess made in chat before writing
this: the equivalent 3-compile pdflatex+pdfpages pipeline (ruled-paper
generation, interleaving, nup=2x1 fold) actually ran *faster* on this same
15-sheet packet, ~1.9s. Root cause: pdflatex is a compiled binary, and
pypdf's merge_transformed_page is pure-Python content-stream manipulation
(re-parsing and rewriting each page's operators, resources, fonts) with no
C extension backing it -- LaTeX's per-invocation startup cost turned out to
be cheaper than that. A C++-backed library (pikepdf, wrapping QPDF) would
likely close or reverse this gap; not tried here. Practical upshot: for
this project's actual usage pattern (a handful of packet rebuilds per
review round), neither pipeline's speed matters -- the real trade-off is
LaTeX's tested nup/geometry math vs. this script's explicit, readable,
dependency-lighter-than-a-full-TeX-install Python geometry, not speed.
"""

from __future__ import annotations

import argparse
import time
from pathlib import Path

from pypdf import PdfReader, PdfWriter, Transformation
from reportlab.lib.colors import Color
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import cm
from reportlab.pdfgen import canvas
from reportlab.platypus import ListFlowable, ListItem, Paragraph, SimpleDocTemplate, Spacer

# --- constants matching ruled_a4_14.tex's own recipe exactly -----------------
CM = 28.3464567  # points per cm (72 / 2.54)
MARGIN = 1.8 * CM
LINE_SPACING = 1.1 * CM
N_LINES = 20
LINE_WIDTH = 0.4  # points
RULE_COLOR = Color(0.65, 0.65, 1.0)  # xcolor "blue!35" (35% blue, 65% white)


def make_ruled_a4(n_pages: int, out_path: Path) -> None:
    """Write n_pages of light-blue ruled A4 notepaper to out_path."""
    page_w, page_h = A4
    c = canvas.Canvas(str(out_path), pagesize=A4)
    c.setStrokeColor(RULE_COLOR)
    c.setLineWidth(LINE_WIDTH)
    usable_width = page_w - 2 * MARGIN
    for page_num in range(n_pages):
        for i in range(N_LINES):
            # Anchored to the TOP margin, going downward (matches
            # ruled_a4_14.tex: the tikzpicture sits at the top of the text
            # flow, so leftover vertical slack falls at the BOTTOM of the
            # page, not the top -- anchoring to the bottom margin instead,
            # as an earlier version of this function did, put all the slack
            # at the top, visibly wrong against the LaTeX original).
            y = page_h - MARGIN - i * LINE_SPACING
            c.line(MARGIN, y, MARGIN + usable_width, y)
        if page_num < n_pages - 1:
            # showPage() commits the current page and starts a new one -- only
            # call it BETWEEN pages, not after the last one (calling it there
            # too, then save(), emits a spurious extra blank page: reportlab
            # still flushes whatever page is pending, even an empty one).
            c.showPage()
            c.setStrokeColor(RULE_COLOR)
            c.setLineWidth(LINE_WIDTH)
    c.save()


def make_text_page(title: str, items: list[str], out_path: Path, intro: str | None = None) -> None:
    """Write a single A4 page: a bold title, an optional intro paragraph, and
    a numbered list of items -- reportlab's platypus flowables handle the
    text wrapping, unlike make_ruled_a4's raw canvas drawing. Used for the
    review-packet lead ("what changed") page, so the whole pipeline (lead
    page, ruled paper, stitching) runs through this one tool rather than
    generating the lead page in LaTeX and only the rest in Python."""
    doc = SimpleDocTemplate(
        str(out_path), pagesize=A4,
        leftMargin=2 * cm, rightMargin=2 * cm, topMargin=2 * cm, bottomMargin=2 * cm,
    )
    title_style = ParagraphStyle("Title", fontName="Helvetica-Bold", fontSize=12, spaceAfter=10)
    body_style = ParagraphStyle("Body", fontName="Helvetica", fontSize=9.5, leading=13, spaceAfter=8)
    item_style = ParagraphStyle("Item", fontName="Helvetica", fontSize=9.5, leading=13)

    story = [Paragraph(title, title_style)]
    if intro:
        story.append(Paragraph(intro, body_style))
    story.append(Spacer(1, 4))
    story.append(ListFlowable(
        [ListItem(Paragraph(item, item_style), spaceAfter=6) for item in items],
        bulletType="1", start=1,
    ))
    doc.build(story)


def _stitch_one_sheet(writer: PdfWriter, left_page, right_page) -> None:
    """Append one new page to writer: left_page | right_page, side by side,
    each unscaled and top-aligned (matches the A4-portrait-pair-on-A3-
    landscape case this project always uses -- both inputs the same height)."""
    lw, lh = float(left_page.mediabox.width), float(left_page.mediabox.height)
    rw, rh = float(right_page.mediabox.width), float(right_page.mediabox.height)
    out_w, out_h = lw + rw, max(lh, rh)

    new_page = writer.add_blank_page(width=out_w, height=out_h)
    new_page.merge_transformed_page(left_page, Transformation().translate(tx=0, ty=out_h - lh))
    new_page.merge_transformed_page(right_page, Transformation().translate(tx=lw, ty=out_h - rh))


def stitch_side_by_side(
    left_pdf: Path,
    right_pdf: Path,
    out_path: Path,
    left_pages: list[int] | None = None,
    right_pages: list[int] | None = None,
) -> int:
    """Build out_path from left_pdf/right_pdf, one A3-landscape sheet per
    (left page, right page) pair, in order. left_pages/right_pages are
    0-indexed page-index lists (default: every page, in order). Returns the
    number of sheets written."""
    left_reader = PdfReader(str(left_pdf))
    right_reader = PdfReader(str(right_pdf))
    if left_pages is None:
        left_pages = list(range(len(left_reader.pages)))
    if right_pages is None:
        right_pages = list(range(len(right_reader.pages)))
    if len(left_pages) != len(right_pages):
        raise ValueError(f"page count mismatch: {len(left_pages)} left vs {len(right_pages)} right")

    writer = PdfWriter()
    for li, ri in zip(left_pages, right_pages):
        _stitch_one_sheet(writer, left_reader.pages[li], right_reader.pages[ri])

    with open(out_path, "wb") as f:
        writer.write(f)
    return len(left_pages)


def build_review_packet(content_pdf: Path, out_path: Path, lead_pdf: Path | None = None) -> int:
    """Full pipeline: generate ruled A4 paper matching content_pdf's page
    count (plus one extra page if lead_pdf is given), then stitch
    content|ruled (with lead|ruled[0] as sheet one, if lead_pdf given) into
    out_path. Returns total sheet count."""
    content_reader = PdfReader(str(content_pdf))
    n_content = len(content_reader.pages)
    n_ruled = n_content + (1 if lead_pdf else 0)

    ruled_path = out_path.with_name(out_path.stem + "_ruled_tmp.pdf")
    make_ruled_a4(n_ruled, ruled_path)

    writer = PdfWriter()
    ruled_reader = PdfReader(str(ruled_path))
    ruled_idx = 0

    if lead_pdf:
        lead_reader = PdfReader(str(lead_pdf))
        _stitch_one_sheet(writer, lead_reader.pages[0], ruled_reader.pages[ruled_idx])
        ruled_idx += 1

    for i in range(n_content):
        _stitch_one_sheet(writer, content_reader.pages[i], ruled_reader.pages[ruled_idx])
        ruled_idx += 1

    with open(out_path, "wb") as f:
        writer.write(f)
    ruled_path.unlink()
    return ruled_idx


def bench(content_pdf: Path, lead_pdf: Path) -> None:
    """Timed breakdown of build_review_packet's three stages, to make the
    "where does the time actually go" question reproducible rather than a
    one-off shell measurement. See the module docstring for the result
    recorded on 2026-08-17."""
    import tempfile

    content_reader = PdfReader(str(content_pdf))
    lead_reader = PdfReader(str(lead_pdf))
    n_content = len(content_reader.pages)

    with tempfile.TemporaryDirectory() as td:
        ruled_path = Path(td) / "ruled.pdf"
        t0 = time.time()
        make_ruled_a4(n_content + 1, ruled_path)
        t1 = time.time()
        print(f"reportlab ruled-paper generation ({n_content + 1} pages): {t1 - t0:.3f}s")

        ruled_reader = PdfReader(str(ruled_path))
        t2 = time.time()
        print(f"pypdf PdfReader parsing (content+ruled+lead): {t2 - t1:.3f}s")

        writer = PdfWriter()
        _stitch_one_sheet(writer, lead_reader.pages[0], ruled_reader.pages[0])
        for i in range(n_content):
            _stitch_one_sheet(writer, content_reader.pages[i], ruled_reader.pages[i + 1])
        t3 = time.time()
        print(f"pypdf merge_transformed_page x{n_content + 1} sheets: {t3 - t2:.3f}s")

        out_path = Path(td) / "out.pdf"
        with open(out_path, "wb") as f:
            writer.write(f)
        t4 = time.time()
        print(f"pypdf writer.write() (serialize output): {t4 - t3:.3f}s")
        print(f"TOTAL: {t4 - t0:.3f}s")


def _cli() -> None:
    p = argparse.ArgumentParser(description="Pure-Python A4|A4 review-packet stitcher (pypdf + reportlab)")
    sub = p.add_subparsers(dest="cmd", required=True)

    p_ruled = sub.add_parser("ruled", help="generate N pages of ruled A4 notepaper")
    p_ruled.add_argument("n_pages", type=int)
    p_ruled.add_argument("out", type=Path)

    p_stitch = sub.add_parser("stitch", help="stitch two PDFs side-by-side, page by page")
    p_stitch.add_argument("left", type=Path)
    p_stitch.add_argument("right", type=Path)
    p_stitch.add_argument("out", type=Path)

    p_packet = sub.add_parser("packet", help="full review packet: content PDF (+ optional lead page) -> A3 blankrev")
    p_packet.add_argument("content", type=Path)
    p_packet.add_argument("out", type=Path)
    p_packet.add_argument("--lead", type=Path, default=None)

    p_bench = sub.add_parser("bench", help="timed stage-by-stage breakdown, using this project's real article as input")
    p_bench.add_argument("content", type=Path)
    p_bench.add_argument("lead", type=Path)

    args = p.parse_args()
    t0 = time.time()
    if args.cmd == "ruled":
        make_ruled_a4(args.n_pages, args.out)
        print(f"wrote {args.n_pages} ruled pages to {args.out}")
    elif args.cmd == "stitch":
        n = stitch_side_by_side(args.left, args.right, args.out)
        print(f"wrote {n} stitched sheets to {args.out}")
    elif args.cmd == "packet":
        n = build_review_packet(args.content, args.out, lead_pdf=args.lead)
        print(f"wrote {n}-sheet review packet to {args.out}")
    elif args.cmd == "bench":
        bench(args.content, args.lead)
        return
    print(f"elapsed: {time.time() - t0:.3f}s")


if __name__ == "__main__":
    _cli()
