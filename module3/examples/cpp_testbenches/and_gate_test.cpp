/**
 * AND Gate C++ Testbench
 * 
 * This testbench demonstrates fundamental C++ testbench concepts using Verilator
 * and introduces verification patterns inspired by UVM (Universal Verification Methodology).
 * While this is a simple example, it establishes patterns that scale to more
 * complex verification environments.
 * 
 * Key Concepts Demonstrated:
 * ==========================
 * 1. C++ Testbench Architecture:
 *    - Main function as test entry point (similar to UVM test class)
 *    - Object-oriented DUT instantiation
 *    - Separation of concerns: DUT, test sequence, cleanup
 * 
 * 2. Verilator Integration:
 *    - Verilator generates C++ wrapper class (Vand_gate) from Verilog
 *    - Signal access via class member variables
 *    - eval() method triggers combinational logic evaluation
 * 
 * 3. Stimulus Generation (UVM-inspired "Driver" concept):
 *    - Direct signal assignment via DUT object members
 *    - Exhaustive testing of all input combinations (2^2 = 4 test cases)
 *    - eval() call after stimulus application to propagate signals
 * 
 * 4. Response Monitoring (UVM-inspired "Monitor" concept):
 *    - Real-time output observation using std::cout
 *    - Signal value reading via DUT object members
 * 
 * 5. Result Checking (UVM-inspired "Scoreboard" concept):
 *    - Expected vs. actual value comparison
 *    - Pass/fail determination for each test case
 *    - Assertion-based error detection (assert macro)
 * 
 * 6. Test Reporting:
 *    - Formatted output for readability
 *    - Test summary
 * 
 * 7. Resource Management:
 *    - Proper DUT cleanup (final() and delete)
 *    - Memory leak prevention
 * 
 * UVM Pattern Mapping (for future reference):
 * ============================================
 * - This testbench combines what in UVM would be separate components:
 *   * Driver: Stimulus generation (lines 60-95)
 *   * Monitor: Response capture (lines 65-95)
 *   * Scoreboard: Result checking (assert statements)
 *   * Test: Test sequence orchestration (main function)
 * 
 * Verilator API Notes:
 * ====================
 * - dut->signal: Access DUT signals as class members
 * - dut->eval(): Evaluate combinational logic (call after changing inputs)
 * - dut->final(): Cleanup method (call before deletion)
 * - Verilated::commandArgs(): Parse command-line arguments
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/simple_gates \
 *            ../../dut/simple_gates/and_gate.v and_gate_test.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>      // Standard I/O for test reporting
#include <cassert>       // Assert macro for result checking
#include <verilated.h>   // Verilator base library (required)
#include "Vand_gate.h"   // Verilator-generated DUT class (from and_gate.v)

/**
 * Main test function
 * 
 * This function orchestrates the entire test sequence, similar to UVM's
 * test class run_phase() method. It follows the standard testbench flow:
 * 1. Initialize simulation environment
 * 2. Create DUT instance
 * 3. Apply stimulus and check responses
 * 4. Cleanup and exit
 * 
 * @param argc Command-line argument count
 * @param argv Command-line argument vector
 * @return Exit status (0 = success, non-zero = failure)
 */
int main(int argc, char** argv) {
    // ========================================================================
    // VERILATOR INITIALIZATION
    // ========================================================================
    // Parse command-line arguments for Verilator
    // This allows passing Verilator-specific options (e.g., --trace)
    Verilated::commandArgs(argc, argv);
    
    // ========================================================================
    // TEST HEADER
    // ========================================================================
    std::cout << "========================================" << std::endl;
    std::cout << "AND Gate C++ Testbench" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Print formatted table header
    // Format: Test # | Input a | Input b | Output y | Expected | Result
    std::cout << "Test |  a  |  b  |  y  | Expected | Pass/Fail" << std::endl;
    std::cout << "-----|-----|-----|-----|----------|----------" << std::endl;
    
    // ========================================================================
    // DUT (DESIGN UNDER TEST) INSTANTIATION
    // ========================================================================
    // Create DUT instance using Verilator-generated class
    // Verilator converts Verilog module 'and_gate' to C++ class 'Vand_gate'
    // The 'new' operator allocates memory on the heap
    Vand_gate* dut = new Vand_gate;
    
    // ========================================================================
    // TEST CASE 1: a=0, b=0 -> Expected output: y=0
    // ========================================================================
    // Apply stimulus: Set input values via DUT object members
    dut->a = 0;  // Set input 'a' to 0
    dut->b = 0;  // Set input 'b' to 0
    
    // Evaluate combinational logic
    // eval() must be called after changing inputs to propagate signals
    // This is equivalent to advancing simulation time in Verilog
    dut->eval();
    
    // Monitor response and check result
    // Cast to int for readable output (signals are typically uint8_t)
    std::cout << "  1  |  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0     |   " 
              << ((dut->y == 0) ? "PASS" : "FAIL") << std::endl;
    
    // Assertion: Verify expected output
    // assert() terminates program if condition is false
    // The string message is displayed on assertion failure
    assert(dut->y == 0 && "Test failed: Expected y=0");
    
    // ========================================================================
    // TEST CASE 2: a=0, b=1 -> Expected output: y=0
    // ========================================================================
    dut->a = 0;
    dut->b = 1;
    dut->eval();  // Propagate signal changes
    std::cout << "  2  |  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0     |   " 
              << ((dut->y == 0) ? "PASS" : "FAIL") << std::endl;
    assert(dut->y == 0 && "Test failed: Expected y=0");
    
    // ========================================================================
    // TEST CASE 3: a=1, b=0 -> Expected output: y=0
    // ========================================================================
    dut->a = 1;
    dut->b = 0;
    dut->eval();
    std::cout << "  3  |  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0     |   " 
              << ((dut->y == 0) ? "PASS" : "FAIL") << std::endl;
    assert(dut->y == 0 && "Test failed: Expected y=0");
    
    // ========================================================================
    // TEST CASE 4: a=1, b=1 -> Expected output: y=1
    // ========================================================================
    // This is the only case where AND gate output is 1
    dut->a = 1;
    dut->b = 1;
    dut->eval();
    std::cout << "  4  |  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    1     |   " 
              << ((dut->y == 1) ? "PASS" : "FAIL") << std::endl;
    assert(dut->y == 1 && "Test failed: Expected y=1");
    
    // ========================================================================
    // TEST SUMMARY
    // ========================================================================
    std::cout << "========================================" << std::endl;
    std::cout << "All tests completed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================================================
    // CLEANUP AND RESOURCE MANAGEMENT
    // ========================================================================
    // Call final() to perform any necessary cleanup in the DUT
    // This is important for proper simulation termination
    dut->final();
    
    // Deallocate DUT memory
    // Always delete objects created with 'new'
    delete dut;
    
    // Return success status
    // Exit code 0 indicates successful test completion
    return 0;
}
