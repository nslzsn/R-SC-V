module main_decoder (
    input  [6:0] op,
    output reg   reg_write,
    output reg   mem_write,
    output reg   alu_src,
    output reg [1:0] imm_src,
    output reg [1:0] result_src,
    output reg   branch,
    output reg   jump,
    output reg [1:0] alu_op
);

    always @(*) begin
        case (op)
            7'b0000011: begin // lw
                reg_write   = 1;
                mem_write   = 0;
                alu_src     = 1;
                imm_src     = 2'b00;
                result_src  = 2'b01;
                branch      = 0;
                alu_op      = 2'b00;
                jump        = 0;
            end
            7'b0100011: begin // sw
                reg_write   = 0;
                mem_write   = 1;
                alu_src     = 1;
                imm_src     = 2'b01;
                result_src  = 2'b00; // x yerine 00 konur
                branch      = 0;
                alu_op      = 2'b00;
                jump        = 0;
            end
            7'b0110011: begin // R-type
                reg_write   = 1;
                mem_write   = 0;
                alu_src     = 0;
                imm_src     = 2'b00; // x yerine 00
                result_src  = 2'b00;
                branch      = 0;
                alu_op      = 2'b10;
                jump        = 0;
            end
            7'b1100011: begin // beq
                reg_write   = 0;
                mem_write   = 0;
                alu_src     = 0;
                imm_src     = 2'b10;
                result_src  = 2'b00; // x yerine 00
                branch      = 1;
                alu_op      = 2'b01;
                jump        = 0;
            end
            7'b0010011: begin // I-type ALU
                reg_write   = 1;
                mem_write   = 0;
                alu_src     = 1;
                imm_src     = 2'b00;
                result_src  = 2'b00;
                branch      = 0;
                alu_op      = 2'b10;
                jump        = 0;
            end
            7'b1101111: begin // jal
                reg_write   = 1;
                mem_write   = 0;
                alu_src     = 0;        // x yerine default verildi
                imm_src     = 2'b11;
                result_src  = 2'b10;
                branch      = 0;
                alu_op      = 2'b00;    // x yerine default verildi
                jump        = 1;
            end
            7'b0110111: begin // lui
                reg_write   = 1;
                mem_write   = 0;
                alu_src     = 1'bx;
                imm_src     = 2'b11;   // özel U-type
                result_src  = 2'b11;   // yeni: direkt immediate ver
                branch      = 0;
                alu_op      = 2'b00;
                jump        = 0;
            end
            default: begin
                reg_write   = 0;
                mem_write   = 0;
                alu_src     = 0;
                imm_src     = 2'b00;
                result_src  = 2'b00;
                branch      = 0;
                alu_op      = 2'b00;
                jump        = 0;
            end
        endcase
    end

endmodule
