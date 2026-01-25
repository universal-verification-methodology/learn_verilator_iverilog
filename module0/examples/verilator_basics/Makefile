# Makefile for Verilator examples
# 
# This Makefile automates compilation and simulation of Verilator testbenches.
# 
# Usage:
#   make [target]          # Build and run specific example
#   make all                # Build and run all examples
#   make clean              # Remove build artifacts
# 
# Prerequisites:
#   - Verilator installed (see scripts/install_verilator.sh)
#   - C++ compiler (g++ or clang++)
#   - Make build system
# 
# Build Process:
#   1. Verilator generates C++ code from Verilog
#   2. C++ compiler compiles generated code + testbench
#   3. Linker creates executable in obj_dir/
#   4. Run executable to simulate
# 
# Verilator Workflow:
#   verilator --cc --exe --build design.v testbench.cpp
#   - --cc: Generate C++ code
#   - --exe: Create executable (combines compilation and linking)
#   - --build: Automatically build (no need to run make separately)
#   - Output: ./obj_dir/V<module_name> executable

# Tool definitions
VERILATOR = verilator              # Verilator compiler
DUT_DIR = ../../dut# Directory containing Design Under Test modules

# Verilator compilation flags
# --cc: Generate C++ code
# --exe: Create executable (combines compilation and linking)
# --build: Automatically build (no need to run make separately)
# -I<path>: Add include path for Verilog files
VERILATOR_FLAGS = --cc --exe --build -I$(DUT_DIR)/simple_gates

# Default target: build and run all examples
all: hello_world and_gate_test

# Hello World example
# Simplest possible testbench - verifies Verilator installation
hello_world: hello_world.v hello_world.cpp
	@echo "Compiling hello_world with Verilator..."
	# Verilator generates C++ class from Verilog module
	# Then compiles C++ testbench with generated code
	# Creates executable: ./obj_dir/Vhello_world
	$(VERILATOR) $(VERILATOR_FLAGS) hello_world.v hello_world.cpp
	@echo "Running hello_world..."
	# Execute the compiled simulation
	./obj_dir/Vhello_world

# AND gate test
# Demonstrates DUT instantiation, signal access, and test patterns
and_gate_test: and_gate_test.cpp
	@echo "Compiling and_gate_test with Verilator..."
	# Compile DUT (and_gate.v) and testbench (and_gate_test.cpp) together
	# Verilator generates Vand_gate class from and_gate module
	# Creates executable: ./obj_dir/Vand_gate
	$(VERILATOR) $(VERILATOR_FLAGS) $(DUT_DIR)/simple_gates/and_gate.v and_gate_test.cpp
	@echo "Running and_gate_test..."
	# Execute the compiled simulation
	./obj_dir/Vand_gate

# Clean build artifacts
# Removes obj_dir/ directory containing all generated files
clean:
	# Remove entire obj_dir directory (contains all generated C++ files)
	rm -rf obj_dir

# Phony targets: these don't create files with these names
# Tell make these are commands, not files to build
.PHONY: all clean hello_world and_gate_test
