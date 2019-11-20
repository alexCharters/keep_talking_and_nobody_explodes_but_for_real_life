module ALUTestOnBoard(clock, reset, rdataA, rdataB, psr, opcodeLow, result);
	input clock, reset;
	input rdataA, rdataB;
	input [3:0] opcodeLow;
	output [4:0] psr;
	output [15:0] result;
	ALU alu(.clock(clock), .reset(reset), .opcode({4'b0000, opcodeLow}), .rdataA(rdataA), .rdataB(rdataB), .psrOut(psr), .result(result));
endmodule
