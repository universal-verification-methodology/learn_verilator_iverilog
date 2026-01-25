/**
 * Counter C++ Testbench for Verilator
 * 
 * This testbench demonstrates sequential logic testing with Verilator:
 * - Clock generation in C++ (manual clock toggling)
 * - Reset generation and sequences (synchronous/asynchronous)
 * - Simulation loop and time management
 * - Sequential logic testing (counters, flip-flops)
 * - Enable/disable control signals
 * 
 * Key Differences from Combinational Logic:
 *   - Sequential logic requires clock edges to update state
 *   - Must toggle clock and call eval() at each edge
 *   - Reset must be applied before normal operation
 *   - State changes occur on clock edges, not immediately
 * 
 * Clock Generation Pattern:
 *   1. Set clock to 0 or 1
 *   2. Call eval() to propagate signals
 *   3. Toggle clock (0->1 or 1->0)
 *   4. Call eval() again to capture edge-triggered behavior
 *   5. Repeat for desired number of cycles
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/counters counter_4bit.v counter_test.cpp
 *   ./obj_dir/Vcounter_4bit
 * 
 * Expected Behavior:
 *   - Counter resets to 0 when rst_n=0
 *   - Counter increments on clock edges when en=1 and rst_n=1
 *   - Counter holds value when en=0
 */

#include <iostream>      // Console I/O
#include <cassert>        // Assertions for test verification
#include <verilated.h>    // Verilator core library
#include "Vcounter_4bit.h" // Generated wrapper class

int main(int argc, char** argv) {
    // ========================================================================
    // STEP 1: Initialize Verilator
    // ========================================================================
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "4-bit Counter C++ Testbench" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================================================
    // STEP 2: Create DUT Instance
    // ========================================================================
    Vcounter_4bit* dut = new Vcounter_4bit;
    
    // ========================================================================
    // STEP 3: Initialize Simulation Variables
    // ========================================================================
    // vluint64_t is Verilator's 64-bit unsigned integer type for simulation time.
    // It's used internally by Verilator for time tracking, especially for tracing.
    vluint64_t sim_time = 0;
    const vluint64_t max_time = 200;  // Maximum simulation time (safety limit)
    
    // ========================================================================
    // STEP 4: Initialize Clock and Control Signals
    // ========================================================================
    // Initialize all signals to known states before starting simulation.
    // This prevents undefined behavior and ensures predictable startup.
    dut->clk = 0;      // Start with clock low
    dut->rst_n = 0;    // Start with reset active (active-low reset)
    dut->en = 0;      // Start with counter disabled
    
    // ========================================================================
    // TEST 1: Reset Functionality
    // ========================================================================
    // Verify that reset (rst_n=0) forces counter to 0 regardless of clock.
    std::cout << "\nTest 1: Reset (rst_n=0)" << std::endl;
    
    // Apply reset for several clock cycles to ensure counter stays at 0.
    // Even if we toggle the clock, the counter should remain reset.
    for (int i = 0; i < 5; i++) {
        // Toggle clock: This creates a clock edge (rising or falling).
        // For sequential logic, state changes typically occur on clock edges.
        dut->clk = !dut->clk;
        
        // eval() must be called after every signal change to:
        //   1. Propagate combinational logic
        //   2. Update sequential elements (on clock edges)
        //   3. Update internal state
        dut->eval();
        
        sim_time++;  // Advance simulation time (for tracking/debugging)
    }
    
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (expected 0)" << std::endl;
    assert(dut->count == 0 && "Reset failed: count should be 0");
    
    // ========================================================================
    // TEST 2: Normal Counting Operation
    // ========================================================================
    // Release reset and enable counter. Verify it increments on clock edges.
    std::cout << "\nTest 2: Release reset, enable counting" << std::endl;
    dut->rst_n = 1;  // Release reset (active-low, so 1 = not reset)
    dut->en = 1;     // Enable counter
    
    // Count for several clock cycles. Each clock edge should increment counter.
    // Note: The actual increment happens on the clock edge, so we need to
    // toggle the clock and call eval() to see the state change.
    for (int i = 0; i < 10; i++) {
        dut->clk = !dut->clk;  // Toggle clock (creates edge)
        dut->eval();            // Evaluate: counter increments on edge
        sim_time++;
        
        // Print every other cycle to reduce output verbosity
        if (i % 2 == 0) {
            std::cout << "Time " << sim_time << ": count = " << (int)dut->count << std::endl;
        }
    }
    
    // ========================================================================
    // TEST 3: Enable/Disable Control
    // ========================================================================
    // Verify that when en=0, counter holds its value (doesn't increment).
    std::cout << "\nTest 3: Disable counting (en=0)" << std::endl;
    dut->en = 0;  // Disable counter
    int count_before = dut->count;  // Capture current count value
    
    // Clock several times with enable off. Counter should hold value.
    for (int i = 0; i < 4; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (should hold at " << count_before << ")" << std::endl;
    assert(dut->count == count_before && "Enable disable failed: count should hold");
    
    // ========================================================================
    // TEST 4: Re-enable Counting
    // ========================================================================
    // Verify counter resumes incrementing when re-enabled.
    std::cout << "\nTest 4: Re-enable counting" << std::endl;
    dut->en = 1;  // Re-enable counter
    
    // Count a few more cycles - should continue from where it left off
    for (int i = 0; i < 4; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count << std::endl;
    
    // ========================================================================
    // TEST 5: Reset During Operation
    // ========================================================================
    // Verify reset works even when counter is running.
    std::cout << "\nTest 5: Reset again" << std::endl;
    dut->rst_n = 0;  // Assert reset
    
    // Clock a couple times - counter should reset to 0
    for (int i = 0; i < 2; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (expected 0)" << std::endl;
    assert(dut->count == 0 && "Reset failed: count should be 0");
    
    // ========================================================================
    // STEP 5: Test Summary and Cleanup
    // ========================================================================
    std::cout << "\n========================================" << std::endl;
    std::cout << "All tests completed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup: Always call final() before deleting DUT
    dut->final();
    delete dut;
    
    return 0;
}
