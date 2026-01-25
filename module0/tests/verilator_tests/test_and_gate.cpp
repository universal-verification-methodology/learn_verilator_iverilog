/**
 * Comprehensive AND Gate Testbench for Verilator
 * 
 * This testbench demonstrates:
 * - Complete test coverage
 * - Error reporting
 * - Test result summary
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/simple_gates and_gate.v test_and_gate.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vand_gate.h"

/**
 * TestBench Class
 * 
 * This class encapsulates the testbench functionality:
 * - Manages DUT instance
 * - Tracks test statistics
 * - Provides test methods
 * 
 * Benefits of class-based testbench:
 * - Organization: Related functionality grouped together
 * - Reusability: Can be extended for more complex tests
 * - Resource management: Constructor/destructor handle DUT lifecycle
 * - State management: Test statistics maintained in object
 */
class TestBench {
private:
    Vand_gate* dut;      // DUT instance pointer
    int test_count;       // Total number of tests run
    int pass_count;       // Number of passed tests
    int fail_count;       // Number of failed tests

public:
    /**
     * Constructor
     * 
     * Initializes test statistics and creates DUT instance.
     * Member initializer list sets counters to 0.
     */
    TestBench() : test_count(0), pass_count(0), fail_count(0) {
        dut = new Vand_gate;  // Create DUT instance
    }
    
    /**
     * Destructor
     * 
     * Cleans up DUT instance when testbench object is destroyed.
     * Always call final() before deleting DUT.
     */
    ~TestBench() {
        dut->final();  // Cleanup before deletion
        delete dut;     // Free memory
    }
    
    /**
     * Check a specific input combination
     * 
     * This method encapsulates the test procedure:
     * 1. Apply test vector to DUT inputs
     * 2. Evaluate DUT (simulate combinational logic)
     * 3. Compare output with expected value
     * 4. Update test statistics
     * 5. Report pass/fail
     * 
     * @param a_val Input A value to test
     * @param b_val Input B value to test
     * @param expected Expected output value
     * 
     * Note: Uses uint8_t for port values (Verilator ports are typically 8-bit)
     */
    void check_and(uint8_t a_val, uint8_t b_val, uint8_t expected) {
        // Apply test vector
        dut->a = a_val;
        dut->b = b_val;
        dut->eval();  // Evaluate combinational logic
        
        // Increment test counter
        test_count++;
        
        // Self-checking: compare actual vs expected
        if (dut->y == expected) {
            // Test passed
            pass_count++;
            std::cout << "[PASS] Test " << test_count 
                      << ": a=" << (int)a_val << ", b=" << (int)b_val 
                      << ", y=" << (int)dut->y << " (expected " << (int)expected << ")" 
                      << std::endl;
        } else {
            // Test failed
            fail_count++;
            // Use std::cerr for error output (separate from normal output)
            std::cerr << "[FAIL] Test " << test_count 
                      << ": a=" << (int)a_val << ", b=" << (int)b_val 
                      << ", y=" << (int)dut->y << " (expected " << (int)expected << ")" 
                      << std::endl;
        }
    }
    
    /**
     * Run all tests
     * 
     * Orchestrates the complete test sequence:
     * 1. Print test header
     * 2. Execute all test cases
     * 3. Print test summary with statistics
     * 4. Report overall pass/fail status
     * 
     * Test Coverage:
     * - Exhaustive: Tests all 2^2 = 4 input combinations
     * - Self-checking: Each test verifies its own result
     * - Statistical: Tracks pass/fail counts
     */
    void run_tests() {
        // Test header
        std::cout << "========================================" << std::endl;
        std::cout << "AND Gate Comprehensive Test (Verilator)" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << std::endl;
        
        /**
         * Exhaustive Test Cases
         * 
         * Test all possible input combinations (truth table):
         * - 0 & 0 = 0
         * - 0 & 1 = 0
         * - 1 & 0 = 0
         * - 1 & 1 = 1
         */
        check_and(0, 0, 0);  // Test case 1: Both inputs 0
        check_and(0, 1, 0);  // Test case 2: A=0, B=1
        check_and(1, 0, 0);  // Test case 3: A=1, B=0
        check_and(1, 1, 1);  // Test case 4: Both inputs 1
        
        /**
         * Test Summary
         * 
         * Print statistics to help understand test results.
         * This makes it easy to see test coverage and results at a glance.
         */
        std::cout << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Test Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Total tests:  " << test_count << std::endl;
        std::cout << "Passed:       " << pass_count << std::endl;
        std::cout << "Failed:       " << fail_count << std::endl;
        std::cout << "========================================" << std::endl;
        
        // Overall status
        if (fail_count == 0) {
            std::cout << "✓ All tests PASSED!" << std::endl;
        } else {
            std::cout << "✗ Some tests FAILED!" << std::endl;
        }
        
        std::cout << "========================================" << std::endl;
    }
    
    /**
     * Get failure count
     * 
     * @return Number of failed tests
     * 
     * Used to determine exit code in main().
     * const method: doesn't modify object state.
     */
    int get_fail_count() const { return fail_count; }
};

/**
 * Main function - Entry point for testbench
 * 
 * @param argc Argument count (from command line)
 * @param argv Argument vector (command line arguments)
 * @return Exit code (0 = success, 1 = failure)
 */
int main(int argc, char** argv) {
    // Initialize Verilator (process command-line arguments)
    Verilated::commandArgs(argc, argv);
    
    /**
     * Create and Run Testbench
     * 
     * The TestBench object:
     * - Creates DUT instance in constructor
     * - Runs all tests via run_tests()
     * - Cleans up DUT in destructor (automatic)
     */
    TestBench tb;
    tb.run_tests();
    
    /**
     * Return Exit Code
     * 
     * Exit code convention:
     * - 0: All tests passed (success)
     * - Non-zero: Some tests failed (failure)
     * 
     * This allows test automation tools to detect failures:
     *   ./test_and_gate && echo "Tests passed" || echo "Tests failed"
     */
    return (tb.get_fail_count() == 0) ? 0 : 1;
}
