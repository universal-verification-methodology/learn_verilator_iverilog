# Makefile for Verilator tests
# Usage: make [target]

VERILATOR = verilator
DUT_DIR = ../../dut
VERILATOR_FLAGS = --cc --exe --build -I$(DUT_DIR)/simple_gates

# Default target
all: test_and_gate

# AND gate test
test_and_gate: test_and_gate.cpp
	@echo "Compiling test_and_gate with Verilator..."
	$(VERILATOR) $(VERILATOR_FLAGS) $(DUT_DIR)/simple_gates/and_gate.v test_and_gate.cpp
	@echo "Running test_and_gate..."
	./obj_dir/Vand_gate

# Clean build artifacts
clean:
	rm -rf obj_dir

.PHONY: all clean test_and_gate
