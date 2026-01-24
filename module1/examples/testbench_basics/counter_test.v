/**
 * Counter Testbench
 * 
 * This testbench demonstrates:
 * - Clock generation with always blocks
 * - Reset sequences
 * - Enable signal control
 * - Sequential logic testing
 * 
 * Usage:
 *   iverilog -o counter_test counter_test.v ../../dut/counters/counter_4bit.v
 *   vvp counter_test
 */

`timescale 1ns/1ps

module counter_test;

    // Testbench signals
    reg       clk;
    reg       rst_n;
    reg       en;
    wire [3:0] count;

    // Instantiate DUT
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
        $display("4-bit Counter Testbench");
        $display("========================================");
        
        // Initialize
        rst_n = 0;
        en = 0;
        #25;  // Wait for clock edge
        
        // Test 1: Reset
        $display("\nTest 1: Reset (rst_n=0)");
        rst_n = 0;
        en = 0;
        #30;
        $display("Time %0t: count = %0d (expected 0)", $time, count);
        if (count !== 4'b0000) $error("Reset failed: count should be 0");
        
        // Test 2: Release reset, enable counting
        $display("\nTest 2: Enable counting (rst_n=1, en=1)");
        rst_n = 1;
        en = 1;
        #100;  // Count for 5 clock cycles
        $display("Time %0t: count = %0d (expected ~5)", $time, count);
        
        // Test 3: Disable counting
        $display("\nTest 3: Disable counting (en=0)");
        en = 0;
        #50;
        $display("Time %0t: count = %0d (should hold value)", $time, count);
        
        // Test 4: Re-enable counting
        $display("\nTest 4: Re-enable counting");
        en = 1;
        #100;
        $display("Time %0t: count = %0d", $time, count);
        
        // Test 5: Reset again
        $display("\nTest 5: Reset again");
        rst_n = 0;
        #30;
        $display("Time %0t: count = %0d (expected 0)", $time, count);
        if (count !== 4'b0000) $error("Reset failed: count should be 0");
        
        $display("\n========================================");
        $display("All tests completed!");
        $display("========================================");
        #20;
        $finish;
    end

    // Generate VCD file
    initial begin
        $dumpfile("counter_test.vcd");
        $dumpvars(0, counter_test);
    end

endmodule
