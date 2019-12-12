module FSM(clock, reset, instruction, pcEn, irEn, pcIncOrSet, rfWe, pcRegSel, r2ImSel, immTypeSel, brWe, wbRegAlu, psrEn, psrFlags);
	input clock, reset;
	input [15:0] instruction;
	input [4:0] psrFlags;
	output reg pcEn, pcIncOrSet, irEn, rfWe, pcRegSel, r2ImSel, brWe, wbRegAlu, psrEn;
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
		psrEn = 1'b0;
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
				psrEn = 1'b1;
				nextState = 2'b11; //go to write back state
				case(instruction[15:12])
					4'b0000: begin //Rtypes
						pcRegSel = 1'b1; //use r1 instead of pc
						r2ImSel = 1'b0; //use r2 data
						if(instruction[7:4] == 4'b1011) begin //CMP
							pcIncOrSet = 1'b0;
						end
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
					4'b0100: begin
						if(instruction[7:4] == 4'b1100) begin //JMP
							pcRegSel = 1'b1;
							r2ImSel = 1'b0;
							immTypeSel = 2'b11;
						end
						else if(instruction[7:4] == 4'b1111) begin //JMP CUST
							pcRegSel = 1'b0;
							r2ImSel = 1'b1;
							immTypeSel = 2'b11;
						end
					end
					4'b0101: begin //ADDI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b01; //Sign extended immediate
					end
					4'b1000: begin //LSHI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b00; //Normal Immediate
					end
					4'b1001: begin //SUBI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b01;
					end
					4'b1100: begin //BCOND
						pcRegSel = 1'b0;
						r2ImSel = 1'b1;
						immTypeSel = 2'b01;
					end
					4'b1011: begin //CMPI
						pcRegSel = 1'b1;
						r2ImSel = 1'b1;
						immTypeSel = 2'b01;
						pcEn = 1'b1;
						pcIncOrSet = 1'b0;
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
			end
			2'b11: begin //WRITE BACK state
				pcEn = 1'b1; //enable the program counter
				rfWe = 1'b1;
				wbRegAlu = 1'b1;
				psrEn = 1'b0;
				pcIncOrSet = 1'b0;
				if(instruction[15:12] == 4'b0100)
					case(instruction[7:4])
						4'b0100: begin //STORE
							rfWe = 1'b0;
							brWe = 1'b1;
						end
						4'b0000: begin //LOAD
							wbRegAlu = 1'b0;
						end
						4'b1100: begin //JMP
							rfWe = 1'b0;
							//pcIncOrSet = ((psrFlags!=5'b00000 && instruction[11:8]==5'b00000) || (psrFlags!=5'b00001 &&  instruction[11:8]==5'b00001))?1'b1:1'b0;
							$display("reeeeeee");
							
							case(instruction[11:8])
								4'b0000: pcIncOrSet = (psrFlags[3] == 1'b1) ? 1'b0 : 1'b1;
								4'b0001: pcIncOrSet = (psrFlags[3] == 1'b0) ? 1'b0 : 1'b1;
								4'b0010: pcIncOrSet = (psrFlags[0] == 1'b1) ? 1'b0 : 1'b1;
								4'b0011: pcIncOrSet = (psrFlags[0] == 1'b0) ? 1'b0 : 1'b1;
								4'b0100: pcIncOrSet = (psrFlags[1] == 1'b1) ? 1'b0 : 1'b1; 
								4'b0101: pcIncOrSet = (psrFlags[1] == 1'b0) ? 1'b0 : 1'b1;
								4'b0110: pcIncOrSet = (psrFlags[4] == 1'b1) ? 1'b0 : 1'b1;
								4'b0111: pcIncOrSet = (psrFlags[4] == 1'b0) ? 1'b0 : 1'b1;
								4'b1000: pcIncOrSet = (psrFlags[2] == 1'b1) ? 1'b0 : 1'b1;
								4'b1001: pcIncOrSet = (psrFlags[2] == 1'b0) ? 1'b0 : 1'b1;
								4'b1010: pcIncOrSet = ((psrFlags[3] == 1'b0 && psrFlags[1] == 1'b0) ? 1'b0 : 1'b1);
								4'b1011: pcIncOrSet = ((psrFlags[3] == 1'b1 || psrFlags[1] == 1'b1) ? 1'b0 : 1'b1);
								4'b1100: pcIncOrSet = ((psrFlags[4] == 1'b0 && psrFlags[0] == 1'b0) ? 1'b0 : 1'b1);
								4'b1101: pcIncOrSet = ((psrFlags[4] == 1'b1 || psrFlags[0] == 1'b1) ? 1'b0 : 1'b1);
								4'b1110: pcIncOrSet = 1'b1;
								4'b1111: pcIncOrSet = 1'b0;
								default: pcIncOrSet = 1'b0;
							endcase	
							
							nextState = 2'b00;
						end
						4'b1111: begin //CUST JUMP
							rfWe = 1'b1;
							pcIncOrSet = 1'b0;
							nextState = 2'b00;
						end
						default: ;
					endcase
				else if(instruction[15:12] == 4'b1100) begin
					pcIncOrSet = 1'b1;
					rfWe = 1'b0;
				end
				else if(instruction[15:12] == 4'b0000 && instruction[7:4] == 4'b0010) begin
					pcIncOrSet = 1'b0;
					rfWe = 1'b0;
					pcEn = 1'b1;
				end
				else
					pcIncOrSet = 1'b0;
				nextState = 2'b00; //get next instruction for IF.
			end
		endcase
	end
	
endmodule