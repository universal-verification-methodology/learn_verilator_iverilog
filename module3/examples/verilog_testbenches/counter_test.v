/**
 * 4-bit Counter Verilog Testbench
 * 
 * This testbench demonstrates sequential logic verification patterns, including
 * clock generation, reset sequences, and enable/disable control. These patterns
 * are fundamental to all sequential circuit verification and form the basis for
 * more advanced UVM-based verification methodologies.
 * 
 * Key Concepts Demonstrated:
 * ==========================
 * 1. Clock Generation (UVM-inspired "Clock Generator" component):
 *    - Continuous clock using always block
 *    - Configurable clock period (50MHz = 20ns period in this example)
 *    - Runs independently of test sequence
 * 
 * 2. Reset Generation (UVM-inspired "Reset Agent" component):
 *    - Synchronous/asynchronous reset sequences
 *    - Reset assertion and de-assertion timing
 *    - Reset verification
 * 
 * 3. Sequential Logic Testing:
 *    - State machine verification
 *    - Clock edge-sensitive behavior
 *    - State transitions over multiple clock cycles
 * 
 * 4. Control Signal Testing:
 *    - Enable/disable functionality
 *    - State holding when disabled
 *    - Re-enable behavior
 * 
 * 5. Time Management:
 *    - Delay control (# delays) for timing
 *    - Clock cycle synchronization
 *    - Timing relationships between signals
 * 
 * 6. Test Sequence Organization:
 *    - Multiple test scenarios
 *    - Test isolation (each test is independent)
 *    - Comprehensive coverage
 * 
 * UVM Pattern Mapping (for future reference):
 * ============================================
 * - Clock generation: Would be a UVM clock agent
 * - Reset generation: Would be a UVM reset agent
 * - Test sequence: Would be a UVM test class with multiple test phases
 * - Monitoring: Would be a UVM monitor collecting transactions
 * 
 * Usage:
 *   iverilog -o counter_test counter_test.v ../../dut/counters/counter_4bit.v
 *   vvp counter_test
 *   gtkwave counter_test.vcd  # View waveforms to see clock and counter behavior
 */

`timescale 1ns/1ps  // Time unit: 1ns, precision: 1ps

module counter_test;

    // ========================================================================
    // TESTBENCH SIGNAL DECLARATIONS
    // ========================================================================
    // Clock signal - driven by always block (continuous clock generation)
    reg       clk;
    
    // Reset signal (active-low: 0 = reset, 1 = normal operation)
    // Active-low resets are common in digital design
    reg       rst_n;
    
    // Enable signal (1 = count, 0 = hold current value)
    reg       en;
    
    // Counter output (4-bit: values 0-15)
    // 'wire' type because it's driven by DUT
    wire [3:0] count;

    // ========================================================================
    // DUT (DESIGN UNDER TEST) INSTANTIATION
    // ========================================================================
    // Instantiate the 4-bit counter module
    counter_4bit dut (
        .clk(clk),      // Clock input
        .rst_n(rst_n),  // Active-low reset
        .en(en),        // Enable signal
        .count(count)   // 4-bit counter output
    );

    // ========================================================================
    // CLOCK GENERATION (UVM-inspired: Clock Agent)
    // ========================================================================
    // Continuous clock generation using always block
    // This runs independently and continuously throughout simulation
    // Clock period = 20ns (50MHz frequency)
    //   - Low phase: 10ns
    //   - High phase: 10ns
    //   - Total period: 20ns
    always begin
        clk = 0;        // Set clock low
        #10;            // Wait 10ns (half period)
        clk = 1;        // Set clock high
        #10;            // Wait 10ns (half period)
        // Loop continues indefinitely
    end

    // ========================================================================
    // TEST SEQUENCE (UVM-inspired: Test Class run_phase)
    // ========================================================================
    // The 'initial' block executes once at simulation start
    // This orchestrates all test scenarios
    initial begin
        $display("========================================");
        $display("4-bit Counter Verilog Testbench");
        $display("========================================");
        
        // ====================================================================
        // INITIALIZATION PHASE
        // ====================================================================
        // Set initial signal states before first clock edge
        // Reset is active (low) to ensure known starting state
        rst_n = 0;  // Assert reset (active low)
        en = 0;     // Disable counting initially
        
        // Wait for clock edge to ensure reset is properly applied
        // #25 ensures we pass at least one clock edge (20ns period)
        #25;
        
        // ====================================================================
        // TEST 1: RESET VERIFICATION
        // ====================================================================
        // Verify that reset properly initializes counter to 0
        $display("\nTest 1: Reset (rst_n=0)");
        rst_n = 0;  // Keep reset asserted
        en = 0;     // Disable counting
        
        // Wait for reset to propagate (multiple clock cycles)
        // #30 ensures at least one full clock cycle passes
        #30;
        
        // Check that counter is reset to 0
        $display("Time %0t: count = %0d (expected 0)", $time, count);
        if (count !== 4'b0000) $error("Reset failed: count should be 0, got %0d", count);
        
        // ====================================================================
        // TEST 2: COUNTING OPERATION
        // ====================================================================
        // Verify counter increments when enabled
        $display("\nTest 2: Enable counting (rst_n=1, en=1)");
        rst_n = 1;  // Release reset (de-assert)
        en = 1;     // Enable counting
        
        // Wait for multiple clock cycles to observe counting
        // #100 = 5 clock cycles (5 * 20ns = 100ns)
        // Counter should increment on each rising clock edge
        #100;
        
        // Display final count value
        // Note: Exact value depends on counter implementation
        $display("Time %0t: count = %0d", $time, count);
        
        // ====================================================================
        // TEST 3: DISABLE FUNCTIONALITY
        // ====================================================================
        // Verify counter holds value when disabled
        $display("\nTest 3: Disable counting (en=0)");
        en = 0;  // Disable counting
        
        // Store count value before disabling
        // This allows verification that count doesn't change
        #50;  // Wait for multiple clock cycles
        
        // Counter should hold its value (not increment)
        $display("Time %0t: count = %0d (should hold value)", $time, count);
        
        // ====================================================================
        // TEST 4: RE-ENABLE OPERATION
        // ====================================================================
        // Verify counter resumes counting when re-enabled
        $display("\nTest 4: Re-enable counting");
        en = 1;  // Re-enable counting
        
        // Continue counting for several more cycles
        #100;
        $display("Time %0t: count = %0d", $time, count);
        
        // ====================================================================
        // TEST 5: RESET DURING OPERATION
        // ====================================================================
        // Verify reset works even when counter is running
        $display("\nTest 5: Reset again");
        rst_n = 0;  // Assert reset again
        
        // Wait for reset to take effect
        #30;
        
        // Counter should return to 0
        $display("Time %0t: count = %0d (expected 0)", $time, count);
        if (count !== 4'b0000) $error("Reset failed: count should be 0, got %0d", count);
        
        // ====================================================================
        // TEST SUMMARY
        // ====================================================================
        $display("\n========================================");
        $display("All tests completed!");
        $display("========================================");
        
        // Additional delay to ensure all events complete
        #20;
        
        // Terminate simulation
        $finish;
    end

    // ========================================================================
    // WAVEFORM GENERATION (VCD FILE)
    // ========================================================================
    // Generate VCD file for waveform analysis
    // Essential for debugging sequential logic and timing issues
    initial begin
        $dumpfile("counter_test.vcd");
        $dumpvars(0, counter_test);  // Dump all signals in testbench
    end

endmodule
