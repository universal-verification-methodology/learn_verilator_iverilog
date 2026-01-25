# Makefile for debugging examples

VERILATOR = verilator
DUT_DIR = ../../../module0/dut
VERILATOR_FLAGS = --cc --exe --build

all: debug_example

debug_example: debug_example.cpp
	@echo "=== Compiling debug_example ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v debug_example.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate
	@echo ""
	@echo "To debug with GDB:"
	@echo "  gdb ./obj_dir/Vand_gate"

clean:
	rm -rf obj_dir

.PHONY: all clean debug_example
