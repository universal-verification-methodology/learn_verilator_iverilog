/**
 * ALU Reusable Routines Verilog Testbench (iverilog)
 * 
 * This testbench demonstrates reusable routines using Verilog tasks and functions.
 * 
 * Key Concepts:
 * - Task definitions for test sequences
 * - Function definitions for calculations
 * - Reusable verification routines
 * 
 * Usage:
 *   make alu_reusable_test
 *   or
 *   iverilog -o alu_reusable_test alu_reusable_test.v ../../../module4/dut/alus/simple_alu.v
 *   vvp alu_reusable_test
 */

`timescale 1ns/1ps

module alu_reusable_test;

    // Signal declarations
    reg [7:0] a, b;
    reg [1:0] op;
    wire [7:0] result;
    wire zero;

    // Test statistics
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    // Task-local variables (must be declared at module level for iverilog)
    reg [8*4-1:0] task_op_name;
    reg [7:0] task_expected;
    reg task_expected_zero;

    // DUT instantiation
    simple_alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );

    /**
     * Function: Calculate Expected Result
     * 
     * Functions in Verilog are used for calculations that return a value.
     * Functions execute in zero simulation time (combinational).
     * 
     * @param a_val Input A value (8-bit)
     * @param b_val Input B value (8-bit)
     * @param op_val Operation code (2-bit: 00=ADD, 01=SUB, 10=AND, 11=OR)
     * @return Expected result (8-bit) based on operation
     */
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

    /**
     * Function: Get Operation Name
     * 
     * Helper function to get operation name from op code.
     * 
     * @param op_val Operation code
     * @return Operation name string
     */
    function [8*4-1:0] get_op_name;
        input [1:0] op_val;
        begin
            case (op_val)
                2'b00: get_op_name = "ADD";
                2'b01: get_op_name = "SUB";
                2'b10: get_op_name = "AND";
                2'b11: get_op_name = "OR ";
                default: get_op_name = "???";
            endcase
        end
    endfunction

    /**
     * Task: Test ALU Operation
     * 
     * Tasks in Verilog can contain timing controls and are used for
     * procedural code that can have delays.
     * 
     * This task performs a complete test cycle:
     * 1. Apply inputs to DUT
     * 2. Wait for combinational logic to settle
     * 3. Calculate expected values
     * 4. Compare actual vs expected
     * 5. Update test statistics
     * 
     * @param a_val Operand A value
     * @param b_val Operand B value
     * @param op_val Operation code
     */
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
            task_op_name = get_op_name(op_val);
            
            // Calculate expected values
            task_expected = calculate_expected(a_val, b_val, op_val);
            task_expected_zero = (task_expected == 8'h00);
            
            // Increment test counter
            test_count = test_count + 1;
            
            // Compare actual vs expected
            if ((result === task_expected) && (zero === task_expected_zero)) begin
                pass_count = pass_count + 1;
                $display("Test %0d [PASS]: %s a=0x%02h, b=0x%02h -> result=0x%02h, zero=%b", 
                         test_count, task_op_name, a_val, b_val, result, zero);
            end else begin
                fail_count = fail_count + 1;
                $error("Test %0d [FAIL]: %s a=0x%02h, b=0x%02h", test_count, task_op_name, a_val, b_val);
                $error("  Expected: result=0x%02h, zero=%b", task_expected, task_expected_zero);
                $error("  Actual:   result=0x%02h, zero=%b", result, zero);
            end
        end
    endtask

    // Test sequence
    initial begin
        $display("========================================");
        $display("ALU Reusable Routines Verilog Testbench (iverilog)");
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
        $dumpfile("alu_reusable_test.vcd");
        $dumpvars(0, alu_reusable_test);
    end

endmodule
