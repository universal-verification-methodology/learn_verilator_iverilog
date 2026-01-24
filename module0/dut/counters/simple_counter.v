/**
 * Simple 4-bit Counter Design Under Test (DUT)
 * 
 * This is a basic synchronous counter with reset, used for learning testbench development.
 * The counter increments on each positive clock edge and resets to 0 when reset is asserted.
 * 
 * Counter Behavior:
 * - On reset (rst_n = 0): count = 0
 * - On clock edge (rst_n = 1): count = count + 1
 * - Counter wraps around: 15 -> 0
 * 
 * This module demonstrates:
 * - Sequential logic design (clocked circuits)
 * - Synchronous reset (active-low)
 * - Non-blocking assignments (<=) for sequential logic
 * - Multi-bit signal declarations
 * 
 * @module simple_counter
 * @param clk Clock signal - counter increments on positive edge
 * @param rst_n Active-low reset signal (0 = reset, 1 = normal operation)
 * @param count 4-bit counter output (0 to 15, then wraps to 0)
 * 
 * @note This is a synchronous sequential circuit (uses flip-flops)
 * @note Uses non-blocking assignment (<=) which is required for sequential logic
 * @note Reset is synchronous - only takes effect on clock edge
 */
module simple_counter(
    input  wire clk,        // Clock signal: positive edge triggers counter increment
    input  wire rst_n,      // Reset signal: active-low (0 = reset, 1 = count)
    output reg [3:0] count  // Counter output: 4-bit value (0-15)
);

    /**
     * Synchronous counter logic
     * 
     * This always block is sensitive to the positive edge of the clock.
     * This creates sequential logic (flip-flops) that updates on clock edges.
     * 
     * Key points:
     * - @(posedge clk) makes this a clocked (sequential) block
     * - Non-blocking assignment (<=) is used for sequential logic
     * - Reset is checked first (priority)
     * - Counter increments when not in reset
     */
    always @(posedge clk) begin
        // Reset has priority: when rst_n is low, counter resets to 0
        if (!rst_n) begin
            // Active-low reset: set counter to 0
            // 4'b0000 means 4 bits, binary format, value 0
            count <= 4'b0000;
        end else begin
            // Normal operation: increment counter
            // When count reaches 15 (4'b1111), it wraps to 0 on next increment
            count <= count + 1;
        end
    end

endmodule
