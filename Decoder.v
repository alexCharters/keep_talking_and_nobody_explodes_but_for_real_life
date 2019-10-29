// module Decoder(instruction, PSR, pcIncrementOrWrite, blockRamWriteEnable, registerFileWriteEnable, integerTypeSelectionLine, reg2OrImmediateSelectionLine, 
//     pcOrRegisterSelectionLine, addressFromRegOrDecoderSelectionLine, writeBackToRegRamOrALUSelectionLine, pcOrAluOutputRamReadSelectionLine, 
//     decoderRamWriteAddress, registerWriteAddress, instructionOut, jalRegisterVal);
//     input [15:0] instruction;
//     input [4:0] PSR; //holds the five psr flags we need. Neg, Zero, Flag, Less, Carry
//     parameter NegativeFlag = 4, ZeroFlag = 3, FlagSetFlag = 2, LowFlag = 1, CarryFlag = 0;
// 	output reg [1:0] integerTypeSelectionLine;
//     output reg blockRamWriteEnable, registerFileWriteEnable, reg2OrImmediateSelectionLine, pcOrRegisterSelectionLine, 
//         addressFromRegOrDecoderSelectionLine, writeBackToRegRamOrALUSelectionLine, pcOrAluOutputRamReadSelectionLine,
// 		  pcIncrementOrWrite;
//     output reg [15:0] decoderRamWriteAddress, instructionOut, jalRegisterVal;
// 	output reg [3:0] registerWriteAddress;
//     parameter Enable = 1'b1, Disable = 1'b0;
//     parameter Immediate = 0, SignExtend = 1, ZeroExtend = 2, Zero = 3;
//     parameter Eq = 4'b0000, Neq = 4'b0001, Geq = 4'b1101, CarrySet = 4'b0010, CarryClear = 4'b0011, HigherThan = 4'b0100,
//         LowerOrSame = 4'b0101, Lo = 4'b1010, HigherOrSame = 4'b1011, GreaterThan = 4'b0110, Leq = 4'b0111, Fset = 4'b1000, 
//         Fclear = 4'b1001, LessThan = 4'b1100, Unconditional = 4'b1110, NoJump = 4'b1111;
//     parameter NOP = 16'b0000000000100000; //NOP since or 0 0 into r0 will do nothing.
//     always @ (*) begin
//         decoderRamWriteAddress = 8'b0; //by default we don't need to specify the write location unless this is a store.
//         instructionOut = instruction; //shouldn't be needed to change instruction in most case.
//         //disable all enable lines
//         blockRamWriteEnable = Disable;
//         registerFileWriteEnable = Disable;
//         pcIncrementOrWrite = Disable; //Disable is increment
//         //by default, set all control lines to most likely value for muxes
//         addressFromRegOrDecoderSelectionLine = 0;
//         integerTypeSelectionLine = 0;
//         pcOrAluOutputRamReadSelectionLine = 1;
//         pcOrRegisterSelectionLine = 1;
//         reg2OrImmediateSelectionLine = 0;
//         jalRegisterVal = 0; //this should only be used to store JAL values. As such, it doesn't really matter what this is right now.
//         case(instruction[15:12])
//             4'b0000: begin //RType
//                 //Since this is an RType, we will always use r1 and r2 for values
//                 pcOrRegisterSelectionLine = 1; //use r1data
//                 reg2OrImmediateSelectionLine = 0; //use r2data
//                 registerFileWriteEnable = Enable; // we need to write the result back into the reg file
//                 writeBackToRegRamOrALUSelectionLine = 1; //write back to the register file using data in the ALU
//                 registerWriteAddress =  instruction[11:8]; //use instruction[11:8] as write back address for reg file
//                 if(instruction[7:4] == 4'b1011)
//                     registerFileWriteEnable = 0; //This is a compare so data should only be written to the PSR.
//                 //As there is no need to modify the instruction, we can simply stop here.
//             end
//             4'b1000: begin
//                 if(instruction[7:4] == 4'b0100) begin //LSH
//                     pcOrRegisterSelectionLine = 1; //use r1data
//                     reg2OrImmediateSelectionLine = 0; //use r2data
//                     registerFileWriteEnable = Enable; // we need to write the result back into the reg file
//                     writeBackToRegRamOrALUSelectionLine = 1; //write back to the register file using data in the ALU
//                     registerWriteAddress =  instruction[11:8]; //use instruction[11:8] as write back address for reg file
//                 end
//                 else begin //LSHI
//                     pcOrRegisterSelectionLine = 1;
//                     reg2OrImmediateSelectionLine = 1;
//                     integerTypeSelectionLine = Immediate;
//                     registerFileWriteEnable = 1;
//                     registerWriteAddress = instruction[11:8];
//                 end
//             end
//             4'b0101: begin //ADDI
//                 pcOrRegisterSelectionLine = 1;
//                 reg2OrImmediateSelectionLine = 1;
//                 registerFileWriteEnable = Enable;
//                 writeBackToRegRamOrALUSelectionLine = 1;
//                 registerWriteAddress = instruction[11:8];
//                 integerTypeSelectionLine = SignExtend;
//                 //ALU can handle ADDI so stop here
//             end
//             4'b0110: begin //ADDUI
//                 pcOrRegisterSelectionLine = 1;
//                 reg2OrImmediateSelectionLine = 1;
//                 registerFileWriteEnable = Enable;
//                 writeBackToRegRamOrALUSelectionLine = 1;
//                 registerWriteAddress = instruction[11:8];
//                 integerTypeSelectionLine = SignExtend;
//             end
//             4'b1001: begin //SUBI
//                 pcOrRegisterSelectionLine = 1;
//                 reg2OrImmediateSelectionLine = 1;
//                 registerFileWriteEnable = Enable;
//                 writeBackToRegRamOrALUSelectionLine = 1;
//                 registerWriteAddress = instruction[11:8];
//                 integerTypeSelectionLine = SignExtend;
//             end
//             4'b1011: begin //CMPI
//                 pcOrRegisterSelectionLine = 1;
//                 reg2OrImmediateSelectionLine = 1;
//                 integerTypeSelectionLine = SignExtend; //need sign extended immediate
//                 registerFileWriteEnable = Disable; //CMPI should only write to the PSR
//                 //Since register write is disabled, we can stop here.
//             end
//             4'b0001: begin //ANDI
//                 //because the alu just ands instruction[11:8] with the immediate, 
//                 pcOrRegisterSelectionLine = 1;
//                 reg2OrImmediateSelectionLine = 1;
//                 integerTypeSelectionLine = ZeroExtend;
//                 registerFileWriteEnable = Enable;
//                 registerWriteAddress = instruction[11:8]; 
//             end
//             4'b0010: begin //ORI
//                 pcOrRegisterSelectionLine = 1;
//                 reg2OrImmediateSelectionLine = 1;
//                 integerTypeSelectionLine = ZeroExtend;
//                 registerFileWriteEnable = Enable;
//                 registerWriteAddress = instruction[11:8]; 
//             end
//             4'b0011: begin //XORI
//                 pcOrRegisterSelectionLine = 1;
//                 reg2OrImmediateSelectionLine = 1;
//                 integerTypeSelectionLine = ZeroExtend;
//                 registerFileWriteEnable = Enable;
//                 registerWriteAddress = instruction[11:8]; 
//             end
// 	        4'b1101: begin //MOVI
// 		        pcOrRegisterSelectionLine = 1;
// 		        reg2OrImmediateSelectionLine = 1;
// 		        integerTypeSelectionLine = ZeroExtend;
// 		        registerFileWriteEnable = 1;
// 		        registerWriteAddress = instruction[11:8];
// 	        end
//             4'b1111: begin //LUI
//                 pcOrRegisterSelectionLine = 1;
//                 reg2OrImmediateSelectionLine = 1;
//                 integerTypeSelectionLine = Immediate;
//                 registerFileWriteEnable = 1;
//                 registerWriteAddress = instruction[11:8];
//             end
//             4'b0100: begin //Several cases here for load, store jumps
//                 case(instruction[7:4])
//                     4'b0000: begin //Load
//                         pcOrRegisterSelectionLine = 1;
//                         reg2OrImmediateSelectionLine = 1; //Zero to add to address
//                         integerTypeSelectionLine = Zero;
//                         registerFileWriteEnable = Enable;
//                         registerWriteAddress = instruction[11:8];
//                         writeBackToRegRamOrALUSelectionLine = 0; //use the value from RAM
//                         pcOrAluOutputRamReadSelectionLine = 1; //Read from the value computed by the ALU
//                         instructionOut = {1'b0, 1'b0, 1'b0, 1'b0, instruction[11:8], 1'b0, 1'b1, 1'b1, 1'b0, instruction[3:0]}; //change the op to an ADDU
//                     end
//                     4'b0100: begin //STORE
//                         pcOrRegisterSelectionLine = 1;
//                         reg2OrImmediateSelectionLine = 0;
//                         registerFileWriteEnable = Disable;
//                         blockRamWriteEnable = 1;
//                         addressFromRegOrDecoderSelectionLine = 0; //get the address from the provided register
//                         instructionOut = {1'b0, 1'b0, 1'b0, 1'b0, instruction[3:0], 1'b0, 1'b1, 1'b1, 1'b0, instruction[11:8]};
//                     end
//                     4'b1000: begin //JAL
//                         pcOrRegisterSelectionLine = 1; 
//                         reg2OrImmediateSelectionLine = 1;
//                         integerTypeSelectionLine = Zero;
//                         jalRegisterVal = instruction[11:8]; //we need to send this register to the JAL register so it can read the values.
//                         blockRamWriteEnable = 0;
//                         pcIncrementOrWrite = 1;
//                         instructionOut = {1'b0, 1'b0, 1'b0, 1'b0, 4'b0000, 1'b0, 1'b1, 1'b1, 1'b0, instruction[3:0]};
//                     end
//                     4'b1100: begin //JCond
//                         //Here, we need to handle each individual condition possibility
//                         case(instruction[11:8])
//                             Eq: begin
//                                 if(PSR[ZeroFlag] == 1'b1) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             Neq: begin
//                                 if(PSR[ZeroFlag] == 1'b0) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             GreaterThan: begin
//                                 if(PSR[NegativeFlag] == 1'b1) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             Geq: begin
//                                 if(PSR[NegativeFlag] == 1'b1 || PSR[ZeroFlag] == 1'b1) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             LessThan: begin
//                                 if(PSR[NegativeFlag] == 1'b0 && PSR[ZeroFlag] == 1'b0) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             Leq: begin
//                                 if(PSR[NegativeFlag] == 1'b0) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             CarrySet: begin
//                                 if(PSR[0] == 1'b1) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             CarryClear: begin
//                                 if(PSR[0] == 1'b0) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             HigherOrSame: begin
//                                 if(PSR[LowFlag] == 1'b1 || PSR[ZeroFlag] == 1'b1) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             HigherThan: begin
//                                 if(PSR[LowFlag] == 1'b1) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             LowerOrSame: begin
//                                 if(PSR[LowFlag] == 1'b0) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             Lo: begin
//                                 if(PSR[LowFlag] == 1'b0 && PSR[ZeroFlag] == 1'b0) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             Fset: begin
//                                 if(PSR[FlagSetFlag] == 1'b1) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             Fclear: begin
//                                 if(PSR[FlagSetFlag] == 1'b0) begin
//                                     pcOrRegisterSelectionLine = 1;
//                                     reg2OrImmediateSelectionLine = 1;
//                                     integerTypeSelectionLine = Zero;
//                                     blockRamWriteEnable = 0;
//                                     registerFileWriteEnable = 0;
//                                     pcIncrementOrWrite = 1;
//                                     instructionOut = {12'b000000000110, instruction[3:0]};
//                                 end
//                                 else
//                                     instructionOut = NOP;
//                             end
//                             Unconditional: begin
//                                 pcOrRegisterSelectionLine = 1;
//                                 reg2OrImmediateSelectionLine = 1;
//                                 integerTypeSelectionLine = Zero;
//                                 blockRamWriteEnable = 0;
//                                 registerFileWriteEnable = 0;
//                                 pcIncrementOrWrite = 1;
//                                 instructionOut = {12'b000000000110, instruction[3:0]};
//                             end
//                             default: begin //Don't jump
//                                 //Essentially a nop
//                                 instructionOut = NOP;
//                             end
//                         endcase
//                     end
//                 endcase
//             end
//             4'b1100: begin //Bcond
//                 case(instruction[11:8])
//                     Eq: begin
//                         if(PSR[ZeroFlag] == 1'b1) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     Neq: begin
//                         if(PSR[ZeroFlag] == 1'b0) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     GreaterThan: begin
//                         if(PSR[NegativeFlag] == 1'b1) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     Geq: begin
//                         if(PSR[ZeroFlag] == 1'b1 || PSR[NegativeFlag] == 1'b0) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     LessThan: begin
//                         if(PSR[NegativeFlag] == 1'b0 && PSR[ZeroFlag] == 1'b0) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     Leq: begin
//                         if(PSR[NegativeFlag] == 1'b0) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     CarrySet: begin
//                         if(PSR[CarryFlag] == 1'b1) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     CarryClear: begin
//                         if(PSR[CarryFlag] == 1'b0) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     HigherOrSame: begin
//                         if(PSR[ZeroFlag] == 1'b1 || PSR[LowFlag] == 1'b1) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     HigherThan: begin
//                         if(PSR[LowFlag] == 1'b1) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     LowerOrSame: begin
//                         if(PSR[LowFlag] == 1'b0) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     Lo: begin
//                         if(PSR[ZeroFlag] == 1'b0 && PSR[LowFlag] == 1'b0) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     Fset: begin
//                         if(PSR[FlagSetFlag] == 1'b1) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     Fclear: begin
//                         if(PSR[FlagSetFlag] == 1'b0) begin
//                             pcOrRegisterSelectionLine = 0;
//                             reg2OrImmediateSelectionLine = 1;
//                             integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                             blockRamWriteEnable = 0;
//                             registerFileWriteEnable = 0;
//                             pcIncrementOrWrite = 1;
//                             instructionOut = {8'b01010000, instruction[7:0]};
//                         end
//                         else
//                             instructionOut = NOP;
//                     end
//                     Unconditional: begin
//                         pcOrRegisterSelectionLine = 0;
//                         reg2OrImmediateSelectionLine = 1;
//                         integerTypeSelectionLine = SignExtend; //May be incorrect for the immediate type needed for branching
//                         blockRamWriteEnable = 0;
//                         registerFileWriteEnable = 0;
//                         pcIncrementOrWrite = 1;
//                         instructionOut = {8'b01010000, instruction[7:0]};
//                     end
//                     default: begin //no branch
//                         instructionOut = NOP;
//                     end
//                 endcase
//             end
//         endcase

//     end
// endmodule

module Decoder(inputInstruction, outputInstruction);
    input [15:0] inputInstruction;
    output reg [15:0] outputInstruction;
    always @ (*) begin
        case(inputInstruction[15:12])

            default: begin
                outputInstruction = inputInstruction;
            end
        endcase
        if(inputInstruction == 16'b0000000000000000)
            outputInstruction = 0000000000100000;
    end
endmodule