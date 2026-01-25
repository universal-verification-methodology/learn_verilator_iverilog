# Makefile for C++ tests (Verilator)

VERILATOR = verilator
DUT_DIR = ../../../module6/dut
VERILATOR_FLAGS = --cc --exe --build

all: class_based_test randomized_test interface_test

class_based_test: class_based_test.cpp
	@echo "=== Compiling class_based_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v class_based_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate

randomized_test: randomized_test.cpp
	@echo "=== Compiling randomized_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/multiplexers \
		$(DUT_DIR)/multiplexers/mux_4to1.v randomized_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vmux_4to1

interface_test: interface_test.cpp
	@echo "=== Compiling interface_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v interface_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate

clean:
	rm -rf obj_dir

.PHONY: all clean class_based_test randomized_test interface_test
