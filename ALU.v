/*
    ALU unit for the KTANE project. 
*/
module ALU(clock, reset, opcode, rdataA, rdataB, psrOut, result);
input [7:0] opcode;
input [15:0] rdataA, rdataB;
input clock, reset;
output reg [4:0] psrOut;
output reg [15:0] result;
reg [16:0] resWire; //holds result and an extra bit to check for overflow.
reg [4:0] psr;
always @ (posedge clock) begin
    case(opcode[7:4])
        4'b0000: begin //IType and RTypes are mainly converted into the same form before we get here, so treat them the same.
            case(opcode[3:0])
                4'b0001: begin //AND
                    resWire <= rdataA & rdataB;
                end
                4'b0010: begin //OR
                    resWire <= rdataA | rdataB;
                end
                4'b0011: begin //XOR
                    resWire <= rdataA ^ rdataB;
                end
                4'b0101: begin //ADD
                    resWire <= rdataA + rdataB;
                    if(rdataA[6] == rdataB[6] && resWire[6] != rdataA[6])
                        psr[2] <= 1'b1;
                    else
                        psr[2] <= 1'b0;
                end
                4'b0110: begin //ADDU
                    resWire <= rdataA + rdataB;
                end
                4'b1001: begin //SUB
                    resWire <= rdataA - rdataB;
                end
                4'b1011: begin //CMP
                    if(rdataA == rdataB)
                        psr[3] <= 1'b1; //Set the equals bit of the PSR
                    else
                        psr[3] <= 1'b0;
                    if(rdataA > rdataB)
                        psr[1] <= 1'b1; //set the low bit of the psr
                    else
                        psr[1] <= 1'b0;
                    psr[4] <= (rdataA[7] & rdataB[7]) ^ psr[1]; //Check the other flags to determine if negative or not
                end
					 4'b1101: begin //MOV
						  resWire <= rdataB;
					 end
                default:
                    resWire <= 17'b0;
            endcase
        end 
		  4'b0100: begin
				case(opcode[3:0])
					4'b0100: resWire <= rdataA; //STORE
					4'b0000: begin
					resWire <= rdataA; //LOAD
					end
					4'b1111: begin //Custom jump (really stores the current pc into r14)
					resWire <= rdataA + 2'b10;
					end
				endcase
		  end
		  4'b1000: begin //LSH (assumes the assembler will properly translate negative numbers.)
				if(opcode[3:0] == 4'b0100) begin
					if(rdataB[7] == 1'b1) begin
						$display("Shifting right by %d", (~(rdataB[6:0] - 1'b1)));
						resWire <= rdataA >> (~(rdataB[6:0] - 1'b1));
						end
					else
						resWire <= rdataA << rdataB[6:0];
					end
				else if(opcode[0] == 1'b0) //ASH
					resWire <= rdataA << rdataB[3:0];
				else
					resWire <= rdataA >> rdataB[3:0];
		  end
        4'b1111: begin
				resWire <= {1'b0, rdataB[7:0], 8'b0}; //LUI
		  end
		  default:
            resWire <= 17'b0;
    endcase
	 if(reset == 1'b0) begin //set everything to zero
		resWire <= 17'b0;
		psr <= 5'b0;
	 end
end
always @ (*) begin
	result <= resWire[15:0]; //take the answer, minus the MSB which is just for overflow detection.
	psrOut <= psr; //send out the psr values.
end
endmodule