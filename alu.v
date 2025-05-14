module alu (
    input [2:0] alu_control,     // ALU işlemi seçimi
    input [31:0] A, B,           // Giriş operandları
    output reg [31:0] result,    // Çıkış sonucu
    output zero                  // Sonuç sıfır mı?
);

    assign zero = (result == 32'd0);  // ← Şuradaki 'm' hatalıydı, silindi

    always @(*) begin
        case (alu_control)
            3'b000: result = A & B;                         // AND
            3'b001: result = A | B;                         // OR
            3'b010: result = A + B;                         // ADD
            3'b110: result = A - B;                         // SUB
            3'b111: result = (A < B) ? 32'd1 : 32'd0; 
            3'b100: result = A << B[4:0];   //  sll işlemi      // SLT
            default: result = 32'd0;
        endcase
    end

endmodule
