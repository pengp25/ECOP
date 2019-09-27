module MUX5(Sel, Ina, Inb, Out);
    input Sel;
    input [4: 0] Ina;
    input [4: 0] Inb;
    output [4: 0] Out;

    assign Out = (Sel == 0) ? Ina : Inb;

endmodule