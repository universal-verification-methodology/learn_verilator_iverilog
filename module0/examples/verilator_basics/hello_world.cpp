/**
 * Hello World Example for Verilator
 * 
 * This is the simplest possible C++ testbench to verify Verilator installation.
 * It demonstrates basic compilation and simulation with Verilator.
 * 
 * Usage:
 *   verilator --cc --exe --build hello_world.v hello_world.cpp
 *   ./obj_dir/Vhello_world
 */

#include <iostream>
#include <verilated.h>
#include "Vhello_world.h"

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Hello World from Verilator!" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "If you see this message, Verilator is working correctly." << std::endl;
    
    // Create and use a simple DUT instance
    Vhello_world* dut = new Vhello_world;
    dut->eval();
    
    std::cout << "DUT instantiated and evaluated successfully." << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
