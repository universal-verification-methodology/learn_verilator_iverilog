# Makefile for C++ tests (Verilator)

VERILATOR = verilator
DUT_DIR = ../../../module4/dut
VERILATOR_FLAGS = --cc --exe --build

all: register_file_test alu_test

register_file_test: register_file_test.cpp
	@echo "=== Compiling register_file_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/registers \
		$(DUT_DIR)/registers/register_file.v register_file_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vregister_file

alu_test: alu_test.cpp
	@echo "=== Compiling alu_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/alus \
		$(DUT_DIR)/alus/simple_alu.v alu_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vsimple_alu

clean:
	rm -rf obj_dir

.PHONY: all clean register_file_test alu_test
