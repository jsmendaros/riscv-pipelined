`timescale 1ns / 1ps
`define CLK_PERIOD 10

module tb_mem_prog;

    parameter DATA_DEP = 512;
    parameter ADDR_WID = 30;

    reg     [ADDR_WID-1:0]  addr;
    wire    [31:0]          rdata;

    mem_prog #(DATA_DEP,ADDR_WID) UUT(
        .addr(addr),
        .rdata(rdata)
    );
    
        
    initial begin
        addr    = 0;
        
        #(`CLK_PERIOD*10);
        addr    = 32'd0;
        
        #`CLK_PERIOD;
        addr    = 32'd1;
        
        #`CLK_PERIOD;
        addr    = 32'd2;
        
        #`CLK_PERIOD;
        addr    = 32'd3;
               
        #(`CLK_PERIOD*10);
        
        
    end

endmodule
