`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2021 04:59:19 PM
// Design Name: 
// Module Name: controller
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


module controller(instruction, MemWrite, Branch, MemRead, RegWrite, MemToReg, ALUOp, ALUSrc, Jump, sd, ld, bne, wmask

    );
    
    input [31:0] instruction;
    output reg MemWrite, RegWrite, Branch, MemRead, ALUSrc; //1+1+1+1+1
    output reg [1:0] MemToReg; //2
    output reg [2:0] ALUOp; //3
    output reg Jump, sd, ld, bne; //1+1+1+1
    output reg [7:0] wmask; //8
    
    wire [6:0] funct7;
    wire [2:0] funct3;
    wire [6:0] opcode;
    
    assign funct7=instruction[31:25];
    assign funct3=instruction[14:12];
    assign opcode=instruction[6:0];
    
    always@(*)begin
        case (opcode)
        7'b0000011: begin //I-type //ld
                ALUSrc<= 1;
                MemToReg<=2'b01;
                MemWrite<=0;
                Branch<=0;
                RegWrite<=1;       
                Jump<=0;
                wmask<=8'b00000000;
                ALUOp <= 3'b110; //add immediate
                sd<=0;
                ld<=1;
                bne<=0;
        end
        
        
        7'b0010011: begin //register-imm addi
                ALUSrc<= 1;
                MemToReg<=2'b00;
                MemWrite<=0;
                Branch<=0;
                RegWrite<=1;       
                Jump<=0;
                wmask<=8'b00000000;   
                ALUOp <= 3'b110; 
                sd<=0;
                ld<=0;
                bne<=0;
        end
        
        
        7'b0100011: begin //S-type //sd, stores
                ALUSrc<= 1;
                MemToReg<=2'b00;
                MemWrite<=1;
                Branch<=0;
                RegWrite<=0;       
                Jump<=0;
                ALUOp <= 3'b110; //add immediate
                sd<=1;
                ld<=0;
                bne<=0;
                case(funct3)
                3'b011: wmask<=8'b11111111;
                3'b010: wmask<=8'b00001111;
                3'b001: wmask<=8'b00000011;
                default: wmask<=8'b00000000;
                endcase
        end
        
        7'b0110011: begin //R-type //arithmetic r-r
                ALUSrc<= 0;
                MemToReg<=2'b00;
                MemWrite<=0;
                Branch<=0;
                RegWrite<=1;        
                Jump<=0;
                wmask<=8'b00000000;
                sd<=0;
                ld<=0;
                bne<=0;
                case(funct3)
                    3'b000: begin //sub add
                        if(funct7 == 7'b0100000) 
                        ALUOp <= 3'b011; //sub
                        else 
                        ALUOp <= 3'b010; //add
                    end
                    3'b111: //and  
                    ALUOp<=3'b000;
                    3'b110: //or
                    ALUOp<=3'b001;
                    3'b100: //xor  
                    ALUOp<=3'b101;
                    3'b010: //slt 
                    ALUOp<=3'b100;
                    default:
                    ALUOp<=3'b010;
                endcase
        end
        
        7'b1100011: begin //branches b-type
                ALUSrc<= 0;
                MemToReg<=2'b00;
                MemWrite<=0;
                Branch<=1;
                RegWrite<=0;        
                Jump<=0;
                wmask<=8'b00000000;
                sd<=0;
                ld<=0;
                 //beq
                if(funct3 == 3'b001) begin //bne
                 bne<=1; //bne
                 end
                else begin //beq       
                bne<=0; //beq
                end 
        end
        
        7'b1100111: begin //JALR
                ALUSrc<= 1;
                ALUOp <= 4'b1011;
                MemToReg<=2'b10; 
                MemWrite<=0;
                Branch<=0;
                RegWrite<=1;      
                Jump<=1;
                wmask<=8'b00000000;
                sd<=0;
                ld<=0;
                bne<=0;           
        end
        
        7'b1101111: begin //JAL
                ALUSrc<= 0;
                ALUOp <= 4'b1011;
                MemToReg<=2'b10; 
                MemWrite<=0;
                Branch<=1; //set for jump
                RegWrite<=1;       
                Jump<=1;
                wmask<=8'b00000000;
                sd<=0;
                ld<=0;
                bne<=0;   
        end
        
        default: begin
                ALUSrc<= 0;
                MemToReg<=2'b00;
                MemWrite<=0;
                Branch<=0;
                RegWrite<=0;      
                Jump<=0;
                wmask<=8'b00000000;
                sd<=0;
                ld<=0;
                bne<=0;
                end 
        endcase
    end
    
endmodule
