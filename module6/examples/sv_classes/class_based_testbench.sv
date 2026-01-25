/**
 * Class-Based Testbench - SystemVerilog (iverilog)
 * 
 * This example demonstrates object-oriented testbench design using SystemVerilog classes,
 * inspired by UVM (Universal Verification Methodology) patterns. It shows how to structure
 * testbenches using classes for better organization, reusability, and maintainability.
 * 
 * Learning Objectives:
 * - Understand SystemVerilog class syntax and semantics
 * - Learn class-based testbench organization (UVM-inspired)
 * - Master transaction classes for data modeling
 * - Implement testbench classes for test orchestration
 * - Understand object instantiation and lifetime management
 * - Learn post_randomize() callback pattern (UVM-style)
 * 
 * UVM Concepts Demonstrated:
 * - Transaction classes: Data structures for test vectors (similar to uvm_sequence_item)
 * - Testbench classes: Test orchestration (similar to uvm_test)
 * - Object-oriented organization: Encapsulation and modularity
 * - Post-randomization callbacks: Automatic expected value calculation
 * 
 * Note: This example is for iverilog. Verilator has limited SystemVerilog class support.
 * For Verilator, use C++ classes instead (see class_based_testbench_cpp.cpp).
 * 
 * Compilation and Execution:
 *   iverilog -g2012 -o class_based_testbench class_based_testbench.sv ../../dut/simple_gates/and_gate.v
 *   vvp class_based_testbench
 * 
 * Key Concepts:
 * - Classes provide object-oriented programming in SystemVerilog
 * - Classes enable better testbench organization and reusability
 * - Transaction classes model data structures for verification
 * - Testbench classes orchestrate test execution
 * - post_randomize() is called automatically after randomization
 */

`timescale 1ns/1ps

/**
 * Transaction Class
 * 
 * This class models a transaction (test vector) for the AND gate.
 * In UVM terminology, this is similar to a sequence item (uvm_sequence_item).
 * 
 * Class Properties:
 * - rand bit a, b: Randomizable inputs (can be randomized with randomize())
 * - bit expected: Calculated expected output (not randomizable)
 * 
 * Methods:
 * - new(): Constructor (called automatically on instantiation)
 * - print(): Display transaction contents (useful for debugging)
 * - post_randomize(): Callback called after randomization (UVM-style pattern)
 * 
 * UVM Pattern: This follows the transaction/sequence_item pattern where:
 * - Data fields are declared as class properties
 * - Randomization is controlled via rand/randc keywords
 * - post_randomize() calculates derived values (expected results)
 */
class transaction;
    // Randomizable input signals (can be randomized with randomize() method)
    // rand keyword makes these variables eligible for constrained randomization
    rand bit a;  // First input to AND gate
    rand bit b;  // Second input to AND gate
    
    // Non-randomizable output (calculated, not randomized)
    bit expected;  // Expected output value (calculated in post_randomize)
    
    /**
     * Constructor - Called automatically when object is created
     * 
     * Initializes all class properties to default values.
     * In SystemVerilog, new() is the constructor function.
     * 
     * Usage: transaction tr = new();  // Creates new transaction object
     */
    function new();
        a = 0;        // Initialize input a to 0
        b = 0;        // Initialize input b to 0
        expected = 0; // Initialize expected output to 0
    endfunction
    
    /**
     * Print Method - Display transaction contents
     * 
     * Useful for debugging and logging. Shows all transaction fields.
     * Similar to UVM's print() or convert2string() methods.
     * 
     * Usage: tr.print();  // Displays transaction values
     */
    function void print();
        $display("Transaction: a=%b, b=%b, expected=%b", a, b, expected);
    endfunction
    
    /**
     * Post-Randomization Callback - UVM-style pattern
     * 
     * This method is automatically called by the SystemVerilog simulator
     * after successful randomization (when randomize() returns true).
     * 
     * Purpose: Calculate derived values that depend on randomized inputs.
     * In this case, we calculate the expected output based on the randomized inputs.
     * 
     * UVM Pattern: Similar to post_randomize() in UVM sequence items, which is
     * used to compute derived fields after randomization.
     * 
     * Usage: Automatically called after tr.randomize() succeeds
     */
    function void post_randomize();
        // Calculate expected result based on randomized inputs
        // This implements the AND gate logic: output = a & b
        expected = a & b;
    endfunction
endclass

/**
 * Testbench Class
 * 
 * This class orchestrates test execution, similar to a UVM test class (uvm_test).
 * It manages test execution, result checking, and reporting.
 * 
 * Class Properties:
 * - transaction tr: Transaction object for generating test vectors
 * - bit result: Actual result from DUT (or simulation)
 * - int test_count, pass_count, fail_count: Test statistics
 * 
 * Methods:
 * - new(): Constructor to initialize testbench
 * - run_test(): Execute a single test case
 * - print_summary(): Display test results summary
 * 
 * UVM Pattern: This follows the test class pattern where:
 * - Test orchestration is encapsulated in a class
 * - Test statistics are maintained as class properties
 * - Test execution is organized into methods
 */
class testbench;
    // Transaction object for generating test vectors
    // This will be instantiated in the constructor
    transaction tr;
    
    // Test execution state
    bit result;        // Actual result from DUT simulation
    int test_count;    // Total number of tests executed
    int pass_count;    // Number of passing tests
    int fail_count;    // Number of failing tests
    
    /**
     * Constructor - Initialize testbench
     * 
     * Creates a new transaction object and initializes test statistics.
     * This is called when the testbench object is instantiated.
     * 
     * Usage: testbench tb = new();  // Creates new testbench instance
     */
    function new();
        // Create a new transaction object
        // This allocates memory and calls transaction::new()
        tr = new();
        
        // Initialize test statistics
        test_count = 0;  // No tests run yet
        pass_count = 0;  // No passes yet
        fail_count = 0;  // No failures yet
    endfunction
    
    /**
     * Run Test Method - Execute a single test case
     * 
     * This method simulates a test case by:
     * 1. Incrementing test count
     * 2. Simulating DUT operation (in real testbench, this would drive DUT)
     * 3. Comparing result with expected value
     * 4. Updating pass/fail statistics
     * 5. Displaying test result
     * 
     * @param a Input signal a value
     * @param b Input signal b value
     * @param expected Expected output value
     * 
     * UVM Pattern: Similar to test execution in UVM where each test case
     * is executed and results are checked and reported.
     */
    function void run_test(bit a, bit b, bit expected);
        // Increment total test count
        test_count++;
        
        // Simulate DUT operation
        // In a real testbench, this would drive signals to DUT and sample outputs
        // Here we simulate the AND gate logic: result = a & b
        result = a & b;
        
        // Compare actual result with expected value
        if (result == expected) begin
            // Test passed - increment pass count
            pass_count++;
            $display("[PASS] Test %0d: a=%b, b=%b, result=%b, expected=%b",
                     test_count, a, b, result, expected);
        end else begin
            // Test failed - increment fail count and report error
            fail_count++;
            $error("[FAIL] Test %0d: a=%b, b=%b, result=%b, expected=%b",
                   test_count, a, b, result, expected);
        end
    endfunction
    
    /**
     * Print Summary Method - Display test results summary
     * 
     * Displays a formatted summary of all test results including:
     * - Total number of tests executed
     * - Number of passing tests
     * - Number of failing tests
     * 
     * UVM Pattern: Similar to UVM's end_of_elaboration_phase() or
     * report_phase() where test results are summarized and reported.
     * 
     * Usage: tb.print_summary();  // Display test summary
     */
    function void print_summary();
        $display("");
        $display("========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests:  %0d", test_count);
        $display("Passed:       %0d", pass_count);
        $display("Failed:       %0d", fail_count);
        $display("========================================");
    endfunction
endclass

/**
 * Top-Level Testbench Module
 * 
 * This is the top-level module that instantiates the testbench class and
 * orchestrates the test execution. In a real verification environment,
 * this would also instantiate the DUT (Design Under Test).
 * 
 * Test Flow:
 * 1. Create testbench object
 * 2. Run deterministic tests (exhaustive test vectors)
 * 3. Run randomized tests using transaction class
 * 4. Print test summary
 * 5. Finish simulation
 * 
 * UVM Pattern: This module is similar to the top-level test module in UVM,
 * which instantiates the test class and starts the test phase.
 */
module class_based_testbench;
    // Testbench class instance
    // This will be created in the initial block
    testbench tb;
    
    /**
     * Initial Block - Test Execution
     * 
     * This block contains the test execution flow:
     * 1. Display header
     * 2. Create testbench instance
     * 3. Run deterministic tests (all input combinations)
     * 4. Run randomized tests using transaction class
     * 5. Print summary and finish
     * 
     * In SystemVerilog, initial blocks execute once at simulation start.
     * This is where test execution begins.
     */
    initial begin
        // Display test header
        $display("========================================");
        $display("Class-Based Testbench Example");
        $display("========================================");
        
        // Create testbench instance
        // This allocates memory and calls testbench::new()
        // The constructor will create the transaction object and initialize statistics
        tb = new();
        
        // Run deterministic tests - exhaustive test vectors
        // These tests cover all possible input combinations (2^2 = 4 combinations)
        // This ensures complete coverage of the AND gate truth table
        $display("\n--- Deterministic Tests ---");
        tb.run_test(0, 0, 0);  // Test case: a=0, b=0, expected=0
        tb.run_test(0, 1, 0);  // Test case: a=0, b=1, expected=0
        tb.run_test(1, 0, 0);  // Test case: a=1, b=0, expected=0
        tb.run_test(1, 1, 1);  // Test case: a=1, b=1, expected=1
        
        // Test with transaction class - Randomized testing
        // This demonstrates the power of class-based testbenches:
        // - Generate random test vectors
        // - Automatically calculate expected values
        // - Reuse transaction objects
        $display("\n--- Randomized Tests (using transaction class) ---");
        // Note: iverilog doesn't support randomize() method or nested method calls,
        // so we use manual randomization and a local variable
        begin
            transaction tr;  // Local transaction handle
            tr = tb.tr;     // Assign testbench's transaction handle
            for (int i = 0; i < 4; i++) begin
                // Manual Randomization (iverilog workaround)
                // Since iverilog doesn't support the randomize() method on classes,
                // we manually randomize the rand variables using $urandom.
                // After setting random values, we manually call post_randomize()
                // to calculate derived values (expected output).
                tr.a = $urandom % 2;  // Random input a: 0 or 1
                tr.b = $urandom % 2;  // Random input b: 0 or 1
                
                // Manually call post_randomize() to calculate expected output
                tr.post_randomize();
                
                // Display transaction contents (for debugging)
                tr.print();
                
                // Run test with randomized values
                // The expected value was automatically calculated in post_randomize()
                tb.run_test(tr.a, tr.b, tr.expected);
            end
        end
        
        // Print test summary
        // This displays total tests, passes, and failures
        tb.print_summary();
        
        // Display footer and finish simulation
        $display("========================================");
        
        // Small delay before finishing (allows any pending events to complete)
        #10;
        
        // Finish simulation
        // This terminates the simulation and returns control to the simulator
        $finish;
    end
endmodule
