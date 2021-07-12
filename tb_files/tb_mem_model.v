`timescale 1ns / 1ps
`define CLK_PERIOD 10

module tb_mem_model;

    parameter DATA_DEP = 512;
    parameter ADDR_WID = 29;

    reg     clk;
    reg     [ADDR_WID-1:0]  addr;
    wire    [63:0]          rdata;
    reg     wr_en;
    reg     [63:0]          wdata;
    reg     [7:0]           wmask;

    mem_model #(DATA_DEP,ADDR_WID) UUT(
        .clk(clk),
        .addr(addr),
        .rdata(rdata),
        .wr_en(wr_en),
        .wdata(wdata),
        .wmask(wmask)
    );
    
    always
        #(`CLK_PERIOD/2) clk = ~clk;
        
    initial begin
        clk     = 0;
        addr    = 0;
        wr_en   = 0;
        wdata   = 0;
        wmask   = 9'h1ff;
        
        #(`CLK_PERIOD*10);
        addr    = 9'd0;
        wr_en   = 0;
        
        #`CLK_PERIOD;
        addr    = 9'd1;
        wr_en   = 0;
        
        #`CLK_PERIOD;
        addr    = 9'd2;
        wr_en   = 0;
        
        #`CLK_PERIOD;
        addr    = 9'd3;
        wr_en   = 0;
        
        #`CLK_PERIOD;
        addr    = 9'd1;
        wdata   = 64'h1122334455667788;
        wr_en   = 1;
        
        #`CLK_PERIOD;
        addr    = 9'd2;
        wdata   = 64'h2222222222222222;
        wr_en   = 1;
        
        #`CLK_PERIOD;
        addr    = 9'd3;
        wdata   = 64'haabbccddeeff0011;
        wr_en   = 1;
        
        #`CLK_PERIOD;
        addr    = 9'd0;
        wr_en   = 0;
        
        #`CLK_PERIOD;
        addr    = 9'd1;
        wr_en   = 0;
        
        #`CLK_PERIOD;
        addr    = 9'd2;
        wr_en   = 0;
        
        #`CLK_PERIOD;
        addr    = 9'd3;
        wr_en   = 0;
        
        #`CLK_PERIOD;
        addr    = 9'd2;
        wdata   = 64'h3333333333333333;
        wr_en   = 1;
        wmask   = 8'b10100101;
        
        #`CLK_PERIOD;
        addr    = 9'd3;
        wdata   = 64'h6666666666666666;
        wr_en   = 1;
        wmask   = 8'b00001111;
        
        #`CLK_PERIOD;
        addr    = 9'd2;
        wr_en   = 0;
        
        #`CLK_PERIOD;
        addr    = 9'd3;
        wr_en   = 0;
        
        #(`CLK_PERIOD*10);
        
        
    end

endmodule
