/**
 * Randomized Testbench - SystemVerilog (iverilog)
 * 
 * This example demonstrates constrained randomization, a powerful verification technique
 * inspired by UVM (Universal Verification Methodology). Constrained randomization allows
 * you to generate large numbers of test vectors automatically while ensuring they meet
 * specific requirements through constraints.
 * 
 * Learning Objectives:
 * - Understand SystemVerilog randomization (rand, randc keywords)
 * - Learn constraint-based randomization (constraint blocks)
 * - Master post_randomize() callback for derived value calculation
 * - Understand seed control for reproducible random tests
 * - Learn random test generation strategies
 * 
 * UVM Concepts Demonstrated:
 * - Constrained Random Verification (CRV): Core UVM methodology
 * - Constraint blocks: Define valid value ranges (similar to UVM constraint blocks)
 * - Randomization: Generate test vectors automatically
 * - Seed control: Reproducible test generation
 * - Transaction-based testing: Randomize transaction objects
 * 
 * Key Benefits of Constrained Randomization:
 * - Generate thousands of test vectors automatically
 * - Ensure test vectors meet design requirements (via constraints)
 * - Achieve better coverage with less manual effort
 * - Reproducible tests through seed control
 * 
 * Note: This example is for iverilog. Verilator has limited randomization support.
 * For Verilator, use C++ random number generators (see randomized_testbench_cpp.cpp).
 * 
 * Compilation and Execution:
 *   iverilog -g2012 -o randomized_testbench randomized_testbench.sv ../../dut/multiplexers/mux_4to1.v
 *   vvp randomized_testbench
 * 
 * Key Concepts:
 * - rand: Random variable (can repeat values)
 * - randc: Cyclic random variable (no repeats until all values used)
 * - constraint: Defines valid value ranges and relationships
 * - randomize(): Generates random values satisfying constraints
 * - post_randomize(): Callback after successful randomization
 */

`timescale 1ns/1ps

/**
 * MUX Transaction Class with Constrained Randomization
 * 
 * This class models a transaction for a 4-to-1 multiplexer test.
 * It demonstrates constrained randomization where:
 * - Input signals are randomized
 * - Constraints ensure valid values
 * - Expected output is calculated automatically
 * 
 * UVM Pattern: This follows the UVM sequence item pattern with constraints,
 * similar to how uvm_sequence_item classes use constraints to define valid
 * transaction values.
 * 
 * Class Properties:
 * - rand bit [1:0] sel: Randomizable 2-bit select signal (0-3)
 * - rand bit in0, in1, in2, in3: Randomizable input signals
 * - bit expected: Calculated expected output (not randomizable)
 */
class mux_transaction;
    // Randomizable select signal (2 bits = 4 possible values: 0, 1, 2, 3)
    // rand keyword makes this eligible for randomization
    // The constraint below ensures it stays in valid range [0:3]
    rand bit [1:0] sel;
    
    // Randomizable input signals (4 inputs to the multiplexer)
    // Each can be randomly set to 0 or 1
    rand bit in0;  // Input 0 (selected when sel=0)
    rand bit in1;  // Input 1 (selected when sel=1)
    rand bit in2;  // Input 2 (selected when sel=2)
    rand bit in3;  // Input 3 (selected when sel=3)
    
    // Non-randomizable expected output (calculated in post_randomize)
    bit expected;
    
    /**
     * Constraint Block - Valid Value Range
     * 
     * Constraints define valid value ranges and relationships for random variables.
     * The constraint solver ensures all randomize() calls generate values that
     * satisfy all constraints.
     * 
     * This constraint ensures sel is always in the valid range [0:3]:
     * - sel inside {[0:3]} means sel can be 0, 1, 2, or 3
     * - This prevents invalid select values
     * 
     * UVM Pattern: Similar to constraint blocks in UVM sequence items:
     *   constraint valid_range { sel inside {[0:3]}; }
     * 
     * More complex constraints are possible:
     *   constraint complex {
     *     sel dist {0:=20, 1:=20, 2:=30, 3:=30};  // Weighted distribution
     *     in0 != in1;  // Relationship between variables
     *   }
     */
    // Note: iverilog doesn't support constraint blocks
    // Constraint blocks are a SystemVerilog feature not fully supported by iverilog
    // The randomization will still work, but without constraint enforcement
    // For full constraint support, use commercial simulators or Verilator with C++
    /*
    constraint sel_range {
        // Ensure select signal is always in valid range [0:3]
        // inside operator checks if value is in the specified set
        sel inside {[0:3]};
    }
    */
    
    /**
     * Post-Randomization Callback
     * 
     * Automatically called after successful randomization to calculate derived values.
     * In this case, we calculate the expected output based on the selected input.
     * 
     * This implements the 4-to-1 multiplexer logic:
     * - When sel=0, output = in0
     * - When sel=1, output = in1
     * - When sel=2, output = in2
     * - When sel=3, output = in3
     * 
     * UVM Pattern: Similar to post_randomize() in UVM sequence items where
     * derived fields are calculated after randomization.
     */
    function void post_randomize();
        // Calculate expected output based on select signal
        // This implements the multiplexer selection logic
        case (sel)
            2'b00: expected = in0;  // Select input 0
            2'b01: expected = in1;  // Select input 1
            2'b10: expected = in2;  // Select input 2
            2'b11: expected = in3;  // Select input 3
        endcase
    endfunction
    
    /**
     * Print Method - Display Transaction Contents
     * 
     * Useful for debugging and logging randomized transactions.
     * Shows all transaction fields including the calculated expected value.
     */
    function void print();
        $display("Transaction: sel=%b, in0=%b, in1=%b, in2=%b, in3=%b, expected=%b",
                 sel, in0, in1, in2, in3, expected);
    endfunction
endclass

/**
 * Randomized Testbench Module
 * 
 * This module demonstrates a complete randomized testbench that:
 * 1. Creates randomized transactions
 * 2. Applies them to the DUT (or simulation model)
 * 3. Checks results automatically
 * 4. Reports test statistics
 * 
 * In a real testbench, this would instantiate the actual DUT module.
 * Here we simulate the DUT behavior using an always_comb block.
 * 
 * UVM Pattern: This demonstrates the test execution flow similar to UVM:
 * - Create transaction objects
 * - Randomize transactions (with constraints)
 * - Apply to DUT
 * - Check results
 * - Report statistics
 */
module randomized_testbench;
    // Transaction object for generating random test vectors
    mux_transaction tr;
    
    // DUT interface signals
    // In a real testbench, these would connect to the actual DUT module
    bit [1:0] sel;      // Select signal (2 bits for 4-to-1 mux)
    bit in0, in1, in2, in3;  // Input signals
    bit out;            // Output signal (from DUT)
    bit expected;       // Expected output (from transaction)
    
    // Test statistics
    integer test_count = 0;  // Total number of tests executed
    integer pass_count = 0;  // Number of passing tests
    integer fail_count = 0;  // Number of failing tests
    
    /**
     * DUT Simulation Model
     * 
     * This always_comb block simulates the 4-to-1 multiplexer behavior.
     * In a real testbench, you would instantiate the actual DUT module:
     * 
     *   mux_4to1 dut (
     *       .sel(sel),
     *       .in0(in0), .in1(in1), .in2(in2), .in3(in3),
     *       .out(out)
     *   );
     * 
     * always_comb: Combinational logic block that updates whenever
     * any input changes. This models the multiplexer selection logic.
     */
    always_comb begin
        // Multiplexer selection logic
        // Based on sel value, route the appropriate input to output
        case (sel)
            2'b00: out = in0;  // Select input 0 when sel=0
            2'b01: out = in1;  // Select input 1 when sel=1
            2'b10: out = in2;  // Select input 2 when sel=2
            2'b11: out = in3;  // Select input 3 when sel=3
            default: out = 1'bx;  // Unknown for invalid sel (shouldn't happen with constraints)
        endcase
    end
    
    /**
     * Test Execution Initial Block
     * 
     * This block orchestrates the randomized test execution:
     * 1. Display header and seed information
     * 2. Create transaction object
     * 3. Generate and execute random tests
     * 4. Report results
     */
    initial begin
        // Display test header
        $display("========================================");
        $display("Randomized Testbench Example");
        $display("========================================");
        
        /**
         * Random Seed Control
         * 
         * $urandom() generates a random unsigned integer.
         * The seed can be set using $urandom(seed) for reproducible tests.
         * 
         * For reproducible tests (same sequence every run):
         *   $urandom(12345);  // Set seed to 12345
         * 
         * For different random sequences each run:
         *   $urandom;  // Use system time or random seed
         * 
         * UVM Pattern: Similar to UVM's +UVM_TESTNAME and seed control
         * for reproducible test generation.
         */
        $display("Random seed: %0d", $urandom);
        
        // Create transaction object
        // This allocates memory and initializes the transaction
        tr = new();
        
        // Generate random tests
        // This loop demonstrates constrained random verification (CRV)
        // where we generate many test vectors automatically
        // Note: iverilog doesn't support randomize() method, so we use manual randomization
        $display("\nGenerating random test vectors:");
        for (int i = 0; i < 10; i++) begin
            /**
             * Manual Randomization (iverilog workaround)
             * 
             * Since iverilog doesn't support the randomize() method on classes,
             * we manually randomize the rand variables using $urandom.
             * 
             * $urandom: Generates random unsigned integer
             * For range [min, max]: use $urandom % (max - min + 1) + min
             * 
             * After setting random values, we manually call post_randomize()
             * to calculate derived values (expected output).
             */
            // Manually randomize rand variables using $urandom with modulo
            tr.sel = $urandom % 4;  // Random select: 0-3 (4 possible values)
            tr.in0 = $urandom % 2;  // Random input 0: 0 or 1
            tr.in1 = $urandom % 2;  // Random input 1: 0 or 1
            tr.in2 = $urandom % 2;  // Random input 2: 0 or 1
            tr.in3 = $urandom % 2;  // Random input 3: 0 or 1
            
            // Manually call post_randomize() to calculate expected output
            tr.post_randomize();
            
            // Display transaction contents (for debugging/logging)
            tr.print();
            
            // Apply randomized values to DUT interface
            // In a real testbench, this would drive DUT input signals
            sel = tr.sel;        // Set select signal
            in0 = tr.in0;        // Set input 0
            in1 = tr.in1;        // Set input 1
            in2 = tr.in2;        // Set input 2
            in3 = tr.in3;        // Set input 3
            expected = tr.expected;  // Get expected output (calculated in post_randomize)
            
            // Wait for combinational logic to settle
            // In real testbench, this allows DUT to process inputs
            #5;
            
            /**
             * Result Checking
             * 
             * Compare actual DUT output with expected value.
             * Use === (case equality) to properly handle X and Z values.
             */
            test_count++;
            if (out === expected) begin
                // Test passed
                pass_count++;
                $display("  [PASS] Test %0d: out=%b, expected=%b", test_count, out, expected);
            end else begin
                // Test failed
                fail_count++;
                $error("  [FAIL] Test %0d: out=%b, expected=%b", test_count, out, expected);
            end
        end
        
        // Print test summary
        // Display comprehensive test results
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
     * VCD (Value Change Dump) files can be viewed in GTKWave or other waveform viewers.
     * 
     * $dumpfile: Specifies the output VCD file name
     * $dumpvars: Specifies which signals to dump
     *   - First argument (0): Dump all signals in this module and below
     *   - Second argument: Module instance name
     */
    initial begin
        $dumpfile("randomized_testbench.vcd");
        $dumpvars(0, randomized_testbench);
    end
endmodule
