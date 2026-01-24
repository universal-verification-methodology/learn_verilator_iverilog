/**
 * Simple OR Gate Design Under Test (DUT)
 * 
 * This is a basic 2-input OR gate used for learning testbench development.
 * It implements the fundamental OR logic operation: output is HIGH when
 * either or both inputs are HIGH.
 * 
 * Truth Table:
 *   a  |  b  |  y
 *  ----|-----|----
 *   0  |  0  |  0
 *   0  |  1  |  1
 *   1  |  0  |  1
 *   1  |  1  |  1
 * 
 * This module demonstrates:
 * - Basic combinational logic design
 * - Verilog module declaration and port definitions
 * - Always blocks for combinational logic
 * - Wire vs reg signal types
 * 
 * @module or_gate
 * @param a Input signal A (1-bit)
 * @param b Input signal B (1-bit)
 * @param y Output signal (a | b) - HIGH when at least one input is HIGH
 * 
 * @note This is a combinational circuit with no clock or reset
 * @note The output is declared as 'reg' because it's assigned in an always block,
 *       but it synthesizes to combinational logic (no flip-flops)
 */
module or_gate(
    input  wire a,  // Input A: First input signal
    input  wire b,  // Input B: Second input signal
    output reg  y   // Output: OR result (a | b)
);

    /**
     * Combinational logic block
     * 
     * The always @(*) block is sensitive to all signals used in the block.
     * This creates combinational logic that updates whenever any input changes.
     * 
     * The (*) is a SystemVerilog wildcard that automatically includes all
     * signals that are read within the block in the sensitivity list.
     * 
     * In Verilog-2001, you would write: always @(a or b)
     */
    always @(*) begin
        // OR operation: y is 1 when either a or b (or both) are 1
        // This is the fundamental OR gate behavior
        y = a | b;
    end

endmodule
