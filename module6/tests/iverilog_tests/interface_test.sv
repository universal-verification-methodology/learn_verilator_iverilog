/**
 * Interface-Based Testbench - SystemVerilog (iverilog)
 * 
 * This testbench demonstrates SystemVerilog interfaces for testbench organization.
 * 
 * Key Concepts:
 * - Interface declaration and usage
 * - Modports for direction control
 * - Interface-based testbench organization
 * 
 * Usage:
 *   make interface_test
 *   or
 *   iverilog -g2012 -o interface_test interface_test.sv ../../../module6/dut/simple_gates/and_gate.v
 *   vvp interface_test
 */

`timescale 1ns/1ps

/**
 * AND Gate Interface
 * 
 * Encapsulates all signals for the AND gate.
 */
interface and_gate_if;
    logic a;  // First input
    logic b;  // Second input
    logic y;  // Output
    
    // Modport for DUT
    modport dut(
        input a, b,
        output y
    );
    
    // Modport for Testbench
    modport tb(
        output a, b,
        input y
    );
endinterface

// DUT wrapper using interface
module and_gate_wrapper(and_gate_if.dut iface);
    and_gate dut (
        .a(iface.a),
        .b(iface.b),
        .y(iface.y)
    );
endmodule

// Top-level testbench module
module interface_test;
    // Interface instance
    and_gate_if iface();
    
    // DUT wrapper instantiation
    and_gate_wrapper dut_wrapper(iface.dut);
    
    // Test sequence
    initial begin
        $display("========================================");
        $display("Interface-Based Testbench (iverilog)");
        $display("========================================");
        
        // Test case 1: a=0, b=0 -> expected: y=0
        iface.tb.a = 0;
        iface.tb.b = 0;
        #5;
        $display("Test 1: a=%b, b=%b, y=%b (expected 0) %s",
                 iface.tb.a, iface.tb.b, iface.tb.y,
                 (iface.tb.y === 0) ? "[PASS]" : "[FAIL]");
        if (iface.tb.y !== 0) $error("Test failed");
        
        // Test case 2: a=0, b=1 -> expected: y=0
        iface.tb.a = 0;
        iface.tb.b = 1;
        #5;
        $display("Test 2: a=%b, b=%b, y=%b (expected 0) %s",
                 iface.tb.a, iface.tb.b, iface.tb.y,
                 (iface.tb.y === 0) ? "[PASS]" : "[FAIL]");
        if (iface.tb.y !== 0) $error("Test failed");
        
        // Test case 3: a=1, b=0 -> expected: y=0
        iface.tb.a = 1;
        iface.tb.b = 0;
        #5;
        $display("Test 3: a=%b, b=%b, y=%b (expected 0) %s",
                 iface.tb.a, iface.tb.b, iface.tb.y,
                 (iface.tb.y === 0) ? "[PASS]" : "[FAIL]");
        if (iface.tb.y !== 0) $error("Test failed");
        
        // Test case 4: a=1, b=1 -> expected: y=1
        iface.tb.a = 1;
        iface.tb.b = 1;
        #5;
        $display("Test 4: a=%b, b=%b, y=%b (expected 1) %s",
                 iface.tb.a, iface.tb.b, iface.tb.y,
                 (iface.tb.y === 1) ? "[PASS]" : "[FAIL]");
        if (iface.tb.y !== 1) $error("Test failed");
        
        $display("\n========================================");
        $display("All tests completed!");
        $display("========================================");
        
        #10;
        $finish;
    end
    
    // Waveform generation
    initial begin
        $dumpfile("interface_test.vcd");
        $dumpvars(0, interface_test);
    end
endmodule
