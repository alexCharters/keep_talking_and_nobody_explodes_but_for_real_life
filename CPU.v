module CPU(clock, reset, sda, scl, sda2, scl2, led1, led2, button, morse_left, morse_right, morse_tx, morse_led, keypad_TL, keypad_TR, keypad_LL, keypad_LR, keypad_leds, morse_sevseg1, morse_sevseg2, timer_sevseg1, timer_sevseg2, timer_sevseg3, strike_leds, debug_leds);
	wire [15:0] instructionIn, instruction, decodedInstruction, aluOut, pcIndex, ramReadAddr, ramWriteAddr, r1Data, r2Data, regFileData, aluSrc1, aluSrc2,
    selectedImmediate, decRamWriteAddr, irVal, signExtended, zeroExtended, ramReadData;
wire [7:0] aluOpCode;
wire [3:0] registerWriteAddress;
wire psrC, psrL, psrO, psrZ, psrN, r2Im;
wire [1:0] intSel;
input clock, reset;

output [6:0] debug_leds;

input button, morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR;

output scl, scl2, morse_led;
inout sda, sda2;

output [3:0] keypad_leds;
output [2:0] led1, led2, strike_leds;

output [6:0] morse_sevseg1, morse_sevseg2, timer_sevseg1, timer_sevseg2, timer_sevseg3;

wire pcEn, pcIncSet, brWe, brRe, ramReadPCAlu, regFileWriteAluRam, rfWe, pcRegSel, pcAluSel, addrRegDecSel, aluEn, brAddrSel, irRe;
reg [4:0] psr = 5'b00000;
ProgramCounter pc(.clock(clock), .enable(pcEn), .incOrSet(pcIncSet), .newAddress(aluOut), .reset(reset), .currentInstruction(pcIndex));
mux2to1 brReadAddrSelectMux(.in1(pcIndex), .in2(aluOut), .select(ramReadPCAlu), .out(ramReadAddr));

assign debug_leds[6] = brWe;

ktane_mem memory(
   .data(aluOut),
	.write_addr(ramWriteAddr),
	.read_addr(ramReadAddr),
	.we(brWe),
	.re(brRe),
	.clk(clock),
	.q(instructionIn),
	.sda(sda),
	.scl(scl),
	.sda2(sda2),
	.scl2(scl2),
	.led1(led1),
	.led2(led2),
	.button(button),
	.morse_left(morse_left),
	.morse_right(morse_right),
	.morse_tx(morse_tx),
	.morse_led(morse_led),
	.keypad_TL(keypad_TL),
	.keypad_TR(keypad_TR),
	.keypad_LL(keypad_LL),
	.keypad_LR(keypad_LR),
	.keypad_leds(keypad_leds),
	.morse_sevseg1(morse_sevseg1),
	.morse_sevseg2(morse_sevseg2),
	.timer_sevseg1(timer_sevseg1),
	.timer_sevseg2(timer_sevseg2),
	.timer_sevseg3(timer_sevseg3),
	.strike_leds(strike_leds),
	.debug_leds(debug_leds[5:0])
	//ADC_CONVST,
	//ADC_SCK,
	//ADC_SDI,
	//ADC_SDO
	);

//BlockRam br(.data(aluOut), .read_addr(ramReadAddr), .write_addr(ramWriteAddr), .we(brWe), .re(brRe), .clk(clock), .q(instructionIn));
InstructionRegister ir(.instruction(instructionIn), .readEnabled(irRe), .out(instruction));

Decoder decoder(.inputInstruction(instructionIn), .outputInstruction(decodedInstruction));

mux2to1 ramOrAluToRf(.in1(aluOut), .in2(instructionIn), .select(regFileWriteAluRam), .out(regFileData));


RegisterFile rf(.clock(clock), .reset(reset), .shouldWrite(rfWe), .register1Address(decodedInstruction[11:8]), .register2Address(instruction[3:0]),
    .writeAddress(instruction[11:8]), .writeData(regFileData), .register1Data(r1Data), .register2Data(r2Data));

	 mux2to1 pcOrReg1Mux(.in1(pcIndex), .in2(r1Data), .select(pcRegSel), .out(aluSrc1));

SignExtender signExtender(.immediate(instruction[7:0]), .extended(signExtended));

ZeroExtender zeroExtender(.immediate(instruction[7:0]), .result(zeroExtended));

mux4to1 immediateMux(.in1({8'b0, instruction[7:0]}), .in2(signExtended), .in3(zeroExtended), .in4(16'b0), .select(intSel), .out(selectedImmediate));

mux2to1 reg2OrImmediateMux(.in1(r2Data), .in2(selectedImmediate), .select(r2Im), .out(aluSrc2));

ALUControl aluController(.instruction(decodedInstruction), .out(aluOpCode));

ALU alu(.enable(aluEn), .sourceData(aluSrc1), .destData(aluSrc2), .operationControl(aluOpCode), .carry(psrC), .low(psrL), .overflow(psrO), 
    .zero(psrZ), .negative(psrN), .result(aluOut));

	 
mux2to1 brWriteAddrMux(.in1(r2Data), .in2(decRamWriteAddr), .select(brAddrSel), .out(ramWriteAddr));


FSM fsm(.clock(clock), .reset(reset), .opcode(instruction), .psr(psr), .pcEnable(pcEn), .pcIncrementOrWrite(pcIncSet), 
    .blockRamWriteEnable(brWe), .registerFileWriteEnable(rfWe), .integerTypeSelectionLine(intSel), .reg2OrImmediateSelectionLine(r2Im), 
    .pcOrRegisterSelectionLine(pcRegSel), .addressFromRegOrDecoderSelectionLine(brAddrSel), .writeBackToRegRamOrALUSelectionLine(regFileWriteAluRam), 
    .pcOrAluOutputRamReadSelectionLine(ramReadPCAlu), 
    .decoderRamWriteAddress(decRamWriteAddr), .registerWriteAddress(registerWriteAddress), .ramReadEnable(brRe), .irReadEnable(irRe), 
    .aluEnable(aluEn), .instructionRegisterValue(irVal));
always @ (*) begin
    psr = {psrN, psrZ, psrO, psrL, psrC};
end
endmodule
