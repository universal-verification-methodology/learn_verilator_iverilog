/**
 * 4-bit Counter Design Under Test (DUT)
 * 
 * This is a synchronous 4-bit counter with reset and enable, used for learning
 * testbench development. This module demonstrates sequential logic, which requires
 * clock-based testbench patterns and is more complex to verify than combinational logic.
 * 
 * Verification Context:
 * - Sequential logic requires clock generation and timing control in testbenches
 * - Demonstrates reset sequences, enable control, and state observation
 * - In UVM, sequential logic like counters are used to learn transaction-based
 *   verification, clocking blocks, and sequence generation
 * - This counter can count from 0 to 15 (2^4 - 1), then wraps to 0
 * 
 * @module counter_4bit
 * @param clk Clock signal (positive edge triggered)
 * @param rst_n Active-low reset signal (asynchronous reset, synchronous release)
 * @param en Enable signal (counter increments only when en=1)
 * @param count[3:0] 4-bit counter output (0 to 15, then wraps)
 * 
 * Behavior:
 * - Reset (rst_n=0): count = 0 (synchronous reset on clock edge)
 * - Enable (en=1): count increments on each clock edge
 * - Disable (en=0): count holds current value
 * - Wraps: After 15 (4'b1111), next value is 0 (4'b0000)
 * 
 * Usage Example:
 *   // Instantiate in testbench
 *   counter_4bit dut (
 *       .clk(clk),
 *       .rst_n(rst_n),
 *       .en(en),
 *       .count(count)
 *   );
 */
module counter_4bit(
    input  wire       clk,    // Clock signal (positive edge triggered)
    input  wire       rst_n,  // Active-low reset (0 = reset, 1 = normal operation)
    input  wire       en,     // Enable signal (1 = count, 0 = hold)
    output reg  [3:0] count   // 4-bit counter output (0-15)
);

    /**
     * Synchronous Counter Logic
     * 
     * This always block implements a synchronous (clocked) counter with:
     * - Active-low reset (rst_n = 0 resets counter to 0)
     * - Enable control (en = 1 allows counting, en = 0 holds value)
     * - Positive edge clocking (updates on rising edge of clk)
     * 
     * Key Concepts:
     * - always @(posedge clk) creates sequential (clocked) logic
     * - Non-blocking assignment (<=) is required for sequential logic
     *   - Ensures all assignments happen simultaneously at clock edge
     *   - Prevents race conditions in simulation
     * - Priority: reset > enable > hold
     * 
     * Reset Behavior:
     * - When rst_n = 0, counter resets to 0 on next clock edge
     * - Reset is synchronous (waits for clock edge)
     * 
     * Enable Behavior:
     * - When en = 1 and rst_n = 1, counter increments
     * - When en = 0, counter holds its current value
     * 
     * Counter Wrapping:
     * - When count reaches 15 (4'b1111), next increment wraps to 0 (4'b0000)
     * - This is automatic in Verilog: 4'b1111 + 1 = 4'b0000 (overflow)
     * 
     * Verification Considerations:
     * - Test reset functionality (assert rst_n, verify count = 0)
     * - Test enable functionality (enable/disable, verify counting/holding)
     * - Test wrapping (count from 15 to 0)
     * - Test timing (verify changes occur on clock edges, not between)
     */
    always @(posedge clk) begin
        // Priority 1: Reset (highest priority)
        // Active-low reset: when rst_n is 0, reset counter to 0
        if (!rst_n) begin
            count <= 4'b0000;  // Reset to 0 (non-blocking assignment for sequential logic)
        end
        // Priority 2: Enable counting
        // When reset is released (rst_n=1) and enable is active (en=1), increment
        else if (en) begin
            count <= count + 1;  // Increment counter (wraps automatically from 15 to 0)
        end
        // Priority 3: Hold (implicit)
        // If en is low and rst_n is high, count holds its value
        // This is implicit - no assignment means value is held (latch behavior in reg)
    end

endmodule
