# Coding Standards for Testbenches

This document outlines coding standards and best practices for writing testbenches in Verilog and C++.

## Table of Contents

1. [Naming Conventions](#naming-conventions)
2. [Code Organization](#code-organization)
3. [Commenting Standards](#commenting-standards)
4. [Documentation Practices](#documentation-practices)
5. [Style Guides](#style-guides)

## Naming Conventions

### Verilog Naming Conventions

#### Modules
- Use lowercase with underscores: `clock_generator`, `reset_generator`
- Be descriptive: `stimulus_generator` not `stim_gen`
- Prefix testbenches with `tb_` or `test_`: `tb_mux_4to1`, `test_counter`

#### Signals
- Use lowercase with underscores: `clk`, `rst_n`, `data_valid`
- Use `_n` suffix for active-low signals: `rst_n`, `enable_n`
- Use descriptive names: `address_bus` not `addr`
- Use prefixes for signal types:
  - `clk_` for clocks: `clk`, `clk_sys`
  - `rst_` for resets: `rst_n`, `rst_async`
  - `data_` for data: `data_in`, `data_out`
  - `ctrl_` for control: `ctrl_valid`, `ctrl_ready`

#### Parameters
- Use UPPERCASE: `CLOCK_PERIOD`, `DATA_WIDTH`
- Use descriptive names: `NUM_TESTS` not `N`

#### Tasks and Functions
- Use lowercase with underscores: `apply_stimulus`, `check_result`
- Use verb-noun pattern: `generate_clock`, `verify_output`

### C++ Naming Conventions

#### Classes
- Use PascalCase: `ClockGenerator`, `ResetGenerator`
- Be descriptive: `StimulusGenerator` not `StimGen`

#### Functions and Methods
- Use camelCase: `generateStimulus()`, `checkResult()`
- Use verb-noun pattern: `generateClock()`, `verifyOutput()`

#### Variables
- Use camelCase: `simTime`, `testCount`
- Use descriptive names: `clockPeriod` not `cp`
- Use prefixes for member variables: `m_` or `_`: `m_simTime`, `_testCount`

#### Constants
- Use UPPERCASE: `CLOCK_PERIOD`, `DATA_WIDTH`

## Code Organization

### File Structure

#### Verilog
```
module_name/
├── module_name.v          # Main module
├── module_name_tb.v       # Testbench
├── module_name_tests.v    # Test cases
└── README.md              # Documentation
```

#### C++
```
module_name/
├── module_name.h          # Header (if needed)
├── module_name.cpp        # Implementation
├── module_name_tb.cpp     # Testbench
└── README.md             # Documentation
```

### Module Organization

1. **Header Comments**: File header with description
2. **Parameters**: All parameters at the top
3. **Port Declarations**: Inputs, outputs, inouts
4. **Internal Signals**: All internal signals
5. **Instantiations**: DUT and sub-modules
6. **Initial Blocks**: Test sequences
7. **Always Blocks**: Clock, reset, logic
8. **Tasks and Functions**: Helper routines
9. **End Module**: Closing

### Function/Task Organization

1. **Purpose**: Clear description
2. **Parameters**: Well-documented
3. **Return Values**: Documented
4. **Implementation**: Clear logic
5. **Error Handling**: Proper checks

## Commenting Standards

### Header Comments

Every file should have a header comment:

```verilog
/**
 * Module Name: Clock Generator
 * 
 * Description: Generates a configurable clock signal
 * 
 * Parameters:
 *   PERIOD: Clock period in nanoseconds (default: 20)
 * 
 * Ports:
 *   clk: Clock output
 * 
 * Usage:
 *   clock_generator #(.PERIOD(50)) clk_gen (.clk(clk));
 */
```

### Inline Comments

- Explain **why**, not **what**
- Use comments for complex logic
- Keep comments up-to-date
- Remove commented-out code

```verilog
// Calculate expected output based on select signal
// This implements the mux logic: out = inputs[sel]
case (sel)
    2'b00: expected = inputs[0];  // Select input 0
    2'b01: expected = inputs[1];  // Select input 1
    // ... more cases
endcase
```

### Section Comments

Use section comments to organize code:

```verilog
// ============================================================================
// Clock Generation
// ============================================================================
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// ============================================================================
// Reset Generation
// ============================================================================
initial begin
    rst_n = 0;
    #100;
    rst_n = 1;
end
```

## Documentation Practices

### README Files

Each module should have a README.md with:
- Overview
- Usage instructions
- Parameters
- Examples
- Dependencies

### Code Documentation

- Document all public interfaces
- Document complex algorithms
- Include usage examples
- Document assumptions and limitations

### Test Documentation

- Document test scenarios
- Explain test coverage
- Document expected results
- Include troubleshooting tips

## Style Guides

### Verilog Style

#### Indentation
- Use 4 spaces (not tabs)
- Indent always blocks, initial blocks
- Indent case statements

#### Line Length
- Keep lines under 100 characters
- Break long lines appropriately

#### Spacing
- Use spaces around operators: `a = b + c;`
- Use spaces after commas: `task test(a, b, c);`
- Use blank lines between sections

#### Block Style
```verilog
// Preferred: ANSI C style
always @(posedge clk) begin
    if (rst_n) begin
        count <= count + 1;
    end else begin
        count <= 0;
    end
end
```

### C++ Style

#### Indentation
- Use 4 spaces (not tabs)
- Indent class members, function bodies

#### Line Length
- Keep lines under 100 characters

#### Spacing
- Use spaces around operators
- Use spaces after commas
- Use blank lines between sections

#### Block Style
```cpp
// Preferred: ANSI C style
if (condition) {
    // code
} else {
    // code
}
```

## Best Practices Summary

1. **Be Consistent**: Follow the same style throughout
2. **Be Descriptive**: Use clear, meaningful names
3. **Be Organized**: Structure code logically
4. **Be Documented**: Comment complex logic
5. **Be Maintainable**: Write code that's easy to modify
6. **Be Testable**: Write code that's easy to test
7. **Be Readable**: Prioritize readability over cleverness

## Tools

- **Linters**: Use linters to enforce style
- **Formatters**: Use formatters to auto-format code
- **Review**: Code reviews help maintain standards
