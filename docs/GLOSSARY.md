# Glossary

This glossary defines key terms used throughout the documentation.

## A

### Assertion
A statement that checks a property or condition during simulation. Assertions can be simple (if-else checks) or formal (SystemVerilog Assertions).

### Asynchronous Reset
A reset signal that can change the state of a design at any time, independent of the clock.

## B

### Blocking Assignment
A Verilog assignment (`=`) that executes immediately and blocks subsequent statements until completion.

### Branch Coverage
A code coverage metric that measures whether all conditional branches (if-else, case) have been executed.

## C

### Clock Domain
A group of signals synchronized to the same clock. Designs with multiple clock domains require special handling.

### Code Coverage
A metric measuring how much of the design code has been executed during testing.

### Constrained Random Verification (CRV)
A verification methodology that uses randomization with constraints to generate test vectors automatically.

## D

### Design Under Test (DUT)
The hardware design being verified by the testbench. Also called "Device Under Test."

### Directed Testing
A verification approach where test vectors are manually created for specific scenarios.

## E

### eval()
A Verilator method that evaluates the DUT for one simulation time step. Must be called after signal changes.

### Event-Driven Simulation
A simulation model where events (signal changes) trigger evaluation of dependent logic.

## F

### Functional Coverage
A metric measuring how well the functional requirements have been tested, often tracked manually or with coverage groups.

## G

### GTKWave
An open-source waveform viewer for VCD and FST files.

## I

### iverilog
Icarus Verilog, an open-source Verilog/SystemVerilog simulator.

### Interface (SystemVerilog)
A SystemVerilog construct that bundles signals and modports for connecting modules.

## M

### Monitor
A testbench component that observes DUT behavior without driving signals.

## N

### Non-Blocking Assignment
A Verilog assignment (`<=`) that schedules the assignment for the end of the time step, allowing parallel execution.

## P

### Procedural Block
Verilog blocks (`initial`, `always`) that contain procedural statements.

## R

### Randomization
The process of generating random values for test vectors, often with constraints.

### Reset Sequence
A sequence of signal changes that initializes the DUT to a known state.

## S

### Scoreboard
A testbench component that compares DUT outputs against expected values.

### Self-Checking Testbench
A testbench that automatically verifies correctness without manual inspection.

### Stimulus
Input signals or data applied to the DUT during testing.

### Synchronous Reset
A reset signal that only affects the design on clock edges.

### SystemVerilog
An extension of Verilog that adds classes, interfaces, and other advanced features.

## T

### Testbench
The verification environment that tests the DUT. Includes stimulus generation, monitoring, and checking.

### Test Vector
A set of input values applied to the DUT during testing.

### Toggle Coverage
A code coverage metric that measures whether signals have changed from 0→1 and 1→0.

### Transaction
A high-level data structure representing a communication or operation, often used in advanced testbenches.

## U

### UVM (Universal Verification Methodology)
An industry-standard verification methodology framework for SystemVerilog.

## V

### VCD (Value Change Dump)
A file format for storing waveform data.

### Verilator
A fast Verilog/SystemVerilog simulator that generates C++ code.

### Verification
The process of ensuring a design works correctly before production.

### VVP
Icarus Verilog runtime, executes compiled Verilog designs.

## W

### Waveform
A visual representation of signal values over time, used for debugging.

---

## Acronyms

- **CRV**: Constrained Random Verification
- **DUT**: Design Under Test
- **FST**: Fast Signal Trace (waveform format)
- **PLI**: Programming Language Interface
- **RTL**: Register Transfer Level
- **UVM**: Universal Verification Methodology
- **VCD**: Value Change Dump
- **VPI**: Verilog Procedural Interface

---

**Last Updated**: 2024
**Contributions**: Please update this glossary as new terms are added to the documentation.
