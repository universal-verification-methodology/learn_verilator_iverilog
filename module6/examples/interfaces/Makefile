# Makefile for interface examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../dut

all: interface_based_testbench interface_based_testbench_cpp

# SystemVerilog interface-based testbench (iverilog)
interface_based_testbench: interface_based_testbench.sv
	@echo "=== Compiling SystemVerilog interface-based testbench (iverilog) ==="
	$(IVERILOG) -g2012 -o interface_based_testbench interface_based_testbench.sv $(DUT_DIR)/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) interface_based_testbench

# C++ equivalent for Verilator
interface_based_testbench_cpp: interface_based_testbench_cpp.cpp
	@echo "=== Compiling C++ interface-based testbench (Verilator equivalent) ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v interface_based_testbench_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate

clean:
	rm -f interface_based_testbench
	rm -rf obj_dir
	rm -f *.vcd

.PHONY: all clean interface_based_testbench interface_based_testbench_cpp
