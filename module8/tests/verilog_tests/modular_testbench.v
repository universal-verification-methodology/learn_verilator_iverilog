/**
 * Modular Testbench Architecture - Verilog (iverilog)
 * 
 * This testbench demonstrates best practices for modular testbench design:
 * - Modular design principles
 * - Reusability strategies
 * - Configurability
 * - Maintainability
 * - Scalability
 * 
 * Usage:
 *   make modular_testbench
 *   or
 *   iverilog -o modular_testbench modular_testbench.v ../../../module8/dut/multiplexers/mux_4to1.v
 *   vvp modular_testbench
 */

`timescale 1ns/1ps

// ============================================================================
// Clock Generator Module (Reusable)
// ============================================================================
module clock_generator #(
    parameter PERIOD = 20  // Clock period in ns
)(
    output reg clk
);
    initial clk = 0;
    always #(PERIOD/2) clk = ~clk;
endmodule

// ============================================================================
// Reset Generator Module (Reusable)
// ============================================================================
module reset_generator #(
    parameter RESET_DURATION = 100  // Reset duration in ns
)(
    output reg rst_n
);
    initial begin
        rst_n = 0;
        #RESET_DURATION;
        rst_n = 1;
    end
endmodule

// ============================================================================
// Stimulus Generator Module (Reusable)
// ============================================================================
module stimulus_generator #(
    parameter NUM_TESTS = 4
)(
    input clk,
    input rst_n,
    output reg [1:0] sel,
    output reg in0, in1, in2, in3,
    output reg valid,
    output reg done
);
    integer test_count;
    
    initial begin
        sel = 0;
        in0 = 0; in1 = 0; in2 = 0; in3 = 0;
        valid = 0;
        done = 0;
        test_count = 0;
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            sel <= 0;
            in0 <= 0; in1 <= 0; in2 <= 0; in3 <= 0;
            valid <= 0;
            done <= 0;
            test_count <= 0;
        end else begin
            if (test_count < NUM_TESTS) begin
                valid <= 1;
                sel <= test_count[1:0];
                // Set selected input to 1, others to 0
                in0 <= (test_count == 0) ? 1 : 0;
                in1 <= (test_count == 1) ? 1 : 0;
                in2 <= (test_count == 2) ? 1 : 0;
                in3 <= (test_count == 3) ? 1 : 0;
                test_count <= test_count + 1;
            end else begin
                valid <= 0;
                done <= 1;
            end
        end
    end
endmodule

// ============================================================================
// Monitor Module (Reusable)
// ============================================================================
module monitor #(
    parameter LOG_FILE = "monitor.log"
)(
    input clk,
    input rst_n,
    input [1:0] sel,
    input in0, in1, in2, in3,
    input out,
    input valid
);
    integer log_file;
    
    initial begin
        log_file = $fopen(LOG_FILE, "w");
        if (log_file == 0) begin
            $error("Failed to open log file");
        end
    end
    
    always @(posedge clk) begin
        if (rst_n && valid) begin
            $fwrite(log_file, "Time %0t: sel=%0d, in0=%b, in1=%b, in2=%b, in3=%b, out=%b\n",
                   $time, sel, in0, in1, in2, in3, out);
        end
    end
endmodule

// ============================================================================
// Checker Module (Reusable)
// ============================================================================
module checker(
    input clk,
    input rst_n,
    input [1:0] sel,
    input in0, in1, in2, in3,
    input out,
    input valid,
    output reg pass,
    output reg fail
);
    reg expected;
    
    initial begin
        pass = 0;
        fail = 0;
    end
    
    always @(posedge clk) begin
        if (rst_n && valid) begin
            // Calculate expected output
            case (sel)
                2'b00: expected = in0;
                2'b01: expected = in1;
                2'b10: expected = in2;
                2'b11: expected = in3;
                default: expected = 0;
            endcase
            
            // Check result
            if (out === expected) begin
                pass = 1;
                fail = 0;
            end else begin
                pass = 0;
                fail = 1;
                $error("Checker failed: sel=%0d, out=%b, expected=%b", sel, out, expected);
            end
        end
    end
endmodule

// ============================================================================
// Top-Level Testbench
// ============================================================================
module modular_testbench;
    // Clock and reset
    wire clk;
    wire rst_n;
    
    // DUT signals
    wire [1:0] sel;
    wire in0, in1, in2, in3;
    wire out;
    wire valid;
    wire done;
    wire pass;
    wire fail;
    
    // Test statistics
    integer total_tests = 0;
    integer passed_tests = 0;
    integer failed_tests = 0;
    
    // Instantiate reusable modules
    clock_generator #(.PERIOD(20)) clk_gen(.clk(clk));
    reset_generator #(.RESET_DURATION(100)) rst_gen(.rst_n(rst_n));
    stimulus_generator #(.NUM_TESTS(4)) stim_gen(
        .clk(clk),
        .rst_n(rst_n),
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .valid(valid),
        .done(done)
    );
    monitor #(.LOG_FILE("monitor.log")) mon(
        .clk(clk),
        .rst_n(rst_n),
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out),
        .valid(valid)
    );
    checker chk(
        .clk(clk),
        .rst_n(rst_n),
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out),
        .valid(valid),
        .pass(pass),
        .fail(fail)
    );
    
    // DUT instantiation
    mux_4to1 dut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );
    
    // Test result collection
    always @(posedge clk) begin
        if (rst_n && valid) begin
            total_tests = total_tests + 1;
            if (pass) passed_tests = passed_tests + 1;
            if (fail) failed_tests = failed_tests + 1;
        end
    end
    
    // Test sequence
    initial begin
        $display("========================================");
        $display("Modular Testbench Architecture (iverilog)");
        $display("========================================");
        
        // Wait for reset
        wait(rst_n);
        #20;
        
        // Wait for tests to complete
        wait(done);
        #50;
        
        // Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total tests: %0d", total_tests);
        $display("Passed:      %0d", passed_tests);
        $display("Failed:      %0d", failed_tests);
        $display("========================================");
        
        if (failed_tests > 0) begin
            $error("Some tests failed!");
        end else begin
            $display("All tests passed!");
        end
        
        #10;
        $finish;
    end
    
    // Waveform generation
    initial begin
        $dumpfile("modular_testbench.vcd");
        $dumpvars(0, modular_testbench);
    end
endmodule
