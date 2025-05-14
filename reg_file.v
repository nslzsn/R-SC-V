module reg_file (
    input clk,
    input we3,
    input [4:0] a1, a2, a3,
    input [31:0] wd3,
    output [31:0] rd1, rd2
);

    reg [31:0] regs [0:31];

    // Read ports
    assign rd1 = (a1 == 0) ? 32'b0 : regs[a1];
    assign rd2 = (a2 == 0) ? 32'b0 : regs[a2];

    // Write port
    always @(posedge clk) begin
        if (we3 && (a3 != 0))
            regs[a3] <= wd3;
    end

endmodule
