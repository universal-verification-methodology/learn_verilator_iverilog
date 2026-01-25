# Makefile for clock and reset examples

IVERILOG = iverilog
VVP = vvp
CXX = g++

all: configurable_clock_reset_verilog configurable_clock_reset_cpp

configurable_clock_reset_verilog: configurable_clock_reset_verilog.v
	@echo "=== Compiling Verilog clock/reset example ==="
	$(IVERILOG) -o configurable_clock_reset configurable_clock_reset_verilog.v
	@echo "=== Running simulation ==="
	$(VVP) configurable_clock_reset

configurable_clock_reset_cpp: configurable_clock_reset_cpp.cpp
	@echo "=== Compiling C++ clock/reset example ==="
	$(CXX) -o configurable_clock_reset configurable_clock_reset_cpp.cpp
	@echo "=== Running simulation ==="
	./configurable_clock_reset

clean:
	rm -f configurable_clock_reset
	rm -f *.vcd

.PHONY: all clean configurable_clock_reset_verilog configurable_clock_reset_cpp
