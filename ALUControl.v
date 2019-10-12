module ALUControl(instruction, shftOrNormMuxEnable, regSrcSelect, regDestSelect, regOrImmediateMuxEnable, immediateSignZeroMuxEnable, aluOrOtherMuxEnable, ramOrRegDestMuxEnable);
	input [7:0] instruction;
	output shftOrNormMuxEnable, regOrImmediateMuxEnable, aluOrOtherMuxEnable, ramOrRegDestMuxEnable;
	output [1:0] immediateSignZeroMuxEnable;
	parameter IMMEDIATE_ONLY = 2'b00, SIGN_EXTEND = 2'b01, ZERO_EXTEND = 2'b10;
	always @ (*) begin
		case(instruction[15:12])
			4'b0000: begin //This is an r type instruction
						shftOrNormMuxEnable = 1'b1;
						regOrImmediateMuxEnable = 1'b0;
						aluOrOtherMuxEnable = 1'b0;
						ramOrRegDestMuxEnable = 1'b1;
						regSrcSelect = instruction[3:0];
			end
			4'b0101: begin //ADDI
				shftOrNormMuxEnable = 1'b1;
				regOrImmediateMuxEnable = 1'b1;
				aluOrOtherMuxEnable = 1'b0;
				ramOrRegDestMuxEnable = 1'b1;
				immediateSignZeroMuxEnable = SIGN_EXTEND;
			end
			4'b0110: begin //ADDUI
				shftOrNormMuxEnable = 1'b1;
				regOrImmediateMuxEnable = 1'b1;
				aluOrOtherMuxEnable = 1'b0;
				ramOrRegDestMuxEnable = 1'b1;
				immediateSignZeroMuxEnable = SIGN_EXTEND;
			end
			4'b1001: begin //SUBI
				shftOrNormMuxEnable = 1'b1;
				regOrImmediateMuxEnable = 1'b1;
				aluOrOtherMuxEnable = 1'b0;
				ramOrRegDestMuxEnable = 1'b1;
				immediateSignZeroMuxEnable = SIGN_EXTEND;
			end
			4'b1011: begin //CMPI
				shftOrNormMuxEnable = 1'b1;
				regOrImmediateMuxEnable = 1'b1;
				aluOrOtherMuxEnable = 1'b0;
				ramOrRegDestMuxEnable = 1'b1;
				immediateSignZeroMuxEnable = SIGN_EXTEND;
			end
			4'b0001: begin //ANDI
				shftOrNormMuxEnable = 1'b1;
				regOrImmediateMuxEnable = 1'b1;
				aluOrOtherMuxEnable = 1'b0;
				ramOrRegDestMuxEnable = 1'b1;
				immediateSignZeroMuxEnable = ZERO_EXTEND;
			end
			4'b0010: begin //ORI
				shftOrNormMuxEnable = 1'b1;
				regOrImmediateMuxEnable = 1'b1;
				aluOrOtherMuxEnable = 1'b0;
				ramOrRegDestMuxEnable = 1'b1;
				immediateSignZeroMuxEnable = ZERO_EXTEND;
			end
			4'b0011: begin //XORI
				shftOrNormMuxEnable = 1'b1;
				regOrImmediateMuxEnable = 1'b1;
				aluOrOtherMuxEnable = 1'b0;
				ramOrRegDestMuxEnable = 1'b1;
				immediateSignZeroMuxEnable = ZERO_EXTEND;
			end
			4'b1101: begin //MOVI
				shftOrNormMuxEnable = 1'b1;
				regOrImmediateMuxEnable = 1'b1;
				aluOrOtherMuxEnable = 1'b0;
				ramOrRegDestMuxEnable = 1'b1;
				immediateSignZeroMuxEnable = ZERO_EXTEND;
			end
			4'b1111: begin //LUI
				shftOrNormMuxEnable = 1'b1;
				regOrImmediateMuxEnable = 1'b1;
				aluOrOtherMuxEnable = 1'b0;
				ramOrRegDestMuxEnable = 1'b1;
				immediateSignZeroMuxEnable = IMMEDIATE_ONLY;
			end
			4'b0100: begin
				case(instruction[7:4])
					4'b0000: begin //LOAD rsrc, rdestAddr
						shftOrNormMuxEnable = 1'b0; //this is the register holding the source
						regOrImmediateMuxEnable = 1'b1; //want to be able to set a constant value of zero to add
						aluOrOtherMuxEnable = 1'b1;
						ramOrRegDestMuxEnable = 1'b1; //we store the read from ram into the register file
						immediateSignZeroMuxEnable = IMMEDIATE_ONLY; //We will need to pass a zero into here for the add
						
					end
					4'b0100: begin //STOR
						shftOrNormMuxEnable = 1'b1; //get the address value of the register's data
						regOrImmediateMuxEnable = 1'b1;
					end
					4'b1000: begin //JAL 
						shftOrNormMuxEnable = 1'b1;
						regOrImmediateMuxEnable = 1'b1;
						aluOrOtherMuxEnable = 1'b0;
						ramOrRegDestMuxEnable = 1'b1;
						immediateSignZeroMuxEnable = IMMEDIATE_ONLY;
					end
					4'b1100: begin

					end
				endcase
			end
		endcase
	end
endmodule
