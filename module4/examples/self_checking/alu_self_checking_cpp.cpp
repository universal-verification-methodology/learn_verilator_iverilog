/**
 * Self-Checking ALU C++ Testbench
 * 
 * This testbench demonstrates a self-checking verification approach using C++
 * classes. The testbench automatically calculates expected values and compares
 * them against actual DUT outputs, eliminating the need for manual result checking.
 * 
 * Learning Objectives:
 * - Understand self-checking testbench architecture in C++
 * - Learn expected value calculation (reference model)
 * - Master automatic error detection and reporting
 * - Understand test result aggregation
 * - Learn class-based testbench organization
 * 
 * UVM Pattern Inspiration:
 * Self-checking testbenches are fundamental to UVM methodology:
 * - Reference models: Calculate expected values
 * - Scoreboards: Compare expected vs actual
 * - Test sequences: Organize test cases
 * - Result reporting: Aggregate and report results
 * 
 * Key Concepts:
 * - Reference Model: Method that calculates expected results
 * - Test Method: Reusable procedure for running test cases
 * - Automatic Checking: Compare actual vs expected automatically
 * - Result Aggregation: Track pass/fail statistics
 * 
 * Compilation and Execution:
 *   verilator --cc --exe --build -I../../dut/alus ../../dut/alus/simple_alu.v alu_self_checking_cpp.cpp
 *   ./obj_dir/Vsimple_alu
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/alus ../../dut/alus/simple_alu.v alu_self_checking_cpp.cpp
 *   ./obj_dir/Vsimple_alu
 */

#include <iostream>        // Standard I/O (cout, cerr, endl)
#include <iomanip>         // I/O manipulators (hex, setw, setfill)
#include <cassert>         // Assertions (for debugging)
#include <verilated.h>     // Verilator base library
#include "Vsimple_alu.h"   // Verilator-generated DUT class

/**
 * ALU Testbench Class
 * 
 * Purpose: Encapsulate all testbench functionality in a single class
 * 
 * This class demonstrates object-oriented testbench design:
 * - Encapsulation: DUT and test logic contained in class
 * - State management: Test statistics tracked internally
 * - Reusability: Test methods can be called multiple times
 * - Clean interface: Public methods for test execution
 * 
 * Design Pattern:
 * - Private members: DUT instance, test statistics, reference model
 * - Public methods: Test execution, result reporting
 * - Constructor/Destructor: DUT lifecycle management
 */
class ALUTestBench {
private:
    /**
     * DUT Instance
     * 
     * Pointer to Verilator-generated DUT class.
     * The DUT represents the ALU design being verified.
     */
    Vsimple_alu* dut;
    
    /**
     * Test Statistics
     * 
     * Track test execution results:
     * - test_count: Total number of tests executed
     * - pass_count: Number of tests that passed
     * - fail_count: Number of tests that failed
     */
    int test_count;
    int pass_count;
    int fail_count;
    
    /**
     * Reference Model: Calculate Expected Result
     * 
     * This method implements a reference model that calculates
     * the expected ALU result based on inputs. This is the "golden
     * reference" against which DUT outputs are compared.
     * 
     * Reference Model Logic:
     * - ADD (op=0): a + b
     * - SUB (op=1): a - b
     * - AND (op=2): a & b
     * - OR  (op=3): a | b
     * 
     * This method mirrors the DUT's logic, allowing automatic
     * verification without manual expected value entry.
     * 
     * @param a   Operand A value
     * @param b   Operand B value
     * @param op  Operation code (0=ADD, 1=SUB, 2=AND, 3=OR)
     * @return    Expected result value
     */
    uint8_t calculate_expected(uint8_t a, uint8_t b, uint8_t op) {
        switch (op) {
            case 0: return a + b;  // ADD: Arithmetic addition
            case 1: return a - b;  // SUB: Arithmetic subtraction
            case 2: return a & b;  // AND: Bitwise AND
            case 3: return a | b;  // OR:  Bitwise OR
            default: return 0;       // Default: Zero (shouldn't occur)
        }
    }
    
public:
    /**
     * Constructor
     * 
     * Initializes the testbench:
     * - Creates DUT instance
     * - Initializes test statistics to zero
     */
    ALUTestBench() : test_count(0), pass_count(0), fail_count(0) {
        dut = new Vsimple_alu;
    }
    
    /**
     * Destructor
     * 
     * Cleans up resources:
     * - Calls dut->final() to close files and finalize statistics
     * - Deletes DUT instance
     */
    ~ALUTestBench() {
        dut->final();
        delete dut;
    }
    
    /**
     * Test ALU Operation
     * 
     * This method performs a complete test cycle:
     * 1. Apply test inputs to DUT
     * 2. Evaluate DUT (compute result)
     * 3. Calculate expected value using reference model
     * 4. Compare actual vs expected
     * 5. Update test statistics
     * 6. Report pass/fail status
     * 
     * This method encapsulates the test pattern, making it easy to
     * run multiple test cases with different inputs.
     * 
     * @param a        Operand A value for this test
     * @param b        Operand B value for this test
     * @param op       Operation code for this test (0=ADD, 1=SUB, 2=AND, 3=OR)
     * @param op_name  Operation name (for logging, e.g., "ADD", "SUB")
     */
    void test_alu(uint8_t a, uint8_t b, uint8_t op, const std::string& op_name) {
        // Step 1: Apply inputs to DUT
        dut->a = a;
        dut->b = b;
        dut->op = op;
        dut->eval();  // Evaluate DUT (combinational logic computes result)
        
        // Step 2: Increment test counter
        test_count++;
        
        // Step 3: Calculate expected values using reference model
        uint8_t expected = calculate_expected(a, b, op);
        bool expected_zero = (expected == 0);  // Zero flag is 1 when result is 0
        
        // Step 4: Compare actual vs expected
        if (dut->result == expected && dut->zero == expected_zero) {
            // Test passed
            pass_count++;
            std::cout << "[PASS] Test " << test_count 
                      << ": " << op_name 
                      << " a=0x" << std::hex << std::setfill('0') << std::setw(2) << (int)a
                      << ", b=0x" << std::setw(2) << (int)b
                      << ", result=0x" << std::setw(2) << (int)dut->result
                      << ", zero=" << std::dec << (int)dut->zero << std::endl;
        } else {
            // Test failed
            fail_count++;
            std::cerr << "[FAIL] Test " << test_count 
                      << ": " << op_name 
                      << " a=0x" << std::hex << std::setfill('0') << std::setw(2) << (int)a
                      << ", b=0x" << std::setw(2) << (int)b
                      << ", expected=0x" << std::setw(2) << (int)expected
                      << " (zero=" << std::dec << (int)expected_zero << ")"
                      << ", got=0x" << std::hex << std::setw(2) << (int)dut->result
                      << " (zero=" << std::dec << (int)dut->zero << ")" << std::endl;
        }
    }
    
    /**
     * Print Test Summary
     * 
     * Generates a summary report of test execution:
     * - Total number of tests
     * - Number of passed tests
     * - Number of failed tests
     * - Overall pass/fail status
     * 
     * This provides a clear overview of test results at the end of execution.
     */
    void print_summary() {
        std::cout << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Test Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Total tests:  " << test_count << std::endl;
        std::cout << "Passed:       " << pass_count << std::endl;
        std::cout << "Failed:       " << fail_count << std::endl;
        std::cout << "========================================" << std::endl;
        
        // Determine overall test result
        if (fail_count == 0) {
            std::cout << "✓ All tests PASSED!" << std::endl;
        } else {
            std::cout << "✗ Some tests FAILED!" << std::endl;
        }
        std::cout << "========================================" << std::endl;
    }
    
    /**
     * Get Fail Count
     * 
     * Returns the number of failed tests.
     * Used to determine exit code (0 = pass, 1 = fail).
     * 
     * @return  Number of failed tests
     */
    int get_fail_count() const { return fail_count; }
};

/**
 * Main Function
 * 
 * Entry point for the testbench. Orchestrates the test sequence:
 * 1. Initialize Verilator
 * 2. Create testbench instance
 * 3. Execute test cases for each operation
 * 4. Print test summary
 * 5. Return exit code based on results
 * 
 * @param argc  Argument count (from command line)
 * @param argv  Argument vector (command line arguments)
 * @return      Exit code (0 = pass, 1 = fail)
 */
int main(int argc, char** argv) {
    // Initialize Verilator with command-line arguments
    // This processes any Verilator-specific options (e.g., --trace, --coverage)
    Verilated::commandArgs(argc, argv);
    
    // Print test header
    std::cout << "========================================" << std::endl;
    std::cout << "Self-Checking ALU Testbench" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create testbench instance
    ALUTestBench tb;
    
    // ========================================
    // Test Sequence
    // ========================================
    
    // Test ADD Operation (op=0)
    tb.test_alu(0x10, 0x20, 0, "ADD");  // Normal addition: 0x10 + 0x20 = 0x30
    tb.test_alu(0xFF, 0x01, 0, "ADD");  // Overflow test: 0xFF + 0x01 = 0x00 (wraps)
    tb.test_alu(0x00, 0x00, 0, "ADD");  // Zero result: 0x00 + 0x00 = 0x00
    
    // Test SUB Operation (op=1)
    tb.test_alu(0x30, 0x10, 1, "SUB");  // Normal subtraction: 0x30 - 0x10 = 0x20
    tb.test_alu(0x00, 0x01, 1, "SUB");  // Underflow test: 0x00 - 0x01 = 0xFF (wraps)
    
    // Test AND Operation (op=2)
    tb.test_alu(0xAA, 0x55, 2, "AND");  // Bit pattern: 0xAA & 0x55 = 0x00
    tb.test_alu(0xFF, 0xFF, 2, "AND");  // All ones: 0xFF & 0xFF = 0xFF
    tb.test_alu(0x00, 0xFF, 2, "AND");  // Zero mask: 0x00 & 0xFF = 0x00
    
    // Test OR Operation (op=3)
    tb.test_alu(0xAA, 0x55, 3, "OR");   // Bit pattern: 0xAA | 0x55 = 0xFF
    tb.test_alu(0x00, 0x00, 3, "OR");   // Zero result: 0x00 | 0x00 = 0x00
    
    // Print test summary
    tb.print_summary();
    
    // Return exit code: 0 = pass, 1 = fail
    return (tb.get_fail_count() == 0) ? 0 : 1;
}
