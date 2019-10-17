module Datapath(clock, reset, instruction, blockRamWriteEnable, registerFileWriteEnable, integerTypeSelectionLine, reg2OrImmediateSelectionLine, pcOrRegisterSelectionLine, addressFromRegOrDecoderSelectionLine, writeBackToRegRamOrALUSelectionLine, pcOrAluOutputRamReadSelectionLine, decoderRamWriteAddress);
	input [15:0] instruction, decoderRamWriteAddress;
	input clock, reset, reg2OrImmediateSelectionLine, pcOrRegisterSelectionLine, addressFromRegOrDecoderSelectionLine, 
		writeBackToRegRamOrALUSelectionLine, blockRamWriteEnable, registerFileWriteEnable, pcOrAluOutputRamReadSelectionLine;
	input [1:0] integerTypeSelectionLine;
	//Setup Program Counter
	reg [15:0] programCounter;
	wire [15:0] signExtendedImmediate, zeroExtendedImmediate, selectedImmediateType, firstInputToAlu, secondInputToAlu, ramWriteAddress;
	wire [15:0] reg1Data, reg2Data, ramReadData, aluOutput, regFileInputData, operationControlLine;
	//Setup all needed muxes
	mux4to1 integerTypeSelectionMux(.in1(instruction[7:0]), .in2(signExtendedImmediate), .in3(zeroExtendedImmediate), 
		.in4(1), .select(integerTypeSelectionLine), .out(selectedImmediateType));
	mux2to1 reg2OrImmediateMux(.in1(reg2Data), .in2(selectedImmediateType), .select(reg2OrImmediateSelectionLine), 
		.out(secondInputToAlu));
	mux2to1 pcOrRegisterMux(.in1(programCounter), .in2(reg1Data), .select(pcOrRegisterSelectionLine), 
		.out(firstInputToAlu));
	mux2to1 addressFromRegOrDecoderMux(.in1(reg2Data), .in2(decoderRamWriteAddress), .select(addressFromRegOrDecoderSelectionLine), 
		.out(ramWriteAddress));
	mux2to1 writeBackToRegRamOrALUMux(.in1(ramReadData), .in2(aluOutput), .select(writeBackToRegRamOrALUSelectionLine), 
		.out(regFileInputData));
	mux2to1 pcOrAluOutputRamReadMux(.in1(aluOutput), .in2(programCounter), .select(pcOrAluOutputRamReadSelectionLine), .out(ramReadAddress));
	//End needed muxes
	//Sign extender creation
	SignExtender immediateSignExtender(.immediate(instruction[7:0]), .extended(signExtendedImmediate));
	ZeroExtender immediateZeroExtender(.immediate(instruction[7:0]), .result(zeroExtendedImmediate));
	//End extender creation
	//Register File Creation
	RegisterFile registerFile(.clock(clock), .shouldWrite(registerFileWriteEnable), .register1Address(instruction[11:7]), .register2Address(instruction[3:0]), 
		.writeAddress(ramWriteAddress), .register1Data(reg1Data), .register2Data(reg2Data));
	//End Register File Creation
	//Begin Alu and controller creation
	ALUControl controller(.instruction(instruction), .out(operationControlLine));
	ALU alu(.sourceData(firstInputToAlu), .destData(secondInputToAlu), .operationControl(operationControlLine), .carry(), .low(), .overflow(), 
		.zero(), .negative(), .result(aluOutput));
	//End Alu and controller creation
	//Block Ram Creation
	BlockRam blockRam(.data(aluOutput), .read_addr(ramReadAddress), .write_addr(ramWriteAddress), .we(blockRamWriteEnable), .clk(clock), 
		.q(ramReadData));

endmodule
