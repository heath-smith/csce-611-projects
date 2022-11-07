module cpu_testtop;

/** RISC-V register file testbench for CSCE611 Fall 2020
 *
 * Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels
 * /

/** ModelSim testbench
 * This testbench exists to automate driving the clock and reset lines when
 * single-stepping through the CPU in the Quartus/ModelSim GUI.
 *
 * Usage:
 *  1.  Run `make testbench`
 *  2.  Run `vsim -c work.cpu_testtop` (Pulls up this testbench in the GUI)
 *  3.  In the GUI: Look for a row of blue arrows.
 *  4.  Find the "Single step" or "Step into" arrow.
 *  5a. Click the arrow numerous times to advance incrementally through the
 *      simulation.
 *  5b. In the TCL console at the bottom of the screen, type `run 30`, or some
 *      other value, to advance the simulation that many timesteps. (This can
 *      allow you to skip past the initial reset to the point in time where
 *      the CPU starts doing interesting stuff!)
 *
 * Feel free to embellish this testbench if you need to!
 *
 */


logic clk;
logic reset;
logic [31:0] in0;
logic [31:0] out0;

cpu dut(clk, reset, in0, out0);

// Drive the clock forever with this block.
always begin
  #5; clk = 1; #5 clk = 0;
end

// This is important! Only want to set these values once at sim startup.
initial begin
  reset = 1'b1; #27; reset = 1'b0;
end

endmodule
