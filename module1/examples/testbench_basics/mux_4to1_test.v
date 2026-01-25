/**
 * 4-to-1 Multiplexer Testbench
 * 
 * This testbench demonstrates fundamental verification concepts for combinational logic:
 * - Module-based testbench structure (foundation for all testbenches)
 * - Initial blocks for test sequences (stimulus generation)
 * - Always blocks for clock generation (for demonstration, not needed for combinational)
 * - Signal access and monitoring (observing DUT behavior)
 * - System tasks: $display, $monitor, $strobe (different output timing)
 * - Self-checking testbench (automatic pass/fail detection)
 * 
 * Verification Methodology Context:
 * - This demonstrates basic testbench patterns that form the foundation of UVM
 * - In UVM, these concepts evolve into: sequences, drivers, monitors, scoreboards
 * - The stimulus generation here is similar to UVM sequences
 * - The checking here is similar to UVM scoreboard functionality
 * - See: https://github.com/universal-verification-methodology/core for advanced patterns
 * 
 * Testbench Structure (UVM Analogy):
 * - DUT Instantiation → UVM Environment (contains DUT)
 * - Stimulus Generation → UVM Sequences (generate transactions)
 * - Response Checking → UVM Scoreboard (verify correctness)
 * - Monitoring → UVM Monitors (observe DUT behavior)
 * 
 * Usage:
 *   iverilog -o mux_4to1_test mux_4to1_test.v ../../dut/multiplexers/mux_4to1.v
 *   vvp mux_4to1_test
 *   gtkwave mux_4to1_test.vcd  # View waveforms
 */

`timescale 1ns/1ps  // Time unit: 1ns, precision: 1ps

module mux_4to1_test;

    // ========================================================================
    // Testbench Signal Declarations
    // ========================================================================
    // These signals connect to the DUT and are controlled by the testbench
    
    reg [1:0] sel;        // Select signal (2-bit, drives DUT input)
    reg       in0, in1, in2, in3;  // Input signals (drive DUT inputs)
    wire      out;        // Output signal (observes DUT output, wire because it's driven by DUT)
    reg       clk;        // Clock signal (for demonstration, not needed for combinational logic)

    // ========================================================================
    // DUT (Design Under Test) Instantiation
    // ========================================================================
    // This is where we instantiate the module we want to test.
    // In UVM, this would be part of the test environment.
    
    mux_4to1 dut (
        .sel(sel),   // Connect testbench signal to DUT port
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)    // DUT drives this signal, testbench observes it
    );

    // ========================================================================
    // Clock Generation (for demonstration purposes)
    // ========================================================================
    // Note: This is NOT needed for combinational logic like a multiplexer.
    // We include it here to demonstrate clock generation patterns that
    // will be essential for sequential logic testbenches.
    // 
    // Clock Pattern:
    // - Period: 10ns (5ns low, 5ns high = 50MHz)
    // - Runs forever until simulation ends
    
    initial begin
        clk = 0;              // Initialize clock to 0
        forever #5 clk = ~clk;  // Toggle every 5ns (creates 10ns period)
    end

    // ========================================================================
    // Continuous Signal Monitoring
    // ========================================================================
    // $monitor automatically prints whenever any monitored signal changes.
    // This is useful for debugging and observing DUT behavior.
    // 
    // Key Points:
    // - Only ONE $monitor can be active at a time (last one wins)
    // - Prints automatically on signal changes (no need to call repeatedly)
    // - Useful for continuous observation during simulation
    // 
    // In UVM: This functionality is provided by monitors that observe
    // transactions and send them to scoreboards for checking.
    
    initial begin
        // Monitor all relevant signals - prints automatically on changes
        $monitor("Time %0t: sel=%b, in0=%b, in1=%b, in2=%b, in3=%b, out=%b",
                 $time, sel, in0, in1, in2, in3, out);
    end

    // ========================================================================
    // Main Test Sequence
    // ========================================================================
    // This is the heart of the testbench - it generates stimulus and checks results.
    // 
    // Test Strategy:
    // - Exhaustive testing: Test all 4 select combinations
    // - For each select value, set the corresponding input high, others low
    // - Verify that output matches the selected input
    // 
    // This pattern (stimulus → wait → check) is fundamental to all verification:
    // 1. Apply stimulus (set inputs)
    // 2. Wait for propagation (combinational logic settles immediately, but we wait for clarity)
    // 3. Check result (compare output to expected value)
    // 4. Report pass/fail
    // 
    // In UVM: This evolves into:
    // - Sequences generate transactions (stimulus)
    // - Drivers apply transactions to DUT
    // - Monitors capture DUT responses
    // - Scoreboards compare expected vs. actual
    
    initial begin
        // Test header
        $display("========================================");
        $display("4-to-1 Multiplexer Testbench");
        $display("========================================");
        
        // Initialize all inputs to known values
        // Good practice: Always initialize signals before testing
        sel = 2'b00;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        #10;  // Wait for signals to settle (combinational logic settles immediately, but delay helps visualization)
        
        // Print test table header
        $display("\nTesting all select combinations:");
        $display("sel | in0 | in1 | in2 | in3 | out | Expected");
        $display("----|-----|-----|-----|-----|-----|----------");
        
        // ====================================================================
        // Test Case 1: Select in0 (sel=00)
        // ====================================================================
        // Strategy: Set in0=1, all others=0, sel=00, verify out=in0
        sel = 2'b00; 
        in0 = 1'b1;  // Set input 0 high
        in1 = 1'b0; 
        in2 = 1'b0; 
        in3 = 1'b0;
        #5;  // Wait for combinational logic to propagate (though it's instant)
        
        // $strobe prints at the END of the current time step (after all assignments)
        // This ensures we see the final, stable values
        // Difference: $display = immediate, $strobe = end of time step
        $strobe(" %b  |  %b  |  %b  |  %b  |  %b  |  %b  |   in0", 
                sel, in0, in1, in2, in3, out);
        
        // Self-checking: Automatically verify correctness
        // !== is case equality (includes X and Z states)
        if (out !== in0) begin
            $error("Test failed: sel=00 should select in0, but out=%b (expected %b)", out, in0);
        end
        
        // ====================================================================
        // Test Case 2: Select in1 (sel=01)
        // ====================================================================
        sel = 2'b01; 
        in0 = 1'b0; 
        in1 = 1'b1;  // Set input 1 high
        in2 = 1'b0; 
        in3 = 1'b0;
        #5;
        $strobe(" %b  |  %b  |  %b  |  %b  |  %b  |  %b  |   in1", 
                sel, in0, in1, in2, in3, out);
        if (out !== in1) begin
            $error("Test failed: sel=01 should select in1, but out=%b (expected %b)", out, in1);
        end
        
        // ====================================================================
        // Test Case 3: Select in2 (sel=10)
        // ====================================================================
        sel = 2'b10; 
        in0 = 1'b0; 
        in1 = 1'b0; 
        in2 = 1'b1;  // Set input 2 high
        in3 = 1'b0;
        #5;
        $strobe(" %b  |  %b  |  %b  |  %b  |  %b  |  %b  |   in2", 
                sel, in0, in1, in2, in3, out);
        if (out !== in2) begin
            $error("Test failed: sel=10 should select in2, but out=%b (expected %b)", out, in2);
        end
        
        // ====================================================================
        // Test Case 4: Select in3 (sel=11)
        // ====================================================================
        sel = 2'b11; 
        in0 = 1'b0; 
        in1 = 1'b0; 
        in2 = 1'b0; 
        in3 = 1'b1;  // Set input 3 high
        #5;
        $strobe(" %b  |  %b  |  %b  |  %b  |  %b  |  %b  |   in3", 
                sel, in0, in1, in2, in3, out);
        if (out !== in3) begin
            $error("Test failed: sel=11 should select in3, but out=%b (expected %b)", out, in3);
        end
        
        // Test summary
        $display("\n========================================");
        $display("All tests passed!");
        $display("========================================");
        #10;  // Final delay before ending
        $finish;  // Terminate simulation
    end

    // ========================================================================
    // Waveform Generation (VCD File)
    // ========================================================================
    // VCD (Value Change Dump) files contain signal waveforms for debugging.
    // These can be viewed in GTKWave or other waveform viewers.
    // 
    // $dumpfile: Specifies the output filename
    // $dumpvars: Specifies which signals to dump
    //   - Level 0: Dump all signals in this module and all submodules
    //   - Level 1: Dump only signals in this module (not submodules)
    //   - Level 2+: Dump only signals at specified hierarchy level
    // 
    // In UVM: Waveform generation is typically handled by the testbench
    // infrastructure, but understanding VCD generation is still important.
    
    initial begin
        $dumpfile("mux_4to1_test.vcd");           // Output VCD filename
        $dumpvars(0, mux_4to1_test);              // Dump all signals (level 0 = all hierarchy)
    end

endmodule
