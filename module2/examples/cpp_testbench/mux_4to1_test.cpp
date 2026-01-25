/**
 * 4-to-1 Multiplexer C++ Testbench for Verilator
 * 
 * This testbench demonstrates fundamental Verilator C++ testbench concepts:
 * - C++ main function structure and entry point
 * - Verilator-generated class usage (V<module_name> pattern)
 * - DUT (Design Under Test) instantiation in C++
 * - Signal access: reading and writing to Verilog signals from C++
 * - Combinational logic testing (no clock required)
 * - Test pattern generation and verification
 * - Assertion-based error checking
 * 
 * Verilator Compilation Process:
 *   1. Verilator reads Verilog source (mux_4to1.v)
 *   2. Generates C++ wrapper class (Vmux_4to1) in obj_dir/
 *   3. Compiles C++ testbench with generated wrapper
 *   4. Links into executable simulation
 * 
 * Key Verilator Concepts:
 *   - Verilated::commandArgs(): Pass command-line arguments to Verilator
 *   - V<module_name>*: Pointer to generated wrapper class
 *   - dut->signal_name: Access Verilog signals as C++ member variables
 *   - dut->eval(): Evaluate combinational logic and update outputs
 *   - dut->final(): Cleanup before simulation ends
 * 
 * Usage:
 *   # Compile and build
 *   verilator --cc --exe --build -I../../dut/multiplexers mux_4to1.v mux_4to1_test.cpp
 *   
 *   # Run simulation
 *   ./obj_dir/Vmux_4to1
 * 
 * Expected Output:
 *   - Test results for all 4 select combinations
 *   - Verification that output matches selected input
 *   - "All tests passed!" message on success
 */

#include <iostream>      // For std::cout, std::endl (console I/O)
#include <cassert>        // For assert() macro (runtime assertions)
#include <verilated.h>    // Verilator core library (required for all testbenches)
#include "Vmux_4to1.h"    // Generated wrapper class (created by Verilator)

int main(int argc, char** argv) {
    // ========================================================================
    // STEP 1: Initialize Verilator
    // ========================================================================
    // Verilated::commandArgs() processes command-line arguments that Verilator
    // understands (e.g., --trace, --coverage). This must be called before
    // creating any Verilator objects. It's safe to pass argc/argv even if
    // you don't use Verilator-specific arguments.
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "4-to-1 Multiplexer C++ Testbench" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================================================
    // STEP 2: Create DUT (Design Under Test) Instance
    // ========================================================================
    // Verilator generates a C++ class named V<module_name> for each top-level
    // Verilog module. For module "mux_4to1", the class is "Vmux_4to1".
    // 
    // The generated class contains:
    //   - Public member variables for each Verilog port (sel, in0, in1, in2, in3, out)
    //   - Methods: eval(), final(), trace(), etc.
    // 
    // We use 'new' to allocate on heap. Remember to 'delete' in cleanup!
    Vmux_4to1* dut = new Vmux_4to1;
    
    // ========================================================================
    // STEP 3: Test Sequence - Combinational Logic Testing
    // ========================================================================
    // For combinational logic (like a multiplexer), we don't need clocks.
    // The test pattern is:
    //   1. Set input signals (sel, in0-in3)
    //   2. Call eval() to propagate signals through combinational logic
    //   3. Read output signal (out)
    //   4. Verify output matches expected value
    //
    // Note: For sequential logic (flip-flops, counters), we need clock cycles.
    // See counter_test.cpp for sequential logic examples.
    
    std::cout << "\nTesting all select combinations:" << std::endl;
    std::cout << "sel | in0 | in1 | in2 | in3 | out | Expected" << std::endl;
    std::cout << "----|-----|-----|-----|-----|-----|----------" << std::endl;
    
    // ========================================================================
    // TEST CASE 1: sel=00 (binary), select in0
    // ========================================================================
    // Strategy: Set only in0=1, others=0. If mux works, out should equal in0.
    dut->sel = 0;  // 2-bit select: 00 selects in0
    dut->in0 = 1; dut->in1 = 0; dut->in2 = 0; dut->in3 = 0;
    
    // eval() evaluates all combinational logic in the design. For a mux,
    // this propagates the selected input to the output. Must call eval()
    // after changing inputs and before reading outputs!
    dut->eval();
    
    std::cout << " " << (int)dut->sel << "  |  " << (int)dut->in0 
              << "  |  " << (int)dut->in1 << "  |  " << (int)dut->in2 
              << "  |  " << (int)dut->in3 << "  |  " << (int)dut->out 
              << "  |   in0" << std::endl;
    
    // Assertion: If condition is false, program aborts with error message.
    // This is a simple but effective way to catch bugs early.
    // In production testbenches, you might want more sophisticated checking.
    assert(dut->out == dut->in0 && "Test failed: sel=00 should select in0");
    
    // ========================================================================
    // TEST CASE 2: sel=01 (binary), select in1
    // ========================================================================
    dut->sel = 1;  // 2-bit select: 01 selects in1
    dut->in0 = 0; dut->in1 = 1; dut->in2 = 0; dut->in3 = 0;
    dut->eval();  // Evaluate combinational logic
    std::cout << " " << (int)dut->sel << "  |  " << (int)dut->in0 
              << "  |  " << (int)dut->in1 << "  |  " << (int)dut->in2 
              << "  |  " << (int)dut->in3 << "  |  " << (int)dut->out 
              << "  |   in1" << std::endl;
    assert(dut->out == dut->in1 && "Test failed: sel=01 should select in1");
    
    // ========================================================================
    // TEST CASE 3: sel=10 (binary), select in2
    // ========================================================================
    dut->sel = 2;  // 2-bit select: 10 selects in2
    dut->in0 = 0; dut->in1 = 0; dut->in2 = 1; dut->in3 = 0;
    dut->eval();
    std::cout << " " << (int)dut->sel << "  |  " << (int)dut->in0 
              << "  |  " << (int)dut->in1 << "  |  " << (int)dut->in2 
              << "  |  " << (int)dut->in3 << "  |  " << (int)dut->out 
              << "  |   in2" << std::endl;
    assert(dut->out == dut->in2 && "Test failed: sel=10 should select in2");
    
    // ========================================================================
    // TEST CASE 4: sel=11 (binary), select in3
    // ========================================================================
    dut->sel = 3;  // 2-bit select: 11 selects in3
    dut->in0 = 0; dut->in1 = 0; dut->in2 = 0; dut->in3 = 1;
    dut->eval();
    std::cout << " " << (int)dut->sel << "  |  " << (int)dut->in0 
              << "  |  " << (int)dut->in1 << "  |  " << (int)dut->in2 
              << "  |  " << (int)dut->in3 << "  |  " << (int)dut->out 
              << "  |   in3" << std::endl;
    assert(dut->out == dut->in3 && "Test failed: sel=11 should select in3");
    
    // ========================================================================
    // STEP 4: Test Summary and Cleanup
    // ========================================================================
    std::cout << "\n========================================" << std::endl;
    std::cout << "All tests passed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================================================
    // STEP 5: Cleanup and Resource Management
    // ========================================================================
    // dut->final() performs final cleanup operations in Verilator. This is
    // important for:
    //   - Closing trace files (if using --trace)
    //   - Finalizing coverage data (if using --coverage)
    //   - Properly shutting down Verilator internals
    // Always call final() before deleting the DUT object.
    dut->final();
    
    // Delete the DUT object to free memory. In C++, every 'new' should
    // have a corresponding 'delete'. Modern C++ would use smart pointers
    // (std::unique_ptr), but raw pointers are shown here for clarity.
    delete dut;
    
    // Return 0 on success. Non-zero exit codes indicate test failure.
    // This is important for automated test scripts that check exit codes.
    return 0;
}
