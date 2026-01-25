/**
 * Function and Class Example - C++
 * 
 * Demonstrates:
 * - Function definitions for test sequences
 * - Class methods for organization
 * - Parameter passing
 * - Reusable verification routines
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/alus ../../dut/alus/simple_alu.v function_class_test_cpp.cpp
 *   ./obj_dir/Vsimple_alu
 */

#include <iostream>
#include <iomanip>
#include <cassert>
#include <verilated.h>
#include "Vsimple_alu.h"

/**
 * Helper Function: Calculate Expected Result
 * 
 * This function performs the same calculation as the DUT to determine
 * the expected output. This is a common pattern in verification:
 * - Use a reference model (golden model) to calculate expected results
 * - Compare DUT output with expected result
 * - Report mismatches as test failures
 * 
 * Key points:
 * - Pure function: no side effects, only calculation
 * - Reusable: can be called from multiple places
 * - Testable: can be unit tested independently
 * - Maintainable: change calculation logic in one place
 * 
 * @param a Input A value (8-bit)
 * @param b Input B value (8-bit)
 * @param op Operation code (0=ADD, 1=SUB, 2=AND, 3=OR)
 * @return Expected result (8-bit) based on operation
 * 
 * UVM Connection: Helper functions in C++ testbenches become utility
 * methods in UVM components. UVM provides many utility functions in
 * base classes (e.g., `uvm_component`, `uvm_object`).
 */
uint8_t calculate_expected(uint8_t a, uint8_t b, uint8_t op) {
    switch (op) {
        case 0: return a + b;  // ADD: arithmetic addition
        case 1: return a - b;  // SUB: arithmetic subtraction
        case 2: return a & b;  // AND: bitwise AND
        case 3: return a | b;  // OR: bitwise OR
        default: return 0;    // Default: return 0 for invalid op
    }
}

/**
 * Testbench Class: ALUTestBench
 * 
 * This class encapsulates the entire testbench functionality:
 * - DUT instance management
 * - Test execution and statistics
 * - Result reporting
 * 
 * Benefits of class-based testbench:
 * - Organization: Related functionality grouped together
 * - Reusability: Can be extended for more complex tests
 * - Resource Management: Constructor/destructor handle DUT lifecycle
 * - State Management: Test statistics maintained in object
 * - Encapsulation: Private members protect internal state
 * 
 * Class Design Patterns:
 * - Constructor: Initialize DUT and test statistics
 * - Destructor: Cleanup DUT (call final(), delete)
 * - Public Methods: Test interface (test_alu_operation, run_test_suite)
 * - Private Members: Internal state (dut, counters)
 * 
 * UVM Connection: This class pattern directly maps to UVM components:
 * - Constructor → `new()` and `build_phase()`
 * - Destructor → `final()` phase
 * - Methods → Phase methods (`run_phase()`, `check_phase()`, etc.)
 * - Private members → Component state and configuration
 * 
 * In UVM, components are organized in a hierarchy:
 * - `uvm_test` (top-level)
 *   - `uvm_env` (test environment)
 *     - `uvm_agent` (interface components)
 *       - `uvm_driver`, `uvm_monitor`, `uvm_sequencer`
 */
class ALUTestBench {
private:
    Vsimple_alu* dut;      // DUT instance pointer
    int test_count;         // Total number of tests run
    int pass_count;         // Number of passed tests
    int fail_count;         // Number of failed tests
    
public:
    /**
     * Constructor
     * 
     * Initializes test statistics and creates DUT instance.
     * Member initializer list sets counters to 0.
     * 
     * UVM Connection: Similar to UVM's `new()` and `build_phase()`:
     * - Create component instances
     * - Initialize configuration
     * - Set up component hierarchy
     */
    ALUTestBench() : test_count(0), pass_count(0), fail_count(0) {
        dut = new Vsimple_alu;  // Create DUT instance
    }
    
    /**
     * Destructor
     * 
     * Cleans up DUT instance when testbench object is destroyed.
     * Always call final() before deleting DUT to:
     * - Close trace files (if any)
     * - Finalize statistics
     * - Perform proper cleanup
     * 
     * UVM Connection: Similar to UVM's `final()` phase:
     * - Cleanup resources
     * - Finalize statistics
     * - Close files and connections
     */
    ~ALUTestBench() {
        dut->final();  // Cleanup before deletion
        delete dut;     // Free memory
    }
    
    // Method: Test ALU operation
    void test_alu_operation(uint8_t a, uint8_t b, uint8_t op, const std::string& op_name) {
        dut->a = a;
        dut->b = b;
        dut->op = op;
        dut->eval();
        
        test_count++;
        
        uint8_t expected = calculate_expected(a, b, op);
        bool expected_zero = (expected == 0);
        
        if (dut->result == expected && dut->zero == expected_zero) {
            pass_count++;
            std::cout << "[PASS] Test " << test_count 
                      << ": " << op_name 
                      << " a=0x" << std::hex << std::setfill('0') << std::setw(2) << (int)a
                      << ", b=0x" << std::setw(2) << (int)b
                      << ", result=0x" << std::setw(2) << (int)dut->result << std::dec << std::endl;
        } else {
            fail_count++;
            std::cerr << "[FAIL] Test " << test_count 
                      << ": " << op_name 
                      << " a=0x" << std::hex << std::setfill('0') << std::setw(2) << (int)a
                      << ", b=0x" << std::setw(2) << (int)b
                      << ", expected=0x" << std::setw(2) << (int)expected
                      << ", got=0x" << std::setw(2) << (int)dut->result << std::dec << std::endl;
        }
    }
    
    // Method: Run test suite
    void run_test_suite() {
        std::cout << "========================================" << std::endl;
        std::cout << "Running ALU Test Suite" << std::endl;
        std::cout << "========================================" << std::endl;
        
        // Test ADD
        test_alu_operation(0x10, 0x20, 0, "ADD");
        test_alu_operation(0xFF, 0x01, 0, "ADD");
        
        // Test SUB
        test_alu_operation(0x30, 0x10, 1, "SUB");
        test_alu_operation(0x00, 0x01, 1, "SUB");
        
        // Test AND
        test_alu_operation(0xAA, 0x55, 2, "AND");
        test_alu_operation(0xFF, 0xFF, 2, "AND");
        
        // Test OR
        test_alu_operation(0xAA, 0x55, 3, "OR");
        test_alu_operation(0x00, 0x00, 3, "OR");
    }
    
    // Method: Print summary
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
    
    ALUTestBench tb;
    tb.run_test_suite();
    tb.print_summary();
    
    return (tb.get_fail_count() == 0) ? 0 : 1;
}
