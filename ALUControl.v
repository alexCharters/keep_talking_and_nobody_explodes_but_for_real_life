module ALUControl(instruction, out);
//maybe we send the PSR flags into here?
	input [15:0] instruction;
	output reg [7:0] out;
	always @ (*) begin
		out = {instruction[15:12], instruction[7:4]}; //this is the case for most instructions.
		//TODO handle jumps and branches. If the decoder can handle moving source values around, this might be easy!
	end
endmodule
