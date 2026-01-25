# Makefile for reusable routines examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../../module4/dut

all: task_function_test_verilog function_class_test_cpp

task_function_test_verilog: task_function_test_verilog.v
	@echo "=== Compiling Verilog task/function example ==="
	$(IVERILOG) -o task_function_test task_function_test_verilog.v $(DUT_DIR)/alus/simple_alu.v
	@echo "=== Running simulation ==="
	$(VVP) task_function_test

function_class_test_cpp: function_class_test_cpp.cpp
	@echo "=== Compiling C++ function/class example ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/alus \
		$(DUT_DIR)/alus/simple_alu.v function_class_test_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vsimple_alu

clean:
	rm -f task_function_test
	rm -rf obj_dir
	rm -f *.vcd

.PHONY: all clean task_function_test_verilog function_class_test_cpp
