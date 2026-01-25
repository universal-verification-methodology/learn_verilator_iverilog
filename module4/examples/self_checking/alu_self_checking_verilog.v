/**
 * Self-Checking ALU Verilog Testbench
 * 
 * This testbench demonstrates a self-checking verification approach where
 * the testbench automatically calculates expected values and compares them
 * against actual DUT outputs. This eliminates the need for manual result
 * checking and enables automated test execution.
 * 
 * Learning Objectives:
 * - Understand self-checking testbench architecture
 * - Learn expected value calculation (reference model)
 * - Master automatic error detection and reporting
 * - Understand test result aggregation
 * - Learn reusable test task patterns
 * 
 * UVM Pattern Inspiration:
 * Self-checking testbenches are fundamental to UVM methodology:
 * - Reference models: Calculate expected values
 * - Scoreboards: Compare expected vs actual
 * - Test sequences: Organize test cases
 * - Result reporting: Aggregate and report results
 * 
 * Key Concepts:
 * - Reference Model: Function that calculates expected results
 * - Test Task: Reusable procedure for running test cases
 * - Automatic Checking: Compare actual vs expected automatically
 * - Result Aggregation: Track pass/fail statistics
 * 
 * Compilation and Execution:
 *   iverilog -o alu_self_checking alu_self_checking_verilog.v ../../dut/alus/simple_alu.v
 *   vvp alu_self_checking
 *   gtkwave alu_self_checking.vcd  # Optional: view waveforms
 * 
 * Usage:
 *   iverilog -o alu_self_checking alu_self_checking_verilog.v ../../dut/alus/simple_alu.v
 *   vvp alu_self_checking
 */

`timescale 1ns/1ps

module alu_self_checking_verilog;

    // ========================================
    // Signal Declarations
    // ========================================
    /**
     * DUT Input Signals
     * 
     * These signals drive the ALU inputs.
     */
    reg [7:0] a, b;    // Operands A and B (8 bits each)
    reg [1:0] op;     // Operation code (00=ADD, 01=SUB, 10=AND, 11=OR)
    
    /**
     * DUT Output Signals
     * 
     * These signals are driven by the ALU outputs.
     */
    wire [7:0] result; // ALU result (8 bits)
    wire zero;         // Zero flag (1 if result is zero)
    
    // ========================================
    // Test Statistics
    // ========================================
    /**
     * Test Result Counters
     * 
     * These variables track test execution statistics:
     * - test_count: Total number of tests executed
     * - pass_count: Number of tests that passed
     * - fail_count: Number of tests that failed
     */
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;
    
    // ========================================
    // DUT Instantiation
    // ========================================
    /**
     * Design Under Test (DUT)
     * 
     * Instantiate the ALU module being verified.
     * All signals are connected by name for clarity.
     */
    simple_alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );
    
    // ========================================
    // Reference Model
    // ========================================
    /**
     * Expected Value Calculation Function
     * 
     * This function implements a reference model that calculates
     * the expected ALU result based on inputs. This is the "golden
     * reference" against which DUT outputs are compared.
     * 
     * Reference Model Logic:
     * - ADD (op=00): a + b
     * - SUB (op=01): a - b
     * - AND (op=10): a & b
     * - OR  (op=11): a | b
     * 
     * This function mirrors the DUT's logic, allowing automatic
     * verification without manual expected value entry.
     * 
     * @param a_val   Operand A value
     * @param b_val   Operand B value
     * @param op_val  Operation code
     * @return        Expected result value
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
    
    // ========================================
    // Self-Checking Test Task
    // ========================================
    /**
     * Self-Checking Test Task
     * 
     * This reusable task performs a complete test cycle:
     * 1. Apply test inputs to DUT
     * 2. Wait for DUT to compute result
     * 3. Calculate expected value using reference model
     * 4. Compare actual vs expected
     * 5. Update test statistics
     * 6. Report pass/fail status
     * 
     * This task encapsulates the test pattern, making it easy to
     * run multiple test cases with different inputs.
     * 
     * @param a_val    Operand A value for this test
     * @param b_val    Operand B value for this test
     * @param op_val   Operation code for this test
     * @param op_name  Operation name (for logging, e.g., "ADD", "SUB")
     */
    // Helper function to get operation name from op code
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
    
    // Declare task-local variables at module level (iverilog requirement)
    reg [8*4-1:0] task_op_name;
    reg [7:0] task_expected;
    reg task_expected_zero;
    
    task test_alu;
        input [7:0] a_val, b_val;
        input [1:0] op_val;
        begin
            // Get operation name from op code
            task_op_name = get_op_name(op_val);
            
            // Step 1: Apply inputs to DUT
            a = a_val;
            b = b_val;
            op = op_val;
            #5;  // Wait for combinational logic to settle
            
            // Step 2: Increment test counter
            test_count = test_count + 1;
            
            // Step 3: Calculate expected values
            begin
                
                // Calculate expected result using reference model
                task_expected = calculate_expected(a_val, b_val, op_val);
                
                // Calculate expected zero flag
                // Zero flag is 1 when result equals 0
                task_expected_zero = (task_expected == 8'h00);
                
                // Step 4: Compare actual vs expected
                // Use === (case equality) for 4-state logic comparison
                if (result === task_expected && zero === task_expected_zero) begin
                    // Test passed
                    pass_count = pass_count + 1;
                    $display("[PASS] Test %0d: %s a=0x%02h, b=0x%02h, result=0x%02h, zero=%b",
                             test_count, task_op_name, a_val, b_val, result, zero);
                end else begin
                    // Test failed
                    fail_count = fail_count + 1;
                    $error("[FAIL] Test %0d: %s a=0x%02h, b=0x%02h, expected=0x%02h (zero=%b), got=0x%02h (zero=%b)",
                           test_count, task_op_name, a_val, b_val, task_expected, task_expected_zero, result, zero);
                end
            end
        end
    endtask
    
    // ========================================
    // Test Sequence
    // ========================================
    /**
     * Test Sequence
     * 
     * This initial block orchestrates the test execution:
     * 1. Print test header
     * 2. Execute test cases for each operation
     * 3. Print test summary
     * 4. Exit with appropriate status code
     * 
     * Test Coverage:
     * - ADD: Normal addition, overflow, zero result
     * - SUB: Normal subtraction, underflow
     * - AND: Various bit patterns
     * - OR: Various bit patterns
     */
    initial begin
        // Print test header
        $display("========================================");
        $display("Self-Checking ALU Testbench");
        $display("========================================");
        
        // ========================================
        // Test ADD Operation (op=00)
        // ========================================
        test_alu(8'h10, 8'h20, 2'b00);  // Normal addition: 0x10 + 0x20 = 0x30
        test_alu(8'hFF, 8'h01, 2'b00);  // Overflow test: 0xFF + 0x01 = 0x00 (wraps)
        test_alu(8'h00, 8'h00, 2'b00);  // Zero result: 0x00 + 0x00 = 0x00
        
        // ========================================
        // Test SUB Operation (op=01)
        // ========================================
        test_alu(8'h30, 8'h10, 2'b01);  // Normal subtraction: 0x30 - 0x10 = 0x20
        test_alu(8'h00, 8'h01, 2'b01);  // Underflow test: 0x00 - 0x01 = 0xFF (wraps)
        
        // ========================================
        // Test AND Operation (op=10)
        // ========================================
        test_alu(8'hAA, 8'h55, 2'b10);  // Bit pattern: 0xAA & 0x55 = 0x00
        test_alu(8'hFF, 8'hFF, 2'b10);  // All ones: 0xFF & 0xFF = 0xFF
        test_alu(8'h00, 8'hFF, 2'b10);  // Zero mask: 0x00 & 0xFF = 0x00
        
        // ========================================
        // Test OR Operation (op=11)
        // ========================================
        test_alu(8'hAA, 8'h55, 2'b11);   // Bit pattern: 0xAA | 0x55 = 0xFF
        test_alu(8'h00, 8'h00, 2'b11);   // Zero result: 0x00 | 0x00 = 0x00
        
        // ========================================
        // Test Summary
        // ========================================
        $display("");
        $display("========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests:  %0d", test_count);
        $display("Passed:       %0d", pass_count);
        $display("Failed:       %0d", fail_count);
        $display("========================================");
        
        // Determine overall test result
        if (fail_count == 0) begin
            $display("✓ All tests PASSED!");
        end else begin
            $display("✗ Some tests FAILED!");
            $finish(1);  // Exit with error code
        end
        
        $display("========================================");
        #10;  // Small delay before finish
        $finish;  // End simulation
    end
    
    // ========================================
    // Waveform Generation
    // ========================================
    /**
     * VCD File Generation
     * 
     * Creates a Value Change Dump (VCD) file for waveform analysis.
     * This file can be viewed in GTKWave or other waveform viewers.
     * 
     * The VCD file will contain:
     * - Input signals (a, b, op)
     * - Output signals (result, zero)
     * - Timing relationships
     */
    initial begin
        $dumpfile("alu_self_checking.vcd");
        $dumpvars(0, alu_self_checking_verilog);
    end

endmodule
