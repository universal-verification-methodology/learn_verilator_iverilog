/**
 * Randomized Testbench - C++ (Verilator Equivalent)
 * 
 * This testbench demonstrates randomization using C++ random number generators,
 * equivalent to SystemVerilog randomization for Verilator.
 * 
 * Key Concepts:
 * - C++ random number generation
 * - Random test generation
 * - Seed control
 * 
 * Usage:
 *   make randomized_test
 *   or
 *   verilator --cc --exe --build -I../../../module6/dut/multiplexers \
 *            ../../../module6/dut/multiplexers/mux_4to1.v randomized_test.cpp
 *   ./obj_dir/Vmux_4to1
 */

#include <iostream>
#include <random>
#include <cassert>
#include <verilated.h>
#include "Vmux_4to1.h"

/**
 * MUX Transaction Class (C++ equivalent)
 * 
 * Models a transaction for 4-to-1 multiplexer test.
 */
class MuxTransaction {
private:
    std::mt19937 gen;
    std::uniform_int_distribution<> sel_dis;
    std::uniform_int_distribution<> in_dis;
    
public:
    uint8_t sel;
    uint8_t in0, in1, in2, in3;
    uint8_t expected;
    
    MuxTransaction() : gen(std::random_device{}()), 
                       sel_dis(0, 3), 
                       in_dis(0, 1) {
        sel = 0;
        in0 = in1 = in2 = in3 = 0;
        expected = 0;
    }
    
    void randomize() {
        // Generate random values
        sel = sel_dis(gen);
        in0 = in_dis(gen);
        in1 = in_dis(gen);
        in2 = in_dis(gen);
        in3 = in_dis(gen);
        
        // Calculate expected output based on select signal
        switch (sel) {
            case 0: expected = in0; break;
            case 1: expected = in1; break;
            case 2: expected = in2; break;
            case 3: expected = in3; break;
            default: expected = 0; break;
        }
    }
    
    void print() {
        std::cout << "Transaction: sel=" << (int)sel 
                  << ", in0=" << (int)in0 
                  << ", in1=" << (int)in1 
                  << ", in2=" << (int)in2 
                  << ", in3=" << (int)in3 
                  << ", expected=" << (int)expected << std::endl;
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Randomized Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vmux_4to1* dut = new Vmux_4to1;
    
    // Create transaction instance
    MuxTransaction tr;
    
    // Test statistics
    int test_count = 0;
    int pass_count = 0;
    int fail_count = 0;
    
    // Generate and run random tests
    for (int i = 0; i < 10; i++) {
        // Generate random transaction
        tr.randomize();
        
        // Apply to DUT
        dut->sel = tr.sel;
        dut->in0 = tr.in0;
        dut->in1 = tr.in1;
        dut->in2 = tr.in2;
        dut->in3 = tr.in3;
        dut->eval();  // Evaluate combinational logic
        
        test_count++;
        
        // Check result
        if (dut->out == tr.expected) {
            pass_count++;
            std::cout << "[PASS] Test " << test_count 
                      << ": sel=" << (int)tr.sel 
                      << ", out=" << (int)dut->out 
                      << ", expected=" << (int)tr.expected << std::endl;
        } else {
            fail_count++;
            std::cerr << "[FAIL] Test " << test_count 
                      << ": sel=" << (int)tr.sel 
                      << ", out=" << (int)dut->out 
                      << ", expected=" << (int)tr.expected << std::endl;
        }
    }
    
    // Print summary
    std::cout << "\n========================================" << std::endl;
    std::cout << "Test Summary" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "Total tests: " << test_count << std::endl;
    std::cout << "Passed:      " << pass_count << std::endl;
    std::cout << "Failed:      " << fail_count << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return (fail_count > 0) ? 1 : 0;
}
