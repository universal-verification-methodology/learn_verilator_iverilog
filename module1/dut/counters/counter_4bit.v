/**
 * 4-bit Counter Design Under Test (DUT)
 * 
 * This is a synchronous 4-bit counter with reset and enable, used for learning testbench development.
 * 
 * @module counter_4bit
 * @param clk Clock signal
 * @param rst_n Active-low reset signal
 * @param en Enable signal
 * @param count[3:0] 4-bit counter output
 */
module counter_4bit(
    input  wire clk,
    input  wire rst_n,
    input  wire en,
    output reg [3:0] count
);

    // Synchronous counter with active-low reset and enable
    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 4'b0000;
        end else if (en) begin
            count <= count + 1;
        end
        // If en is low, count holds its value
    end

endmodule
