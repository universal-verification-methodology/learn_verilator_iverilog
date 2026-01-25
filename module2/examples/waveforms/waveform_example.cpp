/**
 * Waveform Generation Example for Verilator
 * 
 * This example demonstrates Verilator's waveform tracing capabilities:
 * - VCD (Value Change Dump) file generation
 * - Using VerilatedVcdC class for tracing
 * - Signal selection and hierarchy levels
 * - Time management for waveform dumps
 * - GTKWave compatibility
 * 
 * VCD File Format:
 *   - VCD is a standard waveform format used by many EDA tools
 *   - Contains signal value changes over time
 *   - Can be viewed in GTKWave, ModelSim, Vivado, etc.
 *   - Text-based format (can be large for long simulations)
 * 
 * Tracing Workflow:
 *   1. Compile with --trace flag: verilator --trace ...
 *   2. Create VerilatedVcdC object
 *   3. Call dut->trace(tfp, levels) to register signals
 *   4. Open VCD file with tfp->open(filename)
 *   5. Call tfp->dump(time) after each eval() to record state
 *   6. Close file with tfp->close() before final()
 * 
 * Usage:
 *   # Compile with tracing enabled (--trace flag is required!)
 *   verilator --trace --cc --exe --build -I../../dut/multiplexers mux_4to1.v waveform_example.cpp
 *   
 *   # Run simulation (generates waveform_example.vcd)
 *   ./obj_dir/Vmux_4to1
 *   
 *   # View waveform
 *   gtkwave waveform_example.vcd
 */

#include <iostream>          // Console I/O
#include <verilated.h>        // Verilator core library
#include <verilated_vcd_c.h>  // VCD tracing support (requires --trace flag)
#include "Vmux_4to1.h"        // Generated wrapper class

int main(int argc, char** argv) {
    // ========================================================================
    // STEP 1: Initialize Verilator
    // ========================================================================
    Verilated::commandArgs(argc, argv);
    
    // Enable tracing globally (required before creating trace file object)
    // This must be called before time 0, before any evaluation.
    Verilated::traceEverOn(true);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Waveform Generation Example (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================================================
    // STEP 2: Create DUT Instance
    // ========================================================================
    Vmux_4to1* dut = new Vmux_4to1;
    
    // ========================================================================
    // STEP 3: Setup VCD Tracing
    // ========================================================================
    // VerilatedVcdC is the class for VCD file generation.
    // Note: This only works if Verilator was compiled with --trace flag!
    // Without --trace, the trace() method won't be available.
    VerilatedVcdC* tfp = new VerilatedVcdC;
    
    // dut->trace(tfp, levels) registers all signals for tracing.
    // The second parameter (99) specifies how many levels of hierarchy to trace.
    // Higher values trace deeper into submodules, but increase file size.
    // For top-level signals only, use 1. For full hierarchy, use 99.
    dut->trace(tfp, 99);
    
    // Open VCD file for writing. This creates the file and writes the header.
    // The filename can be any valid path. VCD extension is conventional.
    tfp->open("waveform_example.vcd");
    
    // ========================================================================
    // STEP 4: Initialize Simulation
    // ========================================================================
    vluint64_t sim_time = 0;  // Simulation time counter (for VCD timestamps)
    
    // Initialize all signals to known values before starting simulation.
    // This ensures clean waveforms from the start.
    dut->sel = 0;
    dut->in0 = 0; dut->in1 = 0; dut->in2 = 0; dut->in3 = 0;
    
    // Dump initial state (time 0) to VCD file
    dut->eval();
    tfp->dump(sim_time);
    
    // ========================================================================
    // STEP 5: Run Simulation with Tracing
    // ========================================================================
    // Test sequence: cycle through all select values
    for (int i = 0; i < 4; i++) {
        // Set select and corresponding input
        dut->sel = i;
        dut->in0 = (i == 0) ? 1 : 0;  // Set selected input to 1
        dut->in1 = (i == 1) ? 1 : 0;
        dut->in2 = (i == 2) ? 1 : 0;
        dut->in3 = (i == 3) ? 1 : 0;
        
        // Evaluate combinational logic
        dut->eval();
        
        // Dump current state to VCD file at current simulation time
        // This records all signal values at this point in time.
        tfp->dump(sim_time++);
        
        std::cout << "Time " << sim_time << ": sel=" << (int)dut->sel 
                  << ", out=" << (int)dut->out << std::endl;
        
        // Advance simulation time (creates time gap in waveform)
        // This makes it easier to see transitions in GTKWave.
        // In real simulations, time advances based on clock periods.
        sim_time += 10;
        tfp->dump(sim_time);  // Dump again at new time
    }
    
    // ========================================================================
    // STEP 6: Close Trace File
    // ========================================================================
    // Always close the trace file before calling dut->final().
    // The VCD file is finalized when closed.
    tfp->close();
    delete tfp;
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "VCD file generated: waveform_example.vcd" << std::endl;
    std::cout << "View with: gtkwave waveform_example.vcd" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // ========================================================================
    // STEP 7: Cleanup
    // ========================================================================
    dut->final();
    delete dut;
    
    return 0;
}
