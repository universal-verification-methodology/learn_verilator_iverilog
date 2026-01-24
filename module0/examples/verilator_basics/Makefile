# Makefile for Verilator examples
# Usage: make [target]

VERILATOR = verilator
DUT_DIR = ../../dut
VERILATOR_FLAGS = --cc --exe --build -I$(DUT_DIR)/simple_gates

# Default target
all: hello_world and_gate_test

# Hello World example
hello_world: hello_world.v hello_world.cpp
	@echo "Compiling hello_world with Verilator..."
	$(VERILATOR) $(VERILATOR_FLAGS) hello_world.v hello_world.cpp
	@echo "Running hello_world..."
	./obj_dir/Vhello_world

# AND gate test
and_gate_test: and_gate_test.cpp
	@echo "Compiling and_gate_test with Verilator..."
	$(VERILATOR) $(VERILATOR_FLAGS) $(DUT_DIR)/simple_gates/and_gate.v and_gate_test.cpp
	@echo "Running and_gate_test..."
	./obj_dir/Vand_gate

# Clean build artifacts
clean:
	rm -rf obj_dir

.PHONY: all clean hello_world and_gate_test
