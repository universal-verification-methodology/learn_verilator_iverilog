/**
 * File-Based Testbench - Verilog
 * 
 * Demonstrates:
 * - File reading ($readmemh, $readmemb)
 * - File writing ($fopen, $fwrite, $fclose)
 * - Test vector file formats
 * - Result logging to files
 * 
 * Usage:
 *   iverilog -o file_based_test file_based_test_verilog.v ../../dut/alus/simple_alu.v
 *   vvp file_based_test
 */

`timescale 1ns/1ps

module file_based_test_verilog;

    reg [7:0] a, b;
    reg [1:0] op;
    wire [7:0] result;
    wire zero;
    
    integer file_handle;
    integer i;
    reg [18:0] test_vector [0:9];  // a[7:0], b[7:0], op[1:0], expected[7:0]
    reg [7:0] expected [0:9];
    
    // Instantiate DUT
    simple_alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );
    
    /**
     * Main Test Sequence
     * 
     * This initial block orchestrates the file-based testbench:
     * 1. Read test vectors from input files
     * 2. Open output file for results
     * 3. Apply test vectors and check results
     * 4. Write results to file
     * 5. Close file and finish
     * 
     * File I/O in Verilog:
     * - $readmemh: Read hex format file into memory array
     * - $readmemb: Read binary format file into memory array
     * - $fopen: Open file for writing (returns file handle)
     * - $fwrite: Write formatted data to file
     * - $fclose: Close file handle
     * 
     * Benefits of file-based testing:
     * - Separation: Test vectors separate from testbench code
     * - Reusability: Same testbench with different test vectors
     * - Maintainability: Update test vectors without recompiling
     * - Automation: Generate test vectors from scripts/tools
     * - Traceability: Results logged to files for analysis
     * 
     * UVM Connection: File-based configuration leads to UVM's `uvm_config_db`:
     * - Test vectors in files → Configuration objects in UVM
     * - File reading → Configuration database access
     * - Result logging → UVM reporting mechanism
     */
    initial begin
        $display("========================================");
        $display("File-Based Testbench Example");
        $display("========================================");
        
        /**
         * Step 1: Read Test Vectors from Files
         * 
         * $readmemh reads hexadecimal values from file into memory array.
         * File format: One hex value per line (e.g., "aabbcc" for 24-bit value)
         * 
         * test_vector format: [a[7:0], b[7:0], op[1:0]] = 18 bits total
         * - Bits [17:10]: Input A (8 bits)
         * - Bits [9:2]: Input B (8 bits)
         * - Bits [1:0]: Operation code (2 bits)
         * 
         * expected format: Expected result value (8 bits)
         */
        $readmemh("test_vectors.hex", test_vector);
        $readmemh("expected_results.hex", expected);
        
        $display("Read test vectors from file");
        // Note: $size() is not supported by iverilog for memory arrays
        // Using a fixed size or counting manually would be needed
        
        /**
         * Step 2: Open Output File for Results
         * 
         * $fopen opens a file for writing and returns a file handle.
         * File modes:
         * - "w": Write mode (creates new file, overwrites existing)
         * - "a": Append mode (appends to existing file)
         * - "r": Read mode (for $fread, not used here)
         * 
         * File handle 0 indicates failure to open file.
         * Always check for errors when opening files.
         */
        file_handle = $fopen("test_results.txt", "w");
        if (file_handle == 0) begin
            $error("Failed to open output file");
            $finish;  // Exit simulation if file open fails
        end
        
        $fwrite(file_handle, "ALU Test Results\n");
        $fwrite(file_handle, "================\n");
        $fwrite(file_handle, "Test |  a  |  b  | op | result | expected | Pass/Fail\n");
        $fwrite(file_handle, "-----|-----|-----|----|--------|----------|----------\n");
        
        // Apply test vectors
        for (i = 0; i < 10; i = i + 1) begin
            a = test_vector[i][17:10];
            b = test_vector[i][9:2];
            op = test_vector[i][1:0];
            #5;
            
            $display("Test %0d: a=0x%02h, b=0x%02h, op=%b, result=0x%02h, expected=0x%02h %s",
                     i+1, a, b, op, result, expected[i], 
                     (result === expected[i]) ? "[PASS]" : "[FAIL]");
            
            if (result === expected[i]) begin
                $fwrite(file_handle, "  %0d  | 0x%02h | 0x%02h | %b  |  0x%02h  |   0x%02h   |   PASS\n",
                        i+1, a, b, op, result, expected[i]);
            end else begin
                $fwrite(file_handle, "  %0d  | 0x%02h | 0x%02h | %b  |  0x%02h  |   0x%02h   |   FAIL\n",
                        i+1, a, b, op, result, expected[i]);
                $error("Test %0d failed", i+1);
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
