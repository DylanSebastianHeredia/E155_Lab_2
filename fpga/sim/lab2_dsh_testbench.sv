// E155: Lab 2 - Multiplexed 7-Segment Display
// Sebastian Heredia, dheredia@g.hmc.edu
// September 7, 2025
// lab2_dsh_testbench.sv contains the automatic testbench code for lab2_dsh.sv, ensuring proper simulation.

`timescale 1ns/1ps	// Standard time unit

module lab2_dsh_testbench();
	logic clk, reset;
	
	logic [3:0]s0;
	logic [3:0]s1;
	
	logic select;
	logic notselect;
	
	logic [4:0]led;
	logic [6:0]seg;

// Instantiate lab2_dsh.sv module
lab2_dsh dut(clk, reset, s0, s1, select, notselect, led, seg);

// Apply inputs one at a time
// Checking results

always 
	begin
		clk = 1; #5;
		clk = 0; #5;
	end
	
	initial begin 
		
		reset = 0;
	
		// for select = 1;
		s0 = 4'b0000; s1 = 4'b0000; #10;
		assert (seg === 7'b1000000 && led === 5'b00000 && select == ~notselect)	// 0 + 0 = 0
		else $error("0 + 0 failed.");
			
		s0 = 4'b1000; s1 = 4'b1010; #10;

		assert (seg === 7'b0000000 && led === 5'b10010 && select == ~notselect)	// 8 + A = 18
		else $error("8 + A failed.");
			
		s0 = 4'b1010; s1 = 4'b1000; #10;
		assert (seg === 7'b0001000 && led === 5'b10010 && select == ~notselect)	// A + 8 = 18
		else $error("A + 8 failed.");
				
		s0 = 4'b1111; s1 = 4'b1111; #10;
		assert (seg === 7'b0001110 && led === 5'b11110 && select == ~notselect)	// F + F = 30
		else $error("F + F failed.");
	end
endmodule

