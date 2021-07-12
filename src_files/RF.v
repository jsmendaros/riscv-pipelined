`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 01:35:41 AM
// Design Name: 
// Module Name: RF
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


module RF(clk, nrst,  rd_reg1, rd_reg2, write_reg, write_data, rd_data1, rd_data2, RegWrite

    );
    
    input RegWrite, clk, nrst;
    input [4:0]  write_reg, rd_reg1, rd_reg2;
    //[31:25] - funct7
    //[24:20] - rs2
    //19:15 - rs1
    //14:12 - funct3
    //11:7 - rd
    //6:0 opcode
    input [63:0] write_data;
    output [63:0] rd_data1, rd_data2;
    
    reg [63:0] reg_array [31:0]; //switch indeces
    always@(posedge clk)
    begin
        if (!nrst) begin
        reg_array[0]=64'd0;
        reg_array[1]=64'd0;
        reg_array[2]=64'd0;
        reg_array[3]=64'd0;
        reg_array[4]=64'd0;
        reg_array[5]=64'd0;
        reg_array[6]=64'd0;
        reg_array[7]=64'd0;
        reg_array[8]=64'd0;
        reg_array[9]=64'd0;
        reg_array[10]=64'd0;
        reg_array[11]=64'd0;
        reg_array[12]=64'd0;
        reg_array[13]=64'd0;
        reg_array[14]=64'd0;
        reg_array[15]=64'd0;
        reg_array[16]=64'd0;
        reg_array[17]=64'd0;
        reg_array[18]=64'd0;
        reg_array[19]=64'd0;
        reg_array[20]=64'd0;
        reg_array[21]=64'd0;
        reg_array[22]=64'd0;
        reg_array[23]=64'd0;
        reg_array[24]=64'd0;
        reg_array[25]=64'd0;
        reg_array[26]=64'd0;
        reg_array[27]=64'd0;
        reg_array[28]=64'd0;
        reg_array[29]=64'd0;
        reg_array[30]=64'd0;
        reg_array[31]=64'd0;
        end
        else  //add != reg=0
        begin
        if (RegWrite)
            if (write_reg == 5'b00000)
            reg_array[write_reg]<=64'd0;
            else
            reg_array[write_reg]<=write_data;
            
        else reg_array[write_reg]<=reg_array[write_reg];
        end
    end
    
    assign rd_data1=reg_array[rd_reg1];
    assign rd_data2=reg_array[rd_reg2];
    
endmodule
