/**
 * Simple OR Gate Design Under Test (DUT)
 * 
 * This is a basic 2-input OR gate used for learning testbench development.
 * 
 * @module or_gate
 * @param a Input signal A
 * @param b Input signal B
 * @param y Output signal (a | b)
 */
module or_gate(
    input  wire a,
    input  wire b,
    output reg  y
);

    // Combinational logic: OR operation
    always @(*) begin
        y = a | b;
    end

endmodule
