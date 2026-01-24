# Makefile for Verilator compilation examples
# Demonstrates various compilation options

VERILATOR = verilator
DUT_DIR = ../../dut
VERILATOR_FLAGS = --cc --exe --build

# Default target
all: basic_compilation optimization tracing coverage linting

# Basic compilation
basic_compilation: basic_compilation.v basic_compilation.cpp
	@echo "=== Basic Compilation ==="
	$(VERILATOR) $(VERILATOR_FLAGS) basic_compilation.v basic_compilation.cpp
	@echo "=== Running ==="
	./obj_dir/Vbasic_compilation

# Compilation with optimization
optimization: basic_compilation.v basic_compilation.cpp
	@echo "=== Compilation with Optimization (-O2) ==="
	$(VERILATOR) -O2 $(VERILATOR_FLAGS) basic_compilation.v basic_compilation.cpp
	@echo "=== Running ==="
	./obj_dir/Vbasic_compilation

# Compilation with tracing
tracing: basic_compilation.v basic_compilation.cpp
	@echo "=== Compilation with Tracing ==="
	$(VERILATOR) --trace $(VERILATOR_FLAGS) basic_compilation.v basic_compilation.cpp
	@echo "=== Running ==="
	./obj_dir/Vbasic_compilation

# Compilation with coverage
coverage: basic_compilation.v basic_compilation.cpp
	@echo "=== Compilation with Coverage ==="
	$(VERILATOR) --coverage $(VERILATOR_FLAGS) basic_compilation.v basic_compilation.cpp
	@echo "=== Running ==="
	./obj_dir/Vbasic_compilation

# Linting only (no compilation)
linting: basic_compilation.v
	@echo "=== Linting Only ==="
	$(VERILATOR) --lint-only basic_compilation.v

# Clean build artifacts
clean:
	rm -rf obj_dir

.PHONY: all clean basic_compilation optimization tracing coverage linting
