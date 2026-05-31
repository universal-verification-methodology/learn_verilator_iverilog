        # Narration script — Module 5: Procedural Testbench Writing

        **Target length:** ~47 minutes (91 slides; auto-generated — edit per slide as needed)

        ## Timing table

        | Slide | Section | Duration | Narration |
|-------|---------|----------|-----------|
| 1 | Module 5 | 0:25 | Welcome to module 5, Procedural Testbench Writing. In this module you will master procedural testbench construction using verilog procedural blocks and c++ control flow. |
| 2 | Learning objectives | 0:36 | Here is what you will learn in this module. Procedural Constructs: Master initial and always blocks in Verilog, and control flow in C++ Timing Control: Understand delay control, event control, and wait statements Reusable Routines: Create tasks/functions in Verilog and functions/classes in C++ for code organization File I/O: Read test vectors from files and write results for automated testing... |
| 3 | Prerequisites | 0:16 | Before you start, make sure you have these prerequisites. See module README |
| 4 | Learning path | 0:22 | Learning path. Master procedural testbench construction using Verilog procedural blocks and C++ control flow |
| 5 | Overview | 0:16 | Overview. This module covers procedural testbench writing using Verilog's procedural blocks and C++ control structures. You'll learn to create... |
| 6 | Design architecture | 0:08 | Next section: Design architecture. |
| 7 | 1. Protocol-oriented DUT (Module 5) | 0:38 | 1. Protocol-oriented DUT (Module 5). dut/uart/simple_uart.v: TX FSM — idle, start, data bits, stop; tx_done handshake Clock domain: Single clk with active-low rst_n; serial tx output Future DUTs: SPI/I2C examples extend the same procedural TB patterns Interface contract: tx_start pulse, tx_data[7:0], wait for tx_done before next byte Refer to the diagram on the right. |
| 8 | 2. Procedural testbench control architecture | 0:38 | 2. Procedural testbench control architecture. Verilog: initial sequences call tasks; always blocks for clock and monitors C++: main or test class methods encode multi-step protocols with loops and waits Timing: #delay (Verilog) or counted eval() cycles (Verilator) align to bit times State alignment: TB FSM tracks UART phases while DUT FSM runs in RTL Refer to the diagram on the right. |
| 9 | 3. Reusable routine layer | 0:34 | 3. Reusable routine layer. Tasks/functions: send_byte, wait_tx_done, apply_reset — shared across tests C++ helpers: Same operations as methods on a UartDriver helper class File-driven layer: Sequences can be loaded from vector files for long regressions Refer to the diagram on the right. |
| 10 | RTL block diagram (reference) | 0:22 | RTL block diagram (reference). Module 5: DUT hierarchy and signal flow. |
| 11 | Verification / testbench diagram (reference) | 0:22 | Verification / testbench diagram (reference). Module 5: stimulus, observation, and checking. |
| 12 | Task/function Makefile | 0:28 | Task/function Makefile. Review the code on screen and match it to files in the repository. Links ALU DUT; vvp runs procedural task-based test sequence. |
| 13 | Task — apply stimulus and check | 0:28 | Task — apply stimulus and check. Review the code on screen and match it to files in the repository. test_alu_operation task: drive inputs, #delay, compare, log result. |
| 14 | Function — expected ALU result | 0:28 | Function — expected ALU result. Review the code on screen and match it to files in the repository. calculate_expected encodes reference model for each opcode. |
| 15 | Execution & simulation flow | 0:08 | Next section: Execution & simulation flow. |
| 16 | How the example runs (toolchain) | 0:32 | How the example runs (toolchain). Match each bullet to files in the repository. Makefile: Verilator compiles RTL + SystemVerilog testbench into a C++ model sim_main.cpp: generates clk/rst_n, calls eval() until $finish Directed test (initial block or C++): drive stimulus, wait for DUT flags Self-check: compare outputs; print PASS/FAIL (see terminal demo slide) Repo path... |
| 17 | Directed test execution sequence (1) | 0:32 | Follow these steps in order when working through this module. task/function computes expected compare DUT output write pass/fail to log file Define tasks/functions call from initial block Follow this order when tracing waveforms or debugging. |
| 18 | Directed test execution sequence (2) | 0:24 | Follow these steps in order when working through this module. load file vectors log results ./scripts/module5.sh --check Follow this order when tracing waveforms or debugging. |
| 19 | File I/O regression build | 0:28 | File I/O regression build. Review the code on screen and match it to files in the repository. cd module5/examples/file_io && make — reads vectors from file. |
| 20 | File read and test loop | 0:28 | File read and test loop. Review the code on screen and match it to files in the repository. $fopen/$fscanf load vectors; loop until EOF; write results log. |
| 21 | Test sequence orchestration | 0:28 | Test sequence orchestration. Review the code on screen and match it to files in the repository. initial block calls tasks for each opcode; prints final summary. |
| 22 | Verification & testing methods | 0:08 | Next section: Verification & testing methods. |
| 23 | 1. Sequence-based stimulus | 0:34 | 1. Sequence-based stimulus. Multi-step tests: Reset → configure → send N bytes → check tx bit timing Handshaking: Poll tx_done or use timeout counters to detect stuck FSM Negative tests: Start without reset, back-to-back tx_start — expect defined errors Refer to the diagram on the right. |
| 24 | 2. Timing and synchronization checks | 0:34 | 2. Timing and synchronization checks. Bit period: Verify one eval() or time step per bit cell in examples Setup/hold: Ensure tx_data stable before tx_start per README contracts Waveform review: UART frame visible on tx in VCD — start bit, LSB-first data Refer to the diagram on the right. |
| 25 | 3. Reuse and regression methodology | 0:34 | 3. Reuse and regression methodology. Routine library: Centralize protocol steps; tests only describe high-level scenarios File I/O regression: Replay captured stimulus files across tool releases Orchestration: ./scripts/module5.sh --test-sequences and --file-io for focused runs Refer to the diagram on the right. |
| 26 | Procedural control — initial/always | 0:28 | Procedural control — initial/always. Review the code on screen and match it to files in the repository. initial for sequences; tasks encapsulate multi-step protocol. |
| 27 | Result logging to file | 0:28 | Result logging to file. Review the code on screen and match it to files in the repository. $fwrite pass/fail lines; archive for regression diff. |
| 28 | Syllabus topics | 0:08 | Next section: Syllabus topics. |
| 29 | 1. Procedural Constructs (1/6) | 0:36 | 1. Procedural Constructs (1/6). Verilog: Initial Blocks for Test Sequences Initial block usage Sequential execution Multiple initial blocks Initial block organization |
| 30 | 1. Procedural Constructs (2/6) | 0:36 | 1. Procedural Constructs (2/6). Always block usage Continuous execution Clock generation Continuous monitoring C++: Main Function and Control Flow |
| 31 | 1. Procedural Constructs (3/6) | 0:36 | 1. Procedural Constructs (3/6). Control flow Sequential execution Function organization C++: Loops and Conditionals For loops |
| 32 | 1. Procedural Constructs (4/6) | 0:36 | 1. Procedural Constructs (4/6). If-else statements Switch statements Verilog: Blocking vs. Non-Blocking Assignments in Testbenches Blocking assignments (=) Non-blocking assignments (<=) |
| 33 | 1. Procedural Constructs (5/6) | 0:36 | 1. Procedural Constructs (5/6). Best practices Procedural Timing Control (Both Paradigms) Timing control methods Timing accuracy Timing relationships |
| 34 | 1. Procedural Constructs (6/6) | 0:32 | 1. Procedural Constructs (6/6). Verilog: Event Control (@, wait) Event control (@) Wait statements Event-based execution Event coordination |
| 35 | 2. Timing Control (1/7) | 0:36 | 2. Timing Control (1/7). Verilog: Delay Control (# delays) Delay syntax Delay timing Delay accuracy Delay best practices |
| 36 | 2. Timing Control (2/7) | 0:36 | 2. Timing Control (2/7). Posedge control Negedge control Wildcard control Event-based timing C++: Time Management in Simulation Loop |
| 37 | 2. Timing Control (3/7) | 0:36 | 2. Timing Control (3/7). Time tracking Time advancement Time management C++: Clock Cycle Counting Cycle counting |
| 38 | 2. Timing Control (4/7) | 0:36 | 2. Timing Control (4/7). Cycle accuracy Cycle management Verilog: Wait Statements Wait syntax Wait conditions |
| 39 | 2. Timing Control (5/7) | 0:36 | 2. Timing Control (5/7). Wait best practices Timing Accuracy (Both Paradigms) Timing precision Timing relationships Timing verification |
| 40 | 2. Timing Control (6/7) | 0:36 | 2. Timing Control (6/7). Race Condition Avoidance Race conditions Avoidance techniques Best practices Debugging |
| 41 | 2. Timing Control (7/7) | 0:16 | 2. Timing Control (7/7). timing_control_cpp.cpp: Time management in simulation loop |
| 42 | 3. Test Sequences (1/5) | 0:36 | 3. Test Sequences (1/5). Sequential Test Application Test ordering Sequential execution Test dependencies Test coordination |
| 43 | 3. Test Sequences (2/5) | 0:36 | 3. Test Sequences (2/5). Step definition Step execution Step timing Step verification Sequence Timing |
| 44 | 3. Test Sequences (3/5) | 0:36 | 3. Test Sequences (3/5). Timing control Timing accuracy Timing verification Synchronization with DUT DUT synchronization |
| 45 | 3. Test Sequences (4/5) | 0:36 | 3. Test Sequences (4/5). Synchronization methods Synchronization verification Sequence Verification Sequence checking Sequence validation |
| 46 | 3. Test Sequences (5/5) | 0:16 | 3. Test Sequences (5/5). Sequence best practices |
| 47 | 4. Reusable Routines (1/6) | 0:36 | 4. Reusable Routines (1/6). Verilog: Task Definitions for Test Sequences Task syntax Task usage Task parameters Task organization |
| 48 | 4. Reusable Routines (2/6) | 0:36 | 4. Reusable Routines (2/6). Function syntax Function usage Function return values Function organization C++: Function Definitions for Test Sequences |
| 49 | 4. Reusable Routines (3/6) | 0:36 | 4. Reusable Routines (3/6). Function usage Function parameters Function organization C++: Class Methods for Organization Class methods |
| 50 | 4. Reusable Routines (4/6) | 0:36 | 4. Reusable Routines (4/6). Method reusability Method best practices Parameter Passing (Both Paradigms) Parameter syntax Parameter types |
| 51 | 4. Reusable Routines (5/6) | 0:36 | 4. Reusable Routines (5/6). Parameter best practices Reusable Verification Routines Routine design Routine organization Routine reusability |
| 52 | 4. Reusable Routines (6/6) | 0:20 | 4. Reusable Routines (6/6). task_function_test_verilog.v: Tasks and functions for reusable test sequences function_class_test_cpp.cpp: Functions and classes for reusable test sequences |
| 53 | 5. Loops and Control Flow (1/5) | 0:36 | 5. Loops and Control Flow (1/5). For Loops in Testbenches For loop syntax For loop usage Loop-based testing Loop best practices |
| 54 | 5. Loops and Control Flow (2/5) | 0:36 | 5. Loops and Control Flow (2/5). While loop syntax While loop usage Conditional loops Loop termination Repeat Loops |
| 55 | 5. Loops and Control Flow (3/5) | 0:36 | 5. Loops and Control Flow (3/5). Repeat usage Fixed iteration Repeat best practices Conditional Execution If-else statements |
| 56 | 5. Loops and Control Flow (4/5) | 0:36 | 5. Loops and Control Flow (4/5). Conditional logic Conditional best practices Loop-Based Test Generation Test generation Loop-based patterns |
| 57 | 5. Loops and Control Flow (5/5) | 0:16 | 5. Loops and Control Flow (5/5). Generation best practices |
| 58 | 6. File I/O (1/7) | 0:36 | 6. File I/O (1/7). Verilog: File Reading ($readmemh, $readmemb) $readmemh syntax $readmemb syntax File reading Memory initialization |
| 59 | 6. File I/O (2/7) | 0:36 | 6. File I/O (2/7). $fopen syntax $fwrite syntax $fclose syntax File writing C++: File I/O (fstream, ifstream, ofstream) |
| 60 | 6. File I/O (3/7) | 0:36 | 6. File I/O (3/7). ifstream usage ofstream usage File operations C++: Reading Test Vectors Vector reading |
| 61 | 6. File I/O (4/7) | 0:36 | 6. File I/O (4/7). Vector storage Vector application C++: Writing Results Result writing Result formatting |
| 62 | 6. File I/O (5/7) | 0:36 | 6. File I/O (5/7). Result analysis Test Vector File Formats Format types Format selection Format parsing |
| 63 | 6. File I/O (6/7) | 0:36 | 6. File I/O (6/7). Result Logging to Files Logging methods Logging formats Logging organization Logging best practices |
| 64 | 6. File I/O (7/7) | 0:36 | 6. File I/O (7/7). File-based design File-based patterns File-based best practices File-based examples file_based_test_verilog.v: File-based testbench using $readmemh and $fwrite |
| 65 | 7. Advanced Procedural Patterns (1/6) | 0:36 | 7. Advanced Procedural Patterns (1/6). State Machine-Based Testbenches State machine design State transitions State verification State machine patterns |
| 66 | 7. Advanced Procedural Patterns (2/6) | 0:36 | 7. Advanced Procedural Patterns (2/6). Protocol modeling Protocol sequences Protocol verification Protocol patterns Transaction-Based Patterns |
| 67 | 7. Advanced Procedural Patterns (3/6) | 0:36 | 7. Advanced Procedural Patterns (3/6). Transaction sequences Transaction verification Transaction patterns Layered Testbench Structure Layer organization |
| 68 | 7. Advanced Procedural Patterns (4/6) | 0:36 | 7. Advanced Procedural Patterns (4/6). Layer verification Layer patterns Location: (Coming soon) Demonstrates: Protocol testbench, procedural sequences Location: (Coming soon) |
| 69 | 7. Advanced Procedural Patterns (5/6) | 0:36 | 7. Advanced Procedural Patterns (5/6). Location: module5/examples/file_io/ Demonstrates: File I/O, test vector reading, result writing Location: module5/examples/reusable_routines/task_function_test_verilog.v Demonstrates: Tasks and functions for reusable test sequences Location: module5/examples/reusable_routines/function_class_test_cpp.cpp |
| 70 | 7. Advanced Procedural Patterns (6/6) | 0:28 | 7. Advanced Procedural Patterns (6/6). Location: (Coming soon) Demonstrates: State machine-based testbench patterns Location: (Coming soon) Demonstrates: Protocol testbench patterns |
| 71 | Hands-on examples | 0:08 | Next section: Hands-on examples. |
| 72 | Module 5 self-check | 0:45 | Module 5 self-check. Watch the terminal output and confirm you see the expected pass message. |
| 73 | Exercise scaffold | 0:28 | Exercise scaffold. Review the code on screen and match it to files in the repository. |
| 74 | Demo: Procedural constructs | 0:45 | Demo: Procedural constructs. Watch the terminal output and confirm you see the expected pass message. |
| 75 | Demo: Reusable routines | 0:45 | Demo: Reusable routines. Watch the terminal output and confirm you see the expected pass message. |
| 76 | Demo: File I/O | 0:45 | Demo: File I/O. Watch the terminal output and confirm you see the expected pass message. |
| 77 | Demo: Test sequences | 0:45 | Demo: Test sequences. Watch the terminal output and confirm you see the expected pass message. |
| 78 | Practice & assessment | 0:08 | Next section: Practice & assessment. |
| 79 | What you should know (1/11) | 0:36 | By now you should be able to explain the following. Write procedural testbenches effectively (both paradigms) Control timing in testbenches (Verilog and C++) Create complex test sequences (both paradigms) Use tasks/functions (Verilog) and functions/classes (C++) for organization Implement file-based testing (both paradigms) From MODULE5 Learning Outcomes. |
| 80 | What you should know (2/11) | 0:36 | By now you should be able to explain the following. Define tasks for test sequences Use functions for calculations Organize code with reusable routines Define functions for test sequences Use classes for organization From MODULE5 Learning Outcomes. |
| 81 | What you should know (3/11) | 0:36 | By now you should be able to explain the following. Read test vectors from files Write results to files Implement file-based testing Implement protocol sequences Handle timing requirements From MODULE5 Learning Outcomes. |
| 82 | What you should know (4/11) | 0:36 | By now you should be able to explain the following. Model testbench as state machine Implement state transitions Verify state coverage Design reusable components Parameterize routines From MODULE5 Learning Outcomes. |
| 83 | What you should know (5/11) | 0:36 | By now you should be able to explain the following. Can write procedural testbenches effectively (both paradigms) Can control timing in testbenches (Verilog and C++) Can create complex test sequences (both paradigms) Can use tasks/functions (Verilog) and functions/classes (C++) for organization Can implement file-based testing (both paradigms) From MODULE5 Learning Outcomes. |
| 84 | What you should know (6/11) | 0:36 | By now you should be able to explain the following. Module 6: SystemVerilog Testbench Features - Learn SystemVerilog enhancements Module 7: Coverage and Assertions - Master coverage and assertion-based verification File Headers: Every file includes comprehensive header documentation: Purpose and learning objectives Key concepts explained From MODULE5 Learning Outcomes. |
| 85 | What you should know (7/11) | 0:36 | By now you should be able to explain the following. Usage examples Inline Comments: Detailed comments explain: Why code is written a certain way (not just what it does) Procedural block behavior and timing Task/function usage and parameter passing From MODULE5 Learning Outcomes. |
| 86 | What you should know (8/11) | 0:36 | By now you should be able to explain the following. Timing control mechanisms Code Organization: Comments group related code: Signal declarations DUT instantiation Reusable routines (tasks/functions) From MODULE5 Learning Outcomes. |
| 87 | What you should know (9/11) | 0:36 | By now you should be able to explain the following. File operations Icarus Verilog Documentation: http://iverilog.wikia.com/ Verilator Documentation: https://verilator.org/ GTKWave Documentation: http://gtkwave.sourceforge.net/ IEEE 1364-2005 Standard: Verilog Hardware Description Language From MODULE5 Learning Outcomes. |
| 88 | What you should know (10/11) | 0:36 | By now you should be able to explain the following. Universal Verification Methodology (UVM): https://accellera.org/downloads/standards/uvm UVM Core Repository: https://github.com/universal-verification-methodology/core Official UVM library with examples of: Reusable components (agents, drivers, monitors) Sequence-based stimulus generation From MODULE5 Learning Outcomes. |
| 89 | What you should know (11/11) | 0:16 | By now you should be able to explain the following. Phase-based testbench control From MODULE5 Learning Outcomes. |
| 90 | Assessment checklist | 0:36 | Assessment checklist. Can write procedural testbenches effectively (both paradigms) Can control timing in testbenches (Verilog and C++) Can create complex test sequences (both paradigms) Can use tasks/functions (Verilog) and functions/classes (C++) for organization Can implement file-based testing (both paradigms) |
| 91 | Summary & next steps | 0:28 | In summary: Master procedural testbench construction using Verilog procedural blocks and C++ control flow Next up: Next module in course. Master procedural testbench construction using Verilog procedural blocks and C++ control flow Complete module5/CHECKLIST.md Review module5/EXAMPLES.md and run each lab Next: Next module in course |

        ## Section narration (edit for TTS)

        - **Design architecture (Protocol-oriented DUT (Module 5), Procedural testbench control architecture, Reusable routine layer):** Walk through the block diagram, then relate each block to files under module5/examples/.
- **Execution:** Explain make run / UVM make steps, then walk the artifact table and directed-test sequence slide by slide.
- **Verification (Sequence-based stimulus, Timing and synchronization checks, Reuse and regression methodology):** Explain what stimulus is applied, what is checked, and what is intentionally out of scope.
- **Syllabus:** Cover 7 topic section(s) — pause on protocol timing and signals.
- **Before exercises:** Ask learners to recall the learning outcomes slide; they should explain each bullet in their own words.
- **Hands-on:** Run module5/EXAMPLES.md labs; narrate expected PASS lines.

        ## Notes

        - Slides from **Before You Start**, **Design Architecture**, **Verification & Testing Methods**, **Topics Covered**, **EXAMPLES.md**, and **Learning Outcomes**.
        - Full detail: `docs/MODULE5.md` and `module5/EXAMPLES.md`.
        - Regenerate: `regenerate_course_outlines.sh <course_root> --module 5`
