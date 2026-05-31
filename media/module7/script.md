        # Narration script — Module 7: Coverage and Assertions

        **Target length:** ~47 minutes (91 slides; auto-generated — edit per slide as needed)

        ## Timing table

        | Slide | Section | Duration | Narration |
|-------|---------|----------|-----------|
| 1 | Module 7 | 0:25 | Welcome to module 7, Coverage and Assertions. In this module you will master basic coverage analysis and assertion-based verification without systemverilog dependencies. |
| 2 | Learning objectives | 0:16 | Here is what you will learn in this module. Master basic coverage analysis and assertion-based verification without SystemVerilog dependencies |
| 3 | Prerequisites | 0:16 | Before you start, make sure you have these prerequisites. See module README |
| 4 | Learning path | 0:22 | Learning path. Master basic coverage analysis and assertion-based verification without SystemVerilog dependencies |
| 5 | Overview | 0:16 | Overview. This module covers fundamental coverage analysis and assertion-based verification using basic Verilog and C++ constructs. You'll learn... |
| 6 | Design architecture | 0:08 | Next section: Design architecture. |
| 7 | 1. Observability-focused DUT set | 0:34 | 1. Observability-focused DUT set. dut/simple_gates/, dut/multiplexers/, dut/counters/: Familiar blocks for assertion and coverage labs Checkpoints: Internal signals (count, select, flags) exposed for bind-style or inline assertions Tool split: Assertions in SV/Verilog for iverilog; C++ assert paths in Verilator examples Refer to the diagram on the right. |
| 8 | 2. Assertion architecture | 0:38 | 2. Assertion architecture. Immediate assertions: $display + if checks in procedural TB (baseline) Concurrent-style patterns: Properties described in examples where SVA subset supported Assertion libraries: Reusable check macros/modules in assertion_libraries/ examples Failure action: $error / fatal or abort simulation with non-zero status Refer to the diagram on the right. |
| 9 | 3. Coverage model architecture | 0:34 | 3. Coverage model architecture. Functional coverage points: User-defined bins on opcodes, states, or cross terms Code coverage: Line/branch awareness via simulator reports where available Feedback loop: Coverage holes drive new directed or random tests (documented in guides) Refer to the diagram on the right. |
| 10 | RTL block diagram (reference) | 0:22 | RTL block diagram (reference). Module 7: DUT hierarchy and signal flow. |
| 11 | Verification / testbench diagram (reference) | 0:22 | Verification / testbench diagram (reference). Module 7: stimulus, observation, and checking. |
| 12 | Assertions Makefile — compile DUT+TB | 0:28 | Assertions Makefile — compile DUT+TB. Review the code on screen and match it to files in the repository. iverilog -g2012 links counter DUT with assertion TB. |
| 13 | Clocked assertion check | 0:28 | Clocked assertion check. Review the code on screen and match it to files in the repository. always @(posedge clk) verify property; count pass/fail. |
| 14 | DUT under assertion test | 0:28 | DUT under assertion test. Review the code on screen and match it to files in the repository. counter_4bit instantiated; assertions observe count and reset. |
| 15 | Execution & simulation flow | 0:08 | Next section: Execution & simulation flow. |
| 16 | How the example runs (toolchain) | 0:32 | How the example runs (toolchain). Match each bullet to files in the repository. Makefile: Verilator compiles RTL + SystemVerilog testbench into a C++ model sim_main.cpp: generates clk/rst_n, calls eval() until $finish Directed test (initial block or C++): drive stimulus, wait for DUT flags Self-check: compare outputs; print PASS/FAIL (see terminal demo slide) Repo path... |
| 17 | Directed test execution sequence (1) | 0:32 | Follow these steps in order when working through this module. Clocked assertions on posedge summary block before $finish non-zero fail triggers debug Embed checks in TB run simulation Follow this order when tracing waveforms or debugging. |
| 18 | Directed test execution sequence (2) | 0:24 | Follow these steps in order when working through this module. collect assertion_pass/fail analyze coverage gaps ./scripts/module7.sh --check Follow this order when tracing waveforms or debugging. |
| 19 | Run assertion example | 0:28 | Run assertion example. Review the code on screen and match it to files in the repository. cd module7/examples/assertions && make basic_assertions_verilog |
| 20 | Reset assertion property | 0:28 | Reset assertion property. Review the code on screen and match it to files in the repository. When !rst_n, count must be 0; log ASSERT PASS or FAIL. |
| 21 | Verification & testing methods | 0:08 | Next section: Verification & testing methods. |
| 22 | 1. Assertion-based verification (ABV) | 0:34 | 1. Assertion-based verification (ABV). Property targets: Reset behavior, one-hot select, counter monotonicity, no X on outputs Assume/guarantee mindset: Environment assumptions vs DUT guarantees in examples Debug: Assertion name and time stamp in failure message — rerun with VCD at failure cycle Refer to the diagram on the right. |
| 23 | 2. Coverage-driven closure | 0:34 | 2. Coverage-driven closure. Goals: Target 100% on critical crosses; accept waived bins with documented rationale Sampling: Coverpoints updated each transaction or clock in TB code Reports: Text summaries from coverage_analysis examples — gap list for next tests Refer to the diagram on the right. |
| 24 | 3. Metrics and sign-off prep | 0:34 | 3. Metrics and sign-off prep. Pass/fail plus coverage: Exit criteria require zero assertion failures and met coverage goals Regression: Re-run assertion suite after RTL/TB edits — ./scripts/module7.sh --check Bridge to Module 8: Metrics feed verification plan and sign-off checklist Refer to the diagram on the right. |
| 25 | Assertion library module | 0:28 | Assertion library module. Review the code on screen and match it to files in the repository. Reusable check macros; include in multiple TBs. |
| 26 | Coverage analysis workflow | 0:28 | Coverage analysis workflow. Review the code on screen and match it to files in the repository. Run coverage example; review bins for untested select values. |
| 27 | Assertion summary before $finish | 0:28 | Assertion summary before $finish. Review the code on screen and match it to files in the repository. Print assertion_pass/fail totals; non-zero fail → debug waveforms. |
| 28 | Syllabus topics | 0:08 | Next section: Syllabus topics. |
| 29 | 1. Coverage Fundamentals (1/5) | 0:36 | 1. Coverage Fundamentals (1/5). What is Coverage? Verification completeness Coverage metrics Coverage goals Coverage-driven verification |
| 30 | 1. Coverage Fundamentals (2/5) | 0:36 | 1. Coverage Fundamentals (2/5). Code coverage Functional coverage Toggle coverage Coverage relationships Coverage Metrics |
| 31 | 1. Coverage Fundamentals (3/5) | 0:36 | 1. Coverage Fundamentals (3/5). Coverage bins Coverage goals Coverage closure Coverage Goals Setting coverage targets |
| 32 | 1. Coverage Fundamentals (4/5) | 0:36 | 1. Coverage Fundamentals (4/5). Coverage achievement Coverage sign-off Coverage-Driven Verification Using coverage to guide testing Coverage-directed test generation |
| 33 | 1. Coverage Fundamentals (5/5) | 0:16 | 1. Coverage Fundamentals (5/5). Coverage best practices |
| 34 | 2. Code Coverage (1/6) | 0:36 | 2. Code Coverage (1/6). Line Coverage Line execution Line coverage metrics Line coverage analysis Branch Coverage |
| 35 | 2. Code Coverage (2/6) | 0:36 | 2. Code Coverage (2/6). Branch coverage metrics Branch coverage analysis Condition Coverage Condition execution Condition coverage metrics |
| 36 | 2. Code Coverage (3/6) | 0:36 | 2. Code Coverage (3/6). Path Coverage Path execution Path coverage metrics Path coverage analysis iverilog Coverage Capabilities |
| 37 | 2. Code Coverage (4/6) | 0:36 | 2. Code Coverage (4/6). Coverage limitations Coverage tools Coverage analysis Verilator Coverage Capabilities (--coverage) Coverage flag |
| 38 | 2. Code Coverage (5/6) | 0:36 | 2. Code Coverage (5/6). Coverage data Coverage analysis Coverage Tools and Analysis Coverage tools Coverage analysis |
| 39 | 2. Code Coverage (6/6) | 0:24 | 2. Code Coverage (6/6). Coverage best practices code_coverage_iverilog.v: Manual code coverage tracking with iverilog code_coverage_verilator.cpp: Code coverage with Verilator (--coverage flag) |
| 40 | 3. Functional Coverage (Manual Implementation) (1/7) | 0:36 | 3. Functional Coverage (Manual Implementation) (1/7). Functional Coverage Concepts Functional coverage definition Coverage bins Coverage goals Coverage metrics |
| 41 | 3. Functional Coverage (Manual Implementation) (2/7) | 0:36 | 3. Functional Coverage (Manual Implementation) (2/7). Counter-based tracking Coverage bin implementation Coverage collection Coverage analysis Coverage Bins Implementation (Verilog and C++) |
| 42 | 3. Functional Coverage (Manual Implementation) (3/7) | 0:36 | 3. Functional Coverage (Manual Implementation) (3/7). Bin tracking Bin coverage Bin analysis Cross Coverage Using Manual Tracking Cross coverage definition |
| 43 | 3. Functional Coverage (Manual Implementation) (4/7) | 0:36 | 3. Functional Coverage (Manual Implementation) (4/7). Cross coverage analysis Cross coverage best practices Coverage Collection and Analysis Coverage collection Coverage storage |
| 44 | 3. Functional Coverage (Manual Implementation) (5/7) | 0:36 | 3. Functional Coverage (Manual Implementation) (5/7). Coverage reporting Verilog: Using $display/$monitor for Coverage Tracking Display-based tracking Monitor-based tracking Coverage logging |
| 45 | 3. Functional Coverage (Manual Implementation) (6/7) | 0:36 | 3. Functional Coverage (Manual Implementation) (6/7). C++: Using Variables and Data Structures for Coverage Tracking Variable-based tracking Data structure tracking Coverage storage Coverage analysis |
| 46 | 3. Functional Coverage (Manual Implementation) (7/7) | 0:16 | 3. Functional Coverage (Manual Implementation) (7/7). functional_coverage_cpp.cpp: Functional coverage using C++ data structures |
| 47 | 4. Toggle Coverage (1/4) | 0:36 | 4. Toggle Coverage (1/4). Signal Toggling Toggle definition Toggle tracking Toggle metrics Toggle analysis |
| 48 | 4. Toggle Coverage (2/4) | 0:36 | 4. Toggle Coverage (2/4). Toggle percentage Toggle goals Toggle closure Toggle best practices Toggle Analysis |
| 49 | 4. Toggle Coverage (3/4) | 0:36 | 4. Toggle Coverage (3/4). Toggle gaps Toggle optimization Toggle best practices Coverage Reporting Toggle reports |
| 50 | 4. Toggle Coverage (4/4) | 0:20 | 4. Toggle Coverage (4/4). Toggle documentation Toggle best practices |
| 51 | 5. Basic Assertion Concepts (1/7) | 0:36 | 5. Basic Assertion Concepts (1/7). What are Assertions? Assertion definition Assertion purpose Assertion benefits Assertion types |
| 52 | 5. Basic Assertion Concepts (2/7) | 0:36 | 5. Basic Assertion Concepts (2/7). Design verification Bug detection Documentation Debugging aid Simple Assertion Patterns |
| 53 | 5. Basic Assertion Concepts (3/7) | 0:36 | 5. Basic Assertion Concepts (3/7). Range assertions Boolean assertions Timing assertions Verilog: Using if-else for Assertions If-else patterns |
| 54 | 5. Basic Assertion Concepts (4/7) | 0:36 | 5. Basic Assertion Concepts (4/7). Error reporting Assertion best practices Verilog: Using $assert (if supported) $assert syntax $assert usage |
| 55 | 5. Basic Assertion Concepts (5/7) | 0:36 | 5. Basic Assertion Concepts (5/7). $assert best practices C++: Using assert() Macro assert() syntax assert() usage assert() limitations |
| 56 | 5. Basic Assertion Concepts (6/7) | 0:36 | 5. Basic Assertion Concepts (6/7). C++: Using Custom Assertion Functions Custom function design Custom function implementation Custom function usage Custom function best practices |
| 57 | 5. Basic Assertion Concepts (7/7) | 0:36 | 5. Basic Assertion Concepts (7/7). Error messages Error logging Error handling Error best practices basic_assertions_verilog.v: Basic assertions using if-else patterns |
| 58 | 6. Assertion Implementation Patterns (1/7) | 0:36 | 6. Assertion Implementation Patterns (1/7). Clock-Based Assertions Clock synchronization Clock-based checks Clock assertion patterns Clock assertion best practices |
| 59 | 6. Assertion Implementation Patterns (2/7) | 0:36 | 6. Assertion Implementation Patterns (2/7). Reset checks Reset assertion patterns Reset assertion timing Reset assertion best practices Data Validity Assertions |
| 60 | 6. Assertion Implementation Patterns (3/7) | 0:36 | 6. Assertion Implementation Patterns (3/7). Data validity patterns Data assertion implementation Data assertion best practices Protocol Assertions (Basic Patterns) Protocol checks |
| 61 | 6. Assertion Implementation Patterns (4/7) | 0:36 | 6. Assertion Implementation Patterns (4/7). Protocol assertion implementation Protocol assertion best practices Assertion Organization Assertion placement Assertion grouping |
| 62 | 6. Assertion Implementation Patterns (5/7) | 0:36 | 6. Assertion Implementation Patterns (5/7). Assertion organization best practices Reusable Assertion Functions/Tasks Assertion library design Assertion library implementation Assertion library usage |
| 63 | 6. Assertion Implementation Patterns (6/7) | 0:36 | 6. Assertion Implementation Patterns (6/7). Verilog: Assertion Tasks and Functions Task-based assertions Function-based assertions Assertion organization Assertion best practices |
| 64 | 6. Assertion Implementation Patterns (7/7) | 0:36 | 6. Assertion Implementation Patterns (7/7). Function-based assertions Class-based assertions Assertion organization Assertion best practices assertion_lib_verilog.v: Reusable assertion library in Verilog |
| 65 | 7. Coverage Analysis (1/5) | 0:36 | 7. Coverage Analysis (1/5). Coverage Collection Coverage data collection Coverage storage Coverage management Coverage best practices |
| 66 | 7. Coverage Analysis (2/5) | 0:36 | 7. Coverage Analysis (2/5). Coverage report generation Coverage report format Coverage report analysis Coverage report best practices Coverage Analysis |
| 67 | 7. Coverage Analysis (3/5) | 0:36 | 7. Coverage Analysis (3/5). Coverage analysis methods Coverage optimization Coverage best practices Coverage Gaps Identification Gap identification |
| 68 | 7. Coverage Analysis (4/5) | 0:36 | 7. Coverage Analysis (4/5). Gap closure Gap best practices Coverage Closure Strategies Closure planning Closure methods |
| 69 | 7. Coverage Analysis (5/5) | 0:16 | 7. Coverage Analysis (5/5). Closure best practices |
| 70 | 8. Coverage-Driven Test Generation (1/6) | 0:36 | 8. Coverage-Driven Test Generation (1/6). Using Coverage to Guide Testing Coverage-directed testing Coverage-based test selection Coverage optimization Coverage best practices |
| 71 | 8. Coverage-Driven Test Generation (2/6) | 0:36 | 8. Coverage-Driven Test Generation (2/6). Test generation methods Test generation strategies Test generation optimization Test generation best practices Coverage Optimization |
| 72 | 8. Coverage-Driven Test Generation (3/6) | 0:36 | 8. Coverage-Driven Test Generation (3/6). Coverage optimization methods Coverage optimization strategies Coverage optimization best practices Test Selection Based on Coverage Test selection methods |
| 73 | 8. Coverage-Driven Test Generation (4/6) | 0:36 | 8. Coverage-Driven Test Generation (4/6). Test selection optimization Test selection best practices Location: module7/examples/code_coverage/ Demonstrates: Code coverage tracking and analysis Location: module7/examples/functional_coverage/ |
| 74 | 8. Coverage-Driven Test Generation (5/6) | 0:36 | 8. Coverage-Driven Test Generation (5/6). Location: module7/examples/assertions/ Demonstrates: Basic assertion patterns and implementation Location: See coverage examples Demonstrates: Coverage-driven test generation Location: module7/examples/coverage_analysis/ (coming soon) |
| 75 | 8. Coverage-Driven Test Generation (6/6) | 0:20 | 8. Coverage-Driven Test Generation (6/6). Location: module7/examples/assertion_libraries/ Demonstrates: Reusable assertion libraries |
| 76 | Hands-on examples | 0:08 | Next section: Hands-on examples. |
| 77 | Module 7 self-check | 0:45 | Module 7 self-check. Watch the terminal output and confirm you see the expected pass message. |
| 78 | Demo: Assertions | 0:45 | Demo: Assertions. Watch the terminal output and confirm you see the expected pass message. |
| 79 | Demo: Assertion libraries | 0:45 | Demo: Assertion libraries. Watch the terminal output and confirm you see the expected pass message. |
| 80 | Demo: Coverage analysis | 0:45 | Demo: Coverage analysis. Watch the terminal output and confirm you see the expected pass message. |
| 81 | Practice & assessment | 0:08 | Next section: Practice & assessment. |
| 82 | What you should know (1/8) | 0:36 | By now you should be able to explain the following. Understand fundamental coverage concepts Measure code coverage with both tools Implement manual functional coverage (both paradigms) Write basic assertions in Verilog and C++ Organize assertions effectively From MODULE7 Learning Outcomes. |
| 83 | What you should know (2/8) | 0:36 | By now you should be able to explain the following. Use coverage to guide verification Achieve basic coverage closure Apply assertion-based verification patterns Use tool-specific coverage flags Track coverage manually From MODULE7 Learning Outcomes. |
| 84 | What you should know (3/8) | 0:36 | By now you should be able to explain the following. Create coverage bins Track coverage manually Generate coverage reports Use C++ data structures Track coverage manually From MODULE7 Learning Outcomes. |
| 85 | What you should know (4/8) | 0:36 | By now you should be able to explain the following. Use if-else patterns Create assertion tasks Organize assertions Use assert() macro Create custom assertion functions From MODULE7 Learning Outcomes. |
| 86 | What you should know (5/8) | 0:36 | By now you should be able to explain the following. Design reusable assertions Organize assertion library Use assertion library Identify coverage gaps Plan coverage closure From MODULE7 Learning Outcomes. |
| 87 | What you should know (6/8) | 0:36 | By now you should be able to explain the following. Use coverage to guide testing Generate tests based on coverage Optimize test selection Can understand fundamental coverage concepts Can measure code coverage with both tools From MODULE7 Learning Outcomes. |
| 88 | What you should know (7/8) | 0:36 | By now you should be able to explain the following. Can write basic assertions in Verilog and C++ Can organize assertions effectively Can analyze coverage reports Can use coverage to guide verification Can achieve basic coverage closure From MODULE7 Learning Outcomes. |
| 89 | What you should know (8/8) | 0:32 | By now you should be able to explain the following. Module 8: Verification Methodology and Best Practices - Learn industry best practices and verification sign-off Icarus Verilog Documentation: http://iverilog.wikia.com/ Verilator Documentation: https://verilator.org/ GTKWave Documentation: http://gtkwave.sourceforge.net/ IEEE 1364-2005 Standard: Verilog Hardware Description Language From... |
| 90 | Assessment checklist | 0:36 | Assessment checklist. Can understand fundamental coverage concepts Can measure code coverage with both tools Can implement manual functional coverage (both paradigms) Can write basic assertions in Verilog and C++ Can organize assertions effectively |
| 91 | Summary & next steps | 0:28 | In summary: Master basic coverage analysis and assertion-based verification without SystemVerilog dependencies Next up: Next module in course. Master basic coverage analysis and assertion-based verification without SystemVerilog dependencies Complete module7/CHECKLIST.md Review module7/EXAMPLES.md and run each lab Next: Next module in course |

        ## Section narration (edit for TTS)

        - **Design architecture (Observability-focused DUT set, Assertion architecture, Coverage model architecture):** Walk through the block diagram, then relate each block to files under module7/examples/.
- **Execution:** Explain make run / UVM make steps, then walk the artifact table and directed-test sequence slide by slide.
- **Verification (Assertion-based verification (ABV), Coverage-driven closure, Metrics and sign-off prep):** Explain what stimulus is applied, what is checked, and what is intentionally out of scope.
- **Syllabus:** Cover 8 topic section(s) — pause on protocol timing and signals.
- **Before exercises:** Ask learners to recall the learning outcomes slide; they should explain each bullet in their own words.
- **Hands-on:** Run module7/EXAMPLES.md labs; narrate expected PASS lines.

        ## Notes

        - Slides from **Before You Start**, **Design Architecture**, **Verification & Testing Methods**, **Topics Covered**, **EXAMPLES.md**, and **Learning Outcomes**.
        - Full detail: `docs/MODULE7.md` and `module7/EXAMPLES.md`.
        - Regenerate: `regenerate_course_outlines.sh <course_root> --module 7`
