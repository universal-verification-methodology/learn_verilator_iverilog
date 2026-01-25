/**
 * ALU File-Based Verilog Testbench (iverilog)
 * 
 * This testbench demonstrates file I/O for reading test vectors and writing results.
 * 
 * Key Concepts:
 * - File reading ($readmemh)
 * - File writing ($fopen, $fwrite, $fclose)
 * - Test vector file formats
 * - Result logging to files
 * 
 * Usage:
 *   make alu_file_test
 *   or
 *   iverilog -o alu_file_test alu_file_test.v ../../../module4/dut/alus/simple_alu.v
 *   vvp alu_file_test
 * 
 * Note: This testbench expects test_vectors.hex and expected_results.hex files
 * in the same directory. Create them if they don't exist.
 */

`timescale 1ns/1ps

module alu_file_test;

    // Signal declarations
    reg [7:0] a, b;
    reg [1:0] op;
    wire [7:0] result;
    wire zero;

    // File I/O variables
    integer file_handle;
    integer i;
    reg [18:0] test_vector [0:9];  // a[7:0], b[7:0], op[1:0] = 18 bits
    reg [7:0] expected [0:9];

    // Test statistics
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    // DUT instantiation
    simple_alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );

    // Test sequence
    initial begin
        $display("========================================");
        $display("ALU File-Based Verilog Testbench (iverilog)");
        $display("========================================");
        
        // Read test vectors from files
        $readmemh("test_vectors.hex", test_vector);
        $readmemh("expected_results.hex", expected);
        
        $display("Read test vectors from files");
        
        // Open output file for results
        file_handle = $fopen("test_results.txt", "w");
        if (file_handle == 0) begin
            $error("Failed to open output file");
            $finish;
        end
        
        $fwrite(file_handle, "ALU Test Results\n");
        $fwrite(file_handle, "================\n\n");
        
        // Apply test vectors and check results
        for (i = 0; i < 10; i = i + 1) begin
            // Extract inputs from test vector
            // Format: [a[7:0], b[7:0], op[1:0]]
            a = test_vector[i][17:10];
            b = test_vector[i][9:2];
            op = test_vector[i][1:0];
            
            #5;  // Wait for combinational logic
            
            test_count = test_count + 1;
            
            // Compare actual vs expected
            if (result === expected[i]) begin
                pass_count = pass_count + 1;
                $display("Test %0d [PASS]: a=0x%02h, b=0x%02h, op=%0d -> result=0x%02h (expected 0x%02h)", 
                         test_count, a, b, op, result, expected[i]);
                $fwrite(file_handle, "Test %0d: PASS - result=0x%02h (expected 0x%02h)\n", 
                        test_count, result, expected[i]);
            end else begin
                fail_count = fail_count + 1;
                $error("Test %0d [FAIL]: a=0x%02h, b=0x%02h, op=%0d", test_count, a, b, op);
                $error("  Expected: result=0x%02h", expected[i]);
                $error("  Actual:   result=0x%02h", result);
                $fwrite(file_handle, "Test %0d: FAIL - result=0x%02h (expected 0x%02h)\n", 
                        test_count, result, expected[i]);
            end
        end
        
        // Write summary to file
        $fwrite(file_handle, "\nSummary: Total=%0d, Passed=%0d, Failed=%0d\n", 
                test_count, pass_count, fail_count);
        
        // Close file
        $fclose(file_handle);
        
        // Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests: %0d", test_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
        $display("Results written to test_results.txt");
        $display("========================================");
        
        if (fail_count > 0) begin
            $error("Some tests failed!");
        end else begin
            $display("All tests passed!");
        end
        
        #10;
        $finish;
    end

    // Waveform generation
    initial begin
        $dumpfile("alu_file_test.vcd");
        $dumpvars(0, alu_file_test);
    end

endmodule
