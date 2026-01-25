/**
 * Register File Verilog Testbench (iverilog)
 * 
 * This testbench demonstrates modular testbench architecture with separation
 * of concerns: stimulus generation, monitoring, and checking.
 * 
 * Key Concepts:
 * - Modular testbench organization
 * - Clock and reset generation
 * - Write/read operations
 * - Result checking
 * 
 * Usage:
 *   make register_file_test
 *   or
 *   iverilog -o register_file_test register_file_test.v ../../../module4/dut/registers/register_file.v
 *   vvp register_file_test
 */

`timescale 1ns/1ps

module register_file_test;

    // Signal declarations
    reg        clk;
    reg        rst_n;
    reg        we;
    reg [1:0]  waddr;
    reg [7:0]  wdata;
    reg [1:0]  raddr0;
    reg [1:0]  raddr1;
    wire [7:0] rdata0;
    wire [7:0] rdata1;

    // DUT instantiation
    register_file dut (
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr0(raddr0),
        .raddr1(raddr1),
        .rdata0(rdata0),
        .rdata1(rdata1)
    );

    // Clock generation (50MHz = 20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test sequence
    initial begin
        $display("========================================");
        $display("Register File Verilog Testbench (iverilog)");
        $display("========================================");
        
        // Initialize signals
        rst_n = 0;
        we = 0;
        waddr = 0;
        wdata = 0;
        raddr0 = 0;
        raddr1 = 0;
        #25;  // Hold reset
        
        // Release reset
        rst_n = 1;
        #20;  // Wait one clock cycle
        
        // Write to register 0
        $display("\nTest 1: Write 0xAA to register 0");
        we = 1;
        waddr = 0;
        wdata = 8'hAA;
        #20;
        $display("  Write: addr=%0d, data=0x%02h", waddr, wdata);
        
        // Write to register 1
        $display("\nTest 2: Write 0xBB to register 1");
        waddr = 1;
        wdata = 8'hBB;
        #20;
        $display("  Write: addr=%0d, data=0x%02h", waddr, wdata);
        
        // Write to register 2
        $display("\nTest 3: Write 0xCC to register 2");
        waddr = 2;
        wdata = 8'hCC;
        #20;
        $display("  Write: addr=%0d, data=0x%02h", waddr, wdata);
        
        // Read from registers 0 and 1
        $display("\nTest 4: Read from registers 0 and 1");
        we = 0;
        raddr0 = 0;
        raddr1 = 1;
        #20;
        $display("  Read: addr0=%0d, data0=0x%02h (expected 0xAA) %s", 
                 raddr0, rdata0, (rdata0 == 8'hAA) ? "[PASS]" : "[FAIL]");
        $display("  Read: addr1=%0d, data1=0x%02h (expected 0xBB) %s", 
                 raddr1, rdata1, (rdata1 == 8'hBB) ? "[PASS]" : "[FAIL]");
        if (rdata0 !== 8'hAA) $error("Read failed: Expected 0xAA, got 0x%02h", rdata0);
        if (rdata1 !== 8'hBB) $error("Read failed: Expected 0xBB, got 0x%02h", rdata1);
        
        // Read from registers 2 and 3
        $display("\nTest 5: Read from registers 2 and 3");
        raddr0 = 2;
        raddr1 = 3;
        #20;
        $display("  Read: addr0=%0d, data0=0x%02h (expected 0xCC) %s", 
                 raddr0, rdata0, (rdata0 == 8'hCC) ? "[PASS]" : "[FAIL]");
        $display("  Read: addr1=%0d, data1=0x%02h (expected 0x00) %s", 
                 raddr1, rdata1, (rdata1 == 8'h00) ? "[PASS]" : "[FAIL]");
        if (rdata0 !== 8'hCC) $error("Read failed: Expected 0xCC, got 0x%02h", rdata0);
        if (rdata1 !== 8'h00) $error("Read failed: Expected 0x00, got 0x%02h", rdata1);
        
        $display("\n========================================");
        $display("All tests completed!");
        $display("========================================");
        #100;
        $finish;
    end

    // Waveform generation
    initial begin
        $dumpfile("register_file_test.vcd");
        $dumpvars(0, register_file_test);
    end

endmodule
