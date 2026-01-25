# ============================================================================
# Makefile for Verilator Compilation Examples
# ============================================================================
# This Makefile demonstrates various Verilator compilation options and flags.
# Each target shows a different compilation configuration.
# 
# Compilation Options Demonstrated:
#   - Basic compilation (minimal flags)
#   - Optimization levels (-O2)
#   - Waveform tracing (--trace)
#   - Code coverage (--coverage)
#   - Linting only (--lint-only, no code generation)
# 
# Usage:
#   make all              # Run all compilation examples
#   make basic_compilation # Basic compilation
#   make optimization      # Compilation with optimization
#   make tracing          # Compilation with waveform tracing
#   make coverage         # Compilation with code coverage
#   make linting          # Syntax checking only (no compilation)
#   make clean            # Remove build artifacts
# ============================================================================

VERILATOR = verilator
DUT_DIR = ../../dut

# Common flags for compilation targets (not used for linting)
VERILATOR_FLAGS = --cc --exe --build

# Default target: run all compilation examples
all: basic_compilation optimization tracing coverage linting

# ============================================================================
# Basic Compilation
# ============================================================================
# Minimal compilation with only required flags.
# This is the simplest way to compile a Verilator testbench.
basic_compilation: basic_compilation.v basic_compilation.cpp
	@echo "=== Basic Compilation ==="
	$(VERILATOR) $(VERILATOR_FLAGS) basic_compilation.v basic_compilation.cpp
	@echo "=== Running ==="
	./obj_dir/Vbasic_compilation

# ============================================================================
# Compilation with Optimization
# ============================================================================
# -O2 enables optimization for faster simulation.
# Optimization levels: -O0 (none), -O1 (basic), -O2 (default), -O3 (maximum)
# Higher optimization = faster simulation but slower compilation.
optimization: basic_compilation.v basic_compilation.cpp
	@echo "=== Compilation with Optimization (-O2) ==="
	$(VERILATOR) -O2 $(VERILATOR_FLAGS) basic_compilation.v basic_compilation.cpp
	@echo "=== Running ==="
	./obj_dir/Vbasic_compilation

# ============================================================================
# Compilation with Tracing
# ============================================================================
# --trace enables VCD waveform generation.
# Requires VerilatedVcdC in testbench code to actually generate waveforms.
# See waveform_example.cpp for usage.
tracing: basic_compilation.v basic_compilation.cpp
	@echo "=== Compilation with Tracing ==="
	$(VERILATOR) --trace $(VERILATOR_FLAGS) basic_compilation.v basic_compilation.cpp
	@echo "=== Running ==="
	./obj_dir/Vbasic_compilation

# ============================================================================
# Compilation with Coverage
# ============================================================================
# --coverage enables code coverage collection.
# Coverage data can be analyzed to see which parts of the design were exercised.
coverage: basic_compilation.v basic_compilation.cpp
	@echo "=== Compilation with Coverage ==="
	$(VERILATOR) --coverage $(VERILATOR_FLAGS) basic_compilation.v basic_compilation.cpp
	@echo "=== Running ==="
	./obj_dir/Vbasic_compilation

# ============================================================================
# Linting Only
# ============================================================================
# --lint-only checks syntax and design rules without generating code.
# Useful for quick syntax checking during development.
# Note: No --build flag needed, as no code is generated.
linting: basic_compilation.v
	@echo "=== Linting Only ==="
	$(VERILATOR) --lint-only basic_compilation.v

# ============================================================================
# Clean Target
# ============================================================================
# Removes all build artifacts.
clean:
	rm -rf obj_dir

.PHONY: all clean basic_compilation optimization tracing coverage linting
