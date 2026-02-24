`timescale 1ns / 1ps

module disp_ctrl( // Controls 7-seg display - decodes 4-bit hex to segment pattern and manages digit selection
    input [1:0] sel_in,
    input [3:0] mux_data,
    output reg [7:0] seg_out,
    output reg [3:0] ctrl_out
    );
    
    // Digit select - active low
    always @(*) begin
        case(sel_in)
        2'b00: ctrl_out = 4'b1110;  // Digit 0 (rightmost)
        2'b01: ctrl_out = 4'b1101;  // Digit 1
        2'b10: ctrl_out = 4'b1011;  // Digit 2
        2'b11: ctrl_out = 4'b0111;  // Digit 3 (leftmost)
        default: ctrl_out = 4'b1111; // All off
        endcase
    end
    
    // 7-segment decoder - hex 0-F (active low segments)
    always @(*) begin
        case(mux_data)
        4'h0: seg_out = 8'b11000000; // 0
        4'h1: seg_out = 8'b11111001; // 1
        4'h2: seg_out = 8'b10100100; // 2
        4'h3: seg_out = 8'b10110000; // 3
        4'h4: seg_out = 8'b10011001; // 4
        4'h5: seg_out = 8'b10010010; // 5
        4'h6: seg_out = 8'b10000010; // 6
        4'h7: seg_out = 8'b11111000; // 7
        4'h8: seg_out = 8'b10000000; // 8
        4'h9: seg_out = 8'b10011000; // 9
        4'hA: seg_out = 8'b10001000; // A
        4'hB: seg_out = 8'b10000011; // b
        4'hC: seg_out = 8'b11000110; // C
        4'hD: seg_out = 8'b10100001; // d
        4'hE: seg_out = 8'b10000110; // E
        4'hF: seg_out = 8'b10001110; // F
        default: seg_out = 8'b11111111; // Blank
        endcase
    end
endmodule
