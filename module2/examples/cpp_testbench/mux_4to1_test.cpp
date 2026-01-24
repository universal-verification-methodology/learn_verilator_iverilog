/**
 * 4-to-1 Multiplexer C++ Testbench for Verilator
 * 
 * This testbench demonstrates:
 * - C++ main function structure
 * - Verilator-generated class usage
 * - DUT instantiation in C++
 * - Signal access (reading and writing)
 * - Clock generation in C++
 * - Reset generation in C++
 * - Simulation loop
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/multiplexers mux_4to1.v mux_4to1_test.cpp
 *   ./obj_dir/Vmux_4to1
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vmux_4to1.h"

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "4-to-1 Multiplexer C++ Testbench" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vmux_4to1* dut = new Vmux_4to1;
    
    std::cout << "\nTesting all select combinations:" << std::endl;
    std::cout << "sel | in0 | in1 | in2 | in3 | out | Expected" << std::endl;
    std::cout << "----|-----|-----|-----|-----|-----|----------" << std::endl;
    
    // Test all select combinations
    // Test case 1: sel=00, select in0
    dut->sel = 0;
    dut->in0 = 1; dut->in1 = 0; dut->in2 = 0; dut->in3 = 0;
    dut->eval();
    std::cout << " " << (int)dut->sel << "  |  " << (int)dut->in0 
              << "  |  " << (int)dut->in1 << "  |  " << (int)dut->in2 
              << "  |  " << (int)dut->in3 << "  |  " << (int)dut->out 
              << "  |   in0" << std::endl;
    assert(dut->out == dut->in0 && "Test failed: sel=00 should select in0");
    
    // Test case 2: sel=01, select in1
    dut->sel = 1;
    dut->in0 = 0; dut->in1 = 1; dut->in2 = 0; dut->in3 = 0;
    dut->eval();
    std::cout << " " << (int)dut->sel << "  |  " << (int)dut->in0 
              << "  |  " << (int)dut->in1 << "  |  " << (int)dut->in2 
              << "  |  " << (int)dut->in3 << "  |  " << (int)dut->out 
              << "  |   in1" << std::endl;
    assert(dut->out == dut->in1 && "Test failed: sel=01 should select in1");
    
    // Test case 3: sel=10, select in2
    dut->sel = 2;
    dut->in0 = 0; dut->in1 = 0; dut->in2 = 1; dut->in3 = 0;
    dut->eval();
    std::cout << " " << (int)dut->sel << "  |  " << (int)dut->in0 
              << "  |  " << (int)dut->in1 << "  |  " << (int)dut->in2 
              << "  |  " << (int)dut->in3 << "  |  " << (int)dut->out 
              << "  |   in2" << std::endl;
    assert(dut->out == dut->in2 && "Test failed: sel=10 should select in2");
    
    // Test case 4: sel=11, select in3
    dut->sel = 3;
    dut->in0 = 0; dut->in1 = 0; dut->in2 = 0; dut->in3 = 1;
    dut->eval();
    std::cout << " " << (int)dut->sel << "  |  " << (int)dut->in0 
              << "  |  " << (int)dut->in1 << "  |  " << (int)dut->in2 
              << "  |  " << (int)dut->in3 << "  |  " << (int)dut->out 
              << "  |   in3" << std::endl;
    assert(dut->out == dut->in3 && "Test failed: sel=11 should select in3");
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "All tests passed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
