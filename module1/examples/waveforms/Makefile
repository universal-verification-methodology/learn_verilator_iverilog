# Makefile for waveform examples

IVERILOG = iverilog
VVP = vvp
DUT_DIR = ../../dut

all: waveform_example

waveform_example: waveform_example.v
	@echo "=== Compiling waveform_example ==="
	$(IVERILOG) -o waveform_example waveform_example.v $(DUT_DIR)/multiplexers/mux_4to1.v
	@echo "=== Running simulation ==="
	$(VVP) waveform_example
	@echo "=== VCD file generated ==="
	@if [ -f waveform_example.vcd ]; then \
		echo "VCD file: waveform_example.vcd"; \
		ls -lh waveform_example.vcd; \
		echo "View with: gtkwave waveform_example.vcd"; \
	else \
		echo "Warning: VCD file not generated"; \
	fi

clean:
	rm -f waveform_example
	rm -f *.vcd

.PHONY: all clean waveform_example
