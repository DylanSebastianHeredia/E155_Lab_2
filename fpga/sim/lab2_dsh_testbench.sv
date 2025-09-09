// E155: Lab 2 - Multiplexed 7-Segment Display
// Sebastian Heredia, dheredia@g.hmc.edu
// September 8, 2025
// lab2_dsh_full_testbench.sv
// Full automatic testbench for lab2_dsh.sv. Tests all sums of s0+s1 on LEDs,
// validates 7-segment outputs for each nibble, and ensures select/notselect toggle correctly.

`timescale 1ns/1ps

module lab2_dsh_testbench;

    logic clk, reset;
    logic [3:0] s0, s1;
    logic select, notselect;
    logic [4:0] led;
    logic [6:0] seg;

    // Instantiate DUT
    lab2_dsh dut (clk, reset, s0, s1, select, notselect, led, seg);

    // clk
    always #5 clk = ~clk;

    // sevensegment decoder (Duplicateed from sevensegment.sv)
    function automatic [6:0] seg_expected (input [3:0] value_holder);
        case(value_holder)
            4'h0: seg_expected = 7'b1000000;
            4'h1: seg_expected = 7'b1111001;
            4'h2: seg_expected = 7'b0100100;
            4'h3: seg_expected = 7'b0110000;
            4'h4: seg_expected = 7'b0011001;
            4'h5: seg_expected = 7'b0010010;
            4'h6: seg_expected = 7'b0000010;
            4'h7: seg_expected = 7'b1111000;
            4'h8: seg_expected = 7'b0000000;
            4'h9: seg_expected = 7'b0011000;
            4'ha: seg_expected = 7'b0001000;
            4'hb: seg_expected = 7'b0000011;
            4'hc: seg_expected = 7'b1000110;
            4'hd: seg_expected = 7'b0100001;
            4'he: seg_expected = 7'b0000110;
            4'hf: seg_expected = 7'b0001110;
            default: seg_expected = 7'b1111111;
        endcase
    endfunction

    // Start tests
    initial begin
        clk = 0;
        reset = 0;
        #20;
        reset = 1;

        // Test all possible input combinations
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                s0 = a;    // Simplification!
                s1 = b;
                #20;  // Allow some cycles for DUT to settle

                // Checking LED sum
                if (led !== a + b)
                    $error("LED SUM ERROR: s0=%0d s1=%0d expected=%0d got=%0d", a, b, a + b, led);

                // Checking select and notselect (Right and Left sides of dual 7-segment display)
                if (select !== ~notselect)
                    $error("SELECT ERROR: select=%b notselect=%b", select, notselect);

                // Checking sevensegment output encoding
                if (select) begin
                    if (seg !== seg_expected(s0))
                        $error("SEG ERROR: s0=%h expected=%b got=%b", s0, seg_expected(s0), seg);
                end else begin
                    if (seg !== seg_expected(s1))
                        $error("SEG ERROR: s1=%h expected=%b got=%b", s1, seg_expected(s1), seg);
                end
            end
        end

        $display("ALL TESTS PASSED SUCCESSFULLY.");
        $finish;
    end

endmodule







