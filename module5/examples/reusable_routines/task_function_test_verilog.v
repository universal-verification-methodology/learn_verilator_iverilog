/**
 * Task and Function Example - Verilog
 * 
 * Demonstrates:
 * - Task definitions for test sequences
 * - Function definitions for calculations
 * - Parameter passing
 * - Reusable verification routines
 * 
 * Usage:
 *   iverilog -o task_function_test task_function_test_verilog.v ../../dut/alus/simple_alu.v
 *   vvp task_function_test
 */

`timescale 1ns/1ps

module task_function_test_verilog;

    reg [7:0] a, b;
    reg [1:0] op;
    wire [7:0] result;
    wire zero;
    
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;
    
    // Task-local variables (must be declared at module level for iverilog)
    reg [8*4-1:0] task_op_name;
    reg [7:0] task_expected;
    reg task_expected_zero;
    
    // Instantiate DUT
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
     * Unlike tasks, functions cannot contain timing controls (#, @, wait).
     * Functions execute in zero simulation time (combinational).
     * 
     * Key differences from tasks:
     * - Functions return a value (declared in function name)
     * - Functions cannot have delays or timing controls
     * - Functions are called in expressions (not as statements)
     * - Functions are synthesizable (tasks are not)
     * 
     * @param a_val Input A value (8-bit)
     * @param b_val Input B value (8-bit)
     * @param op_val Operation code (2-bit: 00=ADD, 01=SUB, 10=AND, 11=OR)
     * @return Expected result (8-bit) based on operation
     * 
     * UVM Connection: Functions in testbenches evolve into helper methods
     * in UVM components. UVM uses methods for calculations and utilities.
     */
    function [7:0] calculate_expected;
        input [7:0] a_val, b_val;
        input [1:0] op_val;
        begin
            // Case statement implements operation selection
            // This is a common pattern for ALU operations
            case (op_val)
                2'b00: calculate_expected = a_val + b_val;  // ADD: arithmetic addition
                2'b01: calculate_expected = a_val - b_val;  // SUB: arithmetic subtraction
                2'b10: calculate_expected = a_val & b_val;  // AND: bitwise AND
                2'b11: calculate_expected = a_val | b_val;  // OR: bitwise OR
                default: calculate_expected = 8'h00;  // Default: return 0 for invalid op
            endcase
        end
    endfunction
    
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
    
    /**
     * Task: Apply Stimulus and Check Result
     * 
     * Tasks in Verilog are used for procedural code that can contain timing controls.
     * Unlike functions, tasks can have delays (#), event controls (@), and wait statements.
     * Tasks are called as statements (not in expressions).
     * 
     * Key differences from functions:
     * - Tasks can contain timing controls (delays, events, waits)
     * - Tasks are called as statements (not in expressions)
     * - Tasks can have multiple outputs (via output/inout arguments)
     * - Tasks are not synthesizable (used only in testbenches)
     * 
     * This task encapsulates the complete test procedure:
     * 1. Apply test vector to DUT inputs
     * 2. Wait for signal propagation (#5 delay)
     * 3. Calculate expected result using function
     * 4. Compare actual vs expected
     * 5. Update test statistics
     * 6. Report pass/fail
     * 
     * Benefits of using tasks:
     * - Code reuse: same test procedure for all operations
     * - Maintainability: change test procedure in one place
     * - Readability: test cases become simple task calls
     * - Organization: related code grouped together
     * 
     * @param a_val Input A value to test (8-bit)
     * @param b_val Input B value to test (8-bit)
     * @param op_val Operation code (2-bit)
     * @param op_name Operation name string (for display)
     * 
     * UVM Connection: Tasks in testbenches evolve into methods in UVM components.
     * UVM uses methods (like `run_phase()`, `drive()`, `monitor()`) for procedural
     * operations that can contain timing and synchronization.
     */
    task test_alu_operation;
        input [7:0] a_val, b_val;
        input [1:0] op_val;
        begin
            // Get operation name from op code
            task_op_name = get_op_name(op_val);
            
            // Step 1: Apply test vector to DUT inputs
            // This drives the DUT with the test stimulus
            a = a_val;
            b = b_val;
            op = op_val;
            
            // Step 2: Wait for combinational logic to propagate
            // #5 delay ensures output has stabilized before checking
            // For sequential logic, would wait for clock edge instead
            #5;
            
            // Step 3: Increment test counter
            test_count = test_count + 1;
            
            // Step 4: Calculate expected result and check
            begin
                // Call function to calculate expected result
                // Functions execute in zero time (combinational)
                task_expected = calculate_expected(a_val, b_val, op_val);
                
                // Calculate expected zero flag
                // Zero flag is true when result equals zero
                task_expected_zero = (task_expected == 8'h00);
                
                // Step 5: Self-checking - compare actual vs expected
                // Use === (case equality) to catch X/Z states
                if (result === task_expected && zero === task_expected_zero) begin
                    // Test passed
                    pass_count = pass_count + 1;
                    $display("[PASS] Test %0d: %s a=0x%02h, b=0x%02h, result=0x%02h",
                             test_count, task_op_name, a_val, b_val, result);
                end else begin
                    // Test failed
                    fail_count = fail_count + 1;
                    // $error prints error message and continues simulation
                    $error("[FAIL] Test %0d: %s a=0x%02h, b=0x%02h, expected=0x%02h, got=0x%02h",
                           test_count, task_op_name, a_val, b_val, task_expected, result);
                end
            end
        end
    endtask
    
    // Task: Run test suite
    task run_test_suite;
        begin
            $display("========================================");
            $display("Running ALU Test Suite");
            $display("========================================");
            
            // Test ADD
            test_alu_operation(8'h10, 8'h20, 2'b00);
            test_alu_operation(8'hFF, 8'h01, 2'b00);
            
            // Test SUB
            test_alu_operation(8'h30, 8'h10, 2'b01);
            test_alu_operation(8'h00, 8'h01, 2'b01);
            
            // Test AND
            test_alu_operation(8'hAA, 8'h55, 2'b10);
            test_alu_operation(8'hFF, 8'hFF, 2'b10);
            
            // Test OR
            test_alu_operation(8'hAA, 8'h55, 2'b11);
            test_alu_operation(8'h00, 8'h00, 2'b11);
        end
    endtask
    
    // Test sequence
    initial begin
        run_test_suite();
        
        // Print summary
        $display("");
        $display("========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests:  %0d", test_count);
        $display("Passed:       %0d", pass_count);
        $display("Failed:       %0d", fail_count);
        $display("========================================");
        
        if (fail_count == 0) begin
            $display("✓ All tests PASSED!");
        end else begin
            $display("✗ Some tests FAILED!");
            $finish(1);
        end
        
        $display("========================================");
        #10;
        $finish;
    end
    
    // Generate VCD file
    initial begin
        $dumpfile("task_function_test.vcd");
        $dumpvars(0, task_function_test_verilog);
    end

endmodule
