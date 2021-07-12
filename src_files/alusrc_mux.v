`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2021 01:31:25 AM
// Design Name: 
// Module Name: alusrc_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alusrc_mux(rd_data2, sd_imm, addi_imm, ALUSrc, sd, alu_in2

    );
    
    input [63:0] rd_data2, sd_imm, addi_imm;
    input ALUSrc, sd;
    output [63:0] alu_in2;
    
    assign alu_in2 = ALUSrc ? ((sd)? sd_imm : addi_imm) : rd_data2;
endmodule
