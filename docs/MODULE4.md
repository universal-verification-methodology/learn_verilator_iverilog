# Module 4: Basic Testbench Construction

**Goal**: Master construction of structured testbenches with proper organization

---

## Navigation

[← Previous: Module 3: Testbench Fundamentals](MODULE3.md) | [Next: Module 5: Procedural Testbench Writing →](MODULE5.md)

[↑ Back to README](../README.md) | [📚 Full Syllabus](SYLLABUS2.md)



- **Slides & video**: [slides.pptx](../media/module4/slides.pptx) · [slides.pdf](../media/module4/slides.pdf) · [video.mp4](../media/module4/video.mp4) — regenerate: `./scripts/build_all_media.sh --module 4`
---

## Overview

This module focuses on building well-structured testbenches for both Verilog and C++ paradigms. You'll learn to organize testbenches into reusable components, create test scenarios, and implement proper verification patterns in both testbench styles.

### UVM Pattern Inspiration

While this module uses pure Verilog and C++ (not SystemVerilog/UVM), the principles and patterns are inspired by the Universal Verification Methodology (UVM). Understanding these patterns will prepare you for advanced verification methodologies:

**Key UVM Patterns Demonstrated:**

1. **Separation of Concerns**
   - **Stimulus (Driver)**: Generates and applies test vectors to the DUT
   - **Monitor**: Passively observes DUT behavior and logs transactions
   - **Checker/Scoreboard**: Validates DUT outputs against expected values
   - This separation enables independent development, testing, and reuse of components

2. **Modular Architecture**
   - Components are self-contained and reusable
   - Clear interfaces between components
   - Easy to replace or modify individual components
   - Supports hierarchical testbench construction

3. **Reference Models**
   - Self-checking testbenches use reference models to calculate expected values
   - Reference models mirror DUT functionality
   - Enables automatic verification without manual expected value entry

4. **Test Organization**
   - Test cases organized into reusable tasks/functions
   - Test sequences for complex scenarios
   - Result aggregation and reporting

**UVM Core Repository References:**

The patterns in this module align with concepts from the [UVM Core Repository](https://github.com/universal-verification-methodology/core):
- **Agent Architecture**: Driver, Monitor, Sequencer separation
- **Scoreboard Pattern**: Expected vs actual comparison
- **Test Sequences**: Organized test case execution
- **Configuration**: Parameterized and configurable components

**From UVM to This Module:**

| UVM Concept | Verilog Equivalent | C++ Equivalent |
|------------|-------------------|----------------|
| Driver | Stimulus Module | Stimulus Class |
| Monitor | Monitor Module | Monitor Class |
| Scoreboard | Checker Module | Checker Class |
| Sequence | Test Task/Function | Test Method |
| Reference Model | Expected Value Function | Expected Value Method |
| Agent | Testbench Module | Testbench Class |

### Examples and Code Structure

This module includes comprehensive examples and testbenches located in the `module4/` directory:

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
└── README.md              # Module 4 documentation
```

### Quick Start

**Run all examples using the orchestrator script:**
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

**Run examples individually:**
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


## Design Architecture

### 1. Structured DUT portfolio (Module 4)

- **`dut/alus/simple_alu.v`**: Combinational ALU — op select, result, zero flag
- **`dut/fifos/simple_fifo.v`**: Queue storage with full/empty and pointer logic
- **`dut/registers/register_file.v`**: Multi-port register file — read/write ports, clocked updates
- **Complexity step**: Moves from gates/counters to datapath blocks needing organized TBs

### 2. Modular testbench architecture

- **Separation**: Stimulus generator, monitor, checker/scoreboard as distinct modules or classes
- **Clock/reset generator**: Dedicated block (`clock_reset` examples) — configurable period
- **Hierarchy**: Top TB instantiates agents + DUT; connects via named interfaces (wires)
- **C++ mirror**: Same roles as C++ classes with methods `drive()`, `sample()`, `check()`

### 3. Reference model placement

- **Golden model**: Software replica of ALU/FIFO/register behavior in TB
- **Self-checking path**: DUT output compared to reference each cycle or transaction
- **Config**: Parameters for width, depth, and clock period without editing DUT RTL

**Simulation flow**: `cd module4/examples/clock_reset && make` → then `cd ../self_checking && make` → modular TB in `modular_testbenches/`

**Execution sequence**: Build clk/rst generators → connect DUT → drive ALU/FIFO vectors → reference model compare → wire agents at top → `./scripts/module4.sh --check`

**Self-check flow**: Reference model in TB → compare each cycle → aggregate pass/fail before `$finish`

## Verification & Testing Methods

### 1. Component-level verification

- **Stimulus module**: Encapsulates write sequences to FIFO or register ports
- **Monitor module**: Captures read data and status flags passively
- **Checker**: Flags protocol violations (overflow, X on outputs, wrong opcode result)

### 2. Scenario-based testing

- **Scenarios**: Reset + fill FIFO; ALU op sweep; register R/W hazard patterns
- **Tasks/methods**: Each scenario is a callable task — reusable across tests
- **Aggregation**: Single report summarizing scenarios run and failures

### 3. Structured debug and closure

- **Modular debug**: Isolate failing agent by disabling others in top TB
- **Waveform on demand**: Trigger dumps only when checker fires
- **Regression**: `./scripts/module4.sh --self-checking` and `--all-tests` for batch sign-off

## Topics Covered

### 1. Testbench Organization

- **Modular Testbench Structure (Verilog and C++)**
  - Separating concerns
  - Component-based design
  - Reusability principles
  - Maintainability

- **Separate Stimulus, Monitor, and Checker Components**
  - Stimulus generation module/class
  - Response monitoring module/class
  - Result checking module/class
  - Component interaction

- **Verilog: Module-Based Organization**
  - Module hierarchy
  - Module instantiation
  - Signal connectivity
  - Module reusability

- **C++: Class-Based Organization**
  - Class hierarchy
  - Class instantiation
  - Method organization
  - Class reusability

- **Testbench Component Organization**
  - Component placement
  - Signal routing
  - Hierarchy design
  - Organization patterns

- **Reusable Testbench Components**
  - Component design
  - Parameterization
  - Configuration
  - Reuse strategies

- **Configuration and Parameters**
  - Parameter passing
  - Configuration management
  - Runtime configuration
  - Build-time configuration

**Examples**: `module4/examples/modular_testbenches/`
- `register_file_test_verilog.v`: Structured Verilog testbench with separate modules
- `register_file_test_cpp.cpp`: Structured C++ testbench with separate classes

### 2. Clock and Reset Generation

- **Verilog: Clock Generation Patterns (Always Blocks)**
  - Continuous clock generation
  - Configurable periods
  - Multiple clocks
  - Clock gating

- **C++: Clock Generation Patterns (Simulation Loop)**
  - Clock toggling in loop
  - Configurable periods
  - Multiple clocks
  - Clock coordination

- **Configurable Clock Periods (Both Paradigms)**
  - Parameter-based configuration
  - Runtime configuration
  - Clock period calculation
  - Frequency control

- **Multiple Clock Domains**
  - Independent clocks
  - Clock relationships
  - Domain crossing
  - Synchronization

- **Reset Generation (Synchronous, Asynchronous)**
  - Synchronous reset
  - Asynchronous reset
  - Reset timing
  - Reset sequences

- **Verilog: Reset in Initial Blocks**
  - Initial block reset
  - Reset timing control
  - Reset sequences
  - Reset coordination

- **C++: Reset in C++ Code**
  - Reset in simulation loop
  - Reset timing control
  - Reset sequences
  - Reset coordination

- **Reset Sequences and Timing**
  - Reset assertion
  - Reset deassertion
  - Reset duration
  - Reset timing

- **Clock and Reset Coordination**
  - Clock/reset relationship
  - Reset synchronization
  - Timing coordination
  - Best practices

**Examples**: `module4/examples/clock_reset/`
- `configurable_clock_reset_verilog.v`: Configurable clock and reset in Verilog
- `configurable_clock_reset_cpp.cpp`: Configurable clock and reset in C++

### 3. Stimulus Generation

- **Test Vector Generation**
  - Vector format
  - Vector generation
  - Vector storage
  - Vector application

- **Pattern Generation**
  - Pattern types
  - Pattern generation
  - Pattern application
  - Pattern verification

- **Sequential Stimulus Application**
  - Sequential application
  - Timing control
  - Application order
  - Synchronization

- **Stimulus Timing Control**
  - Timing accuracy
  - Timing relationships
  - Timing control
  - Timing verification

- **Stimulus Verification**
  - Stimulus validation
  - Stimulus checking
  - Error detection
  - Verification strategies

**Examples**: `module4/examples/modular_testbenches/`

### 4. Response Monitoring

- **Output Monitoring Strategies**
  - Real-time monitoring
  - Post-processing monitoring
  - Event-driven monitoring
  - Continuous monitoring

- **Real-Time Monitoring**
  - Immediate monitoring
  - Live updates
  - Real-time analysis
  - Performance considerations

- **Post-Processing Monitoring**
  - Delayed analysis
  - Batch processing
  - Data collection
  - Analysis strategies

- **Monitoring Timing**
  - When to monitor
  - Timing accuracy
  - Timing relationships
  - Timing control

- **Event-Driven Monitoring**
  - Event triggers
  - Event-based monitoring
  - Event handling
  - Event coordination

**Examples**: `module4/examples/modular_testbenches/`

### 5. Result Checking

- **Expected Value Calculation**
  - Expected value computation
  - Reference models
  - Calculation methods
  - Accuracy

- **Output Comparison**
  - Value comparison
  - Comparison methods
  - Comparison timing
  - Comparison accuracy

- **Error Detection and Reporting**
  - Error detection
  - Error reporting
  - Error handling
  - Error analysis

- **Assertion-Based Checking**
  - Assertion types
  - Assertion implementation
  - Assertion organization
  - Assertion best practices

- **Self-Checking Testbenches**
  - Automatic checking
  - Self-verification
  - Result aggregation
  - Pass/fail determination

**Examples**: `module4/examples/self_checking/`
- `alu_self_checking_verilog.v`: Self-checking ALU testbench in Verilog
- `alu_self_checking_cpp.cpp`: Self-checking ALU testbench in C++

### 6. Test Scenarios

- **Test Case Organization**
  - Test case structure
  - Test case organization
  - Test case management
  - Test case documentation

- **Multiple Test Scenarios**
  - Scenario definition
  - Scenario organization
  - Scenario selection
  - Scenario execution

- **Test Sequencing**
  - Test order
  - Test dependencies
  - Test sequencing
  - Test coordination

- **Test Selection Mechanisms**
  - Test selection
  - Test filtering
  - Test prioritization
  - Test management

- **Test Result Aggregation**
  - Result collection
  - Result aggregation
  - Result analysis
  - Result reporting

**Examples**: `module4/examples/self_checking/`

## Example Testbenches

### Structured Verilog Testbench for Register File
- Location: `module4/examples/modular_testbenches/register_file_test_verilog.v`
- Demonstrates: Modular structure, separate stimulus/monitor/checker modules

### Structured C++ Testbench for Register File
- Location: `module4/examples/modular_testbenches/register_file_test_cpp.cpp`
- Demonstrates: Class-based organization, separate stimulus/monitor/checker classes

### Verilog Testbench for FIFO with Multiple Scenarios
- Location: (Coming soon)
- Demonstrates: Multiple test scenarios, test sequencing

### C++ Testbench for FIFO with Multiple Scenarios
- Location: (Coming soon)
- Demonstrates: Multiple test scenarios, test sequencing

### Testbench for ALU with Comprehensive Tests (Both Paradigms)
- Location: `module4/examples/self_checking/`
- Demonstrates: Self-checking testbenches, comprehensive testing

### Testbench for State Machine (Both Paradigms)
- Location: (Coming soon)
- Demonstrates: State machine testing, state coverage

### Testbench with Configurable Parameters (Both Paradigms)
- Location: `module4/examples/clock_reset/`
- Demonstrates: Configurable clock/reset, parameterization

## Learning Outcomes

By the end of this module, you should be able to:

- Organize testbenches modularly (both paradigms)
- Generate clocks and resets properly (Verilog and C++)
- Create structured stimulus (both paradigms)
- Implement monitoring strategies (both paradigms)
- Build self-checking testbenches (both paradigms)
- Organize multiple test scenarios
- Choose appropriate organization style

## Key Exercises

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

## Assessment

- [ ] Can organize testbenches modularly (both paradigms)
- [ ] Can generate configurable clocks and resets (Verilog and C++)
- [ ] Can create structured stimulus (both paradigms)
- [ ] Can implement monitoring strategies (both paradigms)
- [ ] Can build self-checking testbenches (both paradigms)
- [ ] Can organize multiple test scenarios
- [ ] Can choose appropriate organization style

## Next Steps

After completing this module, proceed to:
- **Module 5: Procedural Testbench Writing** - Master procedural testbench construction
- **Module 6: SystemVerilog Testbench Features** - Learn SystemVerilog enhancements

## Best Practices

### Testbench Design Principles

1. **Separation of Concerns**
   - Keep stimulus, monitoring, and checking separate
   - Each component should have a single, well-defined responsibility
   - This makes testbenches easier to understand, maintain, and debug

2. **Reusability**
   - Design components to be reusable across multiple testbenches
   - Use parameters/configuration for flexibility
   - Create library components for common functionality (clocks, resets, etc.)

3. **Self-Checking**
   - Always implement automatic result checking
   - Use reference models to calculate expected values
   - Report pass/fail status clearly

4. **Documentation**
   - Comment code thoroughly, especially complex logic
   - Document component interfaces and responsibilities
   - Include usage examples in comments

5. **Error Reporting**
   - Provide clear, informative error messages
   - Include context (time, signal values, expected vs actual)
   - Aggregate errors for summary reporting

### Code Organization

**Verilog Testbench Structure:**
```
testbench_top
├── stimulus_module      (drives inputs)
├── dut                  (design under test)
├── monitor_module       (observes behavior)
└── checker_module      (validates outputs)
```

**C++ Testbench Structure:**
```cpp
main()
├── Stimulus class       (drives inputs)
├── DUT instance         (design under test)
├── Monitor class       (observes behavior)
└── Checker class       (validates outputs)
```

### Common Pitfalls to Avoid

1. **Mixing Concerns**
   - Don't combine stimulus and checking in the same module/class
   - Don't drive signals from monitor or checker components

2. **Hardcoded Values**
   - Use parameters/constants for timing and configuration
   - Avoid magic numbers in code

3. **Insufficient Checking**
   - Don't rely on manual inspection of waveforms
   - Always implement automatic checking

4. **Poor Error Messages**
   - Include enough context to debug failures
   - Use consistent error message format

5. **Inadequate Documentation**
   - Document component purpose and interfaces
   - Explain complex logic and timing relationships

## Additional Resources

- **Icarus Verilog Documentation**: http://iverilog.wikia.com/
- **Verilator Documentation**: https://verilator.org/
- **GTKWave Documentation**: http://gtkwave.sourceforge.net/
- **UVM Core Repository**: https://github.com/universal-verification-methodology/core
- **UVM User's Guide**: IEEE 1800.2-2020 Standard
- **Verification Methodology**: Best practices from industry verification teams
