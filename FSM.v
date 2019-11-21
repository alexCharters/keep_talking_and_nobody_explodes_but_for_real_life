module FSM(clock, reset, instruction, pcEn, irEn, pcIncOrSet);
	input clock, reset;
	input [15:0] instruction;
	output reg pcEn, pcIncOrSet, irEn;
	reg [1:0] currentState = 2'b0, nextState = 2'b0;
	
	always @(posedge clock) begin
		if(reset == 1'b0)
			currentState <= 2'b0;
		else
			currentState <= nextState;
	end
	
	always @ (*) begin
		pcEn = 1'b0;
		pcIncOrSet = 1'b0;
		irEn = 1'b0;
		case(currentState)
			2'b00: begin //IF state
				nextState = 2'b01; //go to decode state
			end
			2'b01: begin //DECODE state
				irEn = 1'b1;
				nextState = 2'b10; //go to execute state
			end
			2'b10: begin //EXECUTE state
				nextState = 2'b11; //go to write back state
			end
			2'b11: begin //WRITE BACK state
				pcEn = 1'b1; //enable the program counter
				if(instruction[15:12] == 4'b0100)
					pcIncOrSet = 1'b1;
				else
					pcIncOrSet = 1'b0;
				nextState = 2'b00; //get next instruction for IF.
			end
		endcase
	end
	
endmodule