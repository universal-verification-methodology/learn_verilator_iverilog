/**
 * Simple AND Gate Testbench for iverilog
 * 
 * This testbench demonstrates:
 * - DUT instantiation
 * - Signal driving
 * - Output monitoring
 * - Basic test patterns
 * 
 * Usage:
 *   iverilog -o and_gate_test and_gate_test.v ../dut/simple_gates/and_gate.v
 *   vvp and_gate_test
 */

`timescale 1ns/1ps

module and_gate_test;

    // Testbench signals
    reg  a, b;
    wire y;

    // Instantiate DUT
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    // Test sequence
    initial begin
        $display("========================================");
        $display("AND Gate Testbench");
        $display("========================================");
        
        // Initialize inputs
        a = 0;
        b = 0;
        #10;
        
        // Test all input combinations
        $display("\nTesting AND gate truth table:");
        $display("Time |  a  |  b  |  y  | Expected");
        $display("-----|-----|-----|-----|----------");
        
        // Test case 1: 0 & 0 = 0
        a = 0; b = 0;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    0", $time, a, b, y);
        if (y !== 0) $error("Test failed: 0 & 0 should be 0");
        
        // Test case 2: 0 & 1 = 0
        a = 0; b = 1;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    0", $time, a, b, y);
        if (y !== 0) $error("Test failed: 0 & 1 should be 0");
        
        // Test case 3: 1 & 0 = 0
        a = 1; b = 0;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    0", $time, a, b, y);
        if (y !== 0) $error("Test failed: 1 & 0 should be 0");
        
        // Test case 4: 1 & 1 = 1
        a = 1; b = 1;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    1", $time, a, b, y);
        if (y !== 1) $error("Test failed: 1 & 1 should be 1");
        
        $display("\n========================================");
        $display("All tests passed!");
        $display("========================================");
        #10;
        $finish;
    end

    // Optional: Generate VCD file for waveform viewing
    initial begin
        $dumpfile("and_gate_test.vcd");
        $dumpvars(0, and_gate_test);
    end

endmodule
