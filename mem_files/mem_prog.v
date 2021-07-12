/* Program memory model
 * - Asynchronous read
 * - Replace $readmemh() argument with your own memory initialization if needed
 * -- Argument points to a text file containing hex values of a word per line
 * -- Default file: progmem.mem
 * -- For Vivado, use Add Sources -> Simulation Sources -> Add File to include the memory initialization
 */

`timescale 1ns / 1ps

module mem_prog
    #(  parameter DATA_DEP = 512, // Depth of memory (in words)
        parameter ADDR_WID = 30   // Word address width (32-2)
    ) 
    (   input   [ADDR_WID-1:0]  addr, // doubleword address
        output  [31:0]          rdata
    );
    
    reg [31:0] memdata [0:DATA_DEP-1];
    
    /* Read path */
    assign rdata = memdata[addr];
    
    /* Initialization */
    initial begin
        $readmemh("progmem.mem",memdata);
    end
        
endmodule
