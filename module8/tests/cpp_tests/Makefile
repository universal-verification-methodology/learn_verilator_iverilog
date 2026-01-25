# Makefile for C++ tests (Verilator)

VERILATOR = verilator
DUT_DIR = ../../../module8/dut
VERILATOR_FLAGS = --cc --exe --build

all: modular_testbench metrics_test

modular_testbench: modular_testbench.cpp
	@echo "=== Compiling modular_testbench ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/multiplexers \
		$(DUT_DIR)/multiplexers/mux_4to1.v modular_testbench.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vmux_4to1

metrics_test: metrics_test.cpp
	@echo "=== Compiling metrics_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v metrics_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate

clean:
	rm -rf obj_dir
	rm -f monitor.log

.PHONY: all clean modular_testbench metrics_test
