module ProgramCounter(incOrSet, newAddress, currentInstruction);
	input incOrSet; //will control if the PC increments or is set to a different address after each operation.
	input [15:0] newAddress; //will contain the branch, or jump address the pc should be set to if Set is enabled.
	output reg [15:0] currentInstruction; //Outputs the current instruction number. 
	always @(*) begin
		if(incOrSet == 0) begin //we are simply incrementing the PC by one.
			currentInstruction = currentInstruction + 1;
		end
		else begin
			currentInstruction = newAddress; //A new address has been provided, so we need to set our counter to it.
		end
	end
endmodule
