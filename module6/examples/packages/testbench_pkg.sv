/**
 * Testbench Package - SystemVerilog
 * 
 * This package demonstrates SystemVerilog package organization, which provides
 * a namespace for shared definitions, types, functions, and tasks that can be
 * reused across multiple testbenches.
 * 
 * Learning Objectives:
 * - Understand SystemVerilog package syntax and semantics
 * - Learn package organization and namespace management
 * - Master shared type definitions
 * - Learn reusable function and task definitions
 * - Understand package import and usage
 * 
 * UVM Concepts Demonstrated:
 * - Package organization: Similar to UVM packages (uvm_pkg)
 * - Shared definitions: Types, functions, and tasks shared across testbenches
 * - Namespace management: Avoid naming conflicts
 * - Reusable components: Functions and tasks for common operations
 * 
 * Benefits of Packages:
 * - Code reuse: Share definitions across multiple files
 * - Namespace management: Avoid naming conflicts
 * - Organization: Group related definitions together
 * - Maintainability: Update once, affects all users
 * 
 * Usage:
 *   import testbench_pkg::*;  // Import all definitions
 *   import testbench_pkg::test_vector_t;  // Import specific definition
 * 
 * Note: This example is for iverilog. Verilator has limited package support.
 */

package testbench_pkg;
    /**
     * Package Constants
     * 
     * Constants defined in packages can be used across multiple modules.
     * This constant defines the number of test vectors for the AND gate.
     */
    parameter int TEST_COUNT = 4;  // Number of test vectors (2^2 = 4 combinations)
    
    /**
     * Type Definitions
     * 
     * Packages are ideal for defining shared types that are used across
     * multiple testbenches. This struct represents a test vector.
     * 
     * struct packed: Packed structure (bit-aligned, no padding)
     * - More efficient for synthesis
     * - Can be used in bit operations
     * - All members must be packed types
     * 
     * UVM Pattern: Similar to UVM's type definitions in packages, such as
     * uvm_object_wrapper or transaction types.
     */
    typedef struct packed {
        logic a;        // Input signal a
        logic b;        // Input signal b
        logic expected; // Expected output value
    } test_vector_t;
    
    /**
     * Function Definition - Calculate AND Gate Output
     * 
     * Functions in packages provide reusable computation logic.
     * 
     * function automatic: Automatic storage (stack-based, reentrant)
     * - Each call gets its own copy of local variables
     * - Can be called recursively
     * - No side effects (pure function)
     * 
     * @param a First input to AND gate
     * @param b Second input to AND gate
     * @return AND gate output (a & b)
     * 
     * UVM Pattern: Similar to UVM utility functions in packages.
     */
    function automatic logic calculate_and(logic a, logic b);
        // Implement AND gate logic
        return a & b;
    endfunction
    
    /**
     * Task Definition - Print Test Result
     * 
     * Tasks in packages provide reusable procedural code with side effects.
     * Unlike functions, tasks can contain timing controls and can have
     * multiple outputs (via reference arguments).
     * 
     * task automatic: Automatic storage (stack-based, reentrant)
     * - Each call gets its own copy of local variables
     * - Can contain timing controls (#, @)
     * - Can have side effects (display, file I/O, etc.)
     * 
     * @param test_num Test case number
     * @param a Input signal a value
     * @param b Input signal b value
     * @param result Actual result from DUT
     * @param expected Expected result value
     * 
     * UVM Pattern: Similar to UVM utility tasks for reporting and logging.
     */
    task automatic print_test_result(int test_num, logic a, logic b, logic result, logic expected);
        // Compare result with expected value
        // Use === (case equality) to properly handle X and Z values
        if (result === expected) begin
            // Test passed - display pass message
            $display("[PASS] Test %0d: a=%b, b=%b, result=%b, expected=%b",
                     test_num, a, b, result, expected);
        end else begin
            // Test failed - display error message
            $error("[FAIL] Test %0d: a=%b, b=%b, result=%b, expected=%b",
                   test_num, a, b, result, expected);
        end
    endtask
endpackage
