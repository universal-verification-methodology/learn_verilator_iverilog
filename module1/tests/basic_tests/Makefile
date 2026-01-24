# Makefile for basic tests

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../dut

all: test_mux_4to1

test_mux_4to1: test_mux_4to1.v
	@echo "=== Compiling test_mux_4to1 ==="
	$(IVERILOG) -o test_mux_4to1 test_mux_4to1.v $(DUT_DIR)/multiplexers/mux_4to1.v
	@echo "=== Running test ==="
	$(VVP) test_mux_4to1

clean:
	rm -f test_mux_4to1
	rm -f *.vcd

.PHONY: all clean test_mux_4to1
