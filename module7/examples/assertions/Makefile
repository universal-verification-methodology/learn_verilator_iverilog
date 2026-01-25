# Makefile for assertion examples

IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
DUT_DIR = ../../dut

all: basic_assertions_verilog basic_assertions_cpp

basic_assertions_verilog: basic_assertions_verilog.v
	@echo "=== Compiling Verilog assertions example ==="
	$(IVERILOG) -g2012 -o basic_assertions basic_assertions_verilog.v $(DUT_DIR)/counters/counter_4bit.v
	@echo "=== Running simulation ==="
	$(VVP) basic_assertions

basic_assertions_cpp: basic_assertions_cpp.cpp
	@echo "=== Compiling C++ assertions example ==="
	$(VERILATOR) --cc --exe --build -I$(DUT_DIR)/counters \
		$(DUT_DIR)/counters/counter_4bit.v basic_assertions_cpp.cpp
	@echo "=== Running simulation ==="
	./obj_dir/Vcounter_4bit

clean:
	rm -f basic_assertions
	rm -rf obj_dir
	rm -f *.vcd

.PHONY: all clean basic_assertions_verilog basic_assertions_cpp
