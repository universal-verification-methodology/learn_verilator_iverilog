/**
 * Waveform Generation Example
 * 
 * This example demonstrates waveform generation for debugging and analysis:
 * - VCD (Value Change Dump) file generation ($dumpfile, $dumpvars)
 * - Signal selection for waveforms (choosing which signals to dump)
 * - Different dump levels (hierarchy control)
 * - GTKWave compatibility (viewing waveforms)
 * 
 * Verification Context:
 * - Waveforms are essential for debugging testbenches
 * - VCD files capture signal transitions over time
 * - Useful for verifying timing, state transitions, and debugging failures
 * - In UVM, waveform generation is typically handled by the testbench infrastructure,
 *   but understanding VCD generation is still important
 * 
 * Usage:
 *   iverilog -o waveform_example waveform_example.v ../../dut/multiplexers/mux_4to1.v
 *   vvp waveform_example
 *   gtkwave waveform_example.vcd  # View waveforms
 */

`timescale 1ns/1ps

module waveform_example;

    // ========================================================================
    // Testbench Signal Declarations
    // ========================================================================
    
    reg [1:0] sel;        // Select signal
    reg       in0, in1, in2, in3;  // Input signals
    wire      out;        // Output signal
    reg       clk;        // Clock signal (for demonstration)
    integer   i;          // Loop counter

    // ========================================================================
    // DUT (Design Under Test) Instantiation
    // ========================================================================
    
    mux_4to1 dut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );

    // ========================================================================
    // Clock Generation
    // ========================================================================
    // Clock is included here to create interesting signal transitions
    // for waveform viewing, even though it's not needed for combinational logic
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 20ns period (50MHz)
    end

    // ========================================================================
    // Test Sequence with Signal Transitions
    // ========================================================================
    // This sequence creates various signal transitions to make the waveform
    // interesting and useful for analysis. The goal is to generate a waveform
    // that clearly shows the multiplexer's behavior.
    
    initial begin
        $display("========================================");
        $display("Waveform Generation Example");
        $display("========================================");
        
        // Initialize all signals to known values
        sel = 2'b00;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        #20;  // Wait for initial state to be captured in waveform
        
        // Create signal transitions for each select value
        // This loop creates a pattern that's easy to analyze in the waveform
        for (i = 0; i < 4; i = i + 1) begin
            // Set select to current loop index
            sel = i[1:0];
            
            // Set the corresponding input high, all others low
            // This creates a clear pattern: when sel=i, in[i] is high
            in0 = (i == 0) ? 1'b1 : 1'b0;
            in1 = (i == 1) ? 1'b1 : 1'b0;
            in2 = (i == 2) ? 1'b1 : 1'b0;
            in3 = (i == 3) ? 1'b1 : 1'b0;
            
            #40;  // Wait long enough to see transitions clearly in waveform
            $display("Time %0t: sel=%b, out=%b", $time, sel, out);
        end
        
        $display("========================================");
        $display("VCD file generated: waveform_example.vcd");
        $display("View with: gtkwave waveform_example.vcd");
        $display("========================================");
        $display("In GTKWave, you can:");
        $display("  - Navigate signals in the hierarchy");
        $display("  - Zoom in/out to see timing details");
        $display("  - Add signals to the waveform view");
        $display("  - Measure timing between signals");
        $display("========================================");
        #20;
        $finish;
    end

    // ========================================================================
    // VCD File Generation
    // ========================================================================
    // VCD (Value Change Dump) files contain signal waveforms.
    // They can be viewed in GTKWave or other waveform viewers.
    // 
    // $dumpfile: Specifies the output filename
    // $dumpvars: Specifies which signals to dump
    //   - Level 0: Dump all signals in this module AND all submodules (full hierarchy)
    //   - Level 1: Dump only signals in this module (not submodules)
    //   - Level 2+: Dump only signals at specified hierarchy level
    // 
    // Multiple $dumpvars calls can be used to selectively dump signals:
    //   - $dumpvars(0, waveform_example) dumps everything
    //   - $dumpvars(1, dut) explicitly dumps DUT signals (redundant with level 0, but shown for clarity)
    // 
    // Tips:
    // - Use level 0 for small designs (dumps everything)
    // - Use level 1+ for large designs (selective dumping saves file size)
    // - VCD files can get large for long simulations - be selective if needed
    
    initial begin
        $dumpfile("waveform_example.vcd");        // Output VCD filename
        // Level 0: Dump all signals in this module and all submodules
        $dumpvars(0, waveform_example);
        // Level 1: Also explicitly dump DUT signals (redundant with level 0, but shown for example)
        $dumpvars(1, dut);
    end

endmodule
