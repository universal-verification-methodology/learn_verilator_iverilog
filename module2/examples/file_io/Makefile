# Makefile for file I/O examples

VERILATOR = verilator
DUT_DIR = ../../module0/dut
VERILATOR_FLAGS = --cc --exe --build

all: file_io_test

file_io_test: file_io_test.cpp test_vectors.txt
	@echo "=== Compiling file_io_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v file_io_test.cpp
	@echo "=== Running simulation ==="
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate
	@echo "=== Checking output file ==="
	@if [ -f test_results.txt ]; then \
		echo "Results file created:"; \
		cat test_results.txt; \
	else \
		echo "Warning: test_results.txt not found"; \
	fi

clean:
	rm -rf obj_dir
	rm -f test_results.txt

.PHONY: all clean file_io_test
