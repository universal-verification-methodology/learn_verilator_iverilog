# Makefile for Verilog tests (iverilog)

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../../module7/dut

all: assertion_test coverage_test

assertion_test: assertion_test.v
	@echo "=== Compiling assertion_test ==="
	$(IVERILOG) -o assertion_test assertion_test.v $(DUT_DIR)/counters/counter_4bit.v
	@echo "=== Running simulation ==="
	$(VVP) assertion_test

coverage_test: coverage_test.v
	@echo "=== Compiling coverage_test ==="
	$(IVERILOG) -o coverage_test coverage_test.v $(DUT_DIR)/multiplexers/mux_4to1.v
	@echo "=== Running simulation ==="
	$(VVP) coverage_test

clean:
	rm -f assertion_test coverage_test
	rm -f *.vcd

.PHONY: all clean assertion_test coverage_test
