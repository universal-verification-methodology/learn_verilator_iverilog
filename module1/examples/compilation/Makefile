# Makefile for iverilog compilation examples
# Demonstrates various compilation options

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../dut

# Default target
all: basic_compilation include_path macro_def multi_file

# Basic compilation
basic_compilation: basic_compilation.v
	@echo "=== Basic Compilation ==="
	$(IVERILOG) -o basic_compilation basic_compilation.v
	$(VVP) basic_compilation

# Compilation with include path
include_path: basic_compilation.v
	@echo "=== Compilation with Include Path ==="
	$(IVERILOG) -I$(DUT_DIR) -o include_path basic_compilation.v
	$(VVP) include_path

# Compilation with macro definition
macro_def: basic_compilation.v
	@echo "=== Compilation with Macro Definition ==="
	$(IVERILOG) -DDEBUG -o macro_def basic_compilation.v
	$(VVP) macro_def

# Multi-file compilation
multi_file: basic_compilation.v
	@echo "=== Multi-file Compilation ==="
	$(IVERILOG) -o multi_file basic_compilation.v ../../../module0/dut/simple_gates/and_gate.v
	$(VVP) multi_file

# Clean build artifacts
clean:
	rm -f basic_compilation include_path macro_def multi_file
	rm -f *.vcd

.PHONY: all clean basic_compilation include_path macro_def multi_file
