# Makefile for verification metrics examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../dut

all: metrics_tracker_verilog metrics_tracker_cpp

metrics_tracker_verilog: metrics_tracker_verilog.v
	@echo "=== Compiling Verilog metrics tracker example ==="
	$(IVERILOG) -o metrics_tracker metrics_tracker_verilog.v $(DUT_DIR)/simple_gates/and_gate.v
	@echo "=== Running simulation ==="
	$(VVP) metrics_tracker

metrics_tracker_cpp: metrics_tracker_cpp.cpp
	@echo "=== Compiling C++ metrics tracker example ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/simple_gates \
		$(DUT_DIR)/simple_gates/and_gate.v metrics_tracker_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vand_gate

clean:
	rm -f metrics_tracker
	rm -rf obj_dir

.PHONY: all clean metrics_tracker_verilog metrics_tracker_cpp
