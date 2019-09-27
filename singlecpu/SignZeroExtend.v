module SignZeroExtend(InData, ExtSel, OutData);
    input [15: 0] InData;
    input ExtSel;
    output reg [31: 0] OutData;

    always @(InData or ExtSel) begin
        if (ExtSel == 0'b0) begin
            //  Extend zero.
            OutData = {8'h00000000, InData[15: 0]};
        end else begin
            //  Extend signed bit (InData[15])
            OutData = {{16{InData[15]}}, InData[15: 0]};
        end 
    end

    initial OutData = 0;

endmodule