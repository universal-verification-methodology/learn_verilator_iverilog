/**
 * GTKWave Usage Example for iverilog
 * 
 * This testbench demonstrates:
 * - VCD file generation
 * - Multiple signal types (clock, data, control)
 * - Signal transitions for waveform analysis
 * - GTKWave viewing workflow
 * 
 * Usage:
 *   iverilog -o gtkwave_example gtkwave_example.v ../../dut/simple_gates/and_gate.v
 *   vvp gtkwave_example
 *   gtkwave gtkwave_example.vcd
 */

`timescale 1ns/1ps

module gtkwave_example;

    // Testbench signals
    reg  clk;
    reg  a, b;
    wire y;
    reg  enable;
    integer counter;

    // Instantiate DUT
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );


    /**
     * Clock Generation Block
     * 
     * This creates a free-running clock signal that toggles every 5ns.
     * The clock period is 10ns (5ns high + 5ns low), giving a frequency of 100MHz.
     * 
     * 'forever' loop: runs indefinitely until simulation ends
     * #5: wait 5 time units (5ns with our timescale)
     * ~clk: bitwise NOT (toggles the clock)
     * 
     * This clock can be used to drive sequential circuits or create
     * time references for waveform analysis.
     */
    initial begin
        clk = 0;              // Initialize clock to 0
        forever #5 clk = ~clk; // Toggle every 5ns (10ns period = 100MHz)
    end

    /**
     * Test Sequence with Multiple Signal Transitions
     * 
     * This testbench creates a comprehensive waveform with:
     * - Multiple signal types (clock, data, control)
     * - Various signal transitions (slow, fast, patterns)
     * - Different test phases for analysis
     * 
     * The goal is to generate interesting waveforms that demonstrate
     * GTKWave's capabilities for signal analysis and debugging.
     */
    initial begin
        $display("========================================");
        $display("GTKWave Example Testbench");
        $display("========================================");
        $display("This testbench generates a VCD file for GTKWave analysis.");
        $display("After simulation, view the waveform with: gtkwave gtkwave_example.vcd");
        $display("");
        
        /**
         * Signal Initialization
         * 
         * Initialize all signals to known values.
         * This prevents X (unknown) states in waveforms.
         */
        a = 0;        // AND gate input A
        b = 0;        // AND gate input B
        enable = 0;   // Control signal (not used by DUT, but good for waveforms)
        counter = 0;  // Loop counter variable
        
        // Wait a few clock cycles for initialization to complete
        #20;
        
        $display("Starting test sequence at time %0t", $time);
        
        /**
         * Phase 1: Basic Operations
         * 
         * Test all four combinations of AND gate inputs.
         * This creates a clear pattern in the waveform that's easy to analyze.
         */
        enable = 1;   // Enable signal goes high
        a = 0; b = 0; // Test case: 0 & 0 = 0
        #20;          // Wait 20ns (2 clock cycles)
        $display("Time %0t: a=%b, b=%b, y=%b", $time, a, b, y);
        
        a = 0; b = 1; // Test case: 0 & 1 = 0
        #20;
        $display("Time %0t: a=%b, b=%b, y=%b", $time, a, b, y);
        
        a = 1; b = 0; // Test case: 1 & 0 = 0
        #20;
        $display("Time %0t: a=%b, b=%b, y=%b", $time, a, b, y);
        
        a = 1; b = 1; // Test case: 1 & 1 = 1
        #20;
        $display("Time %0t: a=%b, b=%b, y=%b", $time, a, b, y);
        
        /**
         * Phase 2: Rapid Transitions
         * 
         * Create fast signal changes to demonstrate timing analysis.
         * This shows how signals transition and how delays affect waveforms.
         */
        enable = 0;   // Disable
        #10;          // Short delay (1 clock cycle)
        enable = 1;  // Re-enable
        #10;          // Short delay
        
        /**
         * Phase 3: Counter Demonstration
         * 
         * Use a loop to generate a pattern of test vectors.
         * This demonstrates how to generate test vectors programmatically.
         * 
         * The counter variable is used to create different input combinations:
         * - counter[0]: least significant bit (LSB) -> input 'a'
         * - counter[1]: second bit -> input 'b'
         * 
         * This creates a binary counting pattern on the inputs.
         */
        for (counter = 0; counter < 8; counter = counter + 1) begin
            // Extract bits from counter to drive inputs
            // This creates a pattern: 00, 01, 10, 11, 00, 01, 10, 11
            a = counter[0];  // LSB of counter -> input A
            b = counter[1];  // Second bit of counter -> input B
            #20;             // Wait between test vectors
            $display("Time %0t: counter=%0d, a=%b, b=%b, y=%b", 
                     $time, counter, a, b, y);
        end
        
        /**
         * Phase 4: Final State
         * 
         * Return all signals to a known final state.
         * This makes the waveform easier to read and shows proper cleanup.
         */
        enable = 0;
        a = 0;
        b = 0;
        #20;
        
        // Completion message
        $display("");
        $display("========================================");
        $display("Test sequence complete!");
        $display("VCD file generated: gtkwave_example.vcd");
        $display("View with: gtkwave gtkwave_example.vcd");
        $display("========================================");
        #10;
        $finish;
    end

    /**
     * VCD File Generation for GTKWave
     * 
     * This block generates the waveform file that GTKWave can read.
     * 
     * $dumpvars parameters:
     * - First argument (0): Hierarchy level
     *   * 0 = all signals in module and all submodules (full hierarchy)
     *   * 1 = only signals in this module (not submodules)
     *   * 2+ = deeper levels
     * - Second argument: Module instance name
     * 
     * Multiple $dumpvars calls:
     * - First call dumps all signals in testbench module
     * - Second call explicitly dumps DUT signals (redundant but ensures capture)
     * 
     * GTKWave Usage Tips:
     * - Open: gtkwave gtkwave_example.vcd
     * - Add signals: Select signals in left panel, right-click -> "Insert"
     * - Zoom: Mouse wheel or +/- keys
     * - Time markers: Click and drag on timeline
     * - Save session: File -> Write Save File (creates .gtkw file)
     */
    initial begin
        $dumpfile("gtkwave_example.vcd");           // Set VCD output filename
        $dumpvars(0, gtkwave_example);              // Dump all signals (level 0 = full hierarchy)
        $dumpvars(1, dut);                          // Explicitly dump DUT signals (redundant but safe)
    end

endmodule
