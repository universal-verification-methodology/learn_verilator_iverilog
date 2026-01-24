/**
 * Comprehensive AND Gate Testbench for iverilog
 * 
 * This testbench demonstrates:
 * - Complete test coverage
 * - Error reporting
 * - Waveform generation
 * - Test result summary
 * 
 * Usage:
 *   iverilog -o test_and_gate test_and_gate.v ../../dut/simple_gates/and_gate.v
 *   vvp test_and_gate
 */

`timescale 1ns/1ps

module test_and_gate;

    // Testbench signals
    reg  a, b;
    wire y;
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    // Instantiate DUT
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    // Test task: Check a specific input combination
    task check_and(input reg a_val, b_val, expected);
        begin
            a = a_val;
            b = b_val;
            #5;  // Wait for propagation
            test_count = test_count + 1;
            
            if (y === expected) begin
                pass_count = pass_count + 1;
                $display("[PASS] Test %0d: a=%b, b=%b, y=%b (expected %b)", 
                         test_count, a, b, y, expected);
            end else begin
                fail_count = fail_count + 1;
                $error("[FAIL] Test %0d: a=%b, b=%b, y=%b (expected %b)", 
                       test_count, a, b, y, expected);
            end
        end
    endtask

    // Main test sequence
    initial begin
        $display("========================================");
        $display("AND Gate Comprehensive Test");
        $display("========================================");
        $display("Starting tests at time %0t", $time);
        $display("");
        
        // Test all input combinations
        check_and(0, 0, 0);
        check_and(0, 1, 0);
        check_and(1, 0, 0);
        check_and(1, 1, 1);
        
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
            $finish(1);  // Exit with error code
        end
        
        $display("========================================");
        #10;
        $finish;
    end

    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("test_and_gate.vcd");
        $dumpvars(0, test_and_gate);
    end

endmodule
