`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2021 07:29:03 PM
// Design Name: 
// Module Name: alu
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


module alu(ALUOp, in1, in2, zero, ALUresult

    );
    
   input [2:0] ALUOp;
   input [63:0] in1, in2;
   output reg zero;
   output reg [63:0] ALUresult;
   
   
   always@(*)
   begin
   case (ALUOp)
    3'b000: begin//and
    ALUresult<=in1&in2;
    end
    3'b001: begin //OR
    ALUresult<=in1|in2;
    end
    3'b010: begin //add
    ALUresult<=in1+in2;
    end
    3'b011: begin //sub
    ALUresult<=in1-in2;
    end
    3'b100:begin // SLT
				if (in1[63] != in2[63]) begin
					if (in1[63] > in2[63]) begin
						ALUresult <= 1;
					end else begin
						ALUresult <= 0;
					end
				end else begin
					if (in1 < in2)
					begin
						ALUresult <= 1;
					end
					else
					begin
						ALUresult <= 0;
					end
				end
			end
    3'b101: begin //xor
    ALUresult<=in1^in2;
    end
    3'b110: begin //addi
    if (in2[63] ==1'b1) //check if negative imm
    ALUresult<=in1 - (~in2 + 1); //2s complement
    else
    ALUresult<= in1+in2;
    end
    default: begin
        ALUresult<=64'd0;
    end
   endcase
   end
   
   always@(*) begin
    if ((in1-in2)==64'b0)
        zero<=1;
    else 
        zero<=0;   
   end
endmodule
