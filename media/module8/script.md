        # Narration script — Module 8: Verification Methodology and Best Practices

        **Target length:** ~51 minutes (99 slides; auto-generated — edit per slide as needed)

        ## Timing table

        | Slide | Section | Duration | Narration |
|-------|---------|----------|-----------|
| 1 | Module 8 | 0:25 | Welcome to module 8, Verification Methodology and Best Practices. In this module you will master verification methodology and industry best practices. |
| 2 | Learning objectives | 0:16 | Here is what you will learn in this module. Master verification methodology and industry best practices |
| 3 | Prerequisites | 0:16 | Before you start, make sure you have these prerequisites. See module README |
| 4 | Learning path | 0:22 | Learning path. Master verification methodology and industry best practices |
| 5 | Overview | 0:16 | Overview. This module focuses on verification methodology, best practices, and preparing for real-world verification projects. You'll learn about... |
| 6 | Design architecture | 0:08 | Next section: Design architecture. |
| 7 | 1. End-to-end verification program architecture | 0:38 | 1. End-to-end verification program architecture. DUT portfolio: Gates, counters, multiplexers — representative of prior modules TB styles: Modular Verilog TBs and C++ Verilator TBs under tests/ Knowledge base: Guides in examples/ (planning, metrics, sign-off, industry practices) Automation: ./scripts/module8.sh orchestrates methodology demos, not just RTL compiles Refer to the diagram on the... |
| 8 | 2. Layered testbench architecture (production pattern) | 0:38 | 2. Layered testbench architecture (production pattern). Test layer: Selects scenario, configures plusargs, sets pass criteria Environment layer: Agents, scoreboard, coverage collectors — reusable per project DUT layer: RTL with assertions and optional bind modules Tool layer: Simulator choice (iverilog vs Verilator) per block complexity and SV needs Refer to the diagram on the right. |
| 9 | 3. Verification infrastructure | 0:34 | 3. Verification infrastructure. Regression shell: Scripts batch examples; logs archived for trend analysis Documentation: Test plans, coding standards, tool comparison guides in-repo Metrics store: Example formats for coverage/assertion summaries before sign-off Refer to the diagram on the right. |
| 10 | RTL block diagram (reference) | 0:22 | RTL block diagram (reference). Module 8: DUT hierarchy and signal flow. |
| 11 | Verification / testbench diagram (reference) | 0:22 | Verification / testbench diagram (reference). Module 8: stimulus, observation, and checking. |
| 12 | Modular TB Makefile | 0:28 | Modular TB Makefile. Review the code on screen and match it to files in the repository. Compiles reusable generator modules + mux DUT + top TB. |
| 13 | Reusable clock/reset generators | 0:28 | Reusable clock/reset generators. Review the code on screen and match it to files in the repository. Separate clock_generator and reset_generator parameterized modules. |
| 14 | Top TB — wire agents to DUT | 0:28 | Top TB — wire agents to DUT. Review the code on screen and match it to files in the repository. clk_gen, rst_gen, stim_gen, dut, monitor, checker, scoreboard hierarchy. |
| 15 | Execution & simulation flow | 0:08 | Next section: Execution & simulation flow. |
| 16 | How the example runs (toolchain) | 0:32 | How the example runs (toolchain). Match each bullet to files in the repository. Makefile: Verilator compiles RTL + SystemVerilog testbench into a C++ model sim_main.cpp: generates clk/rst_n, calls eval() until $finish Directed test (initial block or C++): drive stimulus, wait for DUT flags Self-check: compare outputs; print PASS/FAIL (see terminal demo slide) Repo path... |
| 17 | Directed test execution sequence (1) | 0:32 | Follow these steps in order when working through this module. scoreboard aggregates checker results metrics tracker reports pass rate and coverage bins Plan tests run modular environment track metrics Follow this order when tracing waveforms or debugging. |
| 18 | Directed test execution sequence (2) | 0:24 | Follow these steps in order when working through this module. apply tool selection guide ./scripts/module8.sh --check for sign-off readiness cd module8/examples/testbench_architecture && make modular_testbench_verilog Follow this order when tracing waveforms or debugging. |
| 19 | Metrics tracker build | 0:28 | Metrics tracker build. Review the code on screen and match it to files in the repository. cd module8/examples/verification_metrics && make |
| 20 | Checker module — expected vs actual | 0:28 | Checker module — expected vs actual. Review the code on screen and match it to files in the repository. checker samples on posedge clk; $error on mismatch. |
| 21 | Verification & testing methods | 0:08 | Next section: Verification & testing methods. |
| 22 | 1. Verification planning and strategy | 0:34 | 1. Verification planning and strategy. Test plan: Features → test cases → priority → owner → status Strategy selection: Directed vs random vs assertion-heavy per risk area Entry/exit criteria: Definition of done per milestone (smoke, feature, full regression) Refer to the diagram on the right. |
| 23 | 2. Metrics, regression, and debug methodology | 0:34 | 2. Metrics, regression, and debug methodology. Metrics: Functional coverage, assertion pass rate, test count, bug find rate Regression: Nightly ./scripts/module8.sh style runs; compare logs to golden Debug process: Reproduce → minimize → fix → add regression test (examples in debugging_methodology/) Refer to the diagram on the right. |
| 24 | 3. Sign-off and industry practice | 0:34 | 3. Sign-off and industry practice. Sign-off checklist: Coverage goals met, zero outstanding sev-1 assertions, plan executed Tool selection: Decision matrix (iverilog vs Verilator) from tool_selection/ guide Maintainability: Coding standards and modular TB rules for team-scale projects Refer to the diagram on the right. |
| 25 | Metrics — test counters | 0:28 | Metrics — test counters. Review the code on screen and match it to files in the repository. total_tests, passed_tests, failed_tests, coverage_bins tracking. |
| 26 | Tool selection criteria | 0:28 | Tool selection criteria. Review the code on screen and match it to files in the repository. When iverilog vs Verilator; SV feature needs vs performance. |
| 27 | Sign-off metrics report | 0:28 | Sign-off metrics report. Review the code on screen and match it to files in the repository. Final $display of pass rate and coverage before regression sign-off. |
| 28 | Syllabus topics | 0:08 | Next section: Syllabus topics. |
| 29 | 1. Verification Planning (1/5) | 0:36 | 1. Verification Planning (1/5). Test Plan Development Test plan structure Test plan content Test plan review Test plan maintenance |
| 30 | 1. Verification Planning (2/5) | 0:36 | 1. Verification Planning (2/5). Strategy definition Strategy selection Strategy implementation Strategy evaluation Test Case Identification |
| 31 | 1. Verification Planning (3/5) | 0:36 | 1. Verification Planning (3/5). Test case identification Test case prioritization Test case documentation Coverage Planning Coverage goals |
| 32 | 1. Verification Planning (4/5) | 0:36 | 1. Verification Planning (4/5). Coverage tracking Coverage closure Resource Estimation Resource planning Resource allocation |
| 33 | 1. Verification Planning (5/5) | 0:16 | 1. Verification Planning (5/5). Resource optimization |
| 34 | 2. Testbench Architecture Best Practices (1/5) | 0:36 | 2. Testbench Architecture Best Practices (1/5). Modular Design Principles Module separation Interface definition Module communication Module testing |
| 35 | 2. Testbench Architecture Best Practices (2/5) | 0:36 | 2. Testbench Architecture Best Practices (2/5). Reusable components Component libraries Component configuration Component documentation Configurability |
| 36 | 2. Testbench Architecture Best Practices (3/5) | 0:36 | 2. Testbench Architecture Best Practices (3/5). Configuration management Configuration testing Configuration documentation Maintainability Code organization |
| 37 | 2. Testbench Architecture Best Practices (4/5) | 0:36 | 2. Testbench Architecture Best Practices (4/5). Code review Code refactoring Scalability Scalable architecture Performance optimization |
| 38 | 2. Testbench Architecture Best Practices (5/5) | 0:24 | 2. Testbench Architecture Best Practices (5/5). Growth planning modular_testbench_verilog.v: Well-structured modular testbench in Verilog modular_testbench_cpp.cpp: Well-structured modular testbench in C++ |
| 39 | 3. Coding Standards for Testbenches (1/5) | 0:36 | 3. Coding Standards for Testbenches (1/5). Naming Conventions Module naming Signal naming Parameter naming Function/task naming |
| 40 | 3. Coding Standards for Testbenches (2/5) | 0:36 | 3. Coding Standards for Testbenches (2/5). File structure Module organization Function organization Code layout Commenting Standards |
| 41 | 3. Coding Standards for Testbenches (3/5) | 0:36 | 3. Coding Standards for Testbenches (3/5). Inline comments Section comments Documentation comments Documentation Practices README files |
| 42 | 3. Coding Standards for Testbenches (4/5) | 0:36 | 3. Coding Standards for Testbenches (4/5). Test documentation User guides Style Guides Verilog style C++ style |
| 43 | 3. Coding Standards for Testbenches (5/5) | 0:20 | 3. Coding Standards for Testbenches (5/5). Tools coding_standards_guide.md: Comprehensive coding standards guide |
| 44 | 4. Verification Metrics (1/5) | 0:36 | 4. Verification Metrics (1/5). Coverage Metrics Code coverage Functional coverage Toggle coverage Coverage analysis |
| 45 | 4. Verification Metrics (2/5) | 0:36 | 4. Verification Metrics (2/5). Bug tracking Bug analysis Bug closure Bug reporting Test Metrics |
| 46 | 4. Verification Metrics (3/5) | 0:36 | 4. Verification Metrics (3/5). Test pass rate Test execution time Test efficiency Progress Tracking Progress measurement |
| 47 | 4. Verification Metrics (4/5) | 0:36 | 4. Verification Metrics (4/5). Progress analysis Progress optimization Quality Metrics Quality measurement Quality analysis |
| 48 | 4. Verification Metrics (5/5) | 0:24 | 4. Verification Metrics (5/5). Quality reporting metrics_tracker_verilog.v: Metrics tracking in Verilog metrics_tracker_cpp.cpp: Metrics tracking in C++ |
| 49 | 5. Debugging Methodology (1/5) | 0:36 | 5. Debugging Methodology (1/5). Systematic Debugging Approach Debugging process Debugging steps Debugging techniques Debugging best practices |
| 50 | 5. Debugging Methodology (2/5) | 0:36 | 5. Debugging Methodology (2/5). Waveform viewers Logging tools Debugging utilities Debugging scripts Logging Strategies |
| 51 | 5. Debugging Methodology (3/5) | 0:36 | 5. Debugging Methodology (3/5). Log format Log management Log analysis Error Reporting Error messages |
| 52 | 5. Debugging Methodology (4/5) | 0:36 | 5. Debugging Methodology (4/5). Error tracking Error analysis Root Cause Analysis Problem identification Cause analysis |
| 53 | 5. Debugging Methodology (5/5) | 0:16 | 5. Debugging Methodology (5/5). Solution verification |
| 54 | 6. Regression Testing (1/5) | 0:36 | 6. Regression Testing (1/5). Regression Test Suite Organization Test suite structure Test organization Test categorization Test maintenance |
| 55 | 6. Regression Testing (2/5) | 0:36 | 6. Regression Testing (2/5). Test selection methods Test prioritization Test optimization Test efficiency Automation |
| 56 | 6. Regression Testing (3/5) | 0:36 | 6. Regression Testing (3/5). Build automation Report automation Automation tools Continuous Integration CI setup |
| 57 | 6. Regression Testing (4/5) | 0:36 | 6. Regression Testing (4/5). CI best practices CI maintenance Regression Analysis Regression detection Regression analysis |
| 58 | 6. Regression Testing (5/5) | 0:16 | 6. Regression Testing (5/5). Regression closure |
| 59 | 7. Verification Sign-Off (1/5) | 0:36 | 7. Verification Sign-Off (1/5). Sign-Off Criteria Criteria definition Criteria measurement Criteria achievement Criteria documentation |
| 60 | 7. Verification Sign-Off (2/5) | 0:36 | 7. Verification Sign-Off (2/5). Coverage goals Coverage achievement Coverage verification Coverage documentation Bug Closure |
| 61 | 7. Verification Sign-Off (3/5) | 0:36 | 7. Verification Sign-Off (3/5). Bug verification Bug documentation Bug closure process Documentation Requirements Documentation types |
| 62 | 7. Verification Sign-Off (4/5) | 0:36 | 7. Verification Sign-Off (4/5). Documentation review Documentation maintenance Review Process Review preparation Review execution |
| 63 | 7. Verification Sign-Off (5/5) | 0:16 | 7. Verification Sign-Off (5/5). Review closure |
| 64 | 8. Tool Selection and Integration (1/6) | 0:36 | 8. Tool Selection and Integration (1/6). When to Use iverilog Use cases Advantages Limitations Best practices |
| 65 | 8. Tool Selection and Integration (2/6) | 0:36 | 8. Tool Selection and Integration (2/6). Use cases Advantages Limitations Best practices Tool Comparison and Trade-offs |
| 66 | 8. Tool Selection and Integration (3/6) | 0:36 | 8. Tool Selection and Integration (3/6). Performance comparison Cost comparison Selection criteria Performance Considerations Simulation speed |
| 67 | 8. Tool Selection and Integration (4/6) | 0:36 | 8. Tool Selection and Integration (4/6). Compilation time Optimization Feature Comparison Verilog support SystemVerilog support |
| 68 | 8. Tool Selection and Integration (5/6) | 0:36 | 8. Tool Selection and Integration (5/6). Coverage support Hybrid Approaches Tool combination Workflow integration Best practices |
| 69 | 8. Tool Selection and Integration (6/6) | 0:16 | 8. Tool Selection and Integration (6/6). tool_comparison_guide.md: Tool selection and comparison guide |
| 70 | 9. Project Management (1/5) | 0:36 | 9. Project Management (1/5). Verification Project Planning Project planning Project structure Project execution Project closure |
| 71 | 9. Project Management (2/5) | 0:36 | 9. Project Management (2/5). Resource planning Resource allocation Resource tracking Resource optimization Schedule Management |
| 72 | 9. Project Management (3/5) | 0:36 | 9. Project Management (3/5). Schedule tracking Schedule optimization Schedule reporting Risk Management Risk identification |
| 73 | 9. Project Management (4/5) | 0:36 | 9. Project Management (4/5). Risk mitigation Risk monitoring Communication and Reporting Communication plan Reporting structure |
| 74 | 9. Project Management (5/5) | 0:16 | 9. Project Management (5/5). Reporting tools |
| 75 | 10. Industry Practices (1/7) | 0:36 | 10. Industry Practices (1/7). Open-Source Verification Tools Tool ecosystem Tool selection Tool integration Tool maintenance |
| 76 | 10. Industry Practices (2/7) | 0:36 | 10. Industry Practices (2/7). IEEE standards Industry practices Compliance Certification Tool Ecosystems |
| 77 | 10. Industry Practices (3/7) | 0:36 | 10. Industry Practices (3/7). Tool workflows Tool best practices Tool evolution Career Development Skill development |
| 78 | 10. Industry Practices (4/7) | 0:36 | 10. Industry Practices (4/7). Professional growth Continuing education Continuing Education Learning resources Training programs |
| 79 | 10. Industry Practices (5/7) | 0:36 | 10. Industry Practices (5/7). Professional development Transition to Commercial Tools Tool evaluation Tool migration Tool training |
| 80 | 10. Industry Practices (6/7) | 0:36 | 10. Industry Practices (6/7). Location: See testbench architecture examples Demonstrates: Complete verification environment following best practices Location: module8/examples/testbench_architecture/ Demonstrates: Modular, reusable, configurable testbench architecture Location: See coding standards and guides |
| 81 | 10. Industry Practices (7/7) | 0:28 | 10. Industry Practices (7/7). Location: See verification metrics examples Demonstrates: Metrics tracking and sign-off criteria Location: Various example directories Demonstrates: Best practices and methodologies |
| 82 | Hands-on examples | 0:08 | Next section: Hands-on examples. |
| 83 | Module 8 self-check | 0:45 | Module 8 self-check. Watch the terminal output and confirm you see the expected pass message. |
| 84 | Demo: Testbench architecture | 0:45 | Demo: Testbench architecture. Watch the terminal output and confirm you see the expected pass message. |
| 85 | Demo: Verification metrics | 0:45 | Demo: Verification metrics. Watch the terminal output and confirm you see the expected pass message. |
| 86 | Demo: Tool selection | 0:45 | Demo: Tool selection. Watch the terminal output and confirm you see the expected pass message. |
| 87 | Demo: Coding standards | 0:45 | Demo: Coding standards. Watch the terminal output and confirm you see the expected pass message. |
| 88 | Practice & assessment | 0:08 | Next section: Practice & assessment. |
| 89 | What you should know (1/9) | 0:36 | By now you should be able to explain the following. Plan verification projects Apply best practices Measure verification progress Debug systematically Manage regression testing From MODULE8 Learning Outcomes. |
| 90 | What you should know (2/9) | 0:36 | By now you should be able to explain the following. Apply industry methodologies Develop test plan Identify test cases Plan coverage Estimate resources From MODULE8 Learning Outcomes. |
| 91 | What you should know (3/9) | 0:36 | By now you should be able to explain the following. Follow coding standards Implement reusable components Document thoroughly Organize test suite Automate execution From MODULE8 Learning Outcomes. |
| 92 | What you should know (4/9) | 0:36 | By now you should be able to explain the following. Analyze regressions Document test plan Document testbenches Document results Create sign-off package From MODULE8 Learning Outcomes. |
| 93 | What you should know (5/9) | 0:36 | By now you should be able to explain the following. Close all bugs Complete documentation Review and sign-off Can plan verification projects Can apply best practices From MODULE8 Learning Outcomes. |
| 94 | What you should know (6/9) | 0:36 | By now you should be able to explain the following. Can debug systematically Can manage regression testing Can achieve verification sign-off Can apply industry methodologies UVM Methodology: Advanced verification with UVM (see learn_uvm2017_sv_verilator repository) From MODULE8 Learning Outcomes. |
| 95 | What you should know (7/9) | 0:36 | By now you should be able to explain the following. Advanced Topics: Power verification, performance verification Industry Projects: Apply skills to real-world projects Commercial Tools: Transition to VCS, QuestaSim, Xcelium Icarus Verilog Documentation: http://iverilog.wikia.com/ Verilator Documentation: https://verilator.org/ From MODULE8 Learning Outcomes. |
| 96 | What you should know (8/9) | 0:36 | By now you should be able to explain the following. IEEE 1364-2005 Standard: Verilog Hardware Description Language IEEE 1800-2017 Standard: SystemVerilog Language Reference Manual Write effective testbenches in Verilog and C++ Use both iverilog and Verilator Apply verification best practices From MODULE8 Learning Outcomes. |
| 97 | What you should know (9/9) | 0:16 | By now you should be able to explain the following. Achieve verification sign-off From MODULE8 Learning Outcomes. |
| 98 | Assessment checklist | 0:36 | Assessment checklist. Can plan verification projects Can apply best practices Can measure verification progress Can debug systematically Can manage regression testing |
| 99 | Summary & next steps | 0:28 | In summary: Master verification methodology and industry best practices Next up: Next module in course. Master verification methodology and industry best practices Complete module8/CHECKLIST.md Review module8/EXAMPLES.md and run each lab Next: Next module in course |

        ## Section narration (edit for TTS)

        - **Design architecture (End-to-end verification program architecture, Layered testbench architecture (production pattern), Verification infrastructure):** Walk through the block diagram, then relate each block to files under module8/examples/.
- **Execution:** Explain make run / UVM make steps, then walk the artifact table and directed-test sequence slide by slide.
- **Verification (Verification planning and strategy, Metrics, regression, and debug methodology, Sign-off and industry practice):** Explain what stimulus is applied, what is checked, and what is intentionally out of scope.
- **Syllabus:** Cover 10 topic section(s) — pause on protocol timing and signals.
- **Before exercises:** Ask learners to recall the learning outcomes slide; they should explain each bullet in their own words.
- **Hands-on:** Run module8/EXAMPLES.md labs; narrate expected PASS lines.

        ## Notes

        - Slides from **Before You Start**, **Design Architecture**, **Verification & Testing Methods**, **Topics Covered**, **EXAMPLES.md**, and **Learning Outcomes**.
        - Full detail: `docs/MODULE8.md` and `module8/EXAMPLES.md`.
        - Regenerate: `regenerate_course_outlines.sh <course_root> --module 8`
