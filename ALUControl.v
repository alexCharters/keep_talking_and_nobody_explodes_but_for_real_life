module ALUControl(instruction, r1PCIn, r2ImmediateIn, psrFlags, opControl, r1PCOut, r2ImmediateOut);
	input [15:0] instruction, r1PCIn, r2ImmediateIn;
	input [15:0] psrFlags;
	output reg [7:0] opControl;
	output reg [15:0] r1PCOut, r2ImmediateOut;

	//Condition code params for ease of use
	parameter EQ = 4'b0000, NE = 4'b0001, GT = 4'b0110, LE = 4'b0111, LT = 4'b1100, GE = 4'b1101;
	//parameters for the PSR flag locations (rrrrIPE0NZF00LTC)
	parameter Carry = 16'b1, LessThan = 16'b100, Overflow = 16'b100000, Zero = 16'b1000000, Negative = 16'b10000000,
		Equal = 16'b1000000000; 

	always @ (*) begin
		//by default the provided input will be the output given to the ALU.
		r1PCOut = r1PCIn;
		r2ImmediateOut = r2ImmediateIn;
		case(instruction[15:12])
		//Need cases for Load, Store, SCond, BCond, and all Jumps.
			4'b0100: begin //set condition, store and load, and all jumps
				case(instruction[7:4])
					4'b0000: begin //LOAD
						//Need to take the value received from a provided address in memory.
						//Once this value is obtained, the decoder should handle writing the value to the proper reg.
						//Really just need the address added with zero. ADDU.
						opControl = 8'b00000110;
						r2ImmediateOut = 0;
					end
					4'b0100: begin //STORE
						//Decoder should handle toggling the proper mux for an add between the register value and zero.
						//This is really just an add U between r0 and the rsrc. This isn't quite going to work, but its a start.
						opControl = 8'b00000110;
						r2ImmediateOut = 0;
					end
					4'b1101: begin //SCond
						//This is just a sneaky CMP hidden! It's also not technically needed, so I will wait until it is required.
					end
					4'b1100: begin //JCond
						//IF the condition is true, we want to output the new value for the program counter. Need some way to check cond.
						// Condition flags from first checkpoint will help.
						// Good thing we have the PSR register flags. Still need the inputs though.
						// Unless we use a NOP to waste time if the condition is false.
						case(instruction[11:8])
							EQ: begin
								if(psrFlags & Equal) begin
									opControl = 8'b00000000; //This needs to be changed.
								end
								else
									//What to do here?
									opControl = 8'b00000000;
							end
						endcase

					end
					default:
						opControl = {instruction[15:12], instruction[7:4]};
				endcase
			end
			4'b1100: begin //BCond
				//Want to add an offset to the PC. This is an ADDI, using the PC and some address immediate.
				opControl = 8'b01010000;
			end
			default:
				opControl = {instruction[15:12], instruction[7:4]}; //By default, the op control will match the instruction. There are only a select few cases where this will not be true.
		endcase
	end
endmodule
