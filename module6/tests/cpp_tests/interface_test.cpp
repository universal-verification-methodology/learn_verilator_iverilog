/**
 * Interface-Based Testbench - C++ (Verilator Equivalent)
 * 
 * This testbench demonstrates interface-like patterns using C++ structs,
 * equivalent to SystemVerilog interfaces for Verilator.
 * 
 * Key Concepts:
 * - C++ structs for signal grouping
 * - Interface-like organization
 * - Signal encapsulation
 * 
 * Usage:
 *   make interface_test
 *   or
 *   verilator --cc --exe --build -I../../../module6/dut/simple_gates \
 *            ../../../module6/dut/simple_gates/and_gate.v interface_test.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vand_gate.h"

/**
 * AND Gate Interface Structure (C++ equivalent)
 * 
 * Encapsulates all signals for the AND gate.
 * This is the C++ equivalent of a SystemVerilog interface.
 */
struct AndGateInterface {
    uint8_t a;  // First input
    uint8_t b;  // Second input
    uint8_t y;  // Output
    
    // Helper methods for interface-like behavior
    void drive_inputs(uint8_t a_val, uint8_t b_val) {
        a = a_val;
        b = b_val;
    }
    
    void sample_output(uint8_t y_val) {
        y = y_val;
    }
    
    void print() {
        std::cout << "Interface: a=" << (int)a 
                  << ", b=" << (int)b 
                  << ", y=" << (int)y << std::endl;
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Interface-Based Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vand_gate* dut = new Vand_gate;
    
    // Create interface instance
    AndGateInterface iface;
    
    // Test case 1: a=0, b=0 -> expected: y=0
    iface.drive_inputs(0, 0);
    dut->a = iface.a;
    dut->b = iface.b;
    dut->eval();
    iface.sample_output(dut->y);
    std::cout << "Test 1: a=" << (int)iface.a 
              << ", b=" << (int)iface.b 
              << ", y=" << (int)iface.y 
              << " (expected 0) " << ((iface.y == 0) ? "[PASS]" : "[FAIL]") << std::endl;
    assert(iface.y == 0 && "Test failed");
    
    // Test case 2: a=0, b=1 -> expected: y=0
    iface.drive_inputs(0, 1);
    dut->a = iface.a;
    dut->b = iface.b;
    dut->eval();
    iface.sample_output(dut->y);
    std::cout << "Test 2: a=" << (int)iface.a 
              << ", b=" << (int)iface.b 
              << ", y=" << (int)iface.y 
              << " (expected 0) " << ((iface.y == 0) ? "[PASS]" : "[FAIL]") << std::endl;
    assert(iface.y == 0 && "Test failed");
    
    // Test case 3: a=1, b=0 -> expected: y=0
    iface.drive_inputs(1, 0);
    dut->a = iface.a;
    dut->b = iface.b;
    dut->eval();
    iface.sample_output(dut->y);
    std::cout << "Test 3: a=" << (int)iface.a 
              << ", b=" << (int)iface.b 
              << ", y=" << (int)iface.y 
              << " (expected 0) " << ((iface.y == 0) ? "[PASS]" : "[FAIL]") << std::endl;
    assert(iface.y == 0 && "Test failed");
    
    // Test case 4: a=1, b=1 -> expected: y=1
    iface.drive_inputs(1, 1);
    dut->a = iface.a;
    dut->b = iface.b;
    dut->eval();
    iface.sample_output(dut->y);
    std::cout << "Test 4: a=" << (int)iface.a 
              << ", b=" << (int)iface.b 
              << ", y=" << (int)iface.y 
              << " (expected 1) " << ((iface.y == 1) ? "[PASS]" : "[FAIL]") << std::endl;
    assert(iface.y == 1 && "Test failed");
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "All tests completed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
