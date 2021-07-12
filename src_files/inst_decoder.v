`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2021 07:35:35 PM
// Design Name: 
// Module Name: inst_decoder
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


module inst_decoder(instruction, rd_reg1, rd_reg2, write_reg

    );
    
    input [31:0] instruction;
    output [4:0] rd_reg1, rd_reg2, write_reg;
    
    assign rd_reg1=instruction[19:15];
    assign rd_reg2=instruction[24:20];
    assign write_reg=instruction[11:7];

endmodule
