module ALUTestOnBoard(clock, reset, rdataA, rdataB, psr, opcodeLow, result);
	input clock, reset;
	input rdataA, rdataB;
	input [3:0] opcodeLow;
	wire [7:0] opcode;
	output [4:0] psr;
	output [15:0] result;
	ALUController aluCtl(.clock(clock), .reset(reset), .opcode({opcodeLow, 4'b0000}), .aluOpcode(opcode));
	ALU alu(.clock(clock), .reset(reset), .opcode(opcode), .rdataA(rdataA), .rdataB(rdataB), .psrOut(psr), .result(result));
endmodule
