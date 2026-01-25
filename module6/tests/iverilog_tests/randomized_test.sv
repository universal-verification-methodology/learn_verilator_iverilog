/**
 * Randomized Testbench - SystemVerilog (iverilog)
 * 
 * This testbench demonstrates constrained randomization for test generation.
 * 
 * Key Concepts:
 * - Random variable generation ($random, $urandom)
 * - Random test generation
 * - Seed control
 * 
 * Usage:
 *   make randomized_test
 *   or
 *   iverilog -g2012 -o randomized_test randomized_test.sv ../../../module6/dut/multiplexers/mux_4to1.v
 *   vvp randomized_test
 */

`timescale 1ns/1ps

/**
 * MUX Transaction Class
 * 
 * Models a transaction for 4-to-1 multiplexer test.
 */
class mux_transaction;
    rand bit [1:0] sel;  // Randomizable select signal
    rand bit in0, in1, in2, in3;  // Randomizable inputs
    bit expected;  // Calculated expected output
    
    function new();
        sel = 0;
        in0 = 0;
        in1 = 0;
        in2 = 0;
        in3 = 0;
        expected = 0;
    endfunction
    
    function void post_randomize();
        // Calculate expected output based on select signal
        case (sel)
            2'b00: expected = in0;
            2'b01: expected = in1;
            2'b10: expected = in2;
            2'b11: expected = in3;
            default: expected = 0;
        endcase
    endfunction
    
    function void print();
        $display("Transaction: sel=%0d, in0=%b, in1=%b, in2=%b, in3=%b, expected=%b",
                 sel, in0, in1, in2, in3, expected);
    endfunction
endclass

// Top-level testbench module
module randomized_test;
    // DUT signals
    reg [1:0] sel;
    reg in0, in1, in2, in3;
    wire out;
    
    // DUT instantiation
    mux_4to1 dut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );
    
    // Test statistics
    int test_count = 0;
    int pass_count = 0;
    int fail_count = 0;
    
    // Transaction class instance (declared at module level for iverilog compatibility)
    mux_transaction tr;
    
    // Test sequence
    initial begin
        $display("========================================");
        $display("Randomized Testbench (iverilog)");
        $display("========================================");
        
        // Display random seed (for reference)
        $display("Random seed: %0d", $urandom);
        
        // Create transaction instance
        tr = new();
        
        // Generate and run random tests
        repeat (10) begin
            // Generate random values using $urandom
            // Note: iverilog doesn't support randomize() method or $urandom_range()
            // So we use $urandom with modulo for range
            tr.sel = $urandom % 4;  // Random select: 0-3
            tr.in0 = $urandom % 2;  // Random input: 0 or 1
            tr.in1 = $urandom % 2;  // Random input: 0 or 1
            tr.in2 = $urandom % 2;  // Random input: 0 or 1
            tr.in3 = $urandom % 2;  // Random input: 0 or 1
            
            // Calculate expected value
            tr.post_randomize();
            
            // Display transaction (for debugging/logging)
            tr.print();
            
            // Apply to DUT
            sel = tr.sel;
            in0 = tr.in0;
            in1 = tr.in1;
            in2 = tr.in2;
            in3 = tr.in3;
            
            #5;  // Wait for combinational logic
            
            test_count++;
            
            // Check result
            if (out === tr.expected) begin
                pass_count++;
                $display("[PASS] Test %0d: sel=%0d, out=%b, expected=%b",
                         test_count, sel, out, tr.expected);
            end else begin
                fail_count++;
                $error("[FAIL] Test %0d: sel=%0d, out=%b, expected=%b",
                       test_count, sel, out, tr.expected);
            end
        end
        
        // Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests: %0d", test_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
        $display("========================================");
        
        #10;
        $finish;
    end
    
    // Waveform generation
    initial begin
        $dumpfile("randomized_test.vcd");
        $dumpvars(0, randomized_test);
    end
endmodule
