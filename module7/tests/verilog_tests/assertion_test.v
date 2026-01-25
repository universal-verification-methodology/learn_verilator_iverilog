/**
 * Basic Assertions Testbench - Verilog (iverilog)
 * 
 * This testbench demonstrates basic assertion patterns using if-else constructs.
 * 
 * Key Concepts:
 * - Clock-based assertions
 * - Reset assertions
 * - Data validity assertions
 * - Error reporting in assertions
 * 
 * Usage:
 *   make assertion_test
 *   or
 *   iverilog -o assertion_test assertion_test.v ../../../module7/dut/counters/counter_4bit.v
 *   vvp assertion_test
 */

`timescale 1ns/1ps

module assertion_test;

    reg clk;
    reg rst_n;
    reg en;
    wire [3:0] count;

    // Assertion statistics
    integer assertion_count = 0;
    integer assertion_pass = 0;
    integer assertion_fail = 0;

    // DUT instantiation
    counter_4bit dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .count(count)
    );

    // Clock generation (50MHz = 20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Assertion: Reset should clear counter
    reg [3:0] prev_count;
    always @(posedge clk) begin
        if (!rst_n) begin
            // Skip assertion if count is X (unknown) - happens at simulation start
            if (count !== 4'bx && count !== 4'bz) begin
                assertion_count = assertion_count + 1;
                if (count == 4'b0000) begin
                    assertion_pass = assertion_pass + 1;
                end else begin
                    assertion_fail = assertion_fail + 1;
                    $error("[ASSERT FAIL] Reset assertion: count should be 0 when rst_n=0, got %0d", count);
                end
            end
        end
    end

    // Assertion: Counter should not exceed 15
    always @(posedge clk) begin
        if (rst_n && en) begin
            assertion_count = assertion_count + 1;
            if (count <= 4'b1111) begin
                assertion_pass = assertion_pass + 1;
            end else begin
                assertion_fail = assertion_fail + 1;
                $error("[ASSERT FAIL] Range assertion: count should be <= 15, got %0d", count);
            end
        end
    end

    // Test sequence
    initial begin
        $display("========================================");
        $display("Basic Assertions Testbench (iverilog)");
        $display("========================================");
        
        // Initialize
        prev_count = 4'b0000;
        rst_n = 0;
        en = 0;
        #35;  // Hold reset for at least one clock cycle (20ns period, so 35ns ensures one full cycle)
        
        // Release reset
        rst_n = 1;
        en = 1;
        #200;  // Count for several cycles
        
        // Disable counting
        en = 0;
        #50;
        
        // Re-enable
        en = 1;
        #100;
        
        // Reset again
        rst_n = 0;
        #50;
        
        // Print assertion summary
        $display("\n========================================");
        $display("Assertion Summary");
        $display("========================================");
        $display("Total assertions: %0d", assertion_count);
        $display("Passed:           %0d", assertion_pass);
        $display("Failed:           %0d", assertion_fail);
        $display("========================================");
        
        if (assertion_fail > 0) begin
            $error("Some assertions failed!");
        end else begin
            $display("All assertions passed!");
        end
        
        #10;
        $finish;
    end

    // Waveform generation
    initial begin
        $dumpfile("assertion_test.vcd");
        $dumpvars(0, assertion_test);
    end

endmodule
