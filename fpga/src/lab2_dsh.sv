// E155: Lab 2 - Multiplexed 7-Segment Display
// Sebastian Heredia, dheredia@g.hmc.edu
// September 6, 2025
// lab2_DSH.sv contains code to instantiate sevensegment.sv to light up a dual 7-segment display and display the sum of the two numbers
// in binary on 5 LEDS. 
`timescale 1ns/1ps

module lab2_dsh (	input logic 			reset,
					input logic		[3:0]	s0,
					input logic 	[3:0]	s1,
					output logic 			select,
					output logic 			notselect, 
					output logic 	[4:0]	led,
					output logic 	[6:0]	seg
				);
	
	logic [3:0]s;	// internal logic output from mux
	
// Idiomatc Adder (5-bits on LEDs)
	assign led = s0 + s1;				// led[0] = P1, led[1] = P2, ... assign in hardware designer
					
// Instantiate HSOSC module
	logic 		int_osc;				// Integer # of oscillations
	logic [31:0]counter = 0;			// Start with counter at 0
	logic 		state = 0;
	
	HSOSC #(.CLKHF_DIV(2'b01)) 													// Divide clk to 24MHz
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
  
    // Counter for 2.4Hz
	always_ff @(posedge int_osc) begin
		if (reset == 0)begin			// intentionall active LOW
			counter   <= 0;
			state <= 0;
		end 
		
		// 24MHz / 2.4Hz = 10E6													// UPDATE
		// 10E6 / 2 = 5E6 for toggle (ON-OFF)
		// Subtract 1 since [4,999,999:0] is 5E6 bits
												
		else if (counter == 50000-1) begin
			counter   <= 0;
			state <= ~state;  			// Toggle LED OFF after 5E6 counts
		end 
		
		else begin
			counter <= counter + 1;		// Continue incrementing counter
		end
	end
	
	assign select = state;
	assign notselect = ~state;
		
// Idiomatic mux taking in s0 and s1 and outputting 4'b into sevensegment
	assign s =  state ? s0:s1;		// if state == 1, then mux choses s0 value, otherwise s1.

	// Instantiate sevensegment module
    sevensegment sevensegment(s, seg);
	
endmodule 
