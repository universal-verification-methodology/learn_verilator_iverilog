# Makefile for basic C++ tests

VERILATOR = verilator
DUT_DIR = ../../../module1/dut
VERILATOR_FLAGS = --cc --exe --build

all: test_mux_4to1

test_mux_4to1: test_mux_4to1.cpp
	@echo "=== Compiling test_mux_4to1 ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/multiplexers \
		$(DUT_DIR)/multiplexers/mux_4to1.v test_mux_4to1.cpp
	@echo "=== Running test ==="
	./obj_dir/Vmux_4to1

clean:
	rm -rf obj_dir

.PHONY: all clean test_mux_4to1
