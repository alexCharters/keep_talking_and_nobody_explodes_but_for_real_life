module CPU(clock, reset);
	input clock, reset;
    reg [15:0] jalRegister;
    reg [4:0] PSR;
    wire [4:0] psrFlagLine;
    wire pcIncOrSet, brWe, rfWe, r2Im, pcRegSel, addrRegDecSel, wbRegRam, pcAluout, brRe, irRe, pcEn;
    wire [15:0] newPCAddress;
    wire [15:0] decRamAddr;
    wire [15:0] instruction, jalAddrLine;
    wire [7:0] outputInstruction;
    wire [15:0] irVal;
    wire [3:0] registerWriteAddress;
    wire [15:0] ramReadAddress, ramWriteAddr, ramWriteData;
    wire [1:0] intSel;
    wire [1:0] currentState;
	assign jalAddrLine = jalRegister;
    assign psrFlagLine = PSR;
	FSM fsm(.clock(clock), .reset(reset), .opcode(instruction), .psr(psrFlagLine), .pcEnable(pcEn), .pcIncrementOrWrite(pcIncOrSet), .blockRamWriteEnable(brWe), 
    .registerFileWriteEnable(rfWe), .integerTypeSelectionLine(intSel), .reg2OrImmediateSelectionLine(r2Im), 
    .pcOrRegisterSelectionLine(pcRegSel), .addressFromRegOrDecoderSelectionLine(addrRegDecSel), .writeBackToRegRamOrALUSelectionLine(wbRegRam), 
    .pcOrAluOutputRamReadSelectionLine(pcAluout), 
    .decoderRamWriteAddress(decRamAddr), .registerWriteAddress(registerWriteAddress), .ramReadEnable(brRe), .irReadEnable(irRe), 
    .instructionRegisterValue(irVal));
    ProgramCounter pc(.clock(clock), .reset(reset), .incOrSet(pcIncOrSet), .enable(pcEn), .newAddress(newPCAddress), .currentInstruction(ramReadAddress));
    BlockRam br(.data(ramWriteData), .read_addr(ramReadAddress), .write_addr(ramWriteAddr), .re(brRe), .we(brWe), .clk(clock), .q(instruction));
    Datapath dp(.clock(clock), .reset(reset), .instruction(instruction), .blockRamWriteEnable(brWe), .registerFileWriteEnable(rfWe), 
    .integerTypeSelectionLine(intSel), .reg2OrImmediateSelectionLine(r2Im), 
	.pcOrRegisterSelectionLine(pcRegSel), .addressFromRegOrDecoderSelectionLine(addrRegDecSel), .writeBackToRegRamOrALUSelectionLine(wbRegRam), 
    .pcOrAluOutputRamReadSelectionLine(pcAluout), 
	.decoderRamWriteAddress(decRamAddr), .registerWriteAddress(registerWriteAddress));

endmodule