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

    /**
     * Test Task: Check a specific input combination
     * 
     * Tasks in Verilog are similar to functions but can contain timing controls.
     * This task encapsulates the test procedure:
     * 1. Apply test vector (a_val, b_val)
     * 2. Wait for signal propagation
     * 3. Check output against expected value
     * 4. Update test statistics
     * 5. Report pass/fail
     * 
     * @param a_val Input A value to test
     * @param b_val Input B value to test
     * @param expected Expected output value
     * 
     * Benefits of using tasks:
     * - Code reuse: same test procedure for all test cases
     * - Maintainability: change test procedure in one place
     * - Readability: test cases become simple function calls
     */
    task check_and(input reg a_val, b_val, expected);
        begin
            // Apply test vector to DUT inputs
            a = a_val;
            b = b_val;
            #5;  // Wait 5ns for combinational logic to propagate
                  // This ensures output has stabilized before checking
            
            // Increment test counter
            test_count = test_count + 1;
            
            /**
             * Self-Checking: Compare actual output with expected
             * 
             * === is case equality operator (checks value and X/Z states)
             * Use === for testbenches to catch X (unknown) or Z (high-impedance) states
             * 
             * == is logical equality (may not catch X/Z properly)
             */
            if (y === expected) begin
                // Test passed
                pass_count = pass_count + 1;
                $display("[PASS] Test %0d: a=%b, b=%b, y=%b (expected %b)", 
                         test_count, a, b, y, expected);
            end else begin
                // Test failed
                fail_count = fail_count + 1;
                // $error prints error message and continues simulation
                // Use $fatal to abort simulation on error
                $error("[FAIL] Test %0d: a=%b, b=%b, y=%b (expected %b)", 
                       test_count, a, b, y, expected);
            end
        end
    endtask

    /**
     * Main Test Sequence
     * 
     * This initial block orchestrates the entire test:
     * 1. Print test header
     * 2. Run all test cases using the check_and task
     * 3. Print test summary with statistics
     * 4. Exit with appropriate error code
     * 
     * Test Coverage:
     * - Exhaustive: Tests all 2^2 = 4 input combinations
     * - Self-checking: Each test verifies its own result
     * - Statistical: Tracks pass/fail counts
     */
    initial begin
        // Test header
        $display("========================================");
        $display("AND Gate Comprehensive Test");
        $display("========================================");
        $display("Starting tests at time %0t", $time);
        $display("");
        
        /**
         * Exhaustive Test Cases
         * 
         * Test all possible input combinations (truth table):
         * - 0 & 0 = 0
         * - 0 & 1 = 0
         * - 1 & 0 = 0
         * - 1 & 1 = 1
         * 
         * Using the check_and task makes test cases concise and readable.
         */
        check_and(0, 0, 0);  // Test case 1: Both inputs 0
        check_and(0, 1, 0);  // Test case 2: A=0, B=1
        check_and(1, 0, 0);  // Test case 3: A=1, B=0
        check_and(1, 1, 1);  // Test case 4: Both inputs 1
        
        /**
         * Test Summary
         * 
         * Print statistics to help understand test results:
         * - Total number of tests run
         * - Number of passed tests
         * - Number of failed tests
         * 
         * This makes it easy to see test coverage and results at a glance.
         */
        $display("");
        $display("========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests:  %0d", test_count);
        $display("Passed:       %0d", pass_count);
        $display("Failed:       %0d", fail_count);
        $display("========================================");
        
        /**
         * Exit Status
         * 
         * Set exit code based on test results:
         * - 0: All tests passed (success)
         * - 1: Some tests failed (failure)
         * 
         * This allows test automation tools to detect failures.
         * $finish(1) exits with error code 1.
         */
        if (fail_count == 0) begin
            $display("✓ All tests PASSED!");
        end else begin
            $display("✗ Some tests FAILED!");
            $finish(1);  // Exit with error code 1 (failure)
        end
        
        $display("========================================");
        #10;      // Final delay
        $finish;  // Exit with success code (0)
    end

    /**
     * VCD File Generation
     * 
     * Generate waveform file for GTKWave analysis.
     * This allows visual inspection of signal behavior during tests.
     * 
     * View waveforms:
     *   gtkwave test_and_gate.vcd
     */
    initial begin
        $dumpfile("test_and_gate.vcd");        // Set VCD output filename
        $dumpvars(0, test_and_gate);            // Dump all signals (full hierarchy)
    end

endmodule
