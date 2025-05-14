
module imm_gen(
    input clk,
    input [24:0] instr_bits,     // instr[31:7]
    input [1:0] imm_src,         // 00: I-type, 01: S-type, 10: B-type
    output reg [31:0] imm_ext
);

    always @(*) begin
        case (imm_src)
            2'b00: begin // I-type (bits [24:13])
                imm_ext = {{20{instr_bits[24]}}, instr_bits[24:13]};
            end
            2'b01: begin // S-type (bits [24:18] & [4:0])
                imm_ext = {{20{instr_bits[24]}}, instr_bits[24:18], instr_bits[4:0]};
            end
            2'b10: begin // B-type (bits [24], [0], [23:18], [4:1], 0)
                imm_ext = {{19{instr_bits[24]}}, instr_bits[0], instr_bits[23:18], instr_bits[4:1], 1'b0};
            end
            2'b11: begin // J-type (jal)
                // J-type: {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}
                imm_ext = {{11{instr_bits[24]}},   // sign-extend (instr[31])
                  instr_bits[12:5],       // instr[19:12]
                  instr_bits[13],         // instr[20]
                  instr_bits[23:14],      // instr[30:21]
                  1'b0};
            end
            2'b11: imm_ext = {instr_bits[24:5], 12'b0}; // U-type, instr[31:12] << 12
            default: begin
                imm_ext = 32'd0;
            end
        endcase
    end

endmodule
