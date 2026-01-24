# Makefile for VVP simulation examples

IVERILOG = iverilog
VVP = vvp

all: vvp_basics

vvp_basics: vvp_basics.v
	@echo "=== Compiling vvp_basics ==="
	$(IVERILOG) -o vvp_basics vvp_basics.v
	@echo "=== Running simulation ==="
	$(VVP) vvp_basics
	@echo "=== Running with verbose mode ==="
	$(VVP) -v vvp_basics

clean:
	rm -f vvp_basics

.PHONY: all clean vvp_basics
