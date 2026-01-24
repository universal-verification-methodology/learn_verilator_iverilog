# Comparison: iverilog vs Verilator

This directory contains side-by-side comparisons of testbenches written for iverilog (Verilog) and Verilator (C++).

## Key Differences

### iverilog (Verilog Testbenches)
- Written in Verilog/SystemVerilog
- Uses `$display`, `$monitor`, `$strobe` for output
- Uses `#` delays for timing
- Uses `initial` and `always` blocks
- Generates VCD files with `$dumpfile` and `$dumpvars`
- Compiled with `iverilog`, run with `vvp`

### Verilator (C++ Testbenches)
- Written in C++
- Uses `std::cout` for output
- Uses simulation loop for timing
- Uses C++ control structures (loops, conditionals)
- Generates VCD files with Verilator tracing API
- Compiled with `verilator`, linked with C++ compiler

## Example Comparisons

See the individual example directories for detailed comparisons:
- `and_gate/` - AND gate testbench comparison
- `counter/` - Counter testbench comparison (coming soon)

## When to Use Each

### Use iverilog when:
- You prefer Verilog/SystemVerilog syntax
- You need quick prototyping
- You're learning Verilog testbench concepts
- You want waveform debugging with GTKWave
- You're working with simple to medium complexity designs

### Use Verilator when:
- You need high performance simulation
- You want to integrate with C++ libraries
- You're building complex testbenches with advanced data structures
- You need to interface with external C/C++ code
- You're working with large designs
