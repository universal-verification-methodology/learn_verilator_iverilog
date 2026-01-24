/**
 * Simple 4-bit Counter Design Under Test (DUT)
 * 
 * This is a basic synchronous counter with reset, used for learning testbench development.
 * 
 * @module simple_counter
 * @param clk Clock signal
 * @param rst_n Active-low reset signal
 * @param count 4-bit counter output
 */
module simple_counter(
    input  wire clk,
    input  wire rst_n,
    output reg [3:0] count
);

    // Synchronous counter with active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1;
        end
    end

endmodule
