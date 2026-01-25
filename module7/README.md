# Module 7: Coverage and Assertions

**Duration**: 2 weeks  
**Complexity**: Intermediate  
**Goal**: Master basic coverage analysis and assertion-based verification without SystemVerilog dependencies

## Overview

This module covers fundamental coverage analysis and assertion-based verification using basic Verilog and C++ constructs. You'll learn to measure verification completeness, write simple assertions, and use coverage to guide verification efforts. We focus on concepts that work with both iverilog and Verilator without requiring advanced SystemVerilog features.

## Directory Structure

```
module7/
├── examples/              # Learning examples for each topic
│   ├── code_coverage/      # Code coverage examples
│   ├── functional_coverage/ # Functional coverage examples
│   ├── assertions/         # Basic assertion examples
│   ├── coverage_analysis/  # Coverage analysis examples
│   └── assertion_libraries/ # Assertion library examples
├── dut/                    # Design Under Test modules (symlinked)
│   ├── simple_gates/       # Basic gates
│   └── counters/            # Counter modules
├── tests/                   # Comprehensive testbenches
│   ├── verilog_tests/       # Verilog testbenches
│   └── cpp_tests/          # C++ testbenches
└── build/                   # Build artifacts (gitignored)
```

## Quick Start

### Run All Examples and Tests

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

### Run Individual Examples

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
- What is coverage?
- Coverage types (code, functional, toggle)
- Coverage metrics
- Coverage goals
- Coverage-driven verification

### 2. Code Coverage
- Line coverage
- Branch coverage
- Condition coverage
- Path coverage
- iverilog coverage capabilities
- Verilator coverage capabilities (--coverage)
- Coverage tools and analysis

**Examples**: `examples/code_coverage/`

### 3. Functional Coverage (Manual Implementation)
- Functional coverage concepts
- Manual functional coverage using counters
- Coverage bins implementation (Verilog and C++)
- Cross coverage using manual tracking
- Coverage collection and analysis
- Verilog: Using $display/$monitor for coverage tracking
- C++: Using variables and data structures for coverage tracking

**Examples**: `examples/functional_coverage/`

### 4. Toggle Coverage
- Signal toggling
- Toggle coverage metrics
- Toggle analysis
- Coverage reporting

**Examples**: See coverage examples

### 5. Basic Assertion Concepts
- What are assertions?
- Assertion purpose and benefits
- Simple assertion patterns
- Verilog: Using if-else for assertions
- Verilog: Using $assert (if supported)
- C++: Using assert() macro
- C++: Using custom assertion functions
- Error reporting in assertions

**Examples**: `examples/assertions/`

### 6. Assertion Implementation Patterns
- Clock-based assertions
- Reset assertions
- Data validity assertions
- Protocol assertions (basic patterns)
- Assertion organization
- Reusable assertion functions/tasks
- Verilog: Assertion tasks and functions
- C++: Assertion helper functions and classes

**Examples**: `examples/assertions/`, `examples/assertion_libraries/`

### 7. Coverage Analysis
- Coverage collection
- Coverage reporting
- Coverage analysis
- Coverage gaps identification
- Coverage closure strategies

**Examples**: `examples/coverage_analysis/` (coming soon)

### 8. Coverage-Driven Test Generation
- Using coverage to guide testing
- Coverage-directed test generation
- Coverage optimization
- Test selection based on coverage

**Examples**: See coverage examples

## Examples

### Code Coverage
- **code_coverage_iverilog.v**: Manual code coverage tracking with iverilog
- **code_coverage_verilator.cpp**: Code coverage with Verilator (--coverage flag)

### Functional Coverage
- **functional_coverage_verilog.v**: Manual functional coverage using counters
- **functional_coverage_cpp.cpp**: Functional coverage using C++ data structures

### Basic Assertions
- **basic_assertions_verilog.v**: Basic assertions using if-else patterns
- **basic_assertions_cpp.cpp**: Basic assertions using assert() and custom functions

### Assertion Libraries
- **assertion_lib_verilog.v**: Reusable assertion library in Verilog
- **assertion_lib_cpp.cpp**: Reusable assertion library in C++

## Learning Outcomes

By the end of this module, you should be able to:

- ✓ Understand fundamental coverage concepts
- ✓ Measure code coverage with both tools
- ✓ Implement manual functional coverage (both paradigms)
- ✓ Write basic assertions in Verilog and C++
- ✓ Organize assertions effectively
- ✓ Analyze coverage reports
- ✓ Use coverage to guide verification
- ✓ Achieve basic coverage closure
- ✓ Apply assertion-based verification patterns

## Exercises

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

## Next Steps

After completing this module, proceed to:
- **Module 8**: Verification Methodology and Best Practices

## Additional Resources

- **Icarus Verilog Documentation**: http://iverilog.wikia.com/
- **Verilator Documentation**: https://verilator.org/
- **GTKWave Documentation**: http://gtkwave.sourceforge.net/
