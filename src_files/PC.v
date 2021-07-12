`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2021 12:25:32 AM
// Design Name: 
// Module Name: PC
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


module PC(pc_jump_branch, clk, nrst, Jump, bne, zero,Branch, opcode, jal_imm, jalr_imm, branch_imm, rd_data1, next_pc

    );
    //next pc handler
    input clk, nrst;
    input Jump, bne, zero, Branch; //control signals for jal and branch
    input [6:0] opcode; //jal
    input [31:0] jalr_imm, branch_imm, jal_imm; //jalr and branch immediates
    input [63:0] rd_data1; //rs1 read data
    input [31:0] pc_jump_branch;
    output [31:0] next_pc;
    
    reg [31:0] pc;
    always@(posedge clk)
    begin
        if (!nrst)
        pc<=32'd0;        
        else begin
            if (Jump) begin
                if (opcode==7'b1100111) begin //jalr
                    if (jalr_imm[31]==1'b1) //check if neg
                    pc<=rd_data1[31:0]-(~jalr_imm+1);
                    else
                    pc<=jalr_imm+rd_data1[31:0];
                end
                else begin //jal
                if (jal_imm[31]==1'b1) //check if neg
                pc<=pc_jump_branch-(~jal_imm+1); 
                else
                pc<=pc_jump_branch+jal_imm;
                end
            end
            else begin 
                if(bne && ~zero) begin
                    if (branch_imm[31]==1'b1) 
                    pc<=pc_jump_branch-(~branch_imm+1);
                    else
                    pc<=pc_jump_branch+branch_imm;
                end           
                else if(~bne && Branch && zero) begin
                    if (branch_imm[31]==1'b1) 
                    pc<=pc_jump_branch-(~branch_imm+1);
                    else
                    pc<=pc_jump_branch+branch_imm;
                end
                else 
                pc<=pc+3'd4;
            end
         end
      end
    
    assign next_pc = pc;
endmodule
