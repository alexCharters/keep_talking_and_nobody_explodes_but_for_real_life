//ALU for project. Right now, everything expects 16 bit values
module ALU
	#(parameter WIDTH = 16, ctlLen = 8)
	(enable, sourceData, destData, operationControl, carry, low, overflow, zero, negative, result);
		input [(WIDTH - 1) : 0] sourceData, destData;
		input [(ctlLen - 1) : 0] operationControl;
		input enable;
		//Series of valid operation higher order bits (7:4)
		parameter RTYPE = 4'b0000, ADDI = 4'b0101, ADDUI = 4'b0110, SUBI = 4'b1001, SUBCI = 4'b1010,
		CMPI = 4'b1011, ANDI = 4'b0001, ORI = 4'b0010, XORI = 4'b0011, MOVI = 4'b1101, LUI = 4'b1111,
		BCOND = 4'b1100, SHIFT = 4'b1000, MEMANDJMP = 4'b0100;
		//Series of operation's lower 4 bits so I don't have to continually consult the ISA
		parameter ADD = 4'b0101, ADDU = 4'b0110, ADDC = 4'b0111, MUL = 4'b1110, SUB = 4'b1001,
			SUBC = 4'b1010, CMP = 4'b1011, AND = 4'b0001, OR = 4'b0010, XOR = 4'b0011, MOV = 4'b1101,
			LSH = 4'b0100, LSHIPOS = 4'b0000, LSHINEG = 4'b0001, ASHU = 4'b0110, ASHUIPOS = 4'b0010, 
			ASHUINEG = 4'b0011, LOAD = 4'b0000, STORE = 4'b0100, SCOND = 4'b1101, JCOND = 4'b1100, 
			JAL = 4'b1000;
		//Custom Instructions
		parameter STORI = 8'b10000101;
		//Wire to hold addition and subtraction results that allows for simple checking of carry
		reg [(WIDTH) : 0] resWire;
		//These represent the different conditions we need to report back after computation.
		output reg carry, low, overflow, zero, negative;
		output reg [(WIDTH - 1): 0] result;
		//Next, grab the requested operation from the control line (high bits first for determining op)
		always@(*) begin

		carry = 0;
		low = 0; 
		overflow = 0;
		zero = 0;
		negative = 0;
		case(operationControl[7:4])
			RTYPE: begin //RTYPE instruction
					case(operationControl[3:0])
						ADD: begin //ADD
							resWire = sourceData + destData;
							carry = resWire[WIDTH];
							low = 0;
							zero = 0;
							if (sourceData < 0 && destData < 0)
								negative = 1;
							else if(destData < 0 && (-1 * destData) > sourceData)
								negative = 1;
							else if (sourceData < 0 && (-1 * sourceData) > destData)
								negative = 1;
							else
								negative = 0;
							if(sourceData[(WIDTH-1)] == destData[(WIDTH-1)] && resWire[WIDTH- 1] != sourceData[WIDTH-1])
								overflow = 1;
							else
								overflow = 0;
						end
						ADDC: begin //ADDC
							resWire = sourceData + destData + carry;
							carry = resWire[WIDTH];
							low = 0;
							zero = 0;
							negative = 0;
						end
						ADDU: begin
							resWire = sourceData + destData;
							carry = resWire[WIDTH];
							low = 0;
							zero = 0;
							negative = 0;
						end
						MUL: begin //MUL
							resWire = sourceData * destData;
							carry = 0;
							low = 0;
							zero = 0;
							negative = (sourceData < 0 && destData > 0) || (sourceData > 0 && destData < 0);
						end
						SUB: begin //SUB
							resWire = destData - sourceData;
							carry = resWire[WIDTH];
							low = 0;
							zero = 0;
							negative = destData < sourceData;
							if(sourceData[WIDTH-1] != destData[WIDTH-1]) begin
								if(sourceData > destData && carry == destData[WIDTH-1])
									overflow = 1;
								else if(destData > sourceData && carry == sourceData[WIDTH-1])
									overflow = 1;
								else
									overflow = 0;
							end
						end
						SUBC: begin //SUBC
							//TODO
							resWire = destData - sourceData - carry;
							negative = destData < (sourceData - carry);
							carry = resWire[WIDTH];
							low = 0;
							zero = 0;
						end
						CMP: begin //CMP
							resWire = 0;
							carry = 0;
							low = sourceData > destData;
							negative = destData < sourceData;
							zero = (sourceData - destData) == 0 ? 1'b1 : 1'b0;
							
						end
						AND: begin //AND
							resWire = sourceData & destData;
							carry = 0;
							low = 0;
							zero = 0;
							negative = 0;
						end
						OR: begin //OR
							resWire = sourceData | destData;
							carry = 0;
							low = 0;
							zero = 0;
							negative = 0;
						end
						XOR: begin //XOR
							resWire = sourceData ^ destData;
							carry = 0;
							low = 0;
							zero = 0;
							negative = 0;
						end
						MOV: begin //MOV HANDLE THIS IN THE CONTROLLER!
							resWire = destData;
							carry = 0;
							low = 0;
							zero = 0;
							negative = 0;
						end
						default: begin
							carry = 0;
							low = 0;
							overflow = 0;
							zero = 0;
							negative = 0;
							resWire = 0;
						end
					endcase
				end
			4'b1000: begin //SHIFT
				case(operationControl[3:0])
					LSH: begin
						resWire = sourceData << destData;
					end
					LSHIPOS: begin
						resWire = sourceData << 1;
					end
					LSHINEG: begin
						$display("NEG");
						resWire = sourceData >> 1;
					end
					ASHU: begin
					$display("ASHU");
						resWire = sourceData <<< destData;
					end
					ASHUIPOS: begin
						resWire = sourceData <<< 1;
					end
					ASHUINEG: begin
						resWire = sourceData >>> 1;
					end
					default: begin
						carry = 0;
						low = 0;
						overflow = 0;
						zero = 0;
						negative = 0;
						resWire = 0;
					end
				endcase
			end
			MEMANDJMP: begin
				case(operationControl[3:0])
					LOAD: begin
						$display("ALU LOAD HIT");
						resWire = destData;
					end
					STORE: begin
						resWire = destData;
					end
					default: begin
						carry = 0;
						low = 0;
						overflow = 0;
						zero = 0;
						negative = 0;
						result = 0;
					end
				endcase
			end
			ADDI: begin
				resWire = sourceData + destData;
				carry = resWire[WIDTH];
				low = 0;
				zero = 0;
				negative = resWire[WIDTH-1:0] > 16'b0111111111111101;
				if(sourceData[(WIDTH-1)] == destData[(WIDTH-1)] && resWire[WIDTH- 1] != sourceData[WIDTH-1])
					overflow = 1;
				else
					overflow = 0;
				end
			
			ADDUI: begin
				resWire = sourceData + destData;
				carry = resWire[WIDTH];
				low = 0;
				overflow = 0;
				zero = 0;
				negative = 0;
			end
			SUBI: begin
				resWire = sourceData - destData;
				if(destData[WIDTH-1] == sourceData[WIDTH-1])
					carry = sourceData > destData;
				low = 0;
				overflow = 0;
				zero = 0;
				if(sourceData[WIDTH-1] == 1'b1 && destData[WIDTH-1] == 1'b1)
					if(destData < sourceData)
						negative = 1;
					else
						negative = 0;
				else if(sourceData[WIDTH-1] == 1'b0 && destData[WIDTH-1] == 1'b1)
					negative = 1;
				else if(sourceData[WIDTH-1] == 1'b1 && destData[WIDTH-1] == 1'b0)
					negative = 0;
				else
					if(sourceData > destData)
						negative = 1;
					else
						negative = 0;
			end
//			SUBCI: begin Lets see if we all want this first.
//				resWire = destData - sourceData - carry;
//				carry = 0;
//				low = 0;
//				overflow = 0;
//				zero = 0;
//				negative = 0; //TODO fix this
//			end
			CMPI: begin
				$display("COMPARING INTEGERS!");
				resWire = 0;
				carry = 0;
				low = sourceData > destData;
				overflow = 0;
				zero = (destData - sourceData) == 0;
				negative = destData < sourceData;
			end
			ANDI: begin
				$display("ANDING!");
				resWire = destData & sourceData;
				carry = 0;
				low = 0;
				overflow = 0;
				zero = 0;
				negative = 0;
			end
			ORI: begin
				resWire = destData | sourceData;
				carry = 0;
				low = 0;
				overflow = 0;
				zero = 0;
				negative = 0;
			end
			XORI: begin
				resWire = destData ^ sourceData;
				carry = 0;
				low = 0;
				overflow = 0;
				zero = 0;
				negative = 0;
			end
			MOVI: begin
				resWire = destData;
				carry = 0;
				low = 0;
				overflow = 0;
				zero = 0;
				negative = 0;
			end
			LUI: begin
				resWire = {1'b0, destData, 8'b0};
				carry = 0;
				low = 0;
				overflow = 0;
				zero = 0;
				negative = 0;
			end
//			BCOND: begin Handle in controller
			
//			end
			STORI[7:4]: begin
				resWire = sourceData; //Move the source (an immediate) out of the ALU for a store into a specific address in memory.
				carry = 0;
				low = 0;
				overflow = 0;
				zero = 0;
				negative = 0;
			end
			default: begin
				//NOT TODAY, LATCHES.
				carry = 0;
				low = 0;
				overflow = 0;
				zero = 0;
				negative = 0;
				resWire = 0;
			end
		endcase
		if(enable)
			result = resWire[(WIDTH - 1): 0];
		end
endmodule
