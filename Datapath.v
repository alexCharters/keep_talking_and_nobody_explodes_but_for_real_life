module Datapath(clock, currentState, reset, regNormExtendCtl, reg2OrImmediateCtl, pcOrReg1Ctl, immediateSelectCtl);
	input clock, reset, regNormExtendCtl, reg2OrImmediateCtl, pcOrReg1Ctl;
	input [2:0] immediateSelectCtl;
	input [1:0] currentState;
	reg [15:0] instruction;
	wire [15:0] regWriteData; //Not sure about this size...
	wire [7:0] reg1Data, reg2Data, aluOperation;
	reg [15:0] psrRegister;
	wire [15:0] extendedR1Data, signExtendedImmediate, zeroExtendedImmediate, r1OutputToALU, r2OutputToALU, pcReg1OutputToALU, immediateMuxResult,
	aluOutput, r1ALUIn, r2ALUIn;
	wire regWriteEnable, zeroLine, carryLine, overflowLine, negativeLine, lowLine;
	RegisterFile regFile(.clock(clock), .shouldWrite(regWriteEnable), .register1Address(instruction[15:12]), .register2Address(instruction[3:0]), .writeAddress(instruction[15:12]), .writeData(regWriteData), .register1Data(reg1Data), .register2Data(reg2Data));
	SignExtender reg1Extend(.immediate(reg1Data), .extended(extendedR1Data));
	SignExtender immediateSignExtend(.immediate(instruction[7:0]), .extended(signExtendedImmediate));
	ZeroExtender immediateZeroExtend(.immediate(instruction[7:0]), .result(zeroExtendedImmediate));
	mux2to1 regNormOrExtendMux(.in1(reg1Data), .in2(extendedR1Data), .select(regNormExtendCtl), .out(r1OutputToALU));
	mux4to1 immediateSelectMux(.in1(instruction[7:0]), .in2(signExtendedImmediate), .in3(zeroExtendedImmediate), .in4(16'b1), .select(immediateSelectCtl), .out(immediateMuxResult));
	mux2to1 reg2OrImmediateMux(.in1(reg2Data), .in2(immediateMuxResult), .select(reg2OrImmediateCtl), .out(r2OutputToALU));
	mux2to1 pcOrReg1ResultMux(.in1(pcValue), .in2(r1OutputToALU), .select(pcOrReg1Ctl), .out(pcReg1OutputToALU));
	ALUControl aluCtl(.instruction(instruction), .r1PCIn(pcReg1OutputToALU), .r2ImmediateIn(r2OutputToALU), .psrFlags(psrRegister), .opControl(aluOperation), .r1PCOut(r1ALUIn), .r2ImmediateOut(r2ALUIn));
	ALU alu(.sourceData(pcReg1OutputToALU), .destData(r2OutputToALU), .operationControl(aluOperation), .carry(carryLine), .low(lowLine), .overflow(overflowLine), .zero(zeroLine), .negative(negativeLine), .result(aluOutput));
	//psrRegister = {6'b000000, 1'b0, 1'b0, negativeLine, zeroLine, overflowLine, 2'b00, lowLine, 1'b0, carryLine};
endmodule
