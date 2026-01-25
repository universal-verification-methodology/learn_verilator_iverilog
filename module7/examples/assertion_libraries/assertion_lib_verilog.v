/**
 * Assertion Library Example - Verilog
 * 
 * Demonstrates:
 * - Reusable assertion functions/tasks
 * - Assertion organization
 * - Assertion library patterns
 * 
 * Usage:
 *   iverilog -g2012 -o assertion_lib assertion_lib_verilog.v ../dut/simple_gates/and_gate.v
 *   vvp assertion_lib
 */

`timescale 1ns/1ps

// Assertion library
module assertion_lib;
    // Assertion task: Check equality
    task assert_equal;
        input integer actual;
        input integer expected;
        input [256:0] message;
        begin
            if (actual !== expected) begin
                $display("[ASSERT FAIL] %s: expected %0d, got %0d", message, expected, actual);
                $stop;
            end else begin
                $display("[ASSERT PASS] %s", message);
            end
        end
    endtask
    
    // Assertion task: Check range
    task assert_range;
        input integer value;
        input integer min;
        input integer max;
        input [256:0] message;
        begin
            if (value < min || value > max) begin
                $display("[ASSERT FAIL] %s: value %0d not in range [%0d:%0d]", 
                       message, value, min, max);
                $stop;
            end else begin
                $display("[ASSERT PASS] %s", message);
            end
        end
    endtask
    
    // Assertion task: Check boolean
    task assert_true;
        input condition;
        input [256:0] message;
        begin
            if (!condition) begin
                $display("[ASSERT FAIL] %s", message);
                $stop;
            end else begin
                $display("[ASSERT PASS] %s", message);
            end
        end
    endtask
endmodule

// Testbench using assertion library
module assertion_lib_verilog;
    reg a, b;
    wire y;
    
    // Instantiate DUT
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );
    
    // Import assertion tasks (simulated by instantiating module)
    assertion_lib assert_lib();
    
    initial begin
        $display("========================================");
        $display("Assertion Library Example");
        $display("========================================");
        
        // Test case 1
        a = 0; b = 0;
        #5;
        assert_lib.assert_equal(y, 0, "AND(0,0) should be 0");
        
        // Test case 2
        a = 0; b = 1;
        #5;
        assert_lib.assert_equal(y, 0, "AND(0,1) should be 0");
        
        // Test case 3
        a = 1; b = 0;
        #5;
        assert_lib.assert_equal(y, 0, "AND(1,0) should be 0");
        
        // Test case 4
        a = 1; b = 1;
        #5;
        assert_lib.assert_equal(y, 1, "AND(1,1) should be 1");
        
        // Range assertion example
        assert_lib.assert_range(y, 0, 1, "Output should be in range [0:1]");
        
        // Boolean assertion example
        assert_lib.assert_true((y == 0 || y == 1), "Output should be boolean");
        
        $display("========================================");
        $display("Assertion library demonstration complete");
        $display("========================================");
        #10;
        $finish;
    end
endmodule
