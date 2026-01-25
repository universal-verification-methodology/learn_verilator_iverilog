# RTL Verification with Verilog and SystemVerilog

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Verilog](https://img.shields.io/badge/Verilog-2005-blue.svg)](https://ieeexplore.ieee.org/document/1620780)
[![SystemVerilog](https://img.shields.io/badge/SystemVerilog-2017-green.svg)](https://ieeexplore.ieee.org/document/8299595)
[![Icarus Verilog](https://img.shields.io/badge/iverilog-Latest-orange.svg)](http://iverilog.wikia.com/)
[![Verilator](https://img.shields.io/badge/Verilator-5.042+-red.svg)](https://www.veripool.org/verilator/)

A comprehensive, modular learning path for mastering **RTL verification** using **Verilog**, **SystemVerilog**, **iverilog**, and **Verilator**. This project provides a complete educational resource with examples, testbenches, and documentation covering testbench development from fundamentals to advanced verification techniques.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Modules](#modules)
- [Installation](#installation)
- [Usage](#usage)
- [Tool Comparison](#tool-comparison)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## 🎯 Overview

This project is a complete educational resource for learning RTL verification using open-source tools. It provides:

- **8 Progressive Modules**: From installation to verification methodology
- **Comprehensive Examples**: Working examples with detailed explanations
- **Dual Paradigm Coverage**: Both Verilog (iverilog) and C++ (Verilator) testbenches
- **Automated Scripts**: Installation and orchestration scripts for easy setup
- **Full Documentation**: Detailed guides covering all concepts and usage
- **Practical Focus**: Real-world verification patterns and best practices

### Course Structure

This course teaches you how to write effective testbenches for RTL verification using both paradigms:

1. **iverilog** - For Verilog/SystemVerilog testbenches (Module 1)
2. **Verilator** - For C++ testbenches (Module 2)
3. **Testbench Fundamentals** - Core concepts for both paradigms (Module 3)
4. **Structured Testbenches** - Modular and reusable testbench construction (Modules 4-8)

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

> **📚 Note**: This course focuses on fundamental testbench development with open-source tools. Advanced verification methodologies like UVM are covered in a separate course. The patterns you'll learn here form the foundation for understanding UVM and other advanced verification frameworks.

## ✨ Features

- ✅ **Dual Simulator Coverage**: Comprehensive coverage of both iverilog and Verilator
- ✅ **Progressive Learning**: 8 modules from beginner to advanced
- ✅ **Practical Examples**: Real-world verification scenarios
- ✅ **Automated Setup**: One-command installation scripts
- ✅ **Both Paradigms**: Verilog testbenches (iverilog) and C++ testbenches (Verilator)
- ✅ **SystemVerilog Features**: Classes, interfaces, randomization (iverilog)
- ✅ **Coverage and Assertions**: Code coverage, functional coverage, basic assertions
- ✅ **Best Practices**: Industry patterns and verification methodology
- ✅ **Comprehensive Documentation**: Detailed guides for every concept
- ✅ **Exercises**: Hands-on practice for each module

## 📚 Prerequisites

### Required Knowledge

- **Hardware Description Languages**: Basic understanding of Verilog/SystemVerilog
- **Digital Design Concepts**: Flip-flops, state machines, buses, protocols
- **Programming Basics**: Understanding of procedural programming (helpful for C++ testbenches)
- **Command Line**: Basic Linux/command-line usage

### System Requirements

- **Operating System**: Linux, macOS, or Windows (WSL2 recommended)
- **Simulators**: 
  - Icarus Verilog (iverilog) - for Verilog testbenches
  - Verilator 5.042+ - for C++ testbenches
- **Waveform Viewer**: GTKWave (for viewing VCD/FST files)
- **Memory**: Minimum 4GB RAM (8GB+ recommended)
- **Disk Space**: ~2GB for tools and dependencies
- **Build Tools**: C++ compiler (GCC, Clang), Make

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd learn_verilator_iverilog
```

### 2. Install All Tools (Automated)

```bash
# Make scripts executable (Linux/Mac/WSL)
chmod +x scripts/*.sh

# Install all tools with default settings
./scripts/module0.sh
```

### 3. Run Your First Example

```bash
# Run Module 0 examples (Hello World)
./scripts/module0.sh

# Run Module 1 examples (iverilog basics)
./scripts/module1.sh

# Run Module 2 examples (Verilator basics)
./scripts/module2.sh
```

### 4. Start Learning

Begin with [Module 0: Installation and Setup](docs/MODULE0.md) and follow the modules sequentially.

## 📁 Project Structure

```
learn_verilator_iverilog/
├── docs/                      # Comprehensive documentation
│   ├── SYLLABUS2.md          # Complete course syllabus
│   ├── MODULE0.md            # Installation and setup guide
│   ├── MODULE1.md            # iverilog deep dive
│   ├── MODULE2.md            # Verilator deep dive
│   ├── MODULE3.md            # Testbench fundamentals
│   ├── MODULE4.md            # Basic testbench construction
│   ├── MODULE5.md            # Procedural testbench writing
│   ├── MODULE6.md            # SystemVerilog testbench features
│   ├── MODULE7.md            # Coverage and assertions
│   └── MODULE8.md            # Verification methodology
│
├── module0/                   # Installation and setup
│   ├── examples/             # Hello World examples
│   │   ├── iverilog_basics/   # iverilog examples
│   │   └── verilator_basics/ # Verilator examples
│   ├── dut/                   # Design Under Test modules
│   └── tests/                 # Testbenches
│
├── module1/                   # iverilog deep dive
│   ├── examples/             # iverilog examples
│   │   ├── compilation/      # Compilation process
│   │   ├── simulation/       # VVP simulation
│   │   ├── testbench_basics/ # Testbench writing
│   │   ├── file_io/          # File I/O
│   │   └── waveforms/         # Waveform generation
│   ├── dut/                   # Design Under Test
│   └── tests/                 # Testbenches
│
├── module2/                   # Verilator deep dive
│   ├── examples/             # Verilator examples
│   │   ├── compilation/      # Compilation process
│   │   ├── cpp_testbench/    # C++ testbench structure
│   │   ├── file_io/          # File I/O
│   │   └── waveforms/        # Waveform generation
│   ├── dut/                   # Design Under Test
│   └── tests/                 # Testbenches
│
├── module3/                   # Testbench fundamentals
│   ├── examples/             # Examples for both paradigms
│   │   ├── verilog_testbenches/  # Verilog testbenches
│   │   └── cpp_testbenches/      # C++ testbenches
│   └── tests/                 # Comparison tests
│
├── module4/                   # Basic testbench construction
├── module5/                   # Procedural testbench writing
├── module6/                   # SystemVerilog features
├── module7/                   # Coverage and assertions
├── module8/                   # Verification methodology
│
├── scripts/                   # Automation scripts
│   ├── module0.sh            # Install all tools
│   ├── module1.sh            # Run Module 1 examples
│   ├── ...                    # Module orchestrators
│   ├── install_*.sh          # Individual tool installers
│   └── uninstall_*.sh        # Tool uninstallers
│
└── README.md                  # This file
```

## 📖 Documentation

The `docs/` directory contains comprehensive documentation for the entire learning path:

### Core Documentation

- **[SYLLABUS2.md](docs/SYLLABUS2.md)**: Complete course syllabus with learning path, schedule, and resources

### Module Documentation

Each module has a dedicated guide with examples, exercises, and detailed explanations:

- **[MODULE0.md](docs/MODULE0.md)**: Installation and Setup
  - System requirements, tool installation, environment setup
  - Automated installation scripts usage
  - First "Hello World" testbenches

- **[MODULE1.md](docs/MODULE1.md)**: iverilog Deep Dive
  - Compilation process, VVP simulation
  - Verilog testbench writing
  - File I/O, waveform generation
  - Debugging and project organization

- **[MODULE2.md](docs/MODULE2.md)**: Verilator Deep Dive
  - Compilation process, C++ testbench writing
  - Verilator C++ API
  - File I/O, waveform generation
  - Debugging and optimization

- **[MODULE3.md](docs/MODULE3.md)**: Testbench Fundamentals
  - Testbench architecture (Verilog and C++)
  - Clock and reset generation
  - Signal access and monitoring
  - Basic verification patterns
  - Paradigm comparison

- **[MODULE4.md](docs/MODULE4.md)**: Basic Testbench Construction
  - Modular testbench organization
  - Configurable clock/reset generation
  - Structured stimulus and monitoring
  - Self-checking testbenches

- **[MODULE5.md](docs/MODULE5.md)**: Procedural Testbench Writing
  - Procedural constructs (initial, always blocks)
  - Timing control and synchronization
  - Reusable routines (tasks/functions)
  - File-based testing
  - Advanced procedural patterns

- **[MODULE6.md](docs/MODULE6.md)**: SystemVerilog Testbench Features
  - SystemVerilog classes (iverilog)
  - Randomization and constraints (iverilog)
  - Interfaces and modports (iverilog)
  - Advanced data types
  - Packages and namespaces
  - C++ equivalents for Verilator

- **[MODULE7.md](docs/MODULE7.md)**: Coverage and Assertions
  - Code coverage (both tools)
  - Manual functional coverage
  - Basic assertions (Verilog and C++)
  - Coverage analysis and closure
  - Assertion libraries

- **[MODULE8.md](docs/MODULE8.md)**: Verification Methodology and Best Practices
  - Verification planning
  - Testbench architecture best practices
  - Coding standards
  - Verification metrics
  - Regression testing
  - Verification sign-off

## 🎓 Modules

### Module 0: Installation and Setup
**Duration**: 1 week  
**Complexity**: Beginner

Set up your verification environment with all required tools:
- Icarus Verilog (iverilog) installation
- Verilator installation
- GTKWave for waveform viewing
- First "Hello World" testbenches

**Quick Start**: `./scripts/module0.sh`

### Module 1: iverilog Deep Dive
**Duration**: 2 weeks  
**Complexity**: Beginner-Intermediate

Master iverilog for Verilog/SystemVerilog testbench development:
- Compilation process and options
- VVP simulation execution
- Verilog testbench writing
- File I/O operations
- Waveform generation
- Debugging techniques

**Quick Start**: `./scripts/module1.sh`

### Module 2: Verilator Deep Dive
**Duration**: 2 weeks  
**Complexity**: Beginner-Intermediate

Master Verilator for C++ testbench development:
- Compilation process and flags
- C++ testbench structure
- Verilator C++ API
- File I/O operations
- Waveform generation
- Performance optimization

**Quick Start**: `./scripts/module2.sh`

### Module 3: Testbench Fundamentals (Verilog and C++)
**Duration**: 2 weeks  
**Complexity**: Beginner

Understand testbench architecture and basic verification concepts:
- Testbench purpose and structure
- Clock and reset generation
- Signal access and monitoring
- Basic verification patterns
- Paradigm comparison

**Quick Start**: `./scripts/module3.sh`

### Module 4: Basic Testbench Construction
**Duration**: 2 weeks  
**Complexity**: Beginner-Intermediate

Master construction of structured testbenches:
- Modular testbench organization
- Configurable clock/reset generation
- Structured stimulus and monitoring
- Self-checking testbenches
- Multiple test scenarios

**Quick Start**: `./scripts/module4.sh`

### Module 5: Procedural Testbench Writing
**Duration**: 2 weeks  
**Complexity**: Intermediate

Master procedural testbench construction:
- Procedural constructs (initial, always blocks)
- Timing control and synchronization
- Reusable routines (tasks/functions)
- File-based testing
- Protocol testbenches

**Quick Start**: `./scripts/module5.sh`

### Module 6: SystemVerilog Testbench Features
**Duration**: 2 weeks  
**Complexity**: Intermediate-Advanced

Master SystemVerilog features for advanced testbenches:
- SystemVerilog classes (iverilog)
- Randomization and constraints (iverilog)
- Interfaces and modports (iverilog)
- Advanced data types
- Packages and namespaces
- C++ equivalents for Verilator

**Quick Start**: `./scripts/module6.sh`

### Module 7: Coverage and Assertions
**Duration**: 2 weeks  
**Complexity**: Intermediate

Master coverage analysis and assertion-based verification:
- Code coverage (both tools)
- Manual functional coverage
- Basic assertions (Verilog and C++)
- Coverage analysis and closure
- Assertion libraries

**Quick Start**: `./scripts/module7.sh`

### Module 8: Verification Methodology and Best Practices
**Duration**: 2 weeks  
**Complexity**: Advanced

Master verification methodology and industry best practices:
- Verification planning
- Testbench architecture best practices
- Coding standards
- Verification metrics
- Regression testing
- Verification sign-off

**Quick Start**: `./scripts/module8.sh`

## 🔧 Installation

### Automated Installation (Recommended)

```bash
# Install all tools
./scripts/module0.sh

# Or install individual tools
./scripts/install_iverilog.sh [--system|--source]
./scripts/install_verilator.sh [--from-submodule|--system|--source]
./scripts/install_gtkwave.sh
```

### Manual Installation

See [MODULE0.md](docs/MODULE0.md) for detailed manual installation instructions.

## 💻 Usage

### Running Examples

Each module has an orchestrator script to run examples and tests:

```bash
# Run all examples for a module
./scripts/module1.sh
./scripts/module2.sh
# ... etc

# Run specific examples
./scripts/module1.sh --compilation --testbench-basics
./scripts/module2.sh --cpp-testbench --waveforms

# Run tests
./scripts/module1.sh --all-tests
```

### Running Individual Examples

```bash
# iverilog example
cd module1/examples/testbench_basics
make all

# Verilator example
cd module2/examples/cpp_testbench
make all
```

## 🔀 Tool Comparison

### iverilog (Icarus Verilog)

**Best For:**
- Learning Verilog testbench concepts
- Quick prototyping
- Simple to medium complexity designs
- Verilog/SystemVerilog testbenches
- SystemVerilog features (classes, interfaces, randomization)

**Characteristics:**
- Verilog/SystemVerilog testbenches
- Good for learning
- Easy to use
- Good waveform support
- Moderate performance
- Good SystemVerilog support

### Verilator

**Best For:**
- High-performance simulation
- Large designs
- Integration with C++ libraries
- Complex testbenches with advanced data structures
- C++ testbenches

**Characteristics:**
- C++ testbenches
- Excellent performance
- Good for large designs
- Requires C++ knowledge
- Limited SystemVerilog support (use C++ equivalents)

### When to Use Each

- **Use iverilog for:**
  - Learning Verilog testbench concepts
  - Quick prototyping
  - SystemVerilog features (classes, interfaces, randomization)
  - When you prefer Verilog syntax

- **Use Verilator for:**
  - High-performance simulation
  - Large designs
  - Integration with C++ libraries
  - Complex testbenches with advanced data structures

See [MODULE8.md](docs/MODULE8.md) for detailed tool comparison and selection guide.

## 🤝 Contributing

Contributions are welcome! This project follows best practices for educational resources:

1. **Code Quality**: All code follows Verilog/SystemVerilog/C++ best practices with comprehensive comments
2. **Documentation**: Comprehensive docstrings and comments
3. **Testing**: Examples are tested and verified
4. **Consistency**: Follow existing patterns and structure

### Contribution Guidelines

- Follow the existing code style and structure
- Add comprehensive comments to all code
- Update relevant documentation
- Test your changes thoroughly
- Follow the module structure for new examples
- Document tool limitations and alternatives

## 📄 License

This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

[![CC BY 4.0](https://i.creativecommons.org/l/by/4.0/88x31.png)](https://creativecommons.org/licenses/by/4.0/)

### What this means:

- ✅ **You are free to:**
  - Share — copy and redistribute the material in any medium or format
  - Adapt — remix, transform, and build upon the material for any purpose, even commercially

- 📝 **Under the following terms:**
  - **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

### Attribution

When using this material, please include:

```
Based on "RTL Verification with Verilog and SystemVerilog" by Yongfu Li
Licensed under CC BY 4.0
https://creativecommons.org/licenses/by/4.0/
```

## 🙏 Acknowledgments

This project is built on the excellent work of:

- **Icarus Verilog (iverilog)**: Open-source Verilog/SystemVerilog simulator
  - Website: http://iverilog.wikia.com/
  - GitHub: https://github.com/steveicarus/iverilog

- **Verilator**: Fast Verilog/SystemVerilog simulator
  - Website: https://www.veripool.org/verilator/
  - GitHub: https://github.com/verilator/verilator

- **GTKWave**: Waveform viewer
  - Website: http://gtkwave.sourceforge.net/

- **Verilog**: IEEE 1364-2005 Standard
- **SystemVerilog**: IEEE 1800-2017 Standard

### Educational Resources

- Verification Academy: https://verificationacademy.com/
- IEEE Design & Test publications
- DVCon proceedings

## 📞 Support

For questions, issues, or contributions:

1. Check the [documentation](docs/) first
2. Review the [SYLLABUS2.md](docs/SYLLABUS2.md) for course overview
3. Check module-specific documentation for detailed information
4. Open an issue for bugs or feature requests

## 📊 Project Statistics

- **8 Modules**: Complete learning path
- **50+ Examples**: Working code examples
- **20+ Testbenches**: Verilog and C++ testbenches
- **15+ Scripts**: Automation and orchestration
- **10 Documentation Files**: Comprehensive guides

## 🎯 Next Steps

After completing this RTL Verification course, you'll be ready for:

- **UVM Methodology**: Advanced verification with UVM (see separate UVM course)
- **Formal Verification**: Property-based verification
- **Advanced Topics**: Power verification, performance verification
- **Industry Projects**: Apply skills to real-world projects
- **Commercial Tools**: Transition to VCS, QuestaSim, Xcelium

---

**Happy Verifying! 🚀**

Start your verification journey today with Module 0: [Installation and Setup](docs/MODULE0.md)
