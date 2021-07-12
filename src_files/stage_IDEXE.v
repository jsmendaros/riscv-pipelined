`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2021 06:44:11 AM
// Design Name: 
// Module Name: stage_ID
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


module stage_IDEXE(clk, nrst,inst_IDEXE, rd_data1, rd_data2, jal_imm_in, jalr_imm_in, branch_imm_in, sd_imm_in, addi_imm_in,
    jal_imm_out, jalr_imm_out, branch_imm_out, sd_imm_out, addi_imm_out, 
    inst_IDEXE_out, rd_data1_out, rd_data2_out,
    MemWrite, Branch, MemRead, RegWrite, MemToReg, ALUOp, ALUSrc, Jump, sd, ld, bne, wmask,
MemWrite_o, Branch_o, MemRead_o, RegWrite_o, MemToReg_o, ALUOp_o, ALUSrc_o, Jump_o, sd_o, ld_o, bne_o, wmask_o, pc_in, pc_out

    );
    input clk, nrst;
    input [31:0] inst_IDEXE, pc_in;
    input [63:0] rd_data1, rd_data2;
    input [31:0] jal_imm_in, jalr_imm_in, branch_imm_in;
    input [63:0] sd_imm_in, addi_imm_in;
    
    output reg [31:0] jal_imm_out, jalr_imm_out, branch_imm_out, inst_IDEXE_out , pc_out;
    output reg [63:0] sd_imm_out, addi_imm_out;
    //[31:25] - funct7
    //[24:20] - rs2
    //19:15 - rs1
    //14:12 - funct3
    //11:7 - rd
    //6:0 opcode
    output reg [63:0] rd_data1_out, rd_data2_out;
    
    //control signals
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
        inst_IDEXE_out<=32'd0;
        rd_data1_out<=64'd0;
        rd_data2_out<=64'd0;
        jal_imm_out<=32'd0;
        jalr_imm_out<=32'd0;
        branch_imm_out<=32'd0;
        sd_imm_out<=64'd0;
        addi_imm_out<=64'd0; 
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
        pc_out<=32'd0;
    end
    else begin
        inst_IDEXE_out<=inst_IDEXE;
        rd_data1_out<=rd_data1;
        rd_data2_out<=rd_data2;
        jal_imm_out<=jal_imm_in;
        jalr_imm_out<=jalr_imm_in;
        branch_imm_out<=branch_imm_in;
        sd_imm_out<=sd_imm_in;
        addi_imm_out<=addi_imm_in; 
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
        pc_out<=pc_in;
    end
    end
    
    
    
endmodule
