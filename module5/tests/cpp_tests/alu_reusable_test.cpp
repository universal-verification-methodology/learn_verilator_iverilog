/**
 * ALU Reusable Routines C++ Testbench (Verilator)
 * 
 * This testbench demonstrates reusable routines using C++ functions and classes.
 * 
 * Key Concepts:
 * - Function definitions for test sequences
 * - Class methods for organization
 * - Reusable verification routines
 * 
 * Usage:
 *   make alu_reusable_test
 *   or
 *   verilator --cc --exe --build -I../../../module4/dut/alus \
 *            ../../../module4/dut/alus/simple_alu.v alu_reusable_test.cpp
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
 * the expected output. This is a common pattern in verification.
 * 
 * @param a Input A value (8-bit)
 * @param b Input B value (8-bit)
 * @param op Operation code (0=ADD, 1=SUB, 2=AND, 3=OR)
 * @return Expected result (8-bit) based on operation
 */
uint8_t calculate_expected(uint8_t a, uint8_t b, uint8_t op) {
    switch (op) {
        case 0: return a + b;  // ADD
        case 1: return a - b;  // SUB
        case 2: return a & b;  // AND
        case 3: return a | b;  // OR
        default: return 0;
    }
}

/**
 * Testbench Class: ALUTestBench
 * 
 * This class encapsulates the entire testbench functionality:
 * - DUT instance management
 * - Test execution and statistics
 * - Result reporting
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
     */
    ALUTestBench() : test_count(0), pass_count(0), fail_count(0) {
        dut = new Vsimple_alu;
    }
    
    /**
     * Destructor
     * 
     * Cleans up DUT instance.
     */
    ~ALUTestBench() {
        dut->final();
        delete dut;
    }
    
    /**
     * Test ALU Operation
     * 
     * This method performs a complete test cycle:
     * 1. Apply inputs to DUT
     * 2. Evaluate combinational logic
     * 3. Calculate expected values
     * 4. Compare actual vs expected
     * 5. Update test statistics
     * 
     * @param a Operand A value
     * @param b Operand B value
     * @param op Operation code
     */
    void test_alu_operation(uint8_t a, uint8_t b, uint8_t op) {
        // Apply inputs
        dut->a = a;
        dut->b = b;
        dut->op = op;
        dut->eval();  // Evaluate combinational logic
        
        // Get operation name
        const char* op_name;
        switch (op) {
            case 0: op_name = "ADD"; break;
            case 1: op_name = "SUB"; break;
            case 2: op_name = "AND"; break;
            case 3: op_name = "OR "; break;
            default: op_name = "???"; break;
        }
        
        // Calculate expected values
        uint8_t expected_result = calculate_expected(a, b, op);
        bool expected_zero = (expected_result == 0);
        
        // Increment test counter
        test_count++;
        
        // Compare actual vs expected
        if ((dut->result == expected_result) && (dut->zero == expected_zero)) {
            pass_count++;
            std::cout << "Test " << test_count << " [PASS]: " << op_name 
                      << " a=0x" << std::hex << std::setw(2) << std::setfill('0') << (int)a
                      << ", b=0x" << std::setw(2) << (int)b
                      << " -> result=0x" << std::setw(2) << (int)dut->result
                      << ", zero=" << (int)dut->zero << std::dec << std::endl;
        } else {
            fail_count++;
            std::cerr << "Test " << test_count << " [FAIL]: " << op_name 
                      << " a=0x" << std::hex << std::setw(2) << std::setfill('0') << (int)a
                      << ", b=0x" << std::setw(2) << (int)b << std::dec << std::endl;
            std::cerr << "  Expected: result=0x" << std::hex << std::setw(2) << std::setfill('0') 
                      << (int)expected_result << ", zero=" << expected_zero << std::dec << std::endl;
            std::cerr << "  Actual:   result=0x" << std::hex << std::setw(2) << std::setfill('0') 
                      << (int)dut->result << ", zero=" << (int)dut->zero << std::dec << std::endl;
        }
    }
    
    /**
     * Run Test Suite
     * 
     * Executes a comprehensive test suite.
     */
    void run_test_suite() {
        // Test ADD operation
        test_alu_operation(0x10, 0x20, 0);  // 0x10 + 0x20 = 0x30
        test_alu_operation(0xFF, 0x01, 0);  // 0xFF + 0x01 = 0x00 (overflow)
        
        // Test SUB operation
        test_alu_operation(0x30, 0x10, 1);  // 0x30 - 0x10 = 0x20
        test_alu_operation(0x10, 0x20, 1);  // 0x10 - 0x20 = 0xF0 (underflow)
        
        // Test AND operation
        test_alu_operation(0xAA, 0x55, 2);  // 0xAA & 0x55 = 0x00
        test_alu_operation(0xFF, 0xAA, 2);  // 0xFF & 0xAA = 0xAA
        
        // Test OR operation
        test_alu_operation(0xAA, 0x55, 3);  // 0xAA | 0x55 = 0xFF
        test_alu_operation(0x00, 0x00, 3);  // 0x00 | 0x00 = 0x00
    }
    
    /**
     * Print Test Summary
     * 
     * Displays test execution statistics.
     */
    void print_summary() {
        std::cout << "\n========================================" << std::endl;
        std::cout << "Test Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Total tests: " << test_count << std::endl;
        std::cout << "Passed:      " << pass_count << std::endl;
        std::cout << "Failed:      " << fail_count << std::endl;
        std::cout << "========================================" << std::endl;
        
        if (fail_count > 0) {
            std::cerr << "Some tests failed!" << std::endl;
        } else {
            std::cout << "All tests passed!" << std::endl;
        }
    }
    
    /**
     * Get Exit Code
     * 
     * Returns 0 if all tests passed, 1 otherwise.
     */
    int get_exit_code() {
        return (fail_count > 0) ? 1 : 0;
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "ALU Reusable Routines C++ Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create testbench instance
    ALUTestBench tb;
    
    // Run test suite
    tb.run_test_suite();
    
    // Print summary
    tb.print_summary();
    
    // Return exit code
    return tb.get_exit_code();
}
