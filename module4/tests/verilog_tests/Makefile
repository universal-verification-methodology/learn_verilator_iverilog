# Makefile for Verilog tests (iverilog)

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../../module4/dut

all: register_file_test alu_test

register_file_test: register_file_test.v
	@echo "=== Compiling register_file_test ==="
	$(IVERILOG) -o register_file_test register_file_test.v $(DUT_DIR)/registers/register_file.v
	@echo "=== Running simulation ==="
	$(VVP) register_file_test

alu_test: alu_test.v
	@echo "=== Compiling alu_test ==="
	$(IVERILOG) -o alu_test alu_test.v $(DUT_DIR)/alus/simple_alu.v
	@echo "=== Running simulation ==="
	$(VVP) alu_test

clean:
	rm -f register_file_test alu_test
	rm -f *.vcd

.PHONY: all clean register_file_test alu_test
