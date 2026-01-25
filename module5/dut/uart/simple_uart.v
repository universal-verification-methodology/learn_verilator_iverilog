/**
 * Simple UART Design Under Test (DUT)
 * 
 * Basic UART transmitter with configurable baud rate
 * 
 * @module simple_uart
 * @param clk Clock signal
 * @param rst_n Active-low reset
 * @param tx_start Transmit start signal
 * @param tx_data[7:0] Data to transmit
 * @param tx_done Transmission complete flag
 * @param tx Serial output
 */
module simple_uart(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        tx_start,
    input  wire [7:0]  tx_data,
    output reg         tx_done,
    output reg         tx
);

    // UART state machine
    reg [3:0] state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;
    
    localparam IDLE = 4'd0;
    localparam START = 4'd1;
    localparam DATA = 4'd2;
    localparam STOP = 4'd3;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            tx <= 1'b1;
            tx_done <= 1'b0;
            shift_reg <= 8'h00;
            bit_count <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_done <= 1'b0;
                    if (tx_start) begin
                        state <= START;
                        shift_reg <= tx_data;
                    end
                end
                START: begin
                    tx <= 1'b0;  // Start bit
                    state <= DATA;
                    bit_count <= 4'd0;
                end
                DATA: begin
                    tx <= shift_reg[0];
                    shift_reg <= {1'b0, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                    if (bit_count == 4'd7) begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    tx <= 1'b1;  // Stop bit
                    tx_done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
