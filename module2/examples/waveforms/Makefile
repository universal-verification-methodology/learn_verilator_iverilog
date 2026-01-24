# Makefile for waveform examples

VERILATOR = verilator
DUT_DIR = ../../module1/dut
VERILATOR_FLAGS = --cc --exe --build --trace

all: waveform_example

waveform_example: waveform_example.cpp
	@echo "=== Compiling waveform_example ==="
	$(VERILATOR) $(VERILATOR_FLAGS) -I$(DUT_DIR)/multiplexers \
		$(DUT_DIR)/multiplexers/mux_4to1.v waveform_example.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vmux_4to1
	@echo "=== VCD file generated ==="
	@if [ -f waveform_example.vcd ]; then \
		echo "VCD file: waveform_example.vcd"; \
		ls -lh waveform_example.vcd; \
		echo "View with: gtkwave waveform_example.vcd"; \
	else \
		echo "Warning: VCD file not generated"; \
	fi

clean:
	rm -rf obj_dir
	rm -f *.vcd

.PHONY: all clean waveform_example
