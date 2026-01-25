/**
 * 4-bit Counter C++ Testbench
 * 
 * This testbench demonstrates sequential logic verification patterns using C++
 * and Verilator, including clock generation via simulation loops, reset sequences,
 * and enable/disable control. These patterns are fundamental to all sequential
 * circuit verification and form the basis for more advanced UVM-based verification.
 * 
 * Key Concepts Demonstrated:
 * ==========================
 * 1. Clock Generation (UVM-inspired: Clock Agent):
 *    - Manual clock toggling in simulation loop
 *    - Clock period control via loop iteration
 *    - Independent clock generation pattern
 * 
 * 2. Reset Generation (UVM-inspired: Reset Agent):
 *    - Reset assertion and de-assertion
 *    - Reset verification
 *    - Reset timing control
 * 
 * 3. Sequential Logic Testing:
 *    - State machine verification
 *    - Clock edge-sensitive behavior
 *    - State transitions over multiple clock cycles
 * 
 * 4. Control Signal Testing:
 *    - Enable/disable functionality
 *    - State holding when disabled
 *    - Re-enable behavior
 * 
 * 5. Time Management:
 *    - Simulation time tracking (sim_time variable)
 *    - Clock cycle counting
 *    - Timing relationships between signals
 * 
 * 6. Test Sequence Organization:
 *    - Multiple test scenarios
 *    - Test isolation
 *    - Comprehensive coverage
 * 
 * Verilator Clock Generation Pattern:
 * ====================================
 * Unlike Verilog's always blocks, C++ testbenches must manually toggle the clock
 * in a loop. The pattern is:
 *   1. Toggle clock: dut->clk = !dut->clk;
 *   2. Evaluate: dut->eval();
 *   3. Advance time: sim_time++;
 * 
 * UVM Pattern Mapping (for future reference):
 * ============================================
 * - Clock generation: Would be a UVM clock agent
 * - Reset generation: Would be a UVM reset agent
 * - Test sequence: Would be a UVM test class with multiple test phases
 * - Monitoring: Would be a UVM monitor collecting transactions
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/counters \
 *            ../../dut/counters/counter_4bit.v counter_test.cpp
 *   ./obj_dir/Vcounter_4bit
 */

#include <iostream>          // Standard I/O for test reporting
#include <cassert>           // Assert macro for result checking
#include <verilated.h>       // Verilator base library
#include "Vcounter_4bit.h"    // Verilator-generated DUT class

/**
 * Main test function
 * 
 * Orchestrates the entire test sequence for the 4-bit counter.
 * Demonstrates manual clock generation and sequential logic testing.
 * 
 * @param argc Command-line argument count
 * @param argv Command-line argument vector
 * @return Exit status (0 = success, non-zero = failure)
 */
int main(int argc, char** argv) {
    // ========================================================================
    // VERILATOR INITIALIZATION
    // ========================================================================
    Verilated::commandArgs(argc, argv);
    
    // ========================================================================
    // TEST HEADER
    // ========================================================================
    std::cout << "========================================" << std::endl;
    std::cout << "4-bit Counter C++ Testbench" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================================================
    // DUT (DESIGN UNDER TEST) INSTANTIATION
    // ========================================================================
    Vcounter_4bit* dut = new Vcounter_4bit;
    
    // ========================================================================
    // SIMULATION VARIABLES
    // ========================================================================
    // Track simulation time (in clock cycles)
    // vluint64_t is Verilator's 64-bit unsigned integer type
    vluint64_t sim_time = 0;
    
    // ========================================================================
    // INITIALIZATION PHASE
    // ========================================================================
    // Set initial signal states
    dut->clk = 0;      // Start with clock low
    dut->rst_n = 0;    // Assert reset (active low)
    dut->en = 0;       // Disable counting initially
    
    // ========================================================================
    // TEST 1: RESET VERIFICATION
    // ========================================================================
    // Verify that reset properly initializes counter to 0
    std::cout << "\nTest 1: Reset (rst_n=0)" << std::endl;
    
    // Apply reset for multiple clock cycles
    // Clock toggling pattern:
    //   1. Toggle clock (creates clock edge)
    //   2. Call eval() to propagate signals through DUT
    //   3. Increment simulation time
    for (int i = 0; i < 5; i++) {
        dut->clk = !dut->clk;  // Toggle clock (0->1 or 1->0)
        dut->eval();           // Evaluate combinational and sequential logic
        sim_time++;             // Advance simulation time
    }
    
    // Verify counter is reset to 0
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (expected 0)" << std::endl;
    assert(dut->count == 0 && "Reset failed: count should be 0");
    
    // ========================================================================
    // TEST 2: COUNTING OPERATION
    // ========================================================================
    // Verify counter increments when enabled
    std::cout << "\nTest 2: Release reset, enable counting" << std::endl;
    dut->rst_n = 1;  // Release reset (de-assert)
    dut->en = 1;     // Enable counting
    
    // Count for several clock cycles
    // Counter should increment on each rising clock edge
    for (int i = 0; i < 10; i++) {
        dut->clk = !dut->clk;  // Toggle clock
        dut->eval();           // Evaluate DUT
        sim_time++;            // Advance time
        
        // Print every other cycle to reduce output verbosity
        if (i % 2 == 0) {
            std::cout << "Time " << sim_time << ": count = " << (int)dut->count << std::endl;
        }
    }
    
    // ========================================================================
    // TEST 3: DISABLE FUNCTIONALITY
    // ========================================================================
    // Verify counter holds value when disabled
    std::cout << "\nTest 3: Disable counting (en=0)" << std::endl;
    dut->en = 0;  // Disable counting
    
    // Store count value before disabling
    // This allows verification that count doesn't change
    int count_before = dut->count;
    
    // Clock a few times with enable off
    // Counter should hold its value (not increment)
    for (int i = 0; i < 4; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    
    // Verify count didn't change
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (should hold at " << count_before << ")" << std::endl;
    assert(dut->count == count_before && "Enable disable failed: count should hold");
    
    // ========================================================================
    // TEST 4: RE-ENABLE OPERATION
    // ========================================================================
    // Verify counter resumes counting when re-enabled
    std::cout << "\nTest 4: Re-enable counting" << std::endl;
    dut->en = 1;  // Re-enable counting
    
    // Count a few more cycles
    for (int i = 0; i < 4; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count << std::endl;
    
    // ========================================================================
    // TEST 5: RESET DURING OPERATION
    // ========================================================================
    // Verify reset works even when counter is running
    std::cout << "\nTest 5: Reset again" << std::endl;
    dut->rst_n = 0;  // Assert reset again
    
    // Wait for reset to take effect (a few clock cycles)
    for (int i = 0; i < 2; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
    
    // Verify counter returned to 0
    std::cout << "Time " << sim_time << ": count = " << (int)dut->count 
              << " (expected 0)" << std::endl;
    assert(dut->count == 0 && "Reset failed: count should be 0");
    
    // ========================================================================
    // TEST SUMMARY
    // ========================================================================
    std::cout << "\n========================================" << std::endl;
    std::cout << "All tests completed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================================================
    // CLEANUP AND RESOURCE MANAGEMENT
    // ========================================================================
    dut->final();  // Cleanup DUT
    delete dut;    // Deallocate memory
    
    return 0;  // Return success
}
