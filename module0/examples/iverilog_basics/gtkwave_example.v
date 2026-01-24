/**
 * GTKWave Usage Example for iverilog
 * 
 * This testbench demonstrates:
 * - VCD file generation
 * - Multiple signal types (clock, data, control)
 * - Signal transitions for waveform analysis
 * - GTKWave viewing workflow
 * 
 * Usage:
 *   iverilog -o gtkwave_example gtkwave_example.v ../../dut/simple_gates/and_gate.v
 *   vvp gtkwave_example
 *   gtkwave gtkwave_example.vcd
 */

`timescale 1ns/1ps

module gtkwave_example;

    // Testbench signals
    reg  clk;
    reg  a, b;
    wire y;
    reg  enable;
    integer counter;

    // Instantiate DUT
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    // Clock generation (10ns period = 50MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence with multiple signal transitions
    initial begin
        $display("========================================");
        $display("GTKWave Example Testbench");
        $display("========================================");
        $display("This testbench generates a VCD file for GTKWave analysis.");
        $display("After simulation, view the waveform with: gtkwave gtkwave_example.vcd");
        $display("");
        
        // Initialize signals
        a = 0;
        b = 0;
        enable = 0;
        counter = 0;
        
        // Wait a few clock cycles
        #20;
        
        $display("Starting test sequence at time %0t", $time);
        
        // Test sequence with various signal combinations
        // This creates interesting waveforms to analyze
        
        // Phase 1: Basic operations
        enable = 1;
        a = 0; b = 0;
        #20;
        $display("Time %0t: a=%b, b=%b, y=%b", $time, a, b, y);
        
        a = 0; b = 1;
        #20;
        $display("Time %0t: a=%b, b=%b, y=%b", $time, a, b, y);
        
        a = 1; b = 0;
        #20;
        $display("Time %0t: a=%b, b=%b, y=%b", $time, a, b, y);
        
        a = 1; b = 1;
        #20;
        $display("Time %0t: a=%b, b=%b, y=%b", $time, a, b, y);
        
        // Phase 2: Rapid transitions
        enable = 0;
        #10;
        enable = 1;
        #10;
        
        // Phase 3: Counter demonstration
        for (counter = 0; counter < 8; counter = counter + 1) begin
            a = counter[0];  // LSB of counter
            b = counter[1];  // Second bit of counter
            #20;
            $display("Time %0t: counter=%0d, a=%b, b=%b, y=%b", 
                     $time, counter, a, b, y);
        end
        
        // Phase 4: Final state
        enable = 0;
        a = 0;
        b = 0;
        #20;
        
        $display("");
        $display("========================================");
        $display("Test sequence complete!");
        $display("VCD file generated: gtkwave_example.vcd");
        $display("View with: gtkwave gtkwave_example.vcd");
        $display("========================================");
        #10;
        $finish;
    end

    // Generate VCD file for GTKWave
    initial begin
        $dumpfile("gtkwave_example.vcd");
        // Dump all signals in this module (level 0 = all signals in module and below)
        $dumpvars(0, gtkwave_example);
        // Also explicitly dump DUT signals to ensure they're captured
        $dumpvars(1, dut);
    end

endmodule
