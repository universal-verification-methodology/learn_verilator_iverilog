/**
 * Modular Testbench Architecture - C++ (Verilator)
 * 
 * This testbench demonstrates best practices for modular testbench design:
 * - Modular design principles
 * - Reusability strategies
 * - Configurability
 * - Maintainability
 * - Scalability
 * 
 * Usage:
 *   make modular_testbench
 *   or
 *   verilator --cc --exe --build -I../../../module8/dut/multiplexers \
 *            ../../../module8/dut/multiplexers/mux_4to1.v modular_testbench.cpp
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
    
public:
    ResetGenerator(int duration = 100) : reset_duration(duration) {}
    
    bool is_reset_active(vluint64_t current_time) const {
        return current_time < reset_duration;
    }
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
    StimulusGenerator(int tests = 4) : num_tests(tests), test_count(0), valid(false), done(false) {}
    
    void generate(bool rst_n, uint8_t& sel, uint8_t& in0, uint8_t& in1, uint8_t& in2, uint8_t& in3) {
        if (!rst_n) {
            test_count = 0;
            valid = false;
            done = false;
            sel = 0;
            in0 = in1 = in2 = in3 = 0;
        } else {
            if (test_count < num_tests) {
                valid = true;
            sel = test_count & 0x3;
            // Set selected input to 1, others to 0
            in0 = (test_count == 0) ? 1 : 0;
            in1 = (test_count == 1) ? 1 : 0;
            in2 = (test_count == 2) ? 1 : 0;
            in3 = (test_count == 3) ? 1 : 0;
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
        if (!log_file.is_open()) {
            std::cerr << "Error: Failed to open log file" << std::endl;
        }
    }
    
    ~Monitor() {
        if (log_file.is_open()) {
            log_file.close();
        }
    }
    
    void log(vluint64_t time, uint8_t sel, uint8_t in0, uint8_t in1, 
             uint8_t in2, uint8_t in3, uint8_t out, bool valid) {
        if (valid && log_file.is_open()) {
            log_file << "Time " << time << ": sel=" << (int)sel 
                     << ", in0=" << (int)in0 << ", in1=" << (int)in1 
                     << ", in2=" << (int)in2 << ", in3=" << (int)in3 
                     << ", out=" << (int)out << std::endl;
        }
    }
};

// ============================================================================
// Checker Class (Reusable)
// ============================================================================
class Checker {
private:
    int pass_count;
    int fail_count;
    
public:
    Checker() : pass_count(0), fail_count(0) {}
    
    bool check(uint8_t sel, uint8_t in0, uint8_t in1, uint8_t in2, 
               uint8_t in3, uint8_t out) {
        uint8_t expected;
        switch (sel) {
            case 0: expected = in0; break;
            case 1: expected = in1; break;
            case 2: expected = in2; break;
            case 3: expected = in3; break;
            default: expected = 0; break;
        }
        
        if (out == expected) {
            pass_count++;
            return true;
        } else {
            fail_count++;
            std::cerr << "[ERROR] Checker failed: sel=" << (int)sel 
                      << ", out=" << (int)out 
                      << ", expected=" << (int)expected << std::endl;
            return false;
        }
    }
    
    int get_pass_count() const { return pass_count; }
    int get_fail_count() const { return fail_count; }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Modular Testbench Architecture (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create reusable components
    ClockGenerator clk_gen(20);
    ResetGenerator rst_gen(100);
    StimulusGenerator stim_gen(4);
    Monitor monitor("monitor.log");
    Checker checker;
    
    // Create DUT instance
    Vmux_4to1* dut = new Vmux_4to1;
    
    // Simulation variables
    vluint64_t sim_time = 0;
    uint8_t sel, in0, in1, in2, in3;
    bool rst_n;
    
    // Initialize (mux is combinational, no clk/rst_n)
    dut->sel = 0;
    dut->in0 = dut->in1 = dut->in2 = dut->in3 = 0;
    dut->eval();
    
    // Simulation loop
    while (sim_time < 500) {
        // Update clock (for testbench timing, not DUT)
        clk_gen.tick();
        
        // Update reset (for testbench control, not DUT)
        rst_n = !rst_gen.is_reset_active(sim_time);
        
        // Generate stimulus
        stim_gen.generate(rst_n, sel, in0, in1, in2, in3);
        dut->sel = sel;
        dut->in0 = in0;
        dut->in1 = in1;
        dut->in2 = in2;
        dut->in3 = in3;
        
        // Evaluate DUT (combinational, responds immediately)
        dut->eval();
        
        // Monitor
        monitor.log(sim_time, sel, in0, in1, in2, in3, dut->out, stim_gen.is_valid());
        
        // Check
        if (rst_n && stim_gen.is_valid()) {
            checker.check(sel, in0, in1, in2, in3, dut->out);
        }
        
        // Check if done
        if (stim_gen.is_done()) {
            break;
        }
        
        sim_time++;
    }
    
    // Print summary
    std::cout << "\n========================================" << std::endl;
    std::cout << "Test Summary" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "Passed: " << checker.get_pass_count() << std::endl;
    std::cout << "Failed: " << checker.get_fail_count() << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return (checker.get_fail_count() > 0) ? 1 : 0;
}
