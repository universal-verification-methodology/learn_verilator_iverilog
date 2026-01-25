/**
 * Configurable Clock and Reset Generation - C++
 * 
 * This example demonstrates professional clock and reset generation patterns
 * in C++ testbenches. It shows how to create configurable, reusable clock
 * and reset generators using C++ classes.
 * 
 * Learning Objectives:
 * - Understand clock generation patterns in C++
 * - Learn configurable clock period implementation
 * - Master multiple clock domain handling
 * - Understand reset sequence timing
 * - Learn clock and reset coordination
 * 
 * UVM Pattern Inspiration:
 * Clock and reset generation is fundamental to all verification environments.
 * In UVM, this is typically handled by:
 * - Clock generators (virtual sequences or clocking blocks)
 * - Reset agents (reset sequences)
 * 
 * This example shows the C++ equivalent patterns using classes.
 * 
 * Key Concepts:
 * - Class-based design: Encapsulated clock/reset generators
 * - Configurable periods: Runtime or compile-time configuration
 * - State management: Track clock state and reset timing
 * - Multiple clocks: Independent clock domain handling
 * 
 * Note: This is a standalone example (not using Verilator) to demonstrate
 * the clock/reset generation concepts without DUT complexity.
 * 
 * Compilation and Execution:
 *   g++ -o configurable_clock_reset configurable_clock_reset_cpp.cpp
 *   ./configurable_clock_reset
 * 
 * Usage:
 *   g++ -o configurable_clock_reset configurable_clock_reset_cpp.cpp
 *   ./configurable_clock_reset
 */

#include <iostream>  // Standard I/O (cout, cerr, endl)
#include <iomanip>   // I/O manipulators (fixed, setprecision)
#include <cstdint>   // Standard integer types (uint64_t)

/**
 * Clock Generator Class
 * 
 * Purpose: Generate clock signals with configurable periods
 * 
 * This class encapsulates clock generation logic, allowing multiple
 * independent clocks to be created with different periods.
 * 
 * Design Pattern:
 * - Encapsulation: Clock state and timing logic hidden
 * - Configurability: Period set via constructor
 * - State tracking: Maintains current clock state and timing
 */
class ClockGenerator {
private:
    int period_ns;        // Clock period in nanoseconds
    bool state;           // Current clock state (false = low, true = high)
    uint64_t next_edge_time;  // Internal time tracking for edge generation
    
public:
    /**
     * Constructor
     * 
     * Initializes clock generator with specified period.
     * 
     * @param period  Clock period in nanoseconds
     */
    ClockGenerator(int period) : period_ns(period), state(false), next_edge_time(0) {}
    
    /**
     * Tick Clock
     * 
     * Advances clock generation based on simulation time.
     * Toggles clock state when half period has elapsed.
     * 
     * @param sim_time  Current simulation time (reference, may be updated)
     * @return          true if clock edge occurred, false otherwise
     */
    bool tick(uint64_t& sim_time) {
        next_edge_time += period_ns / 2;  // Advance by half period
        if (next_edge_time >= sim_time) {
            state = !state;      // Toggle clock state
            next_edge_time = sim_time;     // Reset internal time
            return true;         // Clock edge occurred
        }
        return false;            // No edge this cycle
    }
    
    /**
     * Get Clock State
     * 
     * Returns current clock state (high or low).
     * 
     * @return  true if clock is high, false if low
     */
    bool get_state() const { return state; }
    
    /**
     * Get Clock Period
     * 
     * Returns the configured clock period.
     * 
     * @return  Clock period in nanoseconds
     */
    int get_period() const { return period_ns; }
};

/**
 * Reset Generator Class
 * 
 * Purpose: Generate reset sequences with configurable timing
 * 
 * This class encapsulates reset generation logic, allowing reset
 * to be asserted, held, and released with precise timing control.
 * 
 * Design Pattern:
 * - State machine: Tracks reset state (inactive, active, released)
 * - Timing control: Configurable reset duration
 * - Event detection: Can detect when reset is released
 */
class ResetGenerator {
private:
    uint64_t reset_duration;  // Duration to hold reset (nanoseconds)
    uint64_t reset_start;     // Time when reset was asserted
    bool active;                // Whether reset is currently active
    
public:
    /**
     * Constructor
     * 
     * Initializes reset generator with specified duration.
     * 
     * @param duration  Reset duration in nanoseconds
     */
    ResetGenerator(uint64_t duration) : reset_duration(duration), reset_start(0), active(false) {}
    
    /**
     * Start Reset
     * 
     * Asserts reset and records the start time.
     * 
     * @param sim_time  Current simulation time
     */
    void start(uint64_t sim_time) {
        reset_start = sim_time;
        active = true;
    }
    
    /**
     * Check if Reset is Active
     * 
     * Returns true if reset is currently active (within duration).
     * Automatically deactivates when duration expires.
     * 
     * @param sim_time  Current simulation time
     * @return          true if reset is active, false otherwise
     */
    bool is_active(uint64_t sim_time) {
        if (active && (sim_time - reset_start) < reset_duration) {
            return true;  // Reset still active
        }
        active = false;   // Reset duration expired
        return false;     // Reset inactive
    }
    
    /**
     * Check if Reset was Just Released
     * 
     * Returns true if reset was active and has just been released
     * (duration just expired). Useful for detecting reset release events.
     * 
     * @param sim_time  Current simulation time
     * @return          true if reset was just released, false otherwise
     */
    bool was_released(uint64_t sim_time) {
        return active && (sim_time - reset_start) >= reset_duration;
    }
};

/**
 * Main Function
 * 
 * Entry point for the clock/reset generation example.
 * Demonstrates:
 * - Creating multiple clock generators
 * - Creating reset generator
 * - Running simulation loop
 * - Monitoring clock edges and reset events
 * 
 * @return  Exit code (0 = success)
 */
int main() {
    // Print header
    std::cout << "========================================" << std::endl;
    std::cout << "Configurable Clock and Reset Example" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================
    // Configuration Parameters
    // ========================================
    /**
     * Clock and Reset Parameters
     * 
     * These constants define the timing characteristics.
     * In a real testbench, these could be:
     * - Command-line arguments
     * - Configuration file parameters
     * - Environment variables
     */
    const int CLK_PERIOD_1 = 20;        // Clock 1 period: 20ns = 50MHz
    const int CLK_PERIOD_2 = 40;        // Clock 2 period: 40ns = 25MHz
    const uint64_t RST_DURATION = 100; // Reset duration: 100ns
    
    // Print configuration
    std::cout << "Clock 1 period: " << CLK_PERIOD_1 << " ns (" 
              << std::fixed << std::setprecision(1) << 1000.0/CLK_PERIOD_1 << " MHz)" << std::endl;
    std::cout << "Clock 2 period: " << CLK_PERIOD_2 << " ns (" 
              << 1000.0/CLK_PERIOD_2 << " MHz)" << std::endl;
    std::cout << "Reset duration: " << RST_DURATION << " ns" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================
    // Component Creation
    // ========================================
    // Create clock generators with different periods
    ClockGenerator clk1(CLK_PERIOD_1);
    ClockGenerator clk2(CLK_PERIOD_2);
    
    // Create reset generator
    ResetGenerator rst(RST_DURATION);
    
    // ========================================
    // Simulation Setup
    // ========================================
    uint64_t sim_time = 0;  // Simulation time counter
    
    // Previous state tracking (for edge detection)
    bool clk1_prev = false;
    bool clk2_prev = false;
    bool rst_prev = true;
    
    // Start reset sequence
    rst.start(sim_time);
    std::cout << "Time " << sim_time << ": Reset asserted" << std::endl;
    
    // ========================================
    // Simulation Loop
    // ========================================
    /**
     * Main Simulation Loop
     * 
     * This loop simulates time progression and updates all components.
     * In a real Verilator testbench, this would also call dut->eval().
     * 
     * Loop Structure:
     * 1. Advance simulation time
     * 2. Update clock generators
     * 3. Check reset status
     * 4. Monitor events (clock edges, reset release)
     */
    while (sim_time < 600) {
        sim_time++;  // Advance simulation time
        
        // Update clock generators
        // These return true when a clock edge occurs
        bool clk1_edge = clk1.tick(sim_time);
        bool clk2_edge = clk2.tick(sim_time);
        
        // Check reset status
        bool rst_active = rst.is_active(sim_time);
        
        // Detect reset release event
        if (rst.was_released(sim_time)) {
            std::cout << "Time " << sim_time << ": Reset released" << std::endl;
        }
        
        // Monitor clock 1 positive edges
        // Only log when edge occurs AND clock is high (positive edge)
        if (clk1_edge && clk1.get_state()) {
            std::cout << "Time " << sim_time << ": Clock 1 posedge" << std::endl;
        }
        
        // Monitor clock 2 positive edges
        if (clk2_edge && clk2.get_state()) {
            std::cout << "Time " << sim_time << ": Clock 2 posedge" << std::endl;
        }
    }
    
    // ========================================
    // Simulation Completion
    // ========================================
    std::cout << "========================================" << std::endl;
    std::cout << "Simulation completed" << std::endl;
    std::cout << "========================================" << std::endl;
    
    return 0;
}
