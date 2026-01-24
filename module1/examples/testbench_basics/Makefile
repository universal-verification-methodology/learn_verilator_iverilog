# Makefile for testbench basics examples

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../dut

all: mux_4to1_test counter_test

mux_4to1_test: mux_4to1_test.v
	@echo "=== Compiling mux_4to1_test ==="
	$(IVERILOG) -o mux_4to1_test mux_4to1_test.v $(DUT_DIR)/multiplexers/mux_4to1.v
	@echo "=== Running simulation ==="
	$(VVP) mux_4to1_test

counter_test: counter_test.v
	@echo "=== Compiling counter_test ==="
	$(IVERILOG) -o counter_test counter_test.v $(DUT_DIR)/counters/counter_4bit.v
	@echo "=== Running simulation ==="
	$(VVP) counter_test

clean:
	rm -f mux_4to1_test counter_test
	rm -f *.vcd

.PHONY: all clean mux_4to1_test counter_test
