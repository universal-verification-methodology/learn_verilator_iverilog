/**
 * Verification Metrics Tracker - Verilog
 * 
 * Demonstrates:
 * - Coverage metrics tracking
 * - Bug metrics tracking
 * - Test metrics tracking
 * - Progress tracking
 * - Quality metrics
 * 
 * Usage:
 *   iverilog -o metrics_tracker metrics_tracker_verilog.v ../../dut/simple_gates/and_gate.v
 *   vvp metrics_tracker
 */

`timescale 1ns/1ps

module metrics_tracker_verilog;

    reg a, b;
    wire y;
    
    // Metrics tracking
    integer total_tests = 0;
    integer passed_tests = 0;
    integer failed_tests = 0;
    integer coverage_bins[0:3];
    integer bugs_found = 0;
    real start_time;
    real end_time;
    
    // Instantiate DUT
    and_gate dut (.a(a), .b(b), .y(y));
    
    // Function to calculate coverage
    // Note: Verilog requires functions to have at least one input port
    function real calculate_coverage;
        input dummy;  // Dummy input to satisfy Verilog requirement
        integer covered;
        integer i;
        begin
            covered = 0;
            for (i = 0; i < 4; i = i + 1) begin
                if (coverage_bins[i]) covered = covered + 1;
            end
            calculate_coverage = (covered * 100.0) / 4.0;
        end
    endfunction
    
    // Task to run test
    task run_test;
        input a_val, b_val, expected;
        begin
            total_tests = total_tests + 1;
            a = a_val;
            b = b_val;
            #5;
            
            // Track coverage
            if (a == 0 && b == 0) coverage_bins[0] = 1;
            if (a == 0 && b == 1) coverage_bins[1] = 1;
            if (a == 1 && b == 0) coverage_bins[2] = 1;
            if (a == 1 && b == 1) coverage_bins[3] = 1;
            
            // Check result
            if (y === expected) begin
                passed_tests = passed_tests + 1;
            end else begin
                failed_tests = failed_tests + 1;
                bugs_found = bugs_found + 1;
                $display("[ERROR] Test failed: a=%b, b=%b, y=%b, expected=%b",
                       a, b, y, expected);
            end
        end
    endtask
    
    // Task to print metrics
    task print_metrics;
        real pass_rate;
        real coverage;
        real test_time;
        integer bin_count;
        integer i;
        begin
            pass_rate = (passed_tests * 100.0) / total_tests;
            coverage = calculate_coverage(1'b0);  // Dummy argument
            test_time = end_time - start_time;
            
            $display("");
            $display("========================================");
            $display("Verification Metrics Report");
            $display("========================================");
            $display("Test Metrics:");
            $display("  Total tests:     %0d", total_tests);
            $display("  Passed:          %0d", passed_tests);
            $display("  Failed:          %0d", failed_tests);
            $display("  Pass rate:       %.1f%%", pass_rate);
            $display("");
            $display("Coverage Metrics:");
            $display("  Coverage:        %.1f%%", coverage);
            bin_count = 0;
            for (i = 0; i < 4; i = i + 1) begin
                if (coverage_bins[i]) bin_count = bin_count + 1;
            end
            $display("  Coverage bins:   %0d/4", bin_count);
            $display("");
            $display("Bug Metrics:");
            $display("  Bugs found:      %0d", bugs_found);
            $display("");
            $display("Quality Metrics:");
            $display("  Test time:       %.1f ns", test_time);
            $display("  Tests/sec:       %.1f", total_tests / (test_time / 1000.0));
            $display("========================================");
        end
    endtask
    
    initial begin
        $display("========================================");
        $display("Verification Metrics Tracker");
        $display("========================================");
        
        // Initialize metrics
        coverage_bins[0] = 0;
        coverage_bins[1] = 0;
        coverage_bins[2] = 0;
        coverage_bins[3] = 0;
        start_time = $time;
        
        // Run tests
        run_test(0, 0, 0);
        run_test(0, 1, 0);
        run_test(1, 0, 0);
        run_test(1, 1, 1);
        
        end_time = $time;
        
        // Print metrics
        print_metrics();
        
        #10;
        $finish;
    end

endmodule
