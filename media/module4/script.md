        # Narration script — Module 4: Basic Testbench Construction

        **Target length:** ~45 minutes (90 slides; auto-generated — edit per slide as needed)

        ## Timing table

        | Slide | Section | Duration | Narration |
|-------|---------|----------|-----------|
| 1 | Module 4 | 0:25 | Welcome to module 4, Basic Testbench Construction. In this module you will master construction of structured testbenches with proper organization. |
| 2 | Learning objectives | 0:16 | Here is what you will learn in this module. Master construction of structured testbenches with proper organization |
| 3 | Prerequisites | 0:16 | Before you start, make sure you have these prerequisites. See module README |
| 4 | Learning path | 0:22 | Learning path. Master construction of structured testbenches with proper organization |
| 5 | Overview | 0:16 | Overview. This module focuses on building well-structured testbenches for both Verilog and C++ paradigms. You'll learn to organize testbenches... |
| 6 | Design architecture | 0:08 | Next section: Design architecture. |
| 7 | 1. Structured DUT portfolio (Module 4) | 0:38 | 1. Structured DUT portfolio (Module 4). dut/alus/simple_alu.v: Combinational ALU — op select, result, zero flag dut/fifos/simple_fifo.v: Queue storage with full/empty and pointer logic dut/registers/register_file.v: Multi-port register file — read/write ports, clocked updates Complexity step: Moves from gates/counters to datapath blocks needing organized TBs Refer to the diagram on the right. |
| 8 | 2. Modular testbench architecture | 0:38 | 2. Modular testbench architecture. Separation: Stimulus generator, monitor, checker/scoreboard as distinct modules or classes Clock/reset generator: Dedicated block (clock_reset examples) — configurable period Hierarchy: Top TB instantiates agents + DUT; connects via named interfaces (wires) C++ mirror: Same roles as C++ classes with methods drive(), sample(), check() Refer to the diagram on... |
| 9 | 3. Reference model placement | 0:34 | 3. Reference model placement. Golden model: Software replica of ALU/FIFO/register behavior in TB Self-checking path: DUT output compared to reference each cycle or transaction Config: Parameters for width, depth, and clock period without editing DUT RTL Refer to the diagram on the right. |
| 10 | RTL block diagram (reference) | 0:22 | RTL block diagram (reference). Module 4: DUT hierarchy and signal flow. |
| 11 | Verification / testbench diagram (reference) | 0:22 | Verification / testbench diagram (reference). Module 4: stimulus, observation, and checking. |
| 12 | Clock/reset Makefile target | 0:28 | Clock/reset Makefile target. Review the code on screen and match it to files in the repository. Parameterize period; compile and vvp in one make target. |
| 13 | Configurable clock generation | 0:28 | Configurable clock generation. Review the code on screen and match it to files in the repository. forever #(PERIOD/2) clk=~clk; coordinated reset release. |
| 14 | Self-checking ALU ports | 0:28 | Self-checking ALU ports. Review the code on screen and match it to files in the repository. simple_alu instantiated; wires for a, b, op, result, zero. |
| 15 | Execution & simulation flow | 0:08 | Next section: Execution & simulation flow. |
| 16 | How the example runs (toolchain) | 0:32 | How the example runs (toolchain). Match each bullet to files in the repository. Makefile: Verilator compiles RTL + SystemVerilog testbench into a C++ model sim_main.cpp: generates clk/rst_n, calls eval() until $finish Directed test (initial block or C++): drive stimulus, wait for DUT flags Self-check: compare outputs; print PASS/FAIL (see terminal demo slide) Repo path... |
| 17 | Directed test execution sequence (1) | 0:32 | Follow these steps in order when working through this module. Reference model in TB compare each cycle aggregate pass/fail before $finish Build clk/rst generators connect DUT Follow this order when tracing waveforms or debugging. |
| 18 | Directed test execution sequence (2) | 0:24 | Follow these steps in order when working through this module. drive ALU/FIFO vectors reference model compare wire agents at top Follow this order when tracing waveforms or debugging. |
| 19 | Self-checking example build | 0:28 | Self-checking example build. Review the code on screen and match it to files in the repository. cd module4/examples/self_checking && make |
| 20 | Reference model function | 0:28 | Reference model function. Review the code on screen and match it to files in the repository. calculate_expected(op,a,b) — golden model in TB. |
| 21 | Verification & testing methods | 0:08 | Next section: Verification & testing methods. |
| 22 | 1. Component-level verification | 0:34 | 1. Component-level verification. Stimulus module: Encapsulates write sequences to FIFO or register ports Monitor module: Captures read data and status flags passively Checker: Flags protocol violations (overflow, X on outputs, wrong opcode result) Refer to the diagram on the right. |
| 23 | 2. Scenario-based testing | 0:34 | 2. Scenario-based testing. Scenarios: Reset + fill FIFO; ALU op sweep; register R/W hazard patterns Tasks/methods: Each scenario is a callable task — reusable across tests Aggregation: Single report summarizing scenarios run and failures Refer to the diagram on the right. |
| 24 | 3. Structured debug and closure | 0:34 | 3. Structured debug and closure. Modular debug: Isolate failing agent by disabling others in top TB Waveform on demand: Trigger dumps only when checker fires Regression: ./scripts/module4.sh --self-checking and --all-tests for batch sign-off Refer to the diagram on the right. |
| 25 | Modular TB — checker module | 0:28 | Modular TB — checker module. Review the code on screen and match it to files in the repository. Separate stimulus, monitor, and checker blocks wired at top. |
| 26 | Syllabus topics | 0:08 | Next section: Syllabus topics. |
| 27 | 1. Testbench Organization (1/7) | 0:36 | 1. Testbench Organization (1/7). Modular Testbench Structure (Verilog and C++) Separating concerns Component-based design Reusability principles Maintainability |
| 28 | 1. Testbench Organization (2/7) | 0:36 | 1. Testbench Organization (2/7). Stimulus generation module/class Response monitoring module/class Result checking module/class Component interaction Verilog: Module-Based Organization |
| 29 | 1. Testbench Organization (3/7) | 0:36 | 1. Testbench Organization (3/7). Module instantiation Signal connectivity Module reusability C++: Class-Based Organization Class hierarchy |
| 30 | 1. Testbench Organization (4/7) | 0:36 | 1. Testbench Organization (4/7). Method organization Class reusability Testbench Component Organization Component placement Signal routing |
| 31 | 1. Testbench Organization (5/7) | 0:36 | 1. Testbench Organization (5/7). Organization patterns Reusable Testbench Components Component design Parameterization Configuration |
| 32 | 1. Testbench Organization (6/7) | 0:36 | 1. Testbench Organization (6/7). Configuration and Parameters Parameter passing Configuration management Runtime configuration Build-time configuration |
| 33 | 1. Testbench Organization (7/7) | 0:16 | 1. Testbench Organization (7/7). register_file_test_cpp.cpp: Structured C++ testbench with separate classes |
| 34 | 2. Clock and Reset Generation (1/8) | 0:36 | 2. Clock and Reset Generation (1/8). Verilog: Clock Generation Patterns (Always Blocks) Continuous clock generation Configurable periods Multiple clocks Clock gating |
| 35 | 2. Clock and Reset Generation (2/8) | 0:36 | 2. Clock and Reset Generation (2/8). Clock toggling in loop Configurable periods Multiple clocks Clock coordination Configurable Clock Periods (Both Paradigms) |
| 36 | 2. Clock and Reset Generation (3/8) | 0:36 | 2. Clock and Reset Generation (3/8). Runtime configuration Clock period calculation Frequency control Multiple Clock Domains Independent clocks |
| 37 | 2. Clock and Reset Generation (4/8) | 0:36 | 2. Clock and Reset Generation (4/8). Domain crossing Synchronization Reset Generation (Synchronous, Asynchronous) Synchronous reset Asynchronous reset |
| 38 | 2. Clock and Reset Generation (5/8) | 0:36 | 2. Clock and Reset Generation (5/8). Reset sequences Verilog: Reset in Initial Blocks Initial block reset Reset timing control Reset sequences |
| 39 | 2. Clock and Reset Generation (6/8) | 0:36 | 2. Clock and Reset Generation (6/8). C++: Reset in C++ Code Reset in simulation loop Reset timing control Reset sequences Reset coordination |
| 40 | 2. Clock and Reset Generation (7/8) | 0:36 | 2. Clock and Reset Generation (7/8). Reset assertion Reset deassertion Reset duration Reset timing Clock and Reset Coordination |
| 41 | 2. Clock and Reset Generation (8/8) | 0:32 | 2. Clock and Reset Generation (8/8). Reset synchronization Timing coordination Best practices configurable_clock_reset_verilog.v: Configurable clock and reset in Verilog configurable_clock_reset_cpp.cpp: Configurable clock and reset in C++ |
| 42 | 3. Stimulus Generation (1/5) | 0:36 | 3. Stimulus Generation (1/5). Test Vector Generation Vector format Vector generation Vector storage Vector application |
| 43 | 3. Stimulus Generation (2/5) | 0:36 | 3. Stimulus Generation (2/5). Pattern types Pattern generation Pattern application Pattern verification Sequential Stimulus Application |
| 44 | 3. Stimulus Generation (3/5) | 0:36 | 3. Stimulus Generation (3/5). Timing control Application order Synchronization Stimulus Timing Control Timing accuracy |
| 45 | 3. Stimulus Generation (4/5) | 0:36 | 3. Stimulus Generation (4/5). Timing control Timing verification Stimulus Verification Stimulus validation Stimulus checking |
| 46 | 3. Stimulus Generation (5/5) | 0:16 | 3. Stimulus Generation (5/5). Verification strategies |
| 47 | 4. Response Monitoring (1/5) | 0:36 | 4. Response Monitoring (1/5). Output Monitoring Strategies Real-time monitoring Post-processing monitoring Event-driven monitoring Continuous monitoring |
| 48 | 4. Response Monitoring (2/5) | 0:36 | 4. Response Monitoring (2/5). Immediate monitoring Live updates Real-time analysis Performance considerations Post-Processing Monitoring |
| 49 | 4. Response Monitoring (3/5) | 0:36 | 4. Response Monitoring (3/5). Batch processing Data collection Analysis strategies Monitoring Timing When to monitor |
| 50 | 4. Response Monitoring (4/5) | 0:36 | 4. Response Monitoring (4/5). Timing relationships Timing control Event-Driven Monitoring Event triggers Event-based monitoring |
| 51 | 4. Response Monitoring (5/5) | 0:16 | 4. Response Monitoring (5/5). Event coordination |
| 52 | 5. Result Checking (1/5) | 0:36 | 5. Result Checking (1/5). Expected Value Calculation Expected value computation Reference models Calculation methods Accuracy |
| 53 | 5. Result Checking (2/5) | 0:36 | 5. Result Checking (2/5). Value comparison Comparison methods Comparison timing Comparison accuracy Error Detection and Reporting |
| 54 | 5. Result Checking (3/5) | 0:36 | 5. Result Checking (3/5). Error reporting Error handling Error analysis Assertion-Based Checking Assertion types |
| 55 | 5. Result Checking (4/5) | 0:36 | 5. Result Checking (4/5). Assertion organization Assertion best practices Self-Checking Testbenches Automatic checking Self-verification |
| 56 | 5. Result Checking (5/5) | 0:24 | 5. Result Checking (5/5). Pass/fail determination alu_self_checking_verilog.v: Self-checking ALU testbench in Verilog alu_self_checking_cpp.cpp: Self-checking ALU testbench in C++ |
| 57 | 6. Test Scenarios (1/7) | 0:36 | 6. Test Scenarios (1/7). Test Case Organization Test case structure Test case organization Test case management Test case documentation |
| 58 | 6. Test Scenarios (2/7) | 0:36 | 6. Test Scenarios (2/7). Scenario definition Scenario organization Scenario selection Scenario execution Test Sequencing |
| 59 | 6. Test Scenarios (3/7) | 0:36 | 6. Test Scenarios (3/7). Test dependencies Test sequencing Test coordination Test Selection Mechanisms Test selection |
| 60 | 6. Test Scenarios (4/7) | 0:36 | 6. Test Scenarios (4/7). Test prioritization Test management Test Result Aggregation Result collection Result aggregation |
| 61 | 6. Test Scenarios (5/7) | 0:36 | 6. Test Scenarios (5/7). Result reporting Location: module4/examples/modular_testbenches/register_file_test_verilog.v Demonstrates: Modular structure, separate stimulus/monitor/checker modules Location: module4/examples/modular_testbenches/register_file_test_cpp.cpp Demonstrates: Class-based organization, separate stimulus/monitor/checker classes |
| 62 | 6. Test Scenarios (6/7) | 0:36 | 6. Test Scenarios (6/7). Demonstrates: Multiple test scenarios, test sequencing Location: (Coming soon) Demonstrates: Multiple test scenarios, test sequencing Location: module4/examples/self_checking/ Demonstrates: Self-checking testbenches, comprehensive testing |
| 63 | 6. Test Scenarios (7/7) | 0:24 | 6. Test Scenarios (7/7). Demonstrates: State machine testing, state coverage Location: module4/examples/clock_reset/ Demonstrates: Configurable clock/reset, parameterization |
| 64 | Hands-on examples | 0:08 | Next section: Hands-on examples. |
| 65 | Module 4 self-check | 0:45 | Module 4 self-check. Watch the terminal output and confirm you see the expected pass message. |
| 66 | Exercise scaffold | 0:28 | Exercise scaffold. Review the code on screen and match it to files in the repository. |
| 67 | Demo: Clock and reset | 0:45 | Demo: Clock and reset. Watch the terminal output and confirm you see the expected pass message. |
| 68 | Demo: Self-checking | 0:45 | Demo: Self-checking. Watch the terminal output and confirm you see the expected pass message. |
| 69 | Demo: Stimulus and monitoring | 0:45 | Demo: Stimulus and monitoring. Watch the terminal output and confirm you see the expected pass message. |
| 70 | Demo: Modular testbenches | 0:45 | Demo: Modular testbenches. Watch the terminal output and confirm you see the expected pass message. |
| 71 | Common pitfalls | 0:08 | Next section: Common pitfalls. |
| 72 | Mixing Concerns | 0:20 | Mixing Concerns. Don't combine stimulus and checking in the same module/class Don't drive signals from monitor or checker components |
| 73 | Hardcoded Values | 0:20 | Hardcoded Values. Use parameters/constants for timing and configuration Avoid magic numbers in code |
| 74 | Insufficient Checking | 0:20 | Insufficient Checking. Don't rely on manual inspection of waveforms Always implement automatic checking |
| 75 | Poor Error Messages | 0:20 | Poor Error Messages. Include enough context to debug failures Use consistent error message format |
| 76 | Inadequate Documentation | 0:20 | Inadequate Documentation. Document component purpose and interfaces Explain complex logic and timing relationships |
| 77 | Practice & assessment | 0:08 | Next section: Practice & assessment. |
| 78 | What you should know (1/11) | 0:36 | By now you should be able to explain the following. Organize testbenches modularly (both paradigms) Generate clocks and resets properly (Verilog and C++) Create structured stimulus (both paradigms) Implement monitoring strategies (both paradigms) Build self-checking testbenches (both paradigms) From MODULE4 Learning Outcomes. |
| 79 | What you should know (2/11) | 0:36 | By now you should be able to explain the following. Choose appropriate organization style Separate stimulus, monitor, and checker modules Organize components properly Verify functionality Use class-based organization From MODULE4 Learning Outcomes. |
| 80 | What you should know (3/11) | 0:36 | By now you should be able to explain the following. Compare with Verilog approach Make clock period configurable Implement reset sequences Test different configurations Organize test cases From MODULE4 Learning Outcomes. |
| 81 | What you should know (4/11) | 0:36 | By now you should be able to explain the following. Aggregate results Calculate expected values Compare automatically Report results Design reusable modules/classes From MODULE4 Learning Outcomes. |
| 82 | What you should know (5/11) | 0:36 | By now you should be able to explain the following. Test reusability Can organize testbenches modularly (both paradigms) Can generate configurable clocks and resets (Verilog and C++) Can create structured stimulus (both paradigms) Can implement monitoring strategies (both paradigms) From MODULE4 Learning Outcomes. |
| 83 | What you should know (6/11) | 0:36 | By now you should be able to explain the following. Can organize multiple test scenarios Can choose appropriate organization style Module 5: Procedural Testbench Writing - Master procedural testbench construction Module 6: SystemVerilog Testbench Features - Learn SystemVerilog enhancements Keep stimulus, monitoring, and checking separate From MODULE4 Learning Outcomes. |
| 84 | What you should know (7/11) | 0:36 | By now you should be able to explain the following. This makes testbenches easier to understand, maintain, and debug Design components to be reusable across multiple testbenches Use parameters/configuration for flexibility Create library components for common functionality (clocks, resets, etc.) Always implement automatic result checking From MODULE4 Learning Outcomes. |
| 85 | What you should know (8/11) | 0:36 | By now you should be able to explain the following. Report pass/fail status clearly Comment code thoroughly, especially complex logic Document component interfaces and responsibilities Include usage examples in comments Provide clear, informative error messages From MODULE4 Learning Outcomes. |
| 86 | What you should know (9/11) | 0:36 | By now you should be able to explain the following. Aggregate errors for summary reporting Don't combine stimulus and checking in the same module/class Don't drive signals from monitor or checker components Use parameters/constants for timing and configuration Avoid magic numbers in code From MODULE4 Learning Outcomes. |
| 87 | What you should know (10/11) | 0:36 | By now you should be able to explain the following. Always implement automatic checking Include enough context to debug failures Use consistent error message format Document component purpose and interfaces Explain complex logic and timing relationships From MODULE4 Learning Outcomes. |
| 88 | What you should know (11/11) | 0:32 | By now you should be able to explain the following. Verilator Documentation: https://verilator.org/ GTKWave Documentation: http://gtkwave.sourceforge.net/ UVM Core Repository: https://github.com/universal-verification-methodology/core UVM User's Guide: IEEE 1800.2-2020 Standard Verification Methodology: Best practices from industry verification teams From MODULE4 Learning Outcomes. |
| 89 | Assessment checklist | 0:36 | Assessment checklist. Can organize testbenches modularly (both paradigms) Can generate configurable clocks and resets (Verilog and C++) Can create structured stimulus (both paradigms) Can implement monitoring strategies (both paradigms) Can build self-checking testbenches (both paradigms) |
| 90 | Summary & next steps | 0:28 | In summary: Master construction of structured testbenches with proper organization Next up: Next module in course. Master construction of structured testbenches with proper organization Complete module4/CHECKLIST.md Review module4/EXAMPLES.md and run each lab Next: Next module in course |

        ## Section narration (edit for TTS)

        - **Design architecture (Structured DUT portfolio (Module 4), Modular testbench architecture, Reference model placement):** Walk through the block diagram, then relate each block to files under module4/examples/.
- **Execution:** Explain make run / UVM make steps, then walk the artifact table and directed-test sequence slide by slide.
- **Verification (Component-level verification, Scenario-based testing, Structured debug and closure):** Explain what stimulus is applied, what is checked, and what is intentionally out of scope.
- **Syllabus:** Cover 6 topic section(s) — pause on protocol timing and signals.
- **Before exercises:** Ask learners to recall the learning outcomes slide; they should explain each bullet in their own words.
- **Hands-on:** Run module4/EXAMPLES.md labs; narrate expected PASS lines.

        ## Notes

        - Slides from **Before You Start**, **Design Architecture**, **Verification & Testing Methods**, **Topics Covered**, **EXAMPLES.md**, and **Learning Outcomes**.
        - Full detail: `docs/MODULE4.md` and `module4/EXAMPLES.md`.
        - Regenerate: `regenerate_course_outlines.sh <course_root> --module 4`
