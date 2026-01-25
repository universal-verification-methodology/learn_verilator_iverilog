/**
 * Class-Based Testbench - SystemVerilog (iverilog)
 * 
 * This testbench demonstrates object-oriented testbench design using SystemVerilog classes.
 * 
 * Key Concepts:
 * - SystemVerilog class syntax
 * - Transaction classes for data modeling
 * - Testbench classes for test orchestration
 * - Object instantiation and methods
 * 
 * Usage:
 *   make class_based_test
 *   or
 *   iverilog -g2012 -o class_based_test class_based_test.sv ../../../module6/dut/simple_gates/and_gate.v
 *   vvp class_based_test
 */

`timescale 1ns/1ps

/**
 * Transaction Class
 * 
 * Models a transaction (test vector) for the AND gate.
 */
class transaction;
    rand bit a;  // Randomizable input a
    rand bit b;  // Randomizable input b
    bit expected;  // Calculated expected output
    
    function new();
        a = 0;
        b = 0;
        expected = 0;
    endfunction
    
    function void print();
        $display("Transaction: a=%b, b=%b, expected=%b", a, b, expected);
    endfunction
    
    function void post_randomize();
        // Calculate expected result based on randomized inputs
        expected = a & b;
    endfunction
endclass

/**
 * Testbench Class
 * 
 * Orchestrates test execution.
 */
class testbench;
    transaction tr;
    bit result;        // Actual result from DUT simulation
    int test_count;
    int pass_count;
    int fail_count;
    
    function new();
        tr = new();
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
    endfunction
    
    function void run_test(bit a, bit b, bit expected);
        test_count++;
        result = a & b;  // Simulate DUT operation
        
        if (result == expected) begin
            pass_count++;
            $display("[PASS] Test %0d: a=%b, b=%b, result=%b, expected=%b",
                     test_count, a, b, result, expected);
        end else begin
            fail_count++;
            $error("[FAIL] Test %0d: a=%b, b=%b, result=%b, expected=%b",
                   test_count, a, b, result, expected);
        end
    endfunction
    
    function void print_summary();
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests: %0d", test_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
        $display("========================================");
    endfunction
endclass

// Top-level testbench module
module class_based_test;
    // DUT signals
    reg a, b;
    wire y;
    
    // DUT instantiation
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );
    
    // Testbench class instance
    testbench tb;
    
    // Test sequence
    initial begin
        $display("========================================");
        $display("Class-Based Testbench (iverilog)");
        $display("========================================");
        
        // Create testbench instance
        tb = new();
        
        // Run exhaustive tests
        tb.run_test(0, 0, 0);
        tb.run_test(0, 1, 0);
        tb.run_test(1, 0, 0);
        tb.run_test(1, 1, 1);
        
        // Print summary
        tb.print_summary();
        
        #10;
        $finish;
    end
    
    // Waveform generation
    initial begin
        $dumpfile("class_based_test.vcd");
        $dumpvars(0, class_based_test);
    end
endmodule
