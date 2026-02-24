`timescale 1ns / 1ps

module disp_driver( // Multiplexes 4 hex digits across a 4-digit 7-seg display. Cycles through digits at 1kHz
    input master_clk,
    input master_rst,
    input [3:0] data0,  // Rightmost digit
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,  // Leftmost digit
    output [7:0] seg_out,
    output [3:0] ctrl_out
    );
    
    wire int_clk;
    reg [1:0] int_sel = 2'b00;
    reg [3:0] int_data = 4'b0000;
    
    // Generate 1kHz clock for multiplexing
    clock_divider cd (.clk(master_clk), .rst(master_rst), .clk_1k(int_clk));
    
    // Cycle through digits on 1kHz clock
    always @(posedge int_clk or posedge master_rst) begin
        if (master_rst) begin
            int_sel <= 2'b00;
        end else begin
            case (int_sel)
                2'b00: int_sel <= 2'b01;
                2'b01: int_sel <= 2'b10;
                2'b10: int_sel <= 2'b11;
                2'b11: int_sel <= 2'b00;
            endcase
        end
    end
    
    // Mux data based on current digit selection
    always @(*) begin
        case (int_sel)
            2'b00: int_data = data0;
            2'b01: int_data = data1;
            2'b10: int_data = data2;
            2'b11: int_data = data3;
            default: int_data = 4'b0000;
        endcase
    end
    
    // Instantiate display controller
    disp_ctrl dc (
        .sel_in(int_sel),
        .mux_data(int_data),
        .seg_out(seg_out),
        .ctrl_out(ctrl_out)
    );
    
endmodule
