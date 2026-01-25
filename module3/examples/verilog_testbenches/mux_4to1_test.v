/**
 * 4-to-1 Multiplexer Verilog Testbench
 * 
 * This testbench demonstrates exhaustive testing of a combinational multiplexer,
 * testing all possible select combinations. This pattern is essential for
 * combinational logic verification and demonstrates UVM-inspired exhaustive
 * coverage concepts.
 * 
 * Key Concepts:
 * - Exhaustive test coverage (all 2^2 = 4 select combinations)
 * - Combinational logic testing (no clock required)
 * - Multiple input verification
 * - Path coverage (each input path tested)
 * 
 * Usage:
 *   iverilog -o mux_4to1_test mux_4to1_test.v ../../dut/multiplexers/mux_4to1.v
 *   vvp mux_4to1_test
 */

`timescale 1ns/1ps

module mux_4to1_test;

    // ========================================================================
    // TESTBENCH SIGNAL DECLARATIONS
    // ========================================================================
    reg [1:0] sel;        // 2-bit select signal (4 possible values: 00, 01, 10, 11)
    reg       in0, in1, in2, in3;  // Four 1-bit input signals
    wire      out;        // Output signal (driven by DUT)

    // ========================================================================
    // DUT INSTANTIATION
    // ========================================================================
    mux_4to1 dut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );

    // ========================================================================
    // TEST SEQUENCE: Exhaustive Testing
    // ========================================================================
    // Test all 4 possible select combinations to ensure complete path coverage
    initial begin
        $display("========================================");
        $display("4-to-1 Multiplexer Verilog Testbench");
        $display("========================================");
        
        // Test case 1: sel=00, select in0
        // Strategy: Set in0=1, all others=0, verify out=in0
        sel = 2'b00; in0 = 1'b1; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        #5;  // Wait for combinational logic to settle
        $display("Test 1: sel=%b, out=%b (expected in0=%b) %s", 
                 sel, out, in0, (out === in0) ? "[PASS]" : "[FAIL]");
        if (out !== in0) $error("Test failed: sel=00 should select in0");
        
        // Test case 2: sel=01, select in1
        sel = 2'b01; in0 = 1'b0; in1 = 1'b1; in2 = 1'b0; in3 = 1'b0;
        #5;
        $display("Test 2: sel=%b, out=%b (expected in1=%b) %s", 
                 sel, out, in1, (out === in1) ? "[PASS]" : "[FAIL]");
        if (out !== in1) $error("Test failed: sel=01 should select in1");
        
        // Test case 3: sel=10, select in2
        sel = 2'b10; in0 = 1'b0; in1 = 1'b0; in2 = 1'b1; in3 = 1'b0;
        #5;
        $display("Test 3: sel=%b, out=%b (expected in2=%b) %s", 
                 sel, out, in2, (out === in2) ? "[PASS]" : "[FAIL]");
        if (out !== in2) $error("Test failed: sel=10 should select in2");
        
        // Test case 4: sel=11, select in3
        sel = 2'b11; in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b1;
        #5;
        $display("Test 4: sel=%b, out=%b (expected in3=%b) %s", 
                 sel, out, in3, (out === in3) ? "[PASS]" : "[FAIL]");
        if (out !== in3) $error("Test failed: sel=11 should select in3");
        
        $display("========================================");
        $display("All tests completed!");
        $display("========================================");
        #10;
        $finish;
    end

    // Generate VCD file for waveform analysis
    initial begin
        $dumpfile("mux_4to1_test.vcd");
        $dumpvars(0, mux_4to1_test);
    end

endmodule
