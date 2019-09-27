`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/04 17:59:01
// Design Name: 
// Module Name: RegisterFile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegisterFile(
       input CLK,               //clock
       input RegWre,
       input [4:0] rs,
       input [4:0] rt,
       input [4:0] rd,
       input [1:0] RegDst,
       input [31:0] WriteData, 
       output reg[31:0] ReadData1,
       output reg[31:0] ReadData2
    );
    
    initial begin
        ReadData1 <= 0;
        ReadData2 <= 0;
    end

    reg [31:0] regFile[0:31];
   
    integer i;
    initial begin
        for (i = 0; i < 32; i = i+ 1) regFile[i] <= 0;  
    end
    
    always@(rs or rt)  begin
        ReadData1 = regFile[rs];
        ReadData2 = regFile[rt];
    end
     
    reg [4:0] WriteReg; 
    always@(RegDst or rt or rd) begin
        case (RegDst)
            2'b00: WriteReg = 31;
            2'b01: WriteReg = rt;
            default: WriteReg = rd;
        endcase
    end
    always@(posedge CLK) begin
        if(RegWre && WriteReg)begin
                regFile[WriteReg] <= WriteData;
            end
    end
endmodule
