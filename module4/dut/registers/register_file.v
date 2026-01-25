/**
 * Simple Register File Design Under Test (DUT)
 * 
 * This module implements a simple register file with:
 * - 4 registers (each 8 bits wide)
 * - 2 read ports (can read two registers simultaneously)
 * - 1 write port (can write one register per cycle)
 * 
 * Architecture:
 * - Synchronous write: Writes occur on positive clock edge
 * - Combinational read: Reads are asynchronous (immediate)
 * - Reset: Clears all registers to zero
 * 
 * This is a typical register file design used in processors
 * and other digital systems. It demonstrates:
 * - Multi-port memory structures
 * - Synchronous vs combinational logic
 * - Reset behavior
 * 
 * @module register_file
 * @param clk      Clock signal (synchronizes writes)
 * @param rst_n    Active-low reset (clears all registers)
 * @param we       Write enable (1 = write, 0 = read mode)
 * @param waddr    Write address (2 bits, selects register 0-3)
 * @param wdata    Write data (8 bits, data to write)
 * @param raddr0   Read address 0 (2 bits, selects register 0-3)
 * @param raddr1   Read address 1 (2 bits, selects register 0-3)
 * @param rdata0   Read data 0 (8 bits, output from raddr0)
 * @param rdata1   Read data 1 (8 bits, output from raddr1)
 */
module register_file(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        we,
    input  wire [1:0]  waddr,
    input  wire [7:0]  wdata,
    input  wire [1:0]  raddr0,
    input  wire [1:0]  raddr1,
    output reg  [7:0]  rdata0,
    output reg  [7:0]  rdata1
);

    // ========================================
    // Register File Storage
    // ========================================
    /**
     * Register Array
     * 
     * This array stores the register file data.
     * - 4 registers (indices 0-3)
     * - Each register is 8 bits wide
     * 
     * Access:
     * - Write: registers[waddr] <= wdata (synchronous)
     * - Read:  registers[raddr0], registers[raddr1] (combinational)
     */
    reg [7:0] registers [0:3];

    // ========================================
    // Write Port (Synchronous)
    // ========================================
    /**
     * Write Port Logic
     * 
     * Implements synchronous write behavior:
     * - Writes occur on positive clock edge
     * - Reset clears all registers to zero
     * - Write enable (we) controls whether write occurs
     * - Write address (waddr) selects which register to write
     * 
     * Write Behavior:
     * 1. If reset active: Clear all registers
     * 2. Else if write enable: Write wdata to registers[waddr]
     * 3. Else: No change (registers retain values)
     * 
     * Note: Uses non-blocking assignment (<=) for synchronous logic
     */
    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset: Clear all registers to zero
            registers[0] <= 8'h00;
            registers[1] <= 8'h00;
            registers[2] <= 8'h00;
            registers[3] <= 8'h00;
        end else if (we) begin
            // Write: Store wdata into selected register
            registers[waddr] <= wdata;
        end
        // If !we and rst_n, registers retain their values (no change)
    end

    // ========================================
    // Read Ports (Combinational)
    // ========================================
    /**
     * Read Port Logic
     * 
     * Implements combinational read behavior:
     * - Reads are asynchronous (no clock required)
     * - Outputs update immediately when address changes
     * - Both read ports operate independently
     * 
     * Read Behavior:
     * - rdata0 = registers[raddr0] (always)
     * - rdata1 = registers[raddr1] (always)
     * 
     * Note: Uses blocking assignment (=) for combinational logic
     * Note: Uses always @(*) for combinational sensitivity
     * 
     * Read-after-Write Behavior:
     * - If same register is written and read in same cycle:
     *   - Write occurs on clock edge (synchronous)
     *   - Read sees OLD value (before write) in same cycle
     *   - Read sees NEW value in next cycle
     */
    always @(*) begin
        rdata0 = registers[raddr0];  // Read port 0: output register[raddr0]
        rdata1 = registers[raddr1];  // Read port 1: output register[raddr1]
    end

endmodule
