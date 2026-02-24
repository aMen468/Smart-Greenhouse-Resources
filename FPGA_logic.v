`timescale 1ns / 1ps

module FPGA_Logic( //Sensor logic for growth system
    // Sensor Inputs
    input [5:0] sw,
    
    // FPGA Outputs
    output [9:0] PMOD
);
 
    // Sensor input aliases
    wire S1 = sw[0];
    wire S2 = sw[1];
    wire H = sw[2];
    wire T = sw[3];
    wire L = sw[4];
    wire M = sw[5];
    
    // Growth light outputs (internal wires)
    wire G0, G1, G2, G3, G4, G5, G6, G7;
    
    // Actuator outputs (internal wires)
    wire F, P;
    
    // Growth light logic
    assign G0 = L;
    assign G1 = ((H | T) & L);
    assign G2 = (L & (S1 | S2));
    assign G3 = (L & S1 & S2);
    assign G4 = (H & L & T);
    assign G5 = (L & ~M);
    assign G6 = (L & (S1 | T));
    assign G7 = (L | (M & (S1 | S2)));
    
    // Actuator logic
    assign F = ((H & T) | (L & M) | (S1 & S2 & T));
    assign P = ((H & ~M & S2) | (H & ~M & S1) | (~M & S2 & T) | (~M & S1 & T));
    
    // Map to PMOD outputs
    assign PMOD[0] = G0;
    assign PMOD[1] = G1;
    assign PMOD[2] = G2;
    assign PMOD[3] = G3;
    assign PMOD[4] = G4;
    assign PMOD[5] = G5;
    assign PMOD[6] = G6;
    assign PMOD[7] = G7;
    assign PMOD[8] = F;
    assign PMOD[9] = P;
   
endmodule
