module CPU(clock, reset);
	wire [15:0] instMemInput, instMemOut, instMemAddr, pcVal, instr, decoderOut, aluOut, r1Data, 
		r2Data, rdataA, rdataB, signExtended, zeroExtended, immediate;
	wire [7:0] aluOp;
	input clock, reset;
	wire instMemWe, pcEn, pcIncSet, irEn, rfWe, pcRegSel, r2ImSel;
	wire [1:0] immTypeSel;
	
	FSM fsm(.clock(clock), .reset(reset), .instruction(instr), .pcEn(pcEn), .irEn(irEn), .pcIncOrSet(pcIncSet));

	ProgramCounter pc(.clock(clock), .reset(reset), .enable(pcEn), .incOrSet(pcIncSet), .newValue(pcVal), 
	.currentInstructionIndex(instMemAddr));
	
	InstructionMem instMem(.data(instMemInput), .clk(clock), .addr(instMemAddr), .we(instMemWe), .q(instMemOut));
	
	Decoder decoder(.clock(clock), .reset(reset), .instr(instMemOut), .decoded(decoderOut));
	
	InstructionRegister ir(.clock(clock), .reset(reset), .enable(irEn), .instructionIn(instMemOut), .instructionOut(instr));

	RegisterFile rf(.clock(clock), .reset(reset), .shouldWrite(rfWe), .register1Address(instr[11:8]), .register2Address(instr[3:0]), 
		.writeAddress(instr[11:8]), .writeData(aluOut), .register1Data(r1Data), .register2Data(r2Data));
		
	mux2to1 pcOrReg(.in1(instMemAddr), .in2(r1Data), .select(pcRegSel), .out(rdataA));
	
	SignExtender signExt(.immediate(instr[7:0]), .extended(signExtended));
	
	ZeroExtender zeroExt(.immediate(instr[7:0]), .result(zeroExtended));
	
	mux4to1 immMux(.in1(instr[7:0]), .in2(signExtended), .in3(zeroExtended), .in4(1'b0), .select(immTypeSel), .out(immediate));
	
	mux2to1 r2OrImmediate(.in1(r2Data), .in2(immediate), .select(r2ImSel), .out(rdataB));
	
	ALUController aluCtl(.clock(clock), .reset(reset), .opcode({instr[15:12], instr[7:4]}), .aluOpcode(aluOp));
	
	ALU alu(.clock(clock), .reset(reset), .opcode(aluOp), .rdataA(rdataA), .rdataB(rdataB), .psrOut(), .result(aluOut));
	
endmodule