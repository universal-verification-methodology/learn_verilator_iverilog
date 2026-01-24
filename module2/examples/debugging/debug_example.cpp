/**
 * Debugging with Verilator Example
 * 
 * This example demonstrates:
 * - C++ debugging techniques
 * - Signal inspection
 * - Logging strategies
 * - Error reporting
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/simple_gates and_gate.v debug_example.cpp
 *   ./obj_dir/Vand_gate
 *   
 *   # Debug with GDB:
 *   gdb ./obj_dir/Vand_gate
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vand_gate.h"

// Debug level: 0=minimal, 1=normal, 2=verbose
int debug_level = 1;

void debug_print(int level, const std::string& message) {
    if (debug_level >= level) {
        std::cout << "[DEBUG L" << level << "] " << message << std::endl;
    }
}

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Debugging Example (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    debug_print(0, "Starting test sequence");
    
    // Create DUT instance
    Vand_gate* dut = new Vand_gate;
    
    // Test case 1
    debug_print(1, "Test case 1: a=0, b=0");
    dut->a = 0;
    dut->b = 0;
    dut->eval();
    debug_print(2, "Signal values: a=" + std::to_string(dut->a) + 
                   ", b=" + std::to_string(dut->b) + 
                   ", y=" + std::to_string(dut->y));
    if (dut->y != 0) {
        std::cerr << "Error: Test failed: Expected y=0, got y=" << (int)dut->y << std::endl;
        return 1;
    }
    
    // Test case 2
    debug_print(1, "Test case 2: a=1, b=1");
    dut->a = 1;
    dut->b = 1;
    dut->eval();
    debug_print(2, "Signal values: a=" + std::to_string(dut->a) + 
                   ", b=" + std::to_string(dut->b) + 
                   ", y=" + std::to_string(dut->y));
    if (dut->y != 1) {
        std::cerr << "Error: Test failed: Expected y=1, got y=" << (int)dut->y << std::endl;
        return 1;
    }
    
    debug_print(0, "Test sequence completed");
    
    std::cout << "========================================" << std::endl;
    std::cout << "Debugging demonstration complete" << std::endl;
    std::cout << "Try changing debug_level to see different verbosity" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
