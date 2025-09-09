// E155: Lab 2 - Multiplexed 7-Segment Display
// Sebastian Heredia, dheredia@g.hmc.edu
// September 6, 2025
// lab2_DSH.sv contains code to instantiate sevensegment.sv to light up a dual 7-segment display and display the sum of the two numbers
// in binary on 5 LEDS. 
`timescale 1ns/1ps

module lab2_dsh (	input logic				clk,
					input logic 			reset,
					input logic		[3:0]	s0,
					input logic 	[3:0]	s1,
					output logic 			select,
					output logic 			notselect, 
					output logic 	[4:0]	led,
					output logic 	[6:0]	seg
				);
	
	logic [3:0]s;	// Internal logic output from mux
	
// Idiomatc Adder (5-bits on LEDs)
	assign led = s0 + s1;				// led[0] = P1, led[1] = P2, ... assign in hardware designer
					
// Instantiate HSOSC module
	logic 		int_osc;				// Integer # of oscillations
	logic [31:0]counter = 0;			// Start with counter at 0
	logic 		state = 0;
	
	HSOSC #(.CLKHF_DIV(2'b01))   		// Divides clk from 48MHz to 24MHz
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
  
    // Counter for 240Hz, a frequency that is much greater than the frequency the human eye can observe
	always_ff @(posedge int_osc) begin
		if (reset == 0)begin			// Intentionally active LOW
			counter   <= 0;
			state <= 0;
		end 
												
		else if (counter == 50000-1) begin		// 50,000 counts since indexing from 0-49,999
			counter   <= 0;
			state <= ~state;  			// Toggle LED OFF after 5E4 counts
		end 
		
		else begin
			counter <= counter + 1;		// Continue incrementing counter for next toggle
		end
	end
	
	// Using 1-bit signal to toggle between left and right displays on the dual 7-segment display
	assign select = state;
	assign notselect = ~state;			
		
	// Idiomatic mux taking in s0 and s1 and outputting 4'b into sevensegment
	assign s =  state ? s0:s1;		// ternary operator: if state == 1, then mux choses s0 value, otherwise s1.

	// Instantiate sevensegment module
    sevensegment sevensegment(s, seg);
	
endmodule 
	
	

