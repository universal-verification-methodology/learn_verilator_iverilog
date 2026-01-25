/**
 * Modular Testbench Architecture Example - Verilog
 * 
 * Demonstrates:
 * - Modular design principles
 * - Reusability strategies
 * - Configurability
 * - Maintainability
 * - Scalability
 * 
 * This example shows a well-structured testbench following best practices.
 * 
 * Usage:
 *   iverilog -o modular_testbench modular_testbench_verilog.v ../../dut/multiplexers/mux_4to1.v
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
    parameter NUM_TESTS = 16
)(
    input clk,
    input rst_n,
    output reg [1:0] sel,
    output reg [3:0] inputs,
    output reg valid,
    output reg done
);
    integer test_count;
    
    initial begin
        sel = 0;
        inputs = 0;
        valid = 0;
        done = 0;
        test_count = 0;
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            sel <= 0;
            inputs <= 0;
            valid <= 0;
            done <= 0;
            test_count <= 0;
        end else begin
            if (test_count < NUM_TESTS) begin
                valid <= 1;
                sel <= test_count[1:0];
                inputs <= test_count[3:0];
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
    input [3:0] inputs,
    input out,
    input valid
);
    integer log_file;
    
    initial begin
        log_file = $fopen(LOG_FILE, "w");
        if (log_file == 0) begin
            $error("Failed to open log file: %s", LOG_FILE);
        end else begin
            $fdisplay(log_file, "Time\tSel\tInputs\tOut\tValid");
        end
    end
    
    always @(posedge clk) begin
        if (rst_n && valid) begin
            $fdisplay(log_file, "%0t\t%b\t%b\t%b\t%b", 
                     $time, sel, inputs, out, valid);
            $display("[MONITOR] t=%0t: sel=%b, inputs=%b, out=%b", 
                    $time, sel, inputs, out);
        end
    end
    
    // Note: Log file will be closed automatically when simulation ends
    // (iverilog doesn't support SystemVerilog 'final' blocks)
endmodule

// ============================================================================
// Checker Module (Reusable)
// ============================================================================
module checker (
    input clk,
    input rst_n,
    input [1:0] sel,
    input [3:0] inputs,
    input out,
    input valid,
    output reg error
);
    reg [3:0] expected;
    
    always @(*) begin
        if (rst_n && valid) begin
            case (sel)
                2'b00: expected = inputs[0];
                2'b01: expected = inputs[1];
                2'b10: expected = inputs[2];
                2'b11: expected = inputs[3];
                default: expected = 1'bx;
            endcase
        end else begin
            expected = 1'bx;
        end
    end
    
    always @(posedge clk) begin
        if (rst_n && valid) begin
            if (out !== expected) begin
                error <= 1;
                $error("[CHECKER] Mismatch at t=%0t: sel=%b, inputs=%b, out=%b, expected=%b",
                       $time, sel, inputs, out, expected);
            end else begin
                error <= 0;
            end
        end else begin
            error <= 0;
        end
    end
endmodule

// ============================================================================
// Scoreboard Module (Reusable)
// ============================================================================
module scoreboard (
    input clk,
    input rst_n,
    input valid,
    input error,
    input done
);
    integer pass_count;
    integer fail_count;
    integer total_tests;
    
    initial begin
        pass_count = 0;
        fail_count = 0;
        total_tests = 0;
    end
    
    always @(posedge clk) begin
        if (rst_n && valid) begin
            total_tests <= total_tests + 1;
            if (error) begin
                fail_count <= fail_count + 1;
            end else begin
                pass_count <= pass_count + 1;
            end
        end
    end
    
    always @(posedge done) begin
        #10;
        $display("");
        $display("========================================");
        $display("Scoreboard Summary");
        $display("========================================");
        $display("Total tests:  %0d", total_tests);
        $display("Passed:       %0d", pass_count);
        $display("Failed:       %0d", fail_count);
        $display("Pass rate:    %.1f%%", (pass_count * 100.0) / total_tests);
        $display("========================================");
    end
endmodule

// ============================================================================
// Main Testbench (Top Level)
// ============================================================================
module modular_testbench_verilog;
    
    // Parameters (Configurability)
    parameter CLOCK_PERIOD = 20;
    parameter RESET_DURATION = 100;
    parameter NUM_TESTS = 16;
    
    // Signals
    wire clk;
    wire rst_n;
    wire [1:0] sel;
    wire [3:0] inputs;
    wire out;
    wire valid;
    wire done;
    wire error;
    
    // Instantiate reusable modules
    clock_generator #(.PERIOD(CLOCK_PERIOD)) clk_gen (.clk(clk));
    reset_generator #(.RESET_DURATION(RESET_DURATION)) rst_gen (.rst_n(rst_n));
    stimulus_generator #(.NUM_TESTS(NUM_TESTS)) stim_gen (
        .clk(clk),
        .rst_n(rst_n),
        .sel(sel),
        .inputs(inputs),
        .valid(valid),
        .done(done)
    );
    
    // Instantiate DUT
    mux_4to1 dut (
        .sel(sel),
        .in0(inputs[0]),
        .in1(inputs[1]),
        .in2(inputs[2]),
        .in3(inputs[3]),
        .out(out)
    );
    
    // Instantiate verification components
    monitor #(.LOG_FILE("monitor.log")) mon (
        .clk(clk),
        .rst_n(rst_n),
        .sel(sel),
        .inputs(inputs),
        .out(out),
        .valid(valid)
    );
    
    checker chk (
        .clk(clk),
        .rst_n(rst_n),
        .sel(sel),
        .inputs(inputs),
        .out(out),
        .valid(valid),
        .error(error)
    );
    
    scoreboard sb (
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .error(error),
        .done(done)
    );
    
    // Waveform generation
    initial begin
        $dumpfile("modular_testbench.vcd");
        $dumpvars(0, modular_testbench_verilog);
    end
    
    // Test completion
    initial begin
        $display("========================================");
        $display("Modular Testbench Architecture Example");
        $display("========================================");
        wait(done);
        #100;
        $finish;
    end

endmodule
