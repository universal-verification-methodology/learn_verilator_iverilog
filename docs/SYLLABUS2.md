# Syllabus 2: RTL Verification with Verilog and SystemVerilog

**Course Duration**: 16 weeks (8 modules, 2 weeks each)  
**Target Audience**: Beginners to Intermediate Verification Engineers  
**Prerequisites**: Basic understanding of Verilog/SystemVerilog and digital design  
**Goal**: Master testbench development from fundamentals to advanced verification techniques using iverilog and Verilator

## Course Overview

This comprehensive course teaches you how to write effective testbenches for RTL verification using Verilog, SystemVerilog, iverilog, and Verilator. The course is structured to first teach you both simulators in depth (iverilog for Verilog testbenches, Verilator for C++ testbenches), then apply that knowledge to build testbenches in both paradigms. You'll learn fundamental testbench construction, procedural testbenches, SystemVerilog features, coverage analysis, and verification methodology. By the end of this course, you'll be able to create production-quality testbenches in both Verilog and C++ following industry best practices.

**Note**: This course focuses on fundamental testbench development with open-source tools. Advanced verification methodologies like UVM are covered in a separate course (learn_uvm2017_sv_verilator).

### Learning Path

```
Module 0: Installation and Setup
    ↓
Module 1: iverilog Deep Dive
    ↓
Module 2: Verilator Deep Dive
    ↓
Module 3: Testbench Fundamentals (Verilog and C++)
    ↓
Module 4: Basic Testbench Construction
    ↓
Module 5: Procedural Testbench Writing
    ↓
Module 6: SystemVerilog Testbench Features
    ↓
Module 7: Coverage and Assertions
    ↓
Module 8: Verification Methodology and Best Practices
```

### Reference Materials

- **UVM Core Repository**: https://github.com/universal-verification-methodology/core
- **IEEE 1800-2017 Standard**: SystemVerilog Language Reference Manual
- **IEEE 1364-2005 Standard**: Verilog Hardware Description Language
- **Verilator Documentation**: https://verilator.org/
- **Icarus Verilog Documentation**: http://iverilog.wikia.com/

---

## Module 0: Installation and Setup

**Duration**: 1 week  
**Complexity**: Beginner  
**Goal**: Set up verification environment with iverilog and Verilator

### Overview

This module covers the complete setup of your verification environment, including installation of iverilog, Verilator, GTKWave, and other verification tools. You'll learn the differences between these simulators and when to use each.

### Topics Covered

- System requirements and prerequisites
- Icarus Verilog (iverilog) installation and configuration
- Verilator installation and configuration
- GTKWave for waveform viewing
- VVP (Icarus Verilog runtime) usage
- Verilator compilation and simulation flow
- IDE setup for verification
- Project structure for verification
- First testbench example
- Tool comparison and selection criteria

### Learning Outcomes

By the end of this module, you should be able to:
- Install and configure iverilog and Verilator
- Understand differences between simulators
- Set up verification project structure
- Compile and run simple testbenches
- View and analyze waveforms
- Choose appropriate simulator for different scenarios

### Key Exercises

1. Install all verification tools
2. Create a simple DUT and testbench
3. Compile and simulate with iverilog
4. Compile and simulate with Verilator
5. Compare outputs and waveforms

---

## Module 1: iverilog Deep Dive

**Duration**: 2 weeks  
**Complexity**: Beginner-Intermediate  
**Goal**: Master iverilog for Verilog/SystemVerilog testbench development

### Overview

This module provides comprehensive coverage of Icarus Verilog (iverilog), an open-source Verilog simulator. You'll learn its compilation process, simulation execution, capabilities, limitations, and how to write Verilog testbenches that work with iverilog.

### Topics Covered

#### 1. iverilog Overview
- What is iverilog?
- iverilog capabilities and features
- Supported Verilog/SystemVerilog constructs
- Limitations and workarounds
- When to use iverilog

#### 2. Compilation Process
- Compilation command (iverilog)
- Command-line options and flags
- Include path management (-I)
- Define macros (-D)
- Timescale handling
- Multi-file compilation
- Library management

#### 3. Simulation Execution
- VVP (Icarus Verilog runtime) usage
- Simulation command and options
- Runtime flags
- Simulation control
- Performance considerations

#### 4. Verilog Testbench Writing for iverilog
- Verilog testbench structure
- Module-based testbenches
- Initial blocks for test sequences
- Always blocks for clock generation
- Signal access and monitoring
- $display, $monitor, $strobe
- File I/O ($readmemh, $readmemb, $fopen, $fwrite)

#### 5. Waveform Generation
- VCD file generation ($dumpfile, $dumpvars)
- Signal selection for waveforms
- GTKWave compatibility
- Waveform analysis

#### 6. Debugging with iverilog
- Compilation error debugging
- Runtime error debugging
- Signal tracing techniques
- Logging strategies
- Common pitfalls and solutions

#### 7. Advanced iverilog Features
- PLI/VPI basics
- System tasks and functions
- User-defined system tasks
- Performance optimization
- Large design handling

#### 8. Project Organization
- Makefile integration
- Scripting for automation
- Batch simulation
- Regression testing setup

### Example Testbenches

- Simple Verilog testbench for AND gate
- Verilog testbench for counter
- Verilog testbench with file I/O
- Multi-file Verilog testbench
- Complex Verilog testbench example

### Learning Outcomes

By the end of this module, you should be able to:
- Compile Verilog designs with iverilog
- Execute simulations with vvp
- Write Verilog testbenches compatible with iverilog
- Generate and analyze waveforms
- Debug iverilog compilation and simulation issues
- Organize projects using iverilog
- Automate verification flows with iverilog

### Key Exercises

1. Compile and simulate simple design with iverilog
2. Write Verilog testbench for multiplexer
3. Create testbench with file-based test vectors
4. Generate waveforms and analyze with GTKWave
5. Build Makefile for iverilog-based project

---

## Module 2: Verilator Deep Dive

**Duration**: 2 weeks  
**Complexity**: Beginner-Intermediate  
**Goal**: Master Verilator for C++ testbench development

### Overview

This module provides comprehensive coverage of Verilator, a fast Verilog/SystemVerilog simulator that generates C++ code. You'll learn its compilation process, C++ testbench writing, capabilities, limitations, and how to create efficient C++ testbenches.

### Topics Covered

#### 1. Verilator Overview
- What is Verilator?
- Verilator's compilation model
- C++ wrapper generation
- Verilator capabilities and features
- Supported Verilog/SystemVerilog constructs
- Limitations and workarounds
- When to use Verilator

#### 2. Compilation Process
- Verilator compilation command
- Compilation flags and options
- Optimization levels (-O0, -O1, -O2, -O3)
- Coverage options (--coverage)
- Linting capabilities (--lint-only)
- Waveform generation (--trace, --trace-fst)
- Include path management
- Define macros
- Multi-file compilation

#### 3. C++ Testbench Structure
- C++ main function
- Verilator-generated class usage
- DUT instantiation in C++
- Signal access (reading and writing)
- Clock generation in C++
- Reset generation in C++
- Simulation loop

#### 4. C++ Testbench Writing
- Basic C++ testbench template
- Signal access methods
- Clock and reset patterns
- Stimulus generation in C++
- Response monitoring in C++
- Result checking
- Error reporting

#### 5. Verilator C++ API
- Top module class structure
- Signal access methods
- Evaluation method (eval())
- Time management
- Tracing API
- Coverage API

#### 6. Waveform Generation
- VCD file generation
- FST file generation
- Signal selection for tracing
- GTKWave compatibility
- Waveform analysis

#### 7. Debugging with Verilator
- Compilation error debugging
- C++ compilation errors
- Runtime debugging
- Signal inspection
- Logging strategies
- Common pitfalls and solutions

#### 8. Advanced Verilator Features
- Multi-threaded simulation basics
- Performance optimization
- Large design handling
- Custom C++ integration
- SystemC integration basics

#### 9. Project Organization
- Makefile integration
- CMake integration
- Scripting for automation
- Batch simulation
- Regression testing setup

### Example Testbenches

- Simple C++ testbench for AND gate
- C++ testbench for counter
- C++ testbench with file I/O
- Multi-module C++ testbench
- Complex C++ testbench example

### Learning Outcomes

By the end of this module, you should be able to:
- Compile Verilog designs with Verilator
- Write C++ testbenches for Verilator
- Use Verilator C++ API effectively
- Generate and analyze waveforms
- Debug Verilator compilation and simulation issues
- Organize projects using Verilator
- Optimize Verilator-based testbenches

### Key Exercises

1. Compile and simulate simple design with Verilator
2. Write C++ testbench for multiplexer
3. Create C++ testbench with file-based test vectors
4. Generate waveforms and analyze with GTKWave
5. Build Makefile for Verilator-based project

---

## Module 3: Testbench Fundamentals (Verilog and C++)

**Duration**: 2 weeks  
**Complexity**: Beginner  
**Goal**: Understand testbench architecture and basic verification concepts for both Verilog and C++ testbenches

### Overview

This module introduces the fundamental concepts of testbench design for both Verilog (iverilog) and C++ (Verilator) testbenches. You'll learn what a testbench is, how it interacts with the Design Under Test (DUT), and the basic structure of verification environments in both paradigms.

### Topics Covered

#### 1. Verification Fundamentals
- What is verification?
- Testbench purpose and role
- Design Under Test (DUT) concept
- Verification vs. validation
- Verification flow and methodology
- Verilog testbench vs. C++ testbench comparison

#### 2. Testbench Architecture
- Verilog testbench module structure
- C++ testbench structure
- DUT instantiation (both paradigms)
- Signal connectivity
- Testbench hierarchy
- Top-level testbench organization

#### 3. Basic Testbench Components
- Clock generation (Verilog and C++)
- Reset generation (Verilog and C++)
- Stimulus generation (both paradigms)
- Response monitoring (both paradigms)
- Result checking (both paradigms)
- Simulation control

#### 4. Signal Access and Monitoring
- Verilog: Signal reading and writing
- C++: Signal access via Verilator API
- Verilog: $display, $monitor, $strobe
- C++: std::cout, logging libraries
- Formatting output (both paradigms)
- Timing of display statements

#### 5. Simulation Control
- Verilog: Time management (# delays)
- C++: Time management (simulation loop)
- Event scheduling concepts
- Simulation termination
- Debugging basics (both tools)

#### 6. Simple Verification Patterns
- Directed testing (both paradigms)
- Test vector application
- Expected vs. actual comparison
- Pass/fail reporting
- Basic error detection

#### 7. Paradigm Comparison
- When to use Verilog testbenches
- When to use C++ testbenches
- Performance considerations
- Debugging differences
- Tool-specific features

### Example Testbenches

- Verilog testbench for simple gates (AND, OR, XOR)
- C++ testbench for simple gates (AND, OR, XOR)
- Verilog testbench for multiplexer
- C++ testbench for multiplexer
- Verilog testbench for basic counter
- C++ testbench for basic counter
- Testbench with multiple test cases (both paradigms)

### Learning Outcomes

By the end of this module, you should be able to:
- Understand testbench purpose and structure
- Create basic Verilog testbench modules
- Create basic C++ testbenches
- Generate clocks and resets in both paradigms
- Apply stimulus to DUT (both paradigms)
- Monitor DUT outputs (both paradigms)
- Perform basic result checking
- Control simulation execution
- Choose appropriate testbench paradigm

### Key Exercises

1. Create Verilog testbench for AND gate (iverilog)
2. Create C++ testbench for AND gate (Verilator)
3. Design testbench for 4:1 multiplexer (both paradigms)
4. Build testbench for 4-bit counter (both paradigms)
5. Compare Verilog vs. C++ testbench approaches

---

## Module 4: Basic Testbench Construction

**Duration**: 2 weeks  
**Complexity**: Beginner-Intermediate  
**Goal**: Master construction of structured testbenches with proper organization

### Overview

This module focuses on building well-structured testbenches for both Verilog and C++ paradigms. You'll learn to organize testbenches into reusable components, create test scenarios, and implement proper verification patterns in both testbench styles.

### Topics Covered

#### 1. Testbench Organization
- Modular testbench structure (Verilog and C++)
- Separate stimulus, monitor, and checker components
- Verilog: Module-based organization
- C++: Class-based organization
- Testbench component organization
- Reusable testbench components
- Configuration and parameters

#### 2. Clock and Reset Generation
- Verilog: Clock generation patterns (always blocks)
- C++: Clock generation patterns (simulation loop)
- Configurable clock periods (both paradigms)
- Multiple clock domains
- Reset generation (synchronous, asynchronous)
- Verilog: Reset in initial blocks
- C++: Reset in C++ code
- Reset sequences and timing
- Clock and reset coordination

#### 3. Stimulus Generation
- Test vector generation
- Pattern generation
- Sequential stimulus application
- Stimulus timing control
- Stimulus verification

#### 4. Response Monitoring
- Output monitoring strategies
- Real-time monitoring
- Post-processing monitoring
- Monitoring timing
- Event-driven monitoring

#### 5. Result Checking
- Expected value calculation
- Output comparison
- Error detection and reporting
- Assertion-based checking
- Self-checking testbenches

#### 6. Test Scenarios
- Test case organization
- Multiple test scenarios
- Test sequencing
- Test selection mechanisms
- Test result aggregation

### Example Testbenches

- Structured Verilog testbench for register file
- Structured C++ testbench for register file
- Verilog testbench for FIFO with multiple scenarios
- C++ testbench for FIFO with multiple scenarios
- Testbench for ALU with comprehensive tests (both paradigms)
- Testbench for state machine (both paradigms)
- Testbench with configurable parameters (both paradigms)

### Learning Outcomes

By the end of this module, you should be able to:
- Organize testbenches modularly (both paradigms)
- Generate clocks and resets properly (Verilog and C++)
- Create structured stimulus (both paradigms)
- Implement monitoring strategies (both paradigms)
- Build self-checking testbenches (both paradigms)
- Organize multiple test scenarios
- Choose appropriate organization style

### Key Exercises

1. Create modular Verilog testbench for register file
2. Create modular C++ testbench for register file
3. Design testbench with configurable clock/reset (both paradigms)
4. Build testbench with multiple test scenarios (both paradigms)
5. Implement self-checking testbench (both paradigms)
6. Create reusable testbench components (both paradigms)

---

## Module 5: Procedural Testbench Writing

**Duration**: 2 weeks  
**Complexity**: Intermediate  
**Goal**: Master procedural testbench construction using Verilog procedural blocks and C++ control flow

### Overview

This module covers procedural testbench writing using Verilog's procedural blocks and C++ control structures. You'll learn to create complex test sequences, handle timing, and implement procedural verification patterns in both paradigms.

### Topics Covered

#### 1. Procedural Constructs
- Verilog: Initial blocks for test sequences
- Verilog: Always blocks for continuous behavior
- C++: Main function and control flow
- C++: Loops and conditionals
- Verilog: Blocking vs. non-blocking assignments in testbenches
- Procedural timing control (both paradigms)
- Verilog: Event control (@, wait)

#### 2. Timing Control
- Verilog: Delay control (# delays)
- Verilog: Event control (@posedge, @negedge, @*)
- C++: Time management in simulation loop
- C++: Clock cycle counting
- Verilog: Wait statements
- Timing accuracy (both paradigms)
- Race condition avoidance

#### 3. Test Sequences
- Sequential test application
- Test step implementation
- Sequence timing
- Synchronization with DUT
- Sequence verification

#### 4. Reusable Routines
- Verilog: Task definitions for test sequences
- Verilog: Function definitions for calculations
- C++: Function definitions for test sequences
- C++: Class methods for organization
- Parameter passing (both paradigms)
- Reusable verification routines

#### 5. Loops and Control Flow
- For loops in testbenches
- While loops
- Repeat loops
- Conditional execution
- Loop-based test generation

#### 6. File I/O
- Verilog: File reading ($readmemh, $readmemb)
- Verilog: File writing ($fopen, $fwrite, $fclose)
- C++: File I/O (fstream, ifstream, ofstream)
- C++: Reading test vectors
- C++: Writing results
- Test vector file formats
- Result logging to files
- File-based testbenches (both paradigms)

#### 7. Advanced Procedural Patterns
- State machine-based testbenches
- Protocol-based testbenches
- Transaction-based patterns
- Layered testbench structure

### Example Testbenches

- Procedural Verilog testbench for UART
- Procedural C++ testbench for UART
- File-based testbench with test vectors (both paradigms)
- Task/function-based reusable testbench (Verilog)
- Function/class-based reusable testbench (C++)
- State machine testbench (both paradigms)
- Protocol testbench (SPI, I2C basics) - both paradigms

### Learning Outcomes

By the end of this module, you should be able to:
- Write procedural testbenches effectively (both paradigms)
- Control timing in testbenches (Verilog and C++)
- Create complex test sequences (both paradigms)
- Use tasks/functions (Verilog) and functions/classes (C++) for organization
- Implement file-based testing (both paradigms)
- Build protocol testbenches (both paradigms)

### Key Exercises

1. Create procedural Verilog testbench with tasks
2. Create procedural C++ testbench with functions
3. Design file-based testbench (both paradigms)
4. Build protocol testbench (SPI/I2C) - both paradigms
5. Implement state machine-based testbench (both paradigms)
6. Create reusable testbench library (both paradigms)

---

## Module 6: SystemVerilog Testbench Features

**Duration**: 2 weeks  
**Complexity**: Intermediate-Advanced  
**Goal**: Master SystemVerilog features for advanced testbench development (primarily for iverilog, with Verilator considerations)

### Overview

This module introduces SystemVerilog features that enhance testbench capabilities. You'll learn about classes, randomization, interfaces, and other SystemVerilog constructs that make testbenches more powerful and maintainable. Note: Some SystemVerilog features work better with iverilog, while Verilator has limitations.

### Topics Covered

#### 1. SystemVerilog Classes
- Class basics for testbenches
- Class methods and properties
- Class instantiation
- Object-oriented testbenches
- Class-based testbench organization

#### 2. Randomization
- Random variable generation ($random, $urandom)
- Constrained randomization basics
- Random test generation
- Seed control
- Randomization strategies

#### 3. SystemVerilog Interfaces
- Interface declaration and usage
- Modports for direction control
- Interface in testbenches
- Virtual interfaces
- Interface-based testbenches

#### 4. Advanced Data Types
- Structures and unions
- Enumerated types
- Dynamic arrays
- Associative arrays
- Queues

#### 5. SystemVerilog Operators
- Streaming operators
- Set membership operators
- SystemVerilog-specific operators
- Operator overloading concepts

#### 6. Packages and Namespaces
- Package organization
- Shared definitions
- Namespace management
- Testbench library organization

#### 7. SystemVerilog Procedural Blocks
- Always_comb, always_ff, always_latch
- Unique and priority case
- SystemVerilog-specific constructs

### Example Testbenches

- Class-based testbench (iverilog)
- Randomized testbench (iverilog)
- Interface-based testbench (iverilog)
- Transaction-based testbench (iverilog)
- SystemVerilog-enhanced testbenches
- Equivalent C++ patterns for Verilator

### Learning Outcomes

By the end of this module, you should be able to:
- Use SystemVerilog classes in testbenches (iverilog)
- Implement randomization (iverilog)
- Use interfaces effectively (iverilog)
- Apply advanced data types
- Organize code with packages
- Write modern SystemVerilog testbenches
- Understand Verilator limitations and alternatives

### Key Exercises

1. Convert testbench to class-based (iverilog)
2. Add randomization to testbench (iverilog)
3. Create interface-based testbench (iverilog)
4. Build transaction-based testbench (iverilog)
5. Organize testbench with packages
6. Implement equivalent patterns in C++ for Verilator

---

## Module 7: Coverage and Assertions

**Duration**: 2 weeks  
**Complexity**: Intermediate  
**Goal**: Master basic coverage analysis and assertion-based verification without SystemVerilog dependencies

### Overview

This module covers fundamental coverage analysis and assertion-based verification using basic Verilog and C++ constructs. You'll learn to measure verification completeness, write simple assertions, and use coverage to guide verification efforts. We focus on concepts that work with both iverilog and Verilator without requiring advanced SystemVerilog features.

**Why Basic Coverage and Assertions?**
- SystemVerilog coverage (covergroups) and assertions (SVA) are covered in Module 6 and are primarily for iverilog
- This module focuses on fundamental concepts that work universally with both tools
- Manual coverage and basic assertions teach the underlying principles
- These techniques are more portable and easier to understand for beginners
- Advanced SystemVerilog coverage and assertions are better suited for the UVM course

### Topics Covered

#### 1. Coverage Fundamentals
- What is coverage?
- Coverage types (code, functional, toggle)
- Coverage metrics
- Coverage goals
- Coverage-driven verification

#### 2. Code Coverage
- Line coverage
- Branch coverage
- Condition coverage
- Path coverage
- iverilog coverage capabilities
- Verilator coverage capabilities (--coverage)
- Coverage tools and analysis

#### 3. Functional Coverage (Manual Implementation)
- Functional coverage concepts
- Manual functional coverage using counters
- Coverage bins implementation (Verilog and C++)
- Cross coverage using manual tracking
- Coverage collection and analysis
- Verilog: Using $display/$monitor for coverage tracking
- C++: Using variables and data structures for coverage tracking

#### 4. Toggle Coverage
- Signal toggling
- Toggle coverage metrics
- Toggle analysis
- Coverage reporting

#### 5. Basic Assertion Concepts
- What are assertions?
- Assertion purpose and benefits
- Simple assertion patterns
- Verilog: Using if-else for assertions
- Verilog: Using $assert (if supported)
- C++: Using assert() macro
- C++: Using custom assertion functions
- Error reporting in assertions

#### 6. Assertion Implementation Patterns
- Clock-based assertions
- Reset assertions
- Data validity assertions
- Protocol assertions (basic patterns)
- Assertion organization
- Reusable assertion functions/tasks
- Verilog: Assertion tasks and functions
- C++: Assertion helper functions and classes

#### 7. Coverage Analysis
- Coverage collection
- Coverage reporting
- Coverage analysis
- Coverage gaps identification
- Coverage closure strategies

#### 8. Coverage-Driven Test Generation
- Using coverage to guide testing
- Coverage-directed test generation
- Coverage optimization
- Test selection based on coverage

### Example Testbenches

- Testbench with code coverage (both tools)
- Testbench with manual functional coverage (both paradigms)
- Assertion-based testbench (Verilog and C++)
- Coverage-driven testbench (both tools)
- Coverage analysis examples
- Assertion library examples (both paradigms)

### Learning Outcomes

By the end of this module, you should be able to:
- Understand fundamental coverage concepts
- Measure code coverage with both tools
- Implement manual functional coverage (both paradigms)
- Write basic assertions in Verilog and C++
- Organize assertions effectively
- Analyze coverage reports
- Use coverage to guide verification
- Achieve basic coverage closure
- Apply assertion-based verification patterns

### Key Exercises

1. Add code coverage to testbench (both tools)
2. Implement manual functional coverage in Verilog
3. Implement manual functional coverage in C++
4. Write basic assertions for DUT (Verilog)
5. Write basic assertions for DUT (C++)
6. Create assertion library (both paradigms)
7. Analyze coverage reports
8. Create coverage-driven test plan

---

## Module 8: Verification Methodology and Best Practices

**Duration**: 2 weeks  
**Complexity**: Advanced  
**Goal**: Master verification methodology and industry best practices

### Overview

This module focuses on verification methodology, best practices, and preparing for real-world verification projects. You'll learn about test planning, verification metrics, documentation, and verification sign-off.

### Topics Covered

#### 1. Verification Planning
- Test plan development
- Verification strategy
- Test case identification
- Coverage planning
- Resource estimation

#### 2. Testbench Architecture Best Practices
- Modular design principles
- Reusability strategies
- Configurability
- Maintainability
- Scalability

#### 3. Coding Standards for Testbenches
- Naming conventions
- Code organization
- Commenting standards
- Documentation practices
- Style guides

#### 4. Verification Metrics
- Coverage metrics
- Bug metrics
- Test metrics
- Progress tracking
- Quality metrics

#### 5. Debugging Methodology
- Systematic debugging approach
- Debugging tools and techniques
- Logging strategies
- Error reporting
- Root cause analysis

#### 6. Regression Testing
- Regression test suite organization
- Test selection strategies
- Automation
- Continuous integration
- Regression analysis

#### 7. Verification Sign-Off
- Sign-off criteria
- Coverage closure
- Bug closure
- Documentation requirements
- Review process

#### 8. Tool Selection and Integration
- When to use iverilog
- When to use Verilator
- Tool comparison and trade-offs
- Performance considerations
- Feature comparison
- Hybrid approaches

#### 9. Project Management
- Verification project planning
- Resource management
- Schedule management
- Risk management
- Communication and reporting

#### 10. Industry Practices
- Open-source verification tools
- Industry standards
- Tool ecosystems
- Career development
- Continuing education
- Transition to commercial tools

### Example Projects

- Complete verification project
- Testbench following best practices
- Verification documentation
- Sign-off package
- Methodology examples

### Learning Outcomes

By the end of this module, you should be able to:
- Plan verification projects
- Apply best practices
- Measure verification progress
- Debug systematically
- Manage regression testing
- Achieve verification sign-off
- Apply industry methodologies

### Key Exercises

1. Create verification plan
2. Build testbench following best practices
3. Implement regression test suite
4. Create verification documentation
5. Complete verification sign-off package

---

## Course Assessment

### Module Assessments

Each module includes:
- **Practical Exercises**: Hands-on testbench development
- **Testbench Projects**: Complete verification environments
- **Code Reviews**: Peer and instructor reviews
- **Quizzes**: Concept understanding checks

### Final Project

Design and implement a complete verification environment for a complex DUT, including:
- Comprehensive testbench architecture
- Multiple test scenarios
- Coverage analysis
- Assertions
- Documentation
- Sign-off package

### Grading Criteria

- **Testbench Quality**: Well-structured, maintainable code
- **Functionality**: Testbenches work correctly
- **Coverage**: Adequate coverage achieved
- **Documentation**: Clear comments and documentation
- **Best Practices**: Follows industry best practices
- **Completeness**: All requirements met

---

## Tools and Resources

### Required Tools

- **Icarus Verilog (iverilog)**: Open-source Verilog simulator
- **Verilator**: Fast Verilog/SystemVerilog simulator
- **GTKWave**: Waveform viewer
- **Verible**: SystemVerilog linter and formatter
- **Git**: Version control
- **Coverage Tools**: Tool-specific coverage analyzers

### Reference Materials

- **UVM Core Repository**: https://github.com/universal-verification-methodology/core
- **IEEE 1800-2017**: SystemVerilog Language Reference Manual
- **IEEE 1364-2005**: Verilog Hardware Description Language
- **Verilator Documentation**: https://verilator.org/
- **Icarus Verilog Documentation**: http://iverilog.wikia.com/

### Recommended Reading

- "SystemVerilog for Verification" by Chris Spear
- "Verification Methodology Manual for SystemVerilog" by Janick Bergeron
- "Writing Testbenches: Functional Verification of HDL Models" by Janick Bergeron
- "The Art of Verification" by Faisal Haque

---

## Prerequisites

Before starting this course, you should:
- Understand basic Verilog/SystemVerilog syntax
- Have completed RTL Design course (Syllabus 1) or equivalent
- Understand digital design concepts
- Be familiar with basic Linux/command-line usage

## Next Steps

After completing this RTL Verification course, you'll be ready for:
- **UVM Methodology**: Advanced verification with UVM (see learn_uvm2017_sv_verilator repository)
- **Formal Verification**: Property-based verification
- **Advanced Topics**: Power verification, performance verification
- **Industry Projects**: Apply skills to real-world projects
- **Commercial Tools**: Transition to VCS, QuestaSim, Xcelium

---

## Support and Community

- Check module documentation for detailed examples
- Review reference testbenches in UVM core repository
- Consult tool documentation for specific issues
- Participate in code reviews
- Seek help from instructors and peers

---

**Happy Verifying! 🚀**

Start your verification journey with Module 0: Installation and Setup
