module control_unit (
    input  [6:0] op,
    input  [2:0] funct3,
    input        funct7b5,
    input        zero,


    output pc_src,
    output [1:0] result_src,
    output [2:0] alu_control,
    output mem_write,
    output alu_src,
    output [1:0] imm_src,
    output reg_write
);

    wire branch;
    wire jump;
    wire [1:0] alu_op;

    // Main Decoder instance
    main_decoder md (
        .op(op),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    // ALU Decoder instance
    alu_decoder ad (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .alu_control(alu_control)
    );

    assign pc_src = (branch & zero) | jump;


endmodule
