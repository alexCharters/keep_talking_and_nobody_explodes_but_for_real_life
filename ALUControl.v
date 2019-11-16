module ALUControl(instruction, out);
//maybe we send the PSR flags into here?
	input [15:0] instruction;
	output reg [7:0] out;
	parameter ADD = 8'b00000101, ADDUI = 8'b01100000;
	always @ (*) begin
		out = {instruction[15:12], instruction[7:4]}; //this is the case for most instructions.
		//TODO handle jumps and branches. If the decoder can handle moving source values around, this might be easy!
		if(instruction[15:12] == 4'b0100) begin //Load or store. Need to change to addu. Decoder should select zero.
			case(instruction[7:4])
				4'b0000: begin
					//Load
					out = {instruction[15:12], instruction[7:4]};
				end
				4'b0100: begin
					//Store
					out = ADDUI;
				end
				4'b1100: begin
					//JCond
					out = ADDUI;
				end
				4'b1000: begin
					//JAL
					out = ADDUI;
				end
				default: out = {instruction[15:12], instruction[7:4]};
			endcase
		end
		else if(instruction[15:12] == 4'b1100) begin
			out = ADD; //signed 2's complement
		end
	end
endmodule
