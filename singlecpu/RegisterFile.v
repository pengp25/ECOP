module RegisterFile(CLK,RegWre,ReadReg1,ReadReg2,WriteReg,WriteData,ReadData1,ReadData2);
	input CLK,RegWre;
	input [4:0] ReadReg1,ReadReg2,WriteReg;
	input [31:0] WriteData;
	output [31:0] ReadData1,ReadData2;
	
	reg [31:0] register [0:31];
	
	assign ReadData1 = (ReadReg1 === 0) ? 0 : register[ReadReg1];
	assign ReadData2 = (ReadReg2 === 0) ? 0 : register[ReadReg2];
	
	
	always(@posedge CLK) begin
		if((WriteReg != 0) && (RegWre == 1))
		{
			register[WriteReg] <= WriteData;
		}
		
	end
	
	integer i;
	initial begin
		for(int i=0;i<32;i++)
		{
		register[i]=0;
		}
	end
	
endmodule