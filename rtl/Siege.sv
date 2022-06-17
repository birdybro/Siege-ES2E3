
module Siege
(
    input         clk,
    input         BTNU,
    input         BTND,
    input         BTNL,
    input         BTNR,
    input         BTNC,
    input         RST,
    output [ 3:0] pix_r,
    output [ 3:0] pix_g,
    output [ 3:0] pix_b,
    output        hsync,
    output        vsync,
    output [ 6:0] sg,
    output [ 7:0] an,
    output [15:0] LED,
);

vga_out_signed vga_out_signed
(
    .clk(clk),
    .BTNU(BTNU),
    .BTND(BTND),
    .BTNL(BTNL),
    .BTNR(BTNR),
    .BTNC(BTNC),
    .RST(RST),
    .pix_r(pix_r),
    .pix_g(pix_g),
    .pix_b(pix_b),
    .hsync(hsync),
    .vsync(vsync),
    .sg(sg),
    .an(an),
    .LED(LED)
);

// vga_out vga_out
// (
//     .clk(clk),
//     .BTNU(BTNU),
//     .BTND(BTND),
//     .BTNL(BTNL),
//     .BTNR(BTNR),
//     .BTNC(BTNC),
//     .pix_r(pix_r),
//     .pix_g(pix_g),
//     .pix_b(pix_b),
//     .hsync(hsync),
//     .vsync(vsync),
//     .sg(sg),
//     .an(an),
//     .LED(LED)
// );

endmodule