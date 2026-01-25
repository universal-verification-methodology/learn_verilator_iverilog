/**
 * AND Gate Verilog Testbench (iverilog)
 * 
 * This testbench demonstrates fundamental Verilog testbench concepts for iverilog.
 * It tests the AND gate DUT with exhaustive test coverage.
 * 
 * Key Concepts:
 * - Testbench architecture
 * - DUT instantiation
 * - Stimulus generation
 * - Response monitoring
 * - Result checking
 * 
 * Usage:
 *   make and_gate_test
 *   or
 *   iverilog -o and_gate_test and_gate_test.v ../../../module0/dut/simple_gates/and_gate.v
 *   vvp and_gate_test
 */

`timescale 1ns/1ps

module and_gate_test;

    // Testbench signal declarations
    reg  a, b;
    wire y;

    // DUT instantiation
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    // Test sequence
    initial begin
        $display("========================================");
        $display("AND Gate Verilog Testbench (iverilog)");
        $display("========================================");
        $display("Time |  a  |  b  |  y  | Expected | Pass/Fail");
        $display("-----|-----|-----|-----|----------|----------");
        
        // Test case 1: a=0, b=0 -> Expected: y=0
        a = 0; b = 0;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    0     |   %s", 
                 $time, a, b, y, (y === 0) ? "PASS" : "FAIL");
        if (y !== 0) $error("Test failed: Expected y=0, got y=%b", y);
        
        // Test case 2: a=0, b=1 -> Expected: y=0
        a = 0; b = 1;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    0     |   %s", 
                 $time, a, b, y, (y === 0) ? "PASS" : "FAIL");
        if (y !== 0) $error("Test failed: Expected y=0, got y=%b", y);
        
        // Test case 3: a=1, b=0 -> Expected: y=0
        a = 1; b = 0;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    0     |   %s", 
                 $time, a, b, y, (y === 0) ? "PASS" : "FAIL");
        if (y !== 0) $error("Test failed: Expected y=0, got y=%b", y);
        
        // Test case 4: a=1, b=1 -> Expected: y=1
        a = 1; b = 1;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    1     |   %s", 
                 $time, a, b, y, (y === 1) ? "PASS" : "FAIL");
        if (y !== 1) $error("Test failed: Expected y=1, got y=%b", y);
        
        $display("========================================");
        $display("All tests completed!");
        $display("========================================");
        #10;
        $finish;
    end

    // Waveform generation
    initial begin
        $dumpfile("and_gate_test.vcd");
        $dumpvars(0, and_gate_test);
    end

endmodule
