/**
 * Interface-Based Testbench - SystemVerilog (iverilog)
 * 
 * This example demonstrates SystemVerilog interfaces, a powerful feature for
 * creating reusable, well-structured testbenches. Interfaces encapsulate signal
 * groups and provide direction control through modports, making testbenches
 * more maintainable and less error-prone.
 * 
 * Learning Objectives:
 * - Understand SystemVerilog interface syntax and semantics
 * - Learn modports for signal direction control
 * - Master interface-based testbench organization
 * - Understand interface instantiation and connection
 * - Learn DUT wrapping with interfaces
 * 
 * UVM Concepts Demonstrated:
 * - Interface-based verification: Core UVM methodology
 * - Virtual interfaces: Used in UVM for connecting classes to RTL
 * - Modports: Direction control (similar to UVM's interface modports)
 * - Interface encapsulation: Grouping related signals
 * 
 * Benefits of Interface-Based Testbenches:
 * - Encapsulation: Related signals grouped together
 * - Reusability: Interfaces can be reused across multiple testbenches
 * - Type safety: Modports prevent incorrect signal connections
 * - Maintainability: Changes to interface affect all users automatically
 * - Clarity: Clear signal relationships and directions
 * 
 * Note: This example is for iverilog. Verilator has limited interface support.
 * For Verilator, use C++ structs or classes (see interface_based_testbench_cpp.cpp).
 * 
 * Compilation and Execution:
 *   iverilog -g2012 -o interface_based_testbench interface_based_testbench.sv ../../dut/simple_gates/and_gate.v
 *   vvp interface_based_testbench
 * 
 * Key Concepts:
 * - interface: Declares a bundle of signals
 * - modport: Defines signal directions for different users
 * - Virtual interfaces: Interface handles used in classes (advanced topic)
 */

`timescale 1ns/1ps

/**
 * AND Gate Interface Definition
 * 
 * This interface encapsulates all signals for the AND gate:
 * - Input signals: a, b
 * - Output signal: y
 * 
 * Interfaces provide:
 * 1. Signal grouping: Related signals in one place
 * 2. Direction control: Modports define who can drive/read which signals
 * 3. Reusability: Same interface can be used in multiple testbenches
 * 
 * UVM Pattern: Similar to UVM virtual interfaces, which allow classes
 * to access RTL signals through interface handles.
 */
interface and_gate_if;
    // Interface signals (no direction specified here)
    // Direction is controlled by modports below
    logic a;  // First input to AND gate
    logic b;  // Second input to AND gate
    logic y;  // Output of AND gate
    
    /**
     * Modport for DUT (Design Under Test)
     * 
     * Modports define signal directions for different users of the interface.
     * This modport is for the DUT, which:
     * - Receives inputs (a, b) - these are inputs to the DUT
     * - Drives outputs (y) - this is an output from the DUT
     * 
     * Usage: module dut(and_gate_if.dut iface);
     * 
     * UVM Pattern: Similar to UVM modports that define signal directions
     * for different components (driver, monitor, etc.).
     */
    modport dut(
        input a, b,  // DUT receives these as inputs
        output y     // DUT drives this as output
    );
    
    /**
     * Modport for Testbench
     * 
     * This modport is for the testbench, which:
     * - Drives inputs (a, b) - testbench drives these to DUT
     * - Monitors outputs (y) - testbench reads this from DUT
     * 
     * Usage: In testbench, access signals via iface.tb
     * 
     * UVM Pattern: Testbench modports allow testbench components to
     * drive and monitor signals with proper direction control.
     */
    modport tb(
        output a, b,  // Testbench drives these as outputs
        input y       // Testbench reads this as input
    );
endinterface

/**
 * DUT Wrapper Module
 * 
 * This module wraps the actual DUT (and_gate) and connects it to the interface.
 * The wrapper pattern is common in interface-based testbenches because:
 * 1. DUT modules typically use port lists, not interfaces
 * 2. Wrapper provides clean interface-to-port mapping
 * 3. Allows DUT to be reused with different interfaces
 * 
 * Interface Connection:
 * - iverilog doesn't support interfaces as module ports, so we connect
 *   interface signals directly through hierarchical references
 * - The interface is instantiated in the testbench and connected via hierarchy
 * 
 * UVM Pattern: Similar to how UVM connects virtual interfaces to DUT modules
 * through wrapper modules or bind statements.
 */
module and_gate_wrapper;
    // Interface signals accessed via hierarchical reference
    // These will be connected to the interface in the testbench
    wire a, b, y;
    
    /**
     * DUT Instantiation
     * 
     * The actual DUT module is instantiated here.
     * Interface signals will be connected via hierarchical reference from testbench.
     */
    and_gate dut (
        .a(a),  // Connect to interface signal a
        .b(b),  // Connect to interface signal b
        .y(y)   // Connect to interface signal y
    );
endmodule

/**
 * Interface-Based Testbench Module
 * 
 * This module demonstrates a complete interface-based testbench:
 * 1. Instantiates the interface
 * 2. Connects DUT through wrapper
 * 3. Accesses signals through interface
 * 4. Executes tests and checks results
 * 
 * UVM Pattern: This demonstrates the testbench structure similar to UVM
 * where interfaces are instantiated and connected to DUT and testbench components.
 */
module interface_based_testbench;
    /**
     * Interface Instantiation
     * 
     * Interfaces are instantiated like modules, but without port connections.
     * The interface instance 'iface' contains all the signals (a, b, y).
     * 
     * Syntax: <interface_name> <instance_name>();
     */
    and_gate_if iface();
    
    /**
     * DUT Wrapper Instantiation
     * 
     * The wrapper connects the DUT to the interface.
     * Note: iverilog doesn't support interfaces as module ports, so we connect
     * interface signals via hierarchical reference using bind or direct connection.
     * 
     * Connection: Connect interface signals to wrapper via hierarchical reference
     */
    and_gate_wrapper dut_wrapper();
    
    // Connect interface signals to wrapper module via hierarchical reference
    assign dut_wrapper.a = iface.a;
    assign dut_wrapper.b = iface.b;
    assign iface.y = dut_wrapper.y;
    
    // Test statistics
    integer test_count = 0;  // Total number of tests executed
    integer pass_count = 0;  // Number of passing tests
    integer fail_count = 0;  // Number of failing tests
    
    /**
     * Test Task - Execute Single Test Case
     * 
     * This task encapsulates a single test case execution:
     * 1. Drive input signals through interface
     * 2. Wait for propagation delay
     * 3. Check output against expected value
     * 4. Update statistics and report
     * 
     * Tasks vs Functions:
     * - Tasks can have timing (# delays, @ events)
     * - Functions cannot have timing (must be combinational)
     * - Tasks are used for test sequences with timing
     * 
     * @param a_val Value to drive on input a
     * @param b_val Value to drive on input b
     * @param expected Expected output value
     * 
     * UVM Pattern: Similar to UVM sequence items or test tasks that
     * drive signals and check results.
     */
    task test_and_gate(logic a_val, logic b_val, logic expected);
        // Increment test counter
        test_count++;
        
        /**
         * Drive Input Signals Through Interface
         * 
         * Access interface signals directly via iface.<signal_name>
         * Since we're in the testbench, we can drive a and b (they're outputs
         * from testbench's perspective per the 'tb' modport).
         * 
         * Note: We're accessing signals directly, not through modport.
         * In more advanced usage, you might use iface.tb.a, but direct access
         * works when the modport allows it.
         */
        iface.a = a_val;  // Drive input a
        iface.b = b_val;  // Drive input b
        
        /**
         * Wait for Propagation Delay
         * 
         * #5 means wait 5 time units (5ns with timescale 1ns/1ps).
         * This allows:
         * - Combinational logic to propagate
         * - Signals to stabilize
         * - DUT to process inputs
         * 
         * In real designs, this delay would match the actual propagation delay.
         */
        #5;
        
        /**
         * Result Checking
         * 
         * Compare actual output (iface.y) with expected value.
         * Use === (case equality) to properly handle X and Z values.
         */
        if (iface.y === expected) begin
            // Test passed
            pass_count++;
            $display("[PASS] Test %0d: a=%b, b=%b, y=%b, expected=%b",
                     test_count, a_val, b_val, iface.y, expected);
        end else begin
            // Test failed
            fail_count++;
            $error("[FAIL] Test %0d: a=%b, b=%b, y=%b, expected=%b",
                   test_count, a_val, b_val, iface.y, expected);
        end
    endtask
    
    /**
     * Test Execution Initial Block
     * 
     * This block orchestrates the test execution:
     * 1. Display header
     * 2. Execute all test cases (exhaustive test)
     * 3. Report results
     * 4. Finish simulation
     */
    initial begin
        // Display test header
        $display("========================================");
        $display("Interface-Based Testbench Example");
        $display("========================================");
        
        /**
         * Exhaustive Test Suite
         * 
         * Test all possible input combinations (2^2 = 4 combinations).
         * This ensures complete coverage of the AND gate truth table.
         * 
         * Test Cases:
         * - (0,0) -> 0: Both inputs low, output low
         * - (0,1) -> 0: First low, second high, output low
         * - (1,0) -> 0: First high, second low, output low
         * - (1,1) -> 1: Both inputs high, output high
         */
        test_and_gate(0, 0, 0);  // Test case 1: a=0, b=0, expected=0
        test_and_gate(0, 1, 0);  // Test case 2: a=0, b=1, expected=0
        test_and_gate(1, 0, 0);  // Test case 3: a=1, b=0, expected=0
        test_and_gate(1, 1, 1);  // Test case 4: a=1, b=1, expected=1
        
        // Print test summary
        $display("");
        $display("========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests:  %0d", test_count);
        $display("Passed:       %0d", pass_count);
        $display("Failed:       %0d", fail_count);
        $display("========================================");
        
        // Final status message
        if (fail_count == 0) begin
            $display("✓ All tests PASSED!");
        end else begin
            $display("✗ Some tests FAILED!");
        end
        
        $display("========================================");
        
        // Small delay before finishing (allows any pending events to complete)
        #10;
        
        // Finish simulation
        $finish;
    end
    
    /**
     * VCD File Generation
     * 
     * This initial block sets up waveform dumping for debugging.
     * VCD files can be viewed in GTKWave or other waveform viewers.
     * 
     * $dumpfile: Specifies the output VCD file name
     * $dumpvars: Specifies which signals to dump
     *   - First argument (0): Dump all signals in this module and below
     *   - Second argument: Module instance name
     */
    initial begin
        $dumpfile("interface_based_testbench.vcd");
        $dumpvars(0, interface_based_testbench);
    end
endmodule
