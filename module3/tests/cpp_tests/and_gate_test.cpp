/**
 * AND Gate C++ Testbench (Verilator)
 * 
 * This testbench demonstrates fundamental C++ testbench concepts using Verilator.
 * It tests the AND gate DUT with exhaustive test coverage.
 * 
 * Key Concepts:
 * - C++ testbench architecture
 * - Verilator API usage
 * - DUT instantiation
 * - Stimulus generation
 * - Response monitoring
 * - Result checking
 * 
 * Usage:
 *   make and_gate_test
 *   or
 *   verilator --cc --exe --build -I../../../module0/dut/simple_gates \
 *            ../../../module0/dut/simple_gates/and_gate.v and_gate_test.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vand_gate.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "AND Gate C++ Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "Test |  a  |  b  |  y  | Expected | Pass/Fail" << std::endl;
    std::cout << "-----|-----|-----|-----|----------|----------" << std::endl;
    
    // Create DUT instance
    Vand_gate* dut = new Vand_gate;
    
    // Test case 1: a=0, b=0 -> Expected: y=0
    dut->a = 0;
    dut->b = 0;
    dut->eval();
    std::cout << "  1  |  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0     |   " 
              << ((dut->y == 0) ? "PASS" : "FAIL") << std::endl;
    assert(dut->y == 0 && "Test failed: Expected y=0");
    
    // Test case 2: a=0, b=1 -> Expected: y=0
    dut->a = 0;
    dut->b = 1;
    dut->eval();
    std::cout << "  2  |  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0     |   " 
              << ((dut->y == 0) ? "PASS" : "FAIL") << std::endl;
    assert(dut->y == 0 && "Test failed: Expected y=0");
    
    // Test case 3: a=1, b=0 -> Expected: y=0
    dut->a = 1;
    dut->b = 0;
    dut->eval();
    std::cout << "  3  |  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0     |   " 
              << ((dut->y == 0) ? "PASS" : "FAIL") << std::endl;
    assert(dut->y == 0 && "Test failed: Expected y=0");
    
    // Test case 4: a=1, b=1 -> Expected: y=1
    dut->a = 1;
    dut->b = 1;
    dut->eval();
    std::cout << "  4  |  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    1     |   " 
              << ((dut->y == 1) ? "PASS" : "FAIL") << std::endl;
    assert(dut->y == 1 && "Test failed: Expected y=1");
    
    std::cout << "========================================" << std::endl;
    std::cout << "All tests completed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
