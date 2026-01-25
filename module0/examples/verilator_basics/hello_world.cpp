/**
 * Hello World Example for Verilator
 * 
 * This is the simplest possible C++ testbench to verify Verilator installation.
 * It demonstrates basic compilation and simulation with Verilator.
 * 
 * Learning Objectives:
 * - Understand Verilator compilation process
 * - Learn basic C++ testbench structure
 * - Understand Verilator API (Verilated, DUT class)
 * - Learn how to instantiate and evaluate DUT
 * 
 * Verilator Workflow:
 *   1. Verilator reads Verilog files and generates C++ classes
 *   2. Your C++ testbench includes the generated header
 *   3. Compile C++ testbench with generated files
 *   4. Run executable to simulate
 * 
 * Compilation and Execution:
 *   1. Compile: verilator --cc --exe --build hello_world.v hello_world.cpp
 *      - --cc: Generate C++ code
 *      - --exe: Create executable (combines compilation and linking)
 *      - --build: Automatically build (no need to run make separately)
 *      - Output: ./obj_dir/Vhello_world executable
 *   2. Run: ./obj_dir/Vhello_world
 * 
 * Key Concepts:
 * - Verilator generates a C++ class for each Verilog module
 * - Class name: V<module_name> (e.g., Vhello_world)
 * - DUT instance: Create object of generated class
 * - Evaluation: Call eval() to simulate one time step
 * - Cleanup: Call final() before deleting DUT
 * 
 * Usage:
 *   verilator --cc --exe --build hello_world.v hello_world.cpp
 *   ./obj_dir/Vhello_world
 */

#include <iostream>        // Standard I/O (cout, endl)
#include <verilated.h>     // Verilator base library (Verilated namespace)
#include "Vhello_world.h"  // Generated DUT class header

/**
 * Main function - Entry point for Verilator testbench
 * 
 * @param argc Argument count (from command line)
 * @param argv Argument vector (command line arguments)
 * @return Exit code (0 = success)
 */
int main(int argc, char** argv) {
    /**
     * Initialize Verilator
     * 
     * Verilated::commandArgs() processes command-line arguments.
     * Verilator supports various command-line options that can be
     * passed to the simulation (e.g., --trace, --coverage).
     * 
     * This should be called before creating any DUT instances.
     */
    Verilated::commandArgs(argc, argv);
    
    // Print test header
    std::cout << "========================================" << std::endl;
    std::cout << "Hello World from Verilator!" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "If you see this message, Verilator is working correctly." << std::endl;
    
    /**
     * Create DUT (Design Under Test) Instance
     * 
     * Verilator generates a C++ class for each Verilog module.
     * Class naming convention: V<module_name>
     * 
     * For module "hello_world", Verilator generates class "Vhello_world".
     * 
     * The DUT object represents the entire Verilog module:
     * - Member variables: module ports (inputs, outputs, inouts)
     * - Methods: eval() (evaluate), final() (cleanup), etc.
     */
    Vhello_world* dut = new Vhello_world;
    
    /**
     * Evaluate DUT
     * 
     * dut->eval() simulates one evaluation cycle:
     * - Updates combinational logic
     * - Processes clock edges (if any)
     * - Updates all signals based on current inputs
     * 
     * For combinational logic: one eval() is usually enough
     * For sequential logic: need multiple eval() calls with clock toggling
     * 
     * In this simple example, the module has no logic, so eval() does nothing,
     * but it's good practice to call it.
     */
    dut->eval();
    
    std::cout << "DUT instantiated and evaluated successfully." << std::endl;
    std::cout << "========================================" << std::endl;
    
    /**
     * Cleanup
     * 
     * Before deleting the DUT, call final():
     * - Performs final simulation cleanup
     * - Closes any open files (traces, coverage, etc.)
     * - Finalizes statistics
     * 
     * Then delete the DUT object to free memory.
     */
    dut->final();  // Cleanup before deletion
    delete dut;     // Free memory
    
    return 0;  // Exit successfully
}
