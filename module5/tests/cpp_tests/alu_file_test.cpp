/**
 * ALU File-Based C++ Testbench (Verilator)
 * 
 * This testbench demonstrates file I/O for reading test vectors and writing results.
 * 
 * Key Concepts:
 * - File I/O (fstream, ifstream, ofstream)
 * - Reading test vectors
 * - Writing results
 * - Test vector file formats
 * 
 * Usage:
 *   make alu_file_test
 *   or
 *   verilator --cc --exe --build -I../../../module4/dut/alus \
 *            ../../../module4/dut/alus/simple_alu.v alu_file_test.cpp
 *   ./obj_dir/Vsimple_alu
 * 
 * Note: This testbench expects test_vectors.txt file in the same directory.
 */

#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <vector>
#include <cassert>
#include <verilated.h>
#include "Vsimple_alu.h"

/**
 * Test Vector Structure
 * 
 * Represents a single test vector with inputs and expected output.
 */
struct TestVector {
    uint8_t a;
    uint8_t b;
    uint8_t op;
    uint8_t expected;
};

/**
 * Read Test Vectors from File
 * 
 * This function reads test vectors from a text file and parses them
 * into a vector of TestVector structures.
 * 
 * File Format:
 * - One test vector per line
 * - Format: "a b op expected" (hexadecimal values separated by spaces)
 * - Example: "10 20 0 30" means a=0x10, b=0x20, op=0, expected=0x30
 * - Comments: Lines starting with '#' are ignored
 * - Empty lines are ignored
 * 
 * @param filename Path to test vector file
 * @return Vector of TestVector structures
 */
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
        if (line.empty() || line[0] == '#') {
            continue;
        }
        
        // Parse line into TestVector structure
        TestVector tv;
        std::istringstream iss(line);
        
        // Read hex values: a, b, op, expected
        // Note: Must read into unsigned int first, then cast to uint8_t
        // because uint8_t is typically unsigned char, and operator>> on char
        // reads a single character instead of parsing a number
        unsigned int a_val, b_val, op_val, expected_val;
        iss >> std::hex >> a_val >> b_val >> op_val >> expected_val;
        
        // Check if parsing was successful
        if (iss.fail()) {
            std::cerr << "Warning: Failed to parse line: " << line << std::endl;
            continue;
        }
        
        // Cast to uint8_t
        tv.a = static_cast<uint8_t>(a_val);
        tv.b = static_cast<uint8_t>(b_val);
        tv.op = static_cast<uint8_t>(op_val);
        tv.expected = static_cast<uint8_t>(expected_val);
        
        // Add to vector
        vectors.push_back(tv);
    }
    
    file.close();
    return vectors;
}

/**
 * Write Results to File
 * 
 * Writes test results to an output file.
 * 
 * @param filename Path to output file
 * @param vectors Test vectors that were executed
 * @param results Actual results from DUT
 * @param test_count Total number of tests
 * @param pass_count Number of passed tests
 * @param fail_count Number of failed tests
 */
void write_results(const std::string& filename,
                   const std::vector<TestVector>& vectors,
                   const std::vector<uint8_t>& results,
                   int test_count, int pass_count, int fail_count) {
    std::ofstream file(filename);
    
    if (!file.is_open()) {
        std::cerr << "Error: Cannot open output file " << filename << std::endl;
        return;
    }
    
    file << "ALU Test Results\n";
    file << "================\n\n";
    
    for (size_t i = 0; i < vectors.size(); i++) {
        file << "Test " << (i + 1) << ": ";
        if (results[i] == vectors[i].expected) {
            file << "PASS";
        } else {
            file << "FAIL";
        }
        file << " - result=0x" << std::hex << std::setw(2) << std::setfill('0') 
             << (int)results[i] << " (expected 0x" << std::setw(2) 
             << (int)vectors[i].expected << ")\n" << std::dec;
    }
    
    file << "\nSummary: Total=" << test_count 
         << ", Passed=" << pass_count 
         << ", Failed=" << fail_count << "\n";
    
    file.close();
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "ALU File-Based C++ Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Read test vectors from file
    std::vector<TestVector> vectors = read_test_vectors("test_vectors.txt");
    
    if (vectors.empty()) {
        std::cerr << "Error: No test vectors loaded" << std::endl;
        return 1;
    }
    
    std::cout << "Read " << vectors.size() << " test vectors from file" << std::endl;
    
    // Create DUT instance
    Vsimple_alu* dut = new Vsimple_alu;
    
    // Test statistics
    int test_count = 0;
    int pass_count = 0;
    int fail_count = 0;
    std::vector<uint8_t> results;
    
    // Apply test vectors and check results
    for (const auto& tv : vectors) {
        // Apply inputs
        dut->a = tv.a;
        dut->b = tv.b;
        dut->op = tv.op;
        dut->eval();  // Evaluate combinational logic
        
        test_count++;
        results.push_back(dut->result);
        
        // Compare actual vs expected
        if (dut->result == tv.expected) {
            pass_count++;
            std::cout << "Test " << test_count << " [PASS]: a=0x" 
                      << std::hex << std::setw(2) << std::setfill('0') << (int)tv.a
                      << ", b=0x" << std::setw(2) << (int)tv.b
                      << ", op=" << std::dec << (int)tv.op
                      << " -> result=0x" << std::hex << std::setw(2) << std::setfill('0') 
                      << (int)dut->result << " (expected 0x" << std::setw(2) 
                      << (int)tv.expected << ")" << std::dec << std::endl;
        } else {
            fail_count++;
            std::cerr << "Test " << test_count << " [FAIL]: a=0x" 
                      << std::hex << std::setw(2) << std::setfill('0') << (int)tv.a
                      << ", b=0x" << std::setw(2) << (int)tv.b
                      << ", op=" << std::dec << (int)tv.op << std::endl;
            std::cerr << "  Expected: result=0x" << std::hex << std::setw(2) 
                      << std::setfill('0') << (int)tv.expected << std::dec << std::endl;
            std::cerr << "  Actual:   result=0x" << std::hex << std::setw(2) 
                      << std::setfill('0') << (int)dut->result << std::dec << std::endl;
        }
    }
    
    // Write results to file
    write_results("test_results.txt", vectors, results, test_count, pass_count, fail_count);
    
    // Print summary
    std::cout << "\n========================================" << std::endl;
    std::cout << "Test Summary" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "Total tests: " << test_count << std::endl;
    std::cout << "Passed:      " << pass_count << std::endl;
    std::cout << "Failed:      " << fail_count << std::endl;
    std::cout << "Results written to test_results.txt" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return (fail_count > 0) ? 1 : 0;
}
