/**
 * Functional Coverage Testbench - Verilog (iverilog)
 * 
 * This testbench demonstrates manual functional coverage using counters.
 * 
 * Key Concepts:
 * - Manual functional coverage using counters
 * - Coverage bins implementation
 * - Coverage collection and analysis
 * 
 * Usage:
 *   make coverage_test
 *   or
 *   iverilog -o coverage_test coverage_test.v ../../../module7/dut/multiplexers/mux_4to1.v
 *   vvp coverage_test
 */

`timescale 1ns/1ps

module coverage_test;

    reg [1:0] sel;
    reg in0, in1, in2, in3;
    wire out;

    // Coverage bins for select signal (4 values: 0-3)
    reg [3:0] sel_coverage;

    // Coverage bins for input combinations (16 combinations)
    reg [15:0] input_coverage;

    // Test statistics
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    // DUT instantiation
    mux_4to1 dut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );

    // Task to update coverage
    task update_coverage;
        input [1:0] sel_val;
        input [3:0] input_val;
        begin
            // Track select coverage
            sel_coverage[sel_val] = 1;
            
            // Track input combination coverage
            input_coverage[input_val] = 1;
        end
    endtask

    // Function to calculate coverage percentage for select
    // Note: Verilog requires functions to have at least one input port
    function real calculate_sel_coverage;
        input dummy;  // Dummy input to satisfy Verilog requirement
        integer count;
        integer i;
        begin
            count = 0;
            for (i = 0; i < 4; i = i + 1) begin
                if (sel_coverage[i]) count = count + 1;
            end
            calculate_sel_coverage = (count * 100.0) / 4.0;
        end
    endfunction

    // Function to calculate coverage percentage for inputs
    // Note: Verilog requires functions to have at least one input port
    function real calculate_input_coverage;
        input dummy;  // Dummy input to satisfy Verilog requirement
        integer count;
        integer i;
        begin
            count = 0;
            for (i = 0; i < 16; i = i + 1) begin
                if (input_coverage[i]) count = count + 1;
            end
            calculate_input_coverage = (count * 100.0) / 16.0;
        end
    endfunction

    // Test sequence
    initial begin
        $display("========================================");
        $display("Functional Coverage Testbench (iverilog)");
        $display("========================================");
        
        // Initialize coverage tracking
        sel_coverage = 4'b0000;
        input_coverage = 16'b0000000000000000;
        
        // Test all select values
        repeat (4) begin
            sel = test_count;
            in0 = 1; in1 = 0; in2 = 0; in3 = 0;
            #5;
            
            test_count++;
            update_coverage(sel, {in0, in1, in2, in3});
            
            // Check result
            if (out === in0 && sel == 0) begin
                pass_count++;
            end else if (out === in1 && sel == 1) begin
                pass_count++;
            end else if (out === in2 && sel == 2) begin
                pass_count++;
            end else if (out === in3 && sel == 3) begin
                pass_count++;
            end else begin
                fail_count++;
                $error("Test failed: sel=%0d", sel);
            end
        end
        
        // Print coverage report
        $display("\n========================================");
        $display("Coverage Report");
        $display("========================================");
        $display("Select coverage: %.1f%%", calculate_sel_coverage(1'b0));
        $display("Input coverage:  %.1f%%", calculate_input_coverage(1'b0));
        $display("Coverage bins:");
        $display("  sel[0]: %s", sel_coverage[0] ? "COVERED" : "NOT COVERED");
        $display("  sel[1]: %s", sel_coverage[1] ? "COVERED" : "NOT COVERED");
        $display("  sel[2]: %s", sel_coverage[2] ? "COVERED" : "NOT COVERED");
        $display("  sel[3]: %s", sel_coverage[3] ? "COVERED" : "NOT COVERED");
        $display("========================================");
        $display("Test Summary: Total=%0d, Passed=%0d, Failed=%0d", 
                 test_count, pass_count, fail_count);
        $display("========================================");
        
        #10;
        $finish;
    end

    // Waveform generation
    initial begin
        $dumpfile("coverage_test.vcd");
        $dumpvars(0, coverage_test);
    end

endmodule
