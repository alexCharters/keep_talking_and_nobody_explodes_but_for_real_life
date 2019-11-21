module CPU(clock, reset, sclbutt, sdabutt, scl1, sda1, scl2, sda2, timer_min, timer_sec1, timer_sec2, morse_sev1, morse_sev2, morse_led, keypad_leds, butt_strip, butt_color, strike_leds, button, morse_left, morse_right, morse_tx, keypad);
	wire [15:0] instMemInput, instMemOut, instMemAddr, pcVal, instr, decoderOut, aluOut, r1Data, 
		r2Data, rdataA, rdataB, signExtended, zeroExtended, immediate, storageOut;
	wire [7:0] aluOp;
	input clock, reset;
	wire instMemWe, pcEn, pcIncSet, irEn, rfWe, pcRegSel, r2ImSel, brWe;
	wire [1:0] immTypeSel;
	
	
	
	output sclbutt, scl1, scl2, morse_led;
	inout sdabutt, sda1, sda2;

	output [6:0] timer_min, timer_sec1, timer_sec2, morse_sev1, morse_sev2;
	output [2:0] butt_strip, butt_color, strike_leds;

	output [3:0] keypad_leds;

	input button, morse_left, morse_right, morse_tx;
	input [3:0] keypad;

	wire [7:0]debug_leds;
	
	
	
	FSM fsm(.clock(clock), .reset(reset), .instruction(instMemOut), .pcEn(pcEn), .irEn(irEn), .pcIncOrSet(pcIncSet), .rfWe(rfWe), .pcRegSel(pcRegSel), .r2ImSel(r2ImSel), .immTypeSel(immTypeSel), .brWe(brWe));

	ProgramCounter pc(.clock(clock), .reset(reset), .enable(pcEn), .incOrSet(pcIncSet), .newValue(pcVal), 
	.index(instMemAddr));
	
	InstructionMem instMem(.data(instMemInput), .clk(clock), .addr(instMemAddr), .we(instMemWe), .q(instMemOut));
	
	Decoder decoder(.clock(clock), .reset(reset), .instr(instMemOut), .decoded(decoderOut));
	
	InstructionRegister ir(.clock(clock), .reset(reset), .enable(irEn), .instructionIn(instMemOut), .instr(instr));

	RegisterFile rf(.clock(clock), .reset(reset), .shouldWrite(rfWe), .register1Address(instr[11:8]), .register2Address(instr[3:0]), 
		.writeAddress(instr[11:8]), .writeData(aluOut), .register1Data(r1Data), .register2Data(r2Data));
		
	//StorageRam storeRam(.data(aluOut), .addr(r2Data), .we(brWe), .clk(clock), .q(storageOut));
		
	mux2to1 pcOrReg(.in1(instMemAddr), .in2(r1Data), .select(pcRegSel), .out(rdataA));
	
	SignExtender signExt(.immediate(instr[7:0]), .extended(signExtended));
	
	ZeroExtender zeroExt(.immediate(instr[7:0]), .result(zeroExtended));
	
	mux4to1 immMux(.in1(instr[7:0]), .in2(signExtended), .in3(zeroExtended), .in4(1'b0), .select(immTypeSel), .out(immediate));
	
	mux2to1 r2OrImmediate(.in1(r2Data), .in2(immediate), .select(r2ImSel), .out(rdataB));
	
	ALUController aluCtl(.clock(clock), .reset(reset), .opcode({instMemOut[15:12], instMemOut[7:4]}), .aluOpcode(aluOp));
	
	ALU alu(.clock(clock), .reset(reset), .opcode(aluOp), .rdataA(rdataA), .rdataB(rdataB), .psrOut(), .result(aluOut));
	
	ktane_mem memory(.data(aluOut),
	.addr(r2Data),
	.we(brWe),
	.clk(clock),
	.q(storageOut),
	.sda(sdabutt),
	.scl(sclbutt),
	.sda2(sda1),
	.scl2(scl1),
	.led1(butt_strip),
	.led2(butt_color),
	.button(button),
	.morse_left(morse_left),
	.morse_right(morse_right),
	.morse_tx(morse_tx),
	.morse_led(morse_led),
	.keypad_TL(keypad[3]),
	.keypad_TR(keypad[2]),
	.keypad_LL(keypad[1]),
	.keypad_LR(keypad[0]),
	.keypad_leds(keypad_leds),
	.morse_sevseg1(morse_sev1),
	.morse_sevseg2(morse_sev2),
	.timer_sevseg1(timer_sec2),
	.timer_sevseg2(timer_sec1),
	.timer_sevseg3(timer_min),
	.strike_leds(strike_leds),
	.debug_leds(debug_leds)
	//ADC_CONVST,
	//ADC_SCK,
	//ADC_SDI,
	//ADC_SDO
	);
	
endmodule