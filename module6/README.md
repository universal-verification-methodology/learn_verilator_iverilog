# Module 6: SystemVerilog Testbench Features

**Duration**: 2 weeks  
**Complexity**: Intermediate-Advanced  
**Goal**: Master SystemVerilog features for advanced testbench development (primarily for iverilog, with Verilator considerations)

## Overview

This module introduces SystemVerilog features that enhance testbench capabilities. You'll learn about classes, randomization, interfaces, and other SystemVerilog constructs that make testbenches more powerful and maintainable. These concepts form the foundation of modern verification methodologies like UVM (Universal Verification Methodology).

**Key Learning Outcomes:**
- Master object-oriented testbench design using SystemVerilog classes
- Understand constrained random verification (CRV) principles
- Learn interface-based testbench organization
- Apply advanced data types for flexible testbench design
- Organize code with packages for reusability

**UVM Connection:**
The concepts in this module directly map to UVM patterns:
- **Classes** → UVM base classes (`uvm_object`, `uvm_component`, `uvm_sequence_item`)
- **Randomization** → UVM's constrained random verification framework
- **Interfaces** → UVM virtual interfaces for connecting classes to RTL
- **Packages** → UVM package organization (`uvm_pkg`)
- **Advanced Types** → UVM transaction and configuration structures

Note: Some SystemVerilog features work better with iverilog, while Verilator has limitations. C++ equivalents are provided for Verilator users.

## Directory Structure

```
module6/
├── examples/              # Learning examples for each topic
│   ├── sv_classes/         # SystemVerilog classes (iverilog)
│   ├── randomization/      # Randomization (iverilog)
│   ├── interfaces/         # SystemVerilog interfaces (iverilog)
│   ├── advanced_data_types/ # Advanced data types
│   ├── packages/           # Packages and namespaces
│   └── equivalent_cpp/     # C++ equivalent patterns
├── dut/                    # Design Under Test modules (symlinked)
│   ├── simple_gates/        # Basic gates
│   └── multiplexers/      # MUX modules
├── tests/                   # Comprehensive testbenches
│   ├── iverilog_tests/     # iverilog testbenches
│   └── cpp_tests/          # C++ testbenches
└── build/                   # Build artifacts (gitignored)
```

## Quick Start

### Run All Examples and Tests

```bash
# Run all Module 6 examples and tests
./scripts/module6.sh

# Run specific examples
./scripts/module6.sh --sv-classes
./scripts/module6.sh --randomization
./scripts/module6.sh --interfaces
./scripts/module6.sh --packages

# Show Verilator limitations and C++ equivalents
./scripts/module6.sh --equivalent-cpp
```

### Run Individual Examples

```bash
# SystemVerilog classes examples (iverilog)
cd module6/examples/sv_classes
make all

# Randomization examples (iverilog)
cd module6/examples/randomization
make all

# Interface examples (iverilog)
cd module6/examples/interfaces
make all
```

## Topics Covered

### 1. SystemVerilog Classes
- Class basics for testbenches
- Class methods and properties
- Class instantiation
- Object-oriented testbenches
- Class-based testbench organization

**Examples**: `examples/sv_classes/`
- **Note**: Primarily for iverilog. Verilator has limited class support.

### 2. Randomization
- Random variable generation ($random, $urandom)
- Constrained randomization basics
- Random test generation
- Seed control
- Randomization strategies

**Examples**: `examples/randomization/`
- **Note**: Primarily for iverilog. Verilator has limited randomization support.

### 3. SystemVerilog Interfaces
- Interface declaration and usage
- Modports for direction control
- Interface in testbenches
- Virtual interfaces
- Interface-based testbenches

**Examples**: `examples/interfaces/`
- **Note**: Primarily for iverilog. Verilator has limited interface support.

### 4. Advanced Data Types
- Structures and unions
- Enumerated types
- Dynamic arrays
- Associative arrays
- Queues

**Examples**: `examples/advanced_data_types/`

### 5. SystemVerilog Operators
- Streaming operators
- Set membership operators
- SystemVerilog-specific operators
- Operator overloading concepts

**Examples**: See advanced data types examples

### 6. Packages and Namespaces
- Package organization
- Shared definitions
- Namespace management
- Testbench library organization

**Examples**: `examples/packages/`

### 7. SystemVerilog Procedural Blocks
- Always_comb, always_ff, always_latch
- Unique and priority case
- SystemVerilog-specific constructs

**Examples**: See other examples

## Examples

### SystemVerilog Classes
- **class_based_testbench.sv**: Class-based testbench using SystemVerilog classes (iverilog)
- **class_based_testbench_cpp.cpp**: C++ equivalent for Verilator

### Randomization
- **randomized_testbench.sv**: Randomized testbench with constraints (iverilog)
- **randomized_testbench_cpp.cpp**: C++ equivalent using random number generators

### Interfaces
- **interface_based_testbench.sv**: Interface-based testbench with modports (iverilog)
- **interface_based_testbench_cpp.cpp**: C++ equivalent using structs

### Advanced Data Types
- **advanced_data_types.sv**: Demonstrates structures, unions, arrays, queues (iverilog)
- **advanced_data_types_cpp.cpp**: C++ equivalent using STL containers

### Packages
- **package_example.sv**: Package organization and namespace management (iverilog)

### Verilator Limitations
- **verilator_limitations.md**: Guide to Verilator limitations and C++ alternatives

## Learning Outcomes

By the end of this module, you should be able to:

- ✓ Use SystemVerilog classes in testbenches (iverilog)
- ✓ Implement randomization (iverilog)
- ✓ Use interfaces effectively (iverilog)
- ✓ Apply advanced data types
- ✓ Organize code with packages
- ✓ Write modern SystemVerilog testbenches
- ✓ Understand Verilator limitations and alternatives

## Exercises

1. **Convert testbench to class-based (iverilog)**
   - Use SystemVerilog classes
   - Organize testbench with classes
   - Compare with procedural approach

2. **Add randomization to testbench (iverilog)**
   - Use rand variables
   - Add constraints
   - Generate random tests

3. **Create interface-based testbench (iverilog)**
   - Define interfaces
   - Use modports
   - Connect DUT via interface

4. **Build transaction-based testbench (iverilog)**
   - Use classes for transactions
   - Implement transaction sequences
   - Verify transactions

5. **Organize testbench with packages**
   - Create packages
   - Share definitions
   - Manage namespaces

6. **Implement equivalent patterns in C++ for Verilator**
   - Use C++ classes
   - Use C++ random number generators
   - Use C++ structs for interfaces

## Tool Considerations

### iverilog
- ✅ Full SystemVerilog class support
- ✅ Randomization support
- ✅ Interface support
- ✅ Package support
- ✅ Advanced data types

### Verilator
- ❌ Limited SystemVerilog class support
- ❌ Limited randomization support
- ❌ Limited interface support
- ❌ Limited package support
- ✅ Use C++ equivalents instead

## Next Steps

After completing this module, proceed to:
- **Module 7**: Coverage and Assertions
- **Module 8**: Verification Methodology and Best Practices

## UVM Resources

This module introduces concepts that form the foundation of UVM (Universal Verification Methodology). For further learning:

- **UVM Core Repository**: https://github.com/universal-verification-methodology/core
- **Accellera UVM Standard**: https://www.accellera.org/downloads/standards/uvm
- **"SystemVerilog for Verification" by Chris Spear** - Excellent UVM foundation
- **"The UVM Primer" by Ray Salemi** - Gentle UVM introduction

See `docs/MODULE6.md` for detailed UVM concepts mapping and learning path.

## Additional Resources

- **Icarus Verilog Documentation**: http://iverilog.wikia.com/
- **Verilator Documentation**: https://verilator.org/
- **IEEE 1800-2017 Standard**: SystemVerilog Language Reference Manual
