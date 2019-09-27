module PCAdd(PCaddr, PCSrc, Offset, PCNext);
    input [31: 0] PCaddr;
    input PCSrc;
    input [31: 0] Offset; 
    output [31: 0] PCNext;

    assign PCNext = PCaddr + 4 + ((PCSrc == 0) ? 0 : Offset << 2);

endmodule