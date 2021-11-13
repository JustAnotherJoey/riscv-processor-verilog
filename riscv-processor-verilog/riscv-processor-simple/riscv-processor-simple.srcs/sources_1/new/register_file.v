`include "riscv_defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Loy 
// 
// Create Date: 11/03/2021 06:00:51 PM
// Design Name: 
// Module Name: register_file
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


module register_file(
    input clk,
    input en,
    input [31:0] reg_write_data,
    input [4:0] reg_write_addr,
    input reg_we,
    input [4:0] rs_addr,
    input [4:0] rt_addr,

    output wire [31:0] rs_data,
    output wire [31:0] rt_data
);

endmodule
