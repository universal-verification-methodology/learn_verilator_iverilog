# Module 2: Verilator Deep Dive

**Duration**: 2 weeks  
**Complexity**: Beginner-Intermediate  
**Goal**: Master Verilator for C++ testbench development

## Overview

This module provides comprehensive coverage of Verilator, a fast Verilog/SystemVerilog simulator that generates C++ code. You'll learn its compilation process, C++ testbench writing, capabilities, limitations, and how to create efficient C++ testbenches.

## Directory Structure

```
module2/
├── examples/              # Learning examples for each topic
│   ├── compilation/        # Verilator compilation process
│   ├── cpp_testbench/      # C++ testbench structure
│   ├── file_io/            # File I/O examples
│   ├── waveforms/          # Waveform generation examples
│   ├── debugging/          # Debugging techniques
│   └── advanced/           # Advanced Verilator features
├── dut/                    # Design Under Test modules
│   ├── multiplexers/       # MUX modules (2-to-1, 4-to-1)
│   └── counters/           # Counter modules
├── tests/                  # Comprehensive testbenches
│   ├── basic_tests/        # Basic C++ testbenches
│   ├── file_io_tests/     # File I/O testbenches
│   └── advanced_tests/     # Advanced testbenches
└── build/                  # Build artifacts (gitignored)
```

## Quick Start

### Run All Examples and Tests

```bash
# Run all Module 2 examples and tests
./scripts/module2.sh

# Run specific examples
./scripts/module2.sh --compilation
./scripts/module2.sh --cpp-testbench
./scripts/module2.sh --file-io
./scripts/module2.sh --waveforms
./scripts/module2.sh --debugging

# Run all tests
./scripts/module2.sh --all-tests
```

### Run Individual Examples

```bash
# Compilation examples
cd module2/examples/compilation
make all

# C++ testbench examples
cd module2/examples/cpp_testbench
make all

# File I/O examples
cd module2/examples/file_io
make all

# Waveform examples
cd module2/examples/waveforms
make all
```

## Topics Covered

### 1. Verilator Overview
- What is Verilator?
- Verilator's compilation model
- C++ wrapper generation
- Verilator capabilities and features
- Supported Verilog/SystemVerilog constructs
- Limitations and workarounds
- When to use Verilator

### 2. Compilation Process
- Verilator compilation command
- Compilation flags and options
- Optimization levels (-O0, -O1, -O2, -O3)
- Coverage options (--coverage)
- Linting capabilities (--lint-only)
- Waveform generation (--trace, --trace-fst)
- Include path management
- Define macros
- Multi-file compilation

**Examples**: `examples/compilation/`

### 3. C++ Testbench Structure
- C++ main function
- Verilator-generated class usage
- DUT instantiation in C++
- Signal access (reading and writing)
- Clock generation in C++
- Reset generation in C++
- Simulation loop

**Examples**: `examples/cpp_testbench/`

### 4. C++ Testbench Writing
- Basic C++ testbench template
- Signal access methods
- Clock and reset patterns
- Stimulus generation in C++
- Response monitoring in C++
- Result checking
- Error reporting

**Examples**: `examples/cpp_testbench/`

### 5. Verilator C++ API
- Top module class structure
- Signal access methods
- Evaluation method (eval())
- Time management
- Tracing API
- Coverage API

**Examples**: `examples/cpp_testbench/`, `examples/waveforms/`

### 6. Waveform Generation
- VCD file generation
- FST file generation
- Signal selection for tracing
- GTKWave compatibility
- Waveform analysis

**Examples**: `examples/waveforms/`

### 7. Debugging with Verilator
- Compilation error debugging
- C++ compilation errors
- Runtime debugging
- Signal inspection
- Logging strategies
- Common pitfalls and solutions

**Examples**: `examples/debugging/`

### 8. Advanced Verilator Features
- Multi-threaded simulation basics
- Performance optimization
- Large design handling
- Custom C++ integration
- SystemC integration basics

**Examples**: `examples/advanced/` (optional)

### 9. Project Organization
- Makefile integration
- CMake integration
- Scripting for automation
- Batch simulation
- Regression testing setup

## Examples

### Compilation Examples
- **basic_compilation.cpp**: Demonstrates basic compilation, optimization, tracing, coverage, linting

### C++ Testbench Examples
- **mux_4to1_test.cpp**: Complete C++ testbench for 4-to-1 multiplexer
- **counter_test.cpp**: C++ testbench for 4-bit counter with clock and reset

### File I/O
- **file_io_test.cpp**: Demonstrates C++ file I/O for reading test vectors and writing results

### Waveforms
- **waveform_example.cpp**: Comprehensive waveform generation using Verilator tracing API

### Debugging
- **debug_example.cpp**: C++ debugging techniques and logging strategies

## Tests

### Basic Tests
- **test_mux_4to1.cpp**: Comprehensive 4-to-1 multiplexer test with class-based organization

## Learning Outcomes

By the end of this module, you should be able to:

- ✓ Compile Verilog designs with Verilator
- ✓ Write C++ testbenches for Verilator
- ✓ Use Verilator C++ API effectively
- ✓ Generate and analyze waveforms
- ✓ Debug Verilator compilation and simulation issues
- ✓ Organize projects using Verilator
- ✓ Optimize Verilator-based testbenches

## Exercises

1. **Compilation Practice**
   - Compile designs with different Verilator options
   - Use optimization levels
   - Generate waveforms with tracing
   - Use coverage options

2. **C++ Testbench Development**
   - Write C++ testbench for multiplexer
   - Write C++ testbench for counter
   - Create C++ testbench with file-based test vectors

3. **Waveform Analysis**
   - Generate VCD files with Verilator
   - View waveforms in GTKWave
   - Analyze signal timing

4. **Project Organization**
   - Build Makefile for Verilator-based project
   - Create automation scripts
   - Set up regression testing

## Next Steps

After completing this module, proceed to:
- **Module 3**: Testbench Fundamentals (Verilog and C++)
- **Module 4**: Basic Testbench Construction

## Additional Resources

- **Verilator Documentation**: https://verilator.org/
- **GTKWave Documentation**: http://gtkwave.sourceforge.net/
- **IEEE 1364-2005 Standard**: Verilog Hardware Description Language
- **IEEE 1800-2017 Standard**: SystemVerilog Language Reference Manual
