/**
 * Debugging with Verilator Example
 * 
 * This example demonstrates debugging techniques for Verilator testbenches:
 * - Conditional debug logging with levels
 * - Signal inspection and monitoring
 * - Error detection and reporting
 * - GDB debugging setup
 * - Best practices for debugging C++ testbenches
 * 
 * Debugging Strategies:
 *   1. Add debug prints at key points in simulation
 *   2. Use debug levels to control verbosity
 *   3. Inspect signal values before and after eval()
 *   4. Use GDB for runtime debugging
 *   5. Generate waveforms (VCD) for visual debugging
 *   6. Add assertions to catch errors early
 * 
 * Debug Levels:
 *   - Level 0: Critical errors only (minimal output)
 *   - Level 1: Normal operation (default, moderate output)
 *   - Level 2: Verbose (detailed signal values, all operations)
 * 
 * GDB Debugging:
 *   # Compile with debug symbols (add -g to CXXFLAGS in Makefile)
 *   # Run with GDB:
 *   gdb ./obj_dir/Vand_gate
 *   
 *   # Common GDB commands:
 *   (gdb) break main          # Set breakpoint at main()
 *   (gdb) run                 # Start execution
 *   (gdb) print dut->a       # Print signal value
 *   (gdb) step                # Step one line
 *   (gdb) continue            # Continue execution
 *   (gdb) backtrace           # Show call stack
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/simple_gates and_gate.v debug_example.cpp
 *   ./obj_dir/Vand_gate
 *   
 *   # Try different debug levels by modifying debug_level variable
 */

#include <iostream>      // Console I/O
#include <cassert>        // Assertions
#include <string>         // std::string for debug messages
#include <verilated.h>    // Verilator core
#include "Vand_gate.h"    // Generated wrapper

// ========================================================================
// Debug Level Configuration
// ========================================================================
// Debug level: 0=minimal, 1=normal, 2=verbose
// Change this value to control output verbosity.
// In production, you might set this via command-line argument or environment variable.
int debug_level = 1;

/**
 * Debug Print Function
 * 
 * Prints debug messages only if the message level is >= current debug_level.
 * This allows controlling verbosity without removing debug code.
 * 
 * @param level Message importance level (0=critical, 1=normal, 2=verbose)
 * @param message Debug message to print
 */
void debug_print(int level, const std::string& message) {
    if (debug_level >= level) {
        std::cout << "[DEBUG L" << level << "] " << message << std::endl;
    }
}

int main(int argc, char** argv) {
    // ========================================================================
    // STEP 1: Initialize Verilator
    // ========================================================================
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Debugging Example (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Debug message at level 0 (always shown)
    debug_print(0, "Starting test sequence");
    
    // ========================================================================
    // STEP 2: Create DUT Instance
    // ========================================================================
    Vand_gate* dut = new Vand_gate;
    
    // ========================================================================
    // TEST CASE 1: AND(0, 0) = 0
    // ========================================================================
    debug_print(1, "Test case 1: a=0, b=0");
    
    // Set inputs
    dut->a = 0;
    dut->b = 0;
    
    // Evaluate combinational logic
    dut->eval();
    
    // Debug print at level 2 (only shown if debug_level >= 2)
    // This shows detailed signal values for debugging
    debug_print(2, "Signal values: a=" + std::to_string(dut->a) + 
                   ", b=" + std::to_string(dut->b) + 
                   ", y=" + std::to_string(dut->y));
    
    // Check result and report error if wrong
    // In a real testbench, you might use assertions or a test framework.
    if (dut->y != 0) {
        std::cerr << "ERROR: Test failed: Expected y=0, got y=" << (int)dut->y << std::endl;
        std::cerr << "       Inputs: a=" << (int)dut->a << ", b=" << (int)dut->b << std::endl;
        return 1;  // Exit with error code
    }
    
    // ========================================================================
    // TEST CASE 2: AND(1, 1) = 1
    // ========================================================================
    debug_print(1, "Test case 2: a=1, b=1");
    
    dut->a = 1;
    dut->b = 1;
    dut->eval();
    
    // Verbose debug output (level 2)
    debug_print(2, "Signal values: a=" + std::to_string(dut->a) + 
                   ", b=" + std::to_string(dut->b) + 
                   ", y=" + std::to_string(dut->y));
    
    if (dut->y != 1) {
        std::cerr << "ERROR: Test failed: Expected y=1, got y=" << (int)dut->y << std::endl;
        std::cerr << "       Inputs: a=" << (int)dut->a << ", b=" << (int)dut->b << std::endl;
        return 1;
    }
    
    // ========================================================================
    // STEP 3: Summary and Cleanup
    // ========================================================================
    debug_print(0, "Test sequence completed successfully");
    
    std::cout << "========================================" << std::endl;
    std::cout << "Debugging demonstration complete" << std::endl;
    std::cout << "Try changing debug_level (0, 1, or 2) to see different verbosity" << std::endl;
    std::cout << "For GDB debugging, compile with -g flag and run: gdb ./obj_dir/Vand_gate" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
