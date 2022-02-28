`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.12.2021 12:21:03
// Design Name: 
// Module Name: vga_timing
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


module vga_timing(
    input clk, // note: add width and height as input for dynamic adjustments
    output hsync,
    output vsync,
    output reg [10:0] hcount_reg,
    output reg [9:0] vcount_reg,
    output in_drawing_region
    );
    
    // hcount and vcount are initially 0
    initial begin
        hcount_reg <= 0;
        vcount_reg <= 0;
    end
    
    // On each clock cycle, iterate hcount and vcount correctly
    always @(posedge clk) begin
        hcount_reg <= hcount_reg + 1;
        if (hcount_reg == 11'd1903) begin
            hcount_reg <= 0;
            vcount_reg <= vcount_reg + 1;
            if (vcount_reg == 10'd931) begin
                vcount_reg <= 0;
            end
        end
    end
    
    // Assign hsync and vsync bools based on hcount and vcount
    assign hsync = ~((hcount_reg >= 0) && (hcount_reg <= 151));
    assign vsync = (vcount_reg >= 0) && (vcount_reg <= 2);
    
    // Assign drawing region bool if in the drawing region
    assign in_drawing_region = ((hcount_reg >= 384) && (hcount_reg <= 1823) && (vcount_reg >= 31) && (vcount_reg <= 930));
    
    // Not sure if needed?
    wire pixclk;
    clk_wiz_0 clk_ip (
        // Clock out ports
        .clk_out1(pixclk),     // output clk_out1
        // Clock in ports
        .clk_in1(clk) );       // input clk_in1
    
endmodule
