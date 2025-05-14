module instr_mem(
    input [31:0] addr,           // PC'den gelen adres
    output [31:0] instr          // Çıkan komut
);
    reg [31:0] memory [0:63];    // 16 komutluk küçük bir bellek

    // initial begin
    //     // Belleğe örnek komutlar (gerçek opcode'lar değil)
    //     $readmemh("instr_mem.mem", memory); // Belleği dosyadan yükle
    // end

    assign instr = memory[addr[31:2]];  // 4-byte hizalı adresleme
endmodule
