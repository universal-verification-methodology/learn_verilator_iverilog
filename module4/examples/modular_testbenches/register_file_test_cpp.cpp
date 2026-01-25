/**
 * Modular Register File C++ Testbench
 * 
 * This testbench demonstrates the UVM-inspired separation of concerns pattern
 * using C++ classes. The testbench is organized into distinct, reusable components:
 * - Stimulus Class: Drives inputs to the DUT
 * - Monitor Class: Observes and logs DUT behavior
 * - Checker Class: Validates DUT outputs against expected values
 * 
 * Learning Objectives:
 * - Understand class-based testbench architecture
 * - Learn separation of concerns in C++ verification
 * - Master Verilator testbench organization patterns
 * - Understand stimulus generation in C++
 * - Learn monitoring and checking strategies
 * 
 * UVM Pattern Inspiration:
 * This structure mirrors UVM's agent architecture:
 * - Driver (Stimulus): Generates and applies test vectors
 * - Monitor: Observes transactions and signals
 * - Scoreboard/Checker: Validates correctness
 * 
 * While this uses Verilator (not SystemVerilog/UVM), the principles
 * of separation of concerns and modularity are the same.
 * 
 * Testbench Structure:
 *   Main Function
 *   ├── Stimulus Class
 *   │   └── Methods to generate clock, reset, and test vectors
 *   ├── DUT Instance (Vregister_file)
 *   │   └── Verilator-generated class representing the design
 *   ├── Monitor Class
 *   │   └── Methods to observe and log transactions
 *   └── Checker Class
 *       └── Methods to validate outputs against expected values
 * 
 * Compilation and Execution:
 *   verilator --cc --exe --build -I../../dut/registers ../../dut/registers/register_file.v register_file_test_cpp.cpp
 *   ./obj_dir/Vregister_file
 * 
 * Expected Output:
 *   - Monitor messages showing write/read operations
 *   - Checker messages indicating pass/fail status
 *   - Final test summary
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/registers ../../dut/registers/register_file.v register_file_test_cpp.cpp
 *   ./obj_dir/Vregister_file
 */

#include <iostream>        // Standard I/O (cout, cerr, endl)
#include <cassert>         // Assertions (for debugging)
#include <iomanip>         // I/O manipulators (hex, setw, etc.)
#include <verilated.h>     // Verilator base library
#include "Vregister_file.h" // Verilator-generated DUT class

/**
 * Stimulus Class
 * 
 * Purpose: Generate all input signals to the DUT
 * 
 * Responsibilities:
 * - Clock generation (via tick_clock method)
 * - Reset sequence (assert, hold, release)
 * - Test vector generation (write/read operations)
 * - Timing control (clock cycles between operations)
 * 
 * This class acts as the "driver" in UVM terminology, applying
 * stimulus to the DUT according to the test plan.
 * 
 * Design Pattern:
 * - Public methods: High-level operations (reset, write, read)
 * - Private methods: Low-level utilities (clock ticking)
 * - Encapsulation: Internal clock logic hidden from users
 */
class Stimulus {
public:
    /**
     * Apply Reset Sequence
     * 
     * Asserts reset and initializes all signals to known state.
     * Holds reset for multiple clock cycles to ensure proper reset.
     * 
     * @param dut       Pointer to DUT instance
     * @param sim_time  Reference to simulation time counter (updated)
     * 
     * Reset Sequence:
     * 1. Assert reset (rst_n = 0)
     * 2. Clear all control signals
     * 3. Tick clock for 3 cycles (ensures reset propagates)
     */
    void apply_reset(Vregister_file* dut, vluint64_t& sim_time) {
        dut->rst_n = 0;     // Assert reset (active low)
        dut->we = 0;        // Write enable off
        dut->waddr = 0;     // Write address = 0
        dut->wdata = 0;     // Write data = 0
        dut->raddr0 = 0;    // Read address 0 = 0
        dut->raddr1 = 0;    // Read address 1 = 0
        tick_clock(dut, sim_time, 3);  // Hold reset for 3 clock cycles
    }
    
    /**
     * Release Reset
     * 
     * Deasserts reset and allows design to operate normally.
     * Waits a few cycles for design to stabilize.
     * 
     * @param dut       Pointer to DUT instance
     * @param sim_time  Reference to simulation time counter (updated)
     */
    void release_reset(Vregister_file* dut, vluint64_t& sim_time) {
        dut->rst_n = 1;     // Deassert reset
        tick_clock(dut, sim_time, 2);  // Wait 2 cycles for stabilization
    }
    
    /**
     * Write Register Operation
     * 
     * Performs a write operation to the register file.
     * Sets write enable, address, and data, then ticks clock.
     * 
     * @param dut       Pointer to DUT instance
     * @param sim_time  Reference to simulation time counter (updated)
     * @param addr      Register address to write (0-3)
     * @param data      Data value to write (8 bits)
     */
    void write_register(Vregister_file* dut, vluint64_t& sim_time, 
                       uint8_t addr, uint8_t data) {
        dut->we = 1;        // Enable write
        dut->waddr = addr;  // Set write address
        dut->wdata = data;  // Set write data
        tick_clock(dut, sim_time, 1);  // Tick clock to complete write
    }
    
    /**
     * Read Registers Operation
     * 
     * Performs a read operation from the register file.
     * Sets read addresses and disables write, then ticks clock.
     * 
     * @param dut       Pointer to DUT instance
     * @param sim_time  Reference to simulation time counter (updated)
     * @param addr0     Register address for read port 0 (0-3)
     * @param addr1     Register address for read port 1 (0-3)
     */
    void read_registers(Vregister_file* dut, vluint64_t& sim_time,
                       uint8_t addr0, uint8_t addr1) {
        dut->we = 0;        // Disable write (read mode)
        dut->raddr0 = addr0; // Set read address 0
        dut->raddr1 = addr1; // Set read address 1
        tick_clock(dut, sim_time, 1);  // Tick clock (read is combinational, but we tick for consistency)
    }
    
private:
    /**
     * Tick Clock
     * 
     * Internal utility method to generate clock edges.
     * Toggles clock and evaluates DUT for specified number of cycles.
     * 
     * Clock Generation Pattern:
     * - Set clock low, evaluate DUT
     * - Set clock high, evaluate DUT
     * - Repeat for specified cycles
     * 
     * @param dut       Pointer to DUT instance
     * @param sim_time  Reference to simulation time counter (updated)
     * @param cycles    Number of clock cycles to generate
     */
    void tick_clock(Vregister_file* dut, vluint64_t& sim_time, int cycles) {
        for (int i = 0; i < cycles; i++) {
            // Clock low phase
            dut->clk = 0;
            dut->eval();      // Evaluate DUT at falling edge
            sim_time++;       // Increment simulation time
            
            // Clock high phase
            dut->clk = 1;
            dut->eval();      // Evaluate DUT at rising edge
            sim_time++;       // Increment simulation time
        }
    }
};

/**
 * Monitor Class
 * 
 * Purpose: Observe and log all DUT activity
 * 
 * Responsibilities:
 * - Monitor write operations (address, data)
 * - Monitor read operations (addresses, data)
 * - Log transactions with timestamps
 * - Provide visibility into DUT behavior
 * 
 * This class acts as the "monitor" in UVM terminology, passively
 * observing signals and generating transaction logs. It does NOT
 * drive any signals or validate correctness (that's the checker's job).
 * 
 * Design Pattern:
 * - Stateless: No internal state, just logging functions
 * - Passive: Only observes, never drives signals
 * - Formatted output: Human-readable transaction logs
 */
class Monitor {
public:
    /**
     * Monitor Write Operation
     * 
     * Logs a write transaction with timestamp, address, and data.
     * 
     * @param sim_time  Current simulation time
     * @param addr      Write address
     * @param data      Write data value
     */
    void monitor_write(vluint64_t sim_time, uint8_t addr, uint8_t data) {
        std::cout << "[MONITOR] Time " << sim_time 
                  << ": Write addr=" << (int)addr 
                  << ", data=0x" << std::hex << (int)data << std::dec << std::endl;
    }
    
    /**
     * Monitor Read Operation
     * 
     * Logs a read transaction with timestamp, addresses, and data values.
     * Handles dual-port reads (both ports read simultaneously).
     * 
     * @param sim_time  Current simulation time
     * @param addr0     Read address for port 0
     * @param data0     Read data from port 0
     * @param addr1     Read address for port 1
     * @param data1     Read data from port 1
     */
    void monitor_read(vluint64_t sim_time, uint8_t addr0, uint8_t data0,
                     uint8_t addr1, uint8_t data1) {
        std::cout << "[MONITOR] Time " << sim_time 
                  << ": Read addr0=" << (int)addr0 << " -> data0=0x" << std::hex << (int)data0
                  << ", addr1=" << (int)addr1 << " -> data1=0x" << (int)data1 << std::dec << std::endl;
    }
};

/**
 * Checker Class
 * 
 * Purpose: Validate DUT outputs against expected values
 * 
 * Responsibilities:
 * - Track expected register values based on write operations
 * - Compare read outputs with expected values
 * - Detect and report mismatches
 * - Aggregate error statistics
 * 
 * This class acts as the "scoreboard" or "checker" in UVM terminology.
 * It maintains a reference model (expected register values) and compares
 * DUT outputs against this model.
 * 
 * Checking Strategy:
 * - Predictive checking: track writes to build expected state
 * - Reactive checking: compare reads against expected state
 * - Error counting: maintain statistics for test summary
 * 
 * Design Pattern:
 * - Stateful: Maintains expected register values
 * - Encapsulation: Error count accessed via getter
 * - Return values: Methods return pass/fail status
 */
class Checker {
private:
    /**
     * Expected Register Values
     * 
     * This array maintains the expected state of all registers.
     * It's updated on write operations and used for read validation.
     * 
     * Index: register address (0-3)
     * Value: expected 8-bit register content
     */
    uint8_t expected_regs[4];
    
    /**
     * Error Counter
     * 
     * Tracks the number of mismatches detected during checking.
     * Used to generate final test summary.
     */
    int error_count;
    
public:
    /**
     * Constructor
     * 
     * Initializes the checker with all registers set to zero
     * and error count set to zero.
     */
    Checker() : error_count(0) {
        for (int i = 0; i < 4; i++) {
            expected_regs[i] = 0;
        }
    }
    
    /**
     * Track Write Operation
     * 
     * Updates the expected register value based on a write operation.
     * This is the "predictive" part of the checker - we predict what
     * the register should contain based on write operations.
     * 
     * @param addr  Register address that was written
     * @param data  Data value that was written
     */
    void track_write(uint8_t addr, uint8_t data) {
        expected_regs[addr] = data;
    }
    
    /**
     * Check Read Operation
     * 
     * Validates read outputs by comparing them against expected values.
     * Checks both read ports independently.
     * 
     * @param sim_time  Current simulation time (for error messages)
     * @param addr0     Read address for port 0
     * @param data0     Actual read data from port 0
     * @param addr1     Read address for port 1
     * @param data1     Actual read data from port 1
     * @return          true if all checks pass, false otherwise
     */
    bool check_read(vluint64_t sim_time, uint8_t addr0, uint8_t data0,
                   uint8_t addr1, uint8_t data1) {
        bool pass = true;
        
        // Check read port 0
        if (data0 != expected_regs[addr0]) {
            std::cerr << "[CHECKER] Time " << sim_time 
                      << ": Read0 mismatch! Addr=" << (int)addr0 
                      << ", Expected=0x" << std::hex << (int)expected_regs[addr0]
                      << ", Got=0x" << (int)data0 << std::dec << std::endl;
            error_count++;
            pass = false;
        }
        
        // Check read port 1
        if (data1 != expected_regs[addr1]) {
            std::cerr << "[CHECKER] Time " << sim_time 
                      << ": Read1 mismatch! Addr=" << (int)addr1 
                      << ", Expected=0x" << std::hex << (int)expected_regs[addr1]
                      << ", Got=0x" << (int)data1 << std::dec << std::endl;
            error_count++;
            pass = false;
        }
        
        return pass;
    }
    
    /**
     * Get Error Count
     * 
     * Returns the total number of errors detected during checking.
     * Used to determine overall test pass/fail status.
     * 
     * @return  Number of errors detected
     */
    int get_error_count() const { return error_count; }
};

/**
 * Main Function
 * 
 * Entry point for the testbench. Orchestrates the test sequence:
 * 1. Initialize Verilator and create components
 * 2. Apply reset sequence
 * 3. Execute write operations
 * 4. Execute read operations
 * 5. Generate test summary
 * 
 * @param argc  Argument count (from command line)
 * @param argv  Argument vector (command line arguments)
 * @return      Exit code (0 = pass, 1 = fail)
 */
int main(int argc, char** argv) {
    // Initialize Verilator with command-line arguments
    // This processes any Verilator-specific options (e.g., --trace, --coverage)
    Verilated::commandArgs(argc, argv);
    
    // Print test header
    std::cout << "========================================" << std::endl;
    std::cout << "Modular Register File C++ Testbench" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================
    // Component Creation
    // ========================================
    // Create DUT instance (Verilator-generated class)
    Vregister_file* dut = new Vregister_file;
    
    // Create testbench components
    Stimulus stim;  // Stimulus generator
    Monitor mon;    // Transaction monitor
    Checker chk;    // Output checker
    
    // Simulation time counter (tracks simulation progress)
    vluint64_t sim_time = 0;
    
    // Initialize clock to known state
    dut->clk = 0;
    
    // ========================================
    // Test Sequence
    // ========================================
    
    // Phase 1: Reset Sequence
    stim.apply_reset(dut, sim_time);    // Assert and hold reset
    stim.release_reset(dut, sim_time);   // Release reset
    
    // Phase 2: Write Operations
    // Write test data to multiple registers
    stim.write_register(dut, sim_time, 0, 0xAA);
    chk.track_write(0, 0xAA);           // Update checker's expected values
    mon.monitor_write(sim_time, 0, 0xAA); // Log the write transaction
    
    stim.write_register(dut, sim_time, 1, 0xBB);
    chk.track_write(1, 0xBB);
    mon.monitor_write(sim_time, 1, 0xBB);
    
    stim.write_register(dut, sim_time, 2, 0xCC);
    chk.track_write(2, 0xCC);
    mon.monitor_write(sim_time, 2, 0xCC);
    
    // Phase 3: Read Operations
    // Read from register pairs and validate
    stim.read_registers(dut, sim_time, 0, 1);
    mon.monitor_read(sim_time, 0, dut->rdata0, 1, dut->rdata1);
    chk.check_read(sim_time, 0, dut->rdata0, 1, dut->rdata1);
    
    stim.read_registers(dut, sim_time, 2, 3);
    mon.monitor_read(sim_time, 2, dut->rdata0, 3, dut->rdata1);
    chk.check_read(sim_time, 2, dut->rdata0, 3, dut->rdata1);
    
    // ========================================
    // Test Summary
    // ========================================
    std::cout << "========================================" << std::endl;
    if (chk.get_error_count() == 0) {
        std::cout << "[CHECKER] All checks passed!" << std::endl;
    } else {
        std::cout << "[CHECKER] " << chk.get_error_count() << " errors found!" << std::endl;
    }
    std::cout << "========================================" << std::endl;
    
    // ========================================
    // Cleanup
    // ========================================
    // Call final() before deletion to:
    // - Close any open files (traces, coverage, etc.)
    // - Finalize statistics
    // - Perform final cleanup
    dut->final();
    delete dut;
    
    // Return exit code: 0 = pass, 1 = fail
    return (chk.get_error_count() == 0) ? 0 : 1;
}
