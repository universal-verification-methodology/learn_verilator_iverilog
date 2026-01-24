# Makefile for C++ testbench examples

VERILATOR = verilator
DUT_DIR = ../../module1/dut
VERILATOR_FLAGS = --cc --exe --build

all: mux_4to1_test counter_test

mux_4to1_test: mux_4to1_test.cpp
	@echo "=== Compiling mux_4to1_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/multiplexers \
		$(DUT_DIR)/multiplexers/mux_4to1.v mux_4to1_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vmux_4to1

counter_test: counter_test.cpp
	@echo "=== Compiling counter_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/counters \
		$(DUT_DIR)/counters/counter_4bit.v counter_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vcounter_4bit

clean:
	rm -rf obj_dir

.PHONY: all clean mux_4to1_test counter_test
