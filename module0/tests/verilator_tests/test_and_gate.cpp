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

class TestBench {
private:
    Vand_gate* dut;
    int test_count;
    int pass_count;
    int fail_count;

public:
    TestBench() : test_count(0), pass_count(0), fail_count(0) {
        dut = new Vand_gate;
    }
    
    ~TestBench() {
        dut->final();
        delete dut;
    }
    
    // Check a specific input combination
    void check_and(uint8_t a_val, uint8_t b_val, uint8_t expected) {
        dut->a = a_val;
        dut->b = b_val;
        dut->eval();
        
        test_count++;
        
        if (dut->y == expected) {
            pass_count++;
            std::cout << "[PASS] Test " << test_count 
                      << ": a=" << (int)a_val << ", b=" << (int)b_val 
                      << ", y=" << (int)dut->y << " (expected " << (int)expected << ")" 
                      << std::endl;
        } else {
            fail_count++;
            std::cerr << "[FAIL] Test " << test_count 
                      << ": a=" << (int)a_val << ", b=" << (int)b_val 
                      << ", y=" << (int)dut->y << " (expected " << (int)expected << ")" 
                      << std::endl;
        }
    }
    
    // Run all tests
    void run_tests() {
        std::cout << "========================================" << std::endl;
        std::cout << "AND Gate Comprehensive Test (Verilator)" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << std::endl;
        
        // Test all input combinations
        check_and(0, 0, 0);
        check_and(0, 1, 0);
        check_and(1, 0, 0);
        check_and(1, 1, 1);
        
        // Print summary
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
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    // Create and run testbench
    TestBench tb;
    tb.run_tests();
    
    // Return exit code based on test results
    return (tb.get_fail_count() == 0) ? 0 : 1;
}
