module alu_decoder (
    input  [1:0] alu_op,
    input  [2:0] funct3,
    input        funct7b5,
    output reg [2:0] alu_control
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 3'b010;  // lw, sw → add
            2'b01: alu_control  = 3'b110;  // beq → subtract
            2'b10: begin                 // R-type veya I-type
                case (funct3)
                    3'b000: alu_control  = (funct7b5 == 1'b1) ? 3'b110 : 3'b010; // sub : add
                    3'b010: alu_control  = 3'b111; // slt
                    3'b110: alu_control= 3'b001; // or
                    3'b111: alu_control  = 3'b000; // and
                    3'b001: alu_control = 3'b100; // sll bu soru icin eklendi
                    default: alu_control = 3'bxxx;
                endcase
            end
            default: alu_control  = 3'bxxx;
        endcase
    end

endmodule
