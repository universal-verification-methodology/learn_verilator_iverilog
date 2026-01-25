# Makefile for modular testbench architecture examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../dut

all: modular_testbench_verilog modular_testbench_cpp

modular_testbench_verilog: modular_testbench_verilog.v
	@echo "=== Compiling Verilog modular testbench example ==="
	$(IVERILOG) -o modular_testbench modular_testbench_verilog.v $(DUT_DIR)/multiplexers/mux_4to1.v
	@echo "=== Running simulation ==="
	$(VVP) modular_testbench

modular_testbench_cpp: modular_testbench_cpp.cpp
	@echo "=== Compiling C++ modular testbench example ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/multiplexers \
		$(DUT_DIR)/multiplexers/mux_4to1.v modular_testbench_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vmux_4to1

clean:
	rm -f modular_testbench
	rm -rf obj_dir
	rm -f *.vcd
	rm -f *.log

.PHONY: all clean modular_testbench_verilog modular_testbench_cpp
