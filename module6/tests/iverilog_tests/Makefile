# Makefile for iverilog tests (SystemVerilog)

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../../module6/dut

all: class_based_test randomized_test interface_test

class_based_test: class_based_test.sv
	@echo "=== Compiling class_based_test ==="
	$(IVERILOG) -g2012 -o class_based_test class_based_test.sv $(DUT_DIR)/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) class_based_test

randomized_test: randomized_test.sv
	@echo "=== Compiling randomized_test ==="
	$(IVERILOG) -g2012 -o randomized_test randomized_test.sv $(DUT_DIR)/multiplexers/mux_4to1.v
	@echo "=== Running simulation ==="
	$(VVP) randomized_test

interface_test: interface_test.sv
	@echo "=== Compiling interface_test ==="
	$(IVERILOG) -g2012 -o interface_test interface_test.sv $(DUT_DIR)/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) interface_test

clean:
	rm -f class_based_test randomized_test interface_test
	rm -f *.vcd

.PHONY: all clean class_based_test randomized_test interface_test
