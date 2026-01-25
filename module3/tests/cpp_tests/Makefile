# Makefile for C++ tests (Verilator)

VERILATOR = verilator
DUT_DIR_MODULE0 = ../../../module0/dut
DUT_DIR_MODULE1 = ../../../module1/dut
VERILATOR_FLAGS = --cc --exe --build

all: and_gate_test mux_4to1_test counter_test

and_gate_test: and_gate_test.cpp
	@echo "=== Compiling and_gate_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR_MODULE0)/simple_gates \
		$(DUT_DIR_MODULE0)/simple_gates/and_gate.v and_gate_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate

mux_4to1_test: mux_4to1_test.cpp
	@echo "=== Compiling mux_4to1_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR_MODULE1)/multiplexers \
		$(DUT_DIR_MODULE1)/multiplexers/mux_4to1.v mux_4to1_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vmux_4to1

counter_test: counter_test.cpp
	@echo "=== Compiling counter_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR_MODULE1)/counters \
		$(DUT_DIR_MODULE1)/counters/counter_4bit.v counter_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vcounter_4bit

clean:
	rm -rf obj_dir

.PHONY: all clean and_gate_test mux_4to1_test counter_test
