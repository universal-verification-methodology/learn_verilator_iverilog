/**
 * 4-to-1 Multiplexer C++ Testbench (Verilator)
 * 
 * This testbench demonstrates exhaustive testing of a combinational multiplexer
 * using C++ and Verilator. It tests all possible select combinations.
 * 
 * Key Concepts:
 * - Exhaustive test coverage
 * - Combinational logic testing
 * - Multiple input verification
 * 
 * Usage:
 *   make mux_4to1_test
 *   or
 *   verilator --cc --exe --build -I../../../module1/dut/multiplexers \
 *            ../../../module1/dut/multiplexers/mux_4to1.v mux_4to1_test.cpp
 *   ./obj_dir/Vmux_4to1
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vmux_4to1.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "4-to-1 Multiplexer C++ Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vmux_4to1* dut = new Vmux_4to1;
    
    // Test case 1: sel=00, select in0
    dut->sel = 0;
    dut->in0 = 1; dut->in1 = 0; dut->in2 = 0; dut->in3 = 0;
    dut->eval();
    std::cout << "Test 1: sel=" << (int)dut->sel << ", out=" << (int)dut->out 
              << " (expected in0=" << (int)dut->in0 << ") " 
              << ((dut->out == dut->in0) ? "[PASS]" : "[FAIL]") << std::endl;
    assert(dut->out == dut->in0 && "Test failed: sel=00 should select in0");
    
    // Test case 2: sel=01, select in1
    dut->sel = 1;
    dut->in0 = 0; dut->in1 = 1; dut->in2 = 0; dut->in3 = 0;
    dut->eval();
    std::cout << "Test 2: sel=" << (int)dut->sel << ", out=" << (int)dut->out 
              << " (expected in1=" << (int)dut->in1 << ") " 
              << ((dut->out == dut->in1) ? "[PASS]" : "[FAIL]") << std::endl;
    assert(dut->out == dut->in1 && "Test failed: sel=01 should select in1");
    
    // Test case 3: sel=10, select in2
    dut->sel = 2;
    dut->in0 = 0; dut->in1 = 0; dut->in2 = 1; dut->in3 = 0;
    dut->eval();
    std::cout << "Test 3: sel=" << (int)dut->sel << ", out=" << (int)dut->out 
              << " (expected in2=" << (int)dut->in2 << ") " 
              << ((dut->out == dut->in2) ? "[PASS]" : "[FAIL]") << std::endl;
    assert(dut->out == dut->in2 && "Test failed: sel=10 should select in2");
    
    // Test case 4: sel=11, select in3
    dut->sel = 3;
    dut->in0 = 0; dut->in1 = 0; dut->in2 = 0; dut->in3 = 1;
    dut->eval();
    std::cout << "Test 4: sel=" << (int)dut->sel << ", out=" << (int)dut->out 
              << " (expected in3=" << (int)dut->in3 << ") " 
              << ((dut->out == dut->in3) ? "[PASS]" : "[FAIL]") << std::endl;
    assert(dut->out == dut->in3 && "Test failed: sel=11 should select in3");
    
    std::cout << "========================================" << std::endl;
    std::cout << "All tests completed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
