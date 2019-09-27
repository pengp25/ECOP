module ControlUnit(opcode,sign,zero,ExtSel,PCWre,PCSrc,InsMemRW,mRD,mWR,RegWre,RegDst,ALUSrcA,ALUSrcB,,ALUOp,DBDataSrc);
	input [5:0] opcode;
	input zero,sign;
	output Extsel, PCWre, InsMemRW, mRD, mWR, RegWre, RegDst, ALUSrcA, ALUSrcB, DBDataSrc;
	output [1:0] PCSrc;
	output [2:0] ALUOp;
	
	assign Extsel = (opcode[5:3] == 3'b010 ? 0 : 1);
    assign PCWre = (opcode == 6'b111111 ? 0 : 1);
    assign InsMemRW = 0;
    assign mRD = (opcode == 6'b100111 ? 1 : 0);
    assign mWR = (opcode == 6'b100110 ? 1 : 0);
    assign RegWre = (opcode == 6'b100111 || opcode[5] == 0) ? 1 : 0;
    assign RegDst = ((opcode[2:0] == 3'b000 || opcode[2:0] == 3'b001 || opcode[2:0] == 3'b011) && opcode != 6'b010000) ? 1 : 0;
    assign ALUSrcA = (opcode == 6'b011000 ? 1 : 0);
    assign ALUSrcB = (opcode == 6'b010000 || opcode == 6'b010010 || opcode == 6'b000010 || opcode[2]) ? 1 : 0;
    assign DBDataSrc = (opcode == 6'b100111) ? 1 : 0;
    always@(opcode or zero) begin
        case(opcode[5:3])
            3'b110: begin
                        if (opcode == 6'b110001) begin 
                            if (zero == 0) PcSrc = 2'b00;
                            else PcSrc = 2'b01;
                        end
                        else if (opcode == 6'b110000) begin
                            if (zero == 0) PcSrc = 2'b01;
                            else PcSrc = 2'b00;
                        end
                        else if (opcode == 6'b110010) begin
                            if (sign == 1) PcSrc = 2'b01;
                            else PcSrc = 2'b00;
                        end
                    end
            3'b111: PcSrc = 2'b10;
            default: PcSrc = 2'b00;
        endcase
        case(opcode)
            6'b000000: ALUop = 3'b000; //add
            6'b000001: ALUop = 3'b001; //sub
            6'b000010: ALUop = 3'b000; //addiu
            6'b010000: ALUop = 3'b100; //andi
            6'b010001: ALUop = 3'b100; //and
            6'b010010: ALUop = 3'b011; //ori
            6'b010011: ALUop = 3'b011; //or
            6'b011000: ALUop = 3'b010; //sll
            6'b011100: ALUop = 3'b110; //slti
        endcase
        if (opcode[5:3] == 3'b110)ALUop = 3'b001; //分支指令，用到减
        if (opcode[5:3] == 3'b100)ALUop = 3'b000; //lw和sw，用到加
    end
endmodule
