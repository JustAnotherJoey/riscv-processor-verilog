`include "riscv_defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joseph Loy 
// 
// Create Date: 11/03/2021 05:58:44 PM
// Design Name: Simple Processor 
// Module Name: instruction_decode
// Project Name: RISCV-CPU
// Target Devices: Arty A7 
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module instruction_fetch(
    input clk,
    input rst,
    input en,
    input jump_target,
    input jump_branch,
    input [31:0] branch_imm_id,
    input [31:0] pc_id,
    input [25:0] instr_id,  // Lower 26 bits of the instruction
    output [31:0] pc
);

endmodule