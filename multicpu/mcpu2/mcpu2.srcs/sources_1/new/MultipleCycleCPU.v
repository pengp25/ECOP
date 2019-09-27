`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/04 18:04:54
// Design Name: 
// Module Name: MultipleCycleCPU
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


module MultipleCycleCPU(
        input CLK,
        input RST,
        output [31:0] curPC,
        output [31:0] nextPC,
        output [31:0] instruction,
        output [31:0] DB,
        output [31:0] ALUResult,

        output [31:0] ADR_out,
        output [31:0] BDR_out,
           
        output zero,
        output sign,   
        output PCWre, 
        output ALUSrcA,     
        output ALUSrcB,      
        output DBDataSrc, 
        output RegWre, 
        output WrRegDSrc, // new signal
        output InsMemRW, 
        output mRD,         
        output mWR, 
        output IRWre,  // new signal     
        output ExtSel,   
        output [1:0] PCSrc,  
        output [1:0] RegDst,  // extend
        output [2:0] ALUOp,    // modified 
        output [2:0] status  
    );

    wire [5:0] op;
    wire [4:0] rs, rt, rd, sa;
    wire [15:0] immediate;
    wire [31:0] extendImmediate;
    wire [25:0] addr;
    

    assign op = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign sa = instruction[5:0];
    assign immediate = instruction[15:0];
    assign addr = instruction[25:0];
    
    SignZeroExtend SignZeroExtend(.immediate(immediate),
                                  .ExtSel(ExtSel),
                                  .extendImmediate(extendImmediate));
    
/*
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
*/
    wire [31:0] ReadData1, ReadData2, PC4, IDataOut,ALUoutDR_out, DataOut;
    RegisterFile RegisterFile(.CLK(CLK),
                        .RegWre(RegWre),
                        .rs(rs),
                        .rt(rt),
                        .rd(rd),
                        .RegDst(RegDst),
                        .WriteData(WrRegDSrc ? DB : PC4),
                        .ReadData1(ReadData1),
                        .ReadData2(ReadData2));
                        
    PC PC(.CLK(CLK),
          .Reset(RST),
          .PCWre(PCWre),
          .PCSrc(PCSrc),
          .immediate(extendImmediate),
          .addr(addr),
          .curPC(curPC),
          .PC4(PC4),
          .nextPC(nextPC),
          .rs_val(ReadData1));     
          
          
    InsMEM InsMEM(.IAddr(curPC), 
          .RW(InsMemRW), 
          .IDataOut(IDataOut));    
/*
module IR(
        input CLK,
        input IRWre,
        input [31:0] instruction,
        output reg[31:0] out
    );
*/      
    IR IR(.CLK(CLK),
          .IRWre(IRWre),
          .instruction(IDataOut),
          .out(instruction));
    
    DR ADR(.CLK(CLK), 
           .data(ReadData1),
           .out(ADR_out));
    DR BDR(.CLK(CLK), 
                  .data(ReadData2),
                  .out(BDR_out));

    ALU ALU(.ALUOp(ALUOp),
            .A(ALUSrcA ? sa : ADR_out),
            .B(ALUSrcB ? extendImmediate: BDR_out),
            .result(ALUResult),
            .zero(zero),
            .sign(sign));
            
    DR ALUoutDR(.CLK(CLK),
        .data(ALUResult),
        .out(ALUoutDR_out));

    ControlUnit ControlUnit(.zero(zero),
                            .sign(sign),
                            .CLK(CLK),
                            .RST(RST),
                            .op(op),
                            .PCWre(PCWre),
                            .ALUSrcA(ALUSrcA),
                            .ALUSrcB(ALUSrcB),   
                            .DBDataSrc(DBDataSrc),
                            .RegWre(RegWre),
                            .WrRegDSrc(WrRegDSrc),
                            .InsMemRW(InsMemRW),        
                            .mRD(mRD),
                            .mWR(mWR),
                            .IRWre(IRWre),
                            .ExtSel(ExtSel),
                            .PCSrc(PCSrc),
                            .RegDst(RegDst),
                            .ALUOp(ALUOp),
                            .status(status)
                            );

    DataMEM DataMEM(.RD(mRD),
                    .WR(mWR),
                    .CLK(CLK),
                    .DAddr(ALUoutDR_out),
                    .DataIn(BDR_out),
                    .DataOut(DataOut));
    DR DBDR(.CLK(CLK),
            .data(DBDataSrc ? DataOut : ALUResult),
            .out(DB));
     
endmodule
