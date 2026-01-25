/**
 * Modular Testbench Architecture Example - C++
 * 
 * Demonstrates:
 * - Modular design principles
 * - Reusability strategies
 * - Configurability
 * - Maintainability
 * - Scalability
 * 
 * This example shows a well-structured testbench following best practices.
 * 
 * Usage:
 *   verilator --cc --exe --build -I../../dut/multiplexers ../../dut/multiplexers/mux_4to1.v modular_testbench_cpp.cpp
 *   ./obj_dir/Vmux_4to1
 */

#include <iostream>
#include <fstream>
#include <iomanip>
#include <verilated.h>
#include "Vmux_4to1.h"

// ============================================================================
// Clock Generator Class (Reusable)
// ============================================================================
class ClockGenerator {
private:
    int period_ns;
    vluint64_t sim_time;
    bool clk_state;
    
public:
    ClockGenerator(int period = 20) : period_ns(period), sim_time(0), clk_state(false) {}
    
    bool get_clock() const { return clk_state; }
    
    void tick() {
        sim_time++;
        if ((sim_time % (period_ns / 2)) == 0) {
            clk_state = !clk_state;
        }
    }
    
    vluint64_t get_time() const { return sim_time; }
};

// ============================================================================
// Reset Generator Class (Reusable)
// ============================================================================
class ResetGenerator {
private:
    int reset_duration;
    vluint64_t sim_time;
    
public:
    ResetGenerator(int duration = 100) : reset_duration(duration), sim_time(0) {}
    
    bool is_reset_active(vluint64_t current_time) const {
        return current_time < reset_duration;
    }
    
    void update_time(vluint64_t time) { sim_time = time; }
};

// ============================================================================
// Stimulus Generator Class (Reusable)
// ============================================================================
class StimulusGenerator {
private:
    int num_tests;
    int test_count;
    bool valid;
    bool done;
    
public:
    StimulusGenerator(int tests = 16) : num_tests(tests), test_count(0), valid(false), done(false) {}
    
    void generate(bool rst_n, uint8_t& sel, uint8_t& inputs) {
        if (!rst_n) {
            test_count = 0;
            valid = false;
            done = false;
            sel = 0;
            inputs = 0;
        } else {
            if (test_count < num_tests) {
                valid = true;
                sel = test_count & 0x3;
                inputs = test_count & 0xF;
                test_count++;
            } else {
                valid = false;
                done = true;
            }
        }
    }
    
    bool is_valid() const { return valid; }
    bool is_done() const { return done; }
};

// ============================================================================
// Monitor Class (Reusable)
// ============================================================================
class Monitor {
private:
    std::ofstream log_file;
    
public:
    Monitor(const std::string& filename = "monitor.log") {
        log_file.open(filename);
        if (log_file.is_open()) {
            log_file << "Time\tSel\tInputs\tOut\tValid\n";
        } else {
            std::cerr << "Failed to open log file: " << filename << std::endl;
        }
    }
    
    ~Monitor() {
        if (log_file.is_open()) {
            log_file.close();
            std::cout << "Monitor log written to: monitor.log" << std::endl;
        }
    }
    
    void log(vluint64_t time, uint8_t sel, uint8_t inputs, uint8_t out, bool valid) {
        if (log_file.is_open() && valid) {
            log_file << time << "\t" << (int)sel << "\t" << (int)inputs 
                     << "\t" << (int)out << "\t" << valid << "\n";
            std::cout << "[MONITOR] t=" << time << ": sel=" << (int)sel 
                      << ", inputs=" << (int)inputs << ", out=" << (int)out << std::endl;
        }
    }
};

// ============================================================================
// Checker Class (Reusable)
// ============================================================================
class Checker {
private:
    bool error_flag;
    
public:
    Checker() : error_flag(false) {}
    
    bool check(bool rst_n, bool valid, uint8_t sel, uint8_t inputs, uint8_t out) {
        if (rst_n && valid) {
            uint8_t expected = 0;
            switch (sel) {
                case 0: expected = inputs & 0x1; break;
                case 1: expected = (inputs >> 1) & 0x1; break;
                case 2: expected = (inputs >> 2) & 0x1; break;
                case 3: expected = (inputs >> 3) & 0x1; break;
            }
            
            if (out != expected) {
                error_flag = true;
                std::cerr << "[CHECKER] Mismatch: sel=" << (int)sel 
                          << ", inputs=" << (int)inputs 
                          << ", out=" << (int)out 
                          << ", expected=" << (int)expected << std::endl;
                return false;
            }
        }
        return true;
    }
    
    bool has_error() const { return error_flag; }
    void reset() { error_flag = false; }
};

// ============================================================================
// Scoreboard Class (Reusable)
// ============================================================================
class Scoreboard {
private:
    int pass_count;
    int fail_count;
    int total_tests;
    
public:
    Scoreboard() : pass_count(0), fail_count(0), total_tests(0) {}
    
    void record(bool error) {
        total_tests++;
        if (error) {
            fail_count++;
        } else {
            pass_count++;
        }
    }
    
    void print_summary() {
        std::cout << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Scoreboard Summary" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Total tests:  " << total_tests << std::endl;
        std::cout << "Passed:       " << pass_count << std::endl;
        std::cout << "Failed:       " << fail_count << std::endl;
        if (total_tests > 0) {
            std::cout << "Pass rate:    " << std::fixed << std::setprecision(1) 
                      << (pass_count * 100.0 / total_tests) << "%" << std::endl;
        }
        std::cout << "========================================" << std::endl;
    }
};

// ============================================================================
// Main Testbench
// ============================================================================
int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Modular Testbench Architecture Example (C++)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Configuration parameters
    const int CLOCK_PERIOD = 20;
    const int RESET_DURATION = 100;
    const int NUM_TESTS = 16;
    
    // Create DUT instance
    Vmux_4to1* dut = new Vmux_4to1;
    
    // Create reusable components
    ClockGenerator clk_gen(CLOCK_PERIOD);
    ResetGenerator rst_gen(RESET_DURATION);
    StimulusGenerator stim_gen(NUM_TESTS);
    Monitor monitor("monitor.log");
    Checker checker;
    Scoreboard scoreboard;
    
    // Simulation variables
    vluint64_t sim_time = 0;
    bool rst_n = true;  // No reset needed for combinational mux
    uint8_t sel = 0;
    uint8_t inputs = 0;
    
    // Simulation loop
    while (sim_time < 1000) {
        // Generate stimulus (no clock/reset needed for combinational mux)
        stim_gen.generate(rst_n, sel, inputs);
        dut->sel = sel;
        dut->in0 = (inputs >> 0) & 0x1;
        dut->in1 = (inputs >> 1) & 0x1;
        dut->in2 = (inputs >> 2) & 0x1;
        dut->in3 = (inputs >> 3) & 0x1;
        
        // Evaluate DUT (combinational, no clock needed)
        dut->eval();
        
        // Small delay to allow combinational propagation
        sim_time += 5;
        
        // Monitor and check (always check for combinational logic)
        if (stim_gen.is_valid()) {
            monitor.log(sim_time, sel, inputs, dut->out, true);
            
            // Check
            bool error = !checker.check(rst_n, true, sel, inputs, dut->out);
            scoreboard.record(error);
        }
        
        // Check completion
        if (stim_gen.is_done()) {
            break;
        }
    }
    
    // Print summary
    scoreboard.print_summary();
    
    dut->final();
    delete dut;
    
    return 0;
}
