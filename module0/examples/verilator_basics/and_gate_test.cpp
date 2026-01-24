/**
 * Simple AND Gate Testbench for Verilator
 * 
 * This testbench demonstrates:
 * - Verilator compilation
 * - DUT instantiation in C++
 * - Signal access
 * - Basic test patterns
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/simple_gates and_gate.v and_gate_test.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vand_gate.h"

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "AND Gate Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vand_gate* dut = new Vand_gate;
    
    std::cout << "\nTesting AND gate truth table:" << std::endl;
    std::cout << "  a  |  b  |  y  | Expected" << std::endl;
    std::cout << "-----|-----|-----|----------" << std::endl;
    
    // Test all input combinations
    // Test case 1: 0 & 0 = 0
    dut->a = 0;
    dut->b = 0;
    dut->eval();
    std::cout << "  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0" << std::endl;
    assert(dut->y == 0 && "Test failed: 0 & 0 should be 0");
    
    // Test case 2: 0 & 1 = 0
    dut->a = 0;
    dut->b = 1;
    dut->eval();
    std::cout << "  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0" << std::endl;
    assert(dut->y == 0 && "Test failed: 0 & 1 should be 0");
    
    // Test case 3: 1 & 0 = 0
    dut->a = 1;
    dut->b = 0;
    dut->eval();
    std::cout << "  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0" << std::endl;
    assert(dut->y == 0 && "Test failed: 1 & 0 should be 0");
    
    // Test case 4: 1 & 1 = 1
    dut->a = 1;
    dut->b = 1;
    dut->eval();
    std::cout << "  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    1" << std::endl;
    assert(dut->y == 1 && "Test failed: 1 & 1 should be 1");
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "All tests passed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
