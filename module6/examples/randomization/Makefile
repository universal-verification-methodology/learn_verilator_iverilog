# Makefile for randomization examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../dut

all: randomized_testbench randomized_testbench_cpp

# SystemVerilog randomized testbench (iverilog)
randomized_testbench: randomized_testbench.sv
	@echo "=== Compiling SystemVerilog randomized testbench (iverilog) ==="
	$(IVERILOG) -g2012 -o randomized_testbench randomized_testbench.sv $(DUT_DIR)/multiplexers/mux_4to1.v
	@echo "=== Running simulation ==="
	$(VVP) randomized_testbench

# C++ equivalent for Verilator
randomized_testbench_cpp: randomized_testbench_cpp.cpp
	@echo "=== Compiling C++ randomized testbench (Verilator equivalent) ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/multiplexers \
		$(DUT_DIR)/multiplexers/mux_4to1.v randomized_testbench_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vmux_4to1

clean:
	rm -f randomized_testbench
	rm -rf obj_dir
	rm -f *.vcd

.PHONY: all clean randomized_testbench randomized_testbench_cpp
