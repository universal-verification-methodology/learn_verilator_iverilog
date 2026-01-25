# Makefile for file I/O examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../../module4/dut

all: file_based_test_verilog file_based_test_cpp

file_based_test_verilog: file_based_test_verilog.v test_vectors.hex expected_results.hex
	@echo "=== Compiling Verilog file-based testbench ==="
	$(IVERILOG) -o file_based_test file_based_test_verilog.v $(DUT_DIR)/alus/simple_alu.v
	@echo "=== Running simulation ==="
	$(VVP) file_based_test
	@echo "=== Checking output file ==="
	@if [ -f test_results.txt ]; then \
		echo "Results file created:"; \
		head -15 test_results.txt; \
	else \
		echo "Warning: test_results.txt not found"; \
	fi

file_based_test_cpp: file_based_test_cpp.cpp test_vectors.hex expected_results.hex
	@echo "=== Compiling C++ file-based testbench ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/alus \
		$(DUT_DIR)/alus/simple_alu.v file_based_test_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vsimple_alu || true  # Don't fail on test failures (demo purposes)
	@echo "=== Checking output file ==="
	@if [ -f test_results.txt ]; then \
		echo "Results file created:"; \
		head -15 test_results.txt; \
	else \
		echo "Warning: test_results.txt not found"; \
	fi

clean:
	rm -f file_based_test
	rm -rf obj_dir
	rm -f test_results.txt

.PHONY: all clean file_based_test_verilog file_based_test_cpp
