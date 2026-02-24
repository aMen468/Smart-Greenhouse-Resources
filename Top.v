`timescale 1ns / 1ps

module Project_1_Top( // Top level module integrating sensor logic with dual 7-segment displays
    input clk,              // Master clock
    input rst,              // Reset button
    input [5:0] sw,         // 6 switches for sensors
    output [9:0] PMOD,      // PMOD outputs for breadboard
    output [7:0] D0_SEG,    // Display 0 segments
    output [3:0] D0_AN,     // Display 0 anodes
    output [7:0] D1_SEG,    // Display 1 segments
    output [3:0] D1_AN      // Display 1 anodes
    );
    
    // Internal wires for growth lights
    wire [7:0] growth_lights;
    assign growth_lights = PMOD[7:0];
    
    // Sensor aliases
    wire S1 = sw[0];
    wire S2 = sw[1];
    wire H = sw[2];
    wire T = sw[3];
    wire L = sw[4];
    wire M = sw[5];
    
    // Actuator wires
    wire F = PMOD[8];
    wire P = PMOD[9];
    
    // Calculate number of active growth lights
    wire [3:0] light_count;
    assign light_count = growth_lights[0] + growth_lights[1] + growth_lights[2] + 
                        growth_lights[3] + growth_lights[4] + growth_lights[5] + 
                        growth_lights[6] + growth_lights[7];
    
    // Convert light count to percentage (0, 12, 25, 37, 50, 62, 75, 87, 100)
    reg [7:0] light_percentage;
    always @(*) begin
        case(light_count)
            4'd0: light_percentage = 8'd0;
            4'd1: light_percentage = 8'd12;
            4'd2: light_percentage = 8'd25;
            4'd3: light_percentage = 8'd37;
            4'd4: light_percentage = 8'd50;
            4'd5: light_percentage = 8'd62;
            4'd6: light_percentage = 8'd75;
            4'd7: light_percentage = 8'd87;
            4'd8: light_percentage = 8'd100;
            default: light_percentage = 8'd0;
        endcase
    end
    
    // Extract BCD digits for percentage display
    wire [3:0] perc_ones = light_percentage % 10;
    wire [3:0] perc_tens = (light_percentage / 10) % 10;
    wire [3:0] perc_hundreds = (light_percentage / 100) % 10;
    
    // Display 0 (D0) data: Light percentage as "0XX" or "100"
    wire [3:0] disp1_dig0 = perc_ones;      // Ones
    wire [3:0] disp1_dig1 = perc_tens;      // Tens
    wire [3:0] disp1_dig2 = perc_hundreds;  // Hundreds (0 or 1)
    wire [3:0] disp1_dig3 = 4'h0;          // Blank/unused
    
    // Create status code from all sensors and actuators
    // Bit assignment: [P F M L T H S2 S1]
    wire [7:0] status_code = {P, F, M, L, T, H, S2, S1};
    
    // Display 1 (D1) data: Status code in hex "XX"
    wire [3:0] disp2_dig0 = status_code[3:0];   // Low nibble
    wire [3:0] disp2_dig1 = status_code[7:4];   // High nibble
    wire [3:0] disp2_dig2 = 4'h0;              // Blank/unused
    wire [3:0] disp2_dig3 = 4'h0;              // Blank/unused
    
    // Instantiate FPGA Logic module
    FPGA_Logic logic_module(
        .sw(sw),
        .PMOD(PMOD)
    );
    
    // Instantiate display drivers for both displays
    disp_driver display0(
        .master_clk(clk),
        .master_rst(rst),
        .data0(disp1_dig0),
        .data1(disp1_dig1),
        .data2(disp1_dig2),
        .data3(disp1_dig3),
        .seg_out(D0_SEG),
        .ctrl_out(D0_AN)
    );
    
    disp_driver display1(
        .master_clk(clk),
        .master_rst(rst),
        .data0(disp2_dig0),
        .data1(disp2_dig1),
        .data2(disp2_dig2),
        .data3(disp2_dig3),
        .seg_out(D1_SEG),
        .ctrl_out(D1_AN)
    );
    
endmodule
