/**
 * Waveform Generation Example
 * 
 * This example demonstrates:
 * - VCD file generation ($dumpfile, $dumpvars)
 * - Signal selection for waveforms
 * - Different dump levels
 * - GTKWave compatibility
 * 
 * Usage:
 *   iverilog -o waveform_example waveform_example.v ../../dut/multiplexers/mux_4to1.v
 *   vvp waveform_example
 *   gtkwave waveform_example.vcd
 */

`timescale 1ns/1ps

module waveform_example;

    reg [1:0] sel;
    reg       in0, in1, in2, in3;
    wire      out;
    reg       clk;
    integer   i;

    // Instantiate DUT
    mux_4to1 dut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test sequence with interesting signal transitions
    initial begin
        $display("========================================");
        $display("Waveform Generation Example");
        $display("========================================");
        
        // Initialize
        sel = 2'b00;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        #20;
        
        // Create various signal transitions
        for (i = 0; i < 4; i = i + 1) begin
            sel = i[1:0];
            in0 = (i == 0) ? 1'b1 : 1'b0;
            in1 = (i == 1) ? 1'b1 : 1'b0;
            in2 = (i == 2) ? 1'b1 : 1'b0;
            in3 = (i == 3) ? 1'b1 : 1'b0;
            #40;
            $display("Time %0t: sel=%b, out=%b", $time, sel, out);
        end
        
        $display("========================================");
        $display("VCD file generated: waveform_example.vcd");
        $display("View with: gtkwave waveform_example.vcd");
        $display("========================================");
        #20;
        $finish;
    end

    // VCD file generation with different dump levels
    initial begin
        $dumpfile("waveform_example.vcd");
        // Level 0: Dump all signals in this module and all submodules
        $dumpvars(0, waveform_example);
        // Level 1: Also explicitly dump DUT signals
        $dumpvars(1, dut);
    end

endmodule
