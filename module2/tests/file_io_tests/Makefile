# Makefile for file I/O C++ tests

VERILATOR = verilator
DUT_DIR = ../../module0/dut
VERILATOR_FLAGS = --cc --exe --build

all: test_file_io

test_file_io: test_file_io.cpp test_vectors.txt
	@echo "=== Compiling test_file_io ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v test_file_io.cpp
	@echo "=== Running test ==="
	./obj_dir/Vand_gate

clean:
	rm -rf obj_dir
	rm -f test_results.txt

.PHONY: all clean test_file_io
