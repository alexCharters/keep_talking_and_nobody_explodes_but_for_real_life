module InstructionRegister(clock, reset, enable, instructionIn, instr);
    input clock, reset, enable;
    input [15:0] instructionIn;
	 output reg [15:0] instr;
    always @ (posedge clock) begin
        if(reset == 1'b0)
				instr <= 16'b0;
		  else if(enable == 1'b1) begin
				instr <= instructionIn;
		  end
    end
endmodule