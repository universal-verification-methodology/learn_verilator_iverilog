# Module 5: Procedural Testbench Writing

**Goal**: Master procedural testbench construction using Verilog procedural blocks and C++ control flow

---

## Navigation

[← Previous: Module 4: Basic Testbench Construction](MODULE4.md) | [Next: Module 6: SystemVerilog Testbench Features →](MODULE6.md)

[↑ Back to README](../README.md) | [📚 Full Syllabus](SYLLABUS2.md)



- **Slides & video**: [slides.pptx](../media/module5/slides.pptx) · [slides.pdf](../media/module5/slides.pdf) · [video.mp4](../media/module5/video.mp4) — regenerate: `./scripts/build_all_media.sh --module 5`
---

## Overview

This module covers procedural testbench writing using Verilog's procedural blocks and C++ control structures. You'll learn to create complex test sequences, handle timing, and implement procedural verification patterns in both paradigms.

### What You'll Learn

- **Procedural Constructs**: Master `initial` and `always` blocks in Verilog, and control flow in C++
- **Timing Control**: Understand delay control, event control, and wait statements
- **Reusable Routines**: Create tasks/functions in Verilog and functions/classes in C++ for code organization
- **File I/O**: Read test vectors from files and write results for automated testing
- **Test Sequences**: Build complex, multi-step test sequences
- **Advanced Patterns**: Implement state machines, protocols, and transaction-based testbenches

### Verification Methodology Context

Module 5 introduces patterns that are fundamental to advanced verification methodologies:

- **Reusable Routines** → **UVM Components**: Tasks/functions evolve into UVM's reusable component architecture
- **Test Sequences** → **UVM Sequences**: Procedural sequences become UVM sequence items and sequences
- **File I/O** → **UVM Configuration**: File-based test vectors lead to UVM's configuration database
- **State Machines** → **UVM Phases**: Testbench state machines relate to UVM's phase mechanism
- **Protocol Testbenches** → **UVM Agents**: Protocol drivers/monitors become UVM agents

> **Note**: The patterns in this module directly map to UVM concepts. See the [UVM Core Repository](https://github.com/universal-verification-methodology/core) for advanced examples of these patterns in a production verification framework.

### Examples and Code Structure

This module includes comprehensive examples and testbenches located in the `module5/` directory:

```
module5/
├── examples/              # Learning examples for each topic
│   ├── procedural_constructs/  # Procedural constructs
│   ├── timing_control/         # Timing control
│   ├── test_sequences/         # Test sequences
│   ├── reusable_routines/      # Reusable routines
│   ├── file_io/                # File I/O
│   └── advanced_patterns/      # Advanced procedural patterns
├── dut/                    # Design Under Test modules
│   ├── uart/                # UART modules
│   ├── spi/                 # SPI modules
│   └── i2c/                 # I2C modules
├── tests/                   # Comprehensive testbenches
│   ├── verilog_tests/        # Verilog testbenches
│   └── cpp_tests/            # C++ testbenches
└── README.md              # Module 5 documentation
```

### Quick Start

**Run all examples using the orchestrator script:**
```bash
# Run all Module 5 examples and tests
./scripts/module5.sh

# Run specific examples
./scripts/module5.sh --reusable-routines
./scripts/module5.sh --file-io
./scripts/module5.sh --timing-control

# Run all tests
./scripts/module5.sh --all-tests
```

**Run examples individually:**
```bash
# Reusable routines examples
cd module5/examples/reusable_routines
make all

# File I/O examples
cd module5/examples/file_io
make all

# Timing control examples
cd module5/examples/timing_control
make all
```


## Design Architecture

### 1. Protocol-oriented DUT (Module 5)

- **`dut/uart/simple_uart.v`**: TX FSM — idle, start, data bits, stop; `tx_done` handshake
- **Clock domain**: Single `clk` with active-low `rst_n`; serial `tx` output
- **Future DUTs**: SPI/I2C examples extend the same procedural TB patterns
- **Interface contract**: `tx_start` pulse, `tx_data[7:0]`, wait for `tx_done` before next byte

### 2. Procedural testbench control architecture

- **Verilog**: `initial` sequences call **tasks**; `always` blocks for clock and monitors
- **C++**: `main` or test class methods encode multi-step protocols with loops and waits
- **Timing**: `#delay` (Verilog) or counted `eval()` cycles (Verilator) align to bit times
- **State alignment**: TB FSM tracks UART phases while DUT FSM runs in RTL

### 3. Reusable routine layer

- **Tasks/functions**: `send_byte`, `wait_tx_done`, `apply_reset` — shared across tests
- **C++ helpers**: Same operations as methods on a `UartDriver` helper class
- **File-driven layer**: Sequences can be loaded from vector files for long regressions

## Verification & Testing Methods

### 1. Sequence-based stimulus

- **Multi-step tests**: Reset → configure → send N bytes → check `tx` bit timing
- **Handshaking**: Poll `tx_done` or use timeout counters to detect stuck FSM
- **Negative tests**: Start without reset, back-to-back `tx_start` — expect defined errors

### 2. Timing and synchronization checks

- **Bit period**: Verify one `eval()` or time step per bit cell in examples
- **Setup/hold**: Ensure `tx_data` stable before `tx_start` per README contracts
- **Waveform review**: UART frame visible on `tx` in VCD — start bit, LSB-first data

### 3. Reuse and regression methodology

- **Routine library**: Centralize protocol steps; tests only describe high-level scenarios
- **File I/O regression**: Replay captured stimulus files across tool releases
- **Orchestration**: `./scripts/module5.sh --test-sequences` and `--file-io` for focused runs

## Topics Covered

### 1. Procedural Constructs

- **Verilog: Initial Blocks for Test Sequences**
  - Initial block usage
  - Sequential execution
  - Multiple initial blocks
  - Initial block organization

- **Verilog: Always Blocks for Continuous Behavior**
  - Always block usage
  - Continuous execution
  - Clock generation
  - Continuous monitoring

- **C++: Main Function and Control Flow**
  - Main function structure
  - Control flow
  - Sequential execution
  - Function organization

- **C++: Loops and Conditionals**
  - For loops
  - While loops
  - If-else statements
  - Switch statements

- **Verilog: Blocking vs. Non-Blocking Assignments in Testbenches**
  - Blocking assignments (=)
  - Non-blocking assignments (<=)
  - When to use each
  - Best practices

- **Procedural Timing Control (Both Paradigms)**
  - Timing control methods
  - Timing accuracy
  - Timing relationships
  - Timing best practices

- **Verilog: Event Control (@, wait)**
  - Event control (@)
  - Wait statements
  - Event-based execution
  - Event coordination

**Examples**: `module5/examples/reusable_routines/`

### 2. Timing Control

- **Verilog: Delay Control (# delays)**
  - Delay syntax
  - Delay timing
  - Delay accuracy
  - Delay best practices

- **Verilog: Event Control (@posedge, @negedge, @*)**
  - Posedge control
  - Negedge control
  - Wildcard control
  - Event-based timing

- **C++: Time Management in Simulation Loop**
  - Simulation loop
  - Time tracking
  - Time advancement
  - Time management

- **C++: Clock Cycle Counting**
  - Cycle counting
  - Cycle-based timing
  - Cycle accuracy
  - Cycle management

- **Verilog: Wait Statements**
  - Wait syntax
  - Wait conditions
  - Wait timing
  - Wait best practices

- **Timing Accuracy (Both Paradigms)**
  - Timing precision
  - Timing relationships
  - Timing verification
  - Timing debugging

- **Race Condition Avoidance**
  - Race conditions
  - Avoidance techniques
  - Best practices
  - Debugging

**Examples**: `module5/examples/timing_control/`
- `timing_control_verilog.v`: Delay control, event control, wait statements
- `timing_control_cpp.cpp`: Time management in simulation loop

### 3. Test Sequences

- **Sequential Test Application**
  - Test ordering
  - Sequential execution
  - Test dependencies
  - Test coordination

- **Test Step Implementation**
  - Step definition
  - Step execution
  - Step timing
  - Step verification

- **Sequence Timing**
  - Sequence timing
  - Timing control
  - Timing accuracy
  - Timing verification

- **Synchronization with DUT**
  - DUT synchronization
  - Timing relationships
  - Synchronization methods
  - Synchronization verification

- **Sequence Verification**
  - Sequence checking
  - Sequence validation
  - Sequence debugging
  - Sequence best practices

**Examples**: `module5/examples/test_sequences/` (coming soon)

### 4. Reusable Routines

- **Verilog: Task Definitions for Test Sequences**
  - Task syntax
  - Task usage
  - Task parameters
  - Task organization

- **Verilog: Function Definitions for Calculations**
  - Function syntax
  - Function usage
  - Function return values
  - Function organization

- **C++: Function Definitions for Test Sequences**
  - Function syntax
  - Function usage
  - Function parameters
  - Function organization

- **C++: Class Methods for Organization**
  - Class methods
  - Method organization
  - Method reusability
  - Method best practices

- **Parameter Passing (Both Paradigms)**
  - Parameter syntax
  - Parameter types
  - Parameter passing
  - Parameter best practices

- **Reusable Verification Routines**
  - Routine design
  - Routine organization
  - Routine reusability
  - Routine library

**Examples**: `module5/examples/reusable_routines/`
- `task_function_test_verilog.v`: Tasks and functions for reusable test sequences
- `function_class_test_cpp.cpp`: Functions and classes for reusable test sequences

### 5. Loops and Control Flow

- **For Loops in Testbenches**
  - For loop syntax
  - For loop usage
  - Loop-based testing
  - Loop best practices

- **While Loops**
  - While loop syntax
  - While loop usage
  - Conditional loops
  - Loop termination

- **Repeat Loops**
  - Repeat syntax
  - Repeat usage
  - Fixed iteration
  - Repeat best practices

- **Conditional Execution**
  - If-else statements
  - Switch statements
  - Conditional logic
  - Conditional best practices

- **Loop-Based Test Generation**
  - Test generation
  - Loop-based patterns
  - Generation strategies
  - Generation best practices

**Examples**: `module5/examples/reusable_routines/`, `module5/examples/file_io/`

### 6. File I/O

- **Verilog: File Reading ($readmemh, $readmemb)**
  - $readmemh syntax
  - $readmemb syntax
  - File reading
  - Memory initialization

- **Verilog: File Writing ($fopen, $fwrite, $fclose)**
  - $fopen syntax
  - $fwrite syntax
  - $fclose syntax
  - File writing

- **C++: File I/O (fstream, ifstream, ofstream)**
  - fstream usage
  - ifstream usage
  - ofstream usage
  - File operations

- **C++: Reading Test Vectors**
  - Vector reading
  - Vector parsing
  - Vector storage
  - Vector application

- **C++: Writing Results**
  - Result writing
  - Result formatting
  - Result storage
  - Result analysis

- **Test Vector File Formats**
  - Format types
  - Format selection
  - Format parsing
  - Format best practices

- **Result Logging to Files**
  - Logging methods
  - Logging formats
  - Logging organization
  - Logging best practices

- **File-Based Testbenches (Both Paradigms)**
  - File-based design
  - File-based patterns
  - File-based best practices
  - File-based examples

**Examples**: `module5/examples/file_io/`
- `file_based_test_verilog.v`: File-based testbench using $readmemh and $fwrite
- `file_based_test_cpp.cpp`: File-based testbench using C++ file streams

### 7. Advanced Procedural Patterns

- **State Machine-Based Testbenches**
  - State machine design
  - State transitions
  - State verification
  - State machine patterns

- **Protocol-Based Testbenches**
  - Protocol modeling
  - Protocol sequences
  - Protocol verification
  - Protocol patterns

- **Transaction-Based Patterns**
  - Transaction modeling
  - Transaction sequences
  - Transaction verification
  - Transaction patterns

- **Layered Testbench Structure**
  - Layer organization
  - Layer interaction
  - Layer verification
  - Layer patterns

**Examples**: `module5/examples/advanced_patterns/` (coming soon)

## Example Testbenches

### Procedural Verilog Testbench for UART
- Location: (Coming soon)
- Demonstrates: Protocol testbench, procedural sequences

### Procedural C++ Testbench for UART
- Location: (Coming soon)
- Demonstrates: Protocol testbench, C++ control flow

### File-Based Testbench with Test Vectors (Both Paradigms)
- Location: `module5/examples/file_io/`
- Demonstrates: File I/O, test vector reading, result writing

### Task/Function-Based Reusable Testbench (Verilog)
- Location: `module5/examples/reusable_routines/task_function_test_verilog.v`
- Demonstrates: Tasks and functions for reusable test sequences

### Function/Class-Based Reusable Testbench (C++)
- Location: `module5/examples/reusable_routines/function_class_test_cpp.cpp`
- Demonstrates: Functions and classes for reusable test sequences

### State Machine Testbench (Both Paradigms)
- Location: (Coming soon)
- Demonstrates: State machine-based testbench patterns

### Protocol Testbench (SPI, I2C Basics) - Both Paradigms
- Location: (Coming soon)
- Demonstrates: Protocol testbench patterns

## Learning Outcomes

By the end of this module, you should be able to:

- Write procedural testbenches effectively (both paradigms)
- Control timing in testbenches (Verilog and C++)
- Create complex test sequences (both paradigms)
- Use tasks/functions (Verilog) and functions/classes (C++) for organization
- Implement file-based testing (both paradigms)
- Build protocol testbenches (both paradigms)

## Key Exercises

1. **Create procedural Verilog testbench with tasks**
   - Define tasks for test sequences
   - Use functions for calculations
   - Organize code with reusable routines

2. **Create procedural C++ testbench with functions**
   - Define functions for test sequences
   - Use classes for organization
   - Compare with Verilog approach

3. **Design file-based testbench (both paradigms)**
   - Read test vectors from files
   - Write results to files
   - Implement file-based testing

4. **Build protocol testbench (SPI/I2C) - both paradigms**
   - Implement protocol sequences
   - Handle timing requirements
   - Verify protocol compliance

5. **Implement state machine-based testbench (both paradigms)**
   - Model testbench as state machine
   - Implement state transitions
   - Verify state coverage

6. **Create reusable testbench library (both paradigms)**
   - Design reusable components
   - Parameterize routines
   - Build verification library

## Assessment

- [ ] Can write procedural testbenches effectively (both paradigms)
- [ ] Can control timing in testbenches (Verilog and C++)
- [ ] Can create complex test sequences (both paradigms)
- [ ] Can use tasks/functions (Verilog) and functions/classes (C++) for organization
- [ ] Can implement file-based testing (both paradigms)
- [ ] Can build protocol testbenches (both paradigms)

## Next Steps

After completing this module, proceed to:
- **Module 6: SystemVerilog Testbench Features** - Learn SystemVerilog enhancements
- **Module 7: Coverage and Assertions** - Master coverage and assertion-based verification

## Code Quality and Documentation Standards

All code examples in Module 5 follow these standards:

### Commenting Standards

- **File Headers**: Every file includes comprehensive header documentation:
  - Purpose and learning objectives
  - Key concepts explained
  - Compilation and execution instructions
  - Usage examples

- **Inline Comments**: Detailed comments explain:
  - **Why** code is written a certain way (not just what it does)
  - Procedural block behavior and timing
  - Task/function usage and parameter passing
  - File I/O operations and formats
  - Timing control mechanisms

- **Code Organization**: Comments group related code:
  - Signal declarations
  - DUT instantiation
  - Reusable routines (tasks/functions)
  - Test sequences
  - File operations

### Best Practices Demonstrated

1. **Modular Design**: Tasks/functions and classes for reusable code
2. **Clear Error Messages**: Detailed error reporting in file I/O operations
3. **Systematic Testing**: Structured test sequences with clear phases
4. **Resource Management**: Proper file handle management and cleanup
5. **Timing Accuracy**: Careful timing control to avoid race conditions

## Additional Resources

### Tool Documentation
- **Icarus Verilog Documentation**: http://iverilog.wikia.com/
- **Verilator Documentation**: https://verilator.org/
- **GTKWave Documentation**: http://gtkwave.sourceforge.net/

### Language Standards
- **IEEE 1364-2005 Standard**: Verilog Hardware Description Language
- **IEEE 1800-2017 Standard**: SystemVerilog Language Reference Manual

### Verification Methodology Resources
- **Universal Verification Methodology (UVM)**: https://accellera.org/downloads/standards/uvm
- **UVM Core Repository**: https://github.com/universal-verification-methodology/core
  - Official UVM library with examples of:
    - Reusable components (agents, drivers, monitors)
    - Sequence-based stimulus generation
    - Configuration management
    - Phase-based testbench control

### Pattern Evolution: Module 5 → UVM

| Module 5 Pattern | UVM Equivalent | Key Differences |
|-----------------|----------------|----------------|
| Tasks/Functions | `uvm_component` methods | Object-oriented, polymorphic |
| Procedural sequences | `uvm_sequence` and `uvm_sequence_item` | Transaction-based, reusable |
| File I/O | `uvm_config_db` | Centralized, type-safe |
| State machines | `uvm_phase` mechanism | Structured, automated |
| Protocol testbenches | `uvm_agent` (driver + monitor) | Decoupled, configurable |
| Manual timing | Event-driven simulation | Built-in, synchronized |
