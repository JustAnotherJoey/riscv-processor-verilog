`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2021 05:58:44 PM
// Design Name: 
// Module Name: instruction_decode
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


module riscv_cpu(
    input clk,
    input rst,
    input en,

    output wire [3:0] mem_write_en,
    output wire mem_read_en,
    output wire [31:0] mem_addr,
    output wire [31:0] mem_write_data,
    input [31:0] mem_read_data,
    output wire [31:0] pc,
    input [31:0] instr
);
    
endmodule