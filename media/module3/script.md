        # Narration script — Module 3: Testbench Fundamentals (Verilog and C++)

        **Target length:** ~60 minutes (117 slides; auto-generated — edit per slide as needed)

        ## Timing table

        | Slide | Section | Duration | Narration |
|-------|---------|----------|-----------|
| 1 | Module 3 | 0:25 | Welcome to module 3, Testbench Fundamentals (Verilog and C++). In this module you will understand testbench architecture and basic verification concepts for both verilog and c++ testbenches. |
| 2 | Learning objectives | 0:16 | Here is what you will learn in this module. Understand testbench architecture and basic verification concepts for both Verilog and C++ testbenches |
| 3 | Prerequisites | 0:16 | Before you start, make sure you have these prerequisites. See module README |
| 4 | Learning path | 0:22 | Learning path. Understand testbench architecture and basic verification concepts for both Verilog and C++ testbenches |
| 5 | Overview | 0:16 | Overview. This module introduces the fundamental concepts of testbench design for both Verilog (iverilog) and C++ (Verilator) testbenches. You'll... |
| 6 | Design architecture | 0:08 | Next section: Design architecture. |
| 7 | 1. Canonical testbench–DUT boundary | 0:38 | 1. Canonical testbench–DUT boundary. DUT: Device Under Test in module3/dut/ (gates, multiplexers, counters) TB wrapper: Encapsulates instantiation, clock/reset, and test program only Signals: Explicit wires/regs (Verilog) or model ports (C++) — no hidden coupling Lifecycle: Build → reset → run tests → report → $finish / return exit code Refer to the diagram on the right. |
| 8 | 2. Dual-paradigm environment architecture | 0:38 | 2. Dual-paradigm environment architecture. Verilog TB (examples/verilog_testbenches/): Event-driven initial/always C++ TB (examples/cpp_testbenches/): eval() loop with Verilator model Shared DUT: Same RTL verified two ways — highlights tool-specific TB idioms Comparison guide: examples/comparison/ documents mapping between styles Refer to the diagram on the right. |
| 9 | 3. Verification component roles (UVM-aligned) | 0:38 | 3. Verification component roles (UVM-aligned). Driver: Applies stimulus (assignments before eval or #delay) Monitor: Samples outputs; logs transactions or pin values Scoreboard: Compares actual vs expected; increments pass/fail Clock/reset agents: Reusable blocks generating periodic clock and reset sequences Refer to the diagram on the right. |
| 10 | RTL block diagram (reference) | 0:22 | RTL block diagram (reference). Module 3: DUT hierarchy and signal flow. |
| 11 | Verification / testbench diagram (reference) | 0:22 | Verification / testbench diagram (reference). Module 3: stimulus, observation, and checking. |
| 12 | Verilog TB Makefile — counter_test | 0:28 | Verilog TB Makefile — counter_test. Review the code on screen and match it to files in the repository. iverilog links TB + counter_4bit.v; vvp runs event-driven simulation. |
| 13 | Verilog TB — clock and reset | 0:28 | Verilog TB — clock and reset. Review the code on screen and match it to files in the repository. always #half clk=~clk; reset sequence in initial block. |
| 14 | Shared DUT — counter_4bit | 0:28 | Shared DUT — counter_4bit. Review the code on screen and match it to files in the repository. Same RTL verified by both Verilog and C++ testbench paradigms. |
| 15 | Execution & simulation flow | 0:08 | Next section: Execution & simulation flow. |
| 16 | How the example runs (toolchain) | 0:32 | How the example runs (toolchain). Match each bullet to files in the repository. Makefile: Verilator compiles RTL + SystemVerilog testbench into a C++ model sim_main.cpp: generates clk/rst_n, calls eval() until $finish Directed test (initial block or C++): drive stimulus, wait for DUT flags Self-check: compare outputs; print PASS/FAIL (see terminal demo slide) Repo path... |
| 17 | Directed test execution sequence (1) | 0:32 | Follow these steps in order when working through this module. Both paradigms count errors locally same PASS criteria without manual waveform grading Instantiate DUT in Verilog TB iverilog compile vvp Follow this order when tracing waveforms or debugging. |
| 18 | Directed test execution sequence (2) | 0:24 | Follow these steps in order when working through this module. repeat with C++ TB and Verilator review comparison/ mapping guide cd module3/examples/verilog_testbenches && make counter_test Follow this order when tracing waveforms or debugging. |
| 19 | C++ TB Makefile — Verilator build | 0:28 | C++ TB Makefile — Verilator build. Review the code on screen and match it to files in the repository. cd module3/examples/cpp_testbenches && make counter_test |
| 20 | C++ TB — DUT init and reset test | 0:28 | C++ TB — DUT init and reset test. Review the code on screen and match it to files in the repository. new Vcounter_4bit; drive rst_n low; eval loop verifies count==0. |
| 21 | Verification & testing methods | 0:08 | Next section: Verification & testing methods. |
| 22 | 1. Structured test flow (build–connect–run) | 0:38 | 1. Structured test flow (build–connect–run). Build: Compile RTL + TB; elaborate hierarchy Connect: Port map DUT; tie off unused inputs Run: Execute directed cases (AND truth table, counter wrap, MUX exhaust) Cleanup: Close files, print summary, non-zero exit on failure Refer to the diagram on the right. |
| 23 | 2. Directed and exhaustive patterns | 0:34 | 2. Directed and exhaustive patterns. Truth-table tests: All input combinations for small combinational DUTs Sequential tests: Known count sequences after reset deassert Assertions: assert (C++) or immediate checks (Verilog) on each vector Refer to the diagram on the right. |
| 24 | 3. Cross-paradigm verification discipline | 0:34 | 3. Cross-paradigm verification discipline. Same spec, two TBs: Document expected behavior once; implement in Verilog and C++ Self-checking: Both paradigms count errors locally — no manual waveform grading Orchestration: ./scripts/module3.sh --verilog-testbenches vs --cpp-testbenches Refer to the diagram on the right. |
| 25 | Paradigm comparison checklist | 0:28 | Paradigm comparison checklist. Review the code on screen and match it to files in the repository. Side-by-side: initial blocks vs eval loop; same pass criteria. |
| 26 | Syllabus topics | 0:08 | Next section: Syllabus topics. |
| 27 | Protocol & design details | 0:08 | Next section: Protocol & design details. |
| 28 | 1. Verification Fundamentals (1/5) | 0:36 | 1. Verification Fundamentals (1/5). What is verification? Ensuring design correctness Finding bugs before production Verification vs. validation Testbench Purpose and Role |
| 29 | 1. Verification Fundamentals (2/5) | 0:36 | 1. Verification Fundamentals (2/5). Response monitoring Result checking Testbench as verification environment Design Under Test (DUT) Concept What is DUT? |
| 30 | 1. Verification Fundamentals (3/5) | 0:36 | 1. Verification Fundamentals (3/5). DUT interface DUT testing Verification vs. Validation Verification: Does it work correctly? Validation: Does it meet requirements? |
| 31 | 1. Verification Fundamentals (4/5) | 0:36 | 1. Verification Fundamentals (4/5). Verification Flow and Methodology Test plan creation Testbench development Test execution Result analysis |
| 32 | 1. Verification Fundamentals (5/5) | 0:28 | 1. Verification Fundamentals (5/5). Similarities Differences When to use each Performance considerations |
| 33 | 2. Testbench Architecture (1/6) | 0:36 | 2. Testbench Architecture (1/6). Verilog Testbench Module Structure Module declaration Signal declarations DUT instantiation Test sequence |
| 34 | 2. Testbench Architecture (2/6) | 0:36 | 2. Testbench Architecture (2/6). C++ Testbench Structure Main function Verilator initialization DUT instantiation Test sequence |
| 35 | 2. Testbench Architecture (3/6) | 0:36 | 2. Testbench Architecture (3/6). DUT Instantiation (Both Paradigms) Verilog: Module instantiation C++: Object creation Signal connectivity Port mapping |
| 36 | 2. Testbench Architecture (4/6) | 0:36 | 2. Testbench Architecture (4/6). Input signals Output signals Bidirectional signals Signal naming Testbench Hierarchy |
| 37 | 2. Testbench Architecture (5/6) | 0:36 | 2. Testbench Architecture (5/6). DUT hierarchy Testbench components Organization patterns Top-Level Testbench Organization Single testbench file |
| 38 | 2. Testbench Architecture (6/6) | 0:28 | 2. Testbench Architecture (6/6). Include files Library organization module3/examples/verilog_testbenches/ - Verilog testbench structure module3/examples/cpp_testbenches/ - C++ testbench structure |
| 39 | 3. Basic Testbench Components (1/6) | 0:36 | 3. Basic Testbench Components (1/6). Clock Generation (Verilog and C++) Verilog: Always blocks for continuous clock C++: Simulation loop for clock toggling Clock period control Multiple clocks |
| 40 | 3. Basic Testbench Components (2/6) | 0:36 | 3. Basic Testbench Components (2/6). Verilog: Initial blocks for reset sequences C++: Reset in C++ code Synchronous reset Asynchronous reset Reset timing |
| 41 | 3. Basic Testbench Components (3/6) | 0:36 | 3. Basic Testbench Components (3/6). Test vector generation Pattern application Sequential stimulus Timing control Response Monitoring (Both Paradigms) |
| 42 | 3. Basic Testbench Components (4/6) | 0:36 | 3. Basic Testbench Components (4/6). Real-time monitoring Post-processing Monitoring strategies Result Checking (Both Paradigms) Expected value calculation |
| 43 | 3. Basic Testbench Components (5/6) | 0:36 | 3. Basic Testbench Components (5/6). Error detection Pass/fail reporting Simulation Control Starting simulation Stopping simulation |
| 44 | 3. Basic Testbench Components (6/6) | 0:20 | 3. Basic Testbench Components (6/6). Control flow counter_test.v / counter_test.cpp - Clock and reset generation |
| 45 | 4. Signal Access and Monitoring (1/5) | 0:36 | 4. Signal Access and Monitoring (1/5). Verilog: Signal Reading and Writing Direct signal access Signal assignment Signal reading Signal types |
| 46 | 4. Signal Access and Monitoring (2/5) | 0:36 | 4. Signal Access and Monitoring (2/5). DUT object access Signal reading: dut->signal Signal writing: dut->signal = value Signal types Verilog: $display, $monitor, $strobe |
| 47 | 4. Signal Access and Monitoring (3/5) | 0:36 | 4. Signal Access and Monitoring (3/5). $monitor: Continuous monitoring $strobe: End-of-time-step output Formatting options C++: std::cout, Logging Libraries std::cout for output |
| 48 | 4. Signal Access and Monitoring (4/5) | 0:36 | 4. Signal Access and Monitoring (4/5). Logging libraries File output Formatting Output (Both Paradigms) Verilog: Format specifiers C++: Stream manipulators |
| 49 | 4. Signal Access and Monitoring (5/5) | 0:36 | 4. Signal Access and Monitoring (5/5). Readable output Timing of Display Statements When output occurs Event scheduling Timing considerations |
| 50 | 5. Simulation Control (1/5) | 0:36 | 5. Simulation Control (1/5). Verilog: Time Management (# delays) Delay control: #10 Time advancement Event scheduling Timing accuracy |
| 51 | 5. Simulation Control (2/5) | 0:36 | 5. Simulation Control (2/5). Simulation loop Time tracking Clock cycle counting Time advancement Event Scheduling Concepts |
| 52 | 5. Simulation Control (3/5) | 0:36 | 5. Simulation Control (3/5). Event queue Scheduling order Timing relationships Simulation Termination Verilog: $finish |
| 53 | 5. Simulation Control (4/5) | 0:36 | 5. Simulation Control (4/5). Cleanup procedures Resource management Debugging Basics (Both Tools) Compilation debugging Runtime debugging |
| 54 | 5. Simulation Control (5/5) | 0:20 | 5. Simulation Control (5/5). Waveform analysis counter_test.v / counter_test.cpp - Time management |
| 55 | 6. Simple Verification Patterns (1/5) | 0:36 | 6. Simple Verification Patterns (1/5). Directed Testing (Both Paradigms) Specific test cases Known input/output pairs Exhaustive testing Corner case testing |
| 56 | 6. Simple Verification Patterns (2/5) | 0:36 | 6. Simple Verification Patterns (2/5). Test vector format Vector application Sequential application Batch testing Expected vs. Actual Comparison |
| 57 | 6. Simple Verification Patterns (3/5) | 0:36 | 6. Simple Verification Patterns (3/5). Actual value reading Comparison logic Error detection Pass/Fail Reporting Test result tracking |
| 58 | 6. Simple Verification Patterns (4/5) | 0:36 | 6. Simple Verification Patterns (4/5). Result reporting Summary generation Basic Error Detection Error detection methods Error reporting |
| 59 | 6. Simple Verification Patterns (5/5) | 0:16 | 6. Simple Verification Patterns (5/5). Debugging aids |
| 60 | 7. Paradigm Comparison | 0:16 | 7. Paradigm Comparison. Side-by-Side Comparison Table |
| 61 | Hands-on examples | 0:08 | Next section: Hands-on examples. |
| 62 | Module 3 self-check | 0:45 | Module 3 self-check. Watch the terminal output and confirm you see the expected pass message. |
| 63 | Exercise scaffold | 0:28 | Exercise scaffold. Review the code on screen and match it to files in the repository. |
| 64 | Demo: Verilog testbenches | 0:45 | Demo: Verilog testbenches. Watch the terminal output and confirm you see the expected pass message. |
| 65 | Demo: C++ testbenches | 0:45 | Demo: C++ testbenches. Watch the terminal output and confirm you see the expected pass message. |
| 66 | Demo: Paradigm comparison | 0:45 | Demo: Paradigm comparison. Watch the terminal output and confirm you see the expected pass message. |
| 67 | Key concepts | 0:08 | Next section: Key concepts. |
| 68 | 1. Canonical testbench–DUT boundary | 0:28 | 1. Canonical testbench–DUT boundary. DUT: Device Under Test in module3/dut/ (gates, multiplexers, counters) TB wrapper: Encapsulates instantiation, clock/reset, and test program only Signals: Explicit wires/regs (Verilog) or model ports (C++) — no hidden coupling Lifecycle: Build → reset → run tests → report → $finish / return exit code |
| 69 | 2. Dual-paradigm environment architecture | 0:28 | 2. Dual-paradigm environment architecture. Verilog TB (examples/verilog_testbenches/): Event-driven initial/always C++ TB (examples/cpp_testbenches/): eval() loop with Verilator model Shared DUT: Same RTL verified two ways — highlights tool-specific TB idioms Comparison guide: examples/comparison/ documents mapping between styles |
| 70 | 3. Verification component roles (UVM-aligned) | 0:28 | 3. Verification component roles (UVM-aligned). Driver: Applies stimulus (assignments before eval or #delay) Monitor: Samples outputs; logs transactions or pin values Scoreboard: Compares actual vs expected; increments pass/fail Clock/reset agents: Reusable blocks generating periodic clock and reset sequences |
| 71 | 1. Structured test flow (build–connect–run) | 0:28 | 1. Structured test flow (build–connect–run). Build: Compile RTL + TB; elaborate hierarchy Connect: Port map DUT; tie off unused inputs Run: Execute directed cases (AND truth table, counter wrap, MUX exhaust) Cleanup: Close files, print summary, non-zero exit on failure |
| 72 | 2. Directed and exhaustive patterns | 0:24 | 2. Directed and exhaustive patterns. Truth-table tests: All input combinations for small combinational DUTs Sequential tests: Known count sequences after reset deassert Assertions: assert (C++) or immediate checks (Verilog) on each vector |
| 73 | 3. Cross-paradigm verification discipline | 0:24 | 3. Cross-paradigm verification discipline. Same spec, two TBs: Document expected behavior once; implement in Verilog and C++ Self-checking: Both paradigms count errors locally — no manual waveform grading Orchestration: ./scripts/module3.sh --verilog-testbenches vs --cpp-testbenches |
| 74 | 1. Verification Fundamentals (1/5) | 0:36 | 1. Verification Fundamentals (1/5). What is verification? Ensuring design correctness Finding bugs before production Verification vs. validation Testbench Purpose and Role |
| 75 | 1. Verification Fundamentals (2/5) | 0:36 | 1. Verification Fundamentals (2/5). Response monitoring Result checking Testbench as verification environment Design Under Test (DUT) Concept What is DUT? |
| 76 | 1. Verification Fundamentals (3/5) | 0:36 | 1. Verification Fundamentals (3/5). DUT interface DUT testing Verification vs. Validation Verification: Does it work correctly? Validation: Does it meet requirements? |
| 77 | 1. Verification Fundamentals (4/5) | 0:36 | 1. Verification Fundamentals (4/5). Verification Flow and Methodology Test plan creation Testbench development Test execution Result analysis |
| 78 | 1. Verification Fundamentals (5/5) | 0:28 | 1. Verification Fundamentals (5/5). Similarities Differences When to use each Performance considerations |
| 79 | 2. Testbench Architecture (1/6) | 0:36 | 2. Testbench Architecture (1/6). Verilog Testbench Module Structure Module declaration Signal declarations DUT instantiation Test sequence |
| 80 | 2. Testbench Architecture (2/6) | 0:36 | 2. Testbench Architecture (2/6). C++ Testbench Structure Main function Verilator initialization DUT instantiation Test sequence |
| 81 | 2. Testbench Architecture (3/6) | 0:36 | 2. Testbench Architecture (3/6). DUT Instantiation (Both Paradigms) Verilog: Module instantiation C++: Object creation Signal connectivity Port mapping |
| 82 | 2. Testbench Architecture (4/6) | 0:36 | 2. Testbench Architecture (4/6). Input signals Output signals Bidirectional signals Signal naming Testbench Hierarchy |
| 83 | 2. Testbench Architecture (5/6) | 0:36 | 2. Testbench Architecture (5/6). DUT hierarchy Testbench components Organization patterns Top-Level Testbench Organization Single testbench file |
| 84 | 2. Testbench Architecture (6/6) | 0:28 | 2. Testbench Architecture (6/6). Include files Library organization module3/examples/verilog_testbenches/ - Verilog testbench structure module3/examples/cpp_testbenches/ - C++ testbench structure |
| 85 | 3. Basic Testbench Components (1/6) | 0:36 | 3. Basic Testbench Components (1/6). Clock Generation (Verilog and C++) Verilog: Always blocks for continuous clock C++: Simulation loop for clock toggling Clock period control Multiple clocks |
| 86 | 3. Basic Testbench Components (2/6) | 0:36 | 3. Basic Testbench Components (2/6). Verilog: Initial blocks for reset sequences C++: Reset in C++ code Synchronous reset Asynchronous reset Reset timing |
| 87 | 3. Basic Testbench Components (3/6) | 0:36 | 3. Basic Testbench Components (3/6). Test vector generation Pattern application Sequential stimulus Timing control Response Monitoring (Both Paradigms) |
| 88 | 3. Basic Testbench Components (4/6) | 0:36 | 3. Basic Testbench Components (4/6). Real-time monitoring Post-processing Monitoring strategies Result Checking (Both Paradigms) Expected value calculation |
| 89 | 3. Basic Testbench Components (5/6) | 0:36 | 3. Basic Testbench Components (5/6). Error detection Pass/fail reporting Simulation Control Starting simulation Stopping simulation |
| 90 | 3. Basic Testbench Components (6/6) | 0:20 | 3. Basic Testbench Components (6/6). Control flow counter_test.v / counter_test.cpp - Clock and reset generation |
| 91 | 4. Signal Access and Monitoring (1/5) | 0:36 | 4. Signal Access and Monitoring (1/5). Verilog: Signal Reading and Writing Direct signal access Signal assignment Signal reading Signal types |
| 92 | 4. Signal Access and Monitoring (2/5) | 0:36 | 4. Signal Access and Monitoring (2/5). DUT object access Signal reading: dut->signal Signal writing: dut->signal = value Signal types Verilog: $display, $monitor, $strobe |
| 93 | 4. Signal Access and Monitoring (3/5) | 0:36 | 4. Signal Access and Monitoring (3/5). $monitor: Continuous monitoring $strobe: End-of-time-step output Formatting options C++: std::cout, Logging Libraries std::cout for output |
| 94 | 4. Signal Access and Monitoring (4/5) | 0:36 | 4. Signal Access and Monitoring (4/5). Logging libraries File output Formatting Output (Both Paradigms) Verilog: Format specifiers C++: Stream manipulators |
| 95 | 4. Signal Access and Monitoring (5/5) | 0:36 | 4. Signal Access and Monitoring (5/5). Readable output Timing of Display Statements When output occurs Event scheduling Timing considerations |
| 96 | 5. Simulation Control (1/5) | 0:36 | 5. Simulation Control (1/5). Verilog: Time Management (# delays) Delay control: #10 Time advancement Event scheduling Timing accuracy |
| 97 | 5. Simulation Control (2/5) | 0:36 | 5. Simulation Control (2/5). Simulation loop Time tracking Clock cycle counting Time advancement Event Scheduling Concepts |
| 98 | 5. Simulation Control (3/5) | 0:36 | 5. Simulation Control (3/5). Event queue Scheduling order Timing relationships Simulation Termination Verilog: $finish |
| 99 | 5. Simulation Control (4/5) | 0:36 | 5. Simulation Control (4/5). Cleanup procedures Resource management Debugging Basics (Both Tools) Compilation debugging Runtime debugging |
| 100 | 5. Simulation Control (5/5) | 0:20 | 5. Simulation Control (5/5). Waveform analysis counter_test.v / counter_test.cpp - Time management |
| 101 | 6. Simple Verification Patterns (1/5) | 0:36 | 6. Simple Verification Patterns (1/5). Directed Testing (Both Paradigms) Specific test cases Known input/output pairs Exhaustive testing Corner case testing |
| 102 | 6. Simple Verification Patterns (2/5) | 0:36 | 6. Simple Verification Patterns (2/5). Test vector format Vector application Sequential application Batch testing Expected vs. Actual Comparison |
| 103 | 6. Simple Verification Patterns (3/5) | 0:36 | 6. Simple Verification Patterns (3/5). Actual value reading Comparison logic Error detection Pass/Fail Reporting Test result tracking |
| 104 | 6. Simple Verification Patterns (4/5) | 0:36 | 6. Simple Verification Patterns (4/5). Result reporting Summary generation Basic Error Detection Error detection methods Error reporting |
| 105 | 6. Simple Verification Patterns (5/5) | 0:16 | 6. Simple Verification Patterns (5/5). Debugging aids |
| 106 | 7. Paradigm Comparison | 0:16 | 7. Paradigm Comparison. See docs/MODULE3.md |
| 107 | Practice & assessment | 0:08 | Next section: Practice & assessment. |
| 108 | What you should know (1/8) | 0:36 | By now you should be able to explain the following. Understand testbench purpose and structure Create basic Verilog testbench modules Create basic C++ testbenches Generate clocks and resets in both paradigms Apply stimulus to DUT (both paradigms) From MODULE3 Learning Outcomes. |
| 109 | What you should know (2/8) | 0:36 | By now you should be able to explain the following. Perform basic result checking Control simulation execution Choose appropriate testbench paradigm Use and_gate_test.v as reference Test all input combinations From MODULE3 Learning Outcomes. |
| 110 | What you should know (3/8) | 0:36 | By now you should be able to explain the following. Use and_gate_test.cpp as reference Compare with Verilog version Understand differences Create Verilog testbench Create C++ testbench From MODULE3 Learning Outcomes. |
| 111 | What you should know (4/8) | 0:36 | By now you should be able to explain the following. Implement clock generation Implement reset sequences Compare timing approaches Review comparison guide Understand when to use each From MODULE3 Learning Outcomes. |
| 112 | What you should know (5/8) | 0:36 | By now you should be able to explain the following. Can explain testbench purpose and structure Can create basic Verilog testbench modules Can create basic C++ testbenches Can generate clocks and resets (both paradigms) Can apply stimulus to DUT (both paradigms) From MODULE3 Learning Outcomes. |
| 113 | What you should know (6/8) | 0:36 | By now you should be able to explain the following. Can perform basic result checking Can control simulation execution Can choose appropriate testbench paradigm Prerequisites: Module 1: iverilog Deep Dive and Module 2: Verilator Deep Dive Next Steps: Module 4: Basic Testbench Construction - Master structured testbench construction From MODULE3 Learning Outcomes. |
| 114 | What you should know (7/8) | 0:36 | By now you should be able to explain the following. UVM Connection: UVM Core Repository Module 4: Basic Testbench Construction - Master structured testbench construction Module 5: Procedural Testbench Writing - Learn procedural testbench patterns Icarus Verilog Documentation: http://iverilog.wikia.com/ Verilator Documentation: https://verilator.org/ From MODULE3 Learning Outcomes. |
| 115 | What you should know (8/8) | 0:16 | By now you should be able to explain the following. IEEE 1364-2005 Standard: Verilog Hardware Description Language From MODULE3 Learning Outcomes. |
| 116 | Assessment checklist | 0:36 | Assessment checklist. Can explain testbench purpose and structure Can create basic Verilog testbench modules Can create basic C++ testbenches Can generate clocks and resets (both paradigms) Can apply stimulus to DUT (both paradigms) |
| 117 | Summary & next steps | 0:28 | In summary: Understand testbench architecture and basic verification concepts for both Verilog and C++ testbenches Next up: Next module in course. Understand testbench architecture and basic verification concepts for both Verilog and C++ testbenches Complete module3/CHECKLIST.md Review module3/EXAMPLES.md and run each lab Next: Next module in course |

        ## Section narration (edit for TTS)

        - **Design architecture (Canonical testbench–DUT boundary, Dual-paradigm environment architecture, Verification component roles (UVM-aligned)):** Walk through the block diagram, then relate each block to files under module3/examples/.
- **Execution:** Explain make run / UVM make steps, then walk the artifact table and directed-test sequence slide by slide.
- **Verification (Structured test flow (build–connect–run), Directed and exhaustive patterns, Cross-paradigm verification discipline):** Explain what stimulus is applied, what is checked, and what is intentionally out of scope.
- **Syllabus:** Cover 7 topic section(s) — pause on protocol timing and signals.
- **Before exercises:** Ask learners to recall the learning outcomes slide; they should explain each bullet in their own words.
- **Hands-on:** Run module3/EXAMPLES.md labs; narrate expected PASS lines.

        ## Notes

        - Slides from **Before You Start**, **Design Architecture**, **Verification & Testing Methods**, **Topics Covered**, **EXAMPLES.md**, and **Learning Outcomes**.
        - Full detail: `docs/MODULE3.md` and `module3/EXAMPLES.md`.
        - Regenerate: `regenerate_course_outlines.sh <course_root> --module 3`
