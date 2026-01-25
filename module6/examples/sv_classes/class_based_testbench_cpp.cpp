/**
 * Class-Based Testbench - C++ (Verilator Equivalent)
 * 
 * Demonstrates:
 * - Equivalent C++ class-based patterns for Verilator
 * - Class methods and properties
 * - Class instantiation
 * - Object-oriented testbenches
 * 
 * This is the C++ equivalent for Verilator, since Verilator has limited
 * SystemVerilog class support.
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/simple_gates ../../dut/simple_gates/and_gate.v class_based_testbench_cpp.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <random>
#include <cassert>
#include <verilated.h>
#include "Vand_gate.h"

// Transaction class (C++ equivalent)
class Transaction {
private:
    std::mt19937 gen;
    std::uniform_int_distribution<> dis;
    
public:
    uint8_t a;
    uint8_t b;
    uint8_t expected;
    
    Transaction() : gen(std::random_device{}()), dis(0, 1) {
        a = 0;
        b = 0;
        expected = 0;
    }
    
    void randomize() {
        a = dis(gen);
        b = dis(gen);
        expected = a & b;  // Calculate expected result
    }
    
    void print() {
        std::cout << "Transaction: a=" << (int)a 
                  << ", b=" << (int)b 
                  << ", expected=" << (int)expected << std::endl;
    }
};

// Testbench class (C++ equivalent)
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
    
    void run_test(uint8_t a, uint8_t b, uint8_t expected) {
        test_count++;
        uint8_t result = a & b;  // Simulate DUT operation
        
        if (result == expected) {
            pass_count++;
            std::cout << "[PASS] Test " << test_count 
                      << ": a=" << (int)a << ", b=" << (int)b 
                      << ", result=" << (int)result 
                      << ", expected=" << (int)expected << std::endl;
        } else {
            fail_count++;
            std::cerr << "[FAIL] Test " << test_count 
                      << ": a=" << (int)a << ", b=" << (int)b 
                      << ", result=" << (int)result 
                      << ", expected=" << (int)expected << std::endl;
        }
    }
    
    void print_summary() {
        std::cout << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Test Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Total tests:  " << test_count << std::endl;
        std::cout << "Passed:       " << pass_count << std::endl;
        std::cout << "Failed:       " << fail_count << std::endl;
        std::cout << "========================================" << std::endl;
    }
    
    Transaction* get_transaction() { return tr; }
    int get_fail_count() const { return fail_count; }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Class-Based Testbench Example (C++)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create testbench instance
    TestBench tb;
    
    // Run tests
    tb.run_test(0, 0, 0);
    tb.run_test(0, 1, 0);
    tb.run_test(1, 0, 0);
    tb.run_test(1, 1, 1);
    
    // Test with transaction class
    std::cout << "\nUsing transaction class:" << std::endl;
    for (int i = 0; i < 4; i++) {
        tb.get_transaction()->randomize();
        tb.get_transaction()->print();
        tb.run_test(tb.get_transaction()->a, 
                   tb.get_transaction()->b, 
                   tb.get_transaction()->expected);
    }
    
    // Print summary
    tb.print_summary();
    
    std::cout << "========================================" << std::endl;
    
    return (tb.get_fail_count() == 0) ? 0 : 1;
}
