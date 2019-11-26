module CPU(clock, reset, sclbutt, sdabutt, scl1, sda1, scl2, sda2, timer_min, timer_sec1, timer_sec2, morse_sev1, morse_sev2, morse_led, keypad_leds, butt_strip, butt_color, strike_leds, button, morse_left, morse_right, morse_tx, keypad, ADC_CONVST, ADC_SCK, ADC_SDO, ADC_SDI);
	wire [15:0] instMemInput, instMemOut, instMemAddr, pcVal, instr, decoderOut, aluOut, r1Data, 
		r2Data, rdataA, rdataB, signExtended, zeroExtended, immediate, storageOut, regDataIn;
	wire [7:0] aluOp;
	input clock, reset;
	wire instMemWe, pcEn, pcIncSet, irEn, rfWe, pcRegSel, r2ImSel, brWe, wbRegAlu, psrEn;
	wire [1:0] immTypeSel;
	wire [4:0] psrOut, flags;
	
	input		ADC_SDO;

	output	ADC_CONVST;
	output	ADC_SCK;
	output	ADC_SDI;
	
	output sclbutt, scl1, scl2, morse_led;
	inout sdabutt, sda1, sda2;

	output [6:0] timer_min, timer_sec1, timer_sec2, morse_sev1, morse_sev2;
	output [2:0] butt_strip, butt_color, strike_leds;

	output [3:0] keypad_leds;

	input button, morse_left, morse_right, morse_tx;
	input [3:0] keypad;

	wire [7:0]debug_leds;
	
	
	
	//FSM fsm(.clock(clock), .reset(reset), .instruction(instMemOut), .pcEn(pcEn), .irEn(irEn), .pcIncOrSet(pcIncSet), .rfWe(rfWe), .pcRegSel(pcRegSel), .r2ImSel(r2ImSel), .immTypeSel(immTypeSel), .brWe(brWe));
	FSM fsm(.clock(clock), .reset(reset), .instruction(decoderOut), .pcEn(pcEn), .irEn(irEn), .pcIncOrSet(pcIncSet), 
	.rfWe(rfWe), .pcRegSel(pcRegSel), .r2ImSel(r2ImSel), .immTypeSel(immTypeSel), .brWe(brWe), .wbRegAlu(wbRegAlu),
	.psrEn(psrEn), .psrFlags(psrOut));

	ProgramCounter pc(.clock(clock), .reset(reset), .enable(pcEn), .incOrSet(pcIncSet), .newValue(aluOut), .index(instMemAddr));
	
	InstructionMem instMem(.data(instMemInput), .clk(clock), .addr(instMemAddr), .we(instMemWe), .q(instMemOut));
	
	Decoder decoder(.clock(clock), .reset(reset), .instr(instMemOut), .flags(psrOut), .decoded(decoderOut));
	
	InstructionRegister ir(.clock(clock), .reset(reset), .enable(irEn), .instructionIn(decoderOut), .instr(instr));

	RegisterFile rf(.clock(clock), .reset(reset), .shouldWrite(rfWe), .register1Address(instr[11:8]), .register2Address(instr[3:0]), 
		.writeAddress(instr[11:8]), .writeData(regDataIn), .register1Data(r1Data), .register2Data(r2Data));
		
	//StorageRam storeRam(.data(aluOut), .addr(r2Data), .we(brWe), .clk(clock), .q(storageOut));
		
	mux2to1 pcOrReg(.in1(instMemAddr), .in2(r1Data), .select(pcRegSel), .out(rdataA));
	
	mux2to1 wbRgAlu(.in1(storageOut), .in2(aluOut), .select(wbRegAlu), .out(regDataIn));
	
	SignExtender signExt(.immediate(instr[7:0]), .extended(signExtended));
	
	ZeroExtender zeroExt(.immediate(instr[7:0]), .result(zeroExtended));
	
	mux4to1 immMux(.in1(instr[7:0]), .in2(signExtended), .in3(zeroExtended), .in4(16'b0), .select(immTypeSel), .out(immediate));
	
	mux2to1 r2OrImmediate(.in1(r2Data), .in2(immediate), .select(r2ImSel), .out(rdataB));
	
	ALUController aluCtl(.clock(clock), .reset(reset), .opcode({instMemOut[15:12], instMemOut[7:4]}), .aluOpcode(aluOp));
	
	ALU alu(.clock(clock), .reset(reset), .opcode(aluOp), .rdataA(rdataA), .rdataB(rdataB), .psrOut(flags), .result(aluOut));
	
	PSR psr(.clock(clock), .reset(reset), .enable(psrEn), .flagsIn(flags), .flagsOut(psrOut));
	
	ktane_mem memory(.data(aluOut),
	.addr(r2Data),
	.we(brWe),
	.clk(clock),
	.q(storageOut),
	.sdabutt(sdabutt),
	.sclbutt(sclbutt),
	.sda1(sda1),
	.scl1(scl1),
	.sda2(sda2),
	.scl2(scl2),
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
	.ADC_CONVST(ADC_CONVST),
	.ADC_SCK(ADC_SCK),
	.ADC_SDI(ADC_SDI),
	.ADC_SDO(ADC_SDO),
	.reset(reset)
	);
	
endmodule