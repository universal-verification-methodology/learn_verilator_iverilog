# Module 4: Basic Testbench Construction

**Goal**: Master construction of structured testbenches with proper organization

## Overview

This module focuses on building well-structured testbenches for both Verilog and C++ paradigms. You'll learn to organize testbenches into reusable components, create test scenarios, and implement proper verification patterns in both testbench styles.

### UVM-Inspired Patterns

The testbench structures in this module are inspired by the Universal Verification Methodology (UVM), adapted for pure Verilog and C++:

- **Separation of Concerns**: Stimulus, Monitor, and Checker are separate components
- **Modular Architecture**: Reusable, self-contained components
- **Reference Models**: Self-checking testbenches with automatic expected value calculation
- **Test Organization**: Structured test sequences with result aggregation

See `docs/MODULE4.md` for detailed explanations of UVM patterns and best practices.

## Directory Structure

```
module4/
├── examples/              # Learning examples for each topic
│   ├── modular_testbenches/  # Modular testbench organization
│   ├── clock_reset/          # Configurable clock/reset generation
│   ├── stimulus_monitoring/ # Structured stimulus and monitoring
│   └── self_checking/       # Self-checking testbenches
├── dut/                    # Design Under Test modules
│   ├── registers/           # Register file
│   ├── fifos/               # FIFO modules
│   └── alus/                # ALU modules
├── tests/                   # Comprehensive testbenches
│   ├── verilog_tests/        # Verilog testbenches
│   └── cpp_tests/            # C++ testbenches
└── build/                    # Build artifacts (gitignored)
```

## Quick Start

### Run All Examples and Tests

```bash
# Run all Module 4 examples and tests
./scripts/module4.sh

# Run specific examples
./scripts/module4.sh --modular-testbenches
./scripts/module4.sh --clock-reset
./scripts/module4.sh --self-checking

# Run all tests
./scripts/module4.sh --all-tests
```

### Run Individual Examples

```bash
# Modular testbench examples
cd module4/examples/modular_testbenches
make all

# Clock/reset examples
cd module4/examples/clock_reset
make all

# Self-checking examples
cd module4/examples/self_checking
make all
```

## Topics Covered

### 1. Testbench Organization
- Modular testbench structure (Verilog and C++)
- Separate stimulus, monitor, and checker components
- Verilog: Module-based organization
- C++: Class-based organization
- Testbench component organization
- Reusable testbench components
- Configuration and parameters

**Examples**: `examples/modular_testbenches/`

### 2. Clock and Reset Generation
- Verilog: Clock generation patterns (always blocks)
- C++: Clock generation patterns (simulation loop)
- Configurable clock periods (both paradigms)
- Multiple clock domains
- Reset generation (synchronous, asynchronous)
- Verilog: Reset in initial blocks
- C++: Reset in C++ code
- Reset sequences and timing
- Clock and reset coordination

**Examples**: `examples/clock_reset/`

### 3. Stimulus Generation
- Test vector generation
- Pattern generation
- Sequential stimulus application
- Stimulus timing control
- Stimulus verification

**Examples**: `examples/modular_testbenches/`

### 4. Response Monitoring
- Output monitoring strategies
- Real-time monitoring
- Post-processing monitoring
- Monitoring timing
- Event-driven monitoring

**Examples**: `examples/modular_testbenches/`

### 5. Result Checking
- Expected value calculation
- Output comparison
- Error detection and reporting
- Assertion-based checking
- Self-checking testbenches

**Examples**: `examples/self_checking/`

### 6. Test Scenarios
- Test case organization
- Multiple test scenarios
- Test sequencing
- Test selection mechanisms
- Test result aggregation

**Examples**: `examples/self_checking/`

## Examples

### Modular Testbenches

**Purpose**: Demonstrate separation of concerns with distinct stimulus, monitor, and checker components.

- **register_file_test_verilog.v**: 
  - Structured Verilog testbench with separate modules
  - Stimulus module generates clock, reset, and test vectors
  - Monitor module logs all transactions
  - Checker module validates outputs against expected values
  - Location: `examples/modular_testbenches/register_file_test_verilog.v`

- **register_file_test_cpp.cpp**: 
  - Structured C++ testbench with separate classes
  - Stimulus class provides methods for reset, write, and read operations
  - Monitor class logs transactions with timestamps
  - Checker class maintains expected state and validates reads
  - Location: `examples/modular_testbenches/register_file_test_cpp.cpp`

**Key Learning Points**:
- How to separate testbench functionality into distinct components
- How components interact through shared signals
- Benefits of modular organization (reusability, maintainability)

### Clock and Reset Generation

**Purpose**: Demonstrate professional clock and reset generation patterns.

- **configurable_clock_reset_verilog.v**: 
  - Parameter-based clock period configuration
  - Multiple independent clock domains
  - Configurable reset duration and timing
  - Clock edge monitoring for debugging
  - Location: `examples/clock_reset/configurable_clock_reset_verilog.v`

- **configurable_clock_reset_cpp.cpp**: 
  - Class-based clock and reset generators
  - Configurable periods and durations
  - State tracking for clock edges and reset events
  - Location: `examples/clock_reset/configurable_clock_reset_cpp.cpp`

**Key Learning Points**:
- How to generate configurable clocks
- Reset sequence timing (assert, hold, release)
- Multiple clock domain handling
- Clock and reset coordination

### Self-Checking Testbenches

**Purpose**: Demonstrate automatic verification with reference models.

- **alu_self_checking_verilog.v**: 
  - Reference model function calculates expected values
  - Reusable test task for running test cases
  - Automatic pass/fail detection
  - Test result aggregation and reporting
  - Location: `examples/self_checking/alu_self_checking_verilog.v`

- **alu_self_checking_cpp.cpp**: 
  - Class-based testbench with reference model method
  - Test method encapsulates test execution
  - Automatic comparison and error reporting
  - Test summary generation
  - Location: `examples/self_checking/alu_self_checking_cpp.cpp`

**Key Learning Points**:
- How to implement reference models
- Self-checking testbench architecture
- Test result aggregation
- Error detection and reporting

## Learning Outcomes

By the end of this module, you should be able to:

- ✓ Organize testbenches modularly (both paradigms)
- ✓ Generate clocks and resets properly (Verilog and C++)
- ✓ Create structured stimulus (both paradigms)
- ✓ Implement monitoring strategies (both paradigms)
- ✓ Build self-checking testbenches (both paradigms)
- ✓ Organize multiple test scenarios
- ✓ Choose appropriate organization style

## Exercises

1. **Create modular Verilog testbench for register file**
   - Separate stimulus, monitor, and checker modules
   - Organize components properly
   - Verify functionality

2. **Create modular C++ testbench for register file**
   - Use class-based organization
   - Separate stimulus, monitor, and checker classes
   - Compare with Verilog approach

3. **Design testbench with configurable clock/reset (both paradigms)**
   - Make clock period configurable
   - Implement reset sequences
   - Test different configurations

4. **Build testbench with multiple test scenarios (both paradigms)**
   - Organize test cases
   - Implement test sequencing
   - Aggregate results

5. **Implement self-checking testbench (both paradigms)**
   - Calculate expected values
   - Compare automatically
   - Report results

6. **Create reusable testbench components (both paradigms)**
   - Design reusable modules/classes
   - Parameterize components
   - Test reusability

## Next Steps

After completing this module, proceed to:
- **Module 5**: Procedural Testbench Writing
- **Module 6**: SystemVerilog Testbench Features

## Code Documentation

All code files in this module include comprehensive comments explaining:
- Purpose and responsibilities of each component
- Design patterns and architectural decisions
- UVM-inspired patterns and their implementation
- Step-by-step explanations of complex logic
- Usage examples and compilation instructions

**Example File Structure:**
```verilog
/**
 * Module Header
 * - Purpose and learning objectives
 * - UVM pattern inspiration
 * - Compilation and execution instructions
 */

module component_name;
    /**
     * Signal declarations with detailed comments
     */
    
    /**
     * Logic blocks with step-by-step explanations
     */
endmodule
```

## Additional Resources

- **Icarus Verilog Documentation**: http://iverilog.wikia.com/
- **Verilator Documentation**: https://verilator.org/
- **GTKWave Documentation**: http://gtkwave.sourceforge.net/
- **UVM Core Repository**: https://github.com/universal-verification-methodology/core
- **Detailed Module Documentation**: See `docs/MODULE4.md` for comprehensive explanations
