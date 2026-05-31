        # Narration script — Module 2: Verilator Deep Dive

        **Target length:** ~89 minutes (165 slides; auto-generated — edit per slide as needed)

        ## Timing table

        | Slide | Section | Duration | Narration |
|-------|---------|----------|-----------|
| 1 | Module 2 | 0:25 | Welcome to module 2, Verilator Deep Dive. In this module you will master verilator for c++ testbench development. |
| 2 | Learning objectives | 0:36 | Here is what you will learn in this module. Verilator Fundamentals: Understanding how Verilator converts Verilog to C++ Compilation Process: Mastering Verilator compilation flags and options C++ Testbench Writing: Creating effective testbenches using C++ and Verilator's API Waveform Generation: Creating VCD/FST files for debugging File I/O: Managing test vectors and results with files |
| 3 | Prerequisites | 0:16 | Before you start, make sure you have these prerequisites. See module README |
| 4 | Learning path | 0:22 | Learning path. Master Verilator for C++ testbench development |
| 5 | Overview | 0:16 | Overview. This module provides comprehensive coverage of Verilator, a fast Verilog/SystemVerilog simulator that generates C++ code. You'll learn... |
| 6 | Design architecture | 0:08 | Next section: Design architecture. |
| 7 | 1. Verilator compilation model | 0:38 | 1. Verilator compilation model. Input: Verilog/SystemVerilog RTL + optional --timing / lint flags per example Output: C++ classes (V<top>) in obj_dir/ with fast cycle-accurate eval() Linkage: C++ main() or test class calls dut->eval() each cycle or on events Tracing: --trace / --trace-fst for waveform dumps from the C++ side Refer to the diagram on the right. |
| 8 | 2. Module 2 DUT catalog | 0:38 | 2. Module 2 DUT catalog. dut/multiplexers/: Same MUX family as Module 1 — cross-tool comparison baseline dut/counters/: counter_4bit — exercises sequential C++ drive/monitor loops Port mapping: Verilator flattens ports to struct members (dut->clk, dut->count) Performance: Large test suites favor Verilator’s compiled model over interpreted VVP Refer to the diagram on the right. |
| 9 | 3. C++ testbench architecture | 0:38 | 3. C++ testbench architecture. Top-level main: Allocates Vtop, applies reset sequence, runs clock loop Stimulus loop: for/while sets inputs then eval() advances time Optional OOP: Advanced tests organize Driver/Monitor/Checker as C++ classes Build: Generated Vtop.mk plus user Makefile link testbench and model Refer to the diagram on the right. |
| 10 | RTL block diagram (reference) | 0:22 | RTL block diagram (reference). Module 2: DUT hierarchy and signal flow. |
| 11 | Verification / testbench diagram (reference) | 0:22 | Verification / testbench diagram (reference). Module 2: stimulus, observation, and checking. |
| 12 | Verilator compile flags | 0:28 | Verilator compile flags. Review the code on screen and match it to files in the repository. verilator --cc --exe --build emits obj_dir/ with Vmodule and Makefile. |
| 13 | C++ TB — init, eval, final | 0:28 | C++ TB — init, eval, final. Review the code on screen and match it to files in the repository. Verilated::commandArgs, new Vmodule, dut->eval(), dut->final(). |
| 14 | obj_dir layout after verilator | 0:28 | obj_dir layout after verilator. Review the code on screen and match it to files in the repository. make mux_4to1_test compiles and runs ./obj_dir/Vmux_4to1. |
| 15 | DUT ports as C++ members | 0:28 | DUT ports as C++ members. Review the code on screen and match it to files in the repository. Write dut->sel and inputs, call eval(), read dut->out. |
| 16 | Execution & simulation flow | 0:08 | Next section: Execution & simulation flow. |
| 17 | How the example runs (toolchain) | 0:32 | How the example runs (toolchain). Match each bullet to files in the repository. Makefile: Verilator compiles RTL + SystemVerilog testbench into a C++ model sim_main.cpp: generates clk/rst_n, calls eval() until $finish Directed test (initial block or C++): drive stimulus, wait for DUT flags Self-check: compare outputs; print PASS/FAIL (see terminal demo slide) Repo path... |
| 18 | Directed test execution sequence (1) | 0:32 | Follow these steps in order when working through this module. C++ assert or compare after each eval final "All tests passed" message verilator --cc --exe --build rtl.v tb.cpp inspect obj_dir/ run Vtop Follow this order when tracing waveforms or debugging. |
| 19 | Directed test execution sequence (2) | 0:24 | Follow these steps in order when working through this module. eval() each cycle optional --trace VCD ./scripts/module2.sh --check Follow this order when tracing waveforms or debugging. |
| 20 | Build C++ testbench target | 0:28 | Build C++ testbench target. Review the code on screen and match it to files in the repository. From module2/examples/cpp_testbench: make mux_4to1_test |
| 21 | Verilator --trace for waveforms | 0:28 | Verilator --trace for waveforms. Review the code on screen and match it to files in the repository. Add --trace or --trace-fst; open VCD/FST in GTKWave after run. |
| 22 | Sequential eval loop — counter | 0:28 | Sequential eval loop — counter. Review the code on screen and match it to files in the repository. Toggle clk, eval(), check count — manual clock in C++ loop. |
| 23 | Verification & testing methods | 0:08 | Next section: Verification & testing methods. |
| 24 | 1. Cycle-based C++ testing | 0:34 | 1. Cycle-based C++ testing. Clock generation: Toggle clock in loop with eval() between edges Reset sequence: Hold rst_n low N cycles, release, verify known state Checking: assert() or explicit compare with std::cerr on mismatch Refer to the diagram on the right. |
| 25 | 2. Tracing and performance checks | 0:34 | 2. Tracing and performance checks. Waveforms: Enable Verilator trace API; view in GTKWave for debug examples Printf debug: Structured logging before/after eval() for signal snapshots Regression: ./scripts/module2.sh --all-tests batches compile+run across examples Refer to the diagram on the right. |
| 26 | 3. File I/O and scalable stimulus | 0:34 | 3. File I/O and scalable stimulus. Vector files: Read test data in C++ (file_io examples) for long sequences Repeatability: Fixed seeds and deterministic loops for comparable runs Failure isolation: Run single obj_dir binary with minimal stimulus to bisect bugs Refer to the diagram on the right. |
| 27 | Assert-based checking | 0:28 | Assert-based checking. Review the code on screen and match it to files in the repository. assert() on mismatch; All tests passed on stdout at end. |
| 28 | Syllabus topics | 0:08 | Next section: Syllabus topics. |
| 29 | 1. Verilator Overview (1/6) | 0:36 | 1. Verilator Overview (1/6). What is Verilator? Fast Verilog/SystemVerilog simulator Generates C++ code from Verilog Open-source and free Excellent performance |
| 30 | 1. Verilator Overview (2/6) | 0:36 | 1. Verilator Overview (2/6). Two-stage compilation Verilog → C++ conversion C++ compilation and linking Generated wrapper classes C++ Wrapper Generation |
| 31 | 1. Verilator Overview (3/6) | 0:36 | 1. Verilator Overview (3/6). Signal access methods Evaluation methods Tracing support Verilator Capabilities and Features Fast simulation |
| 32 | 1. Verilator Overview (4/6) | 0:36 | 1. Verilator Overview (4/6). Limited SystemVerilog support Coverage support Waveform generation Supported Verilog/SystemVerilog Constructs Most Verilog-2001 features |
| 33 | 1. Verilator Overview (5/6) | 0:36 | 1. Verilator Overview (5/6). Interfaces (limited) Classes (limited) Assertions (limited) Limitations and Workarounds Limited SystemVerilog support |
| 34 | 1. Verilator Overview (6/6) | 0:36 | 1. Verilator Overview (6/6). Workarounds for unsupported features When to Use Verilator High-performance simulation Large designs Integration with C++ libraries |
| 35 | 2. Compilation Process (1/8) | 0:36 | 2. Compilation Process (1/8). Verilator Compilation Command Basic syntax: verilator --cc --exe design.v testbench.cpp Output generation Build process Compilation Flags and Options |
| 36 | 2. Compilation Process (2/8) | 0:36 | 2. Compilation Process (2/8). --exe: Generate executable --build: Build automatically -I<directory>: Add include path -D<macro>: Define macro -O0, -O1, -O2, -O3: Optimization levels |
| 37 | 2. Compilation Process (3/8) | 0:36 | 2. Compilation Process (3/8). --trace-fst: Generate FST tracing --coverage: Enable coverage --lint-only: Lint without compilation Optimization Levels (-O0, -O1, -O2, -O3) -O0: No optimization (fastest compilation) |
| 38 | 2. Compilation Process (4/8) | 0:36 | 2. Compilation Process (4/8). -O2: More optimization (default) -O3: Maximum optimization (slowest compilation, fastest simulation) Coverage Options (--coverage) Code coverage generation Coverage analysis |
| 39 | 2. Compilation Process (5/8) | 0:36 | 2. Compilation Process (5/8). Linting Capabilities (--lint-only) Syntax checking Design rule checking No simulation generation Waveform Generation (--trace, --trace-fst) |
| 40 | 2. Compilation Process (6/8) | 0:36 | 2. Compilation Process (6/8). --trace-fst: Generate FST files (smaller, faster) Signal selection GTKWave compatibility Include Path Management Adding include directories |
| 41 | 2. Compilation Process (7/8) | 0:36 | 2. Compilation Process (7/8). Relative vs. absolute paths Define Macros Conditional compilation Macro definitions Usage in designs |
| 42 | 2. Compilation Process (8/8) | 0:28 | 2. Compilation Process (8/8). Compiling multiple files File ordering Dependency management basic_compilation.cpp: Demonstrates basic compilation, optimization, tracing, coverage, linting |
| 43 | 3. C++ Testbench Structure (1/7) | 0:36 | 3. C++ Testbench Structure (1/7). C++ Main Function Entry point Verilator initialization DUT instantiation Test sequence |
| 44 | 3. C++ Testbench Structure (2/7) | 0:36 | 3. C++ Testbench Structure (2/7). Verilator-Generated Class Usage Class naming (V<module_name>) Instance creation Method calls Signal access |
| 45 | 3. C++ Testbench Structure (3/7) | 0:36 | 3. C++ Testbench Structure (3/7). Creating DUT object Memory management Lifetime management Signal Access (Reading and Writing) Reading signals: dut->signal_name |
| 46 | 3. C++ Testbench Structure (4/7) | 0:36 | 3. C++ Testbench Structure (4/7). Signal types Multi-bit signals Clock Generation in C++ Simulation loop Clock toggling |
| 47 | 3. C++ Testbench Structure (5/7) | 0:36 | 3. C++ Testbench Structure (5/7). Multiple clocks Reset Generation in C++ Reset sequences Synchronous reset Asynchronous reset |
| 48 | 3. C++ Testbench Structure (6/7) | 0:36 | 3. C++ Testbench Structure (6/7). Simulation Loop Time management Event scheduling Loop structure Termination |
| 49 | 3. C++ Testbench Structure (7/7) | 0:16 | 3. C++ Testbench Structure (7/7). counter_test.cpp: Clock and reset generation, simulation loop |
| 50 | 4. C++ Testbench Writing (1/6) | 0:36 | 4. C++ Testbench Writing (1/6). Basic C++ Testbench Template Standard structure Common patterns Best practices Signal Access Methods |
| 51 | 4. C++ Testbench Writing (2/6) | 0:36 | 4. C++ Testbench Writing (2/6). Signal reading Signal writing Signal monitoring Clock and Reset Patterns Standard clock patterns |
| 52 | 4. C++ Testbench Writing (3/6) | 0:36 | 4. C++ Testbench Writing (3/6). Clock/reset coordination Stimulus Generation in C++ Test vector generation Pattern generation Sequential stimulus |
| 53 | 4. C++ Testbench Writing (4/6) | 0:36 | 4. C++ Testbench Writing (4/6). Response Monitoring in C++ Output monitoring Real-time monitoring Post-processing Logging |
| 54 | 4. C++ Testbench Writing (5/6) | 0:36 | 4. C++ Testbench Writing (5/6). Expected value calculation Output comparison Error detection Assertions Error Reporting |
| 55 | 4. C++ Testbench Writing (6/6) | 0:24 | 4. C++ Testbench Writing (6/6). Exit codes Test summaries Failure reporting |
| 56 | 5. Verilator C++ API (1/5) | 0:36 | 5. Verilator C++ API (1/5). Top Module Class Structure Class name: V<module_name> Constructor/destructor Methods Signals |
| 57 | 5. Verilator C++ API (2/5) | 0:36 | 5. Verilator C++ API (2/5). Direct member access Signal types Multi-bit signals Array signals Evaluation Method (eval()) |
| 58 | 5. Verilator C++ API (3/5) | 0:36 | 5. Verilator C++ API (3/5). When to call eval() Timing considerations Multiple evaluations Time Management Simulation time |
| 59 | 5. Verilator C++ API (4/5) | 0:36 | 5. Verilator C++ API (4/5). Time advancement Time-based events Tracing API VerilatedVcdC class trace() method |
| 60 | 5. Verilator C++ API (5/5) | 0:32 | 5. Verilator C++ API (5/5). File management Coverage API Coverage collection Coverage reporting Coverage analysis |
| 61 | 6. Waveform Generation (1/5) | 0:36 | 6. Waveform Generation (1/5). VCD File Generation Using --trace flag VerilatedVcdC class trace() method dump() method |
| 62 | 6. Waveform Generation (2/5) | 0:36 | 6. Waveform Generation (2/5). FST File Generation Using --trace-fst flag FST advantages GTKWave compatibility Signal Selection for Tracing |
| 63 | 6. Waveform Generation (3/5) | 0:36 | 6. Waveform Generation (3/5). Selective tracing Hierarchy levels GTKWave Compatibility VCD format FST format |
| 64 | 6. Waveform Generation (4/5) | 0:36 | 6. Waveform Generation (4/5). Signal organization Waveform Analysis Viewing waveforms Signal timing Timing relationships |
| 65 | 6. Waveform Generation (5/5) | 0:16 | 6. Waveform Generation (5/5). waveform_example.cpp: Comprehensive waveform generation using Verilator tracing API |
| 66 | 7. Debugging with Verilator (1/6) | 0:36 | 7. Debugging with Verilator (1/6). Compilation Error Debugging Understanding Verilator errors Common compilation errors Syntax errors Missing files |
| 67 | 7. Debugging with Verilator (2/6) | 0:36 | 7. Debugging with Verilator (2/6). Understanding C++ errors Linker errors Template errors Common mistakes Runtime Debugging |
| 68 | 7. Debugging with Verilator (3/6) | 0:36 | 7. Debugging with Verilator (3/6). Signal inspection GDB debugging Valgrind debugging Signal Inspection Printing signal values |
| 69 | 7. Debugging with Verilator (4/6) | 0:36 | 7. Debugging with Verilator (4/6). VCD file analysis Debug output Logging Strategies Debug levels Conditional logging |
| 70 | 7. Debugging with Verilator (5/6) | 0:36 | 7. Debugging with Verilator (5/6). Log organization Common Pitfalls and Solutions Forgetting to call eval() Signal initialization Memory leaks |
| 71 | 7. Debugging with Verilator (6/6) | 0:20 | 7. Debugging with Verilator (6/6). Common mistakes debug_example.cpp: C++ debugging techniques, logging strategies, error handling |
| 72 | 8. Advanced Verilator Features (1/4) | 0:36 | 8. Advanced Verilator Features (1/4). Multi-Threaded Simulation Basics Thread safety Parallel simulation Synchronization Performance Optimization |
| 73 | 8. Advanced Verilator Features (2/4) | 0:36 | 8. Advanced Verilator Features (2/4). Simulation optimization Memory optimization Speed optimization Large Design Handling Compiling large designs |
| 74 | 8. Advanced Verilator Features (3/4) | 0:36 | 8. Advanced Verilator Features (3/4). Incremental compilation Design partitioning Custom C++ Integration Integrating C++ libraries External interfaces |
| 75 | 8. Advanced Verilator Features (4/4) | 0:32 | 8. Advanced Verilator Features (4/4). System integration SystemC Integration Basics SystemC support SystemC integration When to use SystemC |
| 76 | 9. Project Organization (1/7) | 0:36 | 9. Project Organization (1/7). Makefile Integration Basic Makefile structure Verilator compilation rules Test execution Clean targets |
| 77 | 9. Project Organization (2/7) | 0:36 | 9. Project Organization (2/7). CMake Integration CMake setup Verilator integration Build configuration Scripting for Automation |
| 78 | 9. Project Organization (3/7) | 0:36 | 9. Project Organization (3/7). Batch processing Test automation Result collection Batch Simulation Running multiple tests |
| 79 | 9. Project Organization (4/7) | 0:36 | 9. Project Organization (4/7). Parallel execution Result aggregation Regression Testing Setup Test suite organization Regression test structure |
| 80 | 9. Project Organization (5/7) | 0:36 | 9. Project Organization (5/7). Test result tracking Location: module0/examples/verilator_basics/and_gate_test.cpp Demonstrates: Basic C++ testbench structure, signal access Location: module2/examples/cpp_testbench/mux_4to1_test.cpp Demonstrates: Complete C++ testbench, signal access, test patterns |
| 81 | 9. Project Organization (6/7) | 0:36 | 9. Project Organization (6/7). Demonstrates: Clock generation, reset sequences, simulation loop Location: module2/examples/file_io/file_io_test.cpp Demonstrates: Reading test vectors from files, writing results Location: See compilation examples Demonstrates: Multi-file compilation, include paths |
| 82 | 9. Project Organization (7/7) | 0:16 | 9. Project Organization (7/7). Demonstrates: Class-based organization, comprehensive testing |
| 83 | Hands-on examples | 0:08 | Next section: Hands-on examples. |
| 84 | Module 2 self-check | 0:45 | Module 2 self-check. Watch the terminal output and confirm you see the expected pass message. |
| 85 | Exercise scaffold | 0:28 | Exercise scaffold. Review the code on screen and match it to files in the repository. |
| 86 | Demo: Compilation | 0:45 | Demo: Compilation. Watch the terminal output and confirm you see the expected pass message. |
| 87 | Demo: C++ testbench | 0:45 | Demo: C++ testbench. Watch the terminal output and confirm you see the expected pass message. |
| 88 | Demo: File I/O | 0:45 | Demo: File I/O. Watch the terminal output and confirm you see the expected pass message. |
| 89 | Demo: Waveforms | 0:45 | Demo: Waveforms. Watch the terminal output and confirm you see the expected pass message. |
| 90 | Demo: Debugging | 0:45 | Demo: Debugging. Watch the terminal output and confirm you see the expected pass message. |
| 91 | Key concepts | 0:08 | Next section: Key concepts. |
| 92 | 1. Verilator compilation model | 0:28 | 1. Verilator compilation model. Input: Verilog/SystemVerilog RTL + optional --timing / lint flags per example Output: C++ classes (V<top>) in obj_dir/ with fast cycle-accurate eval() Linkage: C++ main() or test class calls dut->eval() each cycle or on events Tracing: --trace / --trace-fst for waveform dumps from the C++ side |
| 93 | 2. Module 2 DUT catalog | 0:28 | 2. Module 2 DUT catalog. dut/multiplexers/: Same MUX family as Module 1 — cross-tool comparison baseline dut/counters/: counter_4bit — exercises sequential C++ drive/monitor loops Port mapping: Verilator flattens ports to struct members (dut->clk, dut->count) Performance: Large test suites favor Verilator’s compiled model over interpreted VVP |
| 94 | 3. C++ testbench architecture | 0:28 | 3. C++ testbench architecture. Top-level main: Allocates Vtop, applies reset sequence, runs clock loop Stimulus loop: for/while sets inputs then eval() advances time Optional OOP: Advanced tests organize Driver/Monitor/Checker as C++ classes Build: Generated Vtop.mk plus user Makefile link testbench and model |
| 95 | 1. Cycle-based C++ testing | 0:24 | 1. Cycle-based C++ testing. Clock generation: Toggle clock in loop with eval() between edges Reset sequence: Hold rst_n low N cycles, release, verify known state Checking: assert() or explicit compare with std::cerr on mismatch |
| 96 | 2. Tracing and performance checks | 0:24 | 2. Tracing and performance checks. Waveforms: Enable Verilator trace API; view in GTKWave for debug examples Printf debug: Structured logging before/after eval() for signal snapshots Regression: ./scripts/module2.sh --all-tests batches compile+run across examples |
| 97 | 3. File I/O and scalable stimulus | 0:24 | 3. File I/O and scalable stimulus. Vector files: Read test data in C++ (file_io examples) for long sequences Repeatability: Fixed seeds and deterministic loops for comparable runs Failure isolation: Run single obj_dir binary with minimal stimulus to bisect bugs |
| 98 | 1. Verilator Overview (1/6) | 0:36 | 1. Verilator Overview (1/6). What is Verilator? Fast Verilog/SystemVerilog simulator Generates C++ code from Verilog Open-source and free Excellent performance |
| 99 | 1. Verilator Overview (2/6) | 0:36 | 1. Verilator Overview (2/6). Two-stage compilation Verilog → C++ conversion C++ compilation and linking Generated wrapper classes C++ Wrapper Generation |
| 100 | 1. Verilator Overview (3/6) | 0:36 | 1. Verilator Overview (3/6). Signal access methods Evaluation methods Tracing support Verilator Capabilities and Features Fast simulation |
| 101 | 1. Verilator Overview (4/6) | 0:36 | 1. Verilator Overview (4/6). Limited SystemVerilog support Coverage support Waveform generation Supported Verilog/SystemVerilog Constructs Most Verilog-2001 features |
| 102 | 1. Verilator Overview (5/6) | 0:36 | 1. Verilator Overview (5/6). Interfaces (limited) Classes (limited) Assertions (limited) Limitations and Workarounds Limited SystemVerilog support |
| 103 | 1. Verilator Overview (6/6) | 0:36 | 1. Verilator Overview (6/6). Workarounds for unsupported features When to Use Verilator High-performance simulation Large designs Integration with C++ libraries |
| 104 | 2. Compilation Process (1/8) | 0:36 | 2. Compilation Process (1/8). Verilator Compilation Command Basic syntax: verilator --cc --exe design.v testbench.cpp Output generation Build process Compilation Flags and Options |
| 105 | 2. Compilation Process (2/8) | 0:36 | 2. Compilation Process (2/8). --exe: Generate executable --build: Build automatically -I<directory>: Add include path -D<macro>: Define macro -O0, -O1, -O2, -O3: Optimization levels |
| 106 | 2. Compilation Process (3/8) | 0:36 | 2. Compilation Process (3/8). --trace-fst: Generate FST tracing --coverage: Enable coverage --lint-only: Lint without compilation Optimization Levels (-O0, -O1, -O2, -O3) -O0: No optimization (fastest compilation) |
| 107 | 2. Compilation Process (4/8) | 0:36 | 2. Compilation Process (4/8). -O2: More optimization (default) -O3: Maximum optimization (slowest compilation, fastest simulation) Coverage Options (--coverage) Code coverage generation Coverage analysis |
| 108 | 2. Compilation Process (5/8) | 0:36 | 2. Compilation Process (5/8). Linting Capabilities (--lint-only) Syntax checking Design rule checking No simulation generation Waveform Generation (--trace, --trace-fst) |
| 109 | 2. Compilation Process (6/8) | 0:36 | 2. Compilation Process (6/8). --trace-fst: Generate FST files (smaller, faster) Signal selection GTKWave compatibility Include Path Management Adding include directories |
| 110 | 2. Compilation Process (7/8) | 0:36 | 2. Compilation Process (7/8). Relative vs. absolute paths Define Macros Conditional compilation Macro definitions Usage in designs |
| 111 | 2. Compilation Process (8/8) | 0:28 | 2. Compilation Process (8/8). Compiling multiple files File ordering Dependency management basic_compilation.cpp: Demonstrates basic compilation, optimization, tracing, coverage, linting |
| 112 | 3. C++ Testbench Structure (1/7) | 0:36 | 3. C++ Testbench Structure (1/7). C++ Main Function Entry point Verilator initialization DUT instantiation Test sequence |
| 113 | 3. C++ Testbench Structure (2/7) | 0:36 | 3. C++ Testbench Structure (2/7). Verilator-Generated Class Usage Class naming (V<module_name>) Instance creation Method calls Signal access |
| 114 | 3. C++ Testbench Structure (3/7) | 0:36 | 3. C++ Testbench Structure (3/7). Creating DUT object Memory management Lifetime management Signal Access (Reading and Writing) Reading signals: dut->signal_name |
| 115 | 3. C++ Testbench Structure (4/7) | 0:36 | 3. C++ Testbench Structure (4/7). Signal types Multi-bit signals Clock Generation in C++ Simulation loop Clock toggling |
| 116 | 3. C++ Testbench Structure (5/7) | 0:36 | 3. C++ Testbench Structure (5/7). Multiple clocks Reset Generation in C++ Reset sequences Synchronous reset Asynchronous reset |
| 117 | 3. C++ Testbench Structure (6/7) | 0:36 | 3. C++ Testbench Structure (6/7). Simulation Loop Time management Event scheduling Loop structure Termination |
| 118 | 3. C++ Testbench Structure (7/7) | 0:16 | 3. C++ Testbench Structure (7/7). counter_test.cpp: Clock and reset generation, simulation loop |
| 119 | 4. C++ Testbench Writing (1/6) | 0:36 | 4. C++ Testbench Writing (1/6). Basic C++ Testbench Template Standard structure Common patterns Best practices Signal Access Methods |
| 120 | 4. C++ Testbench Writing (2/6) | 0:36 | 4. C++ Testbench Writing (2/6). Signal reading Signal writing Signal monitoring Clock and Reset Patterns Standard clock patterns |
| 121 | 4. C++ Testbench Writing (3/6) | 0:36 | 4. C++ Testbench Writing (3/6). Clock/reset coordination Stimulus Generation in C++ Test vector generation Pattern generation Sequential stimulus |
| 122 | 4. C++ Testbench Writing (4/6) | 0:36 | 4. C++ Testbench Writing (4/6). Response Monitoring in C++ Output monitoring Real-time monitoring Post-processing Logging |
| 123 | 4. C++ Testbench Writing (5/6) | 0:36 | 4. C++ Testbench Writing (5/6). Expected value calculation Output comparison Error detection Assertions Error Reporting |
| 124 | 4. C++ Testbench Writing (6/6) | 0:24 | 4. C++ Testbench Writing (6/6). Exit codes Test summaries Failure reporting |
| 125 | 5. Verilator C++ API (1/5) | 0:36 | 5. Verilator C++ API (1/5). Top Module Class Structure Class name: V<module_name> Constructor/destructor Methods Signals |
| 126 | 5. Verilator C++ API (2/5) | 0:36 | 5. Verilator C++ API (2/5). Direct member access Signal types Multi-bit signals Array signals Evaluation Method (eval()) |
| 127 | 5. Verilator C++ API (3/5) | 0:36 | 5. Verilator C++ API (3/5). When to call eval() Timing considerations Multiple evaluations Time Management Simulation time |
| 128 | 5. Verilator C++ API (4/5) | 0:36 | 5. Verilator C++ API (4/5). Time advancement Time-based events Tracing API VerilatedVcdC class trace() method |
| 129 | 5. Verilator C++ API (5/5) | 0:32 | 5. Verilator C++ API (5/5). File management Coverage API Coverage collection Coverage reporting Coverage analysis |
| 130 | 6. Waveform Generation (1/5) | 0:36 | 6. Waveform Generation (1/5). VCD File Generation Using --trace flag VerilatedVcdC class trace() method dump() method |
| 131 | 6. Waveform Generation (2/5) | 0:36 | 6. Waveform Generation (2/5). FST File Generation Using --trace-fst flag FST advantages GTKWave compatibility Signal Selection for Tracing |
| 132 | 6. Waveform Generation (3/5) | 0:36 | 6. Waveform Generation (3/5). Selective tracing Hierarchy levels GTKWave Compatibility VCD format FST format |
| 133 | 6. Waveform Generation (4/5) | 0:36 | 6. Waveform Generation (4/5). Signal organization Waveform Analysis Viewing waveforms Signal timing Timing relationships |
| 134 | 6. Waveform Generation (5/5) | 0:16 | 6. Waveform Generation (5/5). waveform_example.cpp: Comprehensive waveform generation using Verilator tracing API |
| 135 | 7. Debugging with Verilator (1/6) | 0:36 | 7. Debugging with Verilator (1/6). Compilation Error Debugging Understanding Verilator errors Common compilation errors Syntax errors Missing files |
| 136 | 7. Debugging with Verilator (2/6) | 0:36 | 7. Debugging with Verilator (2/6). Understanding C++ errors Linker errors Template errors Common mistakes Runtime Debugging |
| 137 | 7. Debugging with Verilator (3/6) | 0:36 | 7. Debugging with Verilator (3/6). Signal inspection GDB debugging Valgrind debugging Signal Inspection Printing signal values |
| 138 | 7. Debugging with Verilator (4/6) | 0:36 | 7. Debugging with Verilator (4/6). VCD file analysis Debug output Logging Strategies Debug levels Conditional logging |
| 139 | 7. Debugging with Verilator (5/6) | 0:36 | 7. Debugging with Verilator (5/6). Log organization Common Pitfalls and Solutions Forgetting to call eval() Signal initialization Memory leaks |
| 140 | 7. Debugging with Verilator (6/6) | 0:20 | 7. Debugging with Verilator (6/6). Common mistakes debug_example.cpp: C++ debugging techniques, logging strategies, error handling |
| 141 | 8. Advanced Verilator Features (1/4) | 0:36 | 8. Advanced Verilator Features (1/4). Multi-Threaded Simulation Basics Thread safety Parallel simulation Synchronization Performance Optimization |
| 142 | 8. Advanced Verilator Features (2/4) | 0:36 | 8. Advanced Verilator Features (2/4). Simulation optimization Memory optimization Speed optimization Large Design Handling Compiling large designs |
| 143 | 8. Advanced Verilator Features (3/4) | 0:36 | 8. Advanced Verilator Features (3/4). Incremental compilation Design partitioning Custom C++ Integration Integrating C++ libraries External interfaces |
| 144 | 8. Advanced Verilator Features (4/4) | 0:32 | 8. Advanced Verilator Features (4/4). System integration SystemC Integration Basics SystemC support SystemC integration When to use SystemC |
| 145 | 9. Project Organization (1/11) | 0:36 | 9. Project Organization (1/11). Makefile Integration Basic Makefile structure Verilator compilation rules Test execution Clean targets |
| 146 | 9. Project Organization (2/11) | 0:36 | 9. Project Organization (2/11). CMake Integration CMake setup Verilator integration Build configuration Scripting for Automation |
| 147 | 9. Project Organization (3/11) | 0:36 | 9. Project Organization (3/11). Batch processing Test automation Result collection Batch Simulation Running multiple tests |
| 148 | 9. Project Organization (4/11) | 0:36 | 9. Project Organization (4/11). Parallel execution Result aggregation Regression Testing Setup Test suite organization Regression test structure |
| 149 | 9. Project Organization (5/11) | 0:36 | 9. Project Organization (5/11). Test result tracking Location: module0/examples/verilator_basics/and_gate_test.cpp Demonstrates: Basic C++ testbench structure, signal access Location: module2/examples/cpp_testbench/mux_4to1_test.cpp Demonstrates: Complete C++ testbench, signal access, test patterns |
| 150 | 9. Project Organization (6/11) | 0:36 | 9. Project Organization (6/11). Demonstrates: Clock generation, reset sequences, simulation loop Location: module2/examples/file_io/file_io_test.cpp Demonstrates: Reading test vectors from files, writing results Location: See compilation examples Demonstrates: Multi-file compilation, include paths |
| 151 | 9. Project Organization (7/11) | 0:36 | 9. Project Organization (7/11). Demonstrates: Class-based organization, comprehensive testing Compile Verilog designs with Verilator Write C++ testbenches for Verilator Use Verilator C++ API effectively Generate and analyze waveforms |
| 152 | 9. Project Organization (8/11) | 0:36 | 9. Project Organization (8/11). Organize projects using Verilator Optimize Verilator-based testbenches Use compilation examples Try different compilation options Understand compilation process |
| 153 | 9. Project Organization (9/11) | 0:36 | 9. Project Organization (9/11). Test all input combinations Verify correct operation Read test vectors from file Apply vectors to DUT Write results to file |
| 154 | 9. Project Organization (10/11) | 0:36 | 9. Project Organization (10/11). Generate VCD files with Verilator View waveforms in GTKWave Analyze signal timing Debug using waveforms Create Makefile for compilation |
| 155 | 9. Project Organization (11/11) | 0:20 | 9. Project Organization (11/11). Implement clean targets Organize project structure |
| 156 | Practice & assessment | 0:08 | Next section: Practice & assessment. |
| 157 | What you should know (1/7) | 0:36 | By now you should be able to explain the following. Compile Verilog designs with Verilator Write C++ testbenches for Verilator Use Verilator C++ API effectively Generate and analyze waveforms Debug Verilator compilation and simulation issues From MODULE2 Learning Outcomes. |
| 158 | What you should know (2/7) | 0:36 | By now you should be able to explain the following. Optimize Verilator-based testbenches Use compilation examples Try different compilation options Understand compilation process Complete C++ testbench for 4-to-1 multiplexer From MODULE2 Learning Outcomes. |
| 159 | What you should know (3/7) | 0:36 | By now you should be able to explain the following. Verify correct operation Read test vectors from file Apply vectors to DUT Write results to file Compare expected vs. actual From MODULE2 Learning Outcomes. |
| 160 | What you should know (4/7) | 0:36 | By now you should be able to explain the following. View waveforms in GTKWave Analyze signal timing Debug using waveforms Create Makefile for compilation Add test execution rules From MODULE2 Learning Outcomes. |
| 161 | What you should know (5/7) | 0:36 | By now you should be able to explain the following. Organize project structure Can compile Verilog designs with various Verilator options Can write complete C++ testbenches Can use Verilator C++ API effectively Can use file I/O in C++ testbenches From MODULE2 Learning Outcomes. |
| 162 | What you should know (6/7) | 0:36 | By now you should be able to explain the following. Can debug compilation and simulation errors Can organize projects with Makefiles Can optimize Verilator-based testbenches Prerequisites: Module 0: Installation and Setup and Module 1: iverilog Deep Dive Next Steps: Module 3: Testbench Fundamentals - Learn fundamental testbench concepts for both paradigms From MODULE2 Learning Outcomes. |
| 163 | What you should know (7/7) | 0:36 | By now you should be able to explain the following. Module 3: Testbench Fundamentals (Verilog and C++) - Learn fundamental testbench concepts for both paradigms Module 4: Basic Testbench Construction - Master structured testbench construction Verilator Documentation: https://verilator.org/ GTKWave Documentation: http://gtkwave.sourceforge.net/ IEEE 1364-2005 Standard: Verilog Hardware... |
| 164 | Assessment checklist | 0:36 | Assessment checklist. Can compile Verilog designs with various Verilator options Can write complete C++ testbenches Can use Verilator C++ API effectively Can use file I/O in C++ testbenches Can generate and view waveforms |
| 165 | Summary & next steps | 0:28 | In summary: Master Verilator for C++ testbench development Next up: Next module in course. Master Verilator for C++ testbench development Complete module2/CHECKLIST.md Review module2/EXAMPLES.md and run each lab Next: Next module in course |

        ## Section narration (edit for TTS)

        - **Design architecture (Verilator compilation model, Module 2 DUT catalog, C++ testbench architecture):** Walk through the block diagram, then relate each block to files under module2/examples/.
- **Execution:** Explain make run / UVM make steps, then walk the artifact table and directed-test sequence slide by slide.
- **Verification (Cycle-based C++ testing, Tracing and performance checks, File I/O and scalable stimulus):** Explain what stimulus is applied, what is checked, and what is intentionally out of scope.
- **Syllabus:** Cover 9 topic section(s) — pause on protocol timing and signals.
- **Before exercises:** Ask learners to recall the learning outcomes slide; they should explain each bullet in their own words.
- **Hands-on:** Run module2/EXAMPLES.md labs; narrate expected PASS lines.

        ## Notes

        - Slides from **Before You Start**, **Design Architecture**, **Verification & Testing Methods**, **Topics Covered**, **EXAMPLES.md**, and **Learning Outcomes**.
        - Full detail: `docs/MODULE2.md` and `module2/EXAMPLES.md`.
        - Regenerate: `regenerate_course_outlines.sh <course_root> --module 2`
