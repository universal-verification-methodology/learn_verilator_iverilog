# Makefile for Verilog tests (iverilog)

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../../module8/dut

all: modular_testbench metrics_test

modular_testbench: modular_testbench.v
	@echo "=== Compiling modular_testbench ==="
	$(IVERILOG) -o modular_testbench modular_testbench.v $(DUT_DIR)/multiplexers/mux_4to1.v
	@echo "=== Running simulation ==="
	$(VVP) modular_testbench

metrics_test: metrics_test.v
	@echo "=== Compiling metrics_test ==="
	$(IVERILOG) -o metrics_test metrics_test.v $(DUT_DIR)/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) metrics_test

clean:
	rm -f modular_testbench metrics_test
	rm -f *.vcd
	rm -f monitor.log

.PHONY: all clean modular_testbench metrics_test
