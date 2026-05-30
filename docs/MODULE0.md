# Module 0: Installation and Setup

**Goal**: Set up verification environment with iverilog and Verilator

---

## Navigation

[← Previous: N/A (First Module)] | [Next: Module 1: iverilog Deep Dive →](MODULE1.md)

[↑ Back to README](../README.md) | [📚 Full Syllabus](SYLLABUS2.md)



- **Slides & video**: [slides.pptx](../media/module0/slides.pptx) · [slides.pdf](../media/module0/slides.pdf) · [video.mp4](../media/module0/video.mp4) — regenerate: `./scripts/build_all_media.sh --module 0`
---

## Overview

This module covers the complete setup of your verification environment, including installation of iverilog, Verilator, GTKWave, and other verification tools. You'll learn the differences between these simulators and when to use each.

### What You'll Learn

- **Tool Installation**: Automated and manual installation methods for all verification tools
- **Environment Setup**: Configure your development environment for efficient verification work
- **First Testbenches**: Create and run your first "Hello World" testbenches in both paradigms
- **Waveform Analysis**: Generate and view waveforms using GTKWave
- **Project Structure**: Organize your verification project following best practices
- **Tool Comparison**: Understand when to use iverilog vs Verilator

### Prerequisites

Before starting this module, you should:
- [ ] Have a Linux, macOS, or Windows (WSL2) system
- [ ] Have basic command-line knowledge
- [ ] Have Git installed (for cloning the repository)
- [ ] Have a C/C++ compiler available (GCC, Clang, or MSVC)

### Verification Methodology Context

While this module focuses on basic tool setup, the patterns you'll learn here form the foundation for more advanced verification methodologies:

- **Testbench Structure**: The basic testbench patterns shown here (DUT instantiation, stimulus generation, checking) are fundamental to all verification approaches, including UVM (Universal Verification Methodology)
- **Self-Checking Testbenches**: The examples demonstrate self-checking testbenches that automatically verify correctness, a core principle in modern verification
- **Reusable Components**: The testbench organization patterns (tasks in Verilog, classes in C++) are building blocks for more complex verification environments

> **Note**: For advanced UVM examples and patterns, see the [Universal Verification Methodology (UVM) Core Repository](https://github.com/universal-verification-methodology/core). The patterns in this module provide the foundation for understanding UVM's component-based architecture.

### Automated Installation Scripts

This project includes automated installation scripts to simplify the setup process. You can use these scripts to install all tools automatically, or install them manually using the instructions in each section.

**Quick Start (All-in-One Installation)**:
```bash
# Make scripts executable (Linux/Mac/WSL)
chmod +x scripts/*.sh

# Install iverilog
./scripts/install_iverilog.sh

# Install Verilator
./scripts/install_verilator.sh

# Verify installations
iverilog -v
verilator --version
```

**Individual Tool Installation**:
- Icarus Verilog: `./scripts/install_iverilog.sh [--system|--source]`
- Verilator: `./scripts/install_verilator.sh [--from-submodule|--system|--source]`
- GTKWave: Usually installed with iverilog package, or separately via package manager

---

## Quick Reference

### Common Commands
```bash
# Verify iverilog installation
iverilog -v

# Verify Verilator installation
verilator --version

# Verify GTKWave installation
gtkwave --version

# Run first iverilog test
cd module0/examples/iverilog_basics
make hello_world

# Run first Verilator test
cd module0/examples/verilator_basics
make hello_world
```

### Key File Locations
- Installation Scripts: `scripts/install_*.sh`
- Module 0 Examples: `module0/examples/`
- Module 0 DUT: `module0/dut/`
- Module 0 Tests: `module0/tests/`

### Key Concepts
- **iverilog**: Open-source Verilog/SystemVerilog simulator
- **Verilator**: Fast Verilog/SystemVerilog simulator (generates C++)
- **GTKWave**: Waveform viewer for VCD/FST files
- **VVP**: Icarus Verilog runtime (executes compiled designs)

---


## Design Architecture

### 1. Verification toolchain layout

- **Host environment**: Linux, macOS, or WSL2 with GCC/Clang, Make, and Git
- **Icarus path**: `iverilog` compiles RTL + TB → `simv` (or named binary) executed by `vvp`
- **Verilator path**: `verilator --cc` emits C++ model under `obj_dir/` linked with a C++ testbench
- **Waveform path**: Simulators write VCD/FST; **GTKWave** visualizes signal transitions
- **Course layout**: `scripts/install_*.sh`, `module0/examples/`, `module0/dut/`, `module0/tests/`

### 2. Reference DUT hierarchy (Module 0)

- **`module0/dut/simple_gates/`**: Combinational `and_gate`, `or_gate` — minimal port lists (a, b, y)
- **`module0/dut/counters/`**: `simple_counter` — clocked sequential logic with enable and reset
- **Hierarchy depth**: Flat RTL (no sub-modules) so install smoke tests stay fast
- **TB attachment**: Testbench modules instantiate DUT at top level; no bus fabric yet

### 3. First simulation artifact flow

- **iverilog**: `iverilog -o sim tb.v dut.v` → `vvp sim` → optional `$dumpfile` VCD
- **Verilator**: `verilator --cc --exe` → `make -C obj_dir` → `./obj_dir/Vdut`
- **Build dirs**: Per-example `Makefile` targets; artifacts under `build/` or `obj_dir/` (gitignored)

## Verification & Testing Methods

### 1. Install and environment verification

- **Version checks**: `iverilog -v`, `verilator --version`, `gtkwave --version`
- **PATH and compiler**: Confirm `g++`/`gcc` available for Verilator link step
- **Self-check**: `./scripts/module0.sh --check` validates examples and DUT compiles

### 2. Hello-world test methodology

- **Smoke test**: Minimal compile-and-run per tool (no functional depth required)
- **Pass criteria**: Clean compile, simulation exits 0, expected `$display` or C++ `printf`
- **Waveform spot-check**: Open generated VCD in GTKWave to confirm clock/reset toggles

### 3. Debugging and regression basics

- **Log-first**: Capture simulator stdout; use `-g` / `--trace` when examples enable it
- **Compare tools**: Run same DUT with iverilog vs Verilator to see flow differences
- **Repeatability**: Document working directory and Make target in `commands_to_try.txt`

## Topics Covered

### 1. System Requirements and Prerequisites

- **Operating System Support**
  - Linux (Ubuntu/Debian, CentOS/RHEL, Fedora)
  - macOS (Intel and Apple Silicon)
  - Windows (WSL2 recommended)
  
- **Hardware Requirements**
  - Minimum 4GB RAM (8GB+ recommended)
  - 5GB free disk space
  - Multi-core processor recommended

- **Software Prerequisites**
  - C/C++ compiler (GCC 7+, Clang 10+, or MSVC)
  - Make or Ninja build system
  - Git
  - Perl (for some tools)

### 2. Icarus Verilog (iverilog) Installation

- **What is iverilog?**
  - Open-source Verilog/SystemVerilog simulator
  - Good for learning and prototyping
  - Supports most Verilog constructs
  - Limited SystemVerilog support

- **Automated Installation (Recommended)**
  - **Using the installation script**:
    ```bash
    # Install from system package manager (default)
    ./scripts/install_iverilog.sh --system
    
    # Build from source
    ./scripts/install_iverilog.sh --source
    ```
  - The script automatically:
    - Checks for existing installations
    - Installs system dependencies (build tools, libraries)
    - Builds and installs iverilog
    - Verifies the installation

- **Manual Installation Methods**
  - **Linux Installation**
    - Ubuntu/Debian: `sudo apt-get install iverilog gtkwave`
    - CentOS/RHEL: `sudo yum install iverilog gtkwave`
    - Fedora: `sudo dnf install iverilog gtkwave`
    - Building from source (latest features)
  
  - **macOS Installation**
    - Homebrew installation: `brew install icarus-verilog gtkwave`
    - Building from source
  
  - **Windows/WSL2 Installation**
    - Installing in WSL2 Ubuntu: `sudo apt-get install iverilog gtkwave`
    - Building from source in WSL2

- **Verification Steps**
  - Check iverilog version: `iverilog -v`
  - Check vvp runtime: `vvp -v`
  - Run simple test: `echo 'module test; initial $display("Hello"); endmodule' | iverilog -o test - && vvp test`

### 3. Verilator Installation

- **What is Verilator?**
  - Fast Verilog/SystemVerilog simulator
  - Generates C++ code from Verilog
  - Excellent performance
  - Limited SystemVerilog support (some features)

- **Automated Installation (Recommended)**
  - **Using the installation script**:
    ```bash
    # Install from git submodule (default - builds from source)
    ./scripts/install_verilator.sh --from-submodule
    
    # Install from system package manager
    ./scripts/install_verilator.sh --system
    
    # Build from source (clones if submodule doesn't exist)
    ./scripts/install_verilator.sh --source
    ```
  - The script automatically:
    - Checks for existing installations
    - Installs system dependencies (build tools, libraries)
    - Sets up git submodule in `tools/verilator/`
    - Builds and installs Verilator
    - Verifies the installation

- **Manual Installation Methods**
  - **Linux Installation**
    - Ubuntu/Debian: `sudo apt-get install verilator`
    - CentOS/RHEL: `sudo yum install verilator`
    - Fedora: `sudo dnf install verilator`
    - Building from source (latest features)
  
  - **macOS Installation**
    - Homebrew installation: `brew install verilator`
    - Building from source
  
  - **Windows/WSL2 Installation**
    - Installing in WSL2 Ubuntu: `sudo apt-get install verilator`
    - Building from source in WSL2

- **Verification Steps**
  - Check Verilator version: `verilator --version`
  - Run simple test: Create a minimal Verilog file and compile with Verilator

### 4. GTKWave Installation

- **What is GTKWave?**
  - Waveform viewer for VCD and FST files
  - Essential for debugging testbenches
  - Open-source and cross-platform

- **Installation**
  - Usually installed with iverilog package
  - Linux: `sudo apt-get install gtkwave` (or included with iverilog)
  - macOS: `brew install gtkwave` (or included with icarus-verilog)
  - Windows: Available as standalone installer

- **Verification Steps**
  - Check GTKWave: `gtkwave --version`
  - Open a VCD file: `gtkwave waveform.vcd`

### 5. Build System Configuration

- **Makefile Setup**
  - Basic Makefile for iverilog
  - Basic Makefile for Verilator
  - Compilation flags
  - Include paths
  - Test execution

- **iverilog Compilation**
  - Compilation command: `iverilog -o output input.v`
  - Include paths: `-I<directory>`
  - Define macros: `-D<macro>`
  - Timescale handling
  - Multi-file compilation

- **Verilator Compilation**
  - Compilation command: `verilator --cc --exe design.v testbench.cpp`
  - SystemVerilog flags: `-sv`, `--timing`
  - Include paths: `-I<directory>`
  - Optimization flags: `-O0`, `-O1`, `-O2`, `-O3`
  - Coverage options: `--coverage`
  - Waveform generation: `--trace`, `--trace-fst`

### 6. IDE Setup and Configuration

- **Recommended IDEs**
  - VS Code with Verilog/SystemVerilog extension
  - Verible (SystemVerilog linter/formatter)
  - Vim/Neovim with LSP
  - Emacs with Verilog mode

- **VS Code Configuration**
  - SystemVerilog extension setup
  - iverilog integration
  - Verilator integration
  - Debugging configuration
  - Task runner setup for simulations
  - Extension recommendations

- **Editor Configuration**
  - SystemVerilog formatting (Verible)
  - Linting (Verilator, Verible)
  - Code formatting on save
  - Syntax highlighting

### 7. Project Structure Setup

- **Directory Structure**
  - Source code organization
  - Test directory structure
  - DUT (Design Under Test) organization
  - Configuration files
  - `tools/` directory for tools (Verilator as git submodule)

- **Git Submodules Management**
  - Verilator is managed as a git submodule in `tools/verilator/`
  - Initialize submodules: `./scripts/init_submodules.sh` or `git submodule update --init --recursive`
  - Update submodules: `./scripts/update_submodules.sh` or `git submodule update --remote`
  - Add new submodule: `./scripts/add_submodule.sh <repo_url> <path>`
  - Remove submodule: `./scripts/remove_submodule.sh <path>`

- **Makefile/Configuration**
  - Simple Makefile for running tests
  - iverilog configuration
  - Verilator configuration
  - Environment variable management

- **Version Control**
  - Git initialization
  - .gitignore for Verilog and simulation (include build artifacts, waveforms)
  - Initial commit structure
  - Git submodules in `.gitmodules` file

### 8. First "Hello World" Verification Test

- **Prerequisites**
  - Ensure all tools are installed
  - Verify tools are accessible: `iverilog -v` and `verilator --version`

- **iverilog Hello World**
  - **Location**: `module0/examples/iverilog_basics/hello_world.v`
  - **Purpose**: Simplest possible testbench to verify iverilog installation
  - **Key Concepts**:
    - `module` declaration (testbench has no ports)
    - `initial` block for procedural code execution
    - `$display` system task for output
    - `$finish` system task to end simulation
    - Time delays with `#delay`
  - **Compilation**: `iverilog -o hello_world hello_world.v`
  - **Simulation**: `vvp hello_world`
  - **Understanding Output**: Console messages confirm successful execution

- **GTKWave Waveform Example**
  - **Location**: `module0/examples/iverilog_basics/gtkwave_example.v`
  - **Purpose**: Comprehensive example demonstrating waveform generation and analysis
  - **Key Concepts**:
    - VCD (Value Change Dump) file generation with `$dumpfile` and `$dumpvars`
    - Clock generation using `forever` loops
    - Multiple signal types (clock, data, control signals)
    - Signal transitions for timing analysis
    - Test phases and patterns
  - **Compilation**: `iverilog -o gtkwave_example gtkwave_example.v ../../dut/simple_gates/and_gate.v`
  - **Simulation**: `vvp gtkwave_example` (generates `gtkwave_example.vcd`)
  - **Viewing**: `gtkwave gtkwave_example.vcd` or `make view_waveforms`
  - **GTKWave Features Demonstrated**:
    - Signal hierarchy navigation
    - Time marker placement
    - Zoom and pan operations
    - Save file creation for quick reload

- **Verilator Hello World**
  - **Location**: `module0/examples/verilator_basics/hello_world.cpp` and `hello_world.v`
  - **Purpose**: Simplest possible C++ testbench to verify Verilator installation
  - **Key Concepts**:
    - Verilator compilation process (`verilator --cc --exe --build`)
    - Generated C++ class structure (`V<module_name>`)
    - DUT instantiation in C++
    - `eval()` method for simulation
    - `final()` method for cleanup
    - Verilator initialization with `Verilated::commandArgs()`
  - **Compilation**: `verilator --cc --exe --build hello_world.v hello_world.cpp`
  - **Running**: `./obj_dir/Vhello_world`
  - **Understanding Output**: Console messages confirm successful execution

### 9. Tool Comparison and Selection Criteria

- **iverilog Characteristics**
  - Verilog/SystemVerilog testbenches
  - Good for learning
  - Easy to use
  - Good waveform support
  - Moderate performance

- **Verilator Characteristics**
  - C++ testbenches
  - Excellent performance
  - Good for large designs
  - Requires C++ knowledge
  - Limited SystemVerilog support

- **When to Use Each**
  - Use iverilog for:
    - Learning Verilog testbench concepts
    - Quick prototyping
    - Simple to medium complexity designs
    - When you prefer Verilog syntax
  
  - Use Verilator for:
    - High-performance simulation
    - Large designs
    - Integration with C++ libraries
    - Complex testbenches with advanced data structures

### 10. Common Pitfalls and Solutions

#### Pitfall 1: Installation Script Permissions

**Problem**: Scripts won't execute
```bash
./scripts/install_iverilog.sh
# Error: Permission denied
```

**Solution**: Make scripts executable
```bash
chmod +x scripts/*.sh
./scripts/install_iverilog.sh
```

**Why**: Scripts need execute permission on Unix-like systems

**Prevention**: Always check file permissions before running scripts

#### Pitfall 2: Missing Build Dependencies

**Problem**: Compilation fails with "command not found" errors
```bash
./scripts/install_verilator.sh
# Error: g++: command not found
```

**Solution**: Install build essentials first
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install build-essential

# macOS
xcode-select --install

# Then retry installation
```

**Why**: Verilator requires C++ compiler and build tools

#### Pitfall 3: Verilator Version Too Old

**Problem**: Verilator installed but version is too old
```bash
verilator --version
# Verilator 4.xxx (too old, need 5.042+)
```

**Solution**: Install from source or update package
```bash
# Remove old version
sudo apt-get remove verilator

# Install from source (recommended)
./scripts/install_verilator.sh --from-submodule
```

**Why**: This course requires Verilator 5.042+ for full feature support

#### Pitfall 4: PATH Not Updated

**Problem**: Tools installed but not found in PATH
```bash
iverilog -v
# Command not found
```

**Solution**: Add to PATH or use full path
```bash
# Check installation location
which iverilog  # or: whereis iverilog

# Add to PATH (if installed to custom location)
export PATH=$PATH:/usr/local/bin

# Or use full path
/usr/local/bin/iverilog -v
```

**Why**: Installation scripts may install to non-standard locations

### 11. Troubleshooting Common Issues

#### iverilog Installation Issues

**Error**: `error: Cannot find iverilog`
- **Cause**: iverilog not installed or not in PATH
- **Solution**: 
  ```bash
  # Install using script
  ./scripts/install_iverilog.sh
  
  # Or manually
  sudo apt-get install iverilog  # Ubuntu/Debian
  brew install icarus-verilog   # macOS
  ```
- **Verify**: `iverilog -v` should show version

**Error**: `error: syntax error, unexpected TOK_ID` (during test)
- **Cause**: SystemVerilog syntax not supported by default
- **Solution**: Use `-g2012` flag for SystemVerilog support
  ```bash
  iverilog -g2012 -o output input.sv
  ```
- **Note**: Some SystemVerilog features may still be limited

**Error**: `error: Cannot find file`
- **Cause**: Missing include path
- **Solution**: Add include directory with `-I` flag
  ```bash
  iverilog -I../dut -o test test.v
  ```

**Error**: `vvp: command not found`
- **Cause**: VVP runtime not installed or not in PATH
- **Solution**: VVP is usually installed with iverilog. Reinstall if missing:
  ```bash
  sudo apt-get install iverilog  # Includes vvp
  ```

#### Verilator Installation Issues

**Error**: `verilator: command not found`
- **Cause**: Verilator not installed or not in PATH
- **Solution**:
  ```bash
  # Install using script (recommended)
  ./scripts/install_verilator.sh --from-submodule
  
  # Or from system package
  sudo apt-get install verilator  # May be old version
  ```

**Error**: `error: Verilator version 5.042+ required`
- **Cause**: Installed version is too old
- **Solution**: Install from source for latest version
  ```bash
  ./scripts/install_verilator.sh --from-submodule
  ```

**Error**: `error: g++: command not found`
- **Cause**: C++ compiler not installed
- **Solution**: Install build essentials
  ```bash
  # Ubuntu/Debian
  sudo apt-get install build-essential
  
  # macOS
  xcode-select --install
  ```

**Error**: `error: fatal error: 'verilated.h' No such file or directory`
- **Cause**: Verilator headers not found
- **Solution**: Check Verilator installation and include paths
  ```bash
  # Verify installation
  verilator --version
  
  # Check include path
  verilator --getenv VERILATOR_ROOT
  ```

**Error**: C++ compilation errors (undefined references)
- **Cause**: Missing Verilator library linking
- **Solution**: Ensure Makefile includes Verilator libraries
  ```makefile
  # In Makefile
  VL_OBJ_DIR = obj_dir
  include $(VL_OBJ_DIR)/V$(TOP).mk
  ```

#### GTKWave Issues

**Error**: `gtkwave: command not found`
- **Cause**: GTKWave not installed
- **Solution**:
  ```bash
  # Usually installed with iverilog
  sudo apt-get install gtkwave  # Ubuntu/Debian
  brew install gtkwave          # macOS
  ```

**Error**: GTKWave won't open VCD file
- **Cause**: File format issue or corrupted file
- **Solution**: 
  - Verify VCD file was generated correctly
  - Check file permissions
  - Try regenerating: `vvp executable` (should create .vcd file)

#### Platform-Specific Issues

**Linux (Ubuntu/Debian)**:
- **Issue**: Package manager version may be outdated
- **Solution**: Use installation scripts or build from source

**macOS**:
- **Issue**: Homebrew version may be outdated
- **Solution**: Use `--source` flag to build from source
  ```bash
  ./scripts/install_iverilog.sh --source
  ./scripts/install_verilator.sh --source
  ```

**Windows/WSL2**:
- **Issue**: Some tools may not work in Windows directly
- **Solution**: Use WSL2 Ubuntu and install there
  ```bash
  # In WSL2 Ubuntu
  sudo apt-get update
  sudo apt-get install iverilog gtkwave
  ./scripts/install_verilator.sh
  ```

#### Build System Issues

**Makefile Errors**:
- **Issue**: `make: *** No targets specified and no makefile found`
- **Solution**: Ensure you're in the correct directory with a Makefile
  ```bash
  cd module0/examples/iverilog_basics
  make all
  ```

**Include Path Problems**:
- **Issue**: Files not found during compilation
- **Solution**: Check relative paths and use `-I` flags correctly
  ```bash
  iverilog -I../../dut -o test test.v
  ```

#### IDE Issues

**SystemVerilog Syntax Highlighting Not Working**:
- **VS Code**: Install "SystemVerilog" extension by mshr-h
- **Vim**: Install vim-systemverilog plugin
- **Verification**: Open a `.sv` file and check for syntax highlighting

**Import Resolution Problems**:
- **Issue**: IDE can't find included files
- **Solution**: Configure include paths in IDE settings
  - VS Code: Add to `settings.json`:
    ```json
    "systemverilog.includeIndexing": ["**/*.sv", "**/*.v"]
    ```

**Debugging Not Working**:
- **Issue**: Can't set breakpoints or debug
- **Solution**: 
  - For Verilator: Use GDB with compiled executable
  - For iverilog: Use VCD waveforms for debugging

### 12. Verification Checklist

- [ ] C/C++ compiler installed and working
- [ ] iverilog installed and verified
  - Using script: `./scripts/install_iverilog.sh`
  - Verify: `iverilog -v` and `vvp -v`
- [ ] Verilator installed and verified
  - Using script: `./scripts/install_verilator.sh`
  - Verify: `verilator --version`
- [ ] GTKWave installed and verified
  - Verify: `gtkwave --version`
- [ ] All tools verified together
- [ ] IDE configured and working
- [ ] First test runs successfully (both iverilog and Verilator)
- [ ] Can create and run simple testbench
- [ ] Understand basic project structure
- [ ] Know how to get help when stuck
- [ ] Understand tool differences and when to use each

## Learning Outcomes

By the end of this module, you should be able to:

- Install and configure all required tools
- Set up iverilog
- Set up Verilator
- Install and verify GTKWave
- Configure your IDE for verification work
- Create a basic project structure
- Run simple verification tests with both tools
- Understand tool differences and selection criteria
- Troubleshoot common installation issues

## Exercises

1. **Installation Verification**
   - Verify each tool independently:
     - iverilog: `iverilog -v`
     - Verilator: `verilator --version`
     - GTKWave: `gtkwave --version`
   - Document any issues encountered

2. **Environment Setup**
   - Option A (Automated): Run installation scripts
   - Option B (Manual): Install tools individually
   - Set up environment variables if needed

3. **First Tests**
   - Run iverilog hello_world example
   - Run Verilator hello_world example
   - Compare outputs and understand differences

4. **IDE Configuration**
   - Set up your preferred IDE
   - Configure Verilog/SystemVerilog syntax highlighting
   - Test debugging functionality

5. **Project Structure**
   - Create a well-organized project structure
   - Set up version control
   - Create initial documentation
   - Understand the `tools/` directory structure

6. **Tool Comparison**
   - Create a simple testbench in both paradigms
   - Compare compilation time
   - Compare simulation performance
   - Compare debugging capabilities

## Assessment

- [ ] Can install all required tools independently
- [ ] Can set up iverilog
- [ ] Can verify iverilog installation
- [ ] Can set up Verilator
- [ ] Can verify Verilator installation
- [ ] Can install and verify GTKWave
- [ ] Can configure IDE for verification work
- [ ] Can create and run simple test (both tools)
- [ ] Can troubleshoot common issues
- [ ] Understands project structure best practices
- [ ] Understands tool differences and selection criteria

## Related Topics

- **Next Steps**: [Module 1: iverilog Deep Dive](MODULE1.md) - Master iverilog for Verilog testbench development
- **Next Steps**: [Module 2: Verilator Deep Dive](MODULE2.md) - Master Verilator for C++ testbench development
- **UVM Connection**: [UVM Core Repository](https://github.com/universal-verification-methodology/core)

## Next Steps

After completing this module, proceed to:
- **Module 1: iverilog Deep Dive** - Master iverilog for Verilog testbench development
- **Module 2: Verilator Deep Dive** - Master Verilator for C++ testbench development

## Additional Resources

### Installation and Setup
- **Installation Scripts**:
  - All scripts are located in the `scripts/` directory
  - Run `./scripts/install_iverilog.sh --help` for detailed usage
  - Run `./scripts/install_verilator.sh --help` for detailed usage

### Tool Documentation
- **Icarus Verilog Documentation**: http://iverilog.wikia.com/
- **Verilator Documentation**: https://verilator.org/
- **GTKWave Documentation**: http://gtkwave.sourceforge.net/

### Language Standards
- **IEEE 1364-2005 Standard**: Verilog Hardware Description Language
- **IEEE 1800-2017 Standard**: SystemVerilog Language Reference Manual

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

### Best Practices from UVM Core Repository
1. **Modular Design**: Organize testbenches into reusable components
2. **Clear Documentation**: Comment code thoroughly (as demonstrated in Module 0)
3. **Systematic Testing**: Use structured test patterns
4. **Self-Checking**: Automate result verification
5. **Coverage-Driven**: Track what has been tested
6. **Version Control**: Use git for testbench management

## Module 0 Examples and Tests

This module includes comprehensive examples and testbenches located in the `module0/` directory:

```
module0/
├── examples/              # Learning examples
│   ├── iverilog_basics/   # Basic iverilog examples
│   │   ├── hello_world.v           # Simplest testbench
│   │   ├── and_gate_test.v        # DUT instantiation example
│   │   ├── gtkwave_example.v      # Waveform generation example
│   │   └── Makefile                # Build automation
│   ├── verilator_basics/  # Basic Verilator examples
│   │   ├── hello_world.cpp        # Simplest C++ testbench
│   │   ├── and_gate_test.cpp      # Verilator API example
│   │   └── Makefile               # Build automation
│   └── comparison/        # Side-by-side comparisons
├── dut/                   # Design Under Test modules
│   ├── simple_gates/      # Basic gates (AND, OR, XOR)
│   │   ├── and_gate.v             # 2-input AND gate
│   │   └── or_gate.v              # 2-input OR gate
│   └── counters/          # Counter modules
│       └── simple_counter.v        # 4-bit synchronous counter
├── tests/                 # Comprehensive testbenches
│   ├── iverilog_tests/    # iverilog testbenches
│   │   └── test_and_gate.v        # Comprehensive AND gate test
│   └── verilator_tests/   # Verilator testbenches
│       └── test_and_gate.cpp       # Comprehensive AND gate test
└── README.md             # Module 0 documentation
```

### Code Quality and Documentation

All code in Module 0 includes:
- **Comprehensive Comments**: Every file has detailed inline comments explaining:
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

### Quick Start

**Run all examples using the orchestrator script:**
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

**Run examples individually:**
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

# iverilog GTKWave Example (generates VCD for waveform viewing)
cd module0/examples/iverilog_basics
make gtkwave_example
gtkwave gtkwave_example.vcd  # View waveforms

# Verilator AND Gate Test
cd module0/examples/verilator_basics
make and_gate_test
```

For more details, see `module0/README.md`.
