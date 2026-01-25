/**
 * Counter Testbench
 * 
 * This testbench demonstrates verification of sequential (clocked) logic:
 * - Clock generation with always blocks (essential for sequential logic)
 * - Reset sequences (synchronous reset patterns)
 * - Enable signal control (testing enable/disable functionality)
 * - Sequential logic testing (state machine verification)
 * - Timing verification (ensuring changes occur on clock edges)
 * 
 * Verification Methodology Context:
 * - Sequential logic requires different testbench patterns than combinational
 * - Clock generation is fundamental - all sequential logic needs a clock
 * - Reset sequences are critical - must verify reset functionality
 * - In UVM, clock generation is handled by clocking blocks, and reset sequences
 *   are implemented as UVM sequences
 * - See: https://github.com/universal-verification-methodology/core for
 *   advanced clocking and sequence patterns
 * 
 * Key Differences from Combinational Testbenches:
 * - Must generate clock signal (sequential logic is clocked)
 * - Must wait for clock edges (state changes occur on clock edges)
 * - Must test reset sequences (critical for sequential logic)
 * - Timing is important (verify changes occur at correct times)
 * 
 * Usage:
 *   iverilog -o counter_test counter_test.v ../../dut/counters/counter_4bit.v
 *   vvp counter_test
 *   gtkwave counter_test.vcd  # View waveforms to see clock and state changes
 */

`timescale 1ns/1ps  // Time unit: 1ns, precision: 1ps

module counter_test;

    // ========================================================================
    // Testbench Signal Declarations
    // ========================================================================
    
    reg       clk;        // Clock signal (drives DUT clock input)
    reg       rst_n;      // Active-low reset (drives DUT reset input)
    reg       en;         // Enable signal (drives DUT enable input)
    wire [3:0] count;     // Counter output (observes DUT output)

    // ========================================================================
    // DUT (Design Under Test) Instantiation
    // ========================================================================
    
    counter_4bit dut (
        .clk(clk),      // Connect clock to DUT
        .rst_n(rst_n),  // Connect reset to DUT
        .en(en),        // Connect enable to DUT
        .count(count)   // Observe counter output
    );

    // ========================================================================
    // Clock Generation
    // ========================================================================
    // This is ESSENTIAL for sequential logic testbenches.
    // The counter updates on the positive edge of clk, so we must generate
    // a clock signal.
    // 
    // Clock Pattern:
    // - Period: 20ns (10ns low, 10ns high = 50MHz)
    // - Runs continuously throughout simulation
    // - Uses always block (not initial) because it runs forever
    // 
    // Timing:
    // - Time 0: clk = 0
    // - Time 10ns: clk = 1 (rising edge)
    // - Time 20ns: clk = 0 (falling edge)
    // - Time 30ns: clk = 1 (rising edge) - counter increments here
    // - Pattern repeats...
    // 
    // In UVM: Clock generation is typically handled by clocking blocks
    // or virtual interfaces, but understanding this pattern is fundamental.
    
    always begin
        clk = 0;     // Clock low
        #10;         // Wait 10ns (half period)
        clk = 1;     // Clock high (rising edge - counter updates here)
        #10;         // Wait 10ns (half period)
        // Loop forever (creates continuous clock)
    end

    // ========================================================================
    // Main Test Sequence
    // ========================================================================
    // Tests sequential logic behavior:
    // 1. Reset functionality (verify counter resets to 0)
    // 2. Enable functionality (verify counter increments when enabled)
    // 3. Disable functionality (verify counter holds value when disabled)
    // 4. Re-enable (verify counter resumes counting)
    // 5. Reset again (verify reset works after counting)
    // 
    // Important: For sequential logic, we must wait for clock edges.
    // State changes occur on clock edges, not immediately like combinational logic.
    
    initial begin
        $display("========================================");
        $display("4-bit Counter Testbench");
        $display("========================================");
        
        // ====================================================================
        // Initialization
        // ====================================================================
        // Start with reset asserted and enable deasserted
        // This ensures we start from a known state
        rst_n = 0;  // Assert reset (active low, so 0 = reset)
        en = 0;     // Disable counting
        #25;        // Wait for clock edge (ensures reset is applied)
        
        // ====================================================================
        // Test 1: Reset Functionality
        // ====================================================================
        // Verify that when reset is asserted, counter is 0
        // This is a critical test - reset must work correctly
        $display("\nTest 1: Reset (rst_n=0)");
        rst_n = 0;  // Keep reset asserted
        en = 0;     // Keep enable deasserted
        #30;        // Wait for multiple clock edges (reset should hold count at 0)
        $display("Time %0t: count = %0d (expected 0)", $time, count);
        
        // Self-checking: Verify reset works
        if (count !== 4'b0000) begin
            $error("Reset failed: count should be 0, but got %0d", count);
        end
        
        // ====================================================================
        // Test 2: Enable Counting
        // ====================================================================
        // Release reset and enable counting
        // Counter should increment on each clock edge
        $display("\nTest 2: Enable counting (rst_n=1, en=1)");
        rst_n = 1;  // Release reset (active low, so 1 = normal operation)
        en = 1;     // Enable counting
        #100;       // Wait for 5 clock cycles (20ns period * 5 = 100ns)
        // Counter should increment: 0 -> 1 -> 2 -> 3 -> 4 -> 5
        $display("Time %0t: count = %0d (expected ~5 after 5 clock cycles)", $time, count);
        // Note: Exact value depends on when reset was released relative to clock edge
        
        // ====================================================================
        // Test 3: Disable Counting
        // ====================================================================
        // Disable counting - counter should hold its current value
        // This verifies the enable functionality
        $display("\nTest 3: Disable counting (en=0)");
        en = 0;     // Disable counting
        #50;        // Wait for multiple clock cycles
        $display("Time %0t: count = %0d (should hold value, not increment)", $time, count);
        // Counter should NOT increment while en=0
        
        // ====================================================================
        // Test 4: Re-enable Counting
        // ====================================================================
        // Re-enable counting - counter should resume incrementing
        $display("\nTest 4: Re-enable counting");
        en = 1;     // Re-enable counting
        #100;       // Wait for more clock cycles
        $display("Time %0t: count = %0d (should continue incrementing)", $time, count);
        
        // ====================================================================
        // Test 5: Reset Again
        // ====================================================================
        // Assert reset again - verify reset works after counting
        // This tests that reset can be applied at any time
        $display("\nTest 5: Reset again");
        rst_n = 0;  // Assert reset
        #30;        // Wait for clock edges (reset should take effect)
        $display("Time %0t: count = %0d (expected 0)", $time, count);
        
        // Self-checking: Verify reset works
        if (count !== 4'b0000) begin
            $error("Reset failed: count should be 0, but got %0d", count);
        end
        
        // Test summary
        $display("\n========================================");
        $display("All tests completed!");
        $display("========================================");
        $display("Note: View waveforms with: gtkwave counter_test.vcd");
        $display("========================================");
        #20;        // Final delay
        $finish;    // Terminate simulation
    end

    // ========================================================================
    // Waveform Generation (VCD File)
    // ========================================================================
    // VCD files are especially useful for sequential logic because you can
    // see the clock edges and state transitions clearly.
    // 
    // In GTKWave, you can:
    // - See clock signal transitions
    // - See counter increments on clock edges
    // - Verify reset and enable timing
    // - Debug timing issues
    
    initial begin
        $dumpfile("counter_test.vcd");        // Output VCD filename
        $dumpvars(0, counter_test);           // Dump all signals (level 0 = all hierarchy)
    end

endmodule
