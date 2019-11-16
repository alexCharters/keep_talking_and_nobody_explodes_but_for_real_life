module FSM(clock, reset, opcode, psr, pcEnable, pcIncrementOrWrite, blockRamWriteEnable, registerFileWriteEnable, integerTypeSelectionLine, reg2OrImmediateSelectionLine, 
    pcOrRegisterSelectionLine, addressFromRegOrDecoderSelectionLine, writeBackToRegRamOrALUSelectionLine, pcOrAluOutputRamReadSelectionLine, 
    decoderRamWriteAddress, registerWriteAddress, ramReadEnable, irReadEnable, aluEnable, instructionRegisterValue);
    input clock, reset;
    input [4:0] psr;
    input [15:0] opcode; //pass the full instruction to handle addressing
    reg [2:0] nextState = 0;
    reg [2:0] currentState = 0;
    output reg [1:0] integerTypeSelectionLine;
    output reg pcIncrementOrWrite, blockRamWriteEnable, registerFileWriteEnable, reg2OrImmediateSelectionLine,
        pcOrRegisterSelectionLine, addressFromRegOrDecoderSelectionLine, writeBackToRegRamOrALUSelectionLine, pcOrAluOutputRamReadSelectionLine,
		  pcEnable, ramReadEnable, irReadEnable, aluEnable;
    output reg [15:0] decoderRamWriteAddress;
    output reg [3:0] registerWriteAddress;
    output reg [15:0] instructionRegisterValue;
    parameter IF = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010, WRITE_BACK = 3'b011, RESET = 3'b100;
    parameter EQ = 4'b0000, NE = 4'b0001, CarrySet = 4'b0010, CarryClear = 4'b0011, 
        HI = 4'b0100, LS = 4'b0101, GT = 4'b0110, LE = 4'b0111,
        FS = 4'b1000, FC = 4'b1001, LO = 4'b1010, HS = 4'b1011,
        LT = 4'b1100, GE = 4'b1101, UC = 4'b1110, NJ = 4'b1111;
    always @(posedge clock) begin
        if(reset == 1'b0)
            currentState <= IF;
        else
            currentState <= nextState;
    end
    always @ (*) begin
        aluEnable = 0;
        blockRamWriteEnable = 0;
        registerFileWriteEnable = 0;
        integerTypeSelectionLine = 0;
        reg2OrImmediateSelectionLine = 0;
        pcOrRegisterSelectionLine = 1;
        addressFromRegOrDecoderSelectionLine = 0;
        writeBackToRegRamOrALUSelectionLine = 0;
        pcOrAluOutputRamReadSelectionLine = 0;
        pcOrAluOutputRamReadSelectionLine = 0;
		  pcIncrementOrWrite = 0;
        instructionRegisterValue = 0;
        irReadEnable = 0;
        decoderRamWriteAddress = 0;
        registerWriteAddress = 0;
		  ramReadEnable = 1;
        pcEnable = 0;
        nextState = 0;
        case (currentState)
            // RESET: begin
            //     nextState <= IF;
            // end
            IF: begin
                //Tell PC to increment or set to new address
                //store read value in the IR
                pcEnable = 0; //if we enable the pc here, it will increment.
                ramReadEnable = 1;
                irReadEnable = 1;
                nextState = DECODE;
            end
            DECODE: begin
					 ramReadEnable = 1;
                //send instruction from IR to Datapath
                case (opcode[15:12]) //look at the top half of the instruction
                    4'b0000: begin //this is an RType instruction
                        //What to do here
                        nextState = EXECUTE; //nothing special needs to happen here.
                    end 
                    4'b0001: begin //ANDI
                        nextState = EXECUTE;
                    end
                    4'b0010: begin //ORI
                        nextState = EXECUTE;
                    end
                    4'b0011: begin //XORI
                        nextState = EXECUTE;
                    end
                    4'b0101: begin //ADDI
                        nextState = EXECUTE;
                    end
                    4'b0110: begin //ADDUI (not needed)
                    end
                    4'b0111: begin //ADDCI (not needed)
                    end
                    4'b1000: begin //LSH, LSHI, ASH, ASHU, ASHUI
                        nextState = EXECUTE;
                    end
                    4'b1001: begin //SUBI
                        nextState = EXECUTE;
                    end
                    4'b1010: begin //SUBCI (not needed)
                    end
                    4'b1011: begin //CMPI
                        nextState = EXECUTE;
                    end
                    4'b1100: begin //Bcond
                        nextState = EXECUTE;
                    end
                    4'b1101: begin //MOVI
                        nextState = EXECUTE;
                    end
                    4'b1110: begin //MULI (not needed)
                    end
                    4'b1111: begin //LUI
                        nextState = EXECUTE;
                    end
                    4'b0100: begin
                        nextState = EXECUTE;
                    end
                    default: nextState = IF;
                endcase
                nextState = EXECUTE;
            end 
            EXECUTE: begin
                // do computation
                aluEnable = 1;
                nextState = WRITE_BACK;
                case (opcode[15:12])
                    4'b0000: begin //RType
                        pcOrRegisterSelectionLine = 1;
                        reg2OrImmediateSelectionLine = 0;
                        registerFileWriteEnable = 0;
                        //ALU control will select the instruction for the ALU to run, we just need to make sure to provide the sources.
                        registerWriteAddress = opcode[11:8];
                        if(opcode[7:4] == 4'b1011) begin
                            pcEnable = 1;
                            nextState = IF;
                        end
                        else
                            nextState = WRITE_BACK; //We are done with the RType instruction. Write the result
                    end
                    4'b0001: begin //ANDI
                        pcOrRegisterSelectionLine = 1;
                        reg2OrImmediateSelectionLine = 1;
                        integerTypeSelectionLine = 2;
                        nextState = WRITE_BACK;
                    end 
                    4'b0010: begin //ORI
                        pcOrRegisterSelectionLine = 1;
                        reg2OrImmediateSelectionLine = 1;
                        integerTypeSelectionLine = 2;
                        nextState = WRITE_BACK;
                    end 
                    4'b0011: begin //XORI
                        pcOrRegisterSelectionLine = 1;
                        reg2OrImmediateSelectionLine = 1;
                        integerTypeSelectionLine = 2;
                        nextState = WRITE_BACK;
                    end 
                    4'b1101: begin //MOVI
                        pcOrRegisterSelectionLine = 1;
                        reg2OrImmediateSelectionLine = 1;
                        integerTypeSelectionLine = 2'b10;
                        nextState = WRITE_BACK;
                    end
                    4'b0101: begin //ADDI
                        pcOrRegisterSelectionLine = 1;
                        reg2OrImmediateSelectionLine = 1; //FIXME
                        integerTypeSelectionLine = 1;
                        nextState = WRITE_BACK;
                    end
                    4'b1001: begin //SUBI
                        pcOrRegisterSelectionLine = 1;
                        reg2OrImmediateSelectionLine = 1;
                        integerTypeSelectionLine = 1;
                        nextState = WRITE_BACK;
                    end
                    4'b1011: begin //CMPI
                        pcOrRegisterSelectionLine = 1;
                        reg2OrImmediateSelectionLine = 1;
                        integerTypeSelectionLine = 1;
                        pcEnable = 1;
                        nextState = IF; //CMPs do not write back to regfile
                    end
                    4'b1111: begin //LUI
                        pcOrRegisterSelectionLine = 1;
                        reg2OrImmediateSelectionLine = 1;
                        integerTypeSelectionLine = 0;
                        //Decoder needs to handle the loading of r0
                        nextState = WRITE_BACK;
                    end
                    4'b1000: begin
                        case(opcode[7:4])
                            4'b0100: begin 
                                pcOrRegisterSelectionLine = 1;
                                reg2OrImmediateSelectionLine = 0;
                                nextState = WRITE_BACK;
                            end
                            4'b0110: begin
                                pcOrRegisterSelectionLine = 1;
                                reg2OrImmediateSelectionLine = 0;
                                nextState = WRITE_BACK;
                            end
                            default: begin
                                pcOrRegisterSelectionLine = 1;
                                reg2OrImmediateSelectionLine = 1;
                                integerTypeSelectionLine = 0;
                            end

                        endcase
                    end
                    4'b0100: begin
                        case(opcode[7:4])
                            4'b1100: begin //Jcond
                                pcOrRegisterSelectionLine = 1;
                                reg2OrImmediateSelectionLine = 1;
                                integerTypeSelectionLine = 3; //Hard 0
                                nextState = WRITE_BACK;
                            end
                            4'b1000: begin //JAL
                                pcOrRegisterSelectionLine = 1;
                                reg2OrImmediateSelectionLine = 1;
                                integerTypeSelectionLine = 3; //Hard 0
                                nextState = WRITE_BACK;
                            end
                            default: begin //Load and Store
                                pcOrRegisterSelectionLine = 1;
                                reg2OrImmediateSelectionLine = 1;
                                if(opcode[7:4] == 4'b0100)
                                    integerTypeSelectionLine = 3;
                                else begin
                                    integerTypeSelectionLine = 0;
                                    reg2OrImmediateSelectionLine = 0;
                                    pcOrAluOutputRamReadSelectionLine = 1;
                                    ramReadEnable = 1;
                                    writeBackToRegRamOrALUSelectionLine = 0;
                                end
                                nextState = WRITE_BACK;
                            end
                        endcase
                    end 
                    4'b1100: begin //Bcond
                        pcOrRegisterSelectionLine = 0;
                        reg2OrImmediateSelectionLine = 1;
                        integerTypeSelectionLine = 0;
                        nextState = WRITE_BACK;
                    end
						  default: nextState = IF;
                endcase
            end
            WRITE_BACK: begin
                // enable correct muxes to write values.
                pcOrAluOutputRamReadSelectionLine = 0;
                case (opcode[15:12])
                    4'b0100: begin
                        case(opcode[7:4])
                            4'b0000: begin //Load
                                $display("LOAD WB");
                                registerFileWriteEnable = 1;
                                pcOrAluOutputRamReadSelectionLine = 1; //Use the alu to load from ram.
                                writeBackToRegRamOrALUSelectionLine = 1;
                                ramReadEnable = 1;
                                pcEnable = 1;
                            end
                            4'b0100: begin //STORE
                                $display("STORE WB");
                                blockRamWriteEnable = 1;
                                addressFromRegOrDecoderSelectionLine = 0;
                                pcEnable = 1;
                            end
                            4'b1100: begin
                                //need to check condition vs psr 
                                pcIncrementOrWrite = 0; //Assume nothing passes condition check.
                            pcEnable = 1; //still need to move to next instruction
                            case(opcode[11:8])
                                EQ: begin
                                    $display("Jumping since values are equal");
                                    if(psr[3] == 1'b1) begin
                                        pcIncrementOrWrite = 1;
                                    end
                                end
                                NE: begin
                                    if(psr[3] == 1'b0)
                                        pcIncrementOrWrite = 1;
                                end
                                GE: begin
                                    if(psr[3] == 1'b1 || psr[4] == 1'b1)    
                                        pcIncrementOrWrite = 1;
                                end
                                CarrySet: begin
                                    if(psr[0] == 1'b1)
                                        pcIncrementOrWrite = 1;
                                end 
                                CarryClear: begin
                                    if(psr[0] == 1'b0)
                                        pcIncrementOrWrite = 1;
                                end
                                HI: begin
                                    if(psr[1] == 1'b1)
                                        pcIncrementOrWrite = 1;
                                end
                                LS: begin
                                    if(psr[1] == 1'b0)
                                        pcIncrementOrWrite = 1;
                                end
                                LO: begin
                                    if(psr[1] == 1'b0 && psr[3] == 1'b0)
                                        pcIncrementOrWrite = 1;
                                end
                                HS: begin
                                    if(psr[1] == 1'b1 || psr[3] == 1'b1)
                                        pcIncrementOrWrite = 1;
                                end
                                GT: begin
                                    if(psr[4] == 1'b1)
                                        pcIncrementOrWrite = 1;
                                end
                                LE: begin
                                    if(psr[4] == 1'b0)
                                        pcIncrementOrWrite = 1;
                                end
                                FS: begin
                                    if(psr[2] == 1'b1)
                                        pcIncrementOrWrite = 1;
                                end
                                FC: begin
                                    if(psr[2] == 1'b0)
                                        pcIncrementOrWrite = 1;
                                end
                                LT: begin
                                    if(psr[4] == 1'b0 && psr[3] == 1'b0)
                                        pcIncrementOrWrite = 1;
                                end
                                UC: pcIncrementOrWrite = 1;
                                NJ: pcIncrementOrWrite = 0;
                            endcase
                            end
                            4'b1000: begin //JAL
                                pcIncrementOrWrite = 1;
                            end
                            default: nextState = IF;
                        endcase
                    end
                    4'b1100: begin //Bcond
                        pcIncrementOrWrite = 0; //Assume nothing passes condition check.
                        pcEnable = 1; //still need to move to next instruction
                        case(opcode[11:8])
                            EQ: begin
                                if(psr[3] == 1'b1) begin
                                    pcIncrementOrWrite = 1;
                                end
                            end
                            NE: begin
                                if(psr[3] == 1'b0)
                                    pcIncrementOrWrite = 1;
                            end
                            GE: begin
                                if(psr[3] == 1'b1 || psr[4] == 1'b1)    
                                    pcIncrementOrWrite = 1;
                            end
                            CarrySet: begin
                                if(psr[0] == 1'b1)
                                    pcIncrementOrWrite = 1;
                            end 
                            CarryClear: begin
                                if(psr[0] == 1'b0)
                                    pcIncrementOrWrite = 1;
                            end
                            HI: begin
                                if(psr[1] == 1'b1)
                                    pcIncrementOrWrite = 1;
                            end
                            LS: begin
                                if(psr[1] == 1'b0)
                                    pcIncrementOrWrite = 1;
                            end
                            LO: begin
                                if(psr[1] == 1'b0 && psr[3] == 1'b0)
                                    pcIncrementOrWrite = 1;
                            end
                            HS: begin
                                if(psr[1] == 1'b1 || psr[3] == 1'b1)
                                    pcIncrementOrWrite = 1;
                            end
                            GT: begin
                                if(psr[4] == 1'b1)
                                    pcIncrementOrWrite = 1;
                            end
                            LE: begin
                                if(psr[4] == 1'b0)
                                    pcIncrementOrWrite = 1;
                            end
                            FS: begin
                                if(psr[2] == 1'b1)
                                    pcIncrementOrWrite = 1;
                            end
                            FC: begin
                                if(psr[2] == 1'b0)
                                    pcIncrementOrWrite = 1;
                            end
                            LT: begin
                                if(psr[4] == 1'b0 && psr[3] == 1'b0)
                                    pcIncrementOrWrite = 1;
                            end
                            UC: pcIncrementOrWrite = 1;
                            NJ: pcIncrementOrWrite = 0;
                        endcase
                    end
                    default: begin //Most instructions use the same logic to write
                        registerFileWriteEnable = 1;
                        $display("Here");
                        registerWriteAddress = opcode[11:8];
                        nextState = IF;
                        pcIncrementOrWrite = 0;
                        pcEnable = 1;
                        writeBackToRegRamOrALUSelectionLine = 0; //write from ALU
                    end
                endcase
                nextState = IF;
            end
            default: begin
                nextState = IF;
                instructionRegisterValue = 0;
            end 
        endcase
    end
endmodule