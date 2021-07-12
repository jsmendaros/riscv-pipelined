`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2021 05:20:09 AM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(inst, jal_imm, jalr_imm, branch_imm, sd_imm, addi_imm

    );
    
    input [31:0] inst;
    output [31:0] jal_imm, jalr_imm, branch_imm;
    output [63:0] sd_imm, addi_imm;
    
    assign jalr_imm={{20{inst[31]}}, {inst[31:20]}}; //1+4+6+1+8+44
    assign jal_imm={{12{inst[31]}},{inst[31],inst[19:12],inst[20],inst[30:21],1'b0}};
    
    assign branch_imm={{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
    
    assign addi_imm={{52{inst[31]}},inst[31:20]};
    assign sd_imm={{52{inst[31]}},inst[31:25],inst[11:7]};
    
endmodule
