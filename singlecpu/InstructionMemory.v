module InstructionMemory(IAddr,IDataIn,RW,IDataOut);

	input [31:0] IAddr;
	input RW;
	input [31:0] IDataIn;
	output [31:0] IDataOut;
	
	reg [7:0] rom [0:255];
	
	initial begin
		$readmemb ("D:/vivado project/singlecpu3/rom.txt", rom);
	end
	
	assign IDataOut = (RW === 1) ? 0 : {rom[IAddr+3],
										rom[IAddr+2],
										rom[IAddr+1],
										rom[IAddr]};
										
endmodule
