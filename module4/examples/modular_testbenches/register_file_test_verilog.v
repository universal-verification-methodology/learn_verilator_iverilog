/**
 * Modular Register File Verilog Testbench
 * 
 * This testbench demonstrates the UVM-inspired separation of concerns pattern,
 * where testbench functionality is divided into distinct, reusable components:
 * - Stimulus Generator: Drives inputs to the DUT
 * - Monitor: Observes and logs DUT behavior
 * - Checker: Validates DUT outputs against expected values
 * 
 * Learning Objectives:
 * - Understand modular testbench architecture
 * - Learn separation of concerns in verification
 * - Master Verilog module-based testbench organization
 * - Understand stimulus generation patterns
 * - Learn monitoring and checking strategies
 * 
 * UVM Pattern Inspiration:
 * This structure mirrors UVM's agent architecture:
 * - Driver (Stimulus): Generates and applies test vectors
 * - Monitor: Observes transactions and signals
 * - Scoreboard/Checker: Validates correctness
 * 
 * While this is pure Verilog (not SystemVerilog/UVM), the principles
 * of separation of concerns and modularity are the same.
 * 
 * Testbench Structure:
 *   Top-level testbench (register_file_test_verilog)
 *   ├── Stimulus Module (register_file_stimulus)
 *   │   └── Generates clock, reset, and test vectors
 *   ├── DUT (register_file)
 *   │   └── Design Under Test
 *   ├── Monitor Module (register_file_monitor)
 *   │   └── Observes and logs all transactions
 *   └── Checker Module (register_file_checker)
 *       └── Validates outputs against expected values
 * 
 * Compilation and Execution:
 *   iverilog -o register_file_test register_file_test_verilog.v ../../dut/registers/register_file.v
 *   vvp register_file_test
 * 
 * Expected Output:
 *   - Monitor messages showing write/read operations
 *   - Checker messages indicating pass/fail status
 *   - VCD file (register_file_test.vcd) for waveform analysis
 * 
 * Usage:
 *   iverilog -o register_file_test register_file_test_verilog.v ../../dut/registers/register_file.v
 *   vvp register_file_test
 *   gtkwave register_file_test.vcd  # Optional: view waveforms
 */

`timescale 1ns/1ps

/**
 * Stimulus Module
 * 
 * Purpose: Generate all input signals to the DUT
 * 
 * Responsibilities:
 * - Clock generation (continuous)
 * - Reset sequence (assert, hold, release)
 * - Test vector generation (write/read operations)
 * - Timing control (delays between operations)
 * 
 * This module acts as the "driver" in UVM terminology, applying
 * stimulus to the DUT according to the test plan.
 * 
 * @param clk      Clock signal (driven continuously)
 * @param rst_n    Active-low reset signal
 * @param we       Write enable signal
 * @param waddr    Write address (2 bits, selects register 0-3)
 * @param wdata    Write data (8 bits)
 * @param raddr0   Read address 0 (2 bits)
 * @param raddr1   Read address 1 (2 bits)
 */
module register_file_stimulus(
    output reg        clk,
    output reg        rst_n,
    output reg        we,
    output reg [1:0]  waddr,
    output reg [7:0]  wdata,
    output reg [1:0]  raddr0,
    output reg [1:0]  raddr1
);

    /**
     * Clock Generation
     * 
     * Generates a continuous clock signal with 50% duty cycle.
     * Period = 20ns (10ns high, 10ns low) = 50MHz
     * 
     * The clock runs forever until simulation ends ($finish).
     * This is a common pattern for synchronous designs.
     */
    initial begin
        clk = 0;                    // Start at logic 0
        forever #10 clk = ~clk;     // Toggle every 10ns (half period)
    end

    /**
     * Test Sequence
     * 
     * This initial block implements the test scenario:
     * 1. Initialize all signals
     * 2. Apply reset sequence
     * 3. Write test data to multiple registers
     * 4. Read back and verify data
     * 
     * Timing:
     * - Reset held for 25ns (ensures proper reset)
     * - Operations spaced by 20ns (one clock cycle)
     * - Final delay allows checker to complete validation
     */
    initial begin
        // ========================================
        // Phase 1: Initialization
        // ========================================
        // Set all signals to known state before reset
        rst_n = 0;      // Assert reset (active low)
        we = 0;         // Write enable off
        waddr = 0;      // Write address = 0
        wdata = 0;      // Write data = 0
        raddr0 = 0;     // Read address 0 = 0
        raddr1 = 0;     // Read address 1 = 0
        #25;            // Hold reset for 25ns (more than one clock cycle)
        
        // ========================================
        // Phase 2: Reset Release
        // ========================================
        // Release reset and wait for design to stabilize
        rst_n = 1;      // Deassert reset
        #20;            // Wait one clock cycle (20ns)
        
        // ========================================
        // Phase 3: Write Operations
        // ========================================
        // Write test data to register 0
        we = 1;         // Enable write
        waddr = 0;      // Write to register 0
        wdata = 8'hAA;  // Write data = 0xAA
        #20;            // Hold for one clock cycle
        
        // Write test data to register 1
        waddr = 1;      // Write to register 1
        wdata = 8'hBB;  // Write data = 0xBB
        #20;            // Hold for one clock cycle
        
        // Write test data to register 2
        waddr = 2;      // Write to register 2
        wdata = 8'hCC;  // Write data = 0xCC
        #20;            // Hold for one clock cycle
        
        // ========================================
        // Phase 4: Read Operations
        // ========================================
        // Read from two registers simultaneously
        we = 0;         // Disable write (read mode)
        raddr0 = 0;     // Read register 0
        raddr1 = 1;     // Read register 1
        #20;            // Wait for read to complete
        
        // Read from different register pair
        raddr0 = 2;     // Read register 2
        raddr1 = 3;     // Read register 3 (should be 0, not written)
        #20;            // Wait for read to complete
        
        // ========================================
        // Phase 5: Completion
        // ========================================
        // Allow time for checker to complete validation
        #100;           // Extra delay for final checks
        $finish;       // End simulation
    end

endmodule

/**
 * Monitor Module
 * 
 * Purpose: Observe and log all DUT activity
 * 
 * Responsibilities:
 * - Monitor write operations (address, data)
 * - Monitor read operations (addresses, data)
 * - Log transactions with timestamps
 * - Provide visibility into DUT behavior
 * 
 * This module acts as the "monitor" in UVM terminology, passively
 * observing signals and generating transaction logs. It does NOT
 * drive any signals or validate correctness (that's the checker's job).
 * 
 * Monitoring Strategy:
 * - Clock-synchronized monitoring (posedge clk)
 * - Separate handling for write vs read operations
 * - Detailed logging with formatted output
 * 
 * @param clk      Clock signal (for synchronization)
 * @param we       Write enable (indicates write operation)
 * @param waddr    Write address (monitored during writes)
 * @param wdata    Write data (monitored during writes)
 * @param raddr0   Read address 0 (monitored during reads)
 * @param raddr1   Read address 1 (monitored during reads)
 * @param rdata0   Read data 0 (monitored during reads)
 * @param rdata1   Read data 1 (monitored during reads)
 */
module register_file_monitor(
    input wire        clk,
    input wire        we,
    input wire [1:0]  waddr,
    input wire [7:0]  wdata,
    input wire [1:0]  raddr0,
    input wire [1:0]  raddr1,
    input wire [7:0]  rdata0,
    input wire [7:0]  rdata1
);

    /**
     * Monitor Process
     * 
     * Synchronized to positive clock edge to capture stable values.
     * Monitors both write and read operations on every clock cycle.
     * 
     * Monitoring Logic:
     * - If write enable is active: log write transaction
     * - Always log read transaction (dual-port read)
     * 
     * This provides complete visibility into all DUT activity.
     */
    always @(posedge clk) begin
        // Monitor write operations
        // Only log when write enable is active
        if (we) begin
            $display("[MONITOR] Time %0t: Write addr=%0d, data=0x%02h", 
                     $time, waddr, wdata);
        end
        
        // Monitor read operations
        // Always log reads (dual-port, both ports read every cycle)
        // Note: rdata0 and rdata1 are combinational outputs, so they
        // reflect the values at raddr0 and raddr1 immediately
        $display("[MONITOR] Time %0t: Read addr0=%0d -> data0=0x%02h, addr1=%0d -> data1=0x%02h",
                 $time, raddr0, rdata0, raddr1, rdata1);
    end

endmodule

/**
 * Checker Module
 * 
 * Purpose: Validate DUT outputs against expected values
 * 
 * Responsibilities:
 * - Track expected register values based on write operations
 * - Compare read outputs with expected values
 * - Detect and report mismatches
 * - Aggregate error statistics
 * 
 * This module acts as the "scoreboard" or "checker" in UVM terminology.
 * It maintains a reference model (expected register values) and compares
 * DUT outputs against this model.
 * 
 * Checking Strategy:
 * - Predictive checking: track writes to build expected state
 * - Reactive checking: compare reads against expected state
 * - Error counting: maintain statistics for test summary
 * 
 * @param clk      Clock signal (for synchronization)
 * @param we       Write enable (indicates write operation)
 * @param waddr    Write address (used to update expected values)
 * @param wdata    Write data (used to update expected values)
 * @param raddr0   Read address 0 (used to lookup expected value)
 * @param raddr1   Read address 1 (used to lookup expected value)
 * @param rdata0   Read data 0 (compared against expected)
 * @param rdata1   Read data 1 (compared against expected)
 */
module register_file_checker(
    input wire        clk,
    input wire        we,
    input wire [1:0]  waddr,
    input wire [7:0]  wdata,
    input wire [1:0]  raddr0,
    input wire [1:0]  raddr1,
    input wire [7:0]  rdata0,
    input wire [7:0]  rdata1
);

    // ========================================
    // Internal State
    // ========================================
    /**
     * Expected Register Values
     * 
     * This array maintains the expected state of all registers.
     * It's updated on write operations and used for read validation.
     * 
     * Index: register address (0-3)
     * Value: expected 8-bit register content
     */
    reg [7:0] expected_regs [0:3];
    
    /**
     * Error Counter
     * 
     * Tracks the number of mismatches detected during checking.
     * Used to generate final test summary.
     */
    integer error_count = 0;

    // ========================================
    // Expected Value Tracking
    // ========================================
    /**
     * Track Expected Register Values
     * 
     * This process maintains the reference model by tracking all write
     * operations. When a write occurs, we update our expected value
     * for that register address.
     * 
     * This is the "predictive" part of the checker - we predict what
     * the register should contain based on write operations.
     */
    always @(posedge clk) begin
        if (we) begin
            // Update expected value for the written register
            // This models the DUT's write behavior
            expected_regs[waddr] = wdata;
        end
    end

    // ========================================
    // Output Validation
    // ========================================
    /**
     * Check Read Values
     * 
     * This process validates read outputs by comparing them against
     * expected values. It checks both read ports independently.
     * 
     * Checking Logic:
     * - Lookup expected value for each read address
     * - Compare actual read data with expected value
     * - Report mismatches with detailed error messages
     * - Increment error counter on mismatch
     * 
     * Note: Uses !== (case equality) for 4-state logic comparison
     */
    always @(posedge clk) begin
        // Check read port 0
        if (rdata0 !== expected_regs[raddr0]) begin
            $error("[CHECKER] Time %0t: Read0 mismatch! Addr=%0d, Expected=0x%02h, Got=0x%02h",
                   $time, raddr0, expected_regs[raddr0], rdata0);
            error_count = error_count + 1;
        end
        
        // Check read port 1
        if (rdata1 !== expected_regs[raddr1]) begin
            $error("[CHECKER] Time %0t: Read1 mismatch! Addr=%0d, Expected=0x%02h, Got=0x%02h",
                   $time, raddr1, expected_regs[raddr1], rdata1);
            error_count = error_count + 1;
        end
    end

    // ========================================
    // Test Summary
    // ========================================
    /**
     * Final Check and Summary
     * 
     * After all test operations complete, this process generates
     * a summary of the test results. It waits for sufficient time
     * to ensure all checks have completed, then reports pass/fail.
     * 
     * Timing: Waits 300ns to ensure all test operations and checks complete
     */
    initial begin
        #300;  // Wait for all test operations to complete
        if (error_count == 0) begin
            $display("[CHECKER] All checks passed!");
        end else begin
            $display("[CHECKER] %0d errors found!", error_count);
        end
    end

endmodule

/**
 * Top-level Testbench Module
 * 
 * Purpose: Connect all testbench components together
 * 
 * This is the top-level module that instantiates and connects:
 * - Stimulus generator (drives inputs)
 * - DUT (design under test)
 * - Monitor (observes behavior)
 * - Checker (validates outputs)
 * 
 * Architecture:
 *   Stimulus → DUT → Monitor/Checker
 * 
 * All components are connected via wires, allowing signals to
 * flow from stimulus through DUT to monitor/checker.
 * 
 * This hierarchical structure enables:
 * - Clear separation of concerns
 * - Easy component replacement/modification
 * - Reusable testbench components
 */
module register_file_test_verilog;

    // ========================================
    // Signal Declarations
    // ========================================
    // All signals are wires because they're driven by modules
    // Clock and control signals
    wire        clk;      // Clock (driven by stimulus)
    wire        rst_n;    // Reset (driven by stimulus)
    wire        we;       // Write enable (driven by stimulus)
    
    // Write port signals
    wire [1:0]  waddr;    // Write address (driven by stimulus)
    wire [7:0]  wdata;    // Write data (driven by stimulus)
    
    // Read port signals
    wire [1:0]  raddr0;   // Read address 0 (driven by stimulus)
    wire [1:0]  raddr1;   // Read address 1 (driven by stimulus)
    wire [7:0]  rdata0;   // Read data 0 (driven by DUT)
    wire [7:0]  rdata1;   // Read data 1 (driven by DUT)

    // ========================================
    // Component Instantiation
    // ========================================
    /**
     * Stimulus Generator Instance
     * 
     * Generates all input signals to the DUT:
     * - Clock (continuous)
     * - Reset sequence
     * - Write/read operations
     */
    register_file_stimulus stim (
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr0(raddr0),
        .raddr1(raddr1)
    );

    /**
     * Design Under Test (DUT) Instance
     * 
     * The register file being verified.
     * Receives inputs from stimulus, produces outputs to monitor/checker.
     */
    register_file dut (
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr0(raddr0),
        .raddr1(raddr1),
        .rdata0(rdata0),
        .rdata1(rdata1)
    );

    /**
     * Monitor Instance
     * 
     * Observes all DUT activity and logs transactions.
     * Does not drive any signals (passive observation only).
     */
    register_file_monitor mon (
        .clk(clk),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr0(raddr0),
        .raddr1(raddr1),
        .rdata0(rdata0),
        .rdata1(rdata1)
    );

    /**
     * Checker Instance
     * 
     * Validates DUT outputs against expected values.
     * Maintains reference model and compares actual vs expected.
     */
    register_file_checker chk (
        .clk(clk),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr0(raddr0),
        .raddr1(raddr1),
        .rdata0(rdata0),
        .rdata1(rdata1)
    );

    // ========================================
    // Waveform Generation
    // ========================================
    /**
     * VCD File Generation
     * 
     * Creates a Value Change Dump (VCD) file for waveform analysis.
     * This file can be viewed in GTKWave or other waveform viewers.
     * 
     * $dumpfile: Specifies output filename
     * $dumpvars(0, ...): Dumps all variables in the specified scope
     *   - 0 = dump all levels of hierarchy
     *   - register_file_test_verilog = top-level module name
     */
    initial begin
        $dumpfile("register_file_test.vcd");
        $dumpvars(0, register_file_test_verilog);
    end

endmodule
