module InstructionRegister(instruction, readEnabled, out);
    input [15:0] instruction;
    input readEnabled;
    output reg [15:0] out;
    always @ (instruction or readEnabled) begin
        if (readEnabled == 1'b0)
          out = instruction;
    end
endmodule