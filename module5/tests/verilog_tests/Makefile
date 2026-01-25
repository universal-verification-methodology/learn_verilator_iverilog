# Makefile for Verilog tests (iverilog)

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../../module4/dut

all: alu_reusable_test alu_file_test

alu_reusable_test: alu_reusable_test.v
	@echo "=== Compiling alu_reusable_test ==="
	$(IVERILOG) -o alu_reusable_test alu_reusable_test.v $(DUT_DIR)/alus/simple_alu.v
	@echo "=== Running simulation ==="
	$(VVP) alu_reusable_test

alu_file_test: alu_file_test.v
	@echo "=== Compiling alu_file_test ==="
	$(IVERILOG) -o alu_file_test alu_file_test.v $(DUT_DIR)/alus/simple_alu.v
	@echo "=== Running simulation ==="
	$(VVP) alu_file_test

clean:
	rm -f alu_reusable_test alu_file_test
	rm -f *.vcd
	rm -f test_results.txt

.PHONY: all clean alu_reusable_test alu_file_test
