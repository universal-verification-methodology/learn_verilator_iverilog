/**
 * Functional Coverage Testbench - C++ (Verilator)
 * 
 * This testbench demonstrates manual functional coverage using C++ data structures.
 * 
 * Key Concepts:
 * - Manual functional coverage using data structures
 * - Coverage bins implementation
 * - Coverage collection and analysis
 * 
 * Usage:
 *   make coverage_test
 *   or
 *   verilator --cc --exe --build -I../../../module7/dut/multiplexers \
 *            ../../../module7/dut/multiplexers/mux_4to1.v coverage_test.cpp
 *   ./obj_dir/Vmux_4to1
 */

#include <iostream>
#include <iomanip>
#include <vector>
#include <bitset>
#include <cassert>
#include <verilated.h>
#include "Vmux_4to1.h"

// Coverage tracking structures
std::bitset<4> sel_coverage;      // Coverage for 4 select values
std::bitset<16> input_coverage;   // Coverage for 16 input combinations

// Test statistics
int test_count = 0;
int pass_count = 0;
int fail_count = 0;

// Function to update coverage
void update_coverage(uint8_t sel_val, uint8_t input_val) {
    // Track select coverage
    if (sel_val < 4) {
        sel_coverage[sel_val] = true;
    }
    
    // Track input combination coverage
    if (input_val < 16) {
        input_coverage[input_val] = true;
    }
}

// Function to calculate coverage percentage
double calculate_sel_coverage() {
    return (sel_coverage.count() * 100.0) / 4.0;
}

double calculate_input_coverage() {
    return (input_coverage.count() * 100.0) / 16.0;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Functional Coverage Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vmux_4to1* dut = new Vmux_4to1;
    
    // Test all select values
    for (int sel = 0; sel < 4; sel++) {
        dut->sel = sel;
        dut->in0 = 1; dut->in1 = 0; dut->in2 = 0; dut->in3 = 0;
        dut->eval();
        
        test_count++;
        uint8_t input_val = (dut->in0 << 3) | (dut->in1 << 2) | (dut->in2 << 1) | dut->in3;
        update_coverage(sel, input_val);
        
        // Check result
        bool pass = false;
        switch (sel) {
            case 0: pass = (dut->out == dut->in0); break;
            case 1: pass = (dut->out == dut->in1); break;
            case 2: pass = (dut->out == dut->in2); break;
            case 3: pass = (dut->out == dut->in3); break;
        }
        
        if (pass) {
            pass_count++;
        } else {
            fail_count++;
            std::cerr << "Test failed: sel=" << sel << std::endl;
        }
    }
    
    // Print coverage report
    std::cout << "\n========================================" << std::endl;
    std::cout << "Coverage Report" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << std::fixed << std::setprecision(1);
    std::cout << "Select coverage: " << calculate_sel_coverage() << "%" << std::endl;
    std::cout << "Input coverage:  " << calculate_input_coverage() << "%" << std::endl;
    std::cout << "Coverage bins:" << std::endl;
    for (int i = 0; i < 4; i++) {
        std::cout << "  sel[" << i << "]: " << (sel_coverage[i] ? "COVERED" : "NOT COVERED") << std::endl;
    }
    std::cout << "========================================" << std::endl;
    std::cout << "Test Summary: Total=" << test_count 
              << ", Passed=" << pass_count 
              << ", Failed=" << fail_count << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return (fail_count > 0) ? 1 : 0;
}
