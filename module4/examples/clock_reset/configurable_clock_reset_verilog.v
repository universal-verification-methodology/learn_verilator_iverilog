/**
 * Configurable Clock and Reset Generation - Verilog
 * 
 * This example demonstrates professional clock and reset generation patterns
 * commonly used in verification testbenches. It shows how to create
 * configurable, reusable clock and reset generators.
 * 
 * Learning Objectives:
 * - Understand clock generation patterns in Verilog
 * - Learn configurable clock period implementation
 * - Master multiple clock domain handling
 * - Understand reset sequence timing
 * - Learn clock and reset coordination
 * 
 * UVM Pattern Inspiration:
 * Clock and reset generation is fundamental to all verification environments.
 * In UVM, this is typically handled by:
 * - Clock generators (virtual sequences or clocking blocks)
 * - Reset agents (reset sequences)
 * 
 * This example shows the Verilog equivalent patterns.
 * 
 * Key Concepts:
 * - Parameter-based configuration: Clock periods defined as parameters
 * - Continuous clock generation: Using forever loops
 * - Reset timing: Assert, hold, release sequence
 * - Multiple clocks: Independent clock domains
 * 
 * Compilation and Execution:
 *   iverilog -o configurable_clock_reset configurable_clock_reset_verilog.v
 *   vvp configurable_clock_reset
 *   gtkwave configurable_clock_reset.vcd  # Optional: view waveforms
 * 
 * Usage:
 *   iverilog -o configurable_clock_reset configurable_clock_reset_verilog.v
 *   vvp configurable_clock_reset
 */

`timescale 1ns/1ps

module configurable_clock_reset_verilog;

    // ========================================
    // Configuration Parameters
    // ========================================
    /**
     * Clock Period Parameters
     * 
     * These parameters define the clock periods in nanoseconds.
     * They can be overridden during instantiation for different test scenarios.
     * 
     * Frequency calculation: freq_MHz = 1000 / period_ns
     */
    parameter CLK_PERIOD_1 = 20;  // 20ns period = 50MHz
    parameter CLK_PERIOD_2 = 40;  // 40ns period = 25MHz
    parameter RST_DURATION = 100; // Reset duration in ns (5 clock cycles at 50MHz)
    
    // ========================================
    // Signal Declarations
    // ========================================
    /**
     * Clock Signals
     * 
     * Two independent clock signals for multi-clock domain testing.
     * Each clock has its own period and runs independently.
     */
    reg clk1;  // Clock 1 (50MHz by default)
    reg clk2;  // Clock 2 (25MHz by default)
    
    /**
     * Reset Signal
     * 
     * Active-low reset signal (rst_n = 0 means reset active).
     * Synchronous reset (asserted/released on clock edges).
     */
    reg rst_n;
    
    // ========================================
    // Clock Generation
    // ========================================
    /**
     * Clock 1 Generator
     * 
     * Generates a continuous clock signal with configurable period.
     * 
     * Clock Generation Pattern:
     * 1. Initialize clock to 0
     * 2. Forever loop: toggle every half period
     * 3. This creates a 50% duty cycle clock
     * 
     * Period = CLK_PERIOD_1
     * High time = CLK_PERIOD_1/2
     * Low time = CLK_PERIOD_1/2
     * Frequency = 1000 / CLK_PERIOD_1 MHz
     */
    initial begin
        clk1 = 0;                              // Start at logic 0
        forever #(CLK_PERIOD_1/2) clk1 = ~clk1; // Toggle every half period
    end
    
    /**
     * Clock 2 Generator
     * 
     * Generates a second independent clock signal.
     * This demonstrates multiple clock domain handling.
     * 
     * Clock 2 runs at a different frequency than Clock 1,
     * simulating designs with multiple clock domains.
     */
    initial begin
        clk2 = 0;                              // Start at logic 0
        forever #(CLK_PERIOD_2/2) clk2 = ~clk2; // Toggle every half period
    end
    
    // ========================================
    // Reset Generation
    // ========================================
    /**
     * Reset Sequence Generator
     * 
     * Implements a standard reset sequence:
     * 1. Assert reset (rst_n = 0)
     * 2. Hold reset for specified duration
     * 3. Release reset (rst_n = 1)
     * 4. Continue simulation
     * 
     * Reset Timing:
     * - Asserted at time 0
     * - Held for RST_DURATION nanoseconds
     * - Released and remains inactive
     * 
     * This pattern ensures the design is properly reset before
     * normal operation begins.
     */
    initial begin
        // Print configuration information
        $display("========================================");
        $display("Configurable Clock and Reset Example");
        $display("========================================");
        $display("Clock 1 period: %0d ns (%.1f MHz)", CLK_PERIOD_1, 1000.0/CLK_PERIOD_1);
        $display("Clock 2 period: %0d ns (%.1f MHz)", CLK_PERIOD_2, 1000.0/CLK_PERIOD_2);
        $display("Reset duration: %0d ns", RST_DURATION);
        $display("========================================");
        
        // Phase 1: Assert Reset
        rst_n = 0;  // Assert reset (active low)
        $display("Time %0t: Reset asserted", $time);
        
        // Phase 2: Hold Reset
        // Hold reset for specified duration to ensure proper reset
        #RST_DURATION;
        
        // Phase 3: Release Reset
        rst_n = 1;  // Release reset
        $display("Time %0t: Reset released", $time);
        
        // Phase 4: Continue Simulation
        // Run simulation for additional time to observe behavior
        #500;  // Run for 500ns after reset release
        
        // Print completion message
        $display("========================================");
        $display("Simulation completed");
        $display("========================================");
        $finish;  // End simulation
    end
    
    // ========================================
    // Clock Edge Monitoring
    // ========================================
    /**
     * Clock 1 Edge Monitor
     * 
     * Monitors positive edges of Clock 1 for debugging and verification.
     * This helps verify that the clock is running correctly.
     */
    always @(posedge clk1) begin
        $display("Time %0t: Clock 1 posedge", $time);
    end
    
    /**
     * Clock 2 Edge Monitor
     * 
     * Monitors positive edges of Clock 2 for debugging and verification.
     * This helps verify that both clocks are running independently.
     */
    always @(posedge clk2) begin
        $display("Time %0t: Clock 2 posedge", $time);
    end
    
    // ========================================
    // Waveform Generation
    // ========================================
    /**
     * VCD File Generation
     * 
     * Creates a Value Change Dump (VCD) file for waveform analysis.
     * This file can be viewed in GTKWave or other waveform viewers.
     * 
     * The VCD file will contain:
     * - Clock 1 and Clock 2 waveforms
     * - Reset signal waveform
     * - Timing relationships between clocks and reset
     */
    initial begin
        $dumpfile("configurable_clock_reset.vcd");
        $dumpvars(0, configurable_clock_reset_verilog);
    end

endmodule
