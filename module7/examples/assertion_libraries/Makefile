# Makefile for assertion library examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../dut

all: assertion_lib_verilog assertion_lib_cpp

assertion_lib_verilog: assertion_lib_verilog.v
	@echo "=== Compiling Verilog assertion library example ==="
	$(IVERILOG) -g2012 -o assertion_lib assertion_lib_verilog.v $(DUT_DIR)/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) assertion_lib

assertion_lib_cpp: assertion_lib_cpp.cpp
	@echo "=== Compiling C++ assertion library example ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v assertion_lib_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate

clean:
	rm -f assertion_lib
	rm -rf obj_dir

.PHONY: all clean assertion_lib_verilog assertion_lib_cpp
