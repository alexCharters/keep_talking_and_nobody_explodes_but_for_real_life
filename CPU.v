module CPU(clock, reset);
	wire [15:0] instMemInput, instMemOut, instMemAddr, pcVal, instr, decoderOut, aluOut, r1Data, 
		r2Data, rdataA, rdataB, signExtended, zeroExtended, immediate, storageOut, regDataIn;
	wire [7:0] aluOp;
	input clock, reset;
	wire instMemWe, pcEn, pcIncSet, irEn, rfWe, pcRegSel, r2ImSel, brWe, wbRegAlu;
	wire [1:0] immTypeSel;
	wire [4:0] psrOut, flags;
	
	FSM fsm(.clock(clock), .reset(reset), .instruction(instMemOut), .pcEn(pcEn), .irEn(irEn), .pcIncOrSet(pcIncSet), 
	.rfWe(rfWe), .pcRegSel(pcRegSel), .r2ImSel(r2ImSel), .immTypeSel(immTypeSel), .brWe(brWe), .wbRegAlu(wbRegAlu),
	.psrEn(psrEn), .psrFlags(psrOut));

	ProgramCounter pc(.clock(clock), .reset(reset), .enable(pcEn), .incOrSet(pcIncSet), .newValue(aluOut), 
	.index(instMemAddr));
	
	InstructionMem instMem(.data(instMemInput), .clk(clock), .addr(instMemAddr), .we(instMemWe), .q(instMemOut));
	
	Decoder decoder(.clock(clock), .reset(reset), .instr(instMemOut), .flags(psrOut), .decoded(decoderOut));
	
	InstructionRegister ir(.clock(clock), .reset(reset), .enable(irEn), .instructionIn(decoderOut), .instr(instr));

	RegisterFile rf(.clock(clock), .reset(reset), .shouldWrite(rfWe), .register1Address(instr[11:8]), .register2Address(instr[3:0]), 
		.writeAddress(instr[11:8]), .writeData(regDataIn), .register1Data(r1Data), .register2Data(r2Data));
		
	StorageRam storeRam(.data(aluOut), .addr(r2Data), .we(brWe), .clk(clock), .q(storageOut));
		
	mux2to1 pcOrReg(.in1(instMemAddr), .in2(r1Data), .select(pcRegSel), .out(rdataA));
	
	mux2to1 wbRgAlu(.in1(storageOut), .in2(aluOut), .select(wbRegAlu), .out(regDataIn));
	
	SignExtender signExt(.immediate(instr[7:0]), .extended(signExtended));
	
	ZeroExtender zeroExt(.immediate(instr[7:0]), .result(zeroExtended));
	
	mux4to1 immMux(.in1(instr[7:0]), .in2(signExtended), .in3(zeroExtended), .in4(16'b0), .select(immTypeSel), .out(immediate));
	
	mux2to1 r2OrImmediate(.in1(r2Data), .in2(immediate), .select(r2ImSel), .out(rdataB));
	
	ALUController aluCtl(.clock(clock), .reset(reset), .opcode({instMemOut[15:12], instMemOut[7:4]}), .aluOpcode(aluOp));
	
	ALU alu(.clock(clock), .reset(reset), .opcode(aluOp), .rdataA(rdataA), .rdataB(rdataB), .psrOut(flags), .result(aluOut));
	
	PSR psr(.clock(clock), .reset(reset), .enable(psrEn), .flagsIn(flags), .flagsOut(psrOut));
	
endmodule