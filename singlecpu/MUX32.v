module MUX32(Sel, Ina, Inb, Out);
    input Sel;
    input [31: 0] Ina;
    input [31: 0] Inb;
    output [31: 0] Out;

    assign Out = (Sel == 0) ? Ina : Inb;

endmodule