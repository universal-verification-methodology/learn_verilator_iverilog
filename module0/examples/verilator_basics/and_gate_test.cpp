/**
 * Simple AND Gate Testbench for Verilator
 * 
 * This testbench demonstrates:
 * - Verilator compilation process
 * - DUT instantiation in C++
 * - Signal access via Verilator API
 * - Basic test patterns (exhaustive truth table testing)
 * - Self-checking testbench with assertions
 * 
 * Learning Objectives:
 * - Understand how Verilator generates C++ classes from Verilog
 * - Learn how to access DUT ports as C++ member variables
 * - Learn the eval() method for simulation
 * - Understand test vector application in C++
 * - Learn assertion-based verification
 * 
 * Test Strategy:
 * - Exhaustive testing: test all 2^2 = 4 input combinations
 * - Self-checking: use assert() to verify outputs
 * - Clear output: formatted table showing test results
 * 
 * Compilation and Execution:
 *   1. Compile: verilator --cc --exe --build -I../../dut/simple_gates and_gate.v and_gate_test.cpp
 *      - -I<path>: Add include path for Verilog files
 *      - Output: ./obj_dir/Vand_gate executable
 *   2. Run: ./obj_dir/Vand_gate
 * 
 * Key Concepts:
 * - Verilator ports become public member variables
 * - Inputs: Write directly (dut->a = 1)
 * - Outputs: Read after eval() (dut->y)
 * - eval() must be called after changing inputs
 * - Use assert() for self-checking testbenches
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/simple_gates and_gate.v and_gate_test.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>      // Standard I/O (cout, endl)
#include <cassert>       // Assertions for self-checking
#include <verilated.h>   // Verilator base library
#include "Vand_gate.h"   // Generated DUT class header

/**
 * Main function - Entry point for Verilator testbench
 * 
 * @param argc Argument count (from command line)
 * @param argv Argument vector (command line arguments)
 * @return Exit code (0 = success, non-zero = failure)
 */
int main(int argc, char** argv) {
    /**
     * Initialize Verilator
     * 
     * Processes command-line arguments for Verilator options.
     * Must be called before creating DUT instances.
     */
    Verilated::commandArgs(argc, argv);
    
    // Test header
    std::cout << "========================================" << std::endl;
    std::cout << "AND Gate Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    /**
     * Create DUT Instance
     * 
     * Verilator generates class "Vand_gate" from module "and_gate".
     * The DUT object contains:
     * - Member variables: a, b (inputs), y (output)
     * - Methods: eval(), final(), etc.
     */
    Vand_gate* dut = new Vand_gate;
    
    // Test table header
    std::cout << "\nTesting AND gate truth table:" << std::endl;
    std::cout << "  a  |  b  |  y  | Expected" << std::endl;
    std::cout << "-----|-----|-----|----------" << std::endl;
    
    /**
     * Test Case 1: 0 & 0 = 0
     * 
     * Test procedure:
     * 1. Set input values (dut->a, dut->b)
     * 2. Call eval() to simulate combinational logic
     * 3. Read output (dut->y)
     * 4. Verify output matches expected value
     * 
     * Note: For combinational logic, eval() immediately updates outputs.
     *       No clock or delay needed.
     */
    dut->a = 0;  // Set input A to 0
    dut->b = 0;  // Set input B to 0
    dut->eval(); // Evaluate combinational logic
    std::cout << "  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0" << std::endl;
    // Assert: verify output is correct (aborts if false)
    assert(dut->y == 0 && "Test failed: 0 & 0 should be 0");
    
    /**
     * Test Case 2: 0 & 1 = 0
     * 
     * One input is 0, so output should be 0 (AND requires both to be 1).
     */
    dut->a = 0;
    dut->b = 1;
    dut->eval();
    std::cout << "  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0" << std::endl;
    assert(dut->y == 0 && "Test failed: 0 & 1 should be 0");
    
    /**
     * Test Case 3: 1 & 0 = 0
     * 
     * Symmetric to test case 2.
     */
    dut->a = 1;
    dut->b = 0;
    dut->eval();
    std::cout << "  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    0" << std::endl;
    assert(dut->y == 0 && "Test failed: 1 & 0 should be 0");
    
    /**
     * Test Case 4: 1 & 1 = 1
     * 
     * Both inputs are 1, so output should be 1 (only case where AND is true).
     */
    dut->a = 1;
    dut->b = 1;
    dut->eval();
    std::cout << "  " << (int)dut->a << "  |  " << (int)dut->b 
              << "  |  " << (int)dut->y << "  |    1" << std::endl;
    assert(dut->y == 1 && "Test failed: 1 & 1 should be 1");
    
    // Test completion message
    std::cout << "\n========================================" << std::endl;
    std::cout << "All tests passed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    /**
     * Cleanup
     * 
     * Always call final() before deleting DUT to:
     * - Close trace files (if any)
     * - Finalize statistics
     * - Perform proper cleanup
     */
    dut->final();  // Cleanup
    delete dut;     // Free memory
    
    return 0;  // Exit successfully
}
