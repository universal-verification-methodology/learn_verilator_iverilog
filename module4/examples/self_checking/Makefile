# Makefile for self-checking testbench examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../../module4/dut

all: alu_self_checking_verilog alu_self_checking_cpp

alu_self_checking_verilog: alu_self_checking_verilog.v
	@echo "=== Compiling Verilog self-checking testbench ==="
	$(IVERILOG) -o alu_self_checking alu_self_checking_verilog.v $(DUT_DIR)/alus/simple_alu.v
	@echo "=== Running simulation ==="
	$(VVP) alu_self_checking

alu_self_checking_cpp: alu_self_checking_cpp.cpp
	@echo "=== Compiling C++ self-checking testbench ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/alus \
		$(DUT_DIR)/alus/simple_alu.v alu_self_checking_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vsimple_alu

clean:
	rm -f alu_self_checking
	rm -rf obj_dir
	rm -f *.vcd

.PHONY: all clean alu_self_checking_verilog alu_self_checking_cpp
