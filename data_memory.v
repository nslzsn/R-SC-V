module data_memory(
    input clk,
    input we,                    // write enable
    input [31:0] addr,           // adres (ALU sonucu)
    input [31:0] wd,             // write data
    output [31:0] rd             // read data
);

    reg [31:0] memory [0:63];    // 64 kelimelik (256 byte) bellek

    always @(posedge clk) begin
        if (we)
            memory[addr[31:2]] <= wd;   // 4-byte hizalı yazma
    end

    assign rd = memory[addr[31:2]];     // her zaman okuma

endmodule
