/**
 * ALU Self-Checking Verilog Testbench (iverilog)
 * 
 * This testbench demonstrates self-checking verification with automatic
 * expected value calculation using a reference model.
 * 
 * Key Concepts:
 * - Self-checking testbench architecture
 * - Reference model for expected value calculation
 * - Automatic result comparison
 * - Test result aggregation
 * 
 * Usage:
 *   make alu_test
 *   or
 *   iverilog -o alu_test alu_test.v ../../../module4/dut/alus/simple_alu.v
 *   vvp alu_test
 */

`timescale 1ns/1ps

module alu_test;

    // Signal declarations
    reg [7:0] a, b;
    reg [1:0] op;
    wire [7:0] result;
    wire zero;

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

    // Reference model: Calculate expected result
    function [7:0] calculate_expected;
        input [7:0] a_val, b_val;
        input [1:0] op_val;
        begin
            case (op_val)
                2'b00: calculate_expected = a_val + b_val;  // ADD
                2'b01: calculate_expected = a_val - b_val;  // SUB
                2'b10: calculate_expected = a_val & b_val;  // AND
                2'b11: calculate_expected = a_val | b_val;  // OR
                default: calculate_expected = 8'h00;
            endcase
        end
    endfunction

    // Test task
    reg [7:0] expected_result;
    reg expected_zero;
    reg [8*4-1:0] op_name;
    
    task test_alu;
        input [7:0] a_val, b_val;
        input [1:0] op_val;
        begin
            // Apply inputs
            a = a_val;
            b = b_val;
            op = op_val;
            #5;  // Wait for combinational logic
            
            // Get operation name
            case (op_val)
                2'b00: op_name = "ADD";
                2'b01: op_name = "SUB";
                2'b10: op_name = "AND";
                2'b11: op_name = "OR ";
                default: op_name = "???";
            endcase
            
            // Calculate expected values
            expected_result = calculate_expected(a_val, b_val, op_val);
            expected_zero = (expected_result == 8'h00);
            
            // Increment test counter
            test_count = test_count + 1;
            
            // Compare actual vs expected
            if ((result === expected_result) && (zero === expected_zero)) begin
                pass_count = pass_count + 1;
                $display("Test %0d [PASS]: %s a=0x%02h, b=0x%02h -> result=0x%02h, zero=%b", 
                         test_count, op_name, a_val, b_val, result, zero);
            end else begin
                fail_count = fail_count + 1;
                $error("Test %0d [FAIL]: %s a=0x%02h, b=0x%02h", test_count, op_name, a_val, b_val);
                $error("  Expected: result=0x%02h, zero=%b", expected_result, expected_zero);
                $error("  Actual:   result=0x%02h, zero=%b", result, zero);
            end
        end
    endtask

    // Test sequence
    initial begin
        $display("========================================");
        $display("ALU Self-Checking Verilog Testbench (iverilog)");
        $display("========================================");
        
        // Test ADD operation
        test_alu(8'h10, 8'h20, 2'b00);  // 0x10 + 0x20 = 0x30
        test_alu(8'hFF, 8'h01, 2'b00);  // 0xFF + 0x01 = 0x00 (overflow)
        
        // Test SUB operation
        test_alu(8'h30, 8'h10, 2'b01);  // 0x30 - 0x10 = 0x20
        test_alu(8'h10, 8'h20, 2'b01);  // 0x10 - 0x20 = 0xF0 (underflow)
        
        // Test AND operation
        test_alu(8'hAA, 8'h55, 2'b10);  // 0xAA & 0x55 = 0x00
        test_alu(8'hFF, 8'hAA, 2'b10);  // 0xFF & 0xAA = 0xAA
        
        // Test OR operation
        test_alu(8'hAA, 8'h55, 2'b11);  // 0xAA | 0x55 = 0xFF
        test_alu(8'h00, 8'h00, 2'b11);  // 0x00 | 0x00 = 0x00
        
        // Test summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests: %0d", test_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
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
        $dumpfile("alu_test.vcd");
        $dumpvars(0, alu_test);
    end

endmodule
