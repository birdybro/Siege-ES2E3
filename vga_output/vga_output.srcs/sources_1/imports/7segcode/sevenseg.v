`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Felix Bowyer
// 
// Create Date: 10/08/2021 02:26:48 PM
// Design Name: 
// Module Name: sevenseg
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


module sevenseg(
    input [3:0] sw,
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g
    );
    
    assign a = (sw[0]&!sw[1]&!sw[2]&!sw[3])|(!sw[0]&!sw[1]&sw[2]&!sw[3])|(sw[0]&sw[1]&!sw[2]&sw[3])|(sw[0]&!sw[1]&sw[2]&sw[3]);
    assign b = (sw[0]&!sw[1]&sw[2]&!sw[3])|(!sw[0]&sw[1]&sw[2]&!sw[3])|(sw[0]&sw[1]&!sw[2]&sw[3])|(!sw[0]&!sw[1]&sw[2]&sw[3])|(sw[0]&sw[1]&sw[2]&sw[3]);
    assign c = (!sw[0]&sw[1]&!sw[2]&!sw[3])|(!sw[0]&!sw[1]&sw[2]&sw[3])|(!sw[0]&sw[1]&sw[2]&sw[3])|(sw[0]&sw[1]&sw[2]&sw[3]);
    assign d = (sw[0]&!sw[1]&!sw[2]&!sw[3])|(!sw[0]&!sw[1]&sw[2]&!sw[3])|(sw[0]&sw[1]&sw[2]&!sw[3])|(sw[0]&!sw[1]&!sw[2]&sw[3])|(!sw[0]&sw[1]&!sw[2]&sw[3])|(sw[0]&sw[1]&sw[2]&sw[3]);
    assign e = (sw[0]&!sw[1]&!sw[2]&!sw[3])|(sw[0]&sw[1]&!sw[2]&!sw[3])|(!sw[0]&!sw[1]&sw[2]&!sw[3])|(sw[0]&!sw[1]&sw[2]&!sw[3])|(sw[0]&sw[1]&sw[2]&!sw[3])|(sw[0]&!sw[1]&!sw[2]&sw[3]);
    assign f = (sw[0]&!sw[1]&!sw[2]&!sw[3])|(!sw[0]&sw[1]&!sw[2]&!sw[3])|(sw[0]&sw[1]&!sw[2]&!sw[3])|(sw[0]&sw[1]&sw[2]&!sw[3])|(sw[0]&!sw[1]&sw[2]&sw[3]);
    assign g = (!sw[0]&!sw[1]&!sw[2]&!sw[3])|(sw[0]&!sw[1]&!sw[2]&!sw[3])|(sw[0]&sw[1]&sw[2]&!sw[3])|(!sw[0]&!sw[1]&sw[2]&sw[3]);
    
    
endmodule
