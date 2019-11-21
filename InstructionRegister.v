module InstructionRegister(clock, reset, enable, instructionIn, instructionOut);
    input clock, reset, enable;
    input [15:0] instructionIn;
	 reg [15:0] instr;
    output reg [15:0] instructionOut;
    always @ (posedge clock) begin
        if(reset == 1'b0)
				instr <= 16'b0;
		  else if(enable == 1'b1) begin
				instr <= instructionIn;
		  end
		  instructionOut <= instr;
    end
endmodule