/**
 * Hello World Example for iverilog
 * 
 * This is the simplest possible testbench to verify iverilog installation.
 * It demonstrates basic compilation and simulation with iverilog.
 * 
 * Usage:
 *   iverilog -o hello_world hello_world.v
 *   vvp hello_world
 */

module hello_world;

    initial begin
        $display("========================================");
        $display("Hello World from Icarus Verilog!");
        $display("========================================");
        $display("If you see this message, iverilog is working correctly.");
        $display("Time: %0t", $time);
        $display("========================================");
        #10;  // Wait 10 time units
        $finish;
    end

endmodule
