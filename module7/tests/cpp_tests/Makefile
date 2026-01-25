# Makefile for C++ tests (Verilator)

VERILATOR = verilator
DUT_DIR = ../../../module7/dut
VERILATOR_FLAGS = --cc --exe --build

all: assertion_test coverage_test

assertion_test: assertion_test.cpp
	@echo "=== Compiling assertion_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/counters \
		$(DUT_DIR)/counters/counter_4bit.v assertion_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vcounter_4bit

coverage_test: coverage_test.cpp
	@echo "=== Compiling coverage_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/multiplexers \
		$(DUT_DIR)/multiplexers/mux_4to1.v coverage_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vmux_4to1

clean:
	rm -rf obj_dir

.PHONY: all clean assertion_test coverage_test
