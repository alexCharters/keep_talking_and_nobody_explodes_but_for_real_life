module Decoder(clock, reset, instr, decoded);
	input clock, reset;
	input [15:0] instr;
	output reg [15:0] decoded;
	always @ (posedge clock) begin
		case({instr[15:12], instr[7:4]})
			8'b00000000: decoded <= 8'b10000000;
			default: decoded <= instr;
		endcase
	end	
endmodule