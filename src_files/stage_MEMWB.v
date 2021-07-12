`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2021 05:57:26 PM
// Design Name: 
// Module Name: stage_MEMWB
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


module stage_MEMWB(clk, nrst, rdata, ALUResult, ALUResult_out, rdata_out,
MemWrite, Branch, MemRead, RegWrite, MemToReg, ALUOp, ALUSrc, Jump, sd, ld, bne, wmask,
MemWrite_o, Branch_o, MemRead_o, RegWrite_o, MemToReg_o, ALUOp_o, ALUSrc_o, Jump_o, sd_o, ld_o, bne_o, wmask_o, pc_in, pc_out, inst_in, inst_out


    );
    
    input [63:0] ALUResult, rdata;
    input clk, nrst;
    output reg [63:0] ALUResult_out, rdata_out;
    input [31:0] pc_in, inst_in;
    output reg [31:0] pc_out, inst_out;
    
    //control signals from prev stage
    input MemWrite, RegWrite, Branch, MemRead, ALUSrc; //1+1+1+1+1
    input [1:0] MemToReg; //2
    input [2:0] ALUOp; //3
    input Jump, sd, ld, bne; //1+1+1+1
    input [7:0] wmask; //8   
    
    //
    
    
    //output control signals
    output reg MemWrite_o, RegWrite_o, Branch_o, MemRead_o, ALUSrc_o; //1+1+1+1+1
    output reg [1:0] MemToReg_o; //2
    output reg [2:0] ALUOp_o; //3
    output reg Jump_o, sd_o, ld_o, bne_o; //1+1+1+1
    output reg [7:0] wmask_o; //8   
    //
    
    
    always@(posedge clk) begin
    if (!nrst)begin
        ALUResult_out<=64'd0;
        rdata_out<=64'd0;
        pc_out<=32'd0;
        inst_out<=32'd0;
    end
    else begin
        ALUResult_out<=ALUResult;
        rdata_out<=rdata;
        pc_out<=pc_in;
        inst_out<=inst_in;
    end
    end
    
    always@(posedge clk) begin
    if (!nrst)begin
        MemWrite_o<=1'b0;
        RegWrite_o<=1'b0;
        Branch_o<=1'b0;
        MemRead_o<=1'b0;
        ALUSrc_o<=1'b0;
        MemToReg_o<=2'd0;
        ALUOp_o<=3'd0;
        Jump_o<=1'b0;
        sd_o<=1'b0;
        ld_o<=1'b0;
        bne_o<=1'b0;
        wmask_o<=8'd0;
        end
    else begin
        MemWrite_o<=MemWrite;
        RegWrite_o<=RegWrite;
        Branch_o<=Branch;
        MemRead_o<=MemRead;
        ALUSrc_o<=ALUSrc;
        MemToReg_o<=MemToReg;
        ALUOp_o<=ALUOp;
        Jump_o<=Jump;
        sd_o<=sd;
        ld_o<=ld;
        bne_o<=bne;
        wmask_o<=wmask;
        end
    end
endmodule
