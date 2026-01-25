# Module 7: Coverage and Assertions

**Duration**: 2 weeks  
**Complexity**: Intermediate  
**Goal**: Master basic coverage analysis and assertion-based verification without SystemVerilog dependencies

---

## Navigation

[← Previous: Module 6: SystemVerilog Testbench Features](MODULE6.md) | [Next: Module 8: Verification Methodology →](MODULE8.md)

[↑ Back to README](../README.md) | [📚 Full Syllabus](SYLLABUS2.md)

---

## Overview

This module covers fundamental coverage analysis and assertion-based verification using basic Verilog and C++ constructs. You'll learn to measure verification completeness, write simple assertions, and use coverage to guide verification efforts. We focus on concepts that work with both iverilog and Verilator without requiring advanced SystemVerilog features.

**Why Basic Coverage and Assertions?**
- SystemVerilog coverage (covergroups) and assertions (SVA) are covered in Module 6 and are primarily for iverilog
- This module focuses on fundamental concepts that work universally with both tools
- Manual coverage and basic assertions teach the underlying principles
- These techniques are more portable and easier to understand for beginners
- Advanced SystemVerilog coverage and assertions are better suited for the UVM course

### Examples and Code Structure

This module includes comprehensive examples and testbenches located in the `module7/` directory:

```
module7/
├── examples/              # Learning examples for each topic
│   ├── code_coverage/      # Code coverage examples
│   ├── functional_coverage/ # Functional coverage examples
│   ├── assertions/         # Basic assertion examples
│   ├── coverage_analysis/  # Coverage analysis examples
│   └── assertion_libraries/ # Assertion library examples
├── dut/                    # Design Under Test modules (symlinked)
│   ├── simple_gates/        # Basic gates
│   └── counters/            # Counter modules
├── tests/                  # Comprehensive testbenches
│   ├── verilog_tests/       # Verilog testbenches
│   └── cpp_tests/           # C++ testbenches
└── README.md              # Module 7 documentation
```

### Quick Start

**Run all examples using the orchestrator script:**
```bash
# Run all Module 7 examples and tests
./scripts/module7.sh

# Run specific examples
./scripts/module7.sh --code-coverage
./scripts/module7.sh --functional-coverage
./scripts/module7.sh --assertions
./scripts/module7.sh --assertion-libraries

# Run all tests
./scripts/module7.sh --all-tests
```

**Run examples individually:**
```bash
# Code coverage examples
cd module7/examples/code_coverage
make all

# Functional coverage examples
cd module7/examples/functional_coverage
make all

# Assertion examples
cd module7/examples/assertions
make all
```

## Topics Covered

### 1. Coverage Fundamentals

- **What is Coverage?**
  - Verification completeness
  - Coverage metrics
  - Coverage goals
  - Coverage-driven verification

- **Coverage Types (Code, Functional, Toggle)**
  - Code coverage
  - Functional coverage
  - Toggle coverage
  - Coverage relationships

- **Coverage Metrics**
  - Coverage percentage
  - Coverage bins
  - Coverage goals
  - Coverage closure

- **Coverage Goals**
  - Setting coverage targets
  - Coverage planning
  - Coverage achievement
  - Coverage sign-off

- **Coverage-Driven Verification**
  - Using coverage to guide testing
  - Coverage-directed test generation
  - Coverage optimization
  - Coverage best practices

### 2. Code Coverage

- **Line Coverage**
  - Line execution
  - Line coverage metrics
  - Line coverage analysis

- **Branch Coverage**
  - Branch execution
  - Branch coverage metrics
  - Branch coverage analysis

- **Condition Coverage**
  - Condition execution
  - Condition coverage metrics
  - Condition coverage analysis

- **Path Coverage**
  - Path execution
  - Path coverage metrics
  - Path coverage analysis

- **iverilog Coverage Capabilities**
  - Built-in coverage
  - Coverage limitations
  - Coverage tools
  - Coverage analysis

- **Verilator Coverage Capabilities (--coverage)**
  - Coverage flag
  - Coverage generation
  - Coverage data
  - Coverage analysis

- **Coverage Tools and Analysis**
  - Coverage tools
  - Coverage analysis
  - Coverage reporting
  - Coverage best practices

**Examples**: `module7/examples/code_coverage/`
- `code_coverage_iverilog.v`: Manual code coverage tracking with iverilog
- `code_coverage_verilator.cpp`: Code coverage with Verilator (--coverage flag)

### 3. Functional Coverage (Manual Implementation)

- **Functional Coverage Concepts**
  - Functional coverage definition
  - Coverage bins
  - Coverage goals
  - Coverage metrics

- **Manual Functional Coverage Using Counters**
  - Counter-based tracking
  - Coverage bin implementation
  - Coverage collection
  - Coverage analysis

- **Coverage Bins Implementation (Verilog and C++)**
  - Bin definition
  - Bin tracking
  - Bin coverage
  - Bin analysis

- **Cross Coverage Using Manual Tracking**
  - Cross coverage definition
  - Cross coverage tracking
  - Cross coverage analysis
  - Cross coverage best practices

- **Coverage Collection and Analysis**
  - Coverage collection
  - Coverage storage
  - Coverage analysis
  - Coverage reporting

- **Verilog: Using $display/$monitor for Coverage Tracking**
  - Display-based tracking
  - Monitor-based tracking
  - Coverage logging
  - Coverage analysis

- **C++: Using Variables and Data Structures for Coverage Tracking**
  - Variable-based tracking
  - Data structure tracking
  - Coverage storage
  - Coverage analysis

**Examples**: `module7/examples/functional_coverage/`
- `functional_coverage_verilog.v`: Manual functional coverage using counters
- `functional_coverage_cpp.cpp`: Functional coverage using C++ data structures

### 4. Toggle Coverage

- **Signal Toggling**
  - Toggle definition
  - Toggle tracking
  - Toggle metrics
  - Toggle analysis

- **Toggle Coverage Metrics**
  - Toggle percentage
  - Toggle goals
  - Toggle closure
  - Toggle best practices

- **Toggle Analysis**
  - Toggle identification
  - Toggle gaps
  - Toggle optimization
  - Toggle best practices

- **Coverage Reporting**
  - Toggle reports
  - Toggle visualization
  - Toggle documentation
  - Toggle best practices

**Examples**: See coverage examples

### 5. Basic Assertion Concepts

- **What are Assertions?**
  - Assertion definition
  - Assertion purpose
  - Assertion benefits
  - Assertion types

- **Assertion Purpose and Benefits**
  - Design verification
  - Bug detection
  - Documentation
  - Debugging aid

- **Simple Assertion Patterns**
  - Equality assertions
  - Range assertions
  - Boolean assertions
  - Timing assertions

- **Verilog: Using if-else for Assertions**
  - If-else patterns
  - Assertion implementation
  - Error reporting
  - Assertion best practices

- **Verilog: Using $assert (if supported)**
  - $assert syntax
  - $assert usage
  - $assert limitations
  - $assert best practices

- **C++: Using assert() Macro**
  - assert() syntax
  - assert() usage
  - assert() limitations
  - assert() best practices

- **C++: Using Custom Assertion Functions**
  - Custom function design
  - Custom function implementation
  - Custom function usage
  - Custom function best practices

- **Error Reporting in Assertions**
  - Error messages
  - Error logging
  - Error handling
  - Error best practices

**Examples**: `module7/examples/assertions/`
- `basic_assertions_verilog.v`: Basic assertions using if-else patterns
- `basic_assertions_cpp.cpp`: Basic assertions using assert() and custom functions

### 6. Assertion Implementation Patterns

- **Clock-Based Assertions**
  - Clock synchronization
  - Clock-based checks
  - Clock assertion patterns
  - Clock assertion best practices

- **Reset Assertions**
  - Reset checks
  - Reset assertion patterns
  - Reset assertion timing
  - Reset assertion best practices

- **Data Validity Assertions**
  - Data range checks
  - Data validity patterns
  - Data assertion implementation
  - Data assertion best practices

- **Protocol Assertions (Basic Patterns)**
  - Protocol checks
  - Protocol assertion patterns
  - Protocol assertion implementation
  - Protocol assertion best practices

- **Assertion Organization**
  - Assertion placement
  - Assertion grouping
  - Assertion hierarchy
  - Assertion organization best practices

- **Reusable Assertion Functions/Tasks**
  - Assertion library design
  - Assertion library implementation
  - Assertion library usage
  - Assertion library best practices

- **Verilog: Assertion Tasks and Functions**
  - Task-based assertions
  - Function-based assertions
  - Assertion organization
  - Assertion best practices

- **C++: Assertion Helper Functions and Classes**
  - Function-based assertions
  - Class-based assertions
  - Assertion organization
  - Assertion best practices

**Examples**: `module7/examples/assertions/`, `module7/examples/assertion_libraries/`
- `assertion_lib_verilog.v`: Reusable assertion library in Verilog
- `assertion_lib_cpp.cpp`: Reusable assertion library in C++

### 7. Coverage Analysis

- **Coverage Collection**
  - Coverage data collection
  - Coverage storage
  - Coverage management
  - Coverage best practices

- **Coverage Reporting**
  - Coverage report generation
  - Coverage report format
  - Coverage report analysis
  - Coverage report best practices

- **Coverage Analysis**
  - Coverage gap identification
  - Coverage analysis methods
  - Coverage optimization
  - Coverage best practices

- **Coverage Gaps Identification**
  - Gap identification
  - Gap analysis
  - Gap closure
  - Gap best practices

- **Coverage Closure Strategies**
  - Closure planning
  - Closure methods
  - Closure achievement
  - Closure best practices

**Examples**: `module7/examples/coverage_analysis/` (coming soon)

### 8. Coverage-Driven Test Generation

- **Using Coverage to Guide Testing**
  - Coverage-directed testing
  - Coverage-based test selection
  - Coverage optimization
  - Coverage best practices

- **Coverage-Directed Test Generation**
  - Test generation methods
  - Test generation strategies
  - Test generation optimization
  - Test generation best practices

- **Coverage Optimization**
  - Coverage improvement
  - Coverage optimization methods
  - Coverage optimization strategies
  - Coverage optimization best practices

- **Test Selection Based on Coverage**
  - Test selection methods
  - Test selection strategies
  - Test selection optimization
  - Test selection best practices

**Examples**: See coverage examples

## Example Testbenches

### Testbench with Code Coverage (Both Tools)
- Location: `module7/examples/code_coverage/`
- Demonstrates: Code coverage tracking and analysis

### Testbench with Manual Functional Coverage (Both Paradigms)
- Location: `module7/examples/functional_coverage/`
- Demonstrates: Manual functional coverage implementation

### Assertion-Based Testbench (Verilog and C++)
- Location: `module7/examples/assertions/`
- Demonstrates: Basic assertion patterns and implementation

### Coverage-Driven Testbench (Both Tools)
- Location: See coverage examples
- Demonstrates: Coverage-driven test generation

### Coverage Analysis Examples
- Location: `module7/examples/coverage_analysis/` (coming soon)
- Demonstrates: Coverage analysis and closure

### Assertion Library Examples (Both Paradigms)
- Location: `module7/examples/assertion_libraries/`
- Demonstrates: Reusable assertion libraries

## Learning Outcomes

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

## Key Exercises

1. **Add code coverage to testbench (both tools)**
   - Use tool-specific coverage flags
   - Track coverage manually
   - Analyze coverage reports

2. **Implement manual functional coverage in Verilog**
   - Create coverage bins
   - Track coverage manually
   - Generate coverage reports

3. **Implement manual functional coverage in C++**
   - Use C++ data structures
   - Track coverage manually
   - Generate coverage reports

4. **Write basic assertions for DUT (Verilog)**
   - Use if-else patterns
   - Create assertion tasks
   - Organize assertions

5. **Write basic assertions for DUT (C++)**
   - Use assert() macro
   - Create custom assertion functions
   - Organize assertions

6. **Create assertion library (both paradigms)**
   - Design reusable assertions
   - Organize assertion library
   - Use assertion library

7. **Analyze coverage reports**
   - Identify coverage gaps
   - Plan coverage closure
   - Achieve coverage goals

8. **Create coverage-driven test plan**
   - Use coverage to guide testing
   - Generate tests based on coverage
   - Optimize test selection

## Assessment

- [ ] Can understand fundamental coverage concepts
- [ ] Can measure code coverage with both tools
- [ ] Can implement manual functional coverage (both paradigms)
- [ ] Can write basic assertions in Verilog and C++
- [ ] Can organize assertions effectively
- [ ] Can analyze coverage reports
- [ ] Can use coverage to guide verification
- [ ] Can achieve basic coverage closure
- [ ] Can apply assertion-based verification patterns

## Next Steps

After completing this module, proceed to:
- **Module 8: Verification Methodology and Best Practices** - Learn industry best practices and verification sign-off

## Additional Resources

- **Icarus Verilog Documentation**: http://iverilog.wikia.com/
- **Verilator Documentation**: https://verilator.org/
- **GTKWave Documentation**: http://gtkwave.sourceforge.net/
- **IEEE 1364-2005 Standard**: Verilog Hardware Description Language
