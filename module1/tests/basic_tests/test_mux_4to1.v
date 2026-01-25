/**
 * Comprehensive 4-to-1 Multiplexer Test
 * 
 * This is a production-quality testbench demonstrating best practices:
 * - Reusable test tasks (modular test organization)
 * - Comprehensive test coverage (multiple test patterns)
 * - Automatic pass/fail tracking (test statistics)
 * - Error reporting (detailed failure messages)
 * - Test result summary (overall test status)
 * 
 * Verification Methodology Context:
 * - This demonstrates task-based test organization, a fundamental pattern
 * - In UVM, tasks evolve into sequences and virtual sequences
 * - Test statistics tracking is similar to UVM's test reporting
 * - The modular structure (tasks) is the foundation for UVM's component-based architecture
 * - See: https://github.com/universal-verification-methodology/core for
 *   advanced test organization patterns
 * 
 * Best Practices Demonstrated:
 * - Use tasks for reusable test patterns (DRY principle)
 * - Track test statistics (pass/fail counts)
 * - Provide clear error messages
 * - Generate test summaries
 * - Exit with appropriate status codes (0 = pass, 1 = fail)
 * 
 * Usage:
 *   iverilog -o test_mux_4to1 test_mux_4to1.v ../../dut/multiplexers/mux_4to1.v
 *   vvp test_mux_4to1
 *   echo $?  # Check exit code (0 = pass, 1 = fail)
 */

`timescale 1ns/1ps

module test_mux_4to1;

    // ========================================================================
    // Testbench Signal Declarations
    // ========================================================================
    
    reg [1:0] sel;        // Select signal
    reg       in0, in1, in2, in3;  // Input signals
    wire      out;        // Output signal
    
    // Test statistics (track pass/fail counts)
    integer   test_count = 0;  // Total number of tests executed
    integer   pass_count = 0;  // Number of passing tests
    integer   fail_count = 0;  // Number of failing tests

    // ========================================================================
    // DUT (Design Under Test) Instantiation
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
    // Reusable Test Task
    // ========================================================================
    // This task encapsulates a single test case, making the testbench modular.
    // 
    // Benefits of Task-Based Organization:
    // - Reusable: Call the same task with different parameters
    // - Readable: Test cases are clear and concise
    // - Maintainable: Change test logic in one place
    // - Scalable: Easy to add new test cases
    // 
    // In UVM: Tasks evolve into sequences that generate transactions
    // 
    // Task Parameters:
    // - sel_val: Select value to test
    // - in0_val, in1_val, in2_val, in3_val: Input values
    // - expected: Expected output value
    
    task test_mux(
        input [1:0] sel_val,      // Select value
        input       in0_val,       // Input 0 value
        input       in1_val,       // Input 1 value
        input       in2_val,       // Input 2 value
        input       in3_val,       // Input 3 value
        input       expected       // Expected output
    );
        begin
            // Apply stimulus
            sel = sel_val;
            in0 = in0_val;
            in1 = in1_val;
            in2 = in2_val;
            in3 = in3_val;
            #5;  // Wait for combinational logic to propagate
            
            // Increment test counter
            test_count = test_count + 1;
            
            // Check result and update statistics
            if (out === expected) begin
                // Test passed
                pass_count = pass_count + 1;
                $display("[PASS] Test %0d: sel=%b, out=%b (expected %b)", 
                         test_count, sel, out, expected);
            end else begin
                // Test failed
                fail_count = fail_count + 1;
                $error("[FAIL] Test %0d: sel=%b, out=%b (expected %b)", 
                       test_count, sel, out, expected);
            end
        end
    endtask

    // ========================================================================
    // Main Test Sequence
    // ========================================================================
    // This testbench provides comprehensive coverage:
    // 1. Test each select combination with the corresponding input high
    // 2. Test each select combination with all inputs low
    // 3. Generate test summary
    // 4. Exit with appropriate status code
    
    initial begin
        $display("========================================");
        $display("4-to-1 Multiplexer Comprehensive Test");
        $display("========================================");
        
        // ====================================================================
        // Test Group 1: Each select value with corresponding input high
        // ====================================================================
        // This verifies that each select value correctly routes the corresponding input
        // 
        // Test Pattern:
        // - Set the selected input to 1, all others to 0
        // - Verify output equals the selected input (should be 1)
        
        test_mux(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);  // sel=00, select in0 (high)
        test_mux(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);  // sel=01, select in1 (high)
        test_mux(2'b10, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);  // sel=10, select in2 (high)
        test_mux(2'b11, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);  // sel=11, select in3 (high)
        
        // ====================================================================
        // Test Group 2: All inputs low
        // ====================================================================
        // This verifies that when all inputs are low, output is low regardless of select
        // 
        // Test Pattern:
        // - Set all inputs to 0
        // - Test all select values
        // - Verify output is always 0
        
        test_mux(2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);  // sel=00, all low
        test_mux(2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);  // sel=01, all low
        test_mux(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);  // sel=10, all low
        test_mux(2'b11, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);  // sel=11, all low
        
        // ====================================================================
        // Test Summary
        // ====================================================================
        // Print comprehensive test statistics
        
        $display("");
        $display("========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests:  %0d", test_count);
        $display("Passed:       %0d", pass_count);
        $display("Failed:       %0d", fail_count);
        $display("========================================");
        
        // Final status and exit code
        // Exit code: 0 = success, non-zero = failure
        // This allows scripts to check test results: if [ $? -eq 0 ]; then ...
        if (fail_count == 0) begin
            $display("✓ All tests PASSED!");
            $display("========================================");
            #10;
            $finish(0);  // Exit with success code
        end else begin
            $display("✗ Some tests FAILED!");
            $display("========================================");
            #10;
            $finish(1);  // Exit with failure code
        end
    end

    // ========================================================================
    // Waveform Generation (VCD File)
    // ========================================================================
    
    initial begin
        $dumpfile("test_mux_4to1.vcd");
        $dumpvars(0, test_mux_4to1);
    end

endmodule
