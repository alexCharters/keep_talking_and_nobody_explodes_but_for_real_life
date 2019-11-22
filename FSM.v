module FSM(clock, reset, instruction, pcEn, irEn, pcIncOrSet, rfWe, pcRegSel, r2ImSel, immTypeSel, brWe, wbRegAlu);
	input clock, reset;
	input [15:0] instruction;
	output reg pcEn, pcIncOrSet, irEn, rfWe, pcRegSel, r2ImSel, brWe, wbRegAlu;
	output reg [1:0] immTypeSel;
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
		pcRegSel = 1'b1;
		r2ImSel = 1'b0;
		rfWe = 1'b0;
		immTypeSel = 1'b0;
		brWe = 1'b0;
		wbRegAlu = 1'b1; //By default, write using the result from the ALU
		case(currentState)
			2'b00: begin //IF state
				nextState = 2'b01; //go to decode state
			end
			2'b01: begin //DECODE state
				irEn = 1'b1;
				nextState = 2'b10; //go to execute state
			end
			2'b10: begin //EXECUTE state
				//set control lines here
				case(instruction[15:12])
					4'b0000: begin //Rtypes
						pcRegSel = 1'b1; //use r1 instead of pc
						r2ImSel = 1'b0; //use r2 data
					end
					4'b0001: begin //ANDI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b10; //Zero extended immediate
					end
					4'b0010: begin //ORI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b10; //Zero extended immediate
					end
					4'b0011: begin //XORI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b10; 
					end
					4'b0101: begin //ADDI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b01; //Sign extended immediate
					end
					4'b1001: begin //SUBI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b01;
					end
					4'b1101: begin //MOVI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b10; //Zero extended immediate
					end
					4'b1111: begin //LUI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b00;
					end
					default: ;
				endcase
				nextState = 2'b11; //go to write back state
			end
			2'b11: begin //WRITE BACK state
				pcEn = 1'b1; //enable the program counter
				rfWe = 1'b1;
				wbRegAlu = 1'b1;
				if(instruction[15:12] == 4'b0100)
					case(instruction[7:4])
						4'b0100: begin //STORE
							rfWe = 1'b0;
							brWe = 1'b1;
						end
						4'b0000: begin //LOAD
							wbRegAlu = 1'b0;
						end
						default: ;
					endcase
				else
					pcIncOrSet = 1'b0;
				nextState = 2'b00; //get next instruction for IF.
			end
		endcase
	end
	
endmodule