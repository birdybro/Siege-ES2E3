`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2021 13:42:40
// Design Name: 
// Module Name: vga_sim
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


module vga_sim(

    );
    
    reg clk;
    wire [3:0] pix_r, pix_g, pix_b;
    wire hsync, vsync;
    
    initial begin
        clk = 0;
    end
    
    always begin
        #1 clk = ~clk;
    end
    
    vga_out myVga(clk, pix_r, pix_g, pix_b, hsync, vsync);
    
    
    
endmodule
