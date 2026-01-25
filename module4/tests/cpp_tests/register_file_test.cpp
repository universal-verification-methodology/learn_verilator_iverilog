/**
 * Register File C++ Testbench (Verilator)
 * 
 * This testbench demonstrates modular testbench architecture with separation
 * of concerns using C++ classes.
 * 
 * Key Concepts:
 * - Class-based testbench organization
 * - Clock generation via simulation loop
 * - Write/read operations
 * - Result checking
 * 
 * Usage:
 *   make register_file_test
 *   or
 *   verilator --cc --exe --build -I../../../module4/dut/registers \
 *            ../../../module4/dut/registers/register_file.v register_file_test.cpp
 *   ./obj_dir/Vregister_file
 */

#include <iostream>
#include <iomanip>
#include <cassert>
#include <verilated.h>
#include "Vregister_file.h"

// Helper function to tick clock
void tick_clock(Vregister_file* dut, vluint64_t& sim_time, int cycles) {
    for (int i = 0; i < cycles; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        sim_time++;
    }
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    std::cout << "========================================" << std::endl;
    std::cout << "Register File C++ Testbench (Verilator)" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Create DUT instance
    Vregister_file* dut = new Vregister_file;
    vluint64_t sim_time = 0;
    
    // Initialize signals
    dut->clk = 0;
    dut->rst_n = 0;
    dut->we = 0;
    dut->waddr = 0;
    dut->wdata = 0;
    dut->raddr0 = 0;
    dut->raddr1 = 0;
    
    // Apply reset
    tick_clock(dut, sim_time, 3);
    
    // Release reset
    dut->rst_n = 1;
    tick_clock(dut, sim_time, 2);
    
    // Ensure clock is low before first write (for proper posedge)
    if (dut->clk == 1) {
        tick_clock(dut, sim_time, 1);
    }
    
    // Write to register 0
    std::cout << "\nTest 1: Write 0xAA to register 0" << std::endl;
    dut->we = 1;
    dut->waddr = 0;
    dut->wdata = 0xAA;
    tick_clock(dut, sim_time, 2);  // Full clock cycle: posedge (write) + negedge
    std::cout << "  Write: addr=" << (int)dut->waddr << ", data=0x" 
              << std::hex << std::setw(2) << std::setfill('0') << (int)dut->wdata << std::dec << std::endl;
    
    // Write to register 1
    std::cout << "\nTest 2: Write 0xBB to register 1" << std::endl;
    dut->waddr = 1;
    dut->wdata = 0xBB;
    tick_clock(dut, sim_time, 2);  // Full clock cycle: posedge (write) + negedge
    std::cout << "  Write: addr=" << (int)dut->waddr << ", data=0x" 
              << std::hex << std::setw(2) << std::setfill('0') << (int)dut->wdata << std::dec << std::endl;
    
    // Write to register 2
    std::cout << "\nTest 3: Write 0xCC to register 2" << std::endl;
    dut->waddr = 2;
    dut->wdata = 0xCC;
    tick_clock(dut, sim_time, 2);  // Full clock cycle: posedge (write) + negedge
    std::cout << "  Write: addr=" << (int)dut->waddr << ", data=0x" 
              << std::hex << std::setw(2) << std::setfill('0') << (int)dut->wdata << std::dec << std::endl;
    
    // Read from registers 0 and 1
    std::cout << "\nTest 4: Read from registers 0 and 1" << std::endl;
    dut->we = 0;
    dut->raddr0 = 0;
    dut->raddr1 = 1;
    dut->eval();  // Evaluate combinational read (no clock needed, but eval to update outputs)
    // Read is combinational, so we can check immediately
    std::cout << "  Read: addr0=" << (int)dut->raddr0 << ", data0=0x" 
              << std::hex << std::setw(2) << std::setfill('0') << (int)dut->rdata0 
              << " (expected 0xAA) " << ((dut->rdata0 == 0xAA) ? "[PASS]" : "[FAIL]") << std::dec << std::endl;
    std::cout << "  Read: addr1=" << (int)dut->raddr1 << ", data1=0x" 
              << std::hex << std::setw(2) << std::setfill('0') << (int)dut->rdata1 
              << " (expected 0xBB) " << ((dut->rdata1 == 0xBB) ? "[PASS]" : "[FAIL]") << std::dec << std::endl;
    assert(dut->rdata0 == 0xAA && "Read failed: Expected 0xAA");
    assert(dut->rdata1 == 0xBB && "Read failed: Expected 0xBB");
    
    // Read from registers 2 and 3
    std::cout << "\nTest 5: Read from registers 2 and 3" << std::endl;
    dut->raddr0 = 2;
    dut->raddr1 = 3;
    dut->eval();  // Evaluate combinational read (no clock needed, but eval to update outputs)
    // Read is combinational, so we can check immediately
    std::cout << "  Read: addr0=" << (int)dut->raddr0 << ", data0=0x" 
              << std::hex << std::setw(2) << std::setfill('0') << (int)dut->rdata0 
              << " (expected 0xCC) " << ((dut->rdata0 == 0xCC) ? "[PASS]" : "[FAIL]") << std::dec << std::endl;
    std::cout << "  Read: addr1=" << (int)dut->raddr1 << ", data1=0x" 
              << std::hex << std::setw(2) << std::setfill('0') << (int)dut->rdata1 
              << " (expected 0x00) " << ((dut->rdata1 == 0x00) ? "[PASS]" : "[FAIL]") << std::dec << std::endl;
    assert(dut->rdata0 == 0xCC && "Read failed: Expected 0xCC");
    assert(dut->rdata1 == 0x00 && "Read failed: Expected 0x00");
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "All tests completed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Cleanup
    dut->final();
    delete dut;
    
    return 0;
}
