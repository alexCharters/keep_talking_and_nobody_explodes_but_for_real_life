module ProgramCounter(clock, enable, incOrSet, newAddress, reset, currentInstruction);
	input incOrSet, reset, clock, enable; //will control if the PC increments or is set to a different address after each operation.
	input [15:0] newAddress; //will contain the branch, or jump address the pc should be set to if Set is enabled.
	output reg [15:0] currentInstruction; //Outputs the current instruction number. 
	always @(posedge clock) begin
		if(reset == 0)
			currentInstruction <= 0;
		else if(incOrSet == 0 && enable == 1) begin //we are simply incrementing the PC by one.
			if (currentInstruction != 16'hBFFF) begin
				currentInstruction <= currentInstruction + 1'b1;
			end
			else begin
			   currentInstruction <= 16'hBFFF;
			end
		end
		else if(enable == 1) begin
			currentInstruction <= newAddress; //A new address has been provided, so we need to set our counter to it.
		end
	end
endmodule
