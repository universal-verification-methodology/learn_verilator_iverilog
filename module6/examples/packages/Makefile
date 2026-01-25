# Makefile for package examples

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../dut

all: package_example

# SystemVerilog package example (iverilog)
package_example: package_example.sv testbench_pkg.sv
	@echo "=== Compiling SystemVerilog package example (iverilog) ==="
	$(IVERILOG) -g2012 -o package_example package_example.sv testbench_pkg.sv $(DUT_DIR)/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) package_example

clean:
	rm -f package_example

.PHONY: all clean package_example
