`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/04 18:03:44
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
        input zero,
        input sign,
        input CLK,
        input RST,         
        input [5:0] op,     
        output reg PCWre, 
        output reg ALUSrcA,     
        output reg ALUSrcB,      
        output reg DBDataSrc, 
        output reg RegWre, 
        output reg WrRegDSrc, // new signal
        output reg InsMemRW, 
        output reg mRD,         
        output reg mWR, 
        output reg IRWre,  // new signal     
        output reg ExtSel,   
        output reg [1:0] PCSrc,  
        output reg [1:0] RegDst,  // extend
        output reg [2:0] ALUOp,    // modified 
        output reg [2:0] status  
    );
    
	parameter ADD  = 6'b000000; /*add*/
	parameter ADDIU  = 6'b000010; /*addiu*/
	parameter SUB  = 6'b000001;/*sub*/
	parameter ORI  = 6'b010010;/*ori*/
	parameter XORI  = 6'b010011;/*xori*/
	parameter AND  = 6'b010000;/*and*/
	parameter ANDI  = 6'b010001;/*andi*/
	parameter SLL  = 6'b011000;/*sll*/
	parameter SLT  = 6'b100111;/*slt*/
	parameter SLTI  = 6'b100110;/*slti*/
	parameter BEQ  = 6'b110100;/*beq*/
	parameter BNE  = 6'b110101;/*bne*/
	parameter BLTZ  = 6'b110110;/*bltz*/
	parameter JAL  = 6'b111010;/*jal*/
	parameter J  = 6'b111000;/*j*/
	parameter JR  = 6'b111001;/*jr*/
	parameter SW  = 6'b110000;/*sw*/
	parameter LW  = 6'b110001;/*lw*/
	parameter HALT  = 6'b111111;/*halt*/

    
    parameter sIF = 3'b000;
    parameter sID = 3'b001;
    parameter sEXE= 3'b010;
    parameter sMEM= 3'b100;
    parameter sWB = 3'b011;
    initial begin
        InsMemRW = 1;
        PCWre = 1;
        mRD = 0;
        mWR = 0;
        DBDataSrc = 0;
        status = 3'b000;
    end
    
    always@(negedge CLK or negedge RST) begin
        if (RST == 0) begin
            status <= 3'b000;
        end
        else begin
            case (status) 
                sIF: status <= sID;
                sID: begin
                        case (op)
                            J, JR, HALT: status <= sIF;
                            JAL: status <= sWB;
                            default: status <= sEXE;
                        endcase
                end
                sEXE: begin
                        case (op)
                            BEQ, BLTZ: status <= sIF;
                            SW, LW: status <= sMEM;
                            default: status <= sWB;
                        endcase
                end
                sMEM: begin
                        case (op)
                            SW: status <= sIF;
                            default: status <= sWB;
                        endcase
                end
                sWB: status <= sIF;
                default: status <= sIF;           
            endcase
        end
    end
    
    always@(op or zero or sign or status) 
    begin
        InsMemRW = 1;  
        PCWre = (op != HALT && status == sIF) ? 1 : 0;   //halt
        ALUSrcA = (op == SLL) ? 1 : 0;
        ALUSrcB = (op == ADDIU || op == ANDI || op == ORI || op == XORI || op == SLTI || op == LW || op == SW) ? 1 : 0;
        DBDataSrc = (op == LW) ? 1 : 0;
        RegWre = (status != sWB || op == BEQ || op == BNE || op == BLTZ || op == J || op == SW || op == JR || op == HALT) ? 0 : 1;
        WrRegDSrc = (op == JAL) ? 0 : 1;
        
        mRD = (status == sMEM && op == LW) ? 1 : 0;
        mWR = (status == sMEM && op == SW) ? 1 : 0;     //sw
        IRWre = (status == sID) ? 1 : 0;
        ExtSel = (op == ORI || op == XORI || op == ANDI) ? 0 : 1;
        
        case (op) 
            J, JAL: PCSrc = 2'b11;
            JR: PCSrc = 2'b10;
            BEQ: PCSrc = (zero == 1) ? 2'b01 : 2'b00;
			BNE: PCSrc = (zero == 0) ? 2'b01 : 2'b00;
            BLTZ: PCSrc = (sign == 1 && zero == 0) ? 2'b01: 2'b00;
            default: PCSrc = 2'b00;
        endcase
        
        case (op)
            JAL: RegDst = 2'b00;
            ADDIU, ANDI, ORI, XORI, SLTI, LW: RegDst = 2'b01;
            default: RegDst = 2'b10;
        endcase
        
        case (op) 
            ADD, ADDIU, SW, LW: 
                    ALUOp = 3'b000;
            SUB, BEQ, BNE, BLTZ: 
                    ALUOp = 3'b001;
            SLT, SLTI:
                    ALUOp = 3'b110;
            SLL:
                    ALUOp = 3'b010;
            ORI:
                    ALUOp = 3'b011;
            AND, ANDI:
                    ALUOp = 3'b100;
			XORI:
					ALUOp = 3'b111;
            default:
                    ALUOp = 3'b000;         
        endcase
    end
endmodule
