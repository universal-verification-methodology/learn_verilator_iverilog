# Makefile for iverilog examples
# Usage: make [target]

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../dut

# Default target
all: hello_world and_gate_test gtkwave_example

# Hello World example
hello_world: hello_world.v
	@echo "Compiling hello_world..."
	$(IVERILOG) -o hello_world hello_world.v
	@echo "Running hello_world..."
	$(VVP) hello_world

# AND gate test
and_gate_test: and_gate_test.v
	@echo "Compiling and_gate_test..."
	$(IVERILOG) -o and_gate_test and_gate_test.v $(DUT_DIR)/simple_gates/and_gate.v
	@echo "Running and_gate_test..."
	$(VVP) and_gate_test

# GTKWave example - demonstrates waveform generation and viewing
gtkwave_example: gtkwave_example.v
	@echo "Compiling gtkwave_example..."
	$(IVERILOG) -o gtkwave_example gtkwave_example.v $(DUT_DIR)/simple_gates/and_gate.v
	@echo "Running gtkwave_example..."
	$(VVP) gtkwave_example
	@echo ""
	@echo "VCD file generated: gtkwave_example.vcd"
	@echo "To view waveforms, run: gtkwave gtkwave_example.vcd"
	@echo "Or use the automated script: ./view_waveforms.sh"

# View waveforms with GTKWave (requires GUI)
view_waveforms: gtkwave_example
	@if command -v gtkwave >/dev/null 2>&1; then \
		echo "Opening GTKWave..."; \
		gtkwave gtkwave_example.vcd & \
		echo "GTKWave opened. Check the GUI window."; \
	else \
		echo "Error: GTKWave not found. Install with: ./scripts/install_gtkwave.sh"; \
		exit 1; \
	fi

# Clean build artifacts
clean:
	rm -f hello_world and_gate_test gtkwave_example
	rm -f *.vcd

.PHONY: all clean hello_world and_gate_test gtkwave_example view_waveforms
