module ALU(clock, reset, opcode, rdataA, rdataB, psrOut, result);
input [7:0] opcode, rdataA, rdataB;
input clock, reset;
output reg [4:0] psrOut;
output reg [15:0] result;
reg [16:0] resWire; //holds result
reg [4:0] psr;
always @ (posedge clock) begin
    case(opcode[7:4])
        4'b0000: begin
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
                end
                4'b0110: begin //ADDU
                    resWire <= rdataA + rdataB;
                end
                4'b1001: begin //SUB
                    resWire <= rdataA - rdataB;
                end
                4'b1011: begin //CMP
                    if(rdataA - rdataB == 8'b0)
                        psr[3] <= 1'b1;
                    else
                        psr[3] <= 1'b0;
                    if(rdataB > rdataA)
                        psr[1] <= 1'b1;
                    else
                        psr[1] <= 1'b0;
                    psr[4] <= rdataA[7] ^ rdataB[7] ^ psr[1];
                end
                default:
                    resWire <= 17'b0;
            endcase
        end 
        default:
            resWire <= 17'b0;
    endcase
	 if(reset == 1'b0) begin
		resWire <= 17'b0;
		psr <= 5'b0;
	 end
	 else begin
		result <= resWire[15:0];
		psrOut <= psr;
	 end
end
endmodule