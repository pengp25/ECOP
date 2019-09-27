module PC(CLK, Reset, PCWre, nextPC, curPC);
    input CLK, Reset, PCWre;
    input [31:0] nextPC;
    output reg [31:0] curPC;

    // Reset 异步置零
    always@(posedge CLK or negedge Reset) begin
        curPC <= Reset == 0 ? 0 : ((PCWre == 1) ? nextPC : curPC);
    end

    initial curPC = 0;

endmodule