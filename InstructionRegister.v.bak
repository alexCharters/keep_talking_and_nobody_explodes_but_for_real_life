module InstructionRegister(instruction, readEnabled, out);
    input [15:0] instruction;
    input readEnabled;
    output reg [15:0] out;
    always @ (*) begin
        if (readEnabled == 1'b1)
            out = instruction;
    end
endmodule