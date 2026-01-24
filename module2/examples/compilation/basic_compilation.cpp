/**
 * Basic Verilator Compilation Example
 * 
 * This example demonstrates basic Verilator compilation commands and options.
 * 
 * Topics covered:
 * - Basic compilation: verilator --cc --exe design.v testbench.cpp
 * - Optimization levels: -O0, -O1, -O2, -O3
 * - Coverage options: --coverage
 * - Linting: --lint-only
 * - Waveform generation: --trace, --trace-fst
 * - Include paths: -I<directory>
 * - Define macros: -D<macro>
 * 
 * Usage examples:
 *   # Basic compilation
 *   verilator --cc --exe --build basic_compilation.v basic_compilation.cpp
 *   
 *   # With optimization
 *   verilator -O2 --cc --exe --build basic_compilation.v basic_compilation.cpp
 *   
 *   # With tracing
 *   verilator --trace --cc --exe --build basic_compilation.v basic_compilation.cpp
 *   
 *   # With coverage
 *   verilator --coverage --cc --exe --build basic_compilation.v basic_compilation.cpp
 */

#include <iostream>
#include <verilated.h>
#include "Vbasic_compilation.h"

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Basic Verilator Compilation Example" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vbasic_compilation* dut = new Vbasic_compilation;
    
    // Evaluate once
    dut->eval();
    
    std::cout << "DUT instantiated and evaluated successfully." << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
