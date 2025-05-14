module top (
    input clk,
    input reset
);

    // === Program Counter ===
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;

    pc program_counter (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_out(pc_current)
    );

    // === Instruction Memory ===
    wire [31:0] instr;

    instr_mem imem (
        .addr(pc_current),
        .instr(instr)
    );

    // === Instruction Fields ===
    wire [6:0]  op      = instr[6:0];
    wire [4:0]  rd      = instr[11:7];
    wire [2:0]  funct3  = instr[14:12];
    wire [4:0]  rs1     = instr[19:15];
    wire [4:0]  rs2     = instr[24:20];
    wire        funct7b5 = instr[30];
    

    // === Control Unit ===
    wire        reg_write, mem_write, alu_src;
    wire [1:0]  imm_src, result_src;
    wire        pc_src;
    wire [2:0]  alu_control;

    control_unit cu (
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .zero(zero),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .result_src(result_src),
        .pc_src(pc_src),
        .alu_control(alu_control)
    );
    
    // === Immediate Generator ===
    wire [31:0] imm_ext;

    imm_gen immgen (
        .instr_bits(instr[31:7]),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    // === Register File ===
    wire [31:0] rd1, rd2;

    reg_file rf (
        .clk(clk),
        .we3(reg_write),
        .a1(rs1),
        .a2(rs2),
        .a3(rd),
        .wd3(result),
        .rd1(rd1),
        .rd2(rd2)
    );

    // === ALU ===
    wire [31:0] src_b, alu_result;
    wire zero;

    assign src_b = (alu_src) ? imm_ext : rd2;

    alu alu_unit (
        .A(rd1),
        .B(src_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // === Data Memory ===
    wire [31:0] read_data;

    data_memory dmem (
        .clk(clk),
        .addr(alu_result),
        .wd(rd2),
        .we(mem_write),
        .rd(read_data)
    );

    // === Result Mux ===
    wire [31:0] result;

    assign result =
        (result_src == 2'b00) ? alu_result :
        (result_src == 2'b01) ? read_data  :
        (result_src == 2'b10) ? pc_plus4   :
        (result_src == 2'b11) ? imm_ext    : 
        32'b0;

    // === PC Adder: PC + 4 and PC + imm ===
    adder pc_add4 (
        .a(pc_current),
        .b(32'd4),
        .sum(pc_plus4)
    );

    wire [31:0] pc_target;

    adder pc_branch (
        .a(pc_current),
        .b(imm_ext),
        .sum(pc_target)
    );

    assign pc_next = (pc_src) ? pc_target : pc_plus4;

endmodule
