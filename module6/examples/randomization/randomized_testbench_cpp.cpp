/**
 * Randomized Testbench - C++ (Verilator Equivalent)
 * 
 * Demonstrates:
 * - Equivalent C++ randomization patterns for Verilator
 * - Random test generation
 * - Seed control
 * - Randomization strategies
 * 
 * This is the C++ equivalent for Verilator, using C++ random number generators.
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/multiplexers ../../dut/multiplexers/mux_4to1.v randomized_testbench_cpp.cpp
 *   ./obj_dir/Vmux_4to1
 */

#include <iostream>
#include <random>
#include <cassert>
#include <verilated.h>
#include "Vmux_4to1.h"

// Transaction class with randomization (C++ equivalent)
class MuxTransaction {
private:
    std::mt19937 gen;
    std::uniform_int_distribution<> sel_dis;
    std::uniform_int_distribution<> in_dis;
    
public:
    uint8_t sel;
    uint8_t in0, in1, in2, in3;
    uint8_t expected;
    
    MuxTransaction(unsigned int seed = std::random_device{}()) 
        : gen(seed), sel_dis(0, 3), in_dis(0, 1) {
        sel = 0;
        in0 = in1 = in2 = in3 = 0;
        expected = 0;
    }
    
    void randomize() {
        sel = sel_dis(gen);
        in0 = in_dis(gen);
        in1 = in_dis(gen);
        in2 = in_dis(gen);
        in3 = in_dis(gen);
        
        // Calculate expected
        switch (sel) {
            case 0: expected = in0; break;
            case 1: expected = in1; break;
            case 2: expected = in2; break;
            case 3: expected = in3; break;
            default: expected = 0;
        }
    }
    
    void print() {
        std::cout << "Transaction: sel=" << (int)sel 
                  << ", in0=" << (int)in0 << ", in1=" << (int)in1
                  << ", in2=" << (int)in2 << ", in3=" << (int)in3
                  << ", expected=" << (int)expected << std::endl;
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Randomized Testbench Example (C++)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vmux_4to1* dut = new Vmux_4to1;
    
    // Create transaction with seed
    unsigned int seed = std::random_device{}();
    std::cout << "Random seed: " << seed << std::endl;
    MuxTransaction tr(seed);
    
    int test_count = 0;
    int pass_count = 0;
    int fail_count = 0;
    
    // Generate random tests
    std::cout << "\nGenerating random test vectors:" << std::endl;
    for (int i = 0; i < 10; i++) {
        // Randomize transaction
        tr.randomize();
        tr.print();
        
        // Apply to DUT
        dut->sel = tr.sel;
        dut->in0 = tr.in0;
        dut->in1 = tr.in1;
        dut->in2 = tr.in2;
        dut->in3 = tr.in3;
        dut->eval();
        
        // Check result
        test_count++;
        if (dut->out == tr.expected) {
            pass_count++;
            std::cout << "  [PASS] Test " << test_count 
                      << ": out=" << (int)dut->out 
                      << ", expected=" << (int)tr.expected << std::endl;
        } else {
            fail_count++;
            std::cerr << "  [FAIL] Test " << test_count 
                      << ": out=" << (int)dut->out 
                      << ", expected=" << (int)tr.expected << std::endl;
        }
    }
    
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
    
    dut->final();
    delete dut;
    
    return (fail_count == 0) ? 0 : 1;
}
