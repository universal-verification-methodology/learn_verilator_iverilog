/**
 * Basic iverilog Compilation Example
 * 
 * This example demonstrates basic iverilog compilation commands and options.
 * 
 * Topics covered:
 * - Basic compilation: iverilog -o output input.v
 * - Include paths: -I<directory>
 * - Define macros: -D<macro>=<value>
 * - Timescale handling
 * 
 * Usage examples:
 *   # Basic compilation
 *   iverilog -o basic_compilation basic_compilation.v
 *   
 *   # With include path
 *   iverilog -I../../dut -o basic_compilation basic_compilation.v
 *   
 *   # With macro definition
 *   iverilog -DDEBUG -o basic_compilation basic_compilation.v
 *   
 *   # Multiple files
 *   iverilog -o basic_compilation basic_compilation.v ../../dut/simple_gates/and_gate.v
 */

`timescale 1ns/1ps

// Conditional compilation based on macro
`ifdef DEBUG
    `define DEBUG_MSG(msg) $display("[DEBUG] %s", msg)
`else
    `define DEBUG_MSG(msg)
`endif

module basic_compilation;

    initial begin
        $display("========================================");
        $display("Basic Compilation Example");
        $display("========================================");
        $display("Timescale: %s", `__FILE__);
        
        `DEBUG_MSG("Debug mode enabled");
        
        $display("Compilation successful!");
        $display("========================================");
        #10;
        $finish;
    end

endmodule
