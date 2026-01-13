# ssp
My Senior Signature Project: a CPU written in VHDL

# Installation:
1. Download GHDL (https://ghdl.github.io/ghdl/getting.html)
2. Download the code, and add a folder called "work"
3. In a shell (e.x. Windows Powershell), run `ghdl -i --workdir=work *.vhdl`.

# Running the simulation:
1. In a shell, run `ghdl -m --workdir=work ipu` if any changes have been made since the last simulation
2. Run `ghdl -r --workdir=work ipu`.

# Programming:
This processor has an original machine language with no compilers or assemblers currently. To add a program, you have to open `rom.vhdl` and write the code in hexadecimal or binary. The program counter starts at $8000. Good luck!
