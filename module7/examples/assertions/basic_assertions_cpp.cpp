/**
 * Basic Assertions Example - C++
 * 
 * Demonstrates:
 * - Basic assertion patterns using assert() macro
 * - Custom assertion functions
 * - Clock-based assertions
 * - Reset assertions
 * - Data validity assertions
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/counters ../../dut/counters/counter_4bit.v basic_assertions_cpp.cpp
 *   ./obj_dir/Vcounter_4bit
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vcounter_4bit.h"

class AssertionTracker {
private:
    int assertion_count;
    int assertion_pass;
    int assertion_fail;
    
public:
    AssertionTracker() : assertion_count(0), assertion_pass(0), assertion_fail(0) {}
    
    // Custom assertion function
    bool assert_check(const std::string& name, bool condition, const std::string& message = "") {
        assertion_count++;
        if (condition) {
            assertion_pass++;
            return true;
        } else {
            assertion_fail++;
            std::cerr << "[ASSERT FAIL] " << name;
            if (!message.empty()) {
                std::cerr << ": " << message;
            }
            std::cerr << std::endl;
            return false;
        }
    }
    
    void print_summary() {
        std::cout << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Assertion Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Total assertions:  " << assertion_count << std::endl;
        std::cout << "Passed:             " << assertion_pass << std::endl;
        std::cout << "Failed:             " << assertion_fail << std::endl;
        std::cout << "========================================" << std::endl;
        
        if (assertion_fail == 0) {
            std::cout << "✓ All assertions PASSED!" << std::endl;
        } else {
            std::cout << "✗ Some assertions FAILED!" << std::endl;
        }
        std::cout << "========================================" << std::endl;
    }
    
    int get_fail_count() const { return assertion_fail; }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Basic Assertions Example (C++)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vcounter_4bit* dut = new Vcounter_4bit;
    
    // Create assertion tracker
    AssertionTracker assertions;
    
    // Simulation variables
    vluint64_t sim_time = 0;
    int prev_count = 0;
    
    // Initialize clock
    dut->clk = 0;
    
    // Test 1: Reset assertion
    std::cout << "\nTest 1: Reset assertion" << std::endl;
    dut->rst_n = 0;
    dut->en = 0;
    
    for (int i = 0; i < 3; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
        
        assertions.assert_check("Reset assertion", 
                               dut->count == 0,
                               "count should be 0 when rst_n=0");
    }
    
    // Test 2: Increment assertion
    std::cout << "\nTest 2: Increment assertion" << std::endl;
    dut->rst_n = 1;
    dut->en = 1;
    prev_count = dut->count;
    
    for (int i = 0; i < 10; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
        
        if (i % 2 == 0 && i > 0) {  // Check on posedge
            int expected = (prev_count + 1) % 16;
            assertions.assert_check("Increment assertion",
                                   dut->count == expected,
                                   "count should increment from " + std::to_string(prev_count));
            prev_count = dut->count;
        }
    }
    
    // Test 3: Range assertion
    std::cout << "\nTest 3: Range assertion" << std::endl;
    for (int i = 0; i < 10; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
        
        if (i % 2 == 0) {
            assertions.assert_check("Range assertion",
                                   dut->count <= 15,
                                   "count should be <= 15");
        }
    }
    
    // Print assertion summary
    assertions.print_summary();
    
    dut->final();
    delete dut;
    
    return (assertions.get_fail_count() == 0) ? 0 : 1;
}
