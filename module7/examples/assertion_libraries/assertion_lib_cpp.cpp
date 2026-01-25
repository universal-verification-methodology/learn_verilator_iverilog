/**
 * Assertion Library Example - C++
 * 
 * Demonstrates:
 * - Reusable assertion helper functions and classes
 * - Assertion organization
 * - Assertion library patterns
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/simple_gates ../../dut/simple_gates/and_gate.v assertion_lib_cpp.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <sstream>
#include <verilated.h>
#include "Vand_gate.h"

// Assertion library class
class AssertionLib {
private:
    int pass_count;
    int fail_count;
    
public:
    AssertionLib() : pass_count(0), fail_count(0) {}
    
    // Assert equality
    void assert_equal(int actual, int expected, const std::string& message) {
        if (actual == expected) {
            pass_count++;
            std::cout << "[ASSERT PASS] " << message << std::endl;
        } else {
            fail_count++;
            std::cerr << "[ASSERT FAIL] " << message 
                      << ": expected " << expected 
                      << ", got " << actual << std::endl;
        }
    }
    
    // Assert range
    void assert_range(int value, int min, int max, const std::string& message) {
        if (value >= min && value <= max) {
            pass_count++;
            std::cout << "[ASSERT PASS] " << message << std::endl;
        } else {
            fail_count++;
            std::cerr << "[ASSERT FAIL] " << message 
                      << ": value " << value 
                      << " not in range [" << min << ":" << max << "]" << std::endl;
        }
    }
    
    // Assert true
    void assert_true(bool condition, const std::string& message) {
        if (condition) {
            pass_count++;
            std::cout << "[ASSERT PASS] " << message << std::endl;
        } else {
            fail_count++;
            std::cerr << "[ASSERT FAIL] " << message << std::endl;
        }
    }
    
    void print_summary() {
        std::cout << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Assertion Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Passed: " << pass_count << std::endl;
        std::cout << "Failed: " << fail_count << std::endl;
        std::cout << "========================================" << std::endl;
    }
    
    int get_fail_count() const { return fail_count; }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Assertion Library Example (C++)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vand_gate* dut = new Vand_gate;
    
    // Create assertion library
    AssertionLib assert_lib;
    
    // Test case 1
    dut->a = 0; dut->b = 0;
    dut->eval();
    assert_lib.assert_equal(dut->y, 0, "AND(0,0) should be 0");
    
    // Test case 2
    dut->a = 0; dut->b = 1;
    dut->eval();
    assert_lib.assert_equal(dut->y, 0, "AND(0,1) should be 0");
    
    // Test case 3
    dut->a = 1; dut->b = 0;
    dut->eval();
    assert_lib.assert_equal(dut->y, 0, "AND(1,0) should be 0");
    
    // Test case 4
    dut->a = 1; dut->b = 1;
    dut->eval();
    assert_lib.assert_equal(dut->y, 1, "AND(1,1) should be 1");
    
    // Range assertion example
    assert_lib.assert_range(dut->y, 0, 1, "Output should be in range [0:1]");
    
    // Boolean assertion example
    assert_lib.assert_true((dut->y == 0 || dut->y == 1), "Output should be boolean");
    
    // Print summary
    assert_lib.print_summary();
    
    std::cout << "========================================" << std::endl;
    std::cout << "Assertion library demonstration complete" << std::endl;
    std::cout << "========================================" << std::endl;
    
    dut->final();
    delete dut;
    
    return (assert_lib.get_fail_count() == 0) ? 0 : 1;
}
