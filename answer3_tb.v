`timescale 1ns/1ps

module answer3_tb;

    reg clk = 0;
    reg reset = 1;

    top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock üretimi
    always #5 clk = ~clk;

    initial begin
        // === instr_mem belleğini buradan doldur ===
        uut.imem.memory[0] = 32'h00045b37;  // lui x11, 0x00045 → x11 = 0x00045000
        uut.imem.memory[1] = 32'h0012b337;  // lui x6,  0x00123 → x6  = 0x00123000
        uut.imem.memory[2] = 32'h000ab3b7;  // lui x7,  0x000AB → x7  = 0x000AB000
        uut.imem.memory[3] = 32'h00000013;  // nop (addi x0, x0, 0)

        $dumpfile("answer3_tb.vcd");
        $dumpvars(0, answer3_tb);

        #10 reset = 0;

        // Programın çalışmasına zaman tanı
        #200;

        $finish;
    end

endmodule
