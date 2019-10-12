module Datapath(clock, reset);
	wire [15:0] ramDataInput, ramOutput, ramReadAddr, ramWriteAddr, newPCAddr, currentPCVal, dataline, register1Data, register2Data, aluResult;
	wire ramWriteEnable, clockSignalLine, pcIncrementOrSet, writeToRegOrRam, shftOrNorm, regOrImmediate;
	reg [15:0] instructionRegister;
	reg [15:0] jalLinkedReg; //holds the address to return to after a jal. Need to decide how much depth to allow.
	reg [7:0] immediateRegister, signExtendedImmediate, zeroExtendedImmediate;
	reg [4:0] psrRegister; //holds PSR flags
	//Create the program counter
	ProgramCounter PC(pcIncrementOrSet, newPCAddr, currentPCVal);

	//need to assign instruction register here. Read from block ram using PC and get next instruction. 

	//Since block ram is a critical component for load, stores, and getting instructions, lets make sure to set it up.
	BlockRam br(.data(ramDataInput), .read_addr(ramReadAddr), .write_addr(ramWriteAddr),
		.we(ramWriteEnable), .clk(clockSignalLine), .q(ramOutput));
	//Create the register file. Register 1 is the RSrc while Register 2 is the Rdest from the ISA
	RegisterFile regFile(.clock(clock), .shouldWrite(writeToRegOrRam), .register1Address(instructionRegister[3:0]), .register2Address(instructionRegister[11:8]), .writeAddress(instructionRegister[11:8]), .writeData(dataline), .register1Data(register1Data), .register2Data(register2Data));
	//Create needed sign and zero extenders
	SignExtender sExtend(.immediate(immediateRegister), .extended(signExtendedImmediate));
	ZeroExtender zExtend(.immediate(immediateRegister), .result(zeroExtendedImmediate));
	//ALU and its needed controller
	ALU alu(.sourceData(register1Data), .destData(register2Data), .operationControl(), .carry(), .low(), .overflow(), .zero(), .negative(), .result(aluResult));
	ALUControl aluCntl(.instruction(), .shftOrNormMuxEnable(), .regSrcSelect(), .regDestSelect(), .regOrImmediateMuxEnable(), .immediateSignZeroMuxEnable(), .aluOrOtherMuxEnable(), .ramOrRegDestMuxEnable());
endmodule
