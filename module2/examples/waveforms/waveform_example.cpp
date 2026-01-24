/**
 * Waveform Generation Example for Verilator
 * 
 * This example demonstrates:
 * - VCD file generation with Verilator tracing API
 * - Signal selection for tracing
 * - GTKWave compatibility
 * 
 * Usage:
 *   verilator --trace --cc --exe --build -I../../dut/multiplexers mux_4to1.v waveform_example.cpp
 *   ./obj_dir/Vmux_4to1
 */

#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vmux_4to1.h"

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Waveform Generation Example (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vmux_4to1* dut = new Vmux_4to1;
    
    // Create VCD trace file
    VerilatedVcdC* tfp = new VerilatedVcdC;
    dut->trace(tfp, 99);  // Trace 99 levels of hierarchy
    tfp->open("waveform_example.vcd");
    
    // Simulation variables
    vluint64_t sim_time = 0;
    
    // Initialize signals
    dut->sel = 0;
    dut->in0 = 0; dut->in1 = 0; dut->in2 = 0; dut->in3 = 0;
    
    // Test sequence with various signal transitions
    for (int i = 0; i < 4; i++) {
        dut->sel = i;
        dut->in0 = (i == 0) ? 1 : 0;
        dut->in1 = (i == 1) ? 1 : 0;
        dut->in2 = (i == 2) ? 1 : 0;
        dut->in3 = (i == 3) ? 1 : 0;
        
        // Evaluate and trace
        dut->eval();
        tfp->dump(sim_time++);
        
        std::cout << "Time " << sim_time << ": sel=" << (int)dut->sel 
                  << ", out=" << (int)dut->out << std::endl;
        
        // Advance time
        sim_time += 10;
        tfp->dump(sim_time);
    }
    
    // Close trace file
    tfp->close();
    delete tfp;
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "VCD file generated: waveform_example.vcd" << std::endl;
    std::cout << "View with: gtkwave waveform_example.vcd" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
