/**
 * 2-to-1 Multiplexer Design Under Test (DUT)
 * 
 * This is a basic 2-to-1 multiplexer used for learning testbench development.
 * 
 * @module mux_2to1
 * @param sel Select signal (0 = in0, 1 = in1)
 * @param in0 Input signal 0
 * @param in1 Input signal 1
 * @param out Output signal
 */
module mux_2to1(
    input  wire sel,
    input  wire in0,
    input  wire in1,
    output reg  out
);

    // Combinational logic: Multiplexer
    always @(*) begin
        if (sel == 1'b0) begin
            out = in0;
        end else begin
            out = in1;
        end
    end

endmodule
