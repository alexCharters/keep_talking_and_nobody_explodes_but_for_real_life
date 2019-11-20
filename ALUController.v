module ALUController(clock, reset, opcode, aluOpcode);
    input clock, reset;
    input [7:0] opcode;
    output reg [7:0] aluOpcode;
    always @ (posedge clock) begin
        case (opcode[7:4])
            4'b0000:
                aluOpcode <= opcode; //RTYPE is unmodified 
            4'b0100: //LD, STOR, JMP convert to an addu
                aluOpcode <= 8'b00000110;
				4'b1000: //SHIFTS
					aluOpcode <= opcode;
				4'b1111: //LUI
					aluOpcode <= opcode;
            default: 
                aluOpcode <= {4'b0, opcode[7:4]}; //ITYPE assumed in the default case. Convert to RTYPE instruction.
        endcase
    end
endmodule