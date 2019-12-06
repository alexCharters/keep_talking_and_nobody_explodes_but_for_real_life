module PSR(clock, enable, reset, flagsIn, flagsOut);
	input [4:0] flagsIn;
	input clock, enable, reset;
	output reg [4:0] flagsOut;
	always @(*) begin
		if(reset == 1'b0)
			flagsOut = 5'b0;
		else if(enable == 1'b1)
			flagsOut = flagsIn;
	end
endmodule