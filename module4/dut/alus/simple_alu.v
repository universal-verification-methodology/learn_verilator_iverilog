/**
 * Simple ALU Design Under Test (DUT)
 * 
 * This module implements a simple 4-function Arithmetic Logic Unit (ALU).
 * It performs arithmetic and logical operations on two 8-bit operands.
 * 
 * Supported Operations:
 * - ADD (op=00): Arithmetic addition (a + b)
 * - SUB (op=01): Arithmetic subtraction (a - b)
 * - AND (op=10): Bitwise AND (a & b)
 * - OR  (op=11): Bitwise OR (a | b)
 * 
 * Architecture:
 * - Combinational logic: All operations are combinational (no clock)
 * - Zero flag: Set to 1 when result equals zero
 * - 8-bit operations: All inputs and outputs are 8 bits
 * 
 * This is a typical ALU design used in processors and other
 * digital systems. It demonstrates:
 * - Multi-function combinational logic
 * - Case statement for operation selection
 * - Flag generation (zero flag)
 * 
 * @module simple_alu
 * @param a        Operand A (8 bits, first input)
 * @param b        Operand B (8 bits, second input)
 * @param op       Operation code (2 bits, selects operation)
 *                 - 00: ADD (a + b)
 *                 - 01: SUB (a - b)
 *                 - 10: AND (a & b)
 *                 - 11: OR  (a | b)
 * @param result   ALU result (8 bits, output)
 * @param zero     Zero flag (1 bit, 1 when result is zero)
 */
module simple_alu(
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [1:0] op,
    output reg  [7:0] result,
    output reg         zero
);

    // ========================================
    // ALU Operation Logic (Combinational)
    // ========================================
    /**
     * ALU Operation Selection
     * 
     * Implements combinational ALU logic:
     * - Operation selected by op code
     * - Result computed immediately (no clock required)
     * - Zero flag computed from result
     * 
     * Operation Details:
     * - ADD (op=00): Arithmetic addition
     *   - Result = a + b
     *   - Overflow wraps around (8-bit result)
     * 
     * - SUB (op=01): Arithmetic subtraction
     *   - Result = a - b
     *   - Underflow wraps around (8-bit result)
     * 
     * - AND (op=10): Bitwise AND
     *   - Result = a & b (bitwise AND of each bit)
     * 
     * - OR (op=11): Bitwise OR
     *   - Result = a | b (bitwise OR of each bit)
     * 
     * Note: Uses blocking assignment (=) for combinational logic
     * Note: Uses always @(*) for combinational sensitivity
     * 
     * Zero Flag:
     * - Set to 1 when result equals zero
     * - Set to 0 when result is non-zero
     * - Useful for conditional branching in processors
     */
    always @(*) begin
        // Select operation based on op code
        case (op)
            2'b00: result = a + b;      // ADD: Arithmetic addition
            2'b01: result = a - b;      // SUB: Arithmetic subtraction
            2'b10: result = a & b;      // AND: Bitwise AND
            2'b11: result = a | b;      // OR:  Bitwise OR
            default: result = 8'h00;     // Default: Zero (shouldn't occur)
        endcase
        
        // Generate zero flag
        // Zero flag is 1 when result equals zero, 0 otherwise
        zero = (result == 8'h00);
    end

endmodule
