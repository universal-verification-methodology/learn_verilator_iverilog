/**
 * 4-bit Counter Verilog Testbench (iverilog)
 * 
 * This testbench demonstrates sequential logic verification patterns, including
 * clock generation, reset sequences, and enable/disable control.
 * 
 * Key Concepts:
 * - Clock generation using always block
 * - Reset sequences
 * - Sequential logic testing
 * - Enable/disable functionality
 * 
 * Usage:
 *   make counter_test
 *   or
 *   iverilog -o counter_test counter_test.v ../../../module1/dut/counters/counter_4bit.v
 *   vvp counter_test
 *   gtkwave counter_test.vcd
 */

`timescale 1ns/1ps

module counter_test;

    // Testbench signal declarations
    reg       clk;
    reg       rst_n;  // Active-low reset
    reg       en;
    wire [3:0] count;

    // DUT instantiation
    counter_4bit dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .count(count)
    );

    // Clock generation (50MHz = 20ns period)
    always begin
        clk = 0;
        #10;
        clk = 1;
        #10;
    end

    // Test sequence
    initial begin
        $display("========================================");
        $display("4-bit Counter Verilog Testbench (iverilog)");
        $display("========================================");
        
        // Initialization
        rst_n = 0;  // Assert reset
        en = 0;
        #25;
        
        // Test 1: Reset verification
        $display("\nTest 1: Reset (rst_n=0)");
        rst_n = 0;
        en = 0;
        #30;
        $display("Time %0t: count = %0d (expected 0)", $time, count);
        if (count !== 4'b0000) $error("Reset failed: count should be 0, got %0d", count);
        
        // Test 2: Counting operation
        $display("\nTest 2: Enable counting (rst_n=1, en=1)");
        rst_n = 1;  // Release reset
        en = 1;     // Enable counting
        #100;       // 5 clock cycles
        $display("Time %0t: count = %0d", $time, count);
        
        // Test 3: Disable functionality
        $display("\nTest 3: Disable counting (en=0)");
        en = 0;
        #50;
        $display("Time %0t: count = %0d (should hold value)", $time, count);
        
        // Test 4: Re-enable operation
        $display("\nTest 4: Re-enable counting");
        en = 1;
        #100;
        $display("Time %0t: count = %0d", $time, count);
        
        // Test 5: Reset during operation
        $display("\nTest 5: Reset again");
        rst_n = 0;
        #30;
        $display("Time %0t: count = %0d (expected 0)", $time, count);
        if (count !== 4'b0000) $error("Reset failed: count should be 0, got %0d", count);
        
        $display("\n========================================");
        $display("All tests completed!");
        $display("========================================");
        #20;
        $finish;
    end

    // Waveform generation
    initial begin
        $dumpfile("counter_test.vcd");
        $dumpvars(0, counter_test);
    end

endmodule
