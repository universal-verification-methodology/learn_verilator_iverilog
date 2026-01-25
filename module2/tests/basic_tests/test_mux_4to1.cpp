/**
 * Comprehensive 4-to-1 Multiplexer C++ Test
 * 
 * This testbench demonstrates advanced testbench organization patterns:
 * - Class-based testbench structure (better organization than procedural)
 * - Test result tracking and reporting
 * - Comprehensive test coverage
 * - Error reporting with detailed messages
 * - Test summary generation
 * 
 * Class-Based Testbench Benefits:
 *   - Encapsulation: DUT and test state managed together
 *   - Reusability: Test methods can be called multiple times
 *   - Maintainability: Clear separation of concerns
 *   - Extensibility: Easy to add new test methods
 *   - State Management: Test counts tracked automatically
 * 
 * This pattern is inspired by modern verification methodologies (UVM-style
 * organization) but simplified for Verilator C++ testbenches.
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/multiplexers mux_4to1.v test_mux_4to1.cpp
 *   ./obj_dir/Vmux_4to1
 */

#include <iostream>      // Console I/O
#include <cassert>        // Assertions (optional, not used here but good practice)
#include <verilated.h>    // Verilator core
#include "Vmux_4to1.h"    // Generated wrapper

/**
 * TestBench Class
 * 
 * Encapsulates the DUT and test infrastructure in a single class.
 * This is a common pattern in modern testbench design, similar to
 * UVM test classes but adapted for Verilator C++.
 */
class TestBench {
private:
    Vmux_4to1* dut;      // Design Under Test instance
    int test_count;      // Total number of tests executed
    int pass_count;      // Number of passing tests
    int fail_count;      // Number of failing tests

public:
    /**
     * Constructor
     * 
     * Initializes test counters and creates DUT instance.
     * Member initializer list ensures counters start at 0.
     */
    TestBench() : test_count(0), pass_count(0), fail_count(0) {
        dut = new Vmux_4to1;
    }
    
    /**
     * Destructor
     * 
     * Ensures proper cleanup of DUT and Verilator resources.
     * This is called automatically when TestBench object goes out of scope.
     */
    ~TestBench() {
        dut->final();  // Must call final() before delete
        delete dut;
    }
    
    /**
     * Test Single Multiplexer Configuration
     * 
     * Applies a test vector to the DUT and checks the result.
     * Updates test statistics automatically.
     * 
     * @param sel Select signal value (0-3)
     * @param in0 Input 0 value
     * @param in1 Input 1 value
     * @param in2 Input 2 value
     * @param in3 Input 3 value
     * @param expected Expected output value
     */
    void test_mux(uint8_t sel, uint8_t in0, uint8_t in1, uint8_t in2, uint8_t in3, uint8_t expected) {
        // Apply test vector to DUT
        dut->sel = sel;
        dut->in0 = in0;
        dut->in1 = in1;
        dut->in2 = in2;
        dut->in3 = in3;
        
        // Evaluate combinational logic
        dut->eval();
        
        // Update test statistics
        test_count++;
        
        // Check result and update pass/fail counts
        if (dut->out == expected) {
            pass_count++;
            std::cout << "[PASS] Test " << test_count 
                      << ": sel=" << (int)sel << ", out=" << (int)dut->out 
                      << " (expected " << (int)expected << ")" << std::endl;
        } else {
            fail_count++;
            // Use std::cerr for errors (separate from normal output)
            std::cerr << "[FAIL] Test " << test_count 
                      << ": sel=" << (int)sel << ", out=" << (int)dut->out 
                      << " (expected " << (int)expected << ")" << std::endl;
        }
    }
    
    /**
     * Run Complete Test Suite
     * 
     * Executes all test cases and prints a summary.
     * This method orchestrates the entire test sequence.
     */
    void run_tests() {
        std::cout << "========================================" << std::endl;
        std::cout << "4-to-1 Multiplexer Comprehensive Test" << std::endl;
        std::cout << "========================================" << std::endl;
        
        // ====================================================================
        // Test Group 1: Verify each select line works correctly
        // ====================================================================
        // Strategy: Set only the selected input to 1, others to 0.
        // If mux works, output should equal the selected input.
        test_mux(0, 1, 0, 0, 0, 1);  // sel=00 (binary), select in0, expect 1
        test_mux(1, 0, 1, 0, 0, 1);  // sel=01 (binary), select in1, expect 1
        test_mux(2, 0, 0, 1, 0, 1);  // sel=10 (binary), select in2, expect 1
        test_mux(3, 0, 0, 0, 1, 1);  // sel=11 (binary), select in3, expect 1
        
        // ====================================================================
        // Test Group 2: Verify output is 0 when all inputs are 0
        // ====================================================================
        // This tests that the mux correctly passes through 0 values.
        test_mux(0, 0, 0, 0, 0, 0);  // sel=00, all inputs 0, expect 0
        test_mux(1, 0, 0, 0, 0, 0);  // sel=01, all inputs 0, expect 0
        test_mux(2, 0, 0, 0, 0, 0);  // sel=10, all inputs 0, expect 0
        test_mux(3, 0, 0, 0, 0, 0);  // sel=11, all inputs 0, expect 0
        
        // ====================================================================
        // Print Test Summary
        // ====================================================================
        std::cout << "\n========================================" << std::endl;
        std::cout << "Test Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Total tests:  " << test_count << std::endl;
        std::cout << "Passed:       " << pass_count << std::endl;
        std::cout << "Failed:       " << fail_count << std::endl;
        std::cout << "========================================" << std::endl;
        
        // Print final result
        if (fail_count == 0) {
            std::cout << "✓ All tests PASSED!" << std::endl;
        } else {
            std::cout << "✗ Some tests FAILED!" << std::endl;
        }
        std::cout << "========================================" << std::endl;
    }
    
    /**
     * Get Failure Count
     * 
     * Accessor method to get the number of failed tests.
     * Used to determine exit code in main().
     * 
     * @return Number of failed tests
     */
    int get_fail_count() const { return fail_count; }
};

int main(int argc, char** argv) {
    // ========================================================================
    // STEP 1: Initialize Verilator
    // ========================================================================
    Verilated::commandArgs(argc, argv);
    
    // ========================================================================
    // STEP 2: Create and Run Testbench
    // ========================================================================
    // Using RAII (Resource Acquisition Is Initialization) pattern:
    // TestBench object is created on stack, automatically cleaned up when
    // it goes out of scope. The destructor handles DUT cleanup.
    TestBench tb;
    tb.run_tests();
    
    // ========================================================================
    // STEP 3: Return Exit Code
    // ========================================================================
    // Exit code: 0 = success, non-zero = failure
    // This is important for automated test scripts and CI/CD pipelines.
    // Scripts can check the exit code to determine if tests passed.
    return (tb.get_fail_count() == 0) ? 0 : 1;
}
