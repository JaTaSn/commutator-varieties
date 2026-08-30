# 2026-08-16 (Claude-Code-5f668a8d): trace-zero vs skew-symmetric, for a 2x2 matrix -- which
# entries are linked. Prompted by Jan conflating the two (any commutator is trace-zero always;
# skew-symmetric is strictly stronger and only holds under extra conditions, e.g. both inputs
# symmetric). Two side-by-side 2x2 grids (neato, fixed positions): left shows what's actually true
# (diagonal linked via sum=0, off-diagonal free); right shows skew-symmetric (diagonal forced to 0,
# off-diagonal linked by negation) for contrast. See working-notes/trace-zero-vs-skew-symmetric.org.
# Run: python3 gen_trace-zero-vs-skew-symmetric.py && neato -Tsvg graph.dot -o graph.svg.

KIND_COLOR = {
    "free":   ("#3987e5", "#ffffff"),  # blue -- independent/free entry
    "forced": ("#898781", "#0b0b0b"),  # muted gray -- forced to a fixed value
    "linked": ("#d95926", "#ffffff"),  # orange -- entries tied to each other
}

lines = []
lines.append('graph ABC {')
lines.append('  bgcolor="#0d0d0d";')
lines.append('  layout=neato;')
lines.append('  node [fontname="Helvetica,Arial,sans-serif", fontsize=13, style=filled, shape=box, penwidth=0, width=0.9, height=0.6, fixedsize=true];')
lines.append('  edge [fontname="Helvetica,Arial,sans-serif", fontsize=11, fontcolor="#ffffff", penwidth=1.6];')

def cell(name, x, y, label, kind):
    fill, font = KIND_COLOR[kind]
    lines.append(f'  {name} [pos="{x},{y}!", label=<{label}>, fillcolor="{fill}", fontcolor="{font}"];')

# --- left grid: trace-zero (what is actually true) ---
ox = 0
cell("t11", ox+0, 1, "E<SUB>11</SUB>=x", "linked")
cell("t12", ox+1.4, 1, "E<SUB>12</SUB>=y", "free")
cell("t21", ox+0, -0.4, "E<SUB>21</SUB>=z", "free")
cell("t22", ox+1.4, -0.4, "E<SUB>22</SUB>=-x", "linked")
lines.append(f'  t11 -- t22 [color="#d95926", style=dashed, label="sum = 0", constraint=false];')
lines.append(f'  t12 -- t21 [style=invis];')  # invisible: NO relation, just spacing hint

# --- right grid: skew-symmetric (NOT what happens here in general) ---
ox2 = 4.2
cell("s11", ox2+0, 1, "0", "forced")
cell("s12", ox2+1.4, 1, "E<SUB>12</SUB>=y", "linked")
cell("s21", ox2+0, -0.4, "E<SUB>21</SUB>=-y", "linked")
cell("s22", ox2+1.4, -0.4, "0", "forced")
lines.append(f'  s12 -- s21 [color="#d95926", label="= -", constraint=false];')

lines.append('  t11 [shape=box];')  # no-op, keeps structure visually simple

lines.append('  labelloc="t";')
lines.append('  label=<<FONT COLOR="#ffffff" POINT-SIZE="17">Trace-zero &#8800; skew-symmetric, for a 2&#215;2 matrix</FONT><BR/><BR/><FONT COLOR="#199e70" POINT-SIZE="13">left: what [X,Y] actually satisfies -- only the DIAGONAL is linked (sums to 0); off-diagonal entries are free/independent</FONT><BR/><FONT COLOR="#e66767" POINT-SIZE="13">right: skew-symmetric would need the diagonal forced to 0 AND the off-diagonal entries linked -- not true here in general</FONT>>;')
lines.append('  fontname="Helvetica,Arial,sans-serif";')
lines.append('}')

with open("/tmp/dag2/graph.dot","w") as f:
    f.write("\n".join(lines))
