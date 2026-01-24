/**
 * File I/O Testbench Example
 * 
 * This testbench demonstrates:
 * - Reading test vectors from files ($readmemh, $readmemb)
 * - Writing results to files ($fopen, $fwrite, $fclose)
 * - File-based testbench patterns
 * 
 * Usage:
 *   iverilog -o file_read_test file_read_test.v ../../dut/simple_gates/and_gate.v
 *   vvp file_read_test
 * 
 * Note: Create test_vectors.hex before running
 */

`timescale 1ns/1ps

module file_read_test;

    reg  a, b;
    wire y;
    integer file_handle;
    integer i;
    reg [1:0] test_vector [0:3];  // Memory array for test vectors
    reg [1:0] expected [0:3];    // Expected results

    // Instantiate DUT
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        $display("========================================");
        $display("File I/O Testbench Example");
        $display("========================================");
        
        // Read test vectors from file
        $readmemh("test_vectors.hex", test_vector);
        $readmemh("expected_results.hex", expected);
        
        $display("Read test vectors from file");
        $display("Test vectors:");
        for (i = 0; i < 4; i = i + 1) begin
            $display("  Vector %0d: a=%b, b=%b, expected=%b", 
                     i, test_vector[i][1], test_vector[i][0], expected[i][0]);
        end
        
        // Open output file for results
        file_handle = $fopen("test_results.txt", "w");
        if (file_handle == 0) begin
            $error("Failed to open output file");
            $finish;
        end
        
        $fwrite(file_handle, "Test Results\n");
        $fwrite(file_handle, "=============\n");
        $fwrite(file_handle, "Time |  a  |  b  |  y  | Expected | Pass/Fail\n");
        $fwrite(file_handle, "-----|-----|-----|-----|----------|----------\n");
        
        // Apply test vectors
        for (i = 0; i < 4; i = i + 1) begin
            a = test_vector[i][1];
            b = test_vector[i][0];
            #5;
            
            $display("Time %0t: a=%b, b=%b, y=%b, expected=%b", 
                     $time, a, b, y, expected[i][0]);
            
            if (y === expected[i][0]) begin
                $fwrite(file_handle, "%4t |  %b  |  %b  |  %b  |    %b     |   PASS\n",
                        $time, a, b, y, expected[i][0]);
            end else begin
                $fwrite(file_handle, "%4t |  %b  |  %b  |  %b  |    %b     |   FAIL\n",
                        $time, a, b, y, expected[i][0]);
                $error("Test failed at vector %0d", i);
            end
        end
        
        // Close file
        $fclose(file_handle);
        
        $display("\nResults written to test_results.txt");
        $display("========================================");
        #10;
        $finish;
    end

endmodule
