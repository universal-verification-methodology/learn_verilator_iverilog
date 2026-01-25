# Makefile for debugging examples

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../dut

all: debug_example

debug_example: debug_example.v
	@echo "=== Compiling debug_example ==="
	$(IVERILOG) -o debug_example debug_example.v ../../../module0/dut/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) debug_example

clean:
	rm -f debug_example
	rm -f *.vcd

.PHONY: all clean debug_example
