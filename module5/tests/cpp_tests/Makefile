# Makefile for C++ tests (Verilator)

VERILATOR = verilator
DUT_DIR = ../../../module4/dut
VERILATOR_FLAGS = --cc --exe --build

all: alu_reusable_test alu_file_test

alu_reusable_test: alu_reusable_test.cpp
	@echo "=== Compiling alu_reusable_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/alus \
		$(DUT_DIR)/alus/simple_alu.v alu_reusable_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vsimple_alu

alu_file_test: alu_file_test.cpp
	@echo "=== Compiling alu_file_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/alus \
		$(DUT_DIR)/alus/simple_alu.v alu_file_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vsimple_alu

clean:
	rm -rf obj_dir
	rm -f test_results.txt

.PHONY: all clean alu_reusable_test alu_file_test
