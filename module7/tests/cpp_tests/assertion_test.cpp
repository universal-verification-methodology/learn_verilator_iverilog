/**
 * Basic Assertions Testbench - C++ (Verilator)
 * 
 * This testbench demonstrates basic assertion patterns using assert() and custom functions.
 * 
 * Key Concepts:
 * - Clock-based assertions
 * - Reset assertions
 * - Data validity assertions
 * - Error reporting in assertions
 * 
 * Usage:
 *   make assertion_test
 *   or
 *   verilator --cc --exe --build -I../../../module7/dut/counters \
 *            ../../../module7/dut/counters/counter_4bit.v assertion_test.cpp
 *   ./obj_dir/Vcounter_4bit
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vcounter_4bit.h"

// Helper function to tick clock
void tick_clock(Vcounter_4bit* dut, vluint64_t& sim_time, int cycles) {
    for (int i = 0; i < cycles; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
}

// Assertion statistics
int assertion_count = 0;
int assertion_pass = 0;
int assertion_fail = 0;

// Custom assertion function
void check_assertion(bool condition, const char* message) {
    assertion_count++;
    if (condition) {
        assertion_pass++;
    } else {
        assertion_fail++;
        std::cerr << "[ASSERT FAIL] " << message << std::endl;
    }
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Basic Assertions Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vcounter_4bit* dut = new Vcounter_4bit;
    vluint64_t sim_time = 0;
    
    // Initialize
    dut->clk = 0;
    dut->rst_n = 0;
    dut->en = 0;
    
    // Apply reset
    tick_clock(dut, sim_time, 3);
    
    // Assertion: Reset should clear counter
    check_assertion(dut->count == 0, "Reset assertion: count should be 0 when rst_n=0");
    
    // Release reset and enable counting
    dut->rst_n = 1;
    dut->en = 1;
    tick_clock(dut, sim_time, 10);
    
    // Assertion: Counter should not exceed 15
    check_assertion(dut->count <= 15, "Range assertion: count should be <= 15");
    
    // Disable counting
    dut->en = 0;
    uint8_t count_before = dut->count;
    tick_clock(dut, sim_time, 4);
    
    // Assertion: Counter should hold value when disabled
    check_assertion(dut->count == count_before, "Hold assertion: count should hold when en=0");
    
    // Re-enable
    dut->en = 1;
    tick_clock(dut, sim_time, 5);
    
    // Reset again
    dut->rst_n = 0;
    tick_clock(dut, sim_time, 2);
    
    // Assertion: Reset should clear counter again
    check_assertion(dut->count == 0, "Reset assertion: count should be 0 after reset");
    
    // Print assertion summary
    std::cout << "\n========================================" << std::endl;
    std::cout << "Assertion Summary" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "Total assertions: " << assertion_count << std::endl;
    std::cout << "Passed:           " << assertion_pass << std::endl;
    std::cout << "Failed:           " << assertion_fail << std::endl;
    std::cout << "========================================" << std::endl;
    
    if (assertion_fail > 0) {
        std::cerr << "Some assertions failed!" << std::endl;
    } else {
        std::cout << "All assertions passed!" << std::endl;
    }
    
    // Cleanup
    dut->final();
    delete dut;
    
    return (assertion_fail > 0) ? 1 : 0;
}
