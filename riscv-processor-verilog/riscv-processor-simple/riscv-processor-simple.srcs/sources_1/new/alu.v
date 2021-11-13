`include "riscv_defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joseph Loy 
// 
// Create Date: 11/03/2021 05:58:44 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input [9:0] alu_opcode,
    input [31:0] alu_op_x,
    input [31:0] alu_op_y,
    output reg [31:0] alu_result,
    output alu_op_y_zero,
    output wire alu_overflow
);
    
    //******************************************************************************
// Shift operation: ">>>" will perform an arithmetic shift, but the operand
// must be reg signed, also useful for signed vs. unsigned comparison.
//******************************************************************************
    wire signed [31:0] alu_op_x_signed = alu_op_x;
    wire signed [31:0] alu_op_y_signed = alu_op_y;

//******************************************************************************
// ALU datapath
//******************************************************************************

    always @* begin
        case (alu_opcode)
            // PERFORM ALU OPERATIONS DEFINED ABOVE
            `FUNC_ADDU:  alu_result = alu_op_x + alu_op_y;
            `FUNC_AND:   alu_result = alu_op_x_signed & alu_op_y_signed;
            `FUNC_XOR: alu_result = alu_op_x_signed ^ alu_op_y_signed;
            `FUNC_OR:    alu_result = alu_op_x_signed | alu_op_y_signed;
            `FUNC_NOR: alu_result = alu_op_x_signed ~| alu_op_y_signed;
            `FUNC_SUBU:  alu_result = alu_op_x - alu_op_y;
            `FUNC_SLTU:  alu_result = alu_op_x < alu_op_y;
            `FUNC_SLT:   alu_result = alu_op_x_signed < alu_op_y_signed;
            `FUNC_SRL:   alu_result = alu_op_y >> alu_op_x[4:0]; // shift operations are Y >> X
            `FUNC_SRA: alu_result = alu_op_y_signed >>> alu_op_x_signed[4:0];
            `FUNC_SLL:   alu_result = alu_op_y << alu_op_x[4:0];
            `FUNC_PASSX: alu_result = alu_op_x;
            `FUNC_PASSY: alu_result = alu_op_y;
            `FUNC_ADD:   alu_result = alu_op_x_signed + alu_op_y_signed;            
            `FUNC_SUB:   alu_result = alu_op_x_signed - alu_op_y_signed;
            `FUNC_MUL: alu_result = alu_op_x_signed * alu_op_y_signed;
            default:    alu_result = 32'hxxxxxxxx;   // undefined
        endcase
    end

    wire alu_neg = alu_result[31];
    wire x_neg = alu_op_x[31];
    wire y_neg = alu_op_y[31];

    wire add_check = alu_opcode == `ALU_ADD;
    wire sub_check = alu_opcode == `ALU_SUB;

    wire add_pos_over = &{~x_neg, ~y_neg, alu_neg}; // postive + positive = negative
    wire add_neg_over = &{x_neg, y_neg, ~alu_neg}; // negative + negative = positive
    wire sub_pos_over = &{~x_neg, y_neg, alu_neg}; // positive - negative = negative
    wire sub_neg_over = &{x_neg, ~y_neg, ~alu_neg}; // negative - positive = positive

    assign alu_op_y_zero = ~|{alu_op_y};

    assign alu_overflow = |{add_check & (add_pos_over | add_neg_over),
                            sub_check & (sub_pos_over | sub_neg_over)};

endmodule