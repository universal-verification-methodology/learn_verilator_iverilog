/**
 * 4-bit Counter C++ Testbench (Verilator)
 * 
 * This testbench demonstrates sequential logic verification patterns using C++
 * and Verilator, including clock generation via simulation loops, reset sequences,
 * and enable/disable control.
 * 
 * Key Concepts:
 * - Manual clock generation in simulation loop
 * - Reset sequences
 * - Sequential logic testing
 * - Enable/disable functionality
 * 
 * Usage:
 *   make counter_test
 *   or
 *   verilator --cc --exe --build -I../../../module1/dut/counters \
 *            ../../../module1/dut/counters/counter_4bit.v counter_test.cpp
 *   ./obj_dir/Vcounter_4bit
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vcounter_4bit.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "4-bit Counter C++ Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vcounter_4bit* dut = new Vcounter_4bit;
    
    // Simulation time tracking
    vluint64_t sim_time = 0;
    
    // Initialization
    dut->clk = 0;
    dut->rst_n = 0;  // Assert reset
    dut->en = 0;
    
    // Test 1: Reset verification
    std::cout << "\nTest 1: Reset (rst_n=0)" << std::endl;
    for (int i = 0; i < 5; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (expected 0)" << std::endl;
    assert(dut->count == 0 && "Reset failed: count should be 0");
    
    // Test 2: Counting operation
    std::cout << "\nTest 2: Release reset, enable counting" << std::endl;
    dut->rst_n = 1;  // Release reset
    dut->en = 1;     // Enable counting
    for (int i = 0; i < 10; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
        if (i % 2 == 0) {
            std::cout << "Time " << sim_time << ": count = " << (int)dut->count << std::endl;
        }
    }
    
    // Test 3: Disable functionality
    std::cout << "\nTest 3: Disable counting (en=0)" << std::endl;
    dut->en = 0;
    int count_before = dut->count;
    for (int i = 0; i < 4; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (should hold at " << count_before << ")" << std::endl;
    assert(dut->count == count_before && "Enable disable failed: count should hold");
    
    // Test 4: Re-enable operation
    std::cout << "\nTest 4: Re-enable counting" << std::endl;
    dut->en = 1;
    for (int i = 0; i < 4; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count << std::endl;
    
    // Test 5: Reset during operation
    std::cout << "\nTest 5: Reset again" << std::endl;
    dut->rst_n = 0;
    for (int i = 0; i < 2; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (expected 0)" << std::endl;
    assert(dut->count == 0 && "Reset failed: count should be 0");
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "All tests completed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
