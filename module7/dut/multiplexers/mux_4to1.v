/**
 * 4-to-1 Multiplexer Design Under Test (DUT)
 * 
 * This is a 4-to-1 multiplexer used for learning testbench development.
 * A multiplexer (mux) selects one of multiple input signals based on a select signal.
 * This is a fundamental building block in digital design and is commonly used in
 * verification testbenches as a simple DUT for learning purposes.
 * 
 * Verification Context:
 * - This module serves as a simple DUT for learning basic testbench concepts
 * - In UVM (Universal Verification Methodology), such simple modules are often
 *   used as examples before moving to more complex designs
 * - The multiplexer's combinational nature makes it ideal for understanding
 *   stimulus generation and response checking patterns
 * 
 * @module mux_4to1
 * @param sel[1:0] Select signal (2-bit): 00=in0, 01=in1, 10=in2, 11=in3
 * @param in0 Input signal 0 (selected when sel=00)
 * @param in1 Input signal 1 (selected when sel=01)
 * @param in2 Input signal 2 (selected when sel=10)
 * @param in3 Input signal 3 (selected when sel=11)
 * @param out Output signal (selected input based on sel value)
 * 
 * Truth Table:
 *   sel  | out
 *   -----|----
 *   00   | in0
 *   01   | in1
 *   10   | in2
 *   11   | in3
 * 
 * Usage Example:
 *   // Instantiate in testbench
 *   mux_4to1 dut (
 *       .sel(sel),
 *       .in0(1'b1),
 *       .in1(1'b0),
 *       .in2(1'b1),
 *       .in3(1'b0),
 *       .out(out)
 *   );
 */
module mux_4to1(
    input  wire [1:0] sel,  // 2-bit select signal
    input  wire       in0,  // Input 0
    input  wire       in1,  // Input 1
    input  wire       in2,  // Input 2
    input  wire       in3,  // Input 3
    output reg        out   // Output (must be reg for procedural assignment)
);

    /**
     * Combinational Logic: 4-to-1 Multiplexer
     * 
     * This always block implements the multiplexer logic using a case statement.
     * The always @(*) syntax means this block is sensitive to all signals used
     * in the right-hand side (sel, in0, in1, in2, in3), making it combinational.
     * 
     * Key Concepts:
     * - always @(*) creates combinational logic (no clock needed)
     * - case statement provides clear, readable selection logic
     * - default case handles undefined states (good practice for synthesis)
     * - Using 1'bx (unknown) in default helps catch simulation issues
     * 
     * Note: In SystemVerilog, we could use always_comb for better clarity,
     * but this Verilog-2001 syntax works with iverilog.
     */
    always @(*) begin
        case (sel)
            2'b00: out = in0;  // Select input 0 when sel=00
            2'b01: out = in1;  // Select input 1 when sel=01
            2'b10: out = in2;  // Select input 2 when sel=10
            2'b11: out = in3;  // Select input 3 when sel=11
            default: out = 1'bx;  // Unknown state for invalid sel values
        endcase
    end

endmodule
