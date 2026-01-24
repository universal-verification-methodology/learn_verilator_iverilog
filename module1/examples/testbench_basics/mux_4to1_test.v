/**
 * 4-to-1 Multiplexer Testbench
 * 
 * This testbench demonstrates:
 * - Module-based testbench structure
 * - Initial blocks for test sequences
 * - Always blocks for clock generation
 * - Signal access and monitoring
 * - $display, $monitor, $strobe
 * 
 * Usage:
 *   iverilog -o mux_4to1_test mux_4to1_test.v ../../dut/multiplexers/mux_4to1.v
 *   vvp mux_4to1_test
 */

`timescale 1ns/1ps

module mux_4to1_test;

    // Testbench signals
    reg [1:0] sel;
    reg       in0, in1, in2, in3;
    wire      out;
    reg       clk;

    // Instantiate DUT
    mux_4to1 dut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );

    // Clock generation (for demonstration)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor for continuous signal tracking
    initial begin
        $monitor("Time %0t: sel=%b, in0=%b, in1=%b, in2=%b, in3=%b, out=%b",
                 $time, sel, in0, in1, in2, in3, out);
    end

    // Test sequence
    initial begin
        $display("========================================");
        $display("4-to-1 Multiplexer Testbench");
        $display("========================================");
        
        // Initialize inputs
        sel = 2'b00;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        #10;
        
        $display("\nTesting all select combinations:");
        $display("sel | in0 | in1 | in2 | in3 | out | Expected");
        $display("----|-----|-----|-----|-----|-----|----------");
        
        // Test case 1: sel=00, select in0
        sel = 2'b00; in0 = 1'b1; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        #5;
        $strobe(" %b  |  %b  |  %b  |  %b  |  %b  |  %b  |   in0", 
                sel, in0, in1, in2, in3, out);
        if (out !== in0) $error("Test failed: sel=00 should select in0");
        
        // Test case 2: sel=01, select in1
        sel = 2'b01; in0 = 1'b0; in1 = 1'b1; in2 = 1'b0; in3 = 1'b0;
        #5;
        $strobe(" %b  |  %b  |  %b  |  %b  |  %b  |  %b  |   in1", 
                sel, in0, in1, in2, in3, out);
        if (out !== in1) $error("Test failed: sel=01 should select in1");
        
        // Test case 3: sel=10, select in2
        sel = 2'b10; in0 = 1'b0; in1 = 1'b0; in2 = 1'b1; in3 = 1'b0;
        #5;
        $strobe(" %b  |  %b  |  %b  |  %b  |  %b  |  %b  |   in2", 
                sel, in0, in1, in2, in3, out);
        if (out !== in2) $error("Test failed: sel=10 should select in2");
        
        // Test case 4: sel=11, select in3
        sel = 2'b11; in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b1;
        #5;
        $strobe(" %b  |  %b  |  %b  |  %b  |  %b  |  %b  |   in3", 
                sel, in0, in1, in2, in3, out);
        if (out !== in3) $error("Test failed: sel=11 should select in3");
        
        $display("\n========================================");
        $display("All tests passed!");
        $display("========================================");
        #10;
        $finish;
    end

    // Generate VCD file
    initial begin
        $dumpfile("mux_4to1_test.vcd");
        $dumpvars(0, mux_4to1_test);
    end

endmodule
