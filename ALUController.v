module ALUController(clock, reset, opcode, aluOpcode);
    input clock, reset;
    input [7:0] opcode;
    output reg [7:0] aluOpcode;
    always @ (posedge clock) begin
        case (opcode[7:4])
            4'b0000:
                aluOpcode <= opcode; //RTYPE is unmodified 
            4'b0100: //JMP convert to an addu
					 if(opcode[3:0] == 4'b1100 || opcode[3:0] == 4'b1000)
						aluOpcode <= 8'b00000110;
					 else if(opcode[3:0] == 4'b1111)
						aluOpcode <= 8'b01001111;
					 else
						aluOpcode <= opcode;
				4'b1000: //SHIFTS
					aluOpcode <= opcode;
				4'b1100: //BCond
					aluOpcode <= 8'b00000110;
				4'b1111: //LUI
					aluOpcode <= opcode;
            default: 
                aluOpcode <= {4'b0, opcode[7:4]}; //ITYPE assumed in the default case. Convert to RTYPE instruction.
        endcase
    end
endmodule