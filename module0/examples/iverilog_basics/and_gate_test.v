/**
 * Simple AND Gate Testbench for iverilog
 * 
 * This testbench demonstrates:
 * - DUT (Design Under Test) instantiation
 * - Signal driving (stimulus generation)
 * - Output monitoring and verification
 * - Basic test patterns (exhaustive truth table testing)
 * - VCD waveform file generation for GTKWave
 * - Error checking and reporting
 * 
 * Learning Objectives:
 * - Understand how to instantiate a module (DUT)
 * - Learn signal types: reg (driven in testbench) vs wire (connected to DUT)
 * - Learn how to apply test vectors (stimulus)
 * - Learn how to check outputs (self-checking testbench)
 * - Understand timescale directive
 * - Learn VCD file generation for waveform viewing
 * 
 * Test Strategy:
 * - Exhaustive testing: test all 2^2 = 4 input combinations
 * - Self-checking: compare actual output with expected value
 * - Error reporting: use $error for failed tests
 * 
 * Compilation and Execution:
 *   1. Compile: iverilog -o and_gate_test and_gate_test.v ../dut/simple_gates/and_gate.v
 *      - Compiles both testbench and DUT
 *   2. Run: vvp and_gate_test
 *      - Executes simulation and generates VCD file
 *   3. View waveforms: gtkwave and_gate_test.vcd (optional)
 * 
 * Usage:
 *   iverilog -o and_gate_test and_gate_test.v ../dut/simple_gates/and_gate.v
 *   vvp and_gate_test
 */

/**
 * Timescale directive: sets time unit and precision
 * 
 * Format: `timescale <time_unit>/<time_precision>
 * - time_unit: default unit for delays (#10 means 10ns)
 * - time_precision: smallest time step simulator can handle
 * 
 * Common values:
 * - 1ns/1ps: nanosecond unit, picosecond precision (high precision)
 * - 1ns/1ns: nanosecond unit and precision (standard)
 * - 1ps/1ps: picosecond unit and precision (very high precision)
 */
`timescale 1ns/1ps

module and_gate_test;

    /**
     * Testbench Signal Declarations
     * 
     * Signal Types:
     * - 'reg': Used for signals driven in procedural blocks (initial, always)
     *          In testbench, inputs to DUT are typically 'reg'
     * - 'wire': Used for signals that are connected (not driven procedurally)
     *           DUT outputs are typically 'wire' in testbench
     * 
     * Note: 'reg' doesn't mean register/flip-flop - it's just a signal type
     *       that can be assigned in procedural blocks. Synthesis determines
     *       if it becomes combinational or sequential logic.
     */
    reg  a, b;  // Inputs to DUT - driven by testbench (use 'reg')
    wire y;     // Output from DUT - monitored by testbench (use 'wire')

    /**
     * DUT (Design Under Test) Instantiation
     * 
     * This creates an instance of the and_gate module we want to test.
     * 
     * Syntax: module_name instance_name (port_connections);
     * 
     * Port connections use named association (.port_name(signal_name)):
     * - More readable than positional association
     * - Order doesn't matter
     * - Less error-prone when module ports change
     * 
     * The DUT's ports are connected to testbench signals:
     * - DUT input 'a' connected to testbench signal 'a'
     * - DUT input 'b' connected to testbench signal 'b'
     * - DUT output 'y' connected to testbench signal 'y'
     */
    and_gate dut (
        .a(a),  // Connect DUT port 'a' to testbench signal 'a'
        .b(b),  // Connect DUT port 'b' to testbench signal 'b'
        .y(y)   // Connect DUT port 'y' to testbench signal 'y'
    );

    /**
     * Test Sequence - Main Test Logic
     * 
     * This initial block contains the test stimulus and checking logic.
     * It follows a typical testbench pattern:
     * 1. Initialize signals
     * 2. Apply test vectors (stimulus)
     * 3. Wait for propagation (#delay)
     * 4. Check outputs (verification)
     * 5. Report results
     * 6. Finish simulation
     */
    initial begin
        // Test header - makes output readable
        $display("========================================");
        $display("AND Gate Testbench");
        $display("========================================");
        
        /**
         * Signal Initialization
         * 
         * Initialize all inputs to known values before starting tests.
         * This prevents X (unknown) states that could cause issues.
         * 
         * Best practice: Always initialize signals before use
         */
        a = 0;  // Initialize input A to 0
        b = 0;  // Initialize input B to 0
        #10;    // Wait 10ns for signals to stabilize
        
        /**
         * Test Header - Display test table format
         * 
         * Format string explanation:
         * - %4t: Time in 4-character field
         * - %b: Binary format (0 or 1)
         */
        $display("\nTesting AND gate truth table:");
        $display("Time |  a  |  b  |  y  | Expected");
        $display("-----|-----|-----|-----|----------");
        
        /**
         * Test Case 1: 0 & 0 = 0
         * 
         * This tests the first row of the AND gate truth table.
         * Both inputs are 0, so output should be 0.
         */
        a = 0; b = 0;  // Apply test vector
        #5;            // Wait 5ns for combinational logic to propagate
        $display("%4t |  %b  |  %b  |  %b  |    0", $time, a, b, y);
        // Self-checking: verify output matches expected value
        // !== is case equality (checks value and X/Z states)
        if (y !== 0) $error("Test failed: 0 & 0 should be 0");
        
        /**
         * Test Case 2: 0 & 1 = 0
         * 
         * Tests second row of truth table.
         * One input is 0, so output should be 0 (AND requires both to be 1).
         */
        a = 0; b = 1;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    0", $time, a, b, y);
        if (y !== 0) $error("Test failed: 0 & 1 should be 0");
        
        /**
         * Test Case 3: 1 & 0 = 0
         * 
         * Tests third row of truth table.
         * Symmetric to test case 2.
         */
        a = 1; b = 0;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    0", $time, a, b, y);
        if (y !== 0) $error("Test failed: 1 & 0 should be 0");
        
        /**
         * Test Case 4: 1 & 1 = 1
         * 
         * Tests fourth row of truth table.
         * Both inputs are 1, so output should be 1 (only case where AND is true).
         */
        a = 1; b = 1;
        #5;
        $display("%4t |  %b  |  %b  |  %b  |    1", $time, a, b, y);
        if (y !== 1) $error("Test failed: 1 & 1 should be 1");
        
        // Test completion message
        $display("\n========================================");
        $display("All tests passed!");
        $display("========================================");
        #10;    // Final delay before finishing
        $finish; // Terminate simulation
    end

    /**
     * VCD (Value Change Dump) File Generation
     * 
     * This initial block generates a VCD file that can be viewed in GTKWave.
     * VCD files contain waveform data (signal values over time).
     * 
     * System Tasks:
     * - $dumpfile("filename.vcd"): Specifies output VCD file name
     * - $dumpvars(level, module): Dumps signals to VCD file
     *   - level 0: All signals in module and all submodules
     *   - level 1: Only signals in this module (not submodules)
     *   - level 2+: Deeper hierarchy levels
     * 
     * Viewing waveforms:
     *   gtkwave and_gate_test.vcd
     * 
     * Note: This block runs in parallel with the test sequence block above.
     *       Both initial blocks start at time 0 and run concurrently.
     */
    initial begin
        $dumpfile("and_gate_test.vcd");           // Set VCD output file
        $dumpvars(0, and_gate_test);              // Dump all signals (level 0 = all)
    end

endmodule
