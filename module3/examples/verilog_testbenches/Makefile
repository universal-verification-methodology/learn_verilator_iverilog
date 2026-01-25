# Makefile for Verilog testbench examples

IVERILOG = iverilog
VVP = vvp
# Note: and_gate is in module0, mux_4to1 and counter_4bit are in module1
DUT_DIR_MODULE0 = ../../../module0/dut
DUT_DIR_MODULE1 = ../../../module1/dut

all: and_gate_test mux_4to1_test counter_test

and_gate_test: and_gate_test.v
	@echo "=== Compiling and_gate_test ==="
	$(IVERILOG) -o and_gate_test and_gate_test.v ../../../module0/dut/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) and_gate_test

mux_4to1_test: mux_4to1_test.v
	@echo "=== Compiling mux_4to1_test ==="
	$(IVERILOG) -o mux_4to1_test mux_4to1_test.v $(DUT_DIR_MODULE1)/multiplexers/mux_4to1.v
	@echo "=== Running simulation ==="
	$(VVP) mux_4to1_test

counter_test: counter_test.v
	@echo "=== Compiling counter_test ==="
	$(IVERILOG) -o counter_test counter_test.v $(DUT_DIR_MODULE1)/counters/counter_4bit.v
	@echo "=== Running simulation ==="
	$(VVP) counter_test

clean:
	rm -f and_gate_test mux_4to1_test counter_test
	rm -f *.vcd

.PHONY: all clean and_gate_test mux_4to1_test counter_test
