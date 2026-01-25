/**
 * 2-to-1 Multiplexer Design Under Test (DUT)
 * 
 * This is a basic 2-to-1 multiplexer used for learning testbench development.
 * A multiplexer (mux) selects one of two input signals based on a select signal.
 * This is the simplest form of multiplexer and is an excellent starting point
 * for learning verification concepts.
 * 
 * Verification Context:
 * - Simple combinational logic ideal for learning testbench basics
 * - Only 2 inputs + 1 select = 4 possible input combinations (easy to exhaustively test)
 * - Demonstrates fundamental verification patterns: stimulus, observation, checking
 * - In UVM, such simple modules help understand component-based verification
 *   before tackling complex designs
 * 
 * @module mux_2to1
 * @param sel Select signal (1-bit): 0 = in0, 1 = in1
 * @param in0 Input signal 0 (selected when sel=0)
 * @param in1 Input signal 1 (selected when sel=1)
 * @param out Output signal (selected input based on sel value)
 * 
 * Truth Table:
 *   sel | out
 *   ----|----
 *   0   | in0
 *   1   | in1
 * 
 * Usage Example:
 *   // Instantiate in testbench
 *   mux_2to1 dut (
 *       .sel(sel),
 *       .in0(1'b1),
 *       .in1(1'b0),
 *       .out(out)
 *   );
 */
module mux_2to1(
    input  wire sel,  // 1-bit select signal
    input  wire in0,  // Input 0 (selected when sel=0)
    input  wire in1,  // Input 1 (selected when sel=1)
    output reg  out   // Output (must be reg for procedural assignment)
);

    /**
     * Combinational Logic: 2-to-1 Multiplexer
     * 
     * This always block implements the multiplexer using an if-else statement.
     * The always @(*) syntax creates combinational logic that updates whenever
     * any input (sel, in0, in1) changes.
     * 
     * Key Concepts:
     * - always @(*) creates combinational logic (no clock needed)
     * - if-else provides clear selection logic
     * - Using == for comparison (could also use ternary: out = sel ? in1 : in0)
     * 
     * Alternative Implementation (using ternary operator):
     *   assign out = sel ? in1 : in0;
     * 
     * Note: Using always @(*) with if-else is more explicit and easier to
     * extend for learning purposes, though assign with ternary is more concise.
     */
    always @(*) begin
        if (sel == 1'b0) begin
            out = in0;  // Select input 0 when sel is low
        end else begin
            out = in1;  // Select input 1 when sel is high
        end
    end

endmodule
