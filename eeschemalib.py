from pathlib import Path
import sys

doc = """
$CMP {symbol_name}
D {symbol_description}
K {symbol_keywords}
F ~
$ENDCMP"""

nmos = """
#
# {symbol_name}
#
DEF {symbol_name} M 0 0 Y Y 1 F N
F0 "M" 300 50 50 H V L CNN
F1 "{symbol_name}" 300 -50 50 H V L CNN
F2 "" -25 0 50 H I C CNN
F3 "" -25 0 50 H I C CNN
F4 "X" 300 50 50 H V L CNN "Spice_Primitive"
F5 "{spice_model}" 300 50 50 H V L CNN "Spice_Model"
F6 "Y" 300 50 50 H V L CNN "Spice_Netlist_Enabled"
DRAW
P 2 0 1 0 -50 -100 -50 100 N
P 2 0 1 0 -25 -100 100 -100 N
P 2 0 1 0 100 100 -25 100 N
P 2 0 1 0 200 0 -25 0 N
P 4 0 1 0 -25 0 50 25 50 -25 -25 0 F
P 2 1 1 0 -25 -100 -25 100 N
X D 1 100 200 100 D 50 50 1 1 P
X G 2 -200 0 150 R 50 50 1 1 I
X S 3 100 -200 100 U 50 50 1 1 P
X B 4 200 -200 200 U 50 50 1 1 I
ENDDRAW
ENDDEF"""

pmos = """
#
# {symbol_name}
#
DEF {symbol_name} M 0 0 Y Y 1 F N
F0 "M" 300 50 50 H V L CNN
F1 "{symbol_name}" 300 -50 50 H V L CNN
F2 "" 0 0 50 H I C CNN
F3 "" 0 0 50 H I C CNN
F4 "X" 300 50 50 H V L CNN "Spice_Primitive"
F5 "{spice_model}" 300 50 50 H V L CNN "Spice_Model"
F6 "Y" 300 50 50 H V L CNN "Spice_Netlist_Enabled"
DRAW
P 2 0 1 0 -50 100 -50 -100 N
P 2 0 1 0 -25 -100 100 -100 N
P 2 0 1 0 100 100 -25 100 N
P 2 0 1 0 200 0 -25 0 N
P 4 0 1 0 200 0 125 25 125 -25 200 0 F
P 2 1 1 0 -25 -100 -25 100 N
X D 1 100 -200 100 U 50 50 1 1 P
X G 2 -200 0 150 R 50 50 1 1 I
X S 3 100 200 100 D 50 50 1 1 P
X B 4 200 200 200 D 50 50 1 1 I
ENDDRAW
ENDDEF"""

cap = """
#
# {symbol_name}
#
DEF {symbol_name} C 0 10 N Y 1 F N
F0 "C" 25 100 50 H V L CNN
F1 "{symbol_name}" 25 -100 50 H V L CNN
F2 "" 38 -150 50 H I C CNN
F3 "" 0 0 50 H I C CNN
F4 "X" 25 100 50 H I L CNN "Spice_Primitive"
F5 "{spice_model}" 25 100 50 H V L CNN "Spice_Model"
F6 "Y" 25 100 50 H I L CNN "Spice_Netlist_Enabled"
DRAW
P 2 0 1 20 -80 -30 80 -30 N
P 2 0 1 20 -80 30 80 30 N
X ~ 1 0 150 110 D 50 50 1 1 P
X ~ 2 0 -150 110 U 50 50 1 1 P
ENDDRAW
ENDDEF"""

lib = open('sky130.lib', 'w+')
dcm = open('sky130.dcm', 'w+')

lib.write("""EESchema-LIBRARY Version 2.4
#encoding utf-8""")

dcm.write("""EESchema-DOCLIB  Version 2.0
#""")

pdk = Path(sys.argv[1])
p = pdk / "libraries/sky130_fd_pr/latest/cells/"
cells = [d.name for d in p.iterdir()]

for cell in cells:
    if 'nfet' in cell:
        lib.write(nmos.format(symbol_name=cell, spice_model="sky130_fd_pr__"+cell))
        dcm.write(doc.format(symbol_name=cell, symbol_keywords="nmos", symbol_description="Sky130 nmos"))
    elif 'pfet' in cell:
        lib.write(pmos.format(symbol_name=cell, spice_model="sky130_fd_pr__"+cell))
        dcm.write(doc.format(symbol_name=cell, symbol_keywords="pmos", symbol_description="Sky130 pmos"))
    elif 'cap' in cell:
        lib.write(cap.format(symbol_name=cell, spice_model="sky130_fd_pr__"+cell))
        dcm.write(doc.format(symbol_name=cell, symbol_keywords="capacitor", symbol_description="Sky130 cap"))

lib.write("""#
#End Library""")

lib.close()
dcm.close()
