# Makefile for modular testbench examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../../module4/dut

all: register_file_test_verilog register_file_test_cpp

# Verilog modular testbench
register_file_test_verilog: register_file_test_verilog.v
	@echo "=== Compiling Verilog modular testbench ==="
	$(IVERILOG) -o register_file_test_verilog \
		register_file_test_verilog.v \
		$(DUT_DIR)/registers/register_file.v
	@echo "=== Running simulation ==="
	$(VVP) register_file_test_verilog

# C++ modular testbench
register_file_test_cpp: register_file_test_cpp.cpp
	@echo "=== Compiling C++ modular testbench ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/registers \
		$(DUT_DIR)/registers/register_file.v register_file_test_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vregister_file

clean:
	rm -f register_file_test_verilog
	rm -rf obj_dir
	rm -f *.vcd

.PHONY: all clean register_file_test_verilog register_file_test_cpp
