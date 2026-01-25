/**
 * Class-Based Testbench - C++ (Verilator Equivalent)
 * 
 * This testbench demonstrates class-based testbench design using C++ classes,
 * equivalent to SystemVerilog classes for Verilator.
 * 
 * Key Concepts:
 * - C++ class syntax
 * - Transaction classes for data modeling
 * - Testbench classes for test orchestration
 * - Object instantiation and methods
 * 
 * Usage:
 *   make class_based_test
 *   or
 *   verilator --cc --exe --build -I../../../module6/dut/simple_gates \
 *            ../../../module6/dut/simple_gates/and_gate.v class_based_test.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <cassert>
#include <verilated.h>
#include "Vand_gate.h"

/**
 * Transaction Class (C++ equivalent)
 * 
 * Models a transaction (test vector) for the AND gate.
 */
class Transaction {
public:
    uint8_t a;
    uint8_t b;
    uint8_t expected;
    
    Transaction() : a(0), b(0), expected(0) {}
    
    void randomize() {
        // For demonstration, we'll use simple patterns
        // In real testbenches, use std::random
        static int count = 0;
        count++;
        a = (count / 2) % 2;
        b = count % 2;
        expected = a & b;  // Calculate expected result
    }
    
    void print() {
        std::cout << "Transaction: a=" << (int)a 
                  << ", b=" << (int)b 
                  << ", expected=" << (int)expected << std::endl;
    }
};

/**
 * Testbench Class (C++ equivalent)
 * 
 * Orchestrates test execution.
 */
class TestBench {
private:
    Transaction* tr;
    int test_count;
    int pass_count;
    int fail_count;
    
public:
    TestBench() : test_count(0), pass_count(0), fail_count(0) {
        tr = new Transaction();
    }
    
    ~TestBench() {
        delete tr;
    }
    
    void run_test(Vand_gate* dut, uint8_t a, uint8_t b, uint8_t expected) {
        test_count++;
        
        // Apply inputs
        dut->a = a;
        dut->b = b;
        dut->eval();  // Evaluate combinational logic
        
        // Check result
        if (dut->y == expected) {
            pass_count++;
            std::cout << "[PASS] Test " << test_count 
                      << ": a=" << (int)a << ", b=" << (int)b 
                      << ", result=" << (int)dut->y 
                      << ", expected=" << (int)expected << std::endl;
        } else {
            fail_count++;
            std::cerr << "[FAIL] Test " << test_count 
                      << ": a=" << (int)a << ", b=" << (int)b 
                      << ", result=" << (int)dut->y 
                      << ", expected=" << (int)expected << std::endl;
        }
    }
    
    void print_summary() {
        std::cout << "\n========================================" << std::endl;
        std::cout << "Test Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Total tests: " << test_count << std::endl;
        std::cout << "Passed:      " << pass_count << std::endl;
        std::cout << "Failed:      " << fail_count << std::endl;
        std::cout << "========================================" << std::endl;
    }
    
    int get_exit_code() {
        return (fail_count > 0) ? 1 : 0;
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Class-Based Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vand_gate* dut = new Vand_gate;
    
    // Create testbench instance
    TestBench tb;
    
    // Run exhaustive tests
    tb.run_test(dut, 0, 0, 0);
    tb.run_test(dut, 0, 1, 0);
    tb.run_test(dut, 1, 0, 0);
    tb.run_test(dut, 1, 1, 1);
    
    // Print summary
    tb.print_summary();
    
    // Cleanup
    dut->final();
    delete dut;
    
    return tb.get_exit_code();
}
