module Decoder(clock, reset, instr, flags, decoded);
	input clock, reset;
	input [15:0] instr;
	input [4:0] flags;
	output reg [15:0] decoded;
	always @ (*) begin
		case({instr[15:12], instr[7:4]})
			8'b00000000: decoded = 16'b10000000;
			8'b01001100: begin
				case(instr[11:8])
					4'b1110: decoded = instr;
					4'b1111: decoded = 16'b0000000000100000;
				endcase
			end
			default: decoded = instr;
		endcase
	end	
endmodule