/**
 * 4-to-1 Multiplexer Verilog Testbench (iverilog)
 * 
 * This testbench demonstrates exhaustive testing of a combinational multiplexer.
 * It tests all possible select combinations for complete path coverage.
 * 
 * Key Concepts:
 * - Exhaustive test coverage
 * - Combinational logic testing
 * - Multiple input verification
 * 
 * Usage:
 *   make mux_4to1_test
 *   or
 *   iverilog -o mux_4to1_test mux_4to1_test.v ../../../module1/dut/multiplexers/mux_4to1.v
 *   vvp mux_4to1_test
 */

`timescale 1ns/1ps

module mux_4to1_test;

    // Testbench signal declarations
    reg [1:0] sel;
    reg       in0, in1, in2, in3;
    wire      out;

    // DUT instantiation
    mux_4to1 dut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );

    // Test sequence: Exhaustive testing
    initial begin
        $display("========================================");
        $display("4-to-1 Multiplexer Verilog Testbench (iverilog)");
        $display("========================================");
        $display("Test | sel | in0| in1| in2| in3| out | Expected | Pass/Fail");
        $display("-----|-----|----|----|----|----|-----|----------|----------");
        
        // Test case 1: sel=00 -> out should equal in0
        sel = 2'b00; in0 = 0; in1 = 1; in2 = 1; in3 = 1;
        #5;
        $display("  1  |  %b  |  %b |  %b |  %b |  %b |  %b  |    %b     |   %s",
                 sel, in0, in1, in2, in3, out, in0, (out === in0) ? "PASS" : "FAIL");
        if (out !== in0) $error("Test failed: sel=00, Expected out=%b, got out=%b", in0, out);
        
        // Test case 2: sel=01 -> out should equal in1
        sel = 2'b01; in0 = 1; in1 = 0; in2 = 1; in3 = 1;
        #5;
        $display("  2  |  %b  |  %b |  %b |  %b |  %b |  %b  |    %b     |   %s",
                 sel, in0, in1, in2, in3, out, in1, (out === in1) ? "PASS" : "FAIL");
        if (out !== in1) $error("Test failed: sel=01, Expected out=%b, got out=%b", in1, out);
        
        // Test case 3: sel=10 -> out should equal in2
        sel = 2'b10; in0 = 1; in1 = 1; in2 = 0; in3 = 1;
        #5;
        $display("  3  |  %b  |  %b |  %b |  %b |  %b |  %b  |    %b     |   %s",
                 sel, in0, in1, in2, in3, out, in2, (out === in2) ? "PASS" : "FAIL");
        if (out !== in2) $error("Test failed: sel=10, Expected out=%b, got out=%b", in2, out);
        
        // Test case 4: sel=11 -> out should equal in3
        sel = 2'b11; in0 = 1; in1 = 1; in2 = 1; in3 = 0;
        #5;
        $display("  4  |  %b  |  %b |  %b |  %b |  %b |  %b  |    %b     |   %s",
                 sel, in0, in1, in2, in3, out, in3, (out === in3) ? "PASS" : "FAIL");
        if (out !== in3) $error("Test failed: sel=11, Expected out=%b, got out=%b", in3, out);
        
        $display("========================================");
        $display("All tests completed!");
        $display("========================================");
        #10;
        $finish;
    end

    // Waveform generation
    initial begin
        $dumpfile("mux_4to1_test.vcd");
        $dumpvars(0, mux_4to1_test);
    end

endmodule
