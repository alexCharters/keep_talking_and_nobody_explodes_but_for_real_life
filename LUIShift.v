module LUIShift(inputVal, shiftedOutput);
	input [7:0] inputVal;
	output reg [15:0] shiftedOutput;
	always @ (*) begin
		shiftedOutput = inputVal << 8;
	end
endmodule
