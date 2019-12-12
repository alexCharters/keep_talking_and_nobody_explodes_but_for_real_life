module Decoder(clock, reset, instr, flags, decoded);
	input clock, reset;
	input [15:0] instr;
	input [4:0] flags;
	parameter NOP = 16'b0000000000100000;
	reg [15:0] newInstr;
	output reg [15:0] decoded;
	always @ (*) begin
		case({instr[15:12], instr[7:4]})
			8'b00000000: decoded = 16'b0000000000100000;
			8'b01001100: begin
				newInstr = {instr[15:12], 4'b0, instr[7:0]};
				case(instr[11:8])
					4'b0000: decoded = (flags[3] == 1'b1 ? newInstr : NOP);
					4'b0001: decoded = (flags[3] == 1'b0 ? newInstr : NOP);
					4'b0010: decoded = (flags[0] == 1'b1 ? newInstr : NOP);
					4'b0011: decoded = (flags[0] == 1'b0 ? newInstr : NOP);
					4'b0100: decoded = (flags[1] == 1'b1 ? newInstr : NOP); 
					4'b0101: decoded = (flags[1] == 1'b0 ? newInstr : NOP);
					4'b0110: decoded = (flags[4] == 1'b1 ? newInstr : NOP);
					4'b0111: decoded = (flags[4] == 1'b0 ? newInstr : NOP);
					4'b1000: decoded = (flags[2] == 1'b1 ? newInstr : NOP);
					4'b1001: decoded = (flags[2] == 1'b0 ? newInstr : NOP);
					4'b1010: decoded = ((flags[3] == 1'b0 && flags[1] == 1'b0) ? newInstr : NOP);
					4'b1011: decoded = ((flags[3] == 1'b1 || flags[1] == 1'b1) ? newInstr : NOP);
					4'b1100: decoded = ((flags[4] == 1'b0 && flags[0] == 1'b0) ? newInstr : NOP);
					4'b1101: decoded = ((flags[4] == 1'b1 || flags[0] == 1'b1) ? newInstr : NOP);
					4'b1110: decoded = newInstr;
					4'b1111: decoded = 16'b0000000000100000;
					default: decoded = NOP;
				endcase
			end
			default: decoded = instr;
		endcase
		if(instr[15:12] == 4'b1100) begin
			case(instr[11:8])
					4'b0000: decoded = (flags[3] == 1'b1 ? instr : NOP);
					4'b0001: decoded = (flags[3] == 1'b0 ? instr : NOP);
					4'b0010: decoded = (flags[0] == 1'b1 ? instr : NOP);
					4'b0011: decoded = (flags[0] == 1'b0 ? instr : NOP);
					4'b0100: decoded = (flags[1] == 1'b1 ? instr : NOP); 
					4'b0101: decoded = (flags[1] == 1'b0 ? instr : NOP);
					4'b0110: decoded = (flags[4] == 1'b1 ? instr : NOP);
					4'b0111: decoded = (flags[4] == 1'b0 ? instr : NOP);
					4'b1000: decoded = (flags[2] == 1'b1 ? instr : NOP);
					4'b1001: decoded = (flags[2] == 1'b0 ? instr : NOP);
					4'b1010: decoded = ((flags[3] == 1'b0 && flags[1] == 1'b0) ? instr : NOP);
					4'b1011: decoded = ((flags[3] == 1'b1 || flags[1] == 1'b1) ? instr : NOP);
					4'b1100: decoded = ((flags[4] == 1'b0 && flags[0] == 1'b0) ? instr : NOP);
					4'b1101: decoded = ((flags[4] == 1'b1 || flags[0] == 1'b1) ? instr : NOP);
					4'b1110: decoded = instr;
					4'b1111: decoded = 16'b0000000000100000;
					default: decoded = NOP;
				endcase
		end
	end	
endmodule