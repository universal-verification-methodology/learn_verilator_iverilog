/**
 * Interface-Based Testbench - C++ (Verilator Equivalent)
 * 
 * Demonstrates:
 * - Equivalent C++ patterns for Verilator
 * - Struct-based interface simulation
 * - Signal grouping
 * 
 * This is the C++ equivalent for Verilator, using structs to simulate interfaces.
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/simple_gates ../../dut/simple_gates/and_gate.v interface_based_testbench_cpp.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vand_gate.h"

// Interface struct (C++ equivalent to SystemVerilog interface)
struct AndGateInterface {
    uint8_t a;
    uint8_t b;
    uint8_t y;
    
    AndGateInterface() : a(0), b(0), y(0) {}
};

class InterfaceBasedTestBench {
private:
    Vand_gate* dut;
    AndGateInterface iface;
    int test_count;
    int pass_count;
    int fail_count;
    
public:
    InterfaceBasedTestBench() : test_count(0), pass_count(0), fail_count(0) {
        dut = new Vand_gate;
    }
    
    ~InterfaceBasedTestBench() {
        dut->final();
        delete dut;
    }
    
    void test_and_gate(uint8_t a_val, uint8_t b_val, uint8_t expected) {
        test_count++;
        iface.a = a_val;
        iface.b = b_val;
        
        // Apply to DUT
        dut->a = iface.a;
        dut->b = iface.b;
        dut->eval();
        
        // Read from DUT
        iface.y = dut->y;
        
        if (iface.y == expected) {
            pass_count++;
            std::cout << "[PASS] Test " << test_count 
                      << ": a=" << (int)a_val << ", b=" << (int)b_val 
                      << ", y=" << (int)iface.y 
                      << ", expected=" << (int)expected << std::endl;
        } else {
            fail_count++;
            std::cerr << "[FAIL] Test " << test_count 
                      << ": a=" << (int)a_val << ", b=" << (int)b_val 
                      << ", y=" << (int)iface.y 
                      << ", expected=" << (int)expected << std::endl;
        }
    }
    
    void print_summary() {
        std::cout << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Test Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Total tests:  " << test_count << std::endl;
        std::cout << "Passed:       " << pass_count << std::endl;
        std::cout << "Failed:       " << fail_count << std::endl;
        std::cout << "========================================" << std::endl;
        
        if (fail_count == 0) {
            std::cout << "✓ All tests PASSED!" << std::endl;
        } else {
            std::cout << "✗ Some tests FAILED!" << std::endl;
        }
        std::cout << "========================================" << std::endl;
    }
    
    int get_fail_count() const { return fail_count; }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Interface-Based Testbench Example (C++)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    InterfaceBasedTestBench tb;
    
    // Test all combinations
    tb.test_and_gate(0, 0, 0);
    tb.test_and_gate(0, 1, 0);
    tb.test_and_gate(1, 0, 0);
    tb.test_and_gate(1, 1, 1);
    
    tb.print_summary();
    
    return (tb.get_fail_count() == 0) ? 0 : 1;
}
