/**
 * File-Based Testbench - C++
 * 
 * Demonstrates:
 * - File I/O (fstream, ifstream, ofstream)
 * - Reading test vectors
 * - Writing results
 * - Test vector file formats
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/alus ../../dut/alus/simple_alu.v file_based_test_cpp.cpp
 *   ./obj_dir/Vsimple_alu
 */

#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <vector>
#include <cassert>
#include <verilated.h>
#include "Vsimple_alu.h"

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
 * - Format: "a b op" (hexadecimal values separated by spaces)
 * - Example: "10 20 0" means a=0x10, b=0x20, op=0
 * - Comments: Lines starting with '/' or '#' are ignored
 * - Empty lines are ignored
 * 
 * C++ File I/O:
 * - std::ifstream: Input file stream for reading
 * - std::getline: Read line from file
 * - std::istringstream: Parse string into values
 * - std::hex: Read values in hexadecimal format
 * 
 * Error Handling:
 * - Check if file opened successfully
 * - Return empty vector on error (caller should check)
 * - Print error message to stderr
 * 
 * @param filename Path to test vector file
 * @return Vector of TestVector structures
 * 
 * UVM Connection: File reading patterns used in UVM configuration:
 * - Reading configuration files → `uvm_config_db::get()`
 * - Parsing file formats → Configuration object creation
 * - Error handling → UVM reporting mechanism
 */
std::vector<TestVector> read_test_vectors(const std::string& filename) {
    std::vector<TestVector> vectors;
    std::ifstream file(filename);  // Open file for reading
    
    // Check if file opened successfully
    if (!file.is_open()) {
        std::cerr << "Error: Cannot open file " << filename << std::endl;
        return vectors;  // Return empty vector on error
    }
    
    // Read file line by line
    std::string line;
    while (std::getline(file, line)) {
        // Skip comments and empty lines
        // Comments start with '/' or '#'
        if (line.empty() || line[0] == '/' || line[0] == '#') {
            continue;
        }
        
        // Parse line into TestVector structure
        TestVector tv;
        std::istringstream iss(line);  // Create string stream from line
        
        // Read hex values: a, b, op
        // std::hex tells stream to interpret values as hexadecimal
        iss >> std::hex >> tv.a >> tv.b >> tv.op;
        
        // Add to vector
        vectors.push_back(tv);
    }
    
    file.close();  // Close file
    return vectors;
}

// Read expected results from file
std::vector<uint8_t> read_expected_results(const std::string& filename) {
    std::vector<uint8_t> expected;
    std::ifstream file(filename);
    
    if (!file.is_open()) {
        std::cerr << "Error: Cannot open file " << filename << std::endl;
        return expected;
    }
    
    std::string line;
    while (std::getline(file, line)) {
        if (line.empty() || line[0] == '/' || line[0] == '#') {
            continue;
        }
        
        uint8_t val;
        std::istringstream iss(line);
        iss >> std::hex >> val;
        expected.push_back(val);
    }
    
    file.close();
    return expected;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "File-Based Testbench Example" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Read test vectors and expected results
    std::vector<TestVector> test_vectors = read_test_vectors("test_vectors.hex");
    std::vector<uint8_t> expected = read_expected_results("expected_results.hex");
    
    if (test_vectors.size() != expected.size()) {
        std::cerr << "Error: Test vectors and expected results count mismatch" << std::endl;
        return 1;
    }
    
    // Add expected values to test vectors
    for (size_t i = 0; i < test_vectors.size(); i++) {
        test_vectors[i].expected = expected[i];
    }
    
    std::cout << "Read " << test_vectors.size() << " test vectors from file" << std::endl;
    
    // Create DUT instance
    Vsimple_alu* dut = new Vsimple_alu;
    
    // Open output file for results
    std::ofstream result_file("test_results.txt");
    if (!result_file.is_open()) {
        std::cerr << "Error: Cannot open output file" << std::endl;
        return 1;
    }
    
    result_file << "ALU Test Results\n";
    result_file << "================\n";
    result_file << "Test |  a  |  b  | op | result | expected | Pass/Fail\n";
    result_file << "-----|-----|-----|----|--------|----------|----------\n";
    
    int pass_count = 0;
    int fail_count = 0;
    
    // Apply test vectors
    for (size_t i = 0; i < test_vectors.size(); i++) {
        const auto& tv = test_vectors[i];
        
        dut->a = tv.a;
        dut->b = tv.b;
        dut->op = tv.op;
        dut->eval();
        
        bool passed = (dut->result == tv.expected);
        if (passed) {
            pass_count++;
        } else {
            fail_count++;
        }
        
        std::cout << "Test " << (i + 1) 
                  << ": a=0x" << std::hex << std::setfill('0') << std::setw(2) << (int)tv.a
                  << ", b=0x" << std::setw(2) << (int)tv.b
                  << ", op=" << std::dec << (int)tv.op
                  << ", result=0x" << std::hex << std::setw(2) << (int)dut->result
                  << ", expected=0x" << std::setw(2) << (int)tv.expected
                  << " " << (passed ? "[PASS]" : "[FAIL]") << std::dec << std::endl;
        
        result_file << "  " << (i + 1) << "  | 0x" << std::hex << std::setfill('0') << std::setw(2) << (int)tv.a
                    << " | 0x" << std::setw(2) << (int)tv.b
                    << " | " << std::dec << (int)tv.op
                    << "  |  0x" << std::hex << std::setw(2) << (int)dut->result
                    << "  |   0x" << std::setw(2) << (int)tv.expected
                    << "   |   " << (passed ? "PASS" : "FAIL") << "\n";
    }
    
    result_file << "\nSummary: " << pass_count << " passed, " << fail_count << " failed\n";
    result_file.close();
    
    std::cout << "\nResults written to test_results.txt" << std::endl;
    std::cout << "Summary: " << pass_count << " passed, " << fail_count << " failed" << std::endl;
    std::cout << "========================================" << std::endl;
    
    dut->final();
    delete dut;
    
    return (fail_count == 0) ? 0 : 1;
}
