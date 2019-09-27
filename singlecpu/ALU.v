module ALU(ALUOp,regA,regB,zero,result);
	input [2:0] ALUOp;
	input [31:0] regA;
	input [31:0] regB;
	output zero;
	output [31:0] result;
	
	initial begin
		result=0;
	end
	
	//zero is 1 if result is 0
	assign zero = (result==0) ? 1 : 0;
	
	always @(ALUOp or regA or regB) begin
		case(ALUOp)
			//加
			3'b000: result = regA + regB;
			
			//减
			3'b001: result = regA - regB;
			
			//左移
			
			3'b010: result = regB << regA;
			
			//或
			3'b011: result = regA | regB;
			
			//与
			3'b100：result = regA & regB;
			
			//比较不带符号
			3'b101: result = (regA < regB) ? 1:0;
			
			//比较带符号
			3'b110: result = (((regA < regB) & (regA[31] == regB[31])) | ((regA[31] == 1 & regB[31]==0))) ? 1 : 0;
			
			//异或
			3'b111: result = regA ^ regB;
			
			default: begin
                result = 8'h00000000;
                $display("no match");
            end
		endcase
	end
endmodule