# Module 0: Installation and Setup

**Duration**: 1 week  
**Complexity**: Beginner  
**Goal**: Set up verification environment with iverilog and Verilator

## Overview

This module covers the complete setup of your verification environment, including installation of iverilog, Verilator, GTKWave, and other verification tools. You'll learn the differences between these simulators and when to use each.

## Directory Structure

```
module0/
├── examples/              # Learning examples
│   ├── iverilog_basics/   # Basic iverilog examples
│   ├── verilator_basics/  # Basic Verilator examples
│   └── comparison/        # Side-by-side comparisons
├── dut/                   # Design Under Test modules
│   ├── simple_gates/      # Basic gates (AND, OR, XOR)
│   └── counters/          # Counter modules
├── tests/                 # Comprehensive testbenches
│   ├── iverilog_tests/    # iverilog testbenches
│   └── verilator_tests/   # Verilator testbenches
└── build/                 # Build artifacts (gitignored)
```

## Quick Start

### 1. Install Tools

```bash
# Install iverilog
./scripts/install_iverilog.sh

# Install Verilator
./scripts/install_verilator.sh

# Verify installations
iverilog -v
verilator --version
```

### 2. Run Examples

```bash
# Run all Module 0 examples and tests
./scripts/module0.sh

# Run only iverilog examples
./scripts/module0.sh --iverilog-basics

# Run only Verilator examples
./scripts/module0.sh --verilator-basics

# Run all tests
./scripts/module0.sh --all-tests
```

### 3. Run Individual Examples

```bash
# iverilog Hello World
cd module0/examples/iverilog_basics
make hello_world

# Verilator Hello World
cd module0/examples/verilator_basics
make hello_world

# iverilog AND Gate Test
cd module0/examples/iverilog_basics
make and_gate_test

# iverilog GTKWave Example (generates VCD file)
cd module0/examples/iverilog_basics
make gtkwave_example

# View waveforms with GTKWave
cd module0/examples/iverilog_basics
make view_waveforms
# Or manually: gtkwave gtkwave_example.vcd

# Verilator AND Gate Test
cd module0/examples/verilator_basics
make and_gate_test
```

## Examples

### iverilog Examples

1. **Hello World** (`examples/iverilog_basics/hello_world.v`)
   - Simplest possible iverilog testbench
   - Verifies iverilog installation
   - Demonstrates basic compilation and simulation

2. **AND Gate Test** (`examples/iverilog_basics/and_gate_test.v`)
   - DUT instantiation
   - Signal driving and monitoring
   - Basic test patterns
   - VCD waveform generation

3. **GTKWave Example** (`examples/iverilog_basics/gtkwave_example.v`)
   - Comprehensive waveform generation example
   - Multiple signal types (clock, data, control)
   - Signal transitions for analysis
   - Demonstrates GTKWave viewing workflow

### Verilator Examples

1. **Hello World** (`examples/verilator_basics/hello_world.cpp`)
   - Simplest possible Verilator testbench
   - Verifies Verilator installation
   - Demonstrates C++ testbench structure

2. **AND Gate Test** (`examples/verilator_basics/and_gate_test.cpp`)
   - DUT instantiation in C++
   - Signal access via Verilator API
   - Basic test patterns
   - C++ testbench structure

## Tests

### iverilog Tests

- **test_and_gate.v**: Comprehensive AND gate testbench with:
  - Complete test coverage
  - Error reporting
  - Test result summary
  - VCD waveform generation

### Verilator Tests

- **test_and_gate.cpp**: Comprehensive AND gate testbench with:
  - Complete test coverage
  - Error reporting
  - Test result summary
  - C++ class-based organization

## Learning Outcomes

By the end of this module, you should be able to:

- ✓ Install and configure iverilog and Verilator
- ✓ Understand differences between simulators
- ✓ Set up verification project structure
- ✓ Compile and run simple testbenches
- ✓ View and analyze waveforms
- ✓ Choose appropriate simulator for different scenarios

## Exercises

1. **Installation Verification**
   - Verify each tool independently
   - Document any issues encountered

2. **First Testbenches**
   - Run hello_world examples for both tools
   - Run AND gate testbenches
   - Compare outputs

3. **Waveform Analysis**
   - Generate VCD files with `gtkwave_example.v`
   - Run: `cd module0/examples/iverilog_basics && make gtkwave_example`
   - View waveforms in GTKWave: `make view_waveforms` or `gtkwave gtkwave_example.vcd`
   - Analyze signal timing and transitions
   - See `examples/iverilog_basics/README_GTKWAVE.md` for detailed GTKWave usage guide
   - Run `examples/iverilog_basics/view_waveforms.sh` for automated waveform viewing

4. **Tool Comparison**
   - Create a simple testbench in both paradigms
   - Compare compilation time
   - Compare simulation performance
   - Compare debugging capabilities

## Next Steps

After completing this module, proceed to:
- **Module 1**: iverilog Deep Dive
- **Module 2**: Verilator Deep Dive

## Additional Resources

- **Icarus Verilog Documentation**: http://iverilog.wikia.com/
- **Verilator Documentation**: https://verilator.org/
- **GTKWave Documentation**: http://gtkwave.sourceforge.net/
