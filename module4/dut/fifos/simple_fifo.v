/**
 * Simple FIFO Design Under Test (DUT)
 * 
 * 8-entry FIFO with full/empty flags
 * 
 * @module simple_fifo
 * @param clk Clock signal
 * @param rst_n Active-low reset
 * @param wr_en Write enable
 * @param rd_en Read enable
 * @param din[7:0] Data input
 * @param dout[7:0] Data output
 * @param full Full flag
 * @param empty Empty flag
 */
module simple_fifo(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        wr_en,
    input  wire        rd_en,
    input  wire [7:0] din,
    output reg  [7:0] dout,
    output reg         full,
    output reg         empty
);

    // FIFO storage
    reg [7:0] fifo [0:7];
    reg [2:0] wr_ptr;
    reg [2:0] rd_ptr;
    reg [3:0] count;

    always @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr <= 3'b000;
            rd_ptr <= 3'b000;
            count  <= 4'b0000;
            full   <= 1'b0;
            empty  <= 1'b1;
            dout   <= 8'h00;
        end else begin
            // Write operation
            if (wr_en && !full) begin
                fifo[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            
            // Read operation
            if (rd_en && !empty) begin
                dout <= fifo[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
            
            // Update flags
            full  <= (count == 8);
            empty <= (count == 0);
        end
    end

endmodule
