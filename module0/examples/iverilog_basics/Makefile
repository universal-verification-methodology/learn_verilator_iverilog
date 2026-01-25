# Makefile for iverilog examples
# 
# This Makefile automates compilation and simulation of iverilog testbenches.
# 
# Usage:
#   make [target]          # Build and run specific example
#   make all                # Build and run all examples
#   make clean              # Remove build artifacts
# 
# Prerequisites:
#   - iverilog installed (see scripts/install_iverilog.sh)
#   - vvp (Icarus Verilog runtime, usually installed with iverilog)
#   - gtkwave (optional, for waveform viewing)
# 
# Build Process:
#   1. Compile: iverilog compiles Verilog files into executable
#   2. Simulate: vvp runs the compiled simulation
#   3. View: gtkwave displays waveforms (if VCD files generated)

# Tool definitions
IVERILOG = iverilog  # Icarus Verilog compiler
VVP = vvp            # Icarus Verilog runtime (simulator)
DUT_DIR = ../../dut# Directory containing Design Under Test modules

# Default target: build and run all examples
all: hello_world and_gate_test gtkwave_example

# Hello World example
# Simplest possible testbench - verifies iverilog installation
hello_world: hello_world.v
	@echo "Compiling hello_world..."
	# Compile Verilog file into executable
	# -o: output filename
	$(IVERILOG) -o hello_world hello_world.v
	@echo "Running hello_world..."
	# Run compiled simulation
	$(VVP) hello_world

# AND gate test
# Demonstrates DUT instantiation, signal driving, and output checking
and_gate_test: and_gate_test.v
	@echo "Compiling and_gate_test..."
	# Compile testbench and DUT together
	# Multiple files: testbench first, then DUT
	$(IVERILOG) -o and_gate_test and_gate_test.v $(DUT_DIR)/simple_gates/and_gate.v
	@echo "Running and_gate_test..."
	# Run simulation (generates VCD file if $dumpfile is used)
	$(VVP) and_gate_test

# GTKWave example - demonstrates waveform generation and viewing
# Creates comprehensive VCD file with multiple signal transitions
gtkwave_example: gtkwave_example.v
	@echo "Compiling gtkwave_example..."
	# Compile testbench with DUT
	$(IVERILOG) -o gtkwave_example gtkwave_example.v $(DUT_DIR)/simple_gates/and_gate.v
	@echo "Running gtkwave_example..."
	# Run simulation (generates gtkwave_example.vcd)
	$(VVP) gtkwave_example
	@echo ""
	@echo "VCD file generated: gtkwave_example.vcd"
	@echo "To view waveforms, run: gtkwave gtkwave_example.vcd"
	@echo "Or use the automated script: ./view_waveforms.sh"

# View waveforms with GTKWave (requires GUI)
# Automatically opens GTKWave with the generated VCD file
view_waveforms: gtkwave_example
	# Check if gtkwave is installed
	@if command -v gtkwave >/dev/null 2>&1; then \
		echo "Opening GTKWave..."; \
		# Run gtkwave in background (&) so make doesn't wait
		gtkwave gtkwave_example.vcd & \
		echo "GTKWave opened. Check the GUI window."; \
	else \
		echo "Error: GTKWave not found. Install with: ./scripts/install_gtkwave.sh"; \
		exit 1; \
	fi

# Clean build artifacts
# Removes compiled executables and generated waveform files
clean:
	# Remove compiled executables
	rm -f hello_world and_gate_test gtkwave_example
	# Remove all VCD waveform files
	rm -f *.vcd

# Phony targets: these don't create files with these names
# Tell make these are commands, not files to build
.PHONY: all clean hello_world and_gate_test gtkwave_example view_waveforms
