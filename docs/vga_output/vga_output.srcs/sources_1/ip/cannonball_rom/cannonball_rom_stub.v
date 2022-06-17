// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Fri Dec 10 08:14:33 2021
// Host        : F211-32 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {C:/Users/u2012758/OneDrive - University of
//               Warwick/Work/es2e3/coursework/vga_output/vga_output.srcs/sources_1/ip/cannonball_rom/cannonball_rom_stub.v}
// Design      : cannonball_rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_3,Vivado 2019.1" *)
module cannonball_rom(clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[10:0],douta[3:0]" */;
  input clka;
  input ena;
  input [10:0]addra;
  output [3:0]douta;
endmodule
