# ============================================================================
# Makefile for C++ Testbench Examples
# ============================================================================
# This Makefile demonstrates how to build Verilator C++ testbenches.
# 
# Verilator Build Process:
#   1. Verilator generates C++ wrapper classes from Verilog
#   2. C++ testbench is compiled with generated wrappers
#   3. Everything is linked into an executable
#   4. Executable is run to perform simulation
# 
# Key Variables:
#   VERILATOR: Path to verilator executable
#   DUT_DIR: Directory containing Design Under Test (DUT) modules
#   VERILATOR_FLAGS: Common flags for all Verilator invocations
# 
# Usage:
#   make all          # Build and run all testbenches
#   make mux_4to1_test # Build and run multiplexer testbench
#   make counter_test  # Build and run counter testbench
#   make clean         # Remove build artifacts (obj_dir/)
# ============================================================================

# Verilator executable (assumes it's in PATH)
VERILATOR = verilator

# Directory containing DUT modules (relative to this Makefile)
# Note: There's a symlink 'multiplexers' in this directory pointing to module1/dut/multiplexers
DUT_DIR = ../../../module1/dut

# Common Verilator flags:
#   --cc    : Generate C++ code
#   --exe   : Generate executable
#   --build : Automatically build after generation
VERILATOR_FLAGS = --cc --exe --build

# Default target: build and run all testbenches
all: mux_4to1_test counter_test

# ============================================================================
# Multiplexer Testbench Target
# ============================================================================
# Builds and runs the 4-to-1 multiplexer testbench.
# 
# Build steps:
#   1. Verilator generates C++ wrapper from mux_4to1.v
#   2. Compiles testbench with generated wrapper
#   3. Links into executable: obj_dir/Vmux_4to1
#   4. Runs the executable
mux_4to1_test: mux_4to1_test.cpp
	@echo "=== Compiling mux_4to1_test ==="
	# -I flag adds include directory for `include directives in Verilog
	# Use full path to file, -I points to parent directory for includes
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/multiplexers \
		$(DUT_DIR)/multiplexers/mux_4to1.v mux_4to1_test.cpp
	@echo "=== Running simulation ==="
	# Executable is in obj_dir/ with name V<module_name>
	./obj_dir/Vmux_4to1

# ============================================================================
# Counter Testbench Target
# ============================================================================
# Builds and runs the 4-bit counter testbench.
counter_test: counter_test.cpp
	@echo "=== Compiling counter_test ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/counters \
		$(DUT_DIR)/counters/counter_4bit.v counter_test.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vcounter_4bit

# ============================================================================
# Clean Target
# ============================================================================
# Removes all build artifacts (obj_dir/ directory).
# Verilator stores all generated files in obj_dir/.
clean:
	rm -rf obj_dir

# ============================================================================
# Phony Targets
# ============================================================================
# Phony targets are not files, so Make won't check for files with these names.
# This prevents conflicts if files named "all", "clean", etc. exist.
.PHONY: all clean mux_4to1_test counter_test
