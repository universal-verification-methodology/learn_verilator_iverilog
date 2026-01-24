/**
 * File I/O C++ Test for Verilator
 * 
 * Comprehensive testbench with:
 * - Reading test vectors from files
 * - Writing results to files
 * - Test result validation
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../module0/dut/simple_gates \
 *       ../../module0/dut/simple_gates/and_gate.v test_file_io.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <cassert>
#include <verilated.h>
#include "Vand_gate.h"

struct TestVector {
    uint8_t a;
    uint8_t b;
    uint8_t expected;
};

// Read test vectors from file
std::vector<TestVector> read_test_vectors(const std::string& filename) {
    std::vector<TestVector> vectors;
    std::ifstream file(filename);
    
    if (!file.is_open()) {
        std::cerr << "Error: Cannot open file " << filename << std::endl;
        return vectors;
    }
    
    std::string line;
    while (std::getline(file, line)) {
        // Skip comments and empty lines
        if (line.empty() || line[0] == '/' || line[0] == '#') {
            continue;
        }
        
        TestVector tv;
        std::istringstream iss(line);
        iss >> tv.a >> tv.b >> tv.expected;
        vectors.push_back(tv);
    }
    
    file.close();
    return vectors;
}

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "File I/O C++ Test" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Read test vectors
    std::vector<TestVector> test_vectors = read_test_vectors("test_vectors.txt");
    
    if (test_vectors.empty()) {
        std::cerr << "Error: No test vectors found. Creating default test vectors." << std::endl;
        // Create default test vectors
        test_vectors = {
            {0, 0, 0},
            {0, 1, 0},
            {1, 0, 0},
            {1, 1, 1}
        };
    }
    
    std::cout << "Read " << test_vectors.size() << " test vectors from file" << std::endl;
    
    // Create DUT instance
    Vand_gate* dut = new Vand_gate;
    
    // Open output file for results
    std::ofstream result_file("test_results.txt");
    if (!result_file.is_open()) {
        std::cerr << "Error: Cannot open output file" << std::endl;
        return 1;
    }
    
    result_file << "Test Results\n";
    result_file << "=============\n";
    result_file << "Test |  a  |  b  |  y  | Expected | Pass/Fail\n";
    result_file << "-----|-----|-----|-----|----------|----------\n";
    
    int pass_count = 0;
    int fail_count = 0;
    
    // Apply test vectors
    for (size_t i = 0; i < test_vectors.size(); i++) {
        const auto& tv = test_vectors[i];
        
        dut->a = tv.a;
        dut->b = tv.b;
        dut->eval();
        
        bool passed = (dut->y == tv.expected);
        if (passed) {
            pass_count++;
        } else {
            fail_count++;
        }
        
        std::cout << "Test " << (i + 1) << ": a=" << (int)tv.a << ", b=" << (int)tv.b 
                  << ", y=" << (int)dut->y << ", expected=" << (int)tv.expected 
                  << " [" << (passed ? "PASS" : "FAIL") << "]" << std::endl;
        
        result_file << "  " << (i + 1) << "  |  " << (int)tv.a << "  |  " << (int)tv.b 
                    << "  |  " << (int)dut->y << "  |    " << (int)tv.expected 
                    << "     |   " << (passed ? "PASS" : "FAIL") << "\n";
        
        // Assert for test framework
        assert(passed && "Test vector failed");
    }
    
    result_file << "\nSummary: " << pass_count << " passed, " << fail_count << " failed\n";
    result_file.close();
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "Test Summary: " << pass_count << " passed, " << fail_count << " failed" << std::endl;
    std::cout << "Results written to test_results.txt" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return (fail_count == 0) ? 0 : 1;
}
