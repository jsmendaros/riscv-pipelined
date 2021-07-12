`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2021 01:01:02 AM
// Design Name: 
// Module Name: wb_mux
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


module wb_mux(read_data, alu_result, pc, funct3, MemToReg, write_data

    );
    
    input [63:0] read_data, alu_result;
    input [31:0] pc;
    input [2:0] funct3;
    input [1:0] MemToReg;
    output reg [63:0] write_data;
    
    //assign write_data = MemToReg ? alu_result : read_data;
    
    always@(*) begin
    case(MemToReg)
            2'b00: write_data<=alu_result;  
            2'b01: begin //datamem stuff
                case(funct3)
                    3'b011: write_data<=read_data; //ld
                    3'b010: write_data<={{32{read_data[31]}}, read_data[31:0]}; //lw
                    3'b110: write_data<={32'b0, read_data[31:0]}; //lwu
                    3'b001: write_data<={{48{read_data[15]}}, read_data[15:0]}; //lh
                    3'b101: write_data<={48'b0, read_data[15:0]};  //lhu
                    default: write_data<=64'b0;
                endcase
            end            
            2'b10: write_data<=pc+3'd4; //PC+4 jal
            default: write_data<=64'b0;
        endcase   
    end
endmodule
