# Makefile for SystemVerilog class examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../dut

all: class_based_testbench class_based_testbench_cpp

# SystemVerilog class-based testbench (iverilog)
class_based_testbench: class_based_testbench.sv
	@echo "=== Compiling SystemVerilog class-based testbench (iverilog) ==="
	$(IVERILOG) -g2012 -o class_based_testbench class_based_testbench.sv $(DUT_DIR)/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) class_based_testbench

# C++ equivalent for Verilator
class_based_testbench_cpp: class_based_testbench_cpp.cpp
	@echo "=== Compiling C++ class-based testbench (Verilator equivalent) ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v class_based_testbench_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate

clean:
	rm -f class_based_testbench
	rm -rf obj_dir

.PHONY: all clean class_based_testbench class_based_testbench_cpp
