/**
 * Simple AND Gate Design Under Test (DUT)
 * 
 * This is a basic 2-input AND gate used for learning testbench development.
 * 
 * @module and_gate
 * @param a Input signal A
 * @param b Input signal B
 * @param y Output signal (a & b)
 */
module and_gate(
    input  wire a,
    input  wire b,
    output reg  y
);

    // Combinational logic: AND operation
    always @(*) begin
        y = a & b;
    end

endmodule
