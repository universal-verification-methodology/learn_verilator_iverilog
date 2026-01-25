/**
 * Debugging with iverilog Example
 * 
 * This example demonstrates:
 * - Compilation error debugging
 * - Runtime error debugging
 * - Signal tracing techniques
 * - Logging strategies
 * - Common pitfalls and solutions
 * 
 * Usage:
 *   iverilog -o debug_example debug_example.v ../../dut/simple_gates/and_gate.v
 *   vvp debug_example
 */

`timescale 1ns/1ps

module debug_example;

    reg  a, b;
    wire y;
    integer debug_level = 1;  // 0=minimal, 1=normal, 2=verbose
    reg [8*80-1:0] debug_msg;  // Buffer for formatted debug messages

    // Instantiate DUT
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    // Debug task with different verbosity levels
    // Note: iverilog doesn't support 'string' type in task ports
    // Using integer array to represent string (workaround)
    task debug_print;
        input integer level;
        input [8*80-1:0] message;  // 80 characters max
        if (debug_level >= level) begin
            $display("[DEBUG L%0d] %s", level, message);
        end
    endtask

    // Test sequence with debugging
    initial begin
        $display("========================================");
        $display("Debugging Example");
        $display("========================================");
        
        debug_print(0, "Starting test sequence");
        
        // Test case 1
        debug_print(1, "Test case 1: a=0, b=0");
        a = 0; b = 0;
        #5;
        $sformat(debug_msg, "Signal values: a=%b, b=%b, y=%b", a, b, y);
        debug_print(2, debug_msg);
        if (y !== 0) begin
            $error("Test failed: Expected y=0, got y=%b", y);
        end
        
        // Test case 2
        debug_print(1, "Test case 2: a=1, b=1");
        a = 1; b = 1;
        #5;
        $sformat(debug_msg, "Signal values: a=%b, b=%b, y=%b", a, b, y);
        debug_print(2, debug_msg);
        if (y !== 1) begin
            $error("Test failed: Expected y=1, got y=%b", y);
        end
        
        debug_print(0, "Test sequence completed");
        
        $display("========================================");
        $display("Debugging demonstration complete");
        $display("Try changing debug_level to see different verbosity");
        $display("========================================");
        #10;
        $finish;
    end

    // Generate VCD for signal tracing
    initial begin
        $dumpfile("debug_example.vcd");
        $dumpvars(0, debug_example);
    end

endmodule
