# 2026-08-16 (Claude-Code-5f668a8d): generates the [[A,B],C] straight-line-program DAG for n=2 as
# Graphviz dot source -- every one of the 46 nodes (12 inputs, free linear-combination nodes, the
# 10 paid multiplications split by stage, D=[A,B]'s entries, the final result's entries) matches
# code/verify_2x2_triple_commutator_10mult.sage exactly. Run: python3 gen_2x2_triple_commutator_dag.py
# && dot -Tsvg graph.dot -o graph.svg. Palette: dataviz skill's validated categorical order
# (blue/orange/aqua/yellow/magenta/green), dark surface #1a1a19 -- see artefacts/
# 2x2-triple-commutator-dag.svg for the rendered output.

nodes = {}   # name -> (label_html, kind, deps)
KIND_COLOR = {
    "input":   ("#3987e5", "#ffffff"),  # blue
    "mult1":   ("#d95926", "#ffffff"),  # orange -- stage-1 paid multiplications
    "combo":   ("#199e70", "#ffffff"),  # aqua -- free linear combinations
    "dout":    ("#c98500", "#0b0b0b"),  # yellow -- D = [A,B] entries
    "mult2":   ("#d55181", "#ffffff"),  # magenta -- stage-2 paid multiplications
    "eout":    ("#008300", "#ffffff"),  # green -- E = [[A,B],C] entries (final)
}

def add(name, label, kind, deps):
    nodes[name] = (label, kind, deps)

# ---- inputs ----
for m, letter in [("a","A"),("b","B"),("c","C")]:
    for ij in ["11","12","21","22"]:
        add(f"{m}{ij}", f"{letter}<SUB>{ij[0]}{ij[1]}</SUB>", "input", [])

# ---- stage 1: free combos ----
add("da", "d<SUB>A</SUB>=a11-a22", "combo", ["a11","a22"])
add("db", "d<SUB>B</SUB>=b11-b22", "combo", ["b11","b22"])
add("F1L", "a21+dA", "combo", ["a21","da"])
add("F2R", "b12-b21", "combo", ["b12","b21"])
add("F3L", "a12+dA", "combo", ["a12","da"])
add("F3R", "(b12-b21)-dB", "combo", ["F2R","db"])
add("F4R", "b21+dB", "combo", ["b21","db"])
add("F5L", "a12-a21-dA", "combo", ["a12","a21","da"])
add("F5R", "b12+dB", "combo", ["b12","db"])

# ---- stage 1: the 5 paid multiplications ----
add("p1", "p<SUB>1</SUB>", "mult1", ["F1L","db"])
add("p2", "p<SUB>2</SUB>", "mult1", ["a12","F2R"])
add("p3", "p<SUB>3</SUB>", "mult1", ["F3L","F3R"])
add("p4", "p<SUB>4</SUB>", "mult1", ["da","F4R"])
add("p5", "p<SUB>5</SUB>", "mult1", ["F5L","F5R"])

# ---- stage 1 outputs: D = [A,B] ----
add("z", "z = D<SUB>21</SUB>", "dout", ["p1","p4"])
add("y", "y = D<SUB>12</SUB>", "dout", ["p3","p2","p4"])
add("x", "x = D<SUB>11</SUB> = -D<SUB>22</SUB>", "dout", ["p1","p2","p3","p4","p5"])

# ---- stage 2: free combos ----
add("dc", "d<SUB>C</SUB>=c11-c22", "combo", ["c11","c22"])
add("u3", "2x", "combo", ["x"])
add("G1L", "z+2x", "combo", ["z","u3"])
add("G2R", "c12-c21", "combo", ["c12","c21"])
add("G3L", "y+2x", "combo", ["y","u3"])
add("G3R", "(c12-c21)-dC", "combo", ["G2R","dc"])
add("G4R", "c21+dC", "combo", ["c21","dc"])
add("G5L", "y-z-2x", "combo", ["y","z","u3"])
add("G5R", "c12+dC", "combo", ["c12","dc"])

# ---- stage 2: the 5 paid multiplications ----
add("q1", "p<SUB>1</SUB>'", "mult2", ["G1L","dc"])
add("q2", "p<SUB>2</SUB>'", "mult2", ["y","G2R"])
add("q3", "p<SUB>3</SUB>'", "mult2", ["G3L","G3R"])
add("q4", "p<SUB>4</SUB>'", "mult2", ["u3","G4R"])
add("q5", "p<SUB>5</SUB>'", "mult2", ["G5L","G5R"])

# ---- final outputs: E = [[A,B],C] ----
add("E21", "E<SUB>21</SUB>", "eout", ["q1","q4"])
add("E12", "E<SUB>12</SUB>", "eout", ["q3","q2","q4"])
add("E11", "E<SUB>11</SUB> = -E<SUB>22</SUB>", "eout", ["q1","q2","q3","q4","q5"])

lines = []
lines.append('digraph ABC {')
lines.append('  bgcolor="#0d0d0d";')
lines.append('  rankdir=TB;')
lines.append('  splines=spline;')
lines.append('  nodesep=0.28; ranksep=0.75;')
lines.append('  node [fontname="Helvetica,Arial,sans-serif", fontsize=12, style=filled, shape=ellipse, penwidth=0];')
lines.append('  edge [color="#52514e", arrowsize=0.55, penwidth=0.9];')

for name, (label, kind, deps) in nodes.items():
    fill, font = KIND_COLOR[kind]
    lines.append(f'  {name} [label=<{label}>, fillcolor="{fill}", fontcolor="{font}"];')

for name, (label, kind, deps) in nodes.items():
    for d in deps:
        # color the edge by the destination's "paid" status for a little extra pop
        ecolor = "#e66767" if kind in ("mult1","mult2") else "#52514e"
        lines.append(f'  {d} -> {name} [color="{ecolor}"];')

lines.append('  labelloc="t";')
lines.append('  label=<<FONT COLOR="#ffffff" POINT-SIZE="18">[A,B,C] = [[A,B],C] &#8212; the full 10-multiplication straight-line program (n=2)</FONT><BR/><FONT COLOR="#c3c2b7" POINT-SIZE="12">blue=inputs   aqua=free linear combinations   orange/magenta=the 10 paid multiplications (stage 1 / stage 2)   yellow=D=[A,B]   green=final result</FONT>>;')
lines.append('  fontname="Helvetica,Arial,sans-serif";')
lines.append('}')

with open("/tmp/dag/graph.dot", "w") as f:
    f.write("\n".join(lines))

print("nodes:", len(nodes))
print("mult1:", sum(1 for _,(l,k,d) in nodes.items() if k=="mult1"))
print("mult2:", sum(1 for _,(l,k,d) in nodes.items() if k=="mult2"))
