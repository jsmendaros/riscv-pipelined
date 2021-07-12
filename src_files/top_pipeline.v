`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2021 02:48:46 AM
// Design Name: 
// Module Name: top_pipeline
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


module processor(clk, nrst, inst, rdata, ALUop1, ALUop2, ALUres, RFwrdata, RFwren,
addr, pc, wr_en, wdata, wmask

    );
    
    input clk, nrst;
    input [31:0] inst;
    input [63:0] rdata;
    output [63:0] ALUop1, ALUop2, ALUres, RFwrdata, wdata;
    output RFwren, wr_en;
    output [31:0] addr, pc;
    output [7:0] wmask;
    
    /*Start of IFID stage*/
    
    wire [31:0] ifid_pc_in, ifid_pc_out;
    wire [31:0] inst_IFID_in, inst_IFID_out;
    assign inst_IFID_in=inst;
    wire [31:0] next_pc; //pc+4 for jalr
    wire [31:0] jal_imm_idexe_out, jalr_imm_idexe_out, branch_imm_idexe_out;
    /* wire memwb_MemWrite_o, memwb_RegWrite_o, memwb_Branch_o, memwb_MemRead_o, memwb_ALUSrc_o; 
    wire [1:0] memwb_MemToReg_o; 
    wire [2:0] memwb_ALUOp_o; 
    wire memwb_Jump_o, memwb_sd_o, memwb_ld_o, memwb_bne_o; 
    wire [7:0] memwb_wmask_o;  */
    wire [31:0] jal_imm_exemem_out, jalr_imm_exemem_out, branch_imm_exemem_out, out_pc_jump_branch;
    wire idexe_MemWrite_o, idexe_RegWrite_o, idexe_Branch_o, idexe_MemRead_o, idexe_ALUSrc_o; 
    wire [63:0] rd_data1, rd_data2, rd_data1_out, rd_data2_out, write_data_wb_out;
    wire idexe_Jump_o, idexe_sd_o, idexe_ld_o, idexe_bne_o; 
    wire zero;
    wire exemem_zero_in, exemem_zero_out;
    wire [31:0] inst_IDEXE_in, inst_IDEXE_out;
    wire [31:0] idexe_pc_in, idexe_pc_out, out_pc;


    //program counter
    
    PC pc1(idexe_pc_out, clk, nrst, idexe_Jump_o, idexe_bne_o, zero,idexe_Branch_o, inst_IDEXE_out[6:0], 
    jal_imm_idexe_out, jalr_imm_idexe_out, branch_imm_idexe_out, rd_data1_out, next_pc); //pc and inst adder /*come back to add memwb ends*/
    //
    assign pc=next_pc; //pc+4
    
    stage_IFID ifid (clk, nrst, pc, out_pc, inst_IFID_in, inst_IFID_out);
    
    
    /*Start of IDEXE stage*/
    
    wire [63:0] idexe_rd_data1, idexe_rd_data2;
    wire [63:0] idexe_imm_in, idexe_imm_out;
    
    assign inst_IDEXE_in = inst_IFID_out;
    assign idexe_pc_in=out_pc;
    //input control signals
    wire idexe_MemWrite_in, idexe_RegWrite_in, idexe_Branch_in, idexe_MemRead_in, idexe_ALUSrc_in; 
    wire [1:0] idexe_MemToReg_in; 
    wire [2:0] idexe_ALUOp_in; 
    wire idexe_Jump_in, idexe_sd_in, idexe_ld_in, idexe_bne_in; 
    wire [7:0] idexe_wmask_in; 

    //output control signals
    wire [1:0] idexe_MemToReg_o; 
    wire [2:0] idexe_ALUOp_o; 
    wire [7:0] idexe_wmask_o;  
    
    wire [4:0] rd_reg1, rd_reg2, write_reg, write_reg_idexe_in, write_reg_exemem_in, write_reg_memwb_in, write_reg_idexe_out, write_reg_exemem_out, write_reg_memwb_out;
    
    inst_decoder inst_to_rf(inst_IFID_out, rd_reg1, rd_reg2, write_reg_idexe_in);
    
    wire memwb_RegWrite_o;
    RF regfile(clk, nrst, rd_reg1, rd_reg2, memwb_inst_out[11:7], write_data_wb_out, rd_data1, rd_data2, memwb_RegWrite_o); //come back to attach from wbmux
    assign RFwren = memwb_RegWrite_o;

    controller control_unit(inst_IDEXE_in, idexe_MemWrite_in, idexe_Branch_in, idexe_MemRead_in, idexe_RegWrite_in,
     idexe_MemToReg_in, idexe_ALUOp_in, idexe_ALUSrc_in, idexe_Jump_in, idexe_sd_in, idexe_ld_in, idexe_bne_in, idexe_wmask_in);
    
    //Immediate signals
    wire [31:0] jal_imm_idexe_in, jalr_imm_idexe_in, branch_imm_idexe_in;
    wire [63:0] sd_imm_idexe_in, addi_imm_idexe_in;
    wire [63:0] sd_imm_idexe_out, addi_imm_idexe_out;
    
    imm_gen immgen(inst_IFID_out, jal_imm_idexe_in, jalr_imm_idexe_in, branch_imm_idexe_in, sd_imm_idexe_in, addi_imm_idexe_in);
    
    /*stage_IDEXE(clk, nrst,inst_IDEXE, rd_data1, rd_data2, jal_imm_in, jalr_imm_in, branch_imm_in, sd_imm_in, addi_imm_in,
    jal_imm_out, jalr_imm_out, branch_imm_out, sd_imm_out, addi_imm_out, 
    inst_IDEXE_out, rd_data1_out, rd_data2_out,
    MemWrite, Branch, MemRead, RegWrite, MemToReg, ALUOp, ALUSrc, Jump, sd, ld, bne, wmask,
MemWrite_o, Branch_o, MemRead_o, RegWrite_o, MemToReg_o, ALUOp_o, ALUSrc_o, Jump_o, sd_o, ld_o, bne_o, wmask_o, pc_in, pc_out

    );*/
    stage_IDEXE idexe(clk, nrst,inst_IDEXE_in, rd_data1, rd_data2, jal_imm_idexe_in, jalr_imm_idexe_in, branch_imm_idexe_in, sd_imm_idexe_in, addi_imm_idexe_in,
    jal_imm_idexe_out, jalr_imm_idexe_out, branch_imm_idexe_out,
    sd_imm_idexe_out, addi_imm_idexe_out,
    inst_IDEXE_out, rd_data1_out, rd_data2_out,
    idexe_MemWrite_in, idexe_Branch_in, idexe_MemRead_in, idexe_RegWrite_in,
    idexe_MemToReg_in, idexe_ALUOp_in, idexe_ALUSrc_in, idexe_Jump_in, idexe_sd_in, idexe_ld_in, idexe_bne_in, idexe_wmask_in,
    idexe_MemWrite_o,idexe_Branch_o, idexe_MemRead_o,idexe_RegWrite_o, idexe_MemToReg_o,idexe_ALUOp_o, idexe_ALUSrc_o,
    idexe_Jump_o, idexe_sd_o, idexe_ld_o, idexe_bne_o,
    idexe_wmask_o, idexe_pc_in, idexe_pc_out);
    
    /*Start of EXEMEM stage*/
    //Contains ALUSrc mux, ALU
    
    
    
    wire [31:0] exemem_pc_in, exemem_pc_out;
    wire [31:0] exemem_inst_in, exemem_inst_out;
    //Immediate signals
    wire [31:0] jal_imm_exemem_in, jalr_imm_exemem_in, branch_imm_exemem_in;
    
    assign exemem_pc_in = idexe_pc_out;
    assign exemem_inst_in=inst_IDEXE_out; 
    
    //input control signals
    wire exemem_MemWrite_in, exemem_RegWrite_in, exemem_Branch_in, exemem_MemRead_in, exemem_ALUSrc_in; 
    wire [1:0] exemem_MemToReg_in; 
    wire [2:0] exemem_ALUOp_in; 
    wire exemem_Jump_in, exemem_sd_in, exemem_ld_in, exemem_bne_in; 
    wire [7:0] exemem_wmask_in; 
    
    assign exemem_MemWrite_in=idexe_MemWrite_o;
    assign exemem_RegWrite_in=idexe_RegWrite_o;
    assign exemem_Branch_in =idexe_Branch_o;
    assign exemem_MemRead_in=idexe_MemRead_o;
    assign exemem_ALUSrc_in=idexe_ALUSrc_o;
    assign exemem_MemToReg_in=idexe_MemToReg_o;
    assign exemem_ALUOp_in=idexe_ALUOp_o;
    assign exemem_Jump_in=idexe_Jump_o;
    assign exemem_sd_in=idexe_sd_o;
    assign exemem_ld_in=idexe_ld_o;
    assign exemem_bne_in=idexe_bne_o;
    assign exemem_wmask_in=idexe_wmask_o;
    
        
    //output control signals
    wire exemem_MemWrite_o, exemem_RegWrite_o, exemem_Branch_o, exemem_MemRead_o, exemem_ALUSrc_o; 
    wire [1:0] exemem_MemToReg_o; 
    wire [2:0] exemem_ALUOp_o; 
    wire exemem_Jump_o, exemem_sd_o, exemem_ld_o, exemem_bne_o; 
    wire [7:0] exemem_wmask_o;  
    
    wire [63:0] alu_in2; //connect alusrc mux to alu
    
    alusrc_mux alusrc_mux1(.rd_data2(rd_data2_out), .ALUSrc(idexe_ALUSrc_o), .alu_in2(alu_in2), .sd_imm(sd_imm_idexe_out), .addi_imm(addi_imm_idexe_out), .sd(idexe_sd_o)); //alusrc mux
    
    wire [2:0] ALUOp; //alu
    wire [63:0] exemem_in_ALUresult, exemem_out_rd_data2, exemem_out_ALUresult;
    alu alu1(.ALUOp(idexe_ALUOp_o), .in1(rd_data1_out), .in2(alu_in2), .zero(zero), .ALUresult(exemem_in_ALUresult)); //alu
    
   
    stage_EXEMEM exemem(clk, nrst, exemem_in_ALUresult, exemem_out_ALUresult, rd_data2_out, exemem_out_rd_data2,
    exemem_MemWrite_in, exemem_Branch_in, exemem_MemRead_in, exemem_RegWrite_in, 
    exemem_MemToReg_in, exemem_ALUOp_in, exemem_ALUSrc_in, exemem_Jump_in, exemem_sd_in, exemem_ld_in, exemem_bne_in,
    exemem_wmask_in,
    exemem_MemWrite_o, exemem_Branch_o, exemem_MemRead_o, exemem_RegWrite_o,
    exemem_MemToReg_o, exemem_ALUOp_o, exemem_ALUSrc_o, exemem_Jump_o, exemem_sd_o, exemem_ld_o, exemem_bne_o, exemem_wmask_o,
    exemem_pc_in, exemem_pc_out,
    exemem_inst_in, exemem_inst_out, jal_imm_exemem_in, jalr_imm_exemem_in, branch_imm_exemem_in,
    jal_imm_exemem_out, jalr_imm_exemem_out, branch_imm_exemem_out);
    
    /*
    stage_EXEMEM(clk, nrst, ALUResult, ALUResult_out, rd_data2, rd_data2_out,
    MemWrite, Branch, MemRead, RegWrite, MemToReg, ALUOp, ALUSrc, Jump, sd, ld, bne, wmask,
    MemWrite_o, Branch_o, MemRead_o, RegWrite_o, MemToReg_o, ALUOp_o, ALUSrc_o, Jump_o, sd_o, ld_o, bne_o, wmask_o, pc_in, pc_out, inst_in, inst_out
    
    );
    */
    /*Start of MEMWB stage*/
    
    wire [31:0] memwb_pc_in, memwb_pc_out;
    wire [31:0] memwb_inst_in, memwb_inst_out;
    
    assign memwb_pc_in = exemem_pc_out;
    assign memwb_inst_in=exemem_inst_out; 
    assign memwb_ALUresult_in=exemem_out_ALUresult;
    
    //input control signals
    wire memwb_MemWrite_in, memwb_RegWrite_in, memwb_Branch_in, memwb_MemRead_in, memwb_ALUSrc_in; 
    wire [1:0] memwb_MemToReg_in; 
    wire [2:0] memwb_ALUOp_in; 
    wire memwb_Jump_in, memwb_sd_in, memwb_ld_in, memwb_bne_in; 
    wire [7:0] memwb_wmask_in; 

      
    assign memwb_MemWrite_in=exemem_MemWrite_o;
    assign memwb_RegWrite_in=exemem_RegWrite_o;
    assign memwb_Branch_in =exemem_Branch_o;
    assign memwb_MemRead_in=exemem_MemRead_o;
    assign memwb_ALUSrc_in=exemem_ALUSrc_o;
    assign memwb_MemToReg_in=exemem_MemToReg_o;
    assign memwb_ALUOp_in=exemem_ALUOp_o;
    assign memwb_Jump_in=exemem_Jump_o;
    assign memwb_sd_in=exemem_sd_o;
    assign memwb_ld_in=exemem_ld_o;
    assign memwb_bne_in=exemem_bne_o;
    assign memwb_wmask_in=exemem_wmask_o;
        
    //output control signals
    wire memwb_MemWrite_o, memwb_MemRead_o, memwb_ALUSrc_o; 
    wire [1:0] memwb_MemToReg_o; 
    wire [2:0] memwb_ALUOp_o; 
    wire  memwb_sd_o, memwb_ld_o; 
    wire [7:0] memwb_wmask_o;  
    

    //Data signals
    wire [63:0] memwb_in_rdata;
    wire [63:0] memwb_out_ALUresult, memwb_out_rdata;
    
    
    stage_MEMWB memwb(clk, nrst, rdata, exemem_out_ALUresult, memwb_out_ALUresult, memwb_out_rdata,
    memwb_MemWrite_in,memwb_Branch_in, memwb_MemRead_in,memwb_RegWrite_in, memwb_MemToReg_in, memwb_ALUOp_in, memwb_ALUSrc_in,
      memwb_Jump_in, memwb_sd_in, memwb_ld_in, memwb_bne_in, memwb_wmask_in,
    memwb_MemWrite_o,memwb_Branch_o, memwb_MemRead_o,memwb_RegWrite_o,memwb_MemToReg_o, memwb_ALUOp_o,memwb_ALUSrc_o, 
     memwb_Jump_o, memwb_sd_o, memwb_ld_o, memwb_bne_o,memwb_wmask_o,
    memwb_pc_in, memwb_pc_out,
    memwb_inst_in, memwb_inst_out
     );
    /*
    stage_MEMWB(clk, nrst, rdata, ALUResult, ALUResult_out, rdata_out,
    MemWrite, Branch, MemRead, RegWrite, MemToReg, ALUOp, ALUSrc, Jump, sd, ld, bne, wmask,
    MemWrite_o, Branch_o, MemRead_o, RegWrite_o, MemToReg_o, ALUOp_o, ALUSrc_o, Jump_o, sd_o, ld_o, bne_o, wmask_o, pc_in, pc_out, inst_in, inst_out
    

    );
    
    */
    //write back to regfile mux
    wb_mux wbmux(memwb_out_rdata, memwb_out_ALUresult, memwb_pc_out, memwb_inst_out[14:12],memwb_MemToReg_o, write_data_wb_out); //attach next pc and funct3
    //
    
    /*
    wb_mux(read_data, alu_result, pc, funct3, MemToReg, write_data

    );
    */
       
    
    assign addr = exemem_out_ALUresult[31:0]; //output to datamem//write back to regfile mux
    assign ALUop1 = rd_data1_out;
    assign ALUop2 = alu_in2;
    assign ALUres = exemem_out_ALUresult;
    assign RFwrdata = write_data_wb_out;
    
    assign wr_en = exemem_MemWrite_o;
    assign wdata = exemem_out_rd_data2;
    assign wmask = exemem_wmask_o;
    
endmodule
