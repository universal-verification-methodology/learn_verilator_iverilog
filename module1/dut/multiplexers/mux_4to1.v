/**
 * 4-to-1 Multiplexer Design Under Test (DUT)
 * 
 * This is a 4-to-1 multiplexer used for learning testbench development.
 * 
 * @module mux_4to1
 * @param sel[1:0] Select signal (00=in0, 01=in1, 10=in2, 11=in3)
 * @param in0 Input signal 0
 * @param in1 Input signal 1
 * @param in2 Input signal 2
 * @param in3 Input signal 3
 * @param out Output signal
 */
module mux_4to1(
    input  wire [1:0] sel,
    input  wire       in0,
    input  wire       in1,
    input  wire       in2,
    input  wire       in3,
    output reg        out
);

    // Combinational logic: 4-to-1 Multiplexer
    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 1'bx;
        endcase
    end

endmodule
