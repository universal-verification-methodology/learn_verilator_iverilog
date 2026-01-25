/**
 * Verification Metrics Tracker - C++ (Verilator)
 * 
 * This testbench demonstrates verification metrics tracking:
 * - Coverage metrics tracking
 * - Bug metrics tracking
 * - Test metrics tracking
 * - Progress tracking
 * - Quality metrics
 * 
 * Usage:
 *   make metrics_test
 *   or
 *   verilator --cc --exe --build -I../../../module8/dut/simple_gates \
 *            ../../../module8/dut/simple_gates/and_gate.v metrics_test.cpp
 *   ./obj_dir/Vand_gate
 */

#include <iostream>
#include <iomanip>
#include <chrono>
#include <bitset>
#include <verilated.h>
#include "Vand_gate.h"

class MetricsTracker {
private:
    int total_tests;
    int passed_tests;
    int failed_tests;
    std::bitset<4> coverage_bins;
    int bugs_found;
    std::chrono::high_resolution_clock::time_point start_time;
    std::chrono::high_resolution_clock::time_point end_time;
    
public:
    MetricsTracker() : total_tests(0), passed_tests(0), failed_tests(0), bugs_found(0) {}
    
    void start() {
        start_time = std::chrono::high_resolution_clock::now();
    }
    
    void stop() {
        end_time = std::chrono::high_resolution_clock::now();
    }
    
    void record_test(uint8_t a, uint8_t b, uint8_t expected, uint8_t actual) {
        total_tests++;
        
        // Track coverage
        if (a == 0 && b == 0) coverage_bins.set(0);
        if (a == 0 && b == 1) coverage_bins.set(1);
        if (a == 1 && b == 0) coverage_bins.set(2);
        if (a == 1 && b == 1) coverage_bins.set(3);
        
        // Check result
        if (actual == expected) {
            passed_tests++;
        } else {
            failed_tests++;
            bugs_found++;
            std::cerr << "[BUG] Test failed: a=" << (int)a 
                      << ", b=" << (int)b 
                      << ", y=" << (int)actual 
                      << ", expected=" << (int)expected << std::endl;
        }
    }
    
    double calculate_coverage() {
        return (coverage_bins.count() * 100.0) / 4.0;
    }
    
    void print_metrics() {
        double pass_rate = (passed_tests * 100.0) / total_tests;
        double coverage = calculate_coverage();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(
            end_time - start_time).count();
        double test_time_ms = duration / 1000.0;
        
        std::cout << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Verification Metrics Report" << std::endl;
        std::cout << "========================================" << std::endl;
        std::cout << "Test Metrics:" << std::endl;
        std::cout << "  Total tests:     " << total_tests << std::endl;
        std::cout << "  Passed:          " << passed_tests << std::endl;
        std::cout << "  Failed:          " << failed_tests << std::endl;
        std::cout << "  Pass rate:       " << std::fixed << std::setprecision(1) 
                  << pass_rate << "%" << std::endl;
        std::cout << std::endl;
        std::cout << "Coverage Metrics:" << std::endl;
        std::cout << "  Coverage:        " << std::fixed << std::setprecision(1) 
                  << coverage << "%" << std::endl;
        std::cout << "  Coverage bins:   " << coverage_bins.count() << "/4" << std::endl;
        std::cout << std::endl;
        std::cout << "Bug Metrics:" << std::endl;
        std::cout << "  Bugs found:      " << bugs_found << std::endl;
        std::cout << std::endl;
        std::cout << "Quality Metrics:" << std::endl;
        std::cout << "  Test time:       " << std::fixed << std::setprecision(1) 
                  << test_time_ms << " ms" << std::endl;
        if (test_time_ms > 0) {
            std::cout << "  Tests/sec:       " << std::fixed << std::setprecision(1) 
                      << (total_tests * 1000.0) / test_time_ms << std::endl;
        }
        std::cout << "========================================" << std::endl;
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Verification Metrics Tracker (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create metrics tracker
    MetricsTracker metrics;
    metrics.start();
    
    // Create DUT instance
    Vand_gate* dut = new Vand_gate;
    
    // Run exhaustive tests
    dut->a = 0; dut->b = 0; dut->eval();
    metrics.record_test(0, 0, 0, dut->y);
    
    dut->a = 0; dut->b = 1; dut->eval();
    metrics.record_test(0, 1, 0, dut->y);
    
    dut->a = 1; dut->b = 0; dut->eval();
    metrics.record_test(1, 0, 0, dut->y);
    
    dut->a = 1; dut->b = 1; dut->eval();
    metrics.record_test(1, 1, 1, dut->y);
    
    // Stop timing
    metrics.stop();
    
    // Print metrics
    metrics.print_metrics();
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
