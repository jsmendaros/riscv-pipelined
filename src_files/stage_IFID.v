`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2021 06:43:58 AM
// Design Name: 
// Module Name: stage_IF
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


module stage_IFID(clk, nrst, pc, out_pc, inst_IFID, out_inst

    );
    
    input clk, nrst;
    input [31:0] pc;
    input [31:0] inst_IFID;
    output reg [31:0] out_pc, out_inst;
    always@(posedge clk) begin
    if (!nrst)
        out_pc<=32'd0;
    else begin
        out_pc<=pc;
        out_inst<=inst_IFID;
    
    end
    
    end
endmodule
