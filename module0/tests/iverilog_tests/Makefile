# Makefile for iverilog tests
# Usage: make [target]

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../dut

# Default target
all: test_and_gate

# AND gate test
test_and_gate: test_and_gate.v
	@echo "Compiling test_and_gate..."
	$(IVERILOG) -o test_and_gate test_and_gate.v $(DUT_DIR)/simple_gates/and_gate.v
	@echo "Running test_and_gate..."
	$(VVP) test_and_gate

# Clean build artifacts
clean:
	rm -f test_and_gate
	rm -f *.vcd

.PHONY: all clean test_and_gate
