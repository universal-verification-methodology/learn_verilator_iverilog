/**
 * Counter C++ Testbench for Verilator
 * 
 * This testbench demonstrates:
 * - Clock generation in C++
 * - Reset generation in C++
 * - Simulation loop
 * - Time management
 * - Sequential logic testing
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/counters counter_4bit.v counter_test.cpp
 *   ./obj_dir/Vcounter_4bit
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vcounter_4bit.h"

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "4-bit Counter C++ Testbench" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vcounter_4bit* dut = new Vcounter_4bit;
    
    // Simulation variables
    vluint64_t sim_time = 0;
    const vluint64_t max_time = 200;  // Maximum simulation time
    
    // Clock and reset initialization
    dut->clk = 0;
    dut->rst_n = 0;  // Start with reset active
    dut->en = 0;
    
    std::cout << "\nTest 1: Reset (rst_n=0)" << std::endl;
    // Apply reset for a few clock cycles
    for (int i = 0; i < 5; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (expected 0)" << std::endl;
    assert(dut->count == 0 && "Reset failed: count should be 0");
    
    std::cout << "\nTest 2: Release reset, enable counting" << std::endl;
    dut->rst_n = 1;
    dut->en = 1;
    
    // Count for several clock cycles
    for (int i = 0; i < 10; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
        if (i % 2 == 0) {  // Print every other cycle
            std::cout << "Time " << sim_time << ": count = " << (int)dut->count << std::endl;
        }
    }
    
    std::cout << "\nTest 3: Disable counting (en=0)" << std::endl;
    dut->en = 0;
    int count_before = dut->count;
    
    // Clock a few times with enable off
    for (int i = 0; i < 4; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (should hold at " << count_before << ")" << std::endl;
    assert(dut->count == count_before && "Enable disable failed: count should hold");
    
    std::cout << "\nTest 4: Re-enable counting" << std::endl;
    dut->en = 1;
    
    // Count a few more cycles
    for (int i = 0; i < 4; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count << std::endl;
    
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
