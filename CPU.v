module CPU(clock, reset);
	 input clock, reset;
    reg [15:0] jalRegister;
    reg [4:0] PSR;
    wire pcIncOrSet, brWe, rfWe, r2Im, pcRegSel, addrRegDecSel, wbRegRam, pcAluout;
    wire [15:0] newPCAddress;
    wire [15:0] instruction, outputInstruction, decRamAddr, jalAddrLine;
    wire [3:0] registerWriteAddress;
    wire [1:0] intSel;
	 assign jalAddrLine = jalRegister;
    ProgramCounter PC(.clock(clock), .incOrSet(pcIncOrSet), .newAddress(newPCAddress), .reset(reset), .currentInstruction(instruction));
    Decoder decoder(.instruction(instruction), .PSR(PSR), .pcIncrementOrWrite(pcIncOrSet), .blockRamWriteEnable(brWe), .registerFileWriteEnable(rfWe),
    .integerTypeSelectionLine(intSel), .reg2OrImmediateSelectionLine(r2Im), .pcOrRegisterSelectionLine(pcRegSel), 
    .addressFromRegOrDecoderSelectionLine(addrRegDecSel), 
    .writeBackToRegRamOrALUSelectionLine(wbRegRam), .pcOrAluOutputRamReadSelectionLine(pcAluOut), 
    .decoderRamWriteAddress(decRamAddr), .registerWriteAddress(regWriteAddr), .instructionOut(outputInstruction), .jalRegisterVal(jalAddrLine));
    Datapath dataPath(.clock(clock), .reset(reset), .instruction(outputInstruction), .blockRamWriteEnable(brWe), .registerFileWriteEnable(rfWe), 
    .integerTypeSelectionLine(intSel), .reg2OrImmediateSelectionLine(r2Im), .pcOrRegisterSelectionLine(pcRegSel), 
    .addressFromRegOrDecoderSelectionLine(addrRegDecSel), .writeBackToRegRamOrALUSelectionLine(wbRegRam), .pcOrAluOutputRamReadSelectionLine(pcAluOut), 
    .decoderRamWriteAddress(decRamAddr), .registerWriteAddress(regWriteAddr));
endmodule