/**
 * Hello World Example for iverilog
 * 
 * This is the simplest possible testbench to verify iverilog installation.
 * It demonstrates basic compilation and simulation with iverilog.
 * 
 * Learning Objectives:
 * - Understand basic Verilog testbench structure
 * - Learn how to compile Verilog with iverilog
 * - Learn how to run simulations with vvp (Icarus Verilog runtime)
 * - Understand $display system task for output
 * - Understand $finish system task to end simulation
 * 
 * Compilation and Execution:
 *   1. Compile: iverilog -o hello_world hello_world.v
 *      - This creates an executable file 'hello_world'
 *   2. Run: vvp hello_world
 *      - This executes the compiled simulation
 * 
 * Key Concepts:
 * - A testbench is a Verilog module with no ports (top-level)
 * - 'initial' blocks execute once at simulation start
 * - System tasks like $display() print to console
 * - #delay introduces time delays in simulation
 * - $finish terminates the simulation
 * 
 * Usage:
 *   iverilog -o hello_world hello_world.v
 *   vvp hello_world
 */

module hello_world;

    /**
     * Initial block - executes once at simulation time 0
     * 
     * The 'initial' keyword creates a procedural block that runs once
     * at the beginning of simulation. This is different from 'always' blocks
     * which run continuously or on events.
     * 
     * In a testbench, initial blocks are typically used for:
     * - Test stimulus generation
     * - Monitoring and checking
     * - Simulation control ($finish, $stop)
     */
    initial begin
        // $display is a system task that prints formatted text to stdout
        // Similar to printf() in C or print() in Python
        $display("========================================");
        $display("Hello World from Icarus Verilog!");
        $display("========================================");
        $display("If you see this message, iverilog is working correctly.");
        
        // $time is a system function that returns current simulation time
        // %0t formats it as a decimal number (no leading zeros)
        $display("Time: %0t", $time);
        $display("========================================");
        
        // #10 introduces a delay of 10 time units
        // Default time unit is typically 1ns (can be set with `timescale)
        // This delay allows any concurrent processes to complete
        #10;  // Wait 10 time units
        
        // $finish terminates the simulation
        // Without this, simulation would run indefinitely (or until timeout)
        $finish;
    end

endmodule
