`timescale 1ns / 1ps

module clock_divider( // Divides 100MHz clock down to 1kHz for display
    input clk,
    input rst,
    output clk_1k
);
    
    integer count = 1;
    reg tmp = 1'b0;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 1;
            tmp <= 1'b0;
        end else begin
            count <= count + 1;
            if (count == 50000) begin
                tmp <= ~tmp;
                count <= 1;
            end
        end
    end
    
    assign clk_1k = tmp;
    
endmodule
