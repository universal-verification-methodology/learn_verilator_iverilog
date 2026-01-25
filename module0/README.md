# Module 0: Installation and Setup

**Duration**: 1 week  
**Complexity**: Beginner  
**Goal**: Set up verification environment with iverilog and Verilator

## Overview

This module covers the complete setup of your verification environment, including installation of iverilog, Verilator, GTKWave, and other verification tools. You'll learn the differences between these simulators and when to use each.

### Learning Objectives

By completing this module, you will:

1. **Install and Configure Tools**
   - Set up iverilog (Icarus Verilog) simulator
   - Set up Verilator (fast Verilog-to-C++ simulator)
   - Install GTKWave for waveform viewing
   - Verify all installations work correctly

2. **Understand Tool Differences**
   - Learn when to use iverilog vs Verilator
   - Understand compilation and simulation workflows
   - Compare performance and debugging capabilities

3. **Create First Testbenches**
   - Write simple "Hello World" testbenches
   - Instantiate and test basic DUTs (Design Under Test)
   - Generate and view waveforms
   - Understand basic testbench structure

4. **Establish Best Practices**
   - Organize project structure
   - Set up build automation (Makefiles)
   - Follow coding standards and documentation practices
   - Understand verification methodology foundations

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
   - **Purpose**: Simplest possible iverilog testbench to verify installation
   - **Key Concepts**:
     - `module` declaration (testbench modules have no ports)
     - `initial` block for procedural execution
     - `$display` system task for console output
     - `$finish` system task to terminate simulation
     - Time delays with `#delay`
   - **Compilation**: `iverilog -o hello_world hello_world.v`
   - **Simulation**: `vvp hello_world`
   - **Learning Value**: Understand basic testbench structure and simulation flow

2. **AND Gate Test** (`examples/iverilog_basics/and_gate_test.v`)
   - **Purpose**: Demonstrates DUT instantiation and basic verification patterns
   - **Key Concepts**:
     - DUT (Design Under Test) instantiation
     - Signal types: `reg` (driven in testbench) vs `wire` (connected to DUT)
     - Test vector application (stimulus generation)
     - Output checking (self-checking testbench)
     - Exhaustive testing (all input combinations)
     - VCD waveform generation with `$dumpfile` and `$dumpvars`
   - **Compilation**: `iverilog -o and_gate_test and_gate_test.v ../dut/simple_gates/and_gate.v`
   - **Simulation**: `vvp and_gate_test` (generates `and_gate_test.vcd`)
   - **Learning Value**: Learn fundamental verification patterns used in all testbenches

3. **GTKWave Example** (`examples/iverilog_basics/gtkwave_example.v`)
   - **Purpose**: Comprehensive waveform generation and analysis example
   - **Key Concepts**:
     - Clock generation using `forever` loops
     - Multiple signal types (clock, data, control)
     - Test phases and patterns
     - Signal transitions for timing analysis
     - VCD file structure and hierarchy
   - **Compilation**: `iverilog -o gtkwave_example gtkwave_example.v ../dut/simple_gates/and_gate.v`
   - **Simulation**: `vvp gtkwave_example` (generates `gtkwave_example.vcd`)
   - **Viewing**: `gtkwave gtkwave_example.vcd` or use `make view_waveforms`
   - **Learning Value**: Master waveform generation and analysis for debugging

### Verilator Examples

1. **Hello World** (`examples/verilator_basics/hello_world.cpp` and `hello_world.v`)
   - **Purpose**: Simplest possible Verilator testbench to verify installation
   - **Key Concepts**:
     - Verilator compilation process (`verilator --cc --exe --build`)
     - Generated C++ class structure (`V<module_name>`)
     - DUT instantiation in C++
     - `eval()` method for simulation
     - `final()` method for cleanup
     - Verilator initialization with `Verilated::commandArgs()`
   - **Compilation**: `verilator --cc --exe --build hello_world.v hello_world.cpp`
   - **Running**: `./obj_dir/Vhello_world`
   - **Learning Value**: Understand Verilator's C++ testbench paradigm

2. **AND Gate Test** (`examples/verilator_basics/and_gate_test.cpp`)
   - **Purpose**: Demonstrates Verilator API and C++ testbench patterns
   - **Key Concepts**:
     - DUT instantiation in C++
     - Signal access via Verilator API (ports as member variables)
     - Input driving: `dut->a = value`
     - Output reading: `dut->y` (after `eval()`)
     - Self-checking with `assert()`
     - Test vector application in C++
   - **Compilation**: `verilator --cc --exe --build -I../../dut/simple_gates and_gate.v and_gate_test.cpp`
   - **Running**: `./obj_dir/Vand_gate`
   - **Learning Value**: Master Verilator API and C++ testbench structure

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

## Code Quality and Documentation

All code in Module 0 has been enhanced with:
- **Comprehensive Comments**: Detailed inline comments explaining:
  - Purpose and learning objectives
  - Key concepts and Verilog/Verilator features
  - Step-by-step explanations of complex logic
  - Usage instructions and examples
- **Header Documentation**: Each file includes:
  - Module/function purpose
  - Parameter descriptions
  - Usage examples
  - Compilation instructions
- **Best Practices**: Code demonstrates:
  - Proper signal initialization
  - Self-checking testbenches
  - Clear test organization
  - Resource cleanup

## Additional Resources

### Tool Documentation
- **Icarus Verilog Documentation**: http://iverilog.wikia.com/
- **Verilator Documentation**: https://verilator.org/
- **GTKWave Documentation**: http://gtkwave.sourceforge.net/

### Verification Methodologies (Future Learning)

#### Universal Verification Methodology (UVM)
UVM is an industry-standard verification methodology for SystemVerilog. While Module 0 focuses on basic testbench development, UVM provides advanced features for large-scale verification:

- **UVM Core Repository**: https://github.com/universal-verification-methodology/core
  - Official UVM library and examples
  - Comprehensive testbench framework
  - Reusable verification components

- **UVM Concepts** (covered in later modules):
  - **Testbenches**: Structured, reusable test environments
  - **Agents**: Reusable interface drivers/monitors
  - **Sequences**: Stimulus generation patterns
  - **Scoreboards**: Result checking and comparison
  - **Coverage**: Functional and code coverage collection
  - **Phases**: Simulation lifecycle management

- **When to Use UVM**:
  - Large, complex designs requiring structured verification
  - Team environments needing reusable components
  - Projects requiring advanced features (coverage, sequences, etc.)
  - Industry-standard verification practices

- **Learning Path**:
  1. **Module 0** (Current): Basic testbenches with iverilog/Verilator
  2. **Module 1-5**: Advanced testbench techniques
  3. **Module 6+**: SystemVerilog features (interfaces, classes, randomization)
  4. **Future Modules**: UVM methodology and advanced verification

#### Other Verification Methodologies
- **OSVVM** (Open Source VHDL Verification Methodology): For VHDL designs
- **Cocotb** (Coroutine-based COsimulation TestBench): Python-based verification
- **PyUVM**: UVM-like framework in Python
