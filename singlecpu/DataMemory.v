module DataMemory(CLK,mRD,mWR,DAddr,DataIn,DataOut);
	input CLK,mRD,mWR;
	input [31:0] DAddr;
	input [31:0] DataIn;
	output [31:0] DataOut;
	
	reg[7:0] rom [0:255];
	
	//read memory at byte DAddr,DAddr+1,DAddr+2,DAddr+3
	assign DataOut = (mRD == 0) ? 0'h00000000 : { rom[DAddr + 3], rom[DAddr + 2], rom[DAddr + 1], rom[DAddr]};
	
	always @(negedge CLK) begin
		if(mWR == 1 && DAddr >= 1 && DAddr <= 255) begin
		// Write 4 byte (a word) to memory.
        // Only support sw instruction.
        // Don't care the case of instruction sb and sh.

        // little endian
			rom[DAddr + 3] <= DataIn[31:24];
			rom[DAddr + 2] <= DataIn[23:16];
			rom[Daddr + 1] <= DataIn[15:8];
			rom[DAddr] <= DataIn[7:0];
		end
	end
	
endmodule