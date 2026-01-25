/**
 * AND Gate Verilog Testbench
 * 
 * This testbench demonstrates fundamental Verilog testbench concepts and
 * introduces verification patterns inspired by UVM (Universal Verification Methodology).
 * While this is a simple example, it establishes patterns that scale to more
 * complex verification environments.
 * 
 * Key Concepts Demonstrated:
 * ==========================
 * 1. Testbench Architecture:
 *    - Module-based testbench structure (similar to UVM test class)
 *    - Separation of concerns: DUT, testbench signals, test sequence
 * 
 * 2. DUT (Design Under Test) Instantiation:
 *    - Module instantiation with named port connections
 *    - Signal connectivity between testbench and DUT
 * 
 * 3. Stimulus Generation (UVM-inspired "Driver" concept):
 *    - Directed test vectors applied to DUT inputs
 *    - Exhaustive testing of all input combinations (2^2 = 4 test cases)
 *    - Timing control using delay statements (# delays)
 * 
 * 4. Response Monitoring (UVM-inspired "Monitor" concept):
 *    - Real-time output observation using $display
 *    - Signal value capture at specific simulation times
 * 
 * 5. Result Checking (UVM-inspired "Scoreboard" concept):
 *    - Expected vs. actual value comparison
 *    - Pass/fail determination for each test case
 *    - Error reporting using $error system task
 * 
 * 6. Test Reporting:
 *    - Formatted output for readability
 *    - Test summary
 * 
 * 7. Waveform Generation:
 *    - VCD file generation for post-simulation analysis
 *    - Essential for debugging and verification sign-off
 * 
 * UVM Pattern Mapping (for future reference):
 * ============================================
 * - This testbench combines what in UVM would be separate components:
 *   * Driver: Stimulus generation (lines 48-66)
 *   * Monitor: Response capture (lines 43-66)
 *   * Scoreboard: Result checking (lines 45, 52, 59, 66)
 *   * Test: Test sequence orchestration (initial block)
 * 
 * Usage:
 *   iverilog -o and_gate_test and_gate_test.v ../../dut/simple_gates/and_gate.v
 *   vvp and_gate_test
 *   gtkwave and_gate_test.vcd  # View waveforms
 */

`timescale 1ns/1ps  // Time unit: 1ns, precision: 1ps

module and_gate_test;

    // ========================================================================
    // TESTBENCH SIGNAL DECLARATIONS
    // ========================================================================
    // Input signals to DUT (driven by testbench)
    // 'reg' type allows procedural assignment in initial/always blocks
    reg  a, b;
    
    // Output signal from DUT (monitored by testbench)
    // 'wire' type for continuous assignment (driven by DUT)
    wire y;

    // ========================================================================
    // DUT (DESIGN UNDER TEST) INSTANTIATION
    // ========================================================================
    // Instantiate the AND gate module under test
    // Named port connections (.port_name(signal_name)) improve readability
    // and reduce errors compared to positional connections
    and_gate dut (
        .a(a),  // Connect testbench signal 'a' to DUT port 'a'
        .b(b),  // Connect testbench signal 'b' to DUT port 'b'
        .y(y)   // Connect DUT output 'y' to testbench signal 'y'
    );

    // ========================================================================
    // TEST SEQUENCE (UVM-inspired: Test class run_phase equivalent)
    // ========================================================================
    // The 'initial' block executes once at simulation start (time 0)
    // This is where we orchestrate the test sequence
    initial begin
        // Test header for readability
        $display("========================================");
        $display("AND Gate Verilog Testbench");
        $display("========================================");
        
        // Print formatted table header
        // Format: Time | Input a | Input b | Output y | Expected | Result
        $display("Time |  a  |  b  |  y  | Expected | Pass/Fail");
        $display("-----|-----|-----|-----|----------|----------");
        
        // ====================================================================
        // TEST CASE 1: a=0, b=0 -> Expected output: y=0
        // ====================================================================
        // Apply stimulus: Set input values
        a = 0; b = 0;
        
        // Wait for propagation delay (5 time units = 5ns)
        // This allows combinational logic to settle before checking output
        #5;
        
        // Monitor response and check result
        // Format specifiers: %4t (4-char time), %b (binary), %s (string)
        // Case equality (===) checks both value and X/Z states
        $display("%4t |  %b  |  %b  |  %b  |    0     |   %s", 
                 $time, a, b, y, (y === 0) ? "PASS" : "FAIL");
        
        // Assertion: Verify expected output
        // $error provides better error reporting than simple if statement
        if (y !== 0) $error("Test failed: Expected y=0, got y=%b", y);
        
        // ====================================================================
        // TEST CASE 2: a=0, b=1 -> Expected output: y=0
        // ====================================================================
        a = 0; b = 1;
        #5;  // Wait for signal propagation
        $display("%4t |  %b  |  %b  |  %b  |    0     |   %s", 
                 $time, a, b, y, (y === 0) ? "PASS" : "FAIL");
        if (y !== 0) $error("Test failed: Expected y=0, got y=%b", y);
        
        // ====================================================================
        // TEST CASE 3: a=1, b=0 -> Expected output: y=0
        // ====================================================================
        a = 1; b = 0;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    0     |   %s", 
                 $time, a, b, y, (y === 0) ? "PASS" : "FAIL");
        if (y !== 0) $error("Test failed: Expected y=0, got y=%b", y);
        
        // ====================================================================
        // TEST CASE 4: a=1, b=1 -> Expected output: y=1
        // ====================================================================
        // This is the only case where AND gate output is 1
        a = 1; b = 1;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    1     |   %s", 
                 $time, a, b, y, (y === 1) ? "PASS" : "FAIL");
        if (y !== 1) $error("Test failed: Expected y=1, got y=%b", y);
        
        // ====================================================================
        // TEST SUMMARY
        // ====================================================================
        $display("========================================");
        $display("All tests completed!");
        $display("========================================");
        
        // Additional delay before finishing to ensure all events complete
        #10;
        
        // Terminate simulation gracefully
        // $finish ends simulation and returns control to simulator
        $finish;
    end

    // ========================================================================
    // WAVEFORM GENERATION (VCD FILE)
    // ========================================================================
    // VCD (Value Change Dump) files are essential for:
    // - Debugging signal transitions
    // - Timing analysis
    // - Verification sign-off
    // - Post-simulation waveform viewing (GTKWave, etc.)
    initial begin
        // Specify output VCD filename
        $dumpfile("and_gate_test.vcd");
        
        // Dump all variables in this module and below (depth 0 = all levels)
        // Format: $dumpvars(depth, module_instance)
        // Depth 0 means dump all hierarchy levels
        $dumpvars(0, and_gate_test);
    end

endmodule
