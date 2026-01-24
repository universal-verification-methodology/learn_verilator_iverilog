# Makefile for file I/O examples

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../dut

all: file_read_test

file_read_test: file_read_test.v test_vectors.hex expected_results.hex
	@echo "=== Compiling file_read_test ==="
	$(IVERILOG) -o file_read_test file_read_test.v $(DUT_DIR)/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) file_read_test
	@echo "=== Checking output file ==="
	@if [ -f test_results.txt ]; then \
		echo "Results file created:"; \
		cat test_results.txt; \
	else \
		echo "Warning: test_results.txt not found"; \
	fi

clean:
	rm -f file_read_test
	rm -f test_results.txt
	rm -f *.vcd

.PHONY: all clean file_read_test
