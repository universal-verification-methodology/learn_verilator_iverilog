/**
 * ALU Self-Checking C++ Testbench (Verilator)
 * 
 * This testbench demonstrates self-checking verification with automatic
 * expected value calculation using a reference model.
 * 
 * Key Concepts:
 * - Self-checking testbench architecture
 * - Reference model for expected value calculation
 * - Automatic result comparison
 * - Test result aggregation
 * 
 * Usage:
 *   make alu_test
 *   or
 *   verilator --cc --exe --build -I../../../module4/dut/alus \
 *            ../../../module4/dut/alus/simple_alu.v alu_test.cpp
 *   ./obj_dir/Vsimple_alu
 */

#include <iostream>
#include <iomanip>
#include <cassert>
#include <verilated.h>
#include "Vsimple_alu.h"

// Reference model: Calculate expected result
uint8_t calculate_expected(uint8_t a, uint8_t b, uint8_t op) {
    switch (op) {
        case 0: return a + b;  // ADD
        case 1: return a - b;  // SUB
        case 2: return a & b;  // AND
        case 3: return a | b;  // OR
        default: return 0;
    }
}

// Test statistics
int test_count = 0;
int pass_count = 0;
int fail_count = 0;

// Test function
void test_alu(Vsimple_alu* dut, uint8_t a, uint8_t b, uint8_t op) {
    // Apply inputs
    dut->a = a;
    dut->b = b;
    dut->op = op;
    dut->eval();  // Evaluate combinational logic
    
    // Get operation name
    const char* op_name;
    switch (op) {
        case 0: op_name = "ADD"; break;
        case 1: op_name = "SUB"; break;
        case 2: op_name = "AND"; break;
        case 3: op_name = "OR "; break;
        default: op_name = "???"; break;
    }
    
    // Calculate expected values
    uint8_t expected_result = calculate_expected(a, b, op);
    bool expected_zero = (expected_result == 0);
    
    // Increment test counter
    test_count++;
    
    // Compare actual vs expected
    if ((dut->result == expected_result) && (dut->zero == expected_zero)) {
        pass_count++;
        std::cout << "Test " << test_count << " [PASS]: " << op_name 
                  << " a=0x" << std::hex << std::setw(2) << std::setfill('0') << (int)a
                  << ", b=0x" << std::setw(2) << (int)b
                  << " -> result=0x" << std::setw(2) << (int)dut->result
                  << ", zero=" << (int)dut->zero << std::dec << std::endl;
    } else {
        fail_count++;
        std::cerr << "Test " << test_count << " [FAIL]: " << op_name 
                  << " a=0x" << std::hex << std::setw(2) << std::setfill('0') << (int)a
                  << ", b=0x" << std::setw(2) << (int)b << std::dec << std::endl;
        std::cerr << "  Expected: result=0x" << std::hex << std::setw(2) << std::setfill('0') 
                  << (int)expected_result << ", zero=" << expected_zero << std::dec << std::endl;
        std::cerr << "  Actual:   result=0x" << std::hex << std::setw(2) << std::setfill('0') 
                  << (int)dut->result << ", zero=" << (int)dut->zero << std::dec << std::endl;
    }
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "ALU Self-Checking C++ Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vsimple_alu* dut = new Vsimple_alu;
    
    // Test ADD operation
    test_alu(dut, 0x10, 0x20, 0);  // 0x10 + 0x20 = 0x30
    test_alu(dut, 0xFF, 0x01, 0);  // 0xFF + 0x01 = 0x00 (overflow)
    
    // Test SUB operation
    test_alu(dut, 0x30, 0x10, 1);  // 0x30 - 0x10 = 0x20
    test_alu(dut, 0x10, 0x20, 1);  // 0x10 - 0x20 = 0xF0 (underflow)
    
    // Test AND operation
    test_alu(dut, 0xAA, 0x55, 2);  // 0xAA & 0x55 = 0x00
    test_alu(dut, 0xFF, 0xAA, 2);  // 0xFF & 0xAA = 0xAA
    
    // Test OR operation
    test_alu(dut, 0xAA, 0x55, 3);  // 0xAA | 0x55 = 0xFF
    test_alu(dut, 0x00, 0x00, 3);  // 0x00 | 0x00 = 0x00
    
    // Test summary
    std::cout << "\n========================================" << std::endl;
    std::cout << "Test Summary" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "Total tests: " << test_count << std::endl;
    std::cout << "Passed:      " << pass_count << std::endl;
    std::cout << "Failed:      " << fail_count << std::endl;
    std::cout << "========================================" << std::endl;
    
    if (fail_count > 0) {
        std::cerr << "Some tests failed!" << std::endl;
    } else {
        std::cout << "All tests passed!" << std::endl;
    }
    
    // Cleanup
    dut->final();
    delete dut;
    
    return (fail_count > 0) ? 1 : 0;
}
