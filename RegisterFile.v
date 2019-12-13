/*
	Creates the processor registers.
	There are 16 registers, each being 16 bits wide.
	In practice, registers 14 and 15 should not be accessed by
	the program unless jumps or jals occur.
	Register 0 can be written to, but will always give a value of 0 back.
*/
module RegisterFile
	#(parameter WIDTH = 16, REGISTER_BITS = 4)
	(clock, reset, shouldWrite, register1Address, register2Address, writeAddress, writeData, register1Data, register2Data);
	input clock, reset, shouldWrite;
	input [(WIDTH - 1) : 0] writeData;
	input [(REGISTER_BITS - 1) : 0] register1Address, register2Address, writeAddress;
	//This is setup so if we want to use slightly larger values we can 
	reg [(WIDTH-1):0] DataBlock [(1 << REGISTER_BITS) - 1: 0];
	output [(WIDTH-1) : 0] register1Data, register2Data;
	//Set the regfile to respond to pos clock edge for handling read and writes
	always @ (posedge clock) begin
		if(reset == 0) begin
			DataBlock[0] = 0;
		end

		if(shouldWrite) begin
				if(writeAddress != 0)
					DataBlock[writeAddress] <= writeData;
			end
	end
	/* 
		if either address requests for register 0, we simply put a zero back on the line.
		Otherwise, fetch the data from the DataBlock and put that value on the respective output
	*/
	assign register1Data = (register1Address == 4'b0000 ? 16'b0 : DataBlock[register1Address]);
	assign register2Data = (register2Address == 4'b0000 ? 16'b0 : DataBlock[register2Address]);
endmodule