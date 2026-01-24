/**
 * Comprehensive 4-to-1 Multiplexer Test
 * 
 * Complete testbench with:
 * - All input combinations
 * - Error reporting
 * - Test result summary
 * 
 * Usage:
 *   iverilog -o test_mux_4to1 test_mux_4to1.v ../../dut/multiplexers/mux_4to1.v
 *   vvp test_mux_4to1
 */

`timescale 1ns/1ps

module test_mux_4to1;

    reg [1:0] sel;
    reg       in0, in1, in2, in3;
    wire      out;
    integer   test_count = 0;
    integer   pass_count = 0;
    integer   fail_count = 0;

    // Instantiate DUT
    mux_4to1 dut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );

    // Test task
    task test_mux(input [1:0] sel_val, input in0_val, in1_val, in2_val, in3_val, expected);
        begin
            sel = sel_val;
            in0 = in0_val;
            in1 = in1_val;
            in2 = in2_val;
            in3 = in3_val;
            #5;
            test_count = test_count + 1;
            
            if (out === expected) begin
                pass_count = pass_count + 1;
                $display("[PASS] Test %0d: sel=%b, out=%b (expected %b)", 
                         test_count, sel, out, expected);
            end else begin
                fail_count = fail_count + 1;
                $error("[FAIL] Test %0d: sel=%b, out=%b (expected %b)", 
                       test_count, sel, out, expected);
            end
        end
    endtask

    // Main test sequence
    initial begin
        $display("========================================");
        $display("4-to-1 Multiplexer Comprehensive Test");
        $display("========================================");
        
        // Test all select combinations with different input patterns
        test_mux(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);  // sel=00, select in0
        test_mux(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);  // sel=01, select in1
        test_mux(2'b10, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);  // sel=10, select in2
        test_mux(2'b11, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);  // sel=11, select in3
        
        // Test with all inputs low
        test_mux(2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        test_mux(2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        test_mux(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        test_mux(2'b11, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        
        // Print summary
        $display("");
        $display("========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests:  %0d", test_count);
        $display("Passed:       %0d", pass_count);
        $display("Failed:       %0d", fail_count);
        $display("========================================");
        
        if (fail_count == 0) begin
            $display("✓ All tests PASSED!");
        end else begin
            $display("✗ Some tests FAILED!");
            $finish(1);
        end
        
        $display("========================================");
        #10;
        $finish;
    end

    // Generate VCD file
    initial begin
        $dumpfile("test_mux_4to1.vcd");
        $dumpvars(0, test_mux_4to1);
    end

endmodule
