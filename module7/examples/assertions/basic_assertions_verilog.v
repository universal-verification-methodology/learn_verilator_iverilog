/**
 * Basic Assertions Example - Verilog
 * 
 * Demonstrates:
 * - Basic assertion patterns using if-else
 * - Clock-based assertions
 * - Reset assertions
 * - Data validity assertions
 * - Error reporting in assertions
 * 
 * Usage:
 *   iverilog -g2012 -o basic_assertions basic_assertions_verilog.v ../dut/counters/counter_4bit.v
 *   vvp basic_assertions
 */

`timescale 1ns/1ps

module basic_assertions_verilog;

    reg clk;
    reg rst_n;
    reg en;
    wire [3:0] count;
    
    integer assertion_count;
    integer assertion_pass;
    integer assertion_fail;
    
    // Instantiate DUT
    counter_4bit dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .count(count)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Assertion: Reset should clear counter
    always @(posedge clk) begin
        if (!rst_n) begin
            assertion_count = assertion_count + 1;
            if (count == 4'b0000) begin
                assertion_pass = assertion_pass + 1;
                $display("[ASSERT PASS] Reset assertion: count is 0 when rst_n=0");
            end else begin
                assertion_fail = assertion_fail + 1;
                $display("[ASSERT FAIL] Reset assertion: count should be 0 when rst_n=0, got %0d", count);
            end
        end
    end
    
    // Assertion: Counter should not exceed 15
    always @(posedge clk) begin
        if (rst_n && en) begin
            assertion_count = assertion_count + 1;
            if (count <= 4'b1111) begin
                assertion_pass = assertion_pass + 1;
                // Silent pass for this assertion
            end else begin
                assertion_fail = assertion_fail + 1;
                $display("[ASSERT FAIL] Range assertion: count should be <= 15, got %0d", count);
            end
        end
    end
    
    // Assertion: Counter should increment when enabled
    reg [3:0] prev_count;
    always @(posedge clk) begin
        if (rst_n && en) begin
            assertion_count = assertion_count + 1;
            if (count == prev_count + 1 || (prev_count == 4'b1111 && count == 4'b0000)) begin
                assertion_pass = assertion_pass + 1;
            end else begin
                assertion_fail = assertion_fail + 1;
                $display("[ASSERT FAIL] Increment assertion: count should increment, prev=%0d, curr=%0d", 
                       prev_count, count);
            end
            prev_count = count;
        end
    end
    
    // Test sequence
    initial begin
        $display("========================================");
        $display("Basic Assertions Example");
        $display("========================================");
        
        // Initialize
        assertion_count = 0;
        assertion_pass = 0;
        assertion_fail = 0;
        rst_n = 0;
        en = 0;
        prev_count = 4'b0000;
        #25;
        
        // Test reset assertion
        $display("\nTest 1: Reset assertion");
        rst_n = 0;
        #30;
        
        // Test increment assertion
        $display("\nTest 2: Increment assertion");
        rst_n = 1;
        en = 1;
        #100;  // Count for several cycles
        
        // Test range assertion
        $display("\nTest 3: Range assertion");
        #200;  // Continue counting
        
        // Print assertion summary
        $display("");
        $display("========================================");
        $display("Assertion Summary");
        $display("========================================");
        $display("Total assertions:  %0d", assertion_count);
        $display("Passed:             %0d", assertion_pass);
        $display("Failed:             %0d", assertion_fail);
        $display("========================================");
        
        if (assertion_fail == 0) begin
            $display("✓ All assertions PASSED!");
        end else begin
            $display("✗ Some assertions FAILED!");
        end
        
        $display("========================================");
        #20;
        $finish;
    end
    
    // Generate VCD file
    initial begin
        $dumpfile("basic_assertions.vcd");
        $dumpvars(0, basic_assertions_verilog);
    end

endmodule
